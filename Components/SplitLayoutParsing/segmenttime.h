#ifndef SEGMENTTIME_H
#define SEGMENTTIME_H

#include <QString>
#include <QList>
#include "Components/SplitLayoutParsing/timemethod.h"

struct SegmentTime {
    QString id;
    QList<TimeMethod> times;
};

#endif // SEGMENTTIME_H
