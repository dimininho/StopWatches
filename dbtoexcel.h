#ifndef DBTOEXCEL
#define DBTOEXCEL
#include "QtXlsx/xlsxdocument.h"
#include "QtXlsx/xlsxconditionalformatting.h"

class DBtoExcel: public QObject
{
    Q_OBJECT

public:
    DBtoExcel() {}

    void createFile(){
       pXlsx = new QXlsx::Document();
       headerFormat.setFontBold(true);
       dateFormat.setFontBold(true);
       dateFormat.setFontSize(12);
       row = 1;
    }

    void printDate(const QString date){
        QXlsx::CellRange range(row,1,row,12);
        QXlsx::CellRange range2(row,2,row,3);
        QXlsx::ConditionalFormatting cFormat;
        QXlsx::Format highlight;
        highlight.setPatternBackgroundColor(Qt::blue);
        cFormat.addHighlightCellsRule(cFormat.Highlight_NotEqual, "_+_+_", highlight);
        cFormat.addDataBarRule(Qt::blue);
        cFormat.addRange(range);


        pXlsx->write(row,1,"Date",dateFormat);
        pXlsx->write(row,2,date);
        pXlsx->mergeCells(range2);
        pXlsx->addConditionalFormatting(cFormat);
        ++row;
    }

    void printHeader(const QString h1, const QString h2){

        pXlsx->write(row,2,h1,headerFormat);
        pXlsx->write(row,3,h2,headerFormat);
        ++row;
    }

    void exportTask(const QString name, const QString time){

        pXlsx->write(row,2,name);
        pXlsx->write(row,3,time);
        ++row;
    }

    void addLine() {
        ++row;
    }

    void saveFile(){
        pXlsx->saveAs("ExportDB.xlsx");
    }

    ~DBtoExcel() {
        delete pXlsx;
    }

private:
     QXlsx::Document* pXlsx;
     QXlsx::Format headerFormat;
     QXlsx::Format dateFormat;

     int row;
};


#endif // DBTOEXCEL

