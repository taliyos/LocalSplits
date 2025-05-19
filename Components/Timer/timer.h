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
    // To attempt to fix type_traits: to help -> about plugins -> deactivate clang code model
    explicit Timer(const int& updateMilisecondInterval, QObject* parent = nullptr);
    // ~Timer() override;

    // void setTime(const QString& time);

    void setTime(const QString &newTime);

public slots:
    QString getTime();

    void onPauseButtonClick();

signals:
    void timeChanged();

private:
    QElapsedTimer timer;

    qint64 pausedTime = 0;
    qint64 resumedTime = 0;
    qint64 deadTime = 0;

    static QString formatTime(QList<qint64> timeArray, int index, const QString& separator);

    // True when timer paused, false when unpaused
    bool timerPaused = true;
    int updateMilisecondInterval;
};

#endif // TIMER_H
