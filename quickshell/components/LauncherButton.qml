import QtQuick
import "../theme"

Rectangle {
    id: root

    signal clicked()

    width: 28
    height: 24
    radius: 7
    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0

    Behavior on color { ColorAnimation { duration: 130 } }

    Text {
        anchors.centerIn: parent
        text: "󰣇"
        font.pixelSize: 15
        color: mouseArea.containsMouse ? Colors.mauve : Colors.blue
        scale: mouseArea.containsMouse ? 1.15 : 1.0

        Behavior on color { ColorAnimation { duration: 130 } }
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutBack } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
