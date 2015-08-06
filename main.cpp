#include <QGuiApplication>
//#include <QApplication>
#include <QQmlApplicationEngine>
//#include <QStyle>
#include <QQmlContext>
#include <QDir>
#include "fileio.h"
#include <QDebug>
#include "QtXlsx/xlsxdocument.h"
#include "dbtoexcel.h"


#include "QtXlsx/xlsxformat.h"
#include "QtXlsx/xlsxcellrange.h"
#include "QtXlsx/xlsxworksheet.h"
#include "QtXlsx/xlsxconditionalformatting.h"
#include <QDate>
#include <QImage>

QTXLSX_USE_NAMESPACE

int main(int argc, char *argv[])
{

   // QApplication app(argc, argv);
    //app.style()->pixelMetric(QStyle::PM_LargeIconSize);



    QGuiApplication app(argc, argv);



/*
    DBExport.createFile();
    DBExport.addLine();

    DBExport.printDate("05.05.2015");
    DBExport.printHeader("Task","Time");
    DBExport.exportTask("Odessa","12:13:34");
    DBExport.exportTask("baku","12:13:34");
    DBExport.exportTask("Alpha","12:13:34");
    DBExport.addLine();
    //DBExport.addLine();
    DBExport.printDate("09.05.2015");
    DBExport.printHeader("Task","Time");
    DBExport.exportTask("Odessa","12:13:34");
    DBExport.exportTask("baku","12:13:34");

    DBExport.saveFile("ExportDB.xlsx");

    DBExport.createFile();
    DBExport.addLine();
    DBExport.printDate("05.05.2015");
    DBExport.printHeader("Task","Time");
    DBExport.exportTask("Odessa","12:13:34");
    DBExport.printDate("09.05.2015");
    DBExport.printHeader("Task","Time");
    DBExport.exportTask("Odessa2","12:13:34");
    DBExport.exportTask("baku","12:13:34");

    DBExport.saveFile("ExportDB2.xlsx");
*/

    FileIO fileIO;
    DBtoExcel DBExport;

    QQmlApplicationEngine engine;
    engine.setOfflineStoragePath(QDir::currentPath());
    engine.rootContext()->setContextProperty("fileio",&fileIO);
    engine.rootContext()->setContextProperty("DBExport",&DBExport);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


   //QString str = engine.offlineStoragePath();
   //qDebug()<<str;
   //qDebug()<<QDir::currentPath();
    return app.exec();
}
