import QtQuick 2.0


Rectangle {
    id: popupMenu
    property alias model: rootListView.model
    signal popupMenuItemClicked(int index)

    property bool open : false
    opacity: 1
    z: 2
    color: "blue"
    visible: open

    MouseArea {
        anchors.fill: parent
        ListView {
            id: rootListView
            property int delegateHeight: 60
            spacing: 5
            anchors.centerIn: parent
            width: parent.width/2
            height: (delegateHeight+spacing)*count - spacing
            delegate: Item {
                id: delegateItem
                width: rootListView.width
                height: rootListView.delegateHeight
                Rectangle {
                    anchors.fill: parent
                    id: popupDelegateItem
                    radius: 10
                    color: popupMenu.color
                    Text {
                        text: name
                        color: "black"
                        font.pointSize: 15
                        anchors { centerIn: parent; margins: 10 }
                    }


                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: delegateItem.ListView.view.currentIndex = index
                    onClicked: {
                        popupMenuItemClicked(delegateItem.ListView.view.currentIndex);
                    }
                }
            }
        }

        onClicked: popupMenu.visible = false
    }
}
