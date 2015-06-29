import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import "global.js" as Global
import "control.js" as Control
import QtQuick.Controls.Private 1.0

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
    height: 200
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
    }


    MouseArea{
        anchors.fill:settingPanel
        onClicked: settingPanel.state = "SETTINGS_CLOSE"
    }

    GridLayout{
        id: grid
        columns: 1
        rowSpacing: 12
        columnSpacing: 30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
       // anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 30


        ColumnLayout{
            anchors.margins: 50
            id: colLayout

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

            Row {
                id : row1
                spacing: 40
                ComboBox {
                    id: themeChoice
                    model: [Control.whiteThemeName,Control.darkThemeName]
                    style: comboBoxMenuStyle
                    function repaint() {
                        //style = null
                        style = comboBoxMenuStyle
                    }

                }
                Text{
                    text: "Application theme "
                    font.pointSize: 11

                    color: Global.currentTheme.buttonLabelColor
                    function repaint() {
                        color = Global.currentTheme.buttonLabelColor
                    }

                }
            }
            Row{
                id : row2
                spacing: 40
                TextField {
                    id: defaultNameField
                    text:"Project name"
                    font.pointSize: 11
                    width: 130

                }
                Text{
                    text: "Default clock's name "
                    font.pointSize: 11
                    //font.capitalization: Font.SmallCaps
                    color: Global.currentTheme.buttonLabelColor
                    function repaint() {
                        color = Global.currentTheme.buttonLabelColor
                    }
                }
            }




        }









        MenuButton{
            id: saveButton
            buttonText: "Save"
            Layout.row : 1
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
           // anchors.leftMargin: 50
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
            //font.capitalization: Font.SmallCaps
            color: Global.currentTheme.buttonLabelColor
        }

    }


     property Component comboBoxMenuStyle: ComboBoxStyle {
        id: comboBox
        background: Rectangle {
            id: rect
            radius: 1
            border.width: 1
            border.color: control.activeFocus ? "#47b" : "#999"
            color: "#fff"
            implicitHeight: 14
            implicitWidth: 130
        }
        label: Text {
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 11
           // font.capitalization: Font.SmallCaps
            color: "black"
            text: control.currentText
        }

        property Component __dropDownStyle: MenuStyle {
            __maxPopupHeight: 600
            __menuItemType: "comboboxitem"

            frame: Rectangle {              // background
                color: Global.currentTheme.mainMenuBackColor
                border.width: 0
            }

            itemDelegate.label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 11
              //  font.capitalization: Font.SmallCaps
                //color: styleData.selected ? "white" : "black"
                color: Global.currentTheme.buttonLabelColor
                text: styleData.text
            }

            itemDelegate.background: Rectangle {  // selection of an item
                radius: 2
                color: styleData.selected ? Global.currentTheme.mainMenuOnHoverRowColor : Global.currentTheme.mainMenuRowColor
            }

            __scrollerStyle: ScrollViewStyle { }
        }

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







/*

            Row {
                id : row1
                function repaint() {
                   var children = row1.children;
                    for(var i = 0; i<children.length;++i) {
                        if (typeof (children[i].repaint) === "function")
                            children[i].repaint();
                    }
                }
                spacing: 40
                ComboBox {
                    id: themeChoice
                    model: [Control.whiteThemeName,Control.darkThemeName]
                    style: comboBoxMenuStyle
                    function repaint() {
                        //style = null
                        style = comboBoxMenuStyle
                    }

                }
                Text{
                    text: "Application theme "
                    font.pointSize: 11

                    color: Global.currentTheme.buttonLabelColor
                    function repaint() {
                        color = Global.currentTheme.buttonLabelColor
                    }

                }
            }
            Row{
                id : row2
                function repaint() {
                   var children = row2.children;
                    for(var i = 0; i<children.length;++i) {
                        if (typeof (children[i].repaint) === "function")
                            children[i].repaint();
                    }
                }
                spacing: 40
                TextField {
                    id: defaultNameField
                    text:"Project name"
                    font.pointSize: 11
                    width: 130

                }
                Text{
                    text: "Default clock's name "
                    font.pointSize: 11
                    //font.capitalization: Font.SmallCaps
                    color: Global.currentTheme.buttonLabelColor
                    function repaint() {
                        color = Global.currentTheme.buttonLabelColor
                    }
                }
            }

        }

*/
