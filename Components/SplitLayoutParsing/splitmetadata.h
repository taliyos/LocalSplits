#ifndef SPLITMETADATA_H
#define SPLITMETADATA_H

#include <QString>
#include "Components/SplitLayoutParsing/splitplatform.h"

struct SplitMetadata {
    QString runId;
    SplitPlatform platform;
    QString region;
};

#endif // SPLITMETADATA_H
