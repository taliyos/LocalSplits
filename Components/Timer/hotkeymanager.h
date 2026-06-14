#ifndef HOTKEYMANAGER_H
#define HOTKEYMANAGER_H

#include <QHotkey>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class HotkeyManager : public QObject
{
    Q_OBJECT

public:
    explicit HotkeyManager(QObject *parent = nullptr);

signals:
    void pausePressed();
    void splitPressed();
    void resetPressed();

private slots:
    void onPauseActivated();
    void onSplitActivated();
    void onResetActivated();

private:
    QHotkey* m_pauseHotkey;
    QHotkey* m_splitHotkey;
    QHotkey* m_resetHotkey;
};

#endif // HOTKEYMANAGER_H
