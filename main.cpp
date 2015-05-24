#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "fileio.h"
#include <QDebug>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    FileIO fileIO;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("fileio",&fileIO);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QString str = engine.offlineStoragePath();
    qDebug()<<str;
    return app.exec();
}
