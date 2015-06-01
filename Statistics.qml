import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "global.js" as Global
import "control.js" as Control
import QtQuick.LocalStorage 2.0
import QtQuick 2.2 as QQQ


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

               var r = ""

               var rectPositions = [];
               var from,to;
               for(var i = 0; i < rs.rows.length; i++) {
                   rectPositions.length = 0;
                   query = "SELECT startTime,endTime
                            FROM Data WHERE date= " +curDate +
                                   "AND name= '" +rs.rows.item(i).name +"' "+
                                   "AND serialNr = '" + rs.rows.item(i).serialNr + "'";
                   rs2 = tx.executeSql(query);
                   //intervals = "[";
                   for (var j = 0; j<rs2.rows.length; j++) {
                      // rectPositions[j] =new RectRange(rs2.rows.item(j).startTime,rs2.rows.item(j).endTime);
                       from =timeToCoorinate(rs2.rows.item(j).startTime);
                       to = timeToCoorinate(rs2.rows.item(j).endTime);
                       console.log(from +"  -  " + to);
                       rectPositions[j] =new RectRange(from,to);

                   }

                  // intervals += "]";
                   //console.log(intervals);

                    clocks.append({"Name": rs.rows.item(i).name,
                                   "Intervals": rectPositions});
                   //console.log("A   " + clocks.get(i).Intervals.get(0).start);

                  // clocks.append({"Name": rs.rows.item(i).name,
                   //               "Intervals": intervals});
                  // console.log(clocks.get(i).Name  + ":  " +clocks.get(i).Intervals.count+ "  start " + clocks.get(i).Intervals.get(0).start);


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

                function getRectangles(rectPositions) {
                    var text = "";
                    for(var i=0;i<rectPositions.count;++i) {
                        text+= rectPositions.get(i).start + "$" + rectPositions.get(i).end;
                    }
                    //console.log(text);
                    return text;

                }
                function getRectangles2(object) {
                    var text = "";
                    text = object.start + " & " + object.end;
                    //console.log(text);
                    return text;

                }



                Text{
                    id:nam
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pointSize: 20
                    font.weight: Font.Bold
                    text: Name
                }
                function makeRec(){
                    var  w = 150;
                    var newObject = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "red"; height: 20;}',
                        parentRec, "dynamicSnippet1");
                    newObject.width = w;
                    newObject.x = 300;
                }

                /*
                Text{
                    anchors.left: nam.right
                    anchors.leftMargin: 40
                    font.pointSize: 14
                    font.weight: Font.Bold
                    text: getRectangles(Intervals)
                    //text: getRectangles2(Intervals.get(0));
                    //text: Intervals.get(0).start
                }*/

                Component.onCompleted: makeRec();




//               Item{
//                   data: Rect

 //              }

              // Component.onCompleted: console.log(Rect.width);
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
        id: stocks
        // Data from : http://en.wikipedia.org/wiki/NASDAQ-100
        ListElement {name: "Apple Inc."; stockId: "AAPL"; value: "0.0"; change: "0.0"; changePercentage: "0.0"}
    }



    ListModel {
        id: clocks

    }



    Connections{
        target: mainItem
        onShowStatistics: getDataFromDB();
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
