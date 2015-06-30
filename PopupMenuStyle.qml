import QtQuick 2.3
import QtQuick.Controls.Styles 1.3
import "global.js" as Global

MenuStyle {

        //__backgroundColor : "transparent"
        itemDelegate.background:  Rectangle {
            height: 22
            width: 100
            color: Global.currentTheme.mainMenuBackColor
            antialiasing: true
            border.color: Global.currentTheme.mainMenuBackColor
            //opacity: 0.7
            Rectangle {
                  anchors.fill: parent
                  anchors.margins: 1                  
                  color: styleData.selected ? Global.currentTheme.mainMenuOnHoverRowColor : Global.currentTheme.mainMenuRowColor
                  antialiasing: true
                  visible: true
                  border.color: Global.currentTheme.mainMenuBorderColor
           }
        }
        itemDelegate.label: Text{
            text:  styleData.text
            //color: Global.currentTheme.buttonLabelColor
            color:styleData.selected ? Global.currentTheme.mainMenuLabelOnHoverColor : Global.currentTheme.buttonLabelColor
            font.pointSize: 12
            font.bold: styleData.pressed ? true : false
        }


        frame: Rectangle{
            color: Global.currentTheme.mainMenuBackColor
            border.color: "transparent"
            border.width: 0

        }

    }

