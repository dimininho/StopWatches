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


    Text {
        text: parent.hour + ":" + parent.min + ":" + parent.sec
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pointSize: 17
    }

    Rectangle {
        width:10
        height: 10
        radius: 5
        anchors{
            top:watch.top
            right:watch.right
            rightMargin: 15
            topMargin: 15
        }
        color: watch.run ? "yellow" : "grey"

    }

    MouseArea {
        anchors.fill: watch
        onClicked: watch.run = !watch.run
    }



    MouseArea {
        anchors{
            top: watch.top
            left: watch.left
            right: watch.right
            topMargin: 0.55*watch.width
        }
        width: input.contentWidth < 100 ? 100 : input.contentWidth

        height: input.contentHeight
        hoverEnabled: true
        onDoubleClicked: input.focus = true;
        onExited: input.focus = false;

        TextInput {
            id: input
            text: watch.watchName
            font.pixelSize: 15
            anchors.fill:  parent
            cursorVisible: false
            wrapMode: TextInput.WordWrap
            horizontalAlignment:  TextInput.AlignHCenter
            maximumLength: 50
        }

    }

    Connections{
        target: mainItem
        onTimerStep: {watch.nextMoment()}
        onStartWatches: watch.run = true
        onStopWatches: watch.run = false
    }

}
