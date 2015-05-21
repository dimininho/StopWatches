import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "control.js" as Control




Window {
    id: statisticsWindow

    //property date day: Date.now();

    width: 500;
    height: 350;
    color: Control.currentTheme.mainItemColor



    TextInput {
        id: dateField
        //text: clock.clockName
        text:  Qt.formatDateTime(new Date(), "yyyy-MM-dd")
        font.pixelSize: 15
        //color: clock.labelColor
        anchors.fill:  parent
        cursorVisible: false
        horizontalAlignment:  TextInput.AlignHCenter

    }
/*
    Calendar {
        id: calendar
        selectedDate: new Date(2015, 0, 1)
        frameVisible: true
        weekNumbersVisible: true
        focus: true
        style: CalendarStyle {
            dayDelegate: Item {
                readonly property color sameMonthDateTextColor: "#444"
                readonly property color selectedDateColor: "magenta"
                readonly property color selectedDateTextColor: "white"
                readonly property color differentMonthDateTextColor: "#bbb"
                readonly property color invalidDatecolor: "#dddddd"

                Rectangle {
                    anchors.fill: parent
                    border.color: "transparent"
                    color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                    anchors.margins: styleData.selected ? -1 : 0
                }


                Label {
                    id: dayDelegateText
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    color: {
                        var color = invalidDatecolor;
                        if (styleData.valid) {
                            // Date is within the valid range.
                            color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                            if (styleData.selected) {
                                color = selectedDateTextColor;
                            }
                        }
                        color;
                    }
                }
            }
        }
    }

*/
}
