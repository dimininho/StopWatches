import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import "control.js" as Control
import "global.js" as Global

import QtQuick.Controls.Styles 1.3

Window {
    id: mainItem

    property int clockWidth: 180

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

    function repaint() {
       mainItem.color = Global.currentTheme.mainItemColor
       var children = mainItem.contentItem.children;
        for(var i = 0; i<children.length;++i) {
           console.log(children[i]);

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
               console.log("  ++ " + children[i]);

                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();

            }
            //sceneGraphInvalidated();
            //colorChanged("red");
        }
        //Only items which specifies QQuickItem::ItemHasContents are allowed to call QQuickItem::update().

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
           // iconSource: mainItem.width>400 ? "./img/black_menu1.png" : "./img/white_menu1.png"
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
                   console.log("  +*+ " + children[i]);

                    if (typeof (children[i].repaint) === "function")
                        children[i].repaint();
                }

            }

            MenuButton{
                id: startButton
                buttonText: "Start all"
                onButtonClick: {
                    //  mainTimer.start()
                    mainItem.startClocks()

                }
            }

            MenuButton  {
                id: stopButton
                buttonText: "Stop all"
                onButtonClick: {
                    //mainTimer.stop()
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
        style:  menuStyle

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
        Control.addClock(layout,mainItem);
        if (Control.settings.loadOnStart)
            Control.readClocksFromFile(layout);
    }


    //onBeforeRendering:  {       // Control.loadSettingsFromFile();
       // settingPanel.setSettingToPanel();}



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



}
