#ifndef TIMER_H
#define TIMER_H

#include <QElapsedTimer>
#include <QObject>
#include <QString>

class Timer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString time READ getTime WRITE setTime NOTIFY timeChanged)

public:
    explicit Timer(const int& updateMilisecondInterval, QObject* parent = nullptr);
    void setTime(const QString &newTime);

public slots:
    QString getTime();

    void onPauseButtonPress();
    void reset();

signals:
    void timeChanged();

private:
    QElapsedTimer timer;

    qint64 pausedTime = 0;
    qint64 resumedTime = 0;
    qint64 deadTime = 0;

    static QString formatTime(QList<qint64> timeArray, int index, const QString& separator);

    bool timerPaused = true;
    int updateMilisecondInterval;
};

#endif // TIMER_H
