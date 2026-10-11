import QtQuick
import Quickshell
import Quickshell.Wayland
import "../theme"

Rectangle {
    id: root

    property var targetWindow: null
    property bool active: false

    IdleInhibitor {
        id: inhibitor
        window: root.targetWindow
        enabled: root.active
    }

    width: active ? 42 : 24
    height: 24
    radius: 7

    color: active ? Colors.surface1 : (mouseArea.containsMouse ? Colors.surface0 : "transparent")

    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on color { ColorAnimation { duration: 130 } }

    Row {
        anchors.centerIn: parent
        spacing: 3

        Text {
            text: "󰅶"
            font.pixelSize: 13
            color: root.active ? Colors.peach : (mouseArea.containsMouse ? Colors.peach : Colors.overlay1)
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 130 } }
        }

        Text {
            text: "ON"
            visible: root.active
            font.pixelSize: 9
            font.bold: true
            color: Colors.peach
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.active = !root.active;
        }
    }
}
