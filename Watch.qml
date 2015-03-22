import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "control.js" as Control
import QtQuick.Controls.Styles 1.1


Rectangle {
    id: watch
    property int serialNr:0

    property string watchName: "Project name"
    property int min: 0
    property int hour: 0
    property int sec: 0
    property int time: 0
    property bool seeSeconds: false

    property bool run: false

    property color fillColor: "lightsteelblue"


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


    width: 200
    height: 200
    radius: 26
    border.width: 0
    border.color: "#1b50da"

    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.lighter(fillColor, 1.3) }
        GradientStop { position: 0.67; color: Qt.darker(fillColor, 1.35) }
    }
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        onClicked: {
            if (mouse.button == Qt.RightButton) {
                popMenu.x = mouseX;
                popMenu.y = mouseY;
                popMenu.isOpen = true //popupMenu.popup(mouseX,mouseY);
            }
            if (mouse.button == Qt.LeftButton)  watch.run = !watch.run;
        }

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


    Menu{
        id: popupMenu
        MenuItem{
            text: "Set color"
            onTriggered: colorDialog.visible = true;
        }
        MenuItem{
            text: "Enable seconds"
            onTriggered: {
                seeSeconds = !seeSeconds
                if (seeSeconds) text = "Disable seconds"
                else text = "Enable seconds"
             }
        }
        MenuItem{
            text: "Set Name"
            onTriggered: console.log(watch.serialNr + "  ----------");
        }

        MenuItem{
            text: "Remove watch"
            onTriggered: {
                //var itemId = parent.parent.id
                Control.destroyItem(serialNr);
             }
        }


       // visible: true
    }


    ContexMenu {
        id: popMenu
    }
/*
    PMenu {
       // onItemClicked: myText.text = "clicked red item: " + index
        id: pMenu

        model: ListModel {
        ListElement {name: "Red Item 0"}
        ListElement {name: "Red Item 1"}
        ListElement {name: "Red Item 2"}
        }
    }
*/
    Component{
        id:menuStyle
        Rectangle{
            color: "green"
            width: 50
            height: 100
            visible: true
        }

    }





    Connections{
        target: mainItem
        onTimerStep: {watch.nextMoment()}
        onStartWatches: watch.run = true
        onStopWatches: watch.run = false
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
