import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "global.js" as Global
import QtQuick.LocalStorage 2.0
import QtQuick 2.2 as QQQ

/*

ListModel {
    id: fruitModel

    ListElement {
        name: "Apple"
        cost: 2.45
        attributes: [
            ListElement { description: "Core" },
            ListElement { description: "Deciduous" }
        ]
    }
save calculated coordinates of rects into attributes

*/

884 323 319
5x6x9a
Window {
    id: statisticsWindow

    property var locale: Qt.locale()
    property var day: new Date();

    width: 700;
    height: 500;
    color: Global.currentTheme.mainItemColor

    function repaint() {
        statisticsWindow.color = Global.currentTheme.mainItemColor
    }

    property var re : Rectangle{
        width:70;
        height:10;
        color:"red";
    }



    function getDataFromDB() {
       var db = LocalStorage.openDatabaseSync("ClocksData", "1.0", "The data of clock working", 10001);
       clocks.clear();

        function RectRange(start,end) {
            this.start = start
            this.end = end
            //return this;
        }


        var a = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "magenta"; width: 20; height: 20;y:200}',
            clocks, "dynamicSnippet1");


        //a.width=23;
        //a.height = 44;
        //a.y=100;
        //a.color = "magenta";
        //
        //statisticsWindow.re = a;

       // clocks.append({"Name": "TEST",
        //              "Intervals":[{"start":" 12:12:12","end":" 13:12:12"},
         //                           {"start":" 15:152:12","end":" 17:12:12"}]});


        //console.log(clocks.get(0).Name  + ":  " +clocks.Rect.color + "  start " + clocks.get(0).Intervals.get(0).start);

       db.transaction(
           function(tx) {
               var curDate = "'" + day.toLocaleDateString(Qt.locale(),"yyyy-MM-dd")+"'" ;//" '2015-05-25' " ;
               var query = "SELECT serialNr,name
                            FROM Data WHERE date= " +curDate +
                           " GROUP BY serialNr,name";


               var rs = tx.executeSql(query);
               var rs2;

               var r = ""
               var intervals;
               var rectPositions = [];

               for(var i = 0; i < rs.rows.length; i++) {
                   rectPositions.length = 0;
                   query = "SELECT startTime,endTime
                            FROM Data WHERE date= " +curDate +
                                   "AND name= '" +rs.rows.item(i).name +"' "+
                                   "AND serialNr = '" + rs.rows.item(i).serialNr + "'";
                   rs2 = tx.executeSql(query);
                   //intervals = "[";
                   for (var j = 0; j<rs2.rows.length; j++) {
                       rectPositions[j] =new RectRange(rs2.rows.item(j).startTime,rs2.rows.item(j).endTime);
                       //intervals+=rs2.rows.item(j).startTime + " - " + rs2.rows.item(j).endTime+ "; ";
                      // intervals+="{" + "\"start\":\"" + rs2.rows.item(j).startTime +
                      //         "\",\"end\":\"" + rs2.rows.item(j).endTime + "\"}";
                   }

                  // intervals += "]";
                   //console.log(intervals);

                    clocks.append({"Name": rs.rows.item(i).name,
                                   "Intervals": rectPositions});
                   console.log("A   " + clocks.get(i).Intervals.get(0).start);

                  // clocks.append({"Name": rs.rows.item(i).name,
                   //               "Intervals": intervals});
                  // console.log(clocks.get(i).Name  + ":  " +clocks.get(i).Intervals.count+ "  start " + clocks.get(i).Intervals.get(0).start);


               }

           }
       )
    }

    function fillListModel(clocks) {
        for(i=0;clocks.rows.length;++i) {
            var query = "";
            query = "SELECT startTime,endTime
                     FROM Data WHERE date= " +curDate +
                            "AND name= '" +rs.rows.item(i).name +"' "+
                            "AND serialNr = '" + rs.rows.item(i).serialNr + "'";
        }
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
        width: statisticsWindow.contentItem.width

        ListView {
            id:view
            anchors.fill:parent
            width: parent.width
            model: clocks

            delegate: Rectangle{
                property Rectangle rrr: Rectangle{color:"blue"; width:20;height:20;}
                width: parent.width
                height: 40
                color:"#a2eef5"

                function getRectagles(rectPositions) {
                    var text = "";
                    for(var i=0;i<rectPositions.length;++i) {
                        text+= rectPositions[i].start + "$" + rectPositions[i].end;
                    }
                    console.log(text);
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
                Text{
                    anchors.left: nam.right
                    anchors.leftMargin: 40
                    font.pointSize: 14
                    font.weight: Font.Bold
                    text: getRectagles(Intervals);
                }
//               Item{
//                   data: Rect

 //              }

              // Component.onCompleted: console.log(Rect.width);
            }
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
