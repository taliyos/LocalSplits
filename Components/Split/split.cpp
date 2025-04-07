#include "split.h"

#include <QDir>
#include <qurl.h>

#include "Components/SplitLayoutParsing/layoutparser.h"
#include "Components/SplitList/splitlistdata.h"

Split::Split(QObject *parent) : QObject(parent) {
    m_layout = new SplitLayout();
    m_data = new SplitListData();
}

Split::~Split() {
    delete m_layout;
    delete m_data;
}

SplitLayout* Split::getLayout() const {
    return m_layout;
}

SplitListData* Split::getData() const {
    return m_data;
}

void Split::openFile(const QString& fileLocation) {
    delete m_layout;

    m_data->clear();

    const QUrl url(fileLocation);
    QString filePath;
    if (url.isLocalFile()) {
       filePath = QDir::toNativeSeparators(url.toLocalFile());
    } else {
        filePath = fileLocation;
    }

    m_layout = LayoutParser::readLayout(filePath);
    qDebug() << m_layout->gameName << Qt::endl;
    if (m_layout == nullptr) return;

    for (int i = 0; i < m_layout->segments.size(); i++) {
        SplitSegment* segment = m_layout->segments.at(i);
        m_data->addItem(segment->name, "-");
    }

    emit gameNameChanged();
    emit categoryNameChanged();
    emit runIdChanged();
    emit platformChanged();
    emit regionChanged();
    emit attemptCountChanged();
}

void Split::newFile() {
    m_data->clear();
    delete m_layout;
    m_layout = new SplitLayout();

    emit gameNameChanged();
    emit categoryNameChanged();
    emit runIdChanged();
    emit platformChanged();
    emit regionChanged();
    emit attemptCountChanged();
}

QString Split::getGameName() const {
    return m_layout->gameName;
}

void Split::setGameName(const QString& name) {
    m_layout->gameName = name;
    emit gameNameChanged();
}

QString Split::getCategoryName() const{
    return m_layout->categoryName;
}

void Split::setCategoryName(const QString &categoryName) {
    m_layout->categoryName = categoryName;
    emit categoryNameChanged();
}

QString Split::getRunId() const {
    return m_layout->metadata.runId;
}

void Split::setRunId(const QString &runId) {
    m_layout->metadata.runId = runId;
    emit runIdChanged();
}

SplitPlatform Split::getPlatform() const {
    return m_layout->metadata.platform;
}

void Split::setPlatform(const SplitPlatform &platform) {
    m_layout->metadata.platform = platform;
    emit platformChanged();
}

QString Split::getRegion() const {
    return m_layout->metadata.region;
}

void Split::setRegion(const QString &region) {
    m_layout->metadata.region = region;
    emit regionChanged();
}

int Split::getAttemptCount() const {
    return m_layout->attemptCount;
}

void Split::setAttemptCount(const int &attemptCount) {
    m_layout->attemptCount = attemptCount;
    emit attemptCountChanged();
}
