import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme"

Row {
    id: root
    spacing: 4

    function isOccupied(wsId) {
        if (!Hyprland.workspaces || !Hyprland.workspaces.values) return false;
        for (let i = 0; i < Hyprland.workspaces.values.length; ++i) {
            let ws = Hyprland.workspaces.values[i];
            if (ws && ws.id === wsId) return true;
        }
        return false;
    }

    Repeater {
        model: 5

        Rectangle {
            id: wsButton
            property int wsId: index + 1
            property bool isFocused: Hyprland.focusedWorkspace?.id === wsId
            property bool occupied: root.isOccupied(wsId)
            property bool hovered: mouseArea.containsMouse

            width: isFocused ? 28 : (occupied || hovered ? 20 : 8)
            height: 22
            radius: 6

            color: isFocused
                   ? Colors.mauve
                   : (occupied
                      ? (hovered ? Colors.surface2 : Colors.surface0)
                      : (hovered ? Colors.surface1 : "transparent"))

            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 130 } }

            // Número si está enfocado, ocupado o hovered
            Text {
                anchors.centerIn: parent
                visible: wsButton.isFocused || wsButton.occupied || wsButton.hovered
                text: wsId.toString()
                font.bold: wsButton.isFocused || wsButton.occupied
                font.pixelSize: 11
                color: wsButton.isFocused ? Colors.crust : (wsButton.occupied ? Colors.text : Colors.overlay0)
            }

            // Pequeño punto central si está vacío y no hovered
            Rectangle {
                anchors.centerIn: parent
                visible: !wsButton.isFocused && !wsButton.occupied && !wsButton.hovered
                width: 4
                height: 4
                radius: 2
                color: Colors.surface2
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = " + wsId + " })"]);
                }
            }
        }
    }
}
