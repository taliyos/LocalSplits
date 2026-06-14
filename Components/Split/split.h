
#ifndef SPLIT_H
#define SPLIT_H
#include <QObject>

#include "Components/SplitLayoutParsing/splitplatform.h"
#include "Components/Timer/timer.h"
#include "racemanager.h"
#include "Components/RunnerModel/RunnerModel.h"


class SplitListData;
struct SplitLayout;

class Split : public QObject {
    Q_OBJECT


public:

    enum class GameMode{
        SinglePlayer,
        MultiPlayer
    };

    Q_ENUM(GameMode)

    Q_PROPERTY(QString gameName READ getGameName WRITE setGameName NOTIFY gameNameChanged)
    Q_PROPERTY(QString categoryName READ getCategoryName WRITE setCategoryName NOTIFY categoryNameChanged)
    Q_PROPERTY(QString runId READ getRunId WRITE setRunId NOTIFY runIdChanged)
    Q_PROPERTY(SplitPlatform platform READ getPlatform WRITE setPlatform NOTIFY platformChanged)
    Q_PROPERTY(QString region READ getRegion WRITE setRegion NOTIFY regionChanged)
    Q_PROPERTY(int attemptCount READ getAttemptCount WRITE setAttemptCount NOTIFY attemptCountChanged)
    Q_PROPERTY(bool run_ended READ getRunEnded NOTIFY runEndedChanged)
    Q_PROPERTY(GameMode gameMode READ getGameMode WRITE setGameMode NOTIFY gameModeChanged)
    Q_PROPERTY(QString username READ getUsername WRITE setUsername NOTIFY usernameChanged)

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

    bool getRunEnded() const;

    GameMode getGameMode() const;
    Q_INVOKABLE void setGameMode(GameMode mode);
    Q_INVOKABLE RunnerModel* getRunnerModel() const;

    QString getUsername() const;
    void setUsername(const QString& username);

signals:
    void layoutChanged();
    void gameNameChanged();
    void categoryNameChanged();
    void runIdChanged();
    void platformChanged();
    void regionChanged();
    void attemptCountChanged();
    void runEndedChanged();
    void gameModeChanged();
    void runnerModelChanged();
    void usernameChanged();

public slots:
    void openFile(const QString& fileLocation);
    void newFile();
    void onResetButtonPress();
    void onSplitButtonPress();
    void onPauseButtonPress();
    void onRemotePause();
    void onRemoteReset();
    Timer* getTimer() const;
    racemanager* getRaceManager() const;

private:
    SplitLayout* m_layout;
    SplitListData* m_data;
    Timer* m_timer;
    racemanager* m_racemanager = nullptr;
    GameMode m_gameMode = GameMode::SinglePlayer;
    RunnerModel* m_runnerModel;
    QString m_username = "Anonymous";
    int m_splitrow = 0;
    bool m_run_ended = false;
    bool m_run_started = false;
};



#endif //SPLIT_H
