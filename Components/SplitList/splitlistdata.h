#ifndef SPLITLIST_H
#define SPLITLIST_H

#include <QObject>
#include <QVector>
#include "../Split/splititem.h"

class SplitListData : public QObject {
    Q_OBJECT

public:
    explicit SplitListData(QObject* parent = nullptr);
    ~SplitListData() override;

    QVector<SplitItem*> items() const;

    bool setItemAt(int index, SplitItem* item);

signals:
    void preItemAppended();
    void postItemAppended();

    void preItemRemoved(int index);
    void postItemRemoved();

public slots:
    void addItem();
    void addItem(const QString& name, const QString& time);
    void removeItem(int index);

private:
    QVector<SplitItem*> m_items;
};



#endif //SPLITLIST_H
