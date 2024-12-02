#ifndef TIMER_H
#define TIMER_H

#include <QObject>
#include <QString>
#include <qqml.h>

class Timer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    QML_ELEMENT

public:
    explicit Timer(QObject *parent = nullptr);
    QString userName();
    void setUserName(const QString &userName);

signals:
    void userNameChanged();

private:
    QString m_userName;
}


#endif // TIMER_H

