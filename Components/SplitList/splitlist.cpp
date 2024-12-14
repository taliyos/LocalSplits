#include "splitlist.h"

SplitList::SplitList(QObject *parent) : QObject(parent) {
}

QVector<SplitItem> SplitList::items() const {
    return m_items;
}

bool SplitList::setItemAt(int index, const SplitItem &item) {
    if (index < 0 || index >= m_items.size()) return false;

    const SplitItem& existingItem = m_items.at(index);
    if (existingItem.name == item.name && existingItem.time == item.time) return false;

    m_items[index] = item;
    return true;
}

void SplitList::addItem() {
    addItem("New Split", "-");
}

void SplitList::addItem(const QString& name, const QString& time) {
    emit preItemAppended();

    SplitItem item;
    item.name = name;
    item.time = time;

    m_items.append(item);

    emit postItemAppended();
}

void SplitList::removeItem(int index) {
    if (index < 0 || index >= m_items.size()) return;

    emit preItemRemoved(index);
    m_items.removeAt(index);
    emit postItemRemoved();
}
