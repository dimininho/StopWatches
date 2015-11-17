#include <QGuiApplication>
//#include <QApplication>
#include <QQmlApplicationEngine>
//#include <QStyle>
#include <QQmlContext>
#include "fileio.h"
#include <QDebug>
#include "dbtoexcel.h"
#include <QCoreApplication>

QTXLSX_USE_NAMESPACE

int main(int argc, char *argv[])
{

   // QApplication app(argc, argv);
    //app.style()->pixelMetric(QStyle::PM_LargeIconSize);


    QGuiApplication app(argc, argv);

    FileIO fileIO;
    DBtoExcel DBExport;
    Defaults defaults;
    defaults.setDefaultPath(QCoreApplication::applicationDirPath());

    QQmlApplicationEngine engine;
    //engine.setOfflineStoragePath(QDir::currentPath());
    engine.setOfflineStoragePath(QCoreApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("fileio",&fileIO);
    engine.rootContext()->setContextProperty("defaults",&defaults);
    engine.rootContext()->setContextProperty("DBExport",&DBExport);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));



   //qDebug()<<QCoreApplication::applicationDirPath();
    return app.exec();
}
