import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "global.js" as Global
import "control.js" as Control
import QtQuick.LocalStorage 2.0



Window {
    id: statisticsWindow

    property var locale: Qt.locale("en_EN")
    property var day: new Date();
    property int minHour:0
    property int maxHour:24
    property int diagramRightMargin: 40
    property int diagramIndent: 7


    width: 700;
    height: 500;
    maximumWidth: width
    minimumWidth: width
    color: Global.currentTheme.mainItemColor;
   // contentItem.state: "CALENDAR_HIDE"

    function repaint() {
        function repaintInner(parentItem) {
            if (typeof (parentItem.repaint) === "function")
                                  parentItem.repaint();
            var children = parentItem.children
            for(var i = 0; i<children.length;++i)
                    repaintInner( children[i]);

        }
        statisticsWindow.color = Global.currentTheme.mainItemColor;
        repaintInner(statisticsWindow.contentItem);
    }


    function timeToCoorinate(time){
        var arr = time.split(':');
        var seconds = +arr[0]*3600 + arr[1]*60 + arr[2]*1;
        var endPos = statData.width - statData.xPos - diagramRightMargin - 2*diagramIndent;
        var startPos = diagramIndent;
        var minTime = minHour*3600;
        var maxTime = maxHour*3600;
        var normCoef = (maxTime-minTime)/(endPos-startPos);
        return startPos + (seconds - minTime)/normCoef;        
    }
/*
    function secondsToTime(seconds) {
        Number.prototype.div = function(by) {
            return (this - this % by)/by
        }

        var hour = seconds.div(3600);
        seconds -= hour*3600;
        var min = seconds.div(60);
        seconds -= min*60;
        var sec = seconds;
        var timeStr;
        timeStr = (hour>9) ? hour : "0"+hour;
        timeStr = (min>9) ? timeStr + ":" + min : timeStr + ":0" + min
        timeStr = (sec>9) ? timeStr + ":" + sec : timeStr + ":0" + sec
        return timeStr;
    }



    function timeDifference(time1,time2) {
        var arr = time1.split(':');
        var arr2 = time2.split(':');
        var seconds = +arr[0]*3600 + arr[1]*60 + arr[2]*1;
        var seconds2 = +arr2[0]*3600 + arr2[1]*60 + arr2[2]*1;
        return seconds2-seconds;
    }
*/
    function parseHour(time){
        if (time) {
            if (time[2]===':') return time.substr(0,2);
            if (time[1]===':') return time[0];
        }
        return 0;
    }

    function getMinHour(db,curDate) {
        var hour=0
        db.transaction(
            function(tx) {
                var query = "SELECT MIN(startTime) as min
                             FROM Data WHERE date= " +curDate;
                var time = (tx.executeSql(query)).rows.item(0).min;
                hour =  parseHour(time);
            }
        )
        return hour;
    }
    function getMaxHour(db,curDate) {
        var hour
        db.transaction(
            function(tx) {
                var query = "SELECT MAX(endTime) as max
                             FROM Data WHERE date= " +curDate;
                var time = (tx.executeSql(query)).rows.item(0).max;
                hour =  parseHour(time);
                if (hour===0) hour=23;
            }
        )
        return  hour;

    }

    //gets DB data and calculates rectangles for diagram
    //Model:
    //          Task1: (100,150); (190;195)
    //          Task2: (130,131)
    //Numbers are coordinates of the start and end of rectangle on diagram
    //
    function getDataFromDB() {
       var db = LocalStorage.openDatabaseSync("ClocksData", "1.0", "The data of clock working", 10001);
       clocks.clear();

        function RectRange(start,end,diff) {
            this.start = start
            this.end = end
            this.timeDifference = diff
        }

        var curDate = "'" + day.toLocaleDateString(Qt.locale(),"yyyy-MM-dd")+"'" ;//" '2015-05-25' " ;
        minHour = +getMinHour(db,curDate);
        maxHour = +getMaxHour(db,curDate)+1;
        Control.drawCoordinates(labels,minHour,maxHour);
       // console.log(minHour  +  " ^  " + maxHour);

       db.transaction(
           function(tx) {

               var query = "SELECT serialNr,name
                            FROM Data WHERE date= " +curDate +
                           " GROUP BY serialNr,name";

               var rs = tx.executeSql(query);
               var rs2;
               var rectPositions = [];
               var from,to,timeDiff;
               for(var i = 0; i < rs.rows.length; i++) {
                   rectPositions.length = 0;
                   query = "SELECT startTime,endTime
                            FROM Data WHERE date= " +curDate +
                                   "AND name= '" +rs.rows.item(i).name +"' "+
                                   "AND serialNr = '" + rs.rows.item(i).serialNr + "'";
                   rs2 = tx.executeSql(query);
                   for (var j = 0; j<rs2.rows.length; j++) {
                       from =timeToCoorinate(rs2.rows.item(j).startTime);
                       to = timeToCoorinate(rs2.rows.item(j).endTime);
                       timeDiff = Control.timeDifference(rs2.rows.item(j).startTime,rs2.rows.item(j).endTime);

                       rectPositions[j] =new RectRange(from,to,timeDiff);

                   }
                   var itemName =  rs.rows.item(i).name;
                   if (itemName.length>13)
                        itemName = itemName.substr(0,13) + "..."
                    clocks.append({"Name": itemName,
                                   "Intervals": rectPositions});
               }

           }
       )
    }

    Rectangle{
        id: topPanel
        anchors.top: parent.top
        anchors.left: parent.left
        height:40
        z:2
        width: parent.width
        color: Control.currentTheme.mainPanelColor
        function repaint() {
            topPanel.color = Global.currentTheme.mainPanelColor
        }



    Row{
        id: dates
        anchors.left: parent.left
        anchors.verticalCenter:  parent.verticalCenter
        //anchors.leftMargin: 50
        spacing: 20

        MenuButton {
            id: backButton
            buttonWidth: 25
            buttonHeigth: 25
            buttonText: "<"
            onButtonClick: {
                day.setDate(day.getDate()-1)
                dateField.text =  day.toLocaleDateString(locale,"yyyy-MMM-dd")
                getDataFromDB();
            }
        }



        TextField {
            id: dateField;
            text: day.toLocaleDateString(locale,"yyyy-MMM-dd")

            font.pixelSize: 15
            horizontalAlignment: TextInput.AlignHCenter
            //show calendar onClick
            onActiveFocusChanged: {
                underCalendar.enabled = true;
                calendar.visible = true;
                calendar.focus = true;
              }
        }

        MenuButton {
            id: nextButton
            buttonWidth: 25
            buttonHeigth: 25
            buttonText: ">"
            onButtonClick: {
                day.setDate(day.getDate()+1)
                dateField.text =  day.toLocaleDateString(locale,"yyyy-MMM-dd")
                getDataFromDB();
            }
        }


    }

        MenuButton {
            id: exportShowButton
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter:  parent.verticalCenter
            buttonWidth: 100
            buttonHeigth: 25
            buttonText: "Export"
            onButtonClick: {
                exportPanel.state = "ExportPanel_OPEN"
               // console.log(exportPanel.yPos + "     " + exportPanel.height)
            }
        }

    }

    ExportPanel{
        id: exportPanel
        z: 1        //above statData
        yPos: topPanel.height
        anchors.left: topPanel.left
        anchors.right: topPanel.right
    }

    Rectangle {

        id: statData
        anchors.top:  topPanel.bottom
        anchors.topMargin: 20
        anchors.bottom: statisticsWindow.contentItem.bottom
        color: Global.currentTheme.mainItemColor
        width: statisticsWindow.width

        property int xPos: 200

        function repaint() {
            statData.color = Global.currentTheme.mainItemColor
        }

        //represents current model of diagram
        ListView {
            id:view
            anchors.fill:parent
            width: parent.width
            model: clocks

            delegate: Rectangle{
                id: parentRec    
                width: parent.width
                height: 42
                color: Global.currentTheme.mainItemColor

                function createTimingDiagram(rectPositions) {
                    var sumSeconds = 0;
                    for(var i=0;i<rectPositions.count;++i) {
                        var newRect = Qt.createQmlObject('import QtQuick 2.0; Rectangle { height: 34; radius:3;}',
                            diagram, "simpleRect");
                        newRect.x = rectPositions.get(i).start;
                        newRect.color = Global.currentTheme.statisticsBarColor;
                        newRect.width  = rectPositions.get(i).end - rectPositions.get(i).start;
                        newRect.anchors.verticalCenter =  diagram.verticalCenter
                        sumSeconds += rectPositions.get(i).timeDifference;
                    }
                   // console.log(sumSeconds);
                    sumTime.text = Control.secondsToTime(sumSeconds);
                }

                Text{
                    id:nam
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pointSize: 19
                    //font.weight: Font.Bold
                    color: Global.currentTheme.buttonLabelColor
                    text: Name
                }

                Text {
                    id: sumTime
                    anchors.left: nam.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                   // x: 120
                    font.pointSize: 8
                    color: Global.currentTheme.statisticsSumTimeColor
                    text:""

                }

                Rectangle {
                    id: diagram
                    x: statData.xPos
                    height:45;
                    width: statData.width - statData.xPos - diagramRightMargin;
                    color: Global.currentTheme.mainPanelColor
                }

                Component.onCompleted: createTimingDiagram(Intervals);

            }

        }

        Rectangle {
            id: labels
            property int xPos: statData.xPos

            height:60
            width:statData.width
            anchors.bottom: statData.bottom
            anchors.left: statData.left
            anchors.right: statData.right
            color:Global.currentTheme.mainItemColor
            function repaint() {
                labels.color = Global.currentTheme.mainItemColor
            }

            Rectangle{
                id: abscissa
                height: 7
                width:parent.width - statData.xPos - diagramRightMargin + 10
                x: statData.xPos
                color:Global.currentTheme.statisticsBarColor
                function repaint() {
                    abscissa.color = Global.currentTheme.statisticsBarColor
                }
                anchors{
                    top: parent.top
                }
            }

        }

    }


    ListModel {
        id: clocks
    }



    Connections{
        target: mainItem
        onShowStatistics: {
            repaint();
            Control.clockDoubleClick(false);//for correct display of running clocks
            getDataFromDB();//try with Control.delay
           // Control.delay(2000,getDataFromDB);
        }


    }


    Calendar {
        id: calendar
        z:5
        x: dateField.x
        y: dateField.y+dateField.height

        selectedDate: new Date()
        visible: false
        frameVisible: true
        focus: true
        style: calendarstyle
        __locale: locale

        onClicked: {
            var previousDate = dateField.text;
            day.setDate(calendar.selectedDate.getDate());
            day.setMonth(calendar.selectedDate.getMonth());
            day.setYear(calendar.selectedDate.getFullYear());
            dateField.text =   day.toLocaleDateString(locale,"yyyy-MMM-dd");

            if (dateField.text !== previousDate) {
                getDataFromDB();
            } else console.log("same date");
            underCalendar.enabled = false;
            calendar.visible = false;

        }
        function repaint(){
            style = nullstyle;
            style = calendarstyle
        }

    }
    property Component calendarstyle: VarCalendarStyle{}
    property Component nullstyle: CalendarStyle{}


    MouseArea{
        //mouse area lies under calendar.It need to catch mouse's click out of calendar
        id:underCalendar
        z:2
        anchors.fill: parent
        enabled: false
        onClicked: {
            enabled = false;
            calendar.visible = false;
        }
    }



}
