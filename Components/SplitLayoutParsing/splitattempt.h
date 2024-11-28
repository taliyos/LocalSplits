#ifndef SPLITATTEMPT_H
#define SPLITATTEMPT_H

#include <QString>

struct SplitAttempt {
    QString id;
    QString started;
    QString isStartedSynced;
    QString ended;
    QString isEndedSynced;
    QString pauseTime;
};

#endif // SPLITATTEMPT_H
