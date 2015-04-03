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



function Theme() {
    this.buttonFillColor = "#ffffff"
    this.buttonLabelColor = "#ffffff"
    this.mainPanelColor = "#ffffff"
    this.mainItemColor = "#ffffff"
    this.settingsPanelColor = "#ffffff"
    this.watchColor = "#ffffff"
    this.watchLabelColor = "#ffffff"
    this.watchIndicatorColor = "#ffffff"
}

var dark = new Theme();
    dark.buttonFillColor = "#434c53";
    dark.buttonLabelColor = "white"
    dark.mainPanelColor = "#383838"
    dark.mainItemColor = "#676767"
    dark.settingsPanelColor = "#678080"
    dark.watchFillColor = "#434c53"
    dark.watchLabelColor = "white"
    dark.watchIndicatorColor = "#ffffff"



var white = new Theme();
    white.buttonFillColor = "#434c53";
    white.buttonLabelColor = "white"
    white.mainPanelColor = "#eeeeff"
    white.mainItemColor = "#ffeeff"
    white.settingsPanelColor = "#ddeeff"
    white.watchFillColor = "white"
    white.watchLabelColor = "black"
    white.watchIndicatorColor = "#ffffff"



var currentTheme = dark;
var darkThemeName = "Dark";
var whiteThemeName = "White";


function changeTheme(theme){
    switch (theme) {
    case darkThemeName :
        currentTheme = dark;
        console.log("DARK");
        break;
    case whiteThemeName:
        currentTheme = white;
        console.log("WHIte");
        break;
    }
}

/*
function Theme() {}
Theme.prototype.buttonFillColor = "#3000ee";


var black = new Theme();
black.buttonFillColor = "#80aa00";
*/

