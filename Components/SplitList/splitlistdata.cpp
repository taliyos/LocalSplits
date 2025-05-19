#include "splitlistdata.h"
#include <QDebug>

SplitListData::SplitListData(QObject *parent) : QObject(parent) {
}

SplitListData::~SplitListData() {
    for (int i = 0; i < m_items.size(); i++) {
        delete m_items[i];
    }
}

QVector<SplitItem*> SplitListData::items() const {
    return m_items;
}

bool SplitListData::setItemAt(int index, SplitItem* item) {
    if (index < 0 || index >= m_items.size() || item == nullptr) return false;

    const SplitItem* existingItem = m_items.at(index);
    if (existingItem->name == item->name && existingItem->time == item->time) return false;

    m_items[index] = item;
    return true;
}

void SplitListData::addItem() {
    addItem("New Split", "-", m_items.size());
}

void SplitListData::addItem(const QString& name, const QString& time) {
    addItem(name, time, m_items.size());
}

void SplitListData::addItem(const QString& name, const QString& time, const qsizetype& index) {
    emit preItemInserted(index);

    SplitItem* item = new SplitItem();
    item->name = name;
    item->time = time;

    m_items.insert(index, item);

    emit postItemInserted();
}


void SplitListData::removeItem(int index) {
    if (index < 0 || index >= m_items.size()) return;

    emit preItemRemoved(index);
    delete m_items[index];
    m_items.removeAt(index);
    emit postItemRemoved();
}

void SplitListData::clear() {
    if (m_items.size() == 0)  return;

    emit preClear();
    for (int i = 0; i < m_items.size(); i++) {
        delete m_items[i];
    }
    m_items.clear();
    emit postClear();
}

void SplitListData::setTimeatSplitIndex(const QString& time, int index){

    m_items[index]->time = time;
    emit splitChanged(index);
}
