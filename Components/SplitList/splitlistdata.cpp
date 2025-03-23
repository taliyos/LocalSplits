#include "splitlistdata.h"

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
    addItem("New Split", "-");
}

void SplitListData::addItem(const QString& name, const QString& time) {
    emit preItemAppended();

    SplitItem* item = new SplitItem();
    item->name = name;
    item->time = time;

    m_items.append(item);

    emit postItemAppended();
}

void SplitListData::removeItem(int index) {
    if (index < 0 || index >= m_items.size()) return;

    emit preItemRemoved(index);
    delete m_items[index];
    m_items.removeAt(index);
    emit postItemRemoved();
}
