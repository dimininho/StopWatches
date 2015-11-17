import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "control.js" as Control
import QtQuick.Controls.Styles 1.3
import QtQuick.LocalStorage 2.0
import "global.js" as Global

Rectangle {
    id: clock
    property int serialNr:0

    property alias clockName: input.text
    property int min: 0
    property int hour: 0
    property int sec: 0
    property int time: 0
    property bool seeSeconds: false
    property string startTime: ""
    property string endTime: ""
    property bool run: false

    property color fillColor: Control.currentTheme.clockFillColor;
    property color labelColor: Control.currentTheme.clockLabelColor
    property int clockWidth:180



    function writeTime(date,name,serialNr,startTime,endTime) {
        var db = LocalStorage.openDatabaseSync("ClocksData", "1.0", "The data of clock working", 10001);

        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS Data(date DATE, name CHAR,serialNr SMALLINT,startTime TIME, endTime TIME)');
                tx.executeSql('INSERT INTO Data VALUES(?, ?, ?, ? ,?)', [date ,name,serialNr,startTime,endTime]);

            }
         )
    }

    function calculateTime() {
        var temptime = time;
        hour = temptime/3600;
        temptime -= hour*3600;
        min = temptime/60;
        temptime -= min*60;
        sec = temptime;
    }


    function nextMoment() {
        if (clock.run==true)
        {
            ++time;
            calculateTime();
            //console.log(time + "    m" + min + "  s" + sec);
        }
    }



    function whenRunChanged() {
        var moment = new Date();
        var hour = moment.getHours();
        if (hour<10) hour = "0"+hour; //problems with reading of DB

        if(clock.run) {
            startTime = hour + ":" + moment.getMinutes() +":" + moment.getSeconds();
        } else {
            endTime = hour + ":" + moment.getMinutes() +":" + moment.getSeconds();
            writeTime(moment.toLocaleDateString(Qt.locale(),"yyyy-MM-dd") ,
                      clock.clockName,clock.serialNr,startTime,endTime);
        }
    }

    onRunChanged: {
        whenRunChanged();
    }


    width: 180
    height: 180
    color: fillColor
    /*
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.lighter(fillColor, 1.3) }
        GradientStop { position: 0.67; color: Qt.darker(fillColor, 1.35) }
    }
    */
    radius: 10
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
        width:9
        height: 9
        radius: 2
        anchors{
            top:clock.top
            right:clock.right
            rightMargin: 15
            topMargin: 15
        }
        color: clock.run ? Control.currentTheme.clockIndicatorColor : Control.currentTheme.clockIndicatorOffColor

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
            //MS Shell Dlg 2
            text: "Project name"
            font.pixelSize: 15
            color: clock.labelColor
            anchors.fill:  parent
            cursorVisible: false
            wrapMode: TextInput.WordWrap
            horizontalAlignment:  TextInput.AlignHCenter
            maximumLength: 50
            //Component.onCompleted: console.log(text.length);
        }

    }


    Menu{
        id: popupMenu

        MenuItem{
            text: "Show seconds"
            onTriggered: {
                seeSeconds = !seeSeconds
                if (seeSeconds) text = "Hide seconds"
                else text = "Show seconds"
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
                input.forceActiveFocus();
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

       style: PopupMenuStyle {}
    }




    Connections{
        target: mainItem
        onTimerStep: {clock.nextMoment()}
        onStartClocks: clock.run = true
        onStopClocks: clock.run = false       
    }
    Connections{
        target: settingPanel
        onShowSeconds: clock.seeSeconds = Global.settings.enableSeconds
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

    Component.onCompleted: {
        //for updating label after loading from file
        calculateTime();
    }


}
