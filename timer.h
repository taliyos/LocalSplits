#ifndef TIMER_H
#define TIMER_H

#include <QObject>
#include <QString>
#include <qqml.h>
#include <QTime>
#include <QTimer>

class Timer : public QObject
{
    Q_OBJECT
    // Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    QML_ELEMENT

public:
    explicit Timer(QObject *parent = nullptr);
    void userName();
    void setUserName(const QString &userName);

signals:
    void userNameChanged();

private:
    QTimer *timer;
    QTime *stopwatchTime;
    bool isRunning;
    int elapsedTime;
};


// bolt.new and replit.agent (AI coding) liam.ottley video on AI agents.
//chatp gpt relevance for(ai agents), zapier and make.com, promptmetheus (prompts), postman (api integraitons)

#endif // TIMER_H

