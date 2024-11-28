#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "Components/SplitLayoutParsing/layoutparser.h"
#include "windows.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("LocalSplits", "Main");

    SplitLayout* splitLayout = LayoutParser::readLayout("");

    delete splitLayout;

    return app.exec();
}
