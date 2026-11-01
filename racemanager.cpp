#include "racemanager.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>
#include <QSettings>
#include <QTimer>
#include <QJsonArray>

static const int SYNC_PINGS = 5;

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

    m_keepAliveTimer = new QTimer(this);
    m_keepAliveTimer->setInterval(10000);
    connect(m_keepAliveTimer, &QTimer::timeout, this, &racemanager::keepAliveTick);

    m_reconnectTimer = new QTimer(this);
    m_reconnectTimer->setInterval(2000);
    m_reconnectTimer->setSingleShot(true);
    connect(m_reconnectTimer, &QTimer::timeout, this, &racemanager::tryReconnect);

}

QString racemanager::generateRoomCode(){
    const QString chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    QString code;
    for(int i = 0; i < 6; i++){
        code += chars[QRandomGenerator::global()->bounded(chars.size())];
    }
    return code;
}

void racemanager::openRoom(const QString& roomId, const QString& extraQuery){
    m_shouldReconnect = false;
    m_reconnecting = false;
    m_reconnectTimer->stop();
    m_lastStartAt = -1;
    m_mySplits.clear();
    m_finalMs = -1;
    if(m_connected) leaveRoom();
    m_roomId = roomId;
    emit roomIdChanged();
    QString base = m_serverUrl;
    if(!base.startsWith("ws://") && !base.startsWith("wss://")){
        base = "ws://" + base;
    }
    m_roomUrl = QString("%1/race?roomId=%2%3").arg(base, roomId, extraQuery);
    m_socket->open(QUrl(m_roomUrl));
    qDebug() << "Connecting to room:" << roomId;
}

void racemanager::joinRoom(const QString& roomId){
    openRoom(roomId, "");
}

void racemanager::createRoom(bool sharedPause){
    QString code = generateRoomCode();
    openRoom(code, sharedPause ? "&sharedPause=true" : "&sharedPause=false");
    emit roomCodeGenerated(code);
}

bool racemanager::isSharedPause() const {return m_sharedPause;}

void racemanager::leaveRoom() {
    m_shouldReconnect = false;
    m_reconnectTimer->stop();
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
    if(m_pongCount < SYNC_PINGS){
        m_pendingStart = data;
        return;
    }
    qint64 startAt = data["startAt"].toInteger();
    if(startAt == m_lastStartAt) return;
    m_lastStartAt = startAt;

    qint64 localStart = startAt - m_clockOffset;
    qint64 delayMs = localStart - m_clock.elapsed();
    qDebug() << "Race starts in " << delayMs << "ms";
    emit raceStartScheduled(delayMs);
}

void racemanager::sendSplit(int splitIndex, const QString& splitTime){
    m_mySplits[splitIndex] = splitTime;
    sendMessage({
        {"event", "split"},
        {"runner", m_username},
        {"splitIndex", splitIndex},
        {"splitTime", splitTime}
    });
}

void racemanager::requestReset(){
    sendMessage({
        {"event", "requestReset"},
    });
}

void racemanager::sendRunEnded(qint64 finalMs){
    m_finalMs = finalMs;
    sendMessage({
        {"event", "runEnded"},
        {"finalMs", finalMs}
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
    m_lastPongAt = m_clock.elapsed();
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
    m_pongCount++;
    if(m_pongCount == SYNC_PINGS && !m_pendingStart.isEmpty()){
        QJsonObject pending = m_pendingStart;
        m_pendingStart = QJsonObject();
        handleStart(pending);
    }
    if(m_pongCount == SYNC_PINGS && m_reconnecting){
        m_reconnecting = false;
        resendMyRun();
    }
}

void racemanager::onConnected(){
    m_connected = true;
    emit connectedChanged();
    qDebug() << "Connecting with username: " << m_username;

    m_shouldReconnect = true;
    m_lastPongAt = m_clock.elapsed();
    if(!m_reconnecting) emit roomEntered();
    emit runnerConnected(m_username);

    sendMessage({
        {"event", "joined"},
        {"runner", m_username}
    });
    qDebug() << "Connected to room:" << m_roomId;

    m_bestRoundTrip = std::numeric_limits<qint64>::max();
    m_pongCount = 0;
    m_pendingStart = QJsonObject();
    for(int i = 0; i < SYNC_PINGS; i++){
        QTimer::singleShot(i*200, this, &racemanager::sendPing);
    }

    m_keepAliveTimer->start();
}

void racemanager::onDisconnected(){
    m_connected = false;
    qDebug() << "Disconnected from room:" << m_roomId;
    emit connectedChanged();
    m_keepAliveTimer->stop();
    if(m_shouldReconnect) m_reconnectTimer->start();
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
        m_pendingStart = QJsonObject();
        emit racePaused(data["elapsed"].toInteger());
    }else if (event == "reset"){
        m_mySplits.clear();
        m_finalMs = -1;
        m_pendingStart = QJsonObject();
        emit raceReset();
    }else if (event == "results"){
        QJsonArray results = data["results"].toArray();
        for (int i = 0; i < results.size(); i++){
            emit runnerPlaced(results[i].toObject()["runner"].toString(), i + 1);
        }
    }else if (event == "joined") {
        emit runnerConnected(runner);
    }else if (event == "start"){
        handleStart(data);
    }else if (event == "left"){
        emit runnerDisconnected(runner);
    }else if (event == "roomSettings"){
        m_sharedPause = data["sharedPause"].toBool();
        emit sharedPauseChanged();
    }else{
        qWarning() << "Unknown event:" << event;
    }
}

bool racemanager::isInRoom() const { return m_connected || m_shouldReconnect; }

void racemanager::tryReconnect(){
    if(!m_shouldReconnect || m_socket->state() != QAbstractSocket::UnconnectedState) return;
    m_reconnecting = true;
    qDebug() << "Reconnecting to room:" << m_roomId;
    m_socket->open(QUrl(m_roomUrl));
}

void racemanager::keepAliveTick(){
    if(m_clock.elapsed() - m_lastPongAt > 25000){
        qWarning() << "Connection lost, no pong";
        m_socket->abort();
        return;
    }
    sendPing();
}

void racemanager::resendMyRun(){
    const QMap<int, QString> splits = m_mySplits;
    for(auto it = splits.constBegin(); it != splits.constEnd(); ++it){
        sendSplit(it.key(), it.value());
    }
    if(m_finalMs >= 0) sendRunEnded(m_finalMs);
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









