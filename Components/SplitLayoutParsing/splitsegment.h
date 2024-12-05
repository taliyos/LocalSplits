#ifndef SPLITSEGMENT_H
#define SPLITSEGMENT_H

#include <QString>
#include "Components/SplitLayoutParsing/splittime.h"
#include "Components/SplitLayoutParsing/segmenttime.h"
#include "Components/SplitLayoutParsing/timemethod.h"

struct SplitSegment {
    QString name;
    QList<SplitTime> splitTimes;
    QList<TimeMethod> bestSegmentTime;
    QList<SegmentTime> segmentHistory;
};

#endif // SPLITSEGMENT_H
