#ifndef TIMEMETHOD_H
#define TIMEMETHOD_H

#include <QString>

enum TimeType {
    RealTime,
    GameTime
};

struct TimeMethod {
    TimeType type;
    QString time;
};

#endif // TIMEMETHOD_H
