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

    implicitWidth: contentRow.implicitWidth + 20
    implicitHeight: 28
    radius: 8
    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0
    border.color: mouseArea.containsMouse ? Colors.mauve : Colors.surface1
    border.width: 1

    Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 7

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
