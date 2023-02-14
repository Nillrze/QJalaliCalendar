import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Button {
        anchors.centerIn: parent
        text: "open calendar"
        onClicked: if(!calendarPopup.opened)
                      {
                       console.log("first ")
//                       calendarPopup.currentDate  = {"y": 1401, "m": 10, "d": 21}
//                       calendarPopup.isStatic     = false
//                       calendarPopup.ptyExistDate = ["1401-09-05", "1401-09-15", "1401-09-25", "1401-11-16", "1401-11-27"]
//                       calendarPopup.isStatic     = true
                       calendarPopup.open()
                   }
    }

    CalendarPopup {
        id: calendarPopup
        currentDate  : {"y": 1401, "m": 9, "d": 4}
//        selectDate   : {"y": 1401, "m": 10, "d": 4}
        ptyExistDate : ["1401-09-05", "1401-09-15", "1401-09-25", "1401-11-16", "1401-11-27"]
        isStatic     : true
    }
}
