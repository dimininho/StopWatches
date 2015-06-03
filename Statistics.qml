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
    }

    function timeToCoorinate(time){
        var arr = time.split(':');
        var seconds = +arr[0]*3600 + arr[1]*60 + arr[2]*1;
        var endPos = statData.width-40- statData.xPos;
        var startPos = 0;
        var minTime = minHour*3600;
        var maxTime = maxHour*3600;
        var normCoef = (maxTime-minTime)/(endPos-startPos);

        return startPos + (seconds - minTime)/normCoef;

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

        function RectRange(start,end) {
            this.start = start
            this.end = end
            //return this;
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
               var from,to;
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
                       console.log(from +"  -  " + to);
                       rectPositions[j] =new RectRange(from,to);

                   }
                    clocks.append({"Name": rs.rows.item(i).name,
                                   "Intervals": rectPositions});
               }

           }
       )
    }



    Row{
        id: dates
        anchors.top: parent.top
        anchors.leftMargin: 50
        spacing: 20

        Button {
            id: backButton
            width: 25
            height:25
            text:"<"
            onClicked: {
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
        }

        Button {
            id: nextButton
            width: 25
            height:25
            text:">"
            onClicked: {
                day.setDate(day.getDate()+1)
                dateField.text =  day.toLocaleDateString(Qt.locale(),"yyyy-MMM-dd")
                getDataFromDB();
            }
        }

    }


    Rectangle {

        id: statData
        anchors.top:  dates.bottom
        anchors.bottom: statisticsWindow.contentItem.bottom
        color: "cyan"
        width: statisticsWindow.width

        property int xPos: 200

        ListView {
            id:view
            anchors.fill:parent
            width: parent.width
            model: clocks

            delegate: Rectangle{
                id: parentRec
                property Rectangle rrr: Rectangle{color:"blue"; width:20;height:20;}
                width: parent.width
                height: 40
                color:"#a2eef5"

                function createTimingDiagram(rectPositions) {
                    for(var i=0;i<rectPositions.count;++i) {
                        var newRect = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "lightsteelblue"; height: 34; radius:5;}',
                            diagram, "simpleRect");
                        newRect.x = rectPositions.get(i).start;
                        newRect.width  = rectPositions.get(i).end - rectPositions.get(i).start;
                    }
                }

                Text{
                    id:nam
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pointSize: 20
                    font.weight: Font.Bold
                    text: Name
                }

                Rectangle {
                    id: diagram
                    x: statData.xPos
                    height:40;
                    width: statData.width - statData.xPos - 40;
                    color:"lightblue"
                }

                function makeRec(){
                    var  w = 150;
                    var newObject = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "red"; height: 20; radius: 5;}',
                        parentRec, "dynamicSnippet1");
                    newObject.width = w;
                    newObject.x = 300;
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

            Rectangle{
                id: abscissa
                height: 7
                width:parent.width - statData.xPos
                x: statData.xPos
                color:"black"
                anchors{
                    top: parent.top
                    right:parent.right
                }
            }
            //Component.onCompleted: Control.drawCoordinates(labels,statisticsWindow.minHour,statisticsWindow.maxHour);
        }


    }


    ListModel {
        id: clocks

    }



    Connections{
        target: mainItem
        onShowStatistics: {
            Control.clockDoubleClick();
            getDataFromDB();
        }


    }

/*
    Calendar {
        id: calendar
        selectedDate: new Date(2015, 0, 1)
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
    }

*/
}
