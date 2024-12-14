#ifndef SPLITSMODEL_H
#define SPLITSMODEL_H

#include <QAbstractListModel>
#include "../SplitRow/splitrowmodel.h"
#include "../SplitList/splitlist.h"


class SplitModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(SplitList* splits READ splits WRITE setSplits)

public:
    explicit SplitModel(QObject* parent = nullptr);
    ~SplitModel() override;

    enum Role {
        NameRole = Qt::UserRole + 1,
        TimeRole
    };

    SplitList* splits() const;
    void setSplits(SplitList* splits);

    // <-- Defaults -->
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    SplitList* m_splits;
};



#endif //SPLITSMODEL_H
