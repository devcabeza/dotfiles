import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme"

Row {
    id: root
    spacing: 5

    function isOccupied(wsId) {
        if (!Hyprland.workspaces || !Hyprland.workspaces.values) return false;
        for (let i = 0; i < Hyprland.workspaces.values.length; ++i) {
            let ws = Hyprland.workspaces.values[i];
            if (ws && ws.id === wsId) return true;
        }
        return false;
    }

    Repeater {
        model: 5 // Espacios de trabajo 1 a 5

        Rectangle {
            id: wsButton
            property int wsId: index + 1
            property bool isFocused: Hyprland.focusedWorkspace?.id === wsId
            property bool occupied: root.isOccupied(wsId)

            width: isFocused ? 34 : 26
            height: 26
            radius: 7

            color: isFocused
                   ? Colors.mauve
                   : (occupied
                      ? (mouseArea.containsMouse ? Colors.surface2 : Colors.surface1)
                      : (mouseArea.containsMouse ? Colors.surface1 : Colors.surface0))

            border.color: isFocused
                          ? Colors.mauve
                          : (mouseArea.containsMouse ? Colors.surface2 : (occupied ? Colors.surface1 : "transparent"))
            border.width: 1

            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: wsId.toString()
                font.bold: isFocused || occupied
                font.pixelSize: 11
                color: isFocused ? Colors.crust : (occupied ? Colors.text : Colors.overlay0)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    // Despacho compatible con Hyprland 0.56 (Lua)
                    Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = " + wsId + " })"]);
                }
            }
        }
    }
}
