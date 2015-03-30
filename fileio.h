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
        if (!file.open(QFile::WriteOnly))   //| QFile::Truncate
            return false;

        QTextStream out(&file);
        //out.setDevice(&file);
        out.seek(writePos);
        out << data;
        writePos = data.length();
        qDebug()<<writePos;
        file.close();

        return true;
    }



    QString read(const QString& source)
    {
        if (source.isEmpty()) return "NAN";

       QFile file(source);
        if (!file.open(QFile::ReadOnly))
            return "NAN";

        QString str;
        QTextStream in(&file);
        //in.setDevice(&file);
        in.seek(readPos);
        in >> str;
        readPos = in.pos();


        qDebug()<<readPos;
        return str;
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


#endif // FILEIO

