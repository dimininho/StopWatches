/*In this class used module QXlsx written by dbzhang800
 * source:   http://qtxlsx.debao.me
 * DBtoExcel contains functionality for handling export from database
*/

#ifndef DBTOEXCEL
#define DBTOEXCEL
#include "QtXlsx/xlsxdocument.h"
//#include "QtXlsx/xlsxconditionalformatting.h"
//#include "QtXlsx/xlsxformat.h"


class DBtoExcel: public QObject
{
    Q_OBJECT

public:
    DBtoExcel();

    ~DBtoExcel();

public slots:

    void createFile();
    void printDate(const QString date);
    void printHeader(const QString h1, const QString h2);
    void exportTask(const QString name, const QString time);
    void addLine();
    void saveFile(const QString filename);

private:
     QXlsx::Document* pXlsx;
     QXlsx::Format headerFormat;
     QXlsx::Format mainheaderFormat;
     QXlsx::Format dateFormat;

     int row;
};


#endif // DBTOEXCEL

