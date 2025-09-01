#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QDir>
#include <QQmlEngine>
#include <QQuickView>

#include "Components/Split/split.h"
#include "Components/Split/splitmodel.h"
#include "Components/SplitLayoutParsing/layoutparser.h"
#include "Components/SplitList/splitlistdata.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName("LocalSplits");
    QCoreApplication::setApplicationVersion("0.1");

    QGuiApplication app(argc, argv);

    qmlRegisterType<SplitModel>("com.localsplits", 1, 0, "SplitModel");
    qmlRegisterUncreatableType<SplitListData>("com.localsplits", 1, 0, "SplitListData", QStringLiteral("SplitListData should not be created in QML"));

    Split* split = new Split();
    //split->openFile("tests\\testLayout.lss");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("split"), split);
    engine.rootContext()->setContextProperty(QStringLiteral("gameName"), QVariant(split->getLayout()->gameName));
    engine.rootContext()->setContextProperty(QStringLiteral("splitList"), split->getData());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("LocalSplits", "Main");

    return app.exec();
}
