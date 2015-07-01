import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Private 1.0
import "global.js" as Global

CalendarStyle {/*
           background: Rectangle {
               color: "blue"
              // width: 200
               implicitWidth: 200
              // height:200
               implicitHeight: 200
           }*/
            property bool gridVisible: true

           readonly property color sameMonthDateTextColor: Global.currentTheme.buttonLabelColor
           readonly property color selectedDateColor: Global.currentTheme.calendarSelectDate
           readonly property color selectedDateTextColor: Global.currentTheme.mainMenuLabelOnHoverColor
           readonly property color fillDateColor: Global.currentTheme.mainItemColor
           readonly property color differentMonthDateTextColor: "gray"
           readonly property color invalidDatecolor: "red"

           dayDelegate: Item {


               Rectangle {
                   anchors.fill: parent
                   border.color: "transparent"
                   color: styleData.date !== undefined && styleData.selected ? selectedDateColor : fillDateColor
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
                   }

               }
           }
           dayOfWeekDelegate: Rectangle {
               color: gridVisible ? Global.currentTheme.mainPanelColor : "transparent"
               implicitHeight: Math.round(TextSingleton.implicitHeight * 2.25)
               Label {
                   text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                   anchors.centerIn: parent
                   color: sameMonthDateTextColor
               }
           }

           navigationBar: Rectangle {
               height: Math.round(TextSingleton.implicitHeight * 2.73)
               color: Global.currentTheme.mainPanelColor

               Rectangle {
                   color: Qt.rgba(1,1,1,0.6)
                   height: 1
                   width: parent.width
               }

               Rectangle {
                   anchors.bottom: parent.bottom
                   height: 1
                   width: parent.width
                   color: "#ddd"
               }

               MenuButton {
                   id: previousMonth
                   buttonWidth: parent.height-2
                   buttonHeigth: buttonWidth
                   //borderColor: "transparent"
                   buttonRadius:0
                   buttonText: "<"
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.left: parent.left
                   onButtonClick: control.showPreviousMonth()
               }



               Label {
                   id: dateText
                   text: styleData.title
                   elide: Text.ElideRight
                   horizontalAlignment: Text.AlignHCenter
                   font.pixelSize: TextSingleton.implicitHeight * 1.25
                   color: sameMonthDateTextColor
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.left: previousMonth.right
                   anchors.leftMargin: 2
                   anchors.right: nextMonth.left
                   anchors.rightMargin: 2
               }

               MenuButton {
                   id: nextMonth
                   buttonWidth: parent.height-2
                   buttonHeigth: buttonWidth
                   buttonRadius:0
                   buttonText: ">"
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   onButtonClick: control.showNextMonth()
               }


           }


       }

