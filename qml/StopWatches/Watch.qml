import QtQuick 2.0

Rectangle {
    property string watchName: "Project name"
    property int min: 0
    property int hour: 0
    property int sec: 0
    property int time: 0

    property bool run: false



    function nextMoment() {
        if (watch.run==true)
        {
            ++time;
            var temptime = time;
            hour = temptime/3600;
            temptime -= hour*3600;
            min = temptime/60;
            temptime -= min*60;
            sec = temptime;
            //console.log(time + "    m" + min + "  s" + sec);
        }
    }


    id: watch
    width: 200
    height: 200
    color: "#76efa6"
    radius: 26
    border.width: 0
    border.color: "#1b50da"

    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#76efa6"
        }
        GradientStop {
            position: 1
            color: "#2694cc"
        }
    }
    smooth:true

 //   anchors.centerIn: parent

    Text {
        text: parent.watchName
        font.pixelSize: 15
        anchors.centerIn: parent
    }

    Text {
        text: parent.hour + ":" + parent.min + ":" + parent.sec
        // anchors.top: parent.top
       // anchors.left: parent.left
        anchors.horizontalCenter:  parent.horizontalCenter
       // anchors.topMargin: 40
    }

    Rectangle {
        width:10
        height: 10
        radius: 5
        anchors{
            top:parent.top
            right:parent.right
            rightMargin: 15
            topMargin: 15
        }
        color: parent.run ? "yellow" : "grey"

    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: parent.run = !parent.run
    }


    Connections{
        target: mainItem
        onTimerStep: {watch.nextMoment()}
        onStartWatches: watch.run = true
        onStopWatches: watch.run = false
    }

}
