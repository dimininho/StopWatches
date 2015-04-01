import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    id: settingPanel
    color:"#678080"
    width:400
    y: -150
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
            checked: false;
        }

        CheckBox{
            id: enableSeconds
            checked: false;
        }
        CheckBox{
            id: loadSavedWatches
            checked: false;
        }

        ComboBox {
            id: themeChoice
            model: ["White","Dark"]
        }

        TextField {
            id: defaultName
        }
    }


    states: [
        State {
            name: "SETTINGS_OPEN"
            PropertyChanges {
                target: settingPanel
                y: mainPanel.height
            }
        },
        State {
            name: "SETTINGS_CLOSE"
            PropertyChanges {
                target: settingPanel
                y:-mainPanel.height
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

