#ifndef SPLITSMODEL_H
#define SPLITSMODEL_H

#include "../SplitRow/splitrowmodel.h"
#include "../SplitList/splitlistdata.h"


class SplitModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(SplitListData* splits READ splits WRITE setSplits)

public:
    explicit SplitModel(QObject* parent = nullptr);
    ~SplitModel() override;

    enum Role {
        NameRole = Qt::UserRole + 1,
        TimeRole
    };

    SplitListData* splits() const;
    void setSplits(SplitListData* splits);

    // <-- Defaults -->
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    SplitListData* m_splits;

};



#endif //SPLITSMODEL_H
