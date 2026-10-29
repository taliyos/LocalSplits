#ifndef RACEMANAGER_H
#define RACEMANAGER_H

#include <QObject>
#include <QWebSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRandomGenerator>
#include <QElapsedTimer>
#include <limits>

class racemanager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(QString roomId READ getRoomId NOTIFY roomIdChanged)
    Q_PROPERTY(QString serverAddress READ getServerAddress WRITE setServerAddress NOTIFY serverAddressChanged)

public:
    explicit racemanager(QObject *parent = nullptr);

    bool isConnected() const;
    QString getRoomId() const;

    Q_INVOKABLE void joinRoom(const QString& roomId);
    Q_INVOKABLE void createRoom();
    Q_INVOKABLE void leaveRoom();
    Q_INVOKABLE void sendSplit(int splitIndex, const QString& splitTime);
    Q_INVOKABLE void sendReset();
    Q_INVOKABLE void sendRunEnded(const QString& finalTime);
    Q_INVOKABLE void setUsername(const QString& username);
    Q_INVOKABLE void requestStart();
    Q_INVOKABLE void requestPause();
    Q_INVOKABLE void requestResume();

    QString getServerAddress() const;
    void setServerAddress(const QString& serverAddress);

signals:
    void connectedChanged();
    void roomIdChanged();
    void runnerSplit(const QString& runner, int splitIndex, const QString& splitTime);
    void roomCodeGenerated(const QString& code);
    void runnerReset(const QString& runner);
    void runnerFinished(const QString& runner, const QString& finalTime);
    void runnerConnected(const QString& runner);
    void runnerDisconnected(const QString& runner);
    void serverAddressChanged();
    void raceStartScheduled(qint64 delayMs);
    void racePaused(qint64 elapsedMs);

private slots:
    void onConnected();
    void onDisconnected();
    void onMessageReceived(const QString& message);
    void onError(QAbstractSocket::SocketError error);

private:
    QString generateRoomCode();
    QString m_serverUrl;

    QWebSocket* m_socket;
    bool m_connected = false;
    QString m_roomId;
    QString m_username;

    void sendMessage(const QJsonObject& payload);

    void sendPing();
    void handlePong(const QJsonObject& data);

    QElapsedTimer m_clock;
    qint64 m_clockOffset = 0;
    qint64 m_bestRoundTrip = std::numeric_limits<qint64>::max();

    void handleStart(const QJsonObject& data);
    qint64 m_lastStartAt = -1;

};

#endif
