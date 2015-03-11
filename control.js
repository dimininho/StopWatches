
var component;
var buttonObject;
//var parentItem = "layout"
var serialNr = 0;
var maxQty = 5;
var watchesContainer = new Array(maxQty);

function initialize()
{
    watchesContainer = new Array(maxQty);
    console.log("RUN");
}


function addButton(parentItem) {
    ++serialNr;
    component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":mainItem.watchWidth,
                                                      "height":mainItem.watchWidth });

    watchesContainer[serialNr] = buttonObject;

    for(var i=0; i<maxQty;++i){
        console.log(watchesContainer[i] +"  n:" +i +"  +++");
    }
    if (serialNr==3) watchesContainer[1].destroy();
}

function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}

function destroyItem(number)
{
    for(var i=0; i<maxQty;++i){
        console.log(watchesContainer[i] +"  n:" +i +" ???");
    }
    watchesContainer[number].destroy();
    watchesContainer[number] = null;
}


