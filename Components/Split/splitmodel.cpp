#include "splitmodel.h"
#include "splititem.h"

SplitModel::SplitModel(QObject *parent) : QAbstractListModel(parent) {

    std::vector<QString> tempSplits = {"Chauncey", "Boo Release", "Fire", "Water", "Bogmire", "Ice", "Moonshot", "Clairvoya Entry", "Boolossus", "Uncle Grimmly", "Rooftop", "Weston", "Forgor", "King Boo"};

    // Used only for creating and showing temporary splits when no splits are provided.
    m_splits = new SplitListData(this);
    for (int i = 0; i < tempSplits.size(); i++) {
        m_splits->addItem(tempSplits[i], "-");
    }
}

SplitModel::~SplitModel() {
    delete m_splits;
    m_splits = nullptr;
}

SplitListData* SplitModel::splits() const {
     return m_splits;
}

void SplitModel::setSplits(SplitListData* splits) {
    if (splits == m_splits) return;

    beginResetModel();
    if (m_splits) m_splits->disconnect(this);
    else delete m_splits;
    m_splits = splits;
    if (m_splits) {
        connect(m_splits, &SplitListData::preItemInserted, this, [=](int index) {
            beginInsertRows(QModelIndex(), index, index);

        });
        connect(m_splits, &SplitListData::postItemInserted, this, [=]() {
            endInsertRows();
        });
        connect(m_splits, &SplitListData::preItemRemoved, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_splits, &SplitListData::postItemRemoved, this, [=]() {
            endRemoveRows();
        });
        connect(m_splits, &SplitListData::preClear, this, [=] {
            beginResetModel();
        });
        connect(m_splits, &SplitListData::postClear, this, [=] {
            endResetModel();
        });
    }
    endResetModel();
}

int SplitModel::rowCount(const QModelIndex &parent) const {
    return m_splits->items().size();
}

QVariant SplitModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) {
        return {};
    }

    SplitItem* item = m_splits->items().at(index.row());

    switch ((Role) role) {
        case NameRole:
            return QVariant{item->name};
        case TimeRole:
            return QVariant{item->time};
    }
}

bool SplitModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid()) return false;

    if (role == NameRole) m_splits->items()[index.row()]->name = value.toString();
    else if (role == TimeRole) m_splits->items()[index.row()]->time = value.toString();

    return true;
}

Qt::ItemFlags SplitModel::flags(const QModelIndex &index) const {
    if (!index.isValid()) return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> SplitModel::roleNames() const {
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[TimeRole] = "time";
    return names;
}