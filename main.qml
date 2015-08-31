import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.LocalStorage 2.0
import "control.js" as Control
import "global.js" as Global
import QtQuick.Controls.Styles 1.3

Window {
    id: mainItem

    property int clockWidth: 180
    property Component menuStyle: PopupMenuStyle {}

    width:500
    height: 500
    minimumWidth: clockWidth + 20
    minimumHeight: clockWidth + 100
    visible: true
    color: Control.currentTheme.mainItemColor

   // flags: Qt.FramelessWindowHint;

    //width: JS.getSettings(windowWidth)

    MouseArea {
        anchors.fill: parent

    }

    signal timerStep    //signal to clocks
    onTimerStep: {}
    signal startClocks
    onStartClocks: {}
    signal stopClocks
    onStopClocks: {}
    signal showStatistics
    signal newDay


    //calls when theme changes
    //if item should redraws after theme changing, it must contains repaint() function
    //repaintMain() calls all repaint()s  from window.
    function repaintMain() {

        function repaintInner(parentItem) {
            if (typeof (parentItem.repaint) === "function")
                                  parentItem.repaint();
            var children = parentItem.children
            for(var i = 0; i<children.length;++i)
                    repaintInner( children[i]);

        }
        mainItem.color = Global.currentTheme.mainItemColor;
        repaintInner(mainItem.contentItem);

    }



    Timer{
        id: mainTimer
        interval: 1000
        running: true
        repeat:true
        onTriggered: {
            mainItem.timerStep();
            var time = new Date();
            var timestr = "" + time.getHours() + time.getMinutes() + time.getSeconds();
            if (timestr === "235958") mainItem.newDay();
        }
    }


    Rectangle {
        id: mainPanel
        width: mainItem.width
        height: 50
        color: Control.currentTheme.mainPanelColor
        //color: "white"
        anchors.top: parent.top
        z:2

        function repaint() {
           mainPanel.color = Global.currentTheme.mainPanelColor
        }



        GridLayout{
            id: rowlayout
            rowSpacing:  20
            //columns: 2
            anchors.verticalCenter:  mainPanel.verticalCenter
           // anchors.horizontalCenter: mainPanel.horizontalCenter
            anchors.left: mainPanel.left
            anchors.right: mainPanel.right

        Button {
            id: mainMenuButton
            menu: mainMenu
            Layout.alignment: Qt.AlignLeft
            style: menuButtonStyle
            iconSource: "./img/" + Control.currentTheme.mainMenuIcon
            //anchors.verticalCenter:  mainPanel.verticalCenter

            function repaint() {
              iconSource =  "./img/" + Global.currentTheme.mainMenuIcon;
              style = null;
              style = menuButtonStyle; //need for correct updating
            }

        }


            MenuButton{
                id: startButton
                buttonText: "Start all"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onButtonClick: {
                    mainItem.startClocks()
                }
            }

            MenuButton  {
                id: stopButton
                buttonText: "Stop all"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onButtonClick: {
                    mainItem.stopClocks()
                }
            }

            MenuButton  {
                id: addNew
                buttonText: "Add new"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onButtonClick: {
                    Control.addClock(layout,mainItem);
                }
            }
        }

        //}
        /*
        Rectangle {
            width: mainPanel.width
            height:3
            anchors.bottom: mainPanel.bottom
            color: "blue"
            visible: (Global.settings.theme==="White") ? true : false
            function repaint() {
                visible = (Global.settings.theme==="White") ? true : false
            }
        }*/

    }



    Menu{
        id: mainMenu
        style:  PopupMenuStyle {}

        MenuItem{
            text: "Save clocks"
            onTriggered: {
                Control.writeClocksToFile();
             }
        }
        MenuItem{
            text: "Load clocks"
            onTriggered: {
                Control.readClocksFromFile(layout);
             }
        }
        MenuItem{
            text: "Settings"
            onTriggered: {
                settingPanel.state = "SETTINGS_OPEN"
             }
        }
        MenuItem{
            text: "Statistics"
            onTriggered: {
                statisticsWnd.show();
                mainItem.showStatistics();
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
        id: menuButtonStyleID
        background: Rectangle {
            implicitHeight: 30
            implicitWidth: 50
            color:  control.hovered ? Global.currentTheme.buttonOnHoverFillColor :  Global.currentTheme.mainPanelColor
            //color: control.pressed ? "green" :  "#383838"
            antialiasing: true
            border.color: "transparent"
            radius: 5

        }


    }


    SettingsPanel{
        id: settingPanel
        z: 1        //above mainItem
        width: mainItem.width
        yPos: mainPanel.height
        anchors.left: mainItem.left
        anchors.right: mainItem.right
        //state:"SETTINGS_CLOSE"
    }

    Statistics {
        id: statisticsWnd
    }

    ScrollView{
        width: mainItem.width
        height:mainItem.height
        anchors.top: settingPanel.bottom
        anchors.left:  mainItem.contentItem.left
        anchors.right: mainItem.contentItem.right
        //anchors.horizontalCenter: mainItem.contentItem.horizontalCenter
        //anchors.verticalCenter:  mainItem.contentItem.verticalCenter
        anchors.margins: 10


        GridLayout {

            id:layout
            property int colNumber: 2
            rowSpacing: 10
            columnSpacing: 10
            //Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            columns: colNumber
        }
    }


    onWidthChanged: {
         layout.colNumber = mainItem.width / mainItem.clockWidth;
    }


    function checkDB() {// Create the database if it hasn't already exist
        var db = LocalStorage.openDatabaseSync("ClocksData", "1.0", "The data of clock working", 10001);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Data(date DATE, name CHAR,serialNr SMALLINT,startTime TIME, endTime TIME)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(enableSeconds TINYTEXT, onlyOneRun TINYTEXT,loadOnStart TINYTEXT,theme TINYTEXT, themeNr SMALLINT, defName TINYTEXT, exportFolder TINYTEXT)');
                var rws =tx.executeSql('SELECT * FROM Settings')
                if (rws.rows.length===0)
                    tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ? ,?,?,?)', ["false" ,"false","false","Blue","1","Task","/C:progrma files"]);
            }
         )
    }

    onSceneGraphInitialized:  {
       Control.loadSettingsFromFile();
       settingPanel.setSettingToPanel();
       if (Control.settings.loadOnStart)
           Control.readClocksFromFile(layout);
       else
           Control.addClock(layout,mainItem);
       checkDB();
    }



    onNewDay: Control.clockDoubleClick(true);           //save current clocks to DB with delay

    Component.onDestruction: Control.clockDoubleClick(false);//save current clocks to DB

}

