//.pragma library
.import "global.js" as Global


var component;
var buttonObject;
//var parentItem = "layout"
var maxQty = 7;
var serialNr = Global.serialNr;
var endingChar = "#^#"
var settingFile = "settings.txt"
var fileName = "watches.txt";
//var currentTheme = new Global.Theme();
var currentTheme = Global.currentTheme;

var settings = Global.settings;
var watchesContainer = Global.watchesContainer;
var darkThemeName = "Dark";
var whiteThemeName = "White";

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
                                                      "watchName":settings.defName,
                                                      "seeSeconds": settings.enableSeconds});

   // Global.watchesContainer[serialNr] = buttonObject;
    watchesContainer.push(buttonObject);
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
   watchesContainer[number].destroy();
   //watchesContainer[number] = null;
   delete watchesContainer[number];

}

function removeAllWatches()
{
    for(var i=0; i< Global.watchesContainer.length;++i)
    {
        if (watchesContainer[i])
            destroyItem(i);
    }
}


function writeWatchesToFile()
{

    var watchesData = "";
    for(var i=0;i<watchesContainer.length; ++i)
    {
        if (watchesContainer[i]) {
        watchesData+=watchesContainer[i].serialNr + " "
                    +watchesContainer[i].watchName + " " + endingChar + " "
                    +watchesContainer[i].fillColor + " "
                    +watchesContainer[i].labelColor + " "
                    +watchesContainer[i].run + " "
                    +watchesContainer[i].seeSeconds + " "
                    +watchesContainer[i].time +  " \n" ;
        }
    }
    fileio.write(fileName,watchesData);
}


function readWatchesFromFile(parentItem)
{
    var number,name,fillcolor,labelcolor,run,seeSecs,time,subname;
    var i=0;
    var reading = true;

    if (component == null)
        component = Qt.createComponent("Watch.qml");

    removeAllWatches();

    fileio.resetStream();

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

        console.log(number + " " + name + " " +fillcolor + " " + labelcolor  + " " + run  + " " + seeSecs  + " " +time);
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

            watchesContainer.push(buttonObject);
        }

    }
}


function initializeSettings() {
    settings = new Global.Settings(false,false,false,"Dark",1,"Task");
}


function saveSettings(enableSeconds,onlyOneRun,loadOnStart,theme,themeNr,defName){
    settings.enableSeconds = enableSeconds;
    settings.onlyOneRun = onlyOneRun;
    settings.loadOnStart = loadOnStart
    settings.theme = theme
    settings.themeNr = themeNr
    settings.defName = defName

    Global.changeTheme(theme);

    console.log(currentTheme.mainItemColor);

    //mainItem.update();
   // mainItem.changeColor();
   // mainItem.color = Global.currentTheme.mainItemColor;
}



function writeSettingsToFile() {

    var settingsData = "";
    settingsData = settings.enableSeconds + " "
                +settings.onlyOneRun + " "
                +settings.loadOnStart + " "
                +settings.themeNr + " "
                +settings.defName +"\n";
    fileio.write(settingFile,settingsData);

}



function loadSettingsFromFile() {
    var subName,name = "";
    var temp = "";

    fileio.resetStream();

    if (fileio.exist(settingFile))  {
        settings.enableSeconds = (fileio.read(settingFile)==="true");
        settings.onlyOneRun = (fileio.read(settingFile)==="true");
        settings.loadOnStart = (fileio.read(settingFile)==="true");
        temp = fileio.read(settingFile);
        if (!isNaN(temp))
            settings.themeNr = +temp;

        do{
            subName = fileio.read(settingFile);
            if (subName)
               name += subName;
        }while(subName);
        settings.defName = name;

    }

}



/*


    for (var prop in  Global.settings) {

      console.log(prop +" :"+ Global.settings[prop]);

    }


*/

function stopAllWatches()
{
    mainItem.stopWatches();
}
