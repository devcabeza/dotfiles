import QtQuick
import Quickshell
import "../theme"

Rectangle {
    id: root

    signal openPowerMenu()

    width: 28
    height: 24
    radius: 7

    color: mouseArea.containsMouse ? Colors.red : "#25f38ba8"

    Behavior on color { ColorAnimation { duration: 130 } }

    Text {
        anchors.centerIn: parent
        text: "⏻"
        font.pixelSize: 13
        color: mouseArea.containsMouse ? Colors.crust : Colors.red
        scale: mouseArea.containsMouse ? 1.1 : 1.0

        Behavior on color { ColorAnimation { duration: 130 } }
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutBack } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.openPowerMenu()
    }
}
