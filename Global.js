.pragma library

var serialNr = 0;
var maxQty = 10;
//var watchesContainer = new Array(maxQty);
var watchesContainer = [];


function Settings(enableSeconds,onlyOneRun,loadOnStart,theme,defName) {
    this.enableSeconds = enableSeconds
    this.onlyOneRun = onlyOneRun
    this.loadOnStart = loadOnStart
    this.theme = theme
    this.defName = defName
}



var settings = new Settings(false,false,false,"Dark","Task");


function saveSettings(enableSeconds,onlyOneRun,loadOnStart,theme,defName){
    settings.enableSeconds = enableSeconds;
    settings.onlyOneRun = onlyOneRun;
    settings.loadOnStart = loadOnStart
    settings.theme = theme
    settings.defName = defName
}
