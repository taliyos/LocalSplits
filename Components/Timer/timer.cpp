
#include "timer.h"
#include <iostream>
#include <QTimer>
#include <unistd.h>
#include <qDebug>


Timer::Timer(const int& updateMilisecondInterval, QObject *parent) : QObject{parent} {
    this->updateMilisecondInterval = updateMilisecondInterval;

    timer.start();
    QTimer *timeoutTimer = new QTimer(this);
    connect(timeoutTimer, &QTimer::timeout, this, &Timer::timeChanged);
    timeoutTimer->start(this->updateMilisecondInterval);
}

QString Timer::getTime() const {
    qint64 elapsedTimer = timer.elapsed() / 10;

    qint64 hours = elapsedTimer / 360000;

    qint64 minutes = (elapsedTimer % 360000) / 6000;

    qint64 tempSeconds = (elapsedTimer % 6000);
    qint64 seconds = tempSeconds / 100;

    qint64 miliseconds = tempSeconds % 100;

    QList<qint64> timeArray = {hours, minutes, seconds, miliseconds};

    QString readableTime = formatTime(timeArray, 0, QString(""))
        + formatTime(timeArray, 1, QString(":"))
        + formatTime(timeArray, 2, QString(":"))
        + formatTime(timeArray, 3, QString("."));

    return readableTime;
}

QString Timer::formatTime(QList<qint64> timeArray, int index, const QString& separator) {
    QString result = "";
    bool biggerNumberExists = false;

    // Check if a separator is needed
    for (int i = index - 1; i >= 0; i--) {
        if(timeArray[i] > 0){
            biggerNumberExists = true;
            result.append(separator);
            break;
        }
    }

    if(timeArray[index] == 0 && !biggerNumberExists) {
        return "";
    }
    if(biggerNumberExists && timeArray[index] < 10) {
        result.append("0");
    }

    result.append(QString::number(timeArray[index]));
    return result;
}


void Timer::setTime(const QString& newTime) {
    emit timeChanged();
}
