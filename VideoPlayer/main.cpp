#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "videofileexplorermodel.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<VideoFileExplorerModel>("VideoFileExplorerModel", 0, 1, "VideoFileExplorerModel");

//    VideoFileExplorerModel videoExplorer;


    QQmlApplicationEngine engine;

//    engine.rootContext()->setContextProperty("videoExplorer", &videoExplorer);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
