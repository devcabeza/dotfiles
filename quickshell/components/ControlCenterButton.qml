import QtQuick
import "../theme"

Rectangle {
    id: root

    signal openControlCenter()

    width: 26
    height: 24
    radius: 7

    color: mouseArea.containsMouse ? Colors.surface1 : "transparent"

    Behavior on color { ColorAnimation { duration: 130 } }

    Text {
        anchors.centerIn: parent
        text: "󱊖"
        font.pixelSize: 14
        color: mouseArea.containsMouse ? Colors.lavender : Colors.subtext1
        scale: mouseArea.containsMouse ? 1.15 : 1.0

        Behavior on color { ColorAnimation { duration: 130 } }
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutBack } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.openControlCenter()
    }
}
