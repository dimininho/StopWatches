//.pragma library
.import "global.js" as Global

var component;
var buttonObject;
//var parentItem = "layout"
var maxQty = 7;
var serialNr = Global.serialNr;


function addButton(parentItem,main) {
    ++serialNr;
    if (component == null)
        component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.watchWidth,
                                                      "height":main.watchWidth });

    Global.watchesContainer[serialNr] = buttonObject;
/*
    for(var i=0; i<maxQty;++i){
        console.log(watchesContainer[i] +"  n:" +i +"  +++");
    }
*/
}

/*
function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}
*/


function destroyItem(number)
{
   Global.watchesContainer[number].destroy();
   Global.watchesContainer[number] = null;
}
