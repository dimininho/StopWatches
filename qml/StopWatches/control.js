
var component;
var buttonObject;
//var parentItem = "layout"


function addButton(parentItem) {
    component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{});
}



