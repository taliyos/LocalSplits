#ifndef TIMER_H
#define TIMER_H

#include <QElapsedTimer>
#include <QObject>
#include <QString>

class Timer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString time READ getTime)

public:
    explicit Timer(QObject* parent = nullptr);
    // ~Timer() override;

    // void setTime(const QString& time);

public slots:
    QString getTime() const;

signals:
    // void timeChanged();

private:
    QElapsedTimer timer;
    long pausedTime;
    long resumedTime;
};

#endif // TIMER_H
