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

QString Timer::getTime() {


    qint64 elapsedTimer = timer.elapsed();

    if(timerPaused){
        elapsedTimer = pausedTime;
    }else{
        elapsedTimer = pausedTime + (elapsedTimer - pausedTime) - deadTime;
    }
    qint64 elapsedTimerRounded = (elapsedTimer)/ 10;

    qint64 hours = elapsedTimerRounded / 360000;

    qint64 minutes = (elapsedTimerRounded % 360000) / 6000;

    qint64 tempSeconds = (elapsedTimerRounded % 6000);
    qint64 seconds = tempSeconds / 100;

    qint64 miliseconds = tempSeconds % 100;

    QList<qint64> timeArray = {hours, minutes, seconds, miliseconds};

    bool hasHigherUnits = (hours > 0 || minutes > 0);

    QString readableTime = formatTime(timeArray, 0, QString(""))
                           + formatTime(timeArray, 1, QString(":"));

    if (hasHigherUnits){
        readableTime += QString(":") + (seconds < 10 ? "0" : "") + QString::number(seconds);
    } else {
        readableTime += QString::number(seconds);
    }

    readableTime += QString(".") + (miliseconds < 10 ? "0" : "") + QString::number(miliseconds);

    return readableTime;
}

QString Timer::formatTime(QList<qint64> timeArray, int index, const QString& separator) {
    QString result = "";
    bool biggerNumberExists = false;

    // Check if a separator is needed
    for (int i = index - 1; i >= 0; i--)    {
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


void Timer::setTime(const QString& newTime){
    emit timeChanged();

}

void Timer::onPauseButtonPress(){

    timerPaused = !timerPaused;
    if (timerPaused){
        pausedTime = timer.elapsed() - deadTime;

    }else{
        resumedTime = timer.elapsed();
        deadTime = resumedTime - pausedTime;
    }

}

void Timer::reset(){
    timerPaused = true;
    pausedTime = 0;
    resumedTime = 0;
    deadTime = 0;

}
