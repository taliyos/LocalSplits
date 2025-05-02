
#include "timer.h"
#include <iostream>
#include <ostream>
#include <stdlib.h>
#include <unistd.h>
#include <qDebug>


Timer::Timer(QObject *parent) : QObject{parent} {

    timer.start();
    QTimer *timeoutTimer = new QTimer(this);
    connect(timeoutTimer, &QTimer::timeout, this, &Timer::timeChanged);
    timeoutTimer->start(5);

}

QString Timer::getTime() const{
    qint64 elapsedTimer = timer.elapsed()/10;

    qint64 hours = elapsedTimer / 360000;
    QString hourString = QString::number(hours);
    qint64 minutes = (elapsedTimer % 360000) / 6000;
    QString minutesString = QString::number(minutes);

    if(minutes < 10){
        minutesString = "0" + minutesString;
    }

    qint64 tempSeconds = (elapsedTimer % 6000);
    qint64 seconds = tempSeconds / 100;
    QString secondString = QString::number(seconds);
    if(seconds < 10){
        secondString = "0" + secondString;
    }
    qint64 miliseconds = tempSeconds % 100;
    QString milisecondString = QString::number(tempSeconds % 100);
    if(tempSeconds % 100 < 10){
        milisecondString = "0" + milisecondString;
    }
    QList<qint64> timeArray = {hours, minutes, seconds, miliseconds};

    QString readableTime =  formatTime(timeArray, 0, QString("")) + formatTime(timeArray, 1, QString(":")) + formatTime(timeArray, 2, QString(":")) + formatTime(timeArray, 3, QString("."));
    return readableTime;
}

QString Timer::formatTime(QList<qint64> timeArray, int index, QString separator) const{
    QString result = "";
    bool biggerNumberTrue = false;
    if (index == 0){
        // Hour code
        if(timeArray[index] != 0){
            result.append(QString::number(timeArray[index]));
        }

    }else{
        // Non hour code
        // Figure out if there is bigger number so know to display separator
        int tempIndex = index - 1;
        while(tempIndex > 0){
            if(timeArray[tempIndex] > 0){
                biggerNumberTrue = true;
                result.append(separator);
                break;
            }
            tempIndex --;
        }
        if(timeArray[index] == 0 && biggerNumberTrue == false){
            // If empty and no bigger number
            return "";
        } else if(biggerNumberTrue == true){
            if(timeArray[index] < 10){
                result.append("0");
            }
            result.append(QString::number(timeArray[index]));
        }else{
            result.append(QString::number(timeArray[index]));
        }
    }

    return result;

}


void Timer::setTime(const QString& newTime) {

    emit timeChanged();

}
