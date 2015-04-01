import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "global.js" as Global
import "control.js" as Control

Rectangle {
    id: settingPanel

    property int yPos:200

    color:"#678080"
    width:400
    state: "SETTINGS_CLOSE"
    height: 150


    MouseArea{
        anchors.fill:settingPanel
        onClicked: settingPanel.state = "SETTINGS_CLOSE"
    }

    GridLayout{
        id: grid
        columns: 2
        anchors.fill: settingPanel

        CheckBox{
            id: countingRegime
            text: "Only one watch can go"
            checked: false;
        }

        CheckBox{
            id: enableSeconds
            text: "Enable seconds"
            checked: false;
        }
        CheckBox{
            id: loadSavedWatches
            text: "Load saved watches on start"
            checked: false;
        }

        ComboBox {
            id: themeChoice
            model: ["White","Dark"]
        }

        TextField {
            id: defaultName
            text:"Project name"
        }

        MenuButton{
            id: saveButton
            buttonText: "Save"
            onButtonClick: {
                Global.saveSettings(enableSeconds.checked,countingRegime.checked,loadSavedWatches.checked,
                                    themeChoice.currentText,defaultName.text);
                Control.writeSettingsToFile();
            }
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

