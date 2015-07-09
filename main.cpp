#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QStyle>
#include <QQmlContext>
#include <QDir>
#include "fileio.h"
#include <QDebug>

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    app.style()->pixelMetric(QStyle::PM_LargeIconSize);



    //QGuiApplication app(argc, argv);



    FileIO fileIO;

    QQmlApplicationEngine engine;
    engine.setOfflineStoragePath(QDir::currentPath());
    engine.rootContext()->setContextProperty("fileio",&fileIO);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


   //QString str = engine.offlineStoragePath();
   //qDebug()<<str;
   //qDebug()<<QDir::currentPath();
    return app.exec();
}
