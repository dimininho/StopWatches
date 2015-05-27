import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.LocalStorage 2.0
import "control.js" as Control
import "global.js" as Global
//import "Statistics.qml" as Statistics
//import "../" as Root

import QtQuick.Controls.Styles 1.3

Window {
    id: mainItem

    property int clockWidth: 180
    property Component menuStyle: PopupMenuStyle {}

    width:500
    height: 500
    minimumWidth: clockWidth
    minimumHeight: clockWidth
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

    function repaint() {
       mainItem.color = Global.currentTheme.mainItemColor
       var children = mainItem.contentItem.children;
        for(var i = 0; i<children.length;++i) {
            if (typeof (children[i].repaint) === "function")
                children[i].repaint();
        }
    }

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
        color: Control.currentTheme.mainPanelColor
        anchors.top: parent.top
        z:2

        function repaint() {
           mainPanel.color = Global.currentTheme.mainPanelColor
           var children = mainPanel.children;
            for(var i = 0; i<children.length;++i) {
                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();
            }
        }


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
            iconSource: "./img/" + Control.currentTheme.mainMenuIcon
            //iconSource: "./img/white_menu1.png"          
            anchors.left:mainPanel.left
            anchors.verticalCenter:  mainPanel.verticalCenter

            function repaint() {
              iconSource =  "./img/" + Global.currentTheme.mainMenuIcon;
              style = null;
              style = menuButtonStyle; //need for correct updating
            }

        }

        Row{
           // anchors.top : parent.top
            //anchors.horizontalCenter:  mainPanel.horizontalCenter
            //anchors.centerIn:  mainPanel
            anchors.verticalCenter:  mainPanel.verticalCenter
            anchors.horizontalCenter: mainPanel.horizontalCenter
            anchors.left: mainMenuButton.right

            spacing: 20


            function repaint() {
               var children = this.children;
                for(var i = 0; i<children.length;++i) {
                    if (typeof (children[i].repaint) === "function")
                        children[i].repaint();
                }
            }

            MenuButton{
                id: startButton
                buttonText: "Start all"
                onButtonClick: {
                    mainItem.startClocks()
                }
            }

            MenuButton  {
                id: stopButton
                buttonText: "Stop all"
                onButtonClick: {
                    mainItem.stopClocks()
                }
            }

            MenuButton  {
                id: addNew
                buttonText: "Add new"
                onButtonClick: {
                    Control.addClock(layout,mainItem);
                }
            }
        }

        //}

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
        MenuItem{
            text: "Write SQL"
            onTriggered: {
                var db = LocalStorage.openDatabaseSync("SQLQML", "1.0", "The Example QML SQL!", 1000000);

                db.transaction(
                    function(tx) {
                        // Create the database if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS TestDB2(name TEXT, time INT,date DATE)');

                        // Add (another) greeting row
                        tx.executeSql('INSERT INTO TestDB2 VALUES(?, ?, ?)', [ 'task2', 12,'2000-04-20']);


                    }
                )
            }
        }
        MenuItem{
            text: "REad SQL"
            onTriggered: {
                var db = LocalStorage.openDatabaseSync("SQLQML", "1.0", "The Example QML SQL!", 1000000);

                db.transaction(
                    function(tx) {

                        // Show all added greetings
                        var rs = tx.executeSql('SELECT * FROM TestDB2');

                        var r = ""
                        for(var i = 0; i < rs.rows.length; i++) {
                            r += rs.rows.item(i).name + " : " + rs.rows.item(i).time + "  "+rs.rows.item(i).date + "\n"
                        }
                        console.log(r);
                    }
                )
             }
        }

        MenuItem{
            text: "REad DATA"
            onTriggered: {
                 var db = LocalStorage.openDatabaseSync("ClocksData", "1.0", "The data of clock working", 10001);

                db.transaction(
                    function(tx) {
                        var curDate = " '2015-05-25' " ;
                        var query = "SELECT serialNr,name
                                     FROM Data WHERE date= " +curDate +
                                    " GROUP BY serialNr,name";
                        //console.log(query);

                        var rs = tx.executeSql(query);
                        var rs2;

                        var r = ""
                        for(var i = 0; i < rs.rows.length; i++) {
                            r += rs.rows.item(i).serialNr + " : " + rs.rows.item(i).name + "\n"
                            query = "SELECT startTime,endTime
                                     FROM Data WHERE date= " +curDate +
                                            "AND name= '" +rs.rows.item(i).name +"' "+
                                            "AND serialNr = '" + rs.rows.item(i).serialNr + "'";
                            rs2 = tx.executeSql(query);
                            for (var j = 0; j<rs2.rows.length; j++) {
                                r+=rs2.rows.item(j).startTime + " - " + rs2.rows.item(j).endTime+ "\n";
                            }
                            r+="---------\n";
                        }
                        console.log(r);
                    }
                )
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

    GridLayout {
        id:layout
        property int colNumber: 2
        anchors.top: settingPanel.bottom
        //anchors.top :mainPanel.bottom
        anchors.left: mainItem.left
        anchors.right: mainItem.right
        columns: colNumber


    }


    onWidthChanged: {
       // Control.changeColumnsNumber()
         layout.colNumber = mainItem.width / mainItem.clockWidth;
    }

    onSceneGraphInitialized:  {
       // Control.initializeSettings();
      Control.loadSettingsFromFile();
       settingPanel.setSettingToPanel(); 
        if (Control.settings.loadOnStart)
            Control.readClocksFromFile(layout);
        else
            Control.addClock(layout,mainItem);
    }



}
