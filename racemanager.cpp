#include "racemanager.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>

racemanager::racemanager(QObject *parent) : QObject{parent}
{
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
    QString url = QString("%1?roomId=%2").arg(SERVER_URL, roomId);
    m_socket->open(QUrl(url));
    qDebug() << "Connecting to room:" << roomId;
}

void racemanager::leaveRoom() {
    m_socket->close();
    m_roomId.clear();
    emit roomIdChanged();
}

void racemanager::sendSplit(int splitIndex, const QString& splitTime){
    sendMessage({
        {"event", "split"},
        {"runner", m_username},
        {"splitIndex", splitIndex},
        {"splitTime", splitTime}
    });
}

void racemanager::sendPause(const QString& currentTime){
    sendMessage({
        {"event", "pause"},
        {"runner", m_username},
        {"currentTime", currentTime}
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
}

void racemanager::onDisconnected(){
    m_connected = false;
    m_roomId.clear();
    emit connectedChanged();
    qDebug() << "Disconnected from room:" << m_roomId;
}

void racemanager::onMessageReceived(const QString& message){
    QJsonObject data = QJsonDocument::fromJson(message.toUtf8()).object();
    QString event = data["event"].toString();
    QString runner = data["runner"].toString();
    qDebug() << "EVENT RECEIVED:" << data;

    if (event == "split"){
        emit runnerSplit(runner, data["splitIndex"].toInt(), data["splitTime"].toString());
    }else if (event == "pause"){
        emit runnerPaused(runner, data["currentTime"].toString());
    }else if (event == "reset"){
        emit runnerReset(runner);
    }else if (event == "runEnded"){
        emit runnerFinished(runner, data["finalTime"].toString());
    }else if (event == "joined") {
        emit runnerConnected(runner);
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


