#ifndef RACEMANAGER_H
#define RACEMANAGER_H

#include <QObject>
#include <QWebSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRandomGenerator>

class racemanager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(QString roomId READ getRoomId NOTIFY roomIdChanged)

public:
    explicit racemanager(QObject *parent = nullptr);

    bool isConnected() const;
    QString getRoomId() const;

    Q_INVOKABLE void joinRoom(const QString& roomId);
    Q_INVOKABLE void createRoom();
    Q_INVOKABLE void leaveRoom();
    Q_INVOKABLE void sendSplit(int splitIndex, const QString& splitTime);
    Q_INVOKABLE void sendPause(const QString& currentTime);
    Q_INVOKABLE void sendReset();
    Q_INVOKABLE void sendRunEnded(const QString& finalTime);
    Q_INVOKABLE void setUsername(const QString& username);

signals:
    void connectedChanged();
    void roomIdChanged();
    void runnerSplit(const QString& runner, int splitIndex, const QString& splitTime);
    void roomCodeGenerated(const QString& code);
    void runnerPaused(const QString& runner, const QString& currentTime);
    void runnerReset(const QString& runner);
    void runnerFinished(const QString& runner, const QString& finalTime);
    void runnerConnected(const QString& runner);
    void runnerDisconnected(const QString& runner);

private slots:
    void onConnected();
    void onDisconnected();
    void onMessageReceived(const QString& message);
    void onError(QAbstractSocket::SocketError error);

private:
    QString generateRoomCode();

    QWebSocket* m_socket;
    bool m_connected = false;
    QString m_roomId;
    QString m_username;

    void sendMessage(const QJsonObject& payload);

    static constexpr const char* SERVER_URL = "ws://localhost:8080/race";
};

#endif
