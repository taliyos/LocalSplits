#ifndef SPLITROWMODEL_H
#define SPLITROWMODEL_H

#include <QAbstractListModel>
#include <qqmlintegration.h>
#include <QString>

class SplitRowModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString time READ time WRITE setTime NOTIFY timeChanged)


public:
    enum Role {
        NameRole = Qt::UserRole + 1,
        TimeRole
    };
    SplitRowModel(QObject *parent = nullptr);
    ~SplitRowModel();

    QString name() const;
    QString time() const;

    // int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    // QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    // QHash<int, QByteArray> roleNames() const override;

    // Editable:
    // bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

public slots:
    void setName(const QString& name);
    void setTime(const QString& time);

signals:
    void nameChanged();
    void timeChanged();


private:
    QString m_name;
    QString m_time;
};

#endif // SPLITROWMODEL_H
