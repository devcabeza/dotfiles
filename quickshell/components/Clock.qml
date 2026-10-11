import QtQuick
import "../theme"

Rectangle {
    id: root

    property bool showFullDate: false
    property string timeString: ""
    property string dateString: ""

    function updateTime() {
        let now = new Date();
        timeString = Qt.formatTime(now, "hh:mm");
        dateString = Qt.formatDate(now, "ddd, d 'de' MMMM");
    }

    Component.onCompleted: updateTime()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTime()
    }

    implicitWidth: contentRow.implicitWidth + 14
    implicitHeight: 26
    radius: 7
    color: mouseArea.containsMouse ? Colors.surface0 : "transparent"

    Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on color { ColorAnimation { duration: 130 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.showFullDate ? "󰃭" : "󱑂"
            font.pixelSize: 13
            color: Colors.mauve
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.showFullDate ? (root.dateString + " · " + root.timeString) : root.timeString
            font.pixelSize: 12
            font.bold: true
            color: Colors.text
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showFullDate = !root.showFullDate
    }
}
