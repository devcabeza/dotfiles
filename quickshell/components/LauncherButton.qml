import QtQuick
import "../theme"

Rectangle {
    id: root

    signal clicked()

    width: 34
    height: 28
    radius: 8
    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0
    border.color: mouseArea.containsMouse ? Colors.mauve : Colors.surface1
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text: "󰣇"
        font.pixelSize: 16
        color: mouseArea.containsMouse ? Colors.mauve : Colors.blue
        scale: mouseArea.containsMouse ? 1.15 : 1.0

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
