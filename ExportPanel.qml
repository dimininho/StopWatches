import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import "global.js" as Global
import "control.js" as Control
import QtQuick.Controls.Private 1.0

Rectangle {
    id: exportPanel

    property int yPos:50


    color: Global.currentTheme.mainPanelColor
    width:400
    state: "ExportPanel_CLOSE"
    height: 50


    function repaint() {
       exportPanel.color = Global.currentTheme.mainPanelColor
    }


    MouseArea{
        anchors.fill:exportPanel
        onClicked: exportPanel.state = "SETTINGS_CLOSE"
    }




    states: [
        State {
            name: "ExportPanel_OPEN"
            PropertyChanges {
                target: exportPanel
                y: exportPanel.yPos
            }
        },
        State {
            name: "ExportPanel_CLOSE"
            PropertyChanges {
                target: exportPanel
                y:exportPanel.yPos - exportPanel.height
            }
        }
    ]
    transitions: [
        Transition {
            to: "*"
            NumberAnimation{
                target: exportPanel
                properties: "y"
                duration: 300
                easing.type: Easing.OutExpo
            }

        }
    ]
}



