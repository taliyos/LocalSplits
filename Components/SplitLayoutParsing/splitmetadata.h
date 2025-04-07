#ifndef SPLITMETADATA_H
#define SPLITMETADATA_H

#include <QString>
#include "Components/SplitLayoutParsing/splitplatform.h"

struct SplitMetadata {
    Q_GADGET
public:
    QString runId = "";
    SplitPlatform platform;
    QString region = "US";
};

#endif // SPLITMETADATA_H
