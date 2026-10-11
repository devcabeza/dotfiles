import QtQuick
import Quickshell
import "../theme"

Rectangle {
    id: root

    signal openPowerMenu()

    width: 34
    height: 28
    radius: 8

    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0
    border.color: mouseArea.containsMouse ? Colors.red : Colors.surface1
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text: "⏻"
        font.pixelSize: 14
        color: mouseArea.containsMouse ? Colors.red : Colors.subtext1
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.openPowerMenu()
    }
}
