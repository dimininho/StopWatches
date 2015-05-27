#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include "fileio.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    FileIO fileIO;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("fileio",&fileIO);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.setOfflineStoragePath(QDir::currentPath());
   //QString str = engine.offlineStoragePath();
    //qDebug()<<str;
    //qDebug()<<QDir::currentPath();
    return app.exec();
}
