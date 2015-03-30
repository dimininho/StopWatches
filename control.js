//.pragma library
.import "global.js" as Global


var component;
var buttonObject;
//var parentItem = "layout"
var maxQty = 7;
var serialNr = Global.serialNr;
var watchesPropeties = new Array();

function WatchType(object){
    this.number = object.serialNr;
    this.name = object.watchName;
    this.color = object.fillColor;
    this.time = object.time
}


function addButton(parentItem,main) {
    ++serialNr;
    if (component == null)
        component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.watchWidth,
                                                      "height":main.watchWidth});

   // Global.watchesContainer[serialNr] = buttonObject;
    Global.watchesContainer.push(buttonObject);

    for(var i=0; i<maxQty;++i){
        console.log(Global.watchesContainer[i] +"  n:" +i +"  +++");
    }

}

/*
function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}
*/


function destroyItem(number)
{
   Global.watchesContainer[number-1].destroy();
   //Global.watchesContainer[number] = null;
   delete Global.watchesContainer[number-1];

    for(var i=0; i<Global.watchesContainer.length;++i){
        console.log(Global.watchesContainer[i] +"  n:" +i + "  ser: " + Global.watchesContainer.serialNr+"  ---");
    }
}


function writeWatchesToFile()
{
    for(var i=0; i<5;++i){
        //console.log(Global.watchesContainer[i] +"  n:" +i +"  +++");
    }

    var watchesData = "";
    for(var i=0;i<Global.watchesContainer.length; ++i)
    {
        if (Global.watchesContainer[i]) {
        watchesData+=Global.watchesContainer[i].serialNr + " "
                    +Global.watchesContainer[i].watchName + " "
                    +Global.watchesContainer[i].fillColor + " "
                    +Global.watchesContainer[i].time +  " \n" ;
        }
    }
    fileio.write("watches.txt",watchesData);
}
