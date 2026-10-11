import QtQuick
import Quickshell
import "../theme"

Rectangle {
    id: root

    width: 34
    height: 28
    radius: 8
    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0
    border.color: mouseArea.containsMouse ? Colors.sapphire : Colors.surface1
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text: "󰍛"
        font.pixelSize: 14
        color: mouseArea.containsMouse ? Colors.sapphire : Colors.subtext1
        scale: mouseArea.containsMouse ? 1.15 : 1.0

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached(["sh", "-c", "if pgrep -f '^kitty --class btop-floating' > /dev/null 2>&1; then pkill -f '^kitty --class btop-floating'; else kitty --class btop-floating -e btop; fi"]);
        }
    }
}
