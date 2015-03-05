
var component;
var buttonObject;
//var parentItem = "layout"


function addButton(parentItem) {
    component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{"width":mainItem.watchWidth,
                                                      "height":mainItem.watchWidth });
}

function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}


