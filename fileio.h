#ifndef FILEIO
#define FILEIO

#include <QObject>
#include <QFile>
#include <QTextStream>

#include <QDebug>

class FileIO : public QObject
{
    Q_OBJECT

public slots:
    bool write(const QString& source, const QString& data)
    {
        if (source.isEmpty())
            return false;

        QFile file(source);
        if (!file.open(QFile::WriteOnly | QFile::Truncate))
            return false;

        QTextStream out(&file);
        //out.setDevice(&file);
       // out.seek(writePos);
        out << data;
        writePos = data.length();
        qDebug()<<writePos;
        file.close();

        return true;
    }


    QString read(const QString& source)
    {
        if (source.isEmpty()) return "";

       QFile file(source);
       if (!file.exists()) return "";
       if (!file.open(QFile::ReadOnly))
            return "";

        QString str;
        QTextStream in(&file);
        //in.setDevice(&file);
        in.seek(readPos);
        in >> str;
        readPos = in.pos();


        //qDebug()<<readPos;
        return str;
    }

    void resetStream()
    {
       readPos = 0;
    }

    bool exist(const QString& source)
    {
        QFile file(source);
        if (!file.exists()) return false;
        return true;
    }

public:
    FileIO()
        :readPos(0),writePos(0)
    {}

private:
    qint64 readPos;
    qint64 writePos;
   // QTextStream in;
    //QTextStream out;
    //QFile file;
};



class Defaults: public QObject{
    Q_OBJECT
public:
    Defaults() {}
public slots:
    void setDefaultPath(QString path) {
        defPath = path;
    }
    QString defaultPath(){
        return defPath;
    }

 private:
    QString defPath;

};


#endif // FILEIO

