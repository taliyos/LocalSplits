#ifndef RUNNERMODEL_H
#define RUNNERMODEL_H

#include <QAbstractListModel>
#include <QStringList>

struct Runner {
    QString name;
    QList<QString> splits;
};

class RunnerModel : public QAbstractListModel
{
    Q_OBJECT

public:

    enum Roles {
        NameRole = Qt::UserRole + 1,
        SplitsRole
    };

    explicit RunnerModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addRunner(const QString& name);
    Q_INVOKABLE void removeRunner(const QString& name);
    Q_INVOKABLE void updateSplit(const QString& runner, int splitIndex, const QString& time);
    Q_INVOKABLE void resetRunner(const QString& runner);

signals:
    void runnerDataChanged();

private:
    QList<Runner> m_runners;
    int findRunner(const QString& name) const;
};

#endif
