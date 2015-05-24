//.pragma library
.import "global.js" as Global
.import QtQuick.LocalStorage 2.0 as Sql

var component;
var buttonObject;
//var parentItem = "layout"
var maxQty = 7;
var serialNr = Global.serialNr;
var endingChar = "#^#"
var settingFile = "settings.txt"
var fileName = "clocks.txt";
//var currentTheme = new Global.Theme();
var currentTheme = Global.currentTheme;

var settings = Global.settings;
var clocksContainer = Global.clocksContainer;
var darkThemeName = "Dark";
var whiteThemeName = "White";

function ClockType(object){
    this.number = object.serialNr;
    this.name = object.clockName;
    this.color = object.fillColor;
    this.time = object.time
}


function addClock(parentItem,main) {

    if (component === undefined)
        component = Qt.createComponent("Clock.qml");
    buttonObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.clockWidth,
                                                      "height":main.clockWidth,
                                                      "clockName":settings.defName,
                                                      "seeSeconds": settings.enableSeconds});

   // Global.clocksContainer[serialNr] = buttonObject;
    clocksContainer.push(buttonObject);
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
   clocksContainer[number].destroy();
   //clocksContainer[number] = null;
   delete clocksContainer[number];

}

function removeAllClocks()
{
    for(var i=0; i< Global.clocksContainer.length;++i)
    {
        if (clocksContainer[i])
            destroyItem(i);
    }
}


function writeClocksToFile()
{

    var clocksData = "";
    for(var i=0;i<clocksContainer.length; ++i)
    {
        if (clocksContainer[i]) {
        clocksData+=clocksContainer[i].serialNr + " "
                    +clocksContainer[i].clockName + " " + endingChar + " "
                    +clocksContainer[i].fillColor + " "
                    +clocksContainer[i].labelColor + " "
                    +clocksContainer[i].run + " "
                    +clocksContainer[i].seeSeconds + " "
                    +clocksContainer[i].time +  " \n" ;
        }
    }
    fileio.write(fileName,clocksData);
}


function readClocksFromFile(parentItem)
{
    var number,name,fillcolor,labelcolor,run,seeSecs,time,subname;
    var i=0;
    var reading = true;

    if (component == null)
        component = Qt.createComponent("Clock.qml");

    removeAllClocks();

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
                                                              "clockName": name,
                                                              "fillColor": fillcolor,
                                                              "labelColor": labelcolor,
                                                              "run": run,
                                                              "seeSeconds": seeSecs,
                                                              "time": time      });

            clocksContainer.push(buttonObject);
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

    console.log(Global.currentTheme.mainItemColor);
    mainItem.repaint();
}



function writeSettingsToFile() {

    var settingsData = "";
    settingsData = settings.enableSeconds + " "
                +settings.onlyOneRun + " "
                +settings.loadOnStart + " "
                +settings.themeNr + " "
                +settings.theme + " "
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
            settings.themeNr = +temp;   //from string to integer
        settings.theme = fileio.read(settingFile);
        Global.changeTheme(settings.theme);
        mainItem.repaint();
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

function stopAllClocks()
{
    mainItem.stopClocks();
}
