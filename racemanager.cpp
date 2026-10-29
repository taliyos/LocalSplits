#include "racemanager.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>
#include <QSettings>
#include <QTimer>

racemanager::racemanager(QObject *parent) : QObject{parent}
{
    m_clock.start();

    QSettings settings;
    m_serverUrl = settings.value("serverAddress", "localhost:8080").toString();

    m_socket = new QWebSocket("LocalSplits", QWebSocketProtocol::VersionLatest, this);

    connect(m_socket, &QWebSocket::connected, this, &racemanager::onConnected);
    connect(m_socket, &QWebSocket::disconnected, this, &racemanager::onDisconnected);
    connect(m_socket, &QWebSocket::textMessageReceived, this, &racemanager::onMessageReceived);
    connect(m_socket, &QWebSocket::errorOccurred, this, &racemanager::onError);

}

QString racemanager::generateRoomCode(){
    const QString chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    QString code;
    for(int i = 0; i < 6; i++){
        code += chars[QRandomGenerator::global()->bounded(chars.size())];
    }
    return code;
}

void racemanager::createRoom(){
    QString code = generateRoomCode();
    joinRoom(code);
    emit roomCodeGenerated(code);
}

void racemanager::joinRoom(const QString& roomId){
    if(m_connected){
        leaveRoom();
    }
    m_roomId = roomId;
    emit roomIdChanged();
    QString url = QString("ws://%1/race?roomId=%2").arg(m_serverUrl, roomId);
    m_socket->open(QUrl(url));
    qDebug() << "Connecting to room:" << roomId;
}

void racemanager::leaveRoom() {
    m_socket->close();
    m_roomId.clear();
    emit roomIdChanged();
}

void racemanager::requestStart(){
    sendMessage({{"event", "requestStart"}});
}

void racemanager::requestPause(){
    sendMessage({{"event", "requestPause"}});
}

void racemanager::requestResume(){
    sendMessage({{"event", "requestResume"}});
}

void racemanager::handleStart(const QJsonObject& data){
    qint64 startAt = data["startAt"].toInteger();
    if(startAt == m_lastStartAt) return;
    m_lastStartAt = startAt;

    qint64 localStart = startAt - m_clockOffset;
    qint64 delayMs = localStart - m_clock.elapsed();
    qDebug() << "Race starts in " << delayMs << "ms";
    emit raceStartScheduled(delayMs);
}

void racemanager::sendSplit(int splitIndex, const QString& splitTime){
    sendMessage({
        {"event", "split"},
        {"runner", m_username},
        {"splitIndex", splitIndex},
        {"splitTime", splitTime}
    });
}

void racemanager::sendReset(){
    sendMessage({
        {"event", "reset"},
        {"runner", m_username}
    });
}

void racemanager::sendRunEnded(const QString& finalTime){
    sendMessage({
        {"event", "runEnded"},
        {"runner", m_username},
        {"finalTime", finalTime}
    });
}

void racemanager::sendMessage(const QJsonObject& payload){
    if(!m_connected){
        qWarning() << "Tried to send message while disconnected";
        return;
    }
    QString json = QJsonDocument(payload).toJson(QJsonDocument::Compact);
    m_socket->sendTextMessage(json);
}

void racemanager::sendPing(){
    sendMessage({
                 {"event", "ping"},
                 {"clientTime", m_clock.elapsed()}
    });
}

void racemanager::handlePong(const QJsonObject& data){
    qint64 receiveTime = m_clock.elapsed();
    qint64 sendTime = data["clientTime"].toInteger();
    qint64 serverTime = data["serverTime"].toInteger();

    qint64 roundTrip = receiveTime - sendTime;
    qDebug() << "Ping round trip: " << roundTrip <<"ms";

    if (roundTrip < m_bestRoundTrip){
        m_bestRoundTrip = roundTrip;
        m_clockOffset = serverTime - (sendTime + roundTrip / 2);
        qDebug() << "New clock offset:" << m_clockOffset << "ms";
    }
}

void racemanager::onConnected(){
    m_connected = true;
    emit connectedChanged();
    qDebug() << "Connecting with username: " << m_username;

    emit runnerConnected(m_username);

    sendMessage({
        {"event", "joined"},
        {"runner", m_username}
    });
    qDebug() << "Connected to room:" << m_roomId;

    m_bestRoundTrip = std::numeric_limits<qint64>::max();
    for(int i = 0; i < 5; i++){
        QTimer::singleShot(i*200, this, &racemanager::sendPing);
    }
}

void racemanager::onDisconnected(){
    m_connected = false;
    qDebug() << "Disconnected from room:" << m_roomId;
    emit connectedChanged();
}

void racemanager::onMessageReceived(const QString& message){
    QJsonObject data = QJsonDocument::fromJson(message.toUtf8()).object();
    QString event = data["event"].toString();

    if (event == "pong"){
        handlePong(data);
        return;
    }

    QString runner = data["runner"].toString();
    qDebug() << "EVENT RECEIVED:" << data;


    if (event == "split"){
        emit runnerSplit(runner, data["splitIndex"].toInt(), data["splitTime"].toString());
    }else if (event == "paused"){
        emit racePaused(data["elapsed"].toInteger());
    }else if (event == "reset"){
        emit runnerReset(runner);
    }else if (event == "runEnded"){
        emit runnerFinished(runner, data["finalTime"].toString());
    }else if (event == "joined") {
        emit runnerConnected(runner);
    }else if (event == "start"){
        handleStart(data);
    }else{
        qWarning() << "Unknown event:" << event;
    }
}

void racemanager::onError(QAbstractSocket::SocketError error){
    qWarning() << "WebSocket error:" << m_socket->errorString();
}

void racemanager::setUsername(const QString& username){
    m_username = username;
}

bool racemanager::isConnected() const {return m_connected;}
QString racemanager::getRoomId() const { return m_roomId; }

QString racemanager::getServerAddress() const {return m_serverUrl;}
void racemanager::setServerAddress (const QString& serverAddress) {
    if (m_serverUrl == serverAddress){
        return;
    }
    m_serverUrl = serverAddress;
    QSettings settings;
    settings.setValue("serverAddress", m_serverUrl);

    emit serverAddressChanged();
}









