TEMPLATE = app

QT += qml quick
macx: QT+= core sql

SOURCES += main.cpp \
    dbtoexcel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    fileio.h \
    dbtoexcel.h

include(QtXlsx/qtxlsx.pri)

win32: RC_ICONS = icon.ico
macx: ICON = icon.icns
