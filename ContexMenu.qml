import QtQuick 2.2

Rectangle {
    id: contextMenuItem
    signal menuSelected(int index) // index{1: Select All, 2: Remove Selected}
    property bool isOpen: false
    property int  xPos: 0
    property int yPos :0

    x: xPos
    y: yPos
    width: 150
    height: menuHolder.height + 20
    visible: isOpen
    focus: isOpen
    border { width: 1; color: "#BEC1C6" }

    //onFocusChanged: {if (isOpen) isOpen = false; console.log("1");}
   // onActiveFocusChanged: {if (isOpen) isOpen = false; console.log("2"); }


    Column {
        id: menuHolder
        spacing: 1
        width: parent.width
        height: children.height * children.length
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 3 }

         ContextItem{
            id: selectedAll
            button_text: "Select All"
            index: 1
            onButtonClicked: {
                clicked = true;
                menuSelected(index);
                //console.log( "  focus" );
            }
        }

        ContextItem {
            id: removeSelected
            button_text: "Remove Selected"
            index: 2
            onButtonClicked: {
                clicked = true;
                menuSelected(index);
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: visible = false
        hoverEnabled: true
        onExited: visible = false;
        focus: isOpen
}

}
