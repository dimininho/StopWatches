import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import "global.js" as Global
import "control.js" as Control

Rectangle {
    id: settingPanel

    property int yPos:200
/*
    property alias onlyOne: countingRegime.checked
    property alias enableSeconds: enableSecs.checked
    property alias loadSavedClocks: loadSavedClocks.checked
    property alias defaultName: defaultNameField.text
    property alias theme: themeChoice.currentText   */

    color: Global.currentTheme.settingsPanelColor
    width:400
    state: "SETTINGS_CLOSE"
    height: 150
    clip: true

    function setSettingToPanel() {
       countingRegime.checked = Global.settings.onlyOneRun;
       enableSecs.checked = Global.settings.enableSeconds;
       loadSavedClocks.checked = Global.settings.loadOnStart;
       defaultNameField.text = Global.settings.defName;
       themeChoice.currentIndex = Global.settings.themeNr;
    }

    function repaint() {
       settingPanel.color = Global.currentTheme.settingsPanelColor
       var children = settingPanel.children;
        for(var i = 0; i<children.length;++i) {
            if (typeof (children[i].repaint) === "function")
                children[i].repaint();
        }
    }


    MouseArea{
        anchors.fill:settingPanel
        onClicked: settingPanel.state = "SETTINGS_CLOSE"
    }

    GridLayout{
        id: grid
        //columns: 2
        //anchors.centerIn:  settingPanel
        rowSpacing: 12
        columnSpacing: 30
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 30

        function repaint() {
           var children = grid.children;
            for(var i = 0; i<children.length;++i) {
                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();
            }
        }

        ColumnLayout{
            anchors.margins: 50
            id: colLayout

            function repaint() {
               var children = colLayout.children;
                for(var i = 0; i<children.length;++i) {
                    if (typeof (children[i].repaint) === "function")
                        children[i].repaint();
                }
            }

            CheckBox{
                id: countingRegime
                text: "Only one clock can go"
                checked: false;
                style:  checkBoxMenuStyle
                function repaint() {
                    style = null
                    style = checkBoxMenuStyle
                }

            }

            CheckBox{
                id: enableSecs
                text: "Enable seconds"
                checked: false;
                style:  checkBoxMenuStyle
                function repaint() {
                    style = null
                    style = checkBoxMenuStyle
                }

            }
            CheckBox{
                id: loadSavedClocks
                text: "Load saved clocks on start"
                checked: false;
                style:  checkBoxMenuStyle
                function repaint() {
                    style = null
                    style = checkBoxMenuStyle
                }

            }


        }

        Column {
            ComboBox {
                id: themeChoice
                model: [Control.whiteThemeName,Control.darkThemeName]
                style: comboBoxMenuStyle
                function repaint() {
                    style = null
                    style = comboBoxMenuStyle
                }

            }

            TextField {
                id: defaultNameField
                text:"Project name"
                font.pointSize: 11

            }
        }

        MenuButton{
            id: saveButton
            buttonText: "Save"
            Layout.row : 1
            onButtonClick: {
                Control.saveSettings(enableSecs.checked,countingRegime.checked,loadSavedClocks.checked,
                                    themeChoice.currentText,themeChoice.currentIndex,defaultNameField.text);
                Control.writeSettingsToFile();
                //settingPanel.update();
                settingPanel.state = "SETTINGS_CLOSE";
            }
        }
    }


    property Component checkBoxMenuStyle:CheckBoxStyle {
        id : checkBoxMenuStyleID
        indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                radius: 3
                border.color: "gray"
                border.width: 1
                Rectangle {
                    visible: control.checked
                    color: "#555"
                    border.color: "#333"
                    radius: 2
                    anchors.margins: 4
                    anchors.fill: parent
                }
        }
        label: Text {
            text: control.text
            font.pointSize: 11
            color: Global.currentTheme.buttonLabelColor
        }
    }

//http://stackoverflow.com/questions/27089779/qml-combobox-item-dropdownmenu-style
     property Component comboBoxMenuStyle: ComboBoxStyle {
        id: comboBoxMenuStyle
        //textColor: Global.currentTheme.buttonLabelColor
        panel: Rectangle {
            color: "magenta"
            width: 150
            height: 50
        }
        label: Rectangle {
           // text: control.text

            color: "#38d8e6"
            Text {
                text: control.currentText
                color: "green"
            }
        }
        /*
        background: Rectangle {
            color: "magenta"
            width: 150
            height: 50
        }*/

    }


    states: [
        State {
            name: "SETTINGS_OPEN"
            PropertyChanges {
                target: settingPanel
                y: settingPanel.yPos
            }
        },
        State {
            name: "SETTINGS_CLOSE"
            PropertyChanges {
                target: settingPanel
                y:settingPanel.yPos - settingPanel.height
            }
        }
    ]
    transitions: [
        Transition {
            to: "*"
            NumberAnimation{
                target: settingPanel
                properties: "y"
                duration: 300
                easing.type: Easing.OutExpo
            }

        }
    ]
}

