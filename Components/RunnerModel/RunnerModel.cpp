#include "RunnerModel.h"

RunnerModel::RunnerModel(QObject *parent) : QAbstractListModel{parent} {}

int RunnerModel::rowCount(const QModelIndex&) const {
    return m_runners.size();
}

QVariant RunnerModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() >= m_runners.size())
        return QVariant();

    const Runner& runner = m_runners[index.row()];

    if (role == NameRole)
        return runner.name;
    if (role == SplitsRole)
        return QVariant::fromValue(runner.splits);
    return QVariant();
}

QHash<int, QByteArray> RunnerModel::roleNames() const {

    return {
        { NameRole,   "name"   },
        { SplitsRole, "splits" }
    };
}

int RunnerModel::findRunner(const QString& name) const {
    for (int i = 0; i < m_runners.size(); i++) {
        if (m_runners[i].name == name) return i;
    }
    return -1;
}

void RunnerModel::addRunner(const QString& name) {
    if (findRunner(name) != -1) {
        qDebug() << "RunnerModel: runner already exists:" << name;
        return;
    }
    beginInsertRows(QModelIndex(), m_runners.size(), m_runners.size());
    m_runners.append({name, {}});
    endInsertRows();
    qDebug() << "RunnerModel: added runner:" << name << "| total runners:" << m_runners.size();
    emit runnerDataChanged();
}

void RunnerModel::removeRunner(const QString& name) {
    int i = findRunner(name);
    if (i == -1) return;
    beginRemoveRows(QModelIndex(), i, i);
    m_runners.removeAt(i);
    endRemoveRows();
    emit runnerDataChanged();
}

void RunnerModel::updateSplit(const QString& name, int splitIndex, const QString& time) {
    int i = findRunner(name);
    if (i == -1){
        qDebug() << "RunnerModel: updateSplit failed, runner not found:" << name;
        return;
    }
    while (m_runners[i].splits.size() <= splitIndex)
        m_runners[i].splits.append("--");

    m_runners[i].splits[splitIndex] = time;

    QModelIndex idx = index(i);
    emit dataChanged(idx, idx, {SplitsRole});
    emit runnerDataChanged();
}

void RunnerModel::resetRunner(const QString& name) {
    int i = findRunner(name);
    if (i == -1) {
        qDebug() << "RunnerModel: resetRunner failed, runner not found:" << name;
        return;
    }
    qDebug() << "RunnerModel: reset runner:" << name;
    m_runners[i].splits.clear();
    QModelIndex idx = index(i);
    emit dataChanged(idx, idx, {SplitsRole});
    emit runnerDataChanged();
}















