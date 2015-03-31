import QtQuick 2.0

Rectangle {
    id: settingPanel
    color:"#678080"
    //width: mainItem.width
    state: "SETTINGS_CLOSE"
    height: 150


    MouseArea{
        anchors.fill:settingPanel
        onClicked: settingPanel.state = "SETTINGS_CLOSE"
    }

    states: [
        State {
            name: "SETTINGS_OPEN"
            PropertyChanges {
                target: settingPanel
                height: 150
            }
        },
        State {
            name: "SETTINGS_CLOSE"
            PropertyChanges {
                target: settingPanel
                height:0
            }
        }
    ]
    transitions: [
        Transition {
            to: "*"
            NumberAnimation{
                target: settingPanel
                properties: "height"
                duration: 300
                easing.type: Easing.OutExpo
            }

        }
    ]
}

