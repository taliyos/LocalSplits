#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QDir>
#include <QQmlEngine>
#include <QQuickView>
#include <windows.h>

#include "Components/Split/split.h"
#include "Components/Split/splitmodel.h"
#include "Components/SplitLayoutParsing/layoutparser.h"
#include "Components/SplitList/splitlistdata.h"

void createConsole()
{
    AllocConsole();
    FILE *pFileCon = NULL;
    pFileCon = freopen("CONOUT$", "w", stdout);

    COORD coordInfo;
    coordInfo.X = 0;
    coordInfo.Y = 0;

    SetConsoleScreenBufferSize(GetStdHandle(STD_OUTPUT_HANDLE), coordInfo);
    SetConsoleMode(GetStdHandle(STD_OUTPUT_HANDLE),ENABLE_QUICK_EDIT_MODE| ENABLE_EXTENDED_FLAGS);

    // Attach console to this process
    AttachConsole(GetCurrentProcessId());

    // Open and redirect i/o to console
    freopen("CON", "w", stdout);
    freopen("CON", "w", stderr);
    freopen("CON", "r", stdin);
}

void onAppExit() {
    PostMessage(GetConsoleWindow(), WM_CLOSE, 0, 0);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName("LocalSplits");
    QCoreApplication::setApplicationVersion("0.1");

    //createConsole();

    //createConsole();
    QGuiApplication app(argc, argv);

    qmlRegisterType<SplitModel>("com.localsplits", 1, 0, "SplitModel");
    qmlRegisterUncreatableType<SplitListData>("com.localsplits", 1, 0, "SplitListData", QStringLiteral("SplitListData should not be created in QML"));

    Split* split = new Split();
    //split->openFile("tests\\testLayout.lss");

    QQmlApplicationEngine engine;
    qDebug() << QGuiApplication::applicationDirPath() << Qt::endl;
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
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
