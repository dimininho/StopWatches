.pragma library

var serialNr = 0;
var maxQty = 10;
//var watchesContainer = new Array(maxQty);
var watchesContainer = [];


function Settings(enableSeconds,onlyOneRun,loadOnStart,theme,themeNr,defName) {
    this.enableSeconds = enableSeconds
    this.onlyOneRun = onlyOneRun
    this.loadOnStart = loadOnStart
    this.theme = theme
    this.themeNr = themeNr
    this.defName = defName
}

var settings =  new Settings(false,false,false,"Dark",1,"Task");






