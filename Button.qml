import QtQuick 2.0

Rectangle {
    id: button

    property int buttonWidth: 100
    property int buttonHeigth: 30

    property color fillColor: "#b3cbcc"
    property color borderColor: "transparent"
    property color onHoverBorderColor: "red"
     //property color onHoverBorderColor: "#b4c3d5"
    property color labelColor: "black"

    property string buttonText: "Button"
    property int fontSize: 13

    signal buttonClick()

    width: buttonWidth
    height: buttonHeigth
    radius: 6
    smooth: true
    antialiasing: true

    border.color: borderColor
    border.width: 2

    color:buttonMouseArea.pressed ? Qt.darker(fillColor,1.5) : fillColor
    Behavior on color {ColorAnimation { duration: 100 }}

    Text{
        anchors.centerIn: parent
        text: buttonText
        color: labelColor
        font.pointSize:  fontSize
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: buttonClick()

        onEntered: parent.border.color = onHoverBorderColor
        onExited: parent.border.color = borderColor
    }
}
