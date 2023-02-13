import QtQuick 2.15
import QtQuick.Controls 2.15

import "date-conversion.js" as DateConversion

Popup {
    width: 300
    height: 340
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    dim: false
    padding: 0
    background: Rectangle { id: backgroundRect; color: backgroundColor; radius: 4; border.width: 1; border.color: "#4C4C4C" }
    closePolicy: Popup.CloseOnEscape //|| Popup.CloseOnPressOutsideParent


    property int cellWidth: 32
    property color dayColor: "transparent"
    property color selectedDayColor: "#1FBE72"
    property color daysTextColor: "#ffffff"
    property color disableDaysTextColor: "#808080"
    property color backgroundColor: "#333333"

    property var sat
    property var sun
    property var mon
    property var tue
    property var wed
    property var thu
    property var fri

    property var currentDate: DateConversion.today()
    property int todayYear: currentDate["y"]
    property int todayMonth: currentDate["m"]
    property int todayDay: currentDate["d"]
    property var thisMonth: DateConversion.monthName(currentDate["m"])
    property int daysInMonth: DateConversion.dayInMonth(todayYear, todayMonth)
    property var firstDayOfMonth: DateConversion.dayNumber(todayYear, todayMonth,1)
    property var todayNumber: DateConversion.dayNumber(todayYear, todayMonth, todayDay)
    property var todayName: DateConversion.dayOfWeek(todayYear, todayMonth, todayDay)

    property variant ptyExistDate    : []

//    property var todayName: DateConversion.dayOfWeek(todayYear, todayMonth, todayDay)

    signal dateSelected
    signal monthChanged(var month)

    clip: true

    function nextMonth() {
        if (todayMonth == 12)
            currentDate = {"y": todayYear + 1, "m": 1, "d": 1}
        else
            currentDate = {"y": todayYear, "m": todayMonth + 1, "d": 1}

        destroyCells()
        createCells()
        monthChanged(todayMonth)
    }

    function previousMonth() {
        if (todayMonth == 1) {
            currentDate = {"y": todayYear - 1, "m": 12, "d": 1}
        }
        else
            currentDate = {"y": todayYear, "m": todayMonth - 1, "d": 1}

        destroyCells()
        createCells()
        monthChanged(todayMonth)
    }

    function selectedCellChanged(x,type) {
        var j;
        var i;
        var counter = -firstDayOfMonth;
        var selectedDay;

        for (i = 0; i < 6; i++) {
            for (j = 0; j < 7; j++) {
                if (!type || counter > daysInMonth ) //nill remove daysInMonth-1
                    break;

                if (x === gridId.children[j].children[i + 1].children[0].text
                        && gridId.children[j].children[i + 1].children[0].isEnable) {
                    gridId.children[j].children[i + 1].color = selectedDayColor
                    currentDate = {"y": todayYear, "m": todayMonth, "d": x}
                } else {
                    gridId.children[j].children[i + 1].color = dayColor
                }

                counter++;
            }
        }
    }

    function destroyCells() {
        var i;
        var j;

        for (i = 0; i < 7; i++)
        {
            for (j = 1; j < gridId.children[i].children.length; j++)
                gridId.children[i].children[j].anchors.horizontalCenter = undefined

            gridId.children[i].children = gridId.children[i].children[0]
        }
    }

    function createColumns() {
        sat = monthColumns.createObject(gridId, {"text": DateConversion.dayName(0)})
        sun = monthColumns.createObject(gridId, {"text": DateConversion.dayName(1)})
        mon = monthColumns.createObject(gridId, {"text": DateConversion.dayName(2)})
        tue = monthColumns.createObject(gridId, {"text": DateConversion.dayName(3)})
        wed = monthColumns.createObject(gridId, {"text": DateConversion.dayName(4)})
        thu = monthColumns.createObject(gridId, {"text": DateConversion.dayName(5)})
        fri = monthColumns.createObject(gridId, {"text": DateConversion.dayName(6)})
    }

    function createCells() {
        var i;
        var j;
        var counter = 1; //day counter
        var counterNextMonth = 1; //day counter
        var counterPreviousMonth = 0
        if(todayMonth == 1)
            counterPreviousMonth = DateConversion.dayInMonth(todayYear-1, 12) - firstDayOfMonth + 1; //day counter
        else
            counterPreviousMonth = DateConversion.dayInMonth(todayYear, todayMonth - 1) - firstDayOfMonth + 1; //day counter

        for (i = 0; i < 6; i++) {
            if (counter <= daysInMonth) {
                calendarCell.createObject(sat)
                calendarCell.createObject(sun)
                calendarCell.createObject(mon)
                calendarCell.createObject(tue)
                calendarCell.createObject(wed)
                calendarCell.createObject(thu)
                calendarCell.createObject(fri)

                for (j = 0; j < 7; j++) {
                    if ((j === firstDayOfMonth && counter === 1) ||
                            (counter > 1 && counter <= daysInMonth)) {
                        gridId.children[j].children[i + 1].children[0].text = counter;
                        counter++;
                    }
                    else if ((counter > 28 )){
                        gridId.children[j].children[i + 1].children[0].text = counterNextMonth;
                        gridId.children[j].children[i + 1].children[0].color = disableDaysTextColor
                        gridId.children[j].children[i + 1].children[0].isEnable = false
                        counterNextMonth++
                    }
                    else if ((counter == 1 )){
                        gridId.children[j].children[i + 1].children[0].text = counterPreviousMonth;
                        gridId.children[j].children[i + 1].children[0].color = disableDaysTextColor
                        gridId.children[j].children[i + 1].children[0].isEnable = false
                        counterPreviousMonth++
                    }
                }
            }

        }

        if (gridId.children[todayNumber].children[parseInt((todayDay / 7) + 1)].children[0].text !== "") {
            gridId.children[todayNumber].children[parseInt((todayDay / 7) + 1)].color = selectedDayColor;
        } else {
            gridId.children[todayNumber].children[parseInt((todayDay / 7) + 2)].color = selectedDayColor;
        }
    }


    contentItem: Item {

        Component {
            id: calendarCell

            Rectangle {
                width: cellWidth
                height: cellWidth
                radius: width
                color: dayColor

                Text {
                    property bool isEnable: true
                    text: ""
                    font.pointSize: 11
                    color: daysTextColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: parent.children[0].isEnable
                    onPressed: {
                        selectedCellChanged(parent.children[0].text,parent.children[0].isEnable)
                    }

                    onClicked: {
                        selectedCellChanged(parent.children[0].text,parent.children[0].isEnable)
                        dateSelected()
                    }

                    onDoubleClicked: {
                        selectedCellChanged(parent.children[0].text,parent.children[0].isEnable)
                        dateSelected()
                    }
                }
            }
        }

        Component {
            id: monthColumns

            Column {
                id: column
                width: cellWidth
                spacing: 8
                property alias text: text.text

                Rectangle {
                    width: cellWidth
                    height: cellWidth// calverhor(12)
                    color: dayColor

                    Text {
                        id: text
                        text: column.text
                        color: "#808080"
                        font.pointSize: 11
                        anchors.centerIn: parent
                    }
                }
            }
        }

        Rectangle{
            id: calendarRect
            anchors.fill: parent
            color: backgroundColor

            Item {
                id:monthRectId
                width: parent.width - 20
                height: 24
                anchors.top: parent.top
                anchors.topMargin: 16
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: rightNextId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    rotation: LayoutMirroring.enabled ? 180 : 0
                    source: "qrc:/images/next.png"
                    sourceSize.width: parent.width / 8
                    sourceSize.height: parent.width / 8

                    MouseArea{
                        anchors.fill: parent
                        onClicked: nextMonth()
                    }
                }

                Image {
                    id: leftNextId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    rotation: LayoutMirroring.enabled ? 0 : 180
                    source: "qrc:/images/next.png"
                    sourceSize.width: parent.width / 8
                    sourceSize.height: parent.width / 8

                    MouseArea{
                        anchors.fill: parent
                        onClicked: previousMonth()
                    }

                }

                Text {
                    id: monthId
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: thisMonth + " " + todayYear
                    font.pointSize: 12
                    color: "#ffffff"
                }
            }

            Grid {
                id: gridId
                width: parent.width - 30
                height: parent.height - monthRectId.height - 28
                anchors.top: monthRectId.bottom
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 7
                columnSpacing: 8

                Component.onCompleted: {
                    createColumns()
                    createCells()
                }
            }
        }
    }

}
