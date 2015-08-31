.pragma library

var serialNr = 0;
var maxQty = 10;
//var clocksContainer = new Array(maxQty);
var clocksContainer = [];


function Settings(enableSeconds,onlyOneRun,loadOnStart,theme,themeNr,defName,exportFolder) {
    this.enableSeconds = enableSeconds
    this.onlyOneRun = onlyOneRun
    this.loadOnStart = loadOnStart
    this.theme = theme
    this.themeNr = themeNr
    this.defName = defName
    this.exportFolder = exportFolder
}

var settings =  new Settings(false,false,false,"Blue",1,"Task","");



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

var blue = new Theme();
    blue.buttonFillColor = "#152641";
    blue.buttonLabelColor = "white"
    blue.buttonBorderColor = "transparent"
    blue.buttonOnHoverFillColor = "#8498A9"
    blue.buttonOnPressBorderColor = "white"
    blue.mainPanelColor = "#152641"
    blue.mainItemColor = "#4A6587"
    blue.settingsPanelColor = "#8498A9"
    blue.clockFillColor = "#152641"
    blue.clockLabelColor = "white"
    blue.clockIndicatorColor = "white"
    blue.clockIndicatorOffColor = "#485365"
    blue.mainMenuIcon = "white_menu1.png"
    blue.mainMenuBackColor = "#8498A9"
    blue.mainMenuRowColor = "#8498A9"
    blue.mainMenuOnHoverRowColor = "white"
    blue.mainMenuBorderColor = "transparent"
    blue.mainMenuLabelOnHoverColor = "#152641"
    blue.statisticsSumTimeColor = "#F6EFE4"
    blue.statisticsLabelColor = "white"
    blue.statisticsBarColor = "white"
    blue.calendarSelectDate = "#8498A9"


var white = new Theme();
    white.buttonFillColor = "#D8EDFD";//1
    white.buttonLabelColor = "black"
    white.buttonBorderColor = "transparent"
    white.buttonOnHoverFillColor = "white"
    white.buttonOnPressBorderColor = "white"
    white.mainPanelColor = "#D8EDFD"//1
    white.mainItemColor = "white"
    white.settingsPanelColor = "#EAF8FA"
    white.clockFillColor = "#D1E8FA"
    white.clockLabelColor = "black"
    white.clockIndicatorColor = "#195871"
    white.clockIndicatorOffColor = "white"
    white.mainMenuIcon = "black_menu1.png"
    white.mainMenuBackColor = "white"
    white.mainMenuRowColor = "white"
    white.mainMenuOnHoverRowColor = "#CDE1FE"
    white.mainMenuBorderColor = "transparent"
    white.mainMenuLabelOnHoverColor = "black"
    white.statisticsSumTimeColor = "#195871"
    white.statisticsLabelColor = "black"
    white.statisticsBarColor = "#195871"
    white.calendarSelectDate = "#D8EDFD"

var currentTheme = blue;
var blueThemeName = "Blue";
var whiteThemeName = "White";


function changeTheme(theme){
    switch (theme) {
    case blueThemeName :
        currentTheme = blue;
       // console.log("Blue");
        break;
    case whiteThemeName:
        currentTheme = white;
       // console.log("WHIte");
        break;
    }
}

/*
function Theme() {}
Theme.prototype.buttonFillColor = "#3000ee";


var black = new Theme();
black.buttonFillColor = "#80aa00";
*/



