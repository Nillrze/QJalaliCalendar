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
                       calendarPopup.open()
    }

    CalendarPopup {
        id: calendarPopup
    }
}
