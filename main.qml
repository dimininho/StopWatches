import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import "control.js" as Control

import QtQuick.Controls.Styles 1.3

Window {
    id: mainItem

    property int watchWidth: 180

    width:500
    height: 500
    minimumWidth: watchWidth
    minimumHeight: watchWidth
    visible: true
    color: "#676767"
   // flags: Qt.FramelessWindowHint;



    MouseArea {
        anchors.fill: parent

    }

    signal timerStep    //signal to Watches
    onTimerStep: {}
    signal startWatches
    onStartWatches: {}
    signal stopWatches
    onStopWatches: {}



    Timer{
        id: mainTimer
        interval: 1000
        running: true
        repeat:true
        onTriggered: mainItem.timerStep();
    }


    Rectangle {
        id: mainPanel
        width: mainItem.width
        height: 50
        color: "#383838"
        anchors.top: parent.top
        //z:1

       /* RowLayout{
            id: rowlayout
            anchors.centerIn:  mainPanel

*/
        Button {
            id: mainMenuButton
            //text:"="
            menu: mainMenu
            //width: 60
            style: menuButtonStyle
            iconSource: "./img/white_menu1.png"
            anchors.left:mainPanel.left
            anchors.verticalCenter:  mainPanel.verticalCenter

        }

        Row{
           // anchors.top : parent.top
            //anchors.horizontalCenter:  mainPanel.horizontalCenter
            //anchors.centerIn:  mainPanel
            anchors.verticalCenter:  mainPanel.verticalCenter
            anchors.horizontalCenter: mainPanel.horizontalCenter
            anchors.left: mainMenuButton.right

            spacing: 20
            MenuButton{
                id: startButton
                buttonText: "Start all"
                onButtonClick: {
                    //  mainTimer.start()
                    mainItem.startWatches()
                }
            }

            MenuButton  {
                id: stopButton
                buttonText: "Stop all"
                onButtonClick: {
                    //mainTimer.stop()
                    mainItem.stopWatches()
                }

            }

            MenuButton  {
                id: addNew
                buttonText: "Add new"
                onButtonClick: {
                    Control.addButton(layout,mainItem);
                }

            }

        }

        //}

    }



    Menu{
        id: mainMenu
        style:  menuStyle

        MenuItem{
            text: "Save watches"
            onTriggered: {
                Control.writeWatchesToFile();
             }
        }
        MenuItem{
            text: "Load watches"
            onTriggered: {
                Control.readWatchesFromFile(layout);
             }
        }
        MenuItem{
            text: "Settings"
            onTriggered: {
                settingPanel.state = "SETTINGS_OPEN"
             }
        }
        MenuItem{
            text: "Exit"
            onTriggered: {
                Qt.quit();
             }
        }
    }

    property Component menuButtonStyle: ButtonStyle {
        background: Rectangle {
            implicitHeight: 30
            implicitWidth: 50
            color:  control.hovered ? "#888888" :  "#383838"
            //color: control.pressed ? "green" :  "#383838"
            antialiasing: true
            border.color: "transparent"
            radius: 5

        }


    }


    SettingsPanel{
        id: settingPanel
        //y: 200
        width: mainItem.width
        //anchors.top :mainPanel.bottom
        anchors.left: mainItem.left
        anchors.right: mainItem.right
       // state:"SETTINGS_CLOSE"
    }

    GridLayout {
        id:layout
        property int colNumber: 2
        anchors.top: settingPanel.bottom
        anchors.left: mainItem.left
        anchors.right: mainItem.right
        columns: colNumber

       // Watch { }


    }


    onWidthChanged: {
       // Control.changeColumnsNumber()
         layout.colNumber = mainItem.width / mainItem.watchWidth;
    }

    onSceneGraphInitialized:   Control.addButton(layout,mainItem);





    property Component menuStyle: MenuStyle {

        //__backgroundColor : "transparent"
        itemDelegate.background:  Rectangle {
            height: 22
            width: 100
            color: "gray"
            antialiasing: true
            border.color: "gray"
            //opacity: 0.7
            Rectangle {
                  anchors.fill: parent
                  anchors.margins: 1
                  color: styleData.selected ? "#999999" : "#333333"
                  antialiasing: true
                  visible: true
                  border.color: "black"
           }
        }
        itemDelegate.label: Text{
            text:  styleData.text
            color: "white"
            font.pointSize: 12
            font.bold: styleData.pressed ? true : false
        }


        frame: Rectangle{
            color: "gray"
            border.color: "transparent"
            border.width: 0

        }

    }



}
