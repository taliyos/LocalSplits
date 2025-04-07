#ifndef SPLITPLATFORM_H
#define SPLITPLATFORM_H

#include <QString>

struct SplitPlatform {
    Q_GADGET
public:
    QString platform = "GCN";
    QString usesEmulator = "Y";
};

#endif // SPLITPLATFORM_H
