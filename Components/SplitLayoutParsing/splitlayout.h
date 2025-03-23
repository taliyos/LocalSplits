#ifndef SPLITLAYOUT_H
#define SPLITLAYOUT_H

#include <QString>
#include <QList>
#include "Components/SplitLayoutParsing/splitmetadata.h"
#include "Components/SplitLayoutParsing/splitattempt.h"
#include "Components/SplitLayoutParsing/splitsegment.h"

struct SplitLayout {
    QString gameIcon;
    QString gameName;
    QString categoryName;
    SplitMetadata metadata;
    QString offset;
    int attemptCount;
    QList<SplitAttempt> attemptHistory;
    QList<SplitSegment*> segments;
};

#endif // SPLITLAYOUT_H
