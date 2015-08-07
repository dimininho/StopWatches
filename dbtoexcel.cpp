#include "dbtoexcel.h"
#include <QColor>

DBtoExcel::DBtoExcel(){
    pXlsx = new QXlsx::Document();
    headerFormat.setFontBold(true);
    dateFormat.setFontBold(true);
    dateFormat.setFontSize(12);
    dateFormat.setPatternBackgroundColor(QColor(40,165,223));
    mainheaderFormat.setFontSize(14);
    mainheaderFormat.setHorizontalAlignment(QXlsx::Format::AlignHCenter);
}

DBtoExcel::~DBtoExcel(){
    delete pXlsx;
}


void DBtoExcel::createFile(){
    pXlsx = new QXlsx::Document();
    row = 1;
    pXlsx->write(row,1,"Exported from TimeKeeper",mainheaderFormat);
    pXlsx->mergeCells(QXlsx::CellRange(row,1,row,12));
    ++row;
}

void DBtoExcel:: printDate(const QString date){
    pXlsx->write(row,1,"Date",dateFormat);
    pXlsx->write(row,2,date);
    pXlsx->mergeCells(QXlsx::CellRange(row,2,row,3),dateFormat);
    pXlsx->mergeCells(QXlsx::CellRange(row,4,row,12),dateFormat);
    ++row;
}

void DBtoExcel::printHeader(const QString h1, const QString h2){

    pXlsx->write(row,2,h1,headerFormat);
    pXlsx->write(row,3,h2,headerFormat);
    ++row;
}


void DBtoExcel::exportTask(const QString name, const QString time){

    pXlsx->write(row,2,name);
    pXlsx->write(row,3,time);
    ++row;
}

void DBtoExcel::addLine() {
    ++row;
}

void DBtoExcel::saveFile(const QString filename) {
    pXlsx->saveAs(filename);
}
