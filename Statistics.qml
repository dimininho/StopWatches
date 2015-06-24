import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "global.js" as Global
import "control.js" as Control
import QtQuick.LocalStorage 2.0



Window {
    id: statisticsWindow

    property var locale: Qt.locale()
    property var day: new Date();
    property int minHour:0
    property int maxHour:24

    width: 700;
    height: 500;
    color: Global.currentTheme.mainItemColor

    function repaint() {
        statisticsWindow.color = Global.currentTheme.mainItemColor
        var children = statisticsWindow.contentItem.children;
        for(var i = 0; i<children.length;++i) {
            if (typeof (children[i].repaint) === "function")
                children[i].repaint();
        }
    }


    function timeToCoorinate(time){
        var arr = time.split(':');
        var seconds = +arr[0]*3600 + arr[1]*60 + arr[2]*1;
        var endPos = statData.width-40- statData.xPos;
        var startPos = 0;
        var minTime = minHour*3600;
        var maxTime = maxHour*3600;
        var normCoef = (maxTime-minTime)/(endPos-startPos);
//console.log("norma " + normCoef + "  endPos " + endPos);
        return startPos + (seconds - minTime)/normCoef;

    }

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
                var query = "SELECT MAX(startTime) as max
                             FROM Data WHERE date= " +curDate;
                var time = (tx.executeSql(query)).rows.item(0).max;
                hour =  parseHour(time);
                if (hour===0) hour=23;
            }
        )
        return  hour;

    }

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
        console.log(minHour  +  " ^  " + maxHour);

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
                       timeDiff = timeDifference(rs2.rows.item(j).startTime,rs2.rows.item(j).endTime);
                      // console.log(from +"  -  " + to);
                       rectPositions[j] =new RectRange(from,to,timeDiff);

                   }
                    clocks.append({"Name": rs.rows.item(i).name,
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
        width: parent.width
        color: Control.currentTheme.mainPanelColor
        function repaint() {
            topPanel.color = Global.currentTheme.mainPanelColor
            var children = topPanel.children;
            for(var i = 0; i<children.length;++i) {
                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();
            }
        }



    Row{
        id: dates
        //anchors.fill: parent
        //anchors.top: parent.top
        anchors.left: parent.left
        anchors.verticalCenter:  parent.verticalCenter
        //anchors.leftMargin: 50
        spacing: 20

        function repaint() {
            var children = dates.children;
            for(var i = 0; i<children.length;++i) {
                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();
            }
        }

        MenuButton {
            id: backButton
            buttonWidth: 25
            buttonHeigth: 25
            buttonText: "<"
            onButtonClick: {
                day.setDate(day.getDate()-1)
                dateField.text =  day.toLocaleDateString(Qt.locale(),"yyyy-MMM-dd")
                getDataFromDB();
            }
        }



        TextField {
            id: dateField;
            text: day.toLocaleDateString(Qt.locale(),"yyyy-MMM-dd")

            font.pixelSize: 15
            horizontalAlignment: TextInput.AlignHCenter

            onActiveFocusChanged: {
               // calendar.visible = true;
               // calendar.focus = true;
              }
        }

        MenuButton {
            id: nextButton
            buttonWidth: 25
            buttonHeigth: 25
            buttonText: ">"
            onButtonClick: {
                day.setDate(day.getDate()+1)
                dateField.text =  day.toLocaleDateString(Qt.locale(),"yyyy-MMM-dd")
                getDataFromDB();
            }
        }

    }

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
            var children = statData.children;
            for(var i = 0; i<children.length;++i) {
                if (typeof (children[i].repaint) === "function")
                    children[i].repaint();
            }
        }

        ListView {
            id:view
            anchors.fill:parent
            width: parent.width
            model: clocks

            delegate: Rectangle{
                id: parentRec
                property Rectangle rrr: Rectangle{color:"blue"; width:20;height:20;}
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
                    sumTime.text = secondsToTime(sumSeconds);
                }

                Text{
                    id:nam
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pointSize: 19
                    font.weight: Font.Bold
                    color: Global.currentTheme.buttonLabelColor
                    text: Name
                }

                Text {
                    id: sumTime
                    anchors.bottom: parent.bottom
                    x: 120
                    font.pointSize: 10
                    color: Global.currentTheme.statisticsSumTimeColor
                    text:""

                }

                Rectangle {
                    id: diagram
                    x: statData.xPos
                    height:42;
                    width: statData.width - statData.xPos - 40;
                    color: Global.currentTheme.mainPanelColor
                }

                Component.onCompleted: createTimingDiagram(Intervals);

            }

        }

        Rectangle {
            id: labels

            property int xPos: statData.xPos

            height:40
            width:statData.width
            anchors.bottom: statData.bottom
            anchors.left: statData.left
            anchors.right: statData.right
            color:Global.currentTheme.mainItemColor
            function repaint() {
                labels.color = Global.currentTheme.mainItemColor
                var children = labels.children;
                for(var i = 0; i<children.length;++i) {
                    if (typeof (children[i].repaint) === "function")
                        children[i].repaint();
                }
            }

            Rectangle{
                id: abscissa
                height: 7
                width:parent.width - statData.xPos
                x: statData.xPos
                color:Global.currentTheme.statisticsLabelColor
                function repaint() {
                    abscissa.color = Global.currentTheme.statisticsLabelColor
                }
                anchors{
                    top: parent.top
                    right:parent.right
                }
            }

        }
       //MouseArea {
       //    anchors.fill: statData
       //    onClicked: statData.visible = false;
       //    propagateComposedEvents: true
       //}

/*
        Rectangle {
            id: divider
            x: parent.xPos - 1
            width: 1
            height: parent.height
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "black"
        }

*/
    }


    ListModel {
        id: clocks
    }



    Connections{
        target: mainItem
        onShowStatistics: {
            repaint();
            Control.clockDoubleClick(false);//for correct running clocks display
            console.log("get data");
            getDataFromDB();//try with Control.delay
        }


    }


    Calendar {
        id: calendar
        z:2
        x: dateField.x
        y: dateField.y+dateField.height

        selectedDate: new Date()
        visible: false
        frameVisible: true
        weekNumbersVisible: true
        focus: true
        style: CalendarStyle {
            dayDelegate: Item {
                readonly property color sameMonthDateTextColor: "#444"
                readonly property color selectedDateColor: "magenta"
                readonly property color selectedDateTextColor: "white"
                readonly property color differentMonthDateTextColor: "#bbb"
                readonly property color invalidDatecolor: "#dddddd"

                Rectangle {
                    anchors.fill: parent
                    border.color: "transparent"
                    color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                    anchors.margins: styleData.selected ? -1 : 0
                }


                Label {
                    id: dayDelegateText
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    color: {
                        var color = invalidDatecolor;
                        if (styleData.valid) {
                            // Date is within the valid range.
                            color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                            if (styleData.selected) {
                                color = selectedDateTextColor;
                            }
                        }
                        color;
                    }
                }
            }
        }


       // onFocusChanged:  if (calendar.focus===false && visible==true) visible = false;

    }


}
