
#ifndef SPLIT_H
#define SPLIT_H
#include <QObject>

#include "Components/SplitLayoutParsing/splitplatform.h"
#include "Components/Timer/timer.h"


class SplitListData;
struct SplitLayout;

class Split : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString gameName READ getGameName WRITE setGameName NOTIFY gameNameChanged)
    Q_PROPERTY(QString categoryName READ getCategoryName WRITE setCategoryName NOTIFY categoryNameChanged)
    Q_PROPERTY(QString runId READ getRunId WRITE setRunId NOTIFY runIdChanged)
    Q_PROPERTY(SplitPlatform platform READ getPlatform WRITE setPlatform NOTIFY platformChanged)
    Q_PROPERTY(QString region READ getRegion WRITE setRegion NOTIFY regionChanged)
    Q_PROPERTY(int attemptCount READ getAttemptCount WRITE setAttemptCount NOTIFY attemptCountChanged)
    // Q_PROPERTY(Timer* timer READ getTimer NOTIFY timerChanged())


public:
    explicit Split(QObject* parent = nullptr);
    ~Split() override;

    SplitLayout* getLayout() const;
    SplitListData* getData() const;

    QString getGameName() const;
    void setGameName(const QString& gameName);

    QString getCategoryName() const;
    void setCategoryName(const QString& categoryName);

    QString getRunId() const;
    void setRunId(const QString& runId);

    SplitPlatform getPlatform() const;
    void setPlatform(const SplitPlatform& platform);

    QString getRegion() const;
    void setRegion(const QString& region);

    int getAttemptCount() const;
    void setAttemptCount(const int& attemptCount);


    // void setTimer();


signals:
    void layoutChanged();
    void gameNameChanged();
    void categoryNameChanged();
    void runIdChanged();
    void platformChanged();
    void regionChanged();
    void attemptCountChanged();
    void timerChanged();


public slots:
    void openFile(const QString& fileLocation);
    void newFile();
    Timer* getTimer();

private:
    SplitLayout* m_layout;
    SplitListData* m_data;
    Timer* m_timer;
};



#endif //SPLIT_H
