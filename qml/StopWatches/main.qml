import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1



Item {
    id: mainItem
    width:500
    height: 500
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

    Watch {
        x:40
        y:50
    }

    Watch {
        x:300
        y:300
    }


    Row{
       // anchors.top : parent.top
         anchors.horizontalCenter:  parent.horizontalCenter
        spacing: 10
        Button  {
            id: startButton

            text: "Start all"
            onClicked: {
              //  mainTimer.start()
                mainItem.startWatches()
            }

        }
        Button  {
            id: stopButton
            text: "Stop all"

            onClicked: {
              //  mainTimer.stop()
                mainItem.stopWatches()
            }

        }
    }


}


