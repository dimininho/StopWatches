import QtQuick 2.0



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
        y:60
    }

    Watch {
        x:270
        y:300
    }



    Rectangle {
        id: mainPanel
        width: mainItem.width
        height: 50
        color: "plum"
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
                    //mainTimer.stop()


                }

            }
        }

    }





}


