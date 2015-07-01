//.pragma library
.import "global.js" as Global
.import QtQuick.LocalStorage 2.0 as Sql

var component;
var clockObject;
//var parentItem = "layout"
//var maxQty = 7;
var serialNr = Global.serialNr;
var endingChar = "#^#"
var settingFile = "settings.txt"
var fileName = "clocks.txt";
var currentTheme = Global.currentTheme;
var settings = Global.settings;
var clocksContainer = Global.clocksContainer;
var darkThemeName = "Blue";
var whiteThemeName = "White";
var labelContainer = [];

//-----------OPERATIONS WITH CLOCKS---------------------

function addClock(parentItem,main) {

    if (component === undefined)
        component = Qt.createComponent("Clock.qml");

    clockObject = component.createObject(parentItem,{
                                                      "serialNr": serialNr,
                                                      "width":main.clockWidth,
                                                      "height":main.clockWidth,
                                                      "clockName":settings.defName,
                                                      "seeSeconds": settings.enableSeconds});
    clocksContainer.push(clockObject);
    ++serialNr;

   // for(var i=0; i<maxQty;++i){
   //     //console.log(Global.watchesContainer[i] +"  n:" +i +"  +++");
   // }

}

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


function stopAllClocks()
{
    mainItem.stopClocks();
}


//--------------DRAW COORDINATE AXIS AND LABELS    IN STATISTICS WINDOW------------------


function removeCoordinateLabels()
{
    for(var i=0; i< labelContainer.length;++i)
    {
        labelContainer[i].destroy();
    }
    labelContainer.length = 0;
}

//change step of axis
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

    }
}





//---------- AUXILIARY FUNCTIONS FOR WORK WITH DB-------------

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
        delay(2100,innerClockDoubleClick); //for correct writing in DB when date changes
    else
        innerClockDoubleClick();
}


//------------------------SAVING(READING) FROM FILE   ------------------

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
            clockObject = component.createObject(parentItem,{
                                                              "serialNr": number,
                                                              "clockName": name,
                                                              "fillColor": fillcolor,
                                                              "labelColor": labelcolor,
                                                              "run": run,
                                                              "seeSeconds": seeSecs,
                                                              "time": time      });

            //clocksContainer.push(clockObject);
            lastSerNr = +number;
            clocksContainer[lastSerNr] =clockObject;
        }

    }
    serialNr = ++lastSerNr;
    clockDoubleClick(false);
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
    mainItem.repaintMain();
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
        //mainItem.repaint();
        mainItem.repaintMain();
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


