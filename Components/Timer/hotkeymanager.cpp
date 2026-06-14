#include "hotkeymanager.h"

#include <QKeySequence>
#include <QDebug>

HotkeyManager::HotkeyManager(QObject *parent)
    : QObject{parent}
{
    m_pauseHotkey = new QHotkey(QKeySequence("Ctrl+Q"), true, this);
    m_splitHotkey = new QHotkey(QKeySequence("Ctrl+W"), true, this);
    m_resetHotkey = new QHotkey(QKeySequence("Ctrl+E"), true, this);

    connect(m_pauseHotkey, &QHotkey::activated, this, &HotkeyManager::onPauseActivated);
    connect(m_splitHotkey, &QHotkey::activated, this, &HotkeyManager::onSplitActivated);
    connect(m_resetHotkey, &QHotkey::activated, this, &HotkeyManager::onResetActivated);
}

void HotkeyManager::onPauseActivated(){
    emit pausePressed();
}
void HotkeyManager::onSplitActivated(){
    emit splitPressed();
}
void HotkeyManager::onResetActivated(){
    emit resetPressed();
}
