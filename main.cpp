#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QDir>
#include <QQmlEngine>
#include <QQuickView>

#include "Components/Split/splitmodel.h"
#include "Components/SplitLayoutParsing/layoutparser.h"
#include "Components/SplitList/splitlist.h"
#include "Components/SplitRow/splitrowmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<SplitModel>("com.localsplits", 1, 0, "SplitModel");
    qmlRegisterUncreatableType<SplitListData>("com.localsplits", 1, 0, "SplitListData", QStringLiteral("SplitListData should not be created in QML"));

    SplitLayout* splitLayout = LayoutParser::readLayout("tests\\testLayout.lss");

    SplitListData* splitList = new SplitListData();

    for (int i = 0; i < splitLayout->segments.size(); i++) {
        SplitSegment* segment = splitLayout->segments.at(i);
        splitList->addItem(segment->name, "-");
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("gameName"), QVariant(splitLayout->gameName));
    engine.rootContext()->setContextProperty(QStringLiteral("splitList"), splitList);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("LocalSplits", "Main");

    delete splitLayout;

    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, [] {onAppExit();}, Qt::QueuedConnection);

    return app.exec();
}
