#include "splitrowmodel.h"

SplitRowModel::SplitRowModel(QObject *parent)
    : QObject(parent) {

    setName("Poltergust 5000");
    setTime("00:07:12.15");
}

SplitRowModel::~SplitRowModel() {

}

QString SplitRowModel::name() const {
    return m_name;
}

QString SplitRowModel::time() const {
    return m_time;
}

void SplitRowModel::setName(const QString &name) {
    m_name = name;
    // emit nameChanged();
}

void SplitRowModel::setTime(const QString &time) {
    m_time = time;
    // emit timeChanged();
}

/*int SplitRowModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;
}

QVariant SplitRowModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    switch ((Role) role) {
        case NameRole:
            return name();
        case TimeRole:
            return time();
    }

    return {};
}

QHash<int, QByteArray> SplitRowModel::roleNames() const {
    QHash<int, QByteArray> result;

    result[NameRole] = "name";
    result[TimeRole] = "time";

    return result;
}

bool SplitRowModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        // FIXME: Implement me!
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}*/
