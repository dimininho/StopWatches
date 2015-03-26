import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1

import "control.js" as Control

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

        Row{
           // anchors.top : parent.top
            //anchors.horizontalCenter:  mainPanel.horizontalCenter
            anchors.centerIn:  mainPanel

            spacing: 20
            Button  {
                id: startButton
                buttonText: "Start all"
                onButtonClick: {
                    //  mainTimer.start()
                    mainItem.startWatches()
                }
            }

            Button  {
                id: stopButton
                buttonText: "Stop all"
                onButtonClick: {
                    //mainTimer.stop()
                    mainItem.stopWatches()
                }

            }

            Button  {
                id: addNew
                buttonText: "Add new"
                onButtonClick: {
                    Control.addButton(layout,mainItem);
                }

            }
        }

    }



    GridLayout {
        id:layout
        property int colNumber: 2
        anchors.top: mainPanel.bottom
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

}





