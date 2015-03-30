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

    if (component == null)
        component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.watchWidth,
                                                      "height":main.watchWidth});

   // Global.watchesContainer[serialNr] = buttonObject;
    Global.watchesContainer.push(buttonObject);
    ++serialNr;

    for(var i=0; i<maxQty;++i){
        //console.log(Global.watchesContainer[i] +"  n:" +i +"  +++");
    }

}

/*
function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}
*/


function destroyItem(number)
{
   Global.watchesContainer[number].destroy();
   //Global.watchesContainer[number] = null;
   delete Global.watchesContainer[number];

}

function removeAllWatches()
{
    for(var i=0; i< Global.watchesContainer.length;++i)
    {
        if (Global.watchesContainer[i])
            destroyItem(i);
    }
}


function writeWatchesToFile()
{

    var watchesData = "";
    for(var i=0;i<Global.watchesContainer.length; ++i)
    {
        if (Global.watchesContainer[i]) {
        watchesData+=Global.watchesContainer[i].serialNr + " "
                    +Global.watchesContainer[i].watchName + " "
                    +Global.watchesContainer[i].fillColor + " "
                    +Global.watchesContainer[i].labelColor + " "
                    +Global.watchesContainer[i].run + " "
                    +Global.watchesContainer[i].seeSeconds + " "
                    +Global.watchesContainer[i].time +  " \n" ;
        }
    }
    fileio.write("watches.txt",watchesData);
}


function readWatchesFromFile(parentItem)
{
    var fileName = "watches.txt";
    var number,name,fillcolor,labelcolor,run,seeSecs,time;
    var i=0;

    if (component == null)
        component = Qt.createComponent("Watch.qml");

    removeAllWatches();

    while (i<5)
    {
        ++i;
        number = fileio.read(fileName);
        name = fileio.read(fileName);
        fillcolor = fileio.read(fileName);
        labelcolor = fileio.read(fileName);
        run = (fileio.read(fileName)==="true");
        seeSecs = (fileio.read(fileName)==="true");
        time = fileio.read(fileName);

        //console.log(number + " " + name + " " +fillcolor + " " + labelcolor  + " " + run  + " " + seeSecs  + " " +time);


        buttonObject = component.createObject(parentItem,{
                                                          "serialNr": i,
                                                          "watchName": name,
                                                          "fillColor": fillcolor,
                                                          "labelColor": labelcolor,
                                                          "run": run,
                                                          "seeSeconds": seeSecs,
                                                          "time": time      });

        Global.watchesContainer.push(buttonObject);
    }
}
