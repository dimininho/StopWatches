.pragma library

var serialNr = 0;
var maxQty = 10;
//var clocksContainer = new Array(maxQty);
var clocksContainer = [];


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
    this.clockColor = "#ffffff"
    this.clockLabelColor = "#ffffff"
    this.clockIndicatorColor = "#ffffff"
}

var dark = new Theme();
    dark.buttonFillColor = "#383838";
    dark.buttonLabelColor = "white"
    dark.buttonBorderColor = "transparent"
    dark.buttonOnHoverFillColor = "#888888"
    dark.buttonOnPressBorderColor = "white"
    dark.mainPanelColor = "#383838"
    dark.mainItemColor = "#676767"
    dark.settingsPanelColor = "#8498A9"
    dark.clockFillColor = "#434c53"
    dark.clockLabelColor = "white"
    dark.clockIndicatorColor = "#ffffff"
    dark.mainMenuIcon = "white_menu1.png"



var white = new Theme();
    white.buttonFillColor = "#D8EDFD";
    white.buttonLabelColor = "black"
    white.buttonBorderColor = "transparent"
    white.buttonOnHoverFillColor = "#64BCED"
    white.buttonOnPressBorderColor = "white"
    white.mainPanelColor = "#D8EDFD"
    white.mainItemColor = "white"
    white.settingsPanelColor = "#EAF8FA"
    white.clockFillColor = "#D1E8FA"
    white.clockLabelColor = "black"
    white.clockIndicatorColor = "#ffffff"
    white.mainMenuIcon = "black_menu1.png"



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

