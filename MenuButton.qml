import QtQuick 2.0

Rectangle {
    id: button

    property int buttonWidth: 100
    property int buttonHeigth: 30

    property color fillColor: "#383838"
    property color borderColor: "transparent"
    property color onHoverBorderColor: "#888888"
    property color onHoverFillColor: "#888888"
    property color labelColor: "white"

    property string buttonText: "Button"
    property int fontSize: 13

    signal buttonClick()

    width: buttonWidth
    height: buttonHeigth
    radius: 6
    smooth: true
    antialiasing: true

    //border.color: borderColor
    border.width: 2


    color: fillColor
    //color:buttonMouseArea.pressed ? Qt.darker(fillColor,1.5) : fillColor
    border.color:buttonMouseArea.pressed ? "white" : borderColor
    Behavior on border.color {ColorAnimation { duration: 100 }}

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

        onEntered: parent.color = onHoverFillColor
        onExited: parent.color = fillColor
    }
}
