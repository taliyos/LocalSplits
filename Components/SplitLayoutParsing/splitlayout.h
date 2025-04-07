#ifndef SPLITLAYOUT_H
#define SPLITLAYOUT_H

#include <QString>
#include <QList>
#include "Components/SplitLayoutParsing/splitmetadata.h"
#include "Components/SplitLayoutParsing/splitattempt.h"
#include "Components/SplitLayoutParsing/splitsegment.h"

struct SplitLayout {
    Q_GADGET
public:
    QString gameIcon;
    QString gameName = "Game Name";
    QString categoryName = "Category Name";
    SplitMetadata metadata;
    QString offset;
    int attemptCount = 0;
    QList<SplitAttempt> attemptHistory;
    QList<SplitSegment*> segments;
};

#endif // SPLITLAYOUT_H
