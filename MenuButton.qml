import QtQuick 2.0
import "global.js" as Global

Rectangle {
    id: button

    property int buttonWidth: 100
    property int buttonHeigth: 30
    property int buttonRadius: 6
/*
    property color fillColor: "#383838"
    property color borderColor: "transparent"
    property color onPressBorderColor: "white"
    property color onHoverFillColor: "#888888"
    property color labelColor: "white"

 */
    property color fillColor: Global.currentTheme.buttonFillColor
    property color borderColor: Global.currentTheme.buttonBorderColor
    property color onPressBorderColor: Global.currentTheme.buttonOnPressBorderColor
    property color onHoverFillColor: Global.currentTheme.buttonOnHoverFillColor
    property color labelColor: Global.currentTheme.buttonLabelColor


    function repaint() {
       button.fillColor = Global.currentTheme.buttonFillColor
       button.borderColor = Global.currentTheme.buttonBorderColor
       button.onPressBorderColor = Global.currentTheme.buttonOnPressBorderColor
       button.onHoverFillColor = Global.currentTheme.buttonOnHoverFillColor
       button.labelColor = Global.currentTheme.buttonLabelColor
       button.color = fillColor; //need for correct colour updating
    }

    //onColorChanged: console.log("Button color changed");

    property string buttonText: "Button"
    property int fontSize: 13
    signal buttonClick()

    width: buttonWidth
    height: buttonHeigth
    radius: buttonRadius
    smooth: true
    antialiasing: true

    //border.color: borderColor
    border.width: 2


    color: fillColor
    //color:buttonMouseArea.pressed ? Qt.darker(fillColor,1.5) : fillColor
    border.color:buttonMouseArea.pressed ? onPressBorderColor : borderColor
    Behavior on border.color {ColorAnimation { duration: 100 }}

    Text{
        anchors.centerIn: parent
        text: buttonText
        color: labelColor
        font.pointSize:  fontSize
        //font.capitalization: Font.SmallCaps
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
