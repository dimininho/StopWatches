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
var labelContainer = [];

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
    //buttonObject.Layout.alignment = 3
//console.log("clock  " + serialNr);
   // Global.clocksContainer[serialNr] = buttonObject;
    clocksContainer.push(buttonObject);
    ++serialNr;

    for(var i=0; i<maxQty;++i){
        //console.log(Global.watchesContainer[i] +"  n:" +i +"  +++");
    }

}


function removeCoordinateLabels()
{
    for(var i=0; i< labelContainer.length;++i)
    {
        labelContainer[i].destroy();
    }
    labelContainer.length = 0;
}

function getMinDivider(number) {
    var divider = 1;
    if (number>10) {
        if (number % 2 === 0) divider = 2;
        if (number % 3 === 0) divider = 3;
    }
    return divider
}

function drawCoordinates(parentItem,from,to) {
    var label;
    var label00;
    var xStart = parentItem.xPos+7;
    var xEnd = parentItem.width-40-2*7;
    var divCoef = getMinDivider(to-from);
    var step = divCoef*(xEnd - xStart)/(to-from);
    //console.log(from + " @ " +to);
//console.log(parentItem.id + "   " + xStart +"-"+xEnd + "  step" + step);
    var j = 0;
    removeCoordinateLabels();
    for(var i=from;i<=to;i+=divCoef,++j) {
        //forming label like "13:00"
        //where "13" is label and "00" is label00
        label = Qt.createQmlObject('import QtQuick 2.0; Text {font.pointSize: 13; y:13;}',
            parentItem, "label");
        label00 = Qt.createQmlObject('import QtQuick 2.0; Text {font.pointSize: 7; y:13; text:"00";}',
            parentItem, "label00");

        label.text = i;
        label.color = Global.currentTheme.statisticsLabelColor
        label.x = xStart + j*step;
        label00.color = Global.currentTheme.statisticsLabelColor
        label00.x = xStart + j*step + 10*label.text.length;


        labelContainer.push(label);
        labelContainer.push(label00);

//console.log(i);
       // console.log(label.text + " :" + label.x);
    }
}


/*
function changeColumnsNumber(){
    layout.colNumber = mainItem.width / mainItem.watchWidth;
}
*/


function destroyItem(number)
{
    for(var i=0; i< clocksContainer.length;++i)
    { if (clocksContainer[i])
        console.log(clocksContainer[i].clockName +"  i " +i + "   ser " + clocksContainer[i].serialNr);
    }

   clocksContainer[number].destroy();
   //clocksContainer[number] = null;
   delete clocksContainer[number];
    console.log("----------")
    for(var i=0; i< clocksContainer.length;++i)
    {
        if (clocksContainer[i])
         console.log(clocksContainer[i].clockName +"   " +i);
    }
}

function removeAllClocks()
{
    for(var i=0; i< Global.clocksContainer.length;++i)
    {
        if (clocksContainer[i])
            destroyItem(i);
    }
}


function Timer() {
    return Qt.createQmlObject("import QtQuick 2.2; Timer {}", mainItem);
}

function delay(delayTime, cb) {
    var timer = new Timer();
    timer.interval = delayTime;
    timer.repeat = false;
    timer.triggered.connect(cb);
    timer.start();
}

//this function needs for correct display of running clocks
// (we write current time to database and run clock again)


function clockDoubleClick(pause)
{
    var runnedClocks = [];
    function innerClockDoubleClick() {
         for(var j=0; j< runnedClocks.length;++j) {
             clocksContainer[runnedClocks[j]].run = true;
         }
    }
    for(var i=0; i< Global.clocksContainer.length;++i)
    {
        if (clocksContainer[i]){
            if (clocksContainer[i].run) {
                clocksContainer[i].run = false;
                runnedClocks.push(i);
               // clocksContainer[i].whenRunChanged(); //check if correct in Linux
            }
        }
    }

    if (pause)
        delay(2100,innerClockDoubleClick);
    else
        innerClockDoubleClick();
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
    var i,lastSerNr=0;
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
                                                              "serialNr": number,
                                                              "clockName": name,
                                                              "fillColor": fillcolor,
                                                              "labelColor": labelcolor,
                                                              "run": run,
                                                              "seeSeconds": seeSecs,
                                                              "time": time      });

            //clocksContainer.push(buttonObject);
            lastSerNr = +number;
            clocksContainer[lastSerNr] =buttonObject;
        }

    }
    serialNr = ++lastSerNr;
    clockDoubleClick(false);
}

/*
function initializeSettings() {
    settings = new Global.Settings(false,false,false,"Dark",1,"Task");
}
*/

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
