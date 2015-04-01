//.pragma library
.import "global.js" as Global


var component;
var buttonObject;
//var parentItem = "layout"
var maxQty = 7;
var serialNr = Global.serialNr;
var endingChar = "#^#"
var watchesPropeties = new Array();
var settingFile = "settings.txt"

function WatchType(object){
    this.number = object.serialNr;
    this.name = object.watchName;
    this.color = object.fillColor;
    this.time = object.time
}


function addButton(parentItem,main) {

    if (component === undefined)
        component = Qt.createComponent("Watch.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.watchWidth,
                                                      "height":main.watchWidth,
                                                      "watchName":Global.settings.defName,
                                                      "seeSeconds": Global.settings.enableSeconds});

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
                    +Global.watchesContainer[i].watchName + " " + endingChar + " "
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
    var number,name,fillcolor,labelcolor,run,seeSecs,time,subname;
    var i=0;
    var reading = true;

    if (component == null)
        component = Qt.createComponent("Watch.qml");

    removeAllWatches();

    while (reading)
    {
        ++i;
        number = fileio.read(fileName);
        //name = fileio.read(fileName);
        name = "";
        subname = fileio.read(fileName);
        while(subname && subname !== endingChar)
        {
            name += subname + " ";
            subname = fileio.read(fileName);
        }

        fillcolor = fileio.read(fileName);
        labelcolor = fileio.read(fileName);
        run = (fileio.read(fileName)==="true");
        seeSecs = (fileio.read(fileName)==="true");
        time = fileio.read(fileName);

        //console.log(number + " " + name + " " +fillcolor + " " + labelcolor  + " " + run  + " " + seeSecs  + " " +time);
        reading = ((fillcolor) ? true : false);

        if (reading){
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
}



function writeSettingsToFile() {

    var settingsData = "";
    settingsData = Global.settings.enableSeconds + " "
                +Global.settings.onlyOneRun + " "
                +Global.settings.loadOnStart + " "
                +Global.settings.theme + " "
                +Global.settings.defName +"\n";
    fileio.write(settingFile,settingsData);
}



function loadSettings() {
    var subName,name = "";

    Global.settings.enableSeconds = fileio.read(settingFile);
    Global.settings.onlyOneRun = fileio.read(settingFile);
    Global.settings.loadOnStart = fileio.read(settingFile);
    Global.settings.theme = fileio.read(settingFile);
    do{
        subname = fileio.read(settingFile);
        name += subname;
    }while(subName);
    Global.settings.defName = name;
}
