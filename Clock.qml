import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "control.js" as Control
import QtQuick.Controls.Styles 1.3
import "global.js" as Global

Rectangle {
    id: clock
    property int serialNr:0

    //property string clockName: "Project name"
    property alias clockName: input.text
    property int min: 0
    property int hour: 0
    property int sec: 0
    property int time: 0
    property bool seeSeconds: false

    property bool run: false

    //property color fillColor: "#434c53"
    property color fillColor: Control.currentTheme.clockFillColor;
    property color labelColor: Control.currentTheme.clockLabelColor
    property int clockWidth:180


    function nextMoment() {
        if (clock.run==true)
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


    width: 180
    height: 180
    //color: fillColor
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.lighter(fillColor, 1.3) }
        GradientStop { position: 0.67; color: Qt.darker(fillColor, 1.35) }
    }
    radius: 26
    border.width: 0
    border.color: "#1b50da"

    smooth:true
    antialiasing: true


    Text {
        text: {
            var str;
            str = (hour>9) ? parent.hour : "0"+parent.hour;
            str = (min>9) ? str + ":" + parent.min : str + ":0" + parent.min
            if (seeSeconds)
                str = (sec>9) ? str + ":" + parent.sec : str + ":0" + parent.sec
            return str;
        }
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pointSize: 17
        color: parent.labelColor
    }

    Rectangle {
        width:10
        height: 10
        radius: 5
        anchors{
            top:clock.top
            right:clock.right
            rightMargin: 15
            topMargin: 15
        }
        color: clock.run ? "yellow" : "grey"

    }

    MouseArea {
        anchors.fill: clock
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        onClicked: {
            if (mouse.button == Qt.RightButton) {
                popupMenu.popup(mouseX,mouseY);
            }
            if (mouse.button == Qt.LeftButton)    {
                if (Control.settings.onlyOneRun)
                {
                    var temprun = clock.run; //for correct work, when clock's state is "RUN"
                    Control.stopAllClocks();
                    clock.run = temprun;
                }

                clock.run = !clock.run;

             }
        }

    }



    MouseArea {
        anchors{
            top: clock.top
            left: clock.left
            right: clock.right
            topMargin: 0.55*clock.width
        }
        width: input.contentWidth < 100 ? 100 : input.contentWidth

        height: input.contentHeight
        hoverEnabled: true
        onDoubleClicked: input.focus = true;
        onExited: input.focus = false;

        TextInput {
            id: input
            //text: clock.clockName
            text: "Project name"
            font.pixelSize: 15
            color: clock.labelColor
            anchors.fill:  parent
            cursorVisible: false
            wrapMode: TextInput.WordWrap
            horizontalAlignment:  TextInput.AlignHCenter
            maximumLength: 50
        }

    }


    Menu{
        id: popupMenu

        MenuItem{
            text: "Enable seconds"
            onTriggered: {
                seeSeconds = !seeSeconds
                if (seeSeconds) text = "Disable seconds"
                else text = "Enable seconds"
             }
        }
        MenuItem{
            text: "Set color"
            onTriggered: colorDialog.visible = true;
        }

        MenuItem{
            text: "Set Name"
            onTriggered: {
                input.selectAll();
                input.focus = true;
            }
        }

        MenuItem{
            text: "Reset clock"
            onTriggered: {
                clock.time = -1;
                nextMoment();
                clock.run = false;
             }

        }

        MenuItem{
            text: "Remove clock"
            onTriggered: {
                Control.destroyItem(serialNr);
             }

        }

       style: menuStyle
    }


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





    Connections{
        target: mainItem
        onTimerStep: {clock.nextMoment()}
        onStartClocks: clock.run = true
        onStopClocks: clock.run = false
    }



    ColorDialog {
        id: colorDialog
        visible: false
        //modality: colorDialogModal.checked ? Qt.WindowModal : Qt.NonModal
        title: "Choose a color"
        color: "green"

        onAccepted: { fillColor = color; }
        onRejected: { console.log("Rejected") }
    }




}
