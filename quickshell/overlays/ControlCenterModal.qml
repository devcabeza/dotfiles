import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "../theme"

PanelWindow {
    id: root

    property bool opened: false

    property bool wifiEnabled: true
    property bool btEnabled: true
    property bool dndEnabled: false
    property bool caffeineActive: false

    property int brightnessPercent: 100

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0.0
    readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false

    visible: opened

    WlrLayershell.namespace: "quickshell-controlcenter"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    function toggle() {
        if (opened) close();
        else open();
    }

    function open() {
        opened = true;
        refreshStates();
        keyHandler.forceActiveFocus();
    }

    function close() {
        opened = false;
    }

    function refreshStates() {
        refreshProc.running = true;
    }

    Process {
        id: refreshProc
        command: ["sh", "-c", "echo wifi:$(nmcli radio wifi); echo bt:$(bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo on || echo off); echo dnd:$(dunstctl is-paused 2>/dev/null); echo bri:$(brightnessctl -m | cut -d, -f4 | tr -d '%')"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n");
                for (let i = 0; i < lines.length; ++i) {
                    let parts = lines[i].split(":");
                    if (parts.length >= 2) {
                        let k = parts[0];
                        let v = parts[1].trim();
                        if (k === "wifi") root.wifiEnabled = (v === "enabled");
                        if (k === "bt") root.btEnabled = (v === "on");
                        if (k === "dnd") root.dndEnabled = (v === "true");
                        if (k === "bri") root.brightnessPercent = parseInt(v) || 100;
                    }
                }
            }
        }
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: "#4411111b"
        opacity: root.opened ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    Item {
        id: keyHandler
        focus: true
        Keys.onEscapePressed: root.close()
    }

    Rectangle {
        id: centerCard
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 48
        anchors.rightMargin: 12

        width: 320
        height: cardCol.implicitHeight + 28
        radius: 14
        color: Colors.cardBg
        border.color: Colors.cardBorder
        border.width: 1.5

        scale: root.opened ? 1.0 : 0.95
        opacity: root.opened ? 1.0 : 0.0

        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {}
        }

        Column {
            id: cardCol
            anchors.top: parent.top
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.right: parent.right
            anchors.rightMargin: 14
            spacing: 12

            // Encabezado
            Item {
                width: parent.width
                height: 20

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󱊖 Centro de Control"
                    font.pixelSize: 13
                    font.bold: true
                    color: Colors.lavender
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰅖"
                    font.pixelSize: 13
                    color: closeM.containsMouse ? Colors.red : Colors.overlay1

                    MouseArea {
                        id: closeM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }

            // Sliders: Volumen y Brillo
            Column {
                width: parent.width
                spacing: 10

                // Slider Volumen
                Rectangle {
                    width: parent.width
                    height: 38
                    radius: 9
                    color: Colors.surface0
                    border.color: Colors.surface1
                    border.width: 1

                    // Relleno del volumen
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.min(1.0, root.volume)
                        radius: 9
                        color: root.muted ? Colors.surface2 : Colors.teal
                        opacity: 0.35
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.muted ? "󰝟" : (root.volume > 0.5 ? "󰕾" : "󰖀")
                            font.pixelSize: 15
                            color: root.muted ? Colors.red : Colors.teal
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.muted ? "Mudo" : (Math.round(root.volume * 100) + "%")
                            font.pixelSize: 11
                            font.bold: true
                            color: Colors.text
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mouse => {
                            let newVol = Math.max(0.0, Math.min(1.0, mouse.x / parent.width));
                            if (root.sink && root.sink.audio) {
                                root.sink.audio.volume = newVol;
                                if (root.sink.audio.muted) root.sink.audio.muted = false;
                            }
                        }
                    }
                }

                // Slider Brillo
                Rectangle {
                    width: parent.width
                    height: 38
                    radius: 9
                    color: Colors.surface0
                    border.color: Colors.surface1
                    border.width: 1

                    // Relleno del brillo
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * (root.brightnessPercent / 100.0)
                        radius: 9
                        color: Colors.peach
                        opacity: 0.35
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰃠"
                            font.pixelSize: 15
                            color: Colors.peach
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.brightnessPercent + "%"
                            font.pixelSize: 11
                            font.bold: true
                            color: Colors.text
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mouse => {
                            let pct = Math.round(Math.max(5, Math.min(100, (mouse.x / parent.width) * 100)));
                            root.brightnessPercent = pct;
                            Quickshell.execDetached(["brightnessctl", "set", pct + "%"]);
                        }
                    }
                }
            }

            // Quick Toggles Grid (2x2)
            Grid {
                width: parent.width
                columns: 2
                spacing: 8

                // Toggle Wi-Fi
                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 48
                    radius: 9
                    color: root.wifiEnabled ? Colors.surface1 : Colors.surface0
                    border.color: root.wifiEnabled ? Colors.blue : Colors.surface1
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: root.wifiEnabled ? "󰤨" : "󰤭"
                            font.pixelSize: 16
                            color: root.wifiEnabled ? Colors.blue : Colors.overlay1
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                text: "Wi-Fi"
                                font.pixelSize: 11
                                font.bold: true
                                color: Colors.text
                            }

                            Text {
                                text: root.wifiEnabled ? "Activo" : "Apagado"
                                font.pixelSize: 9
                                color: Colors.subtext0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.LeftButton) {
                                let newState = !root.wifiEnabled;
                                root.wifiEnabled = newState;
                                Quickshell.execDetached(["nmcli", "radio", "wifi", newState ? "on" : "off"]);
                            } else {
                                Quickshell.execDetached(["kitty", "-e", "nmtui"]);
                            }
                        }
                    }
                }

                // Toggle Bluetooth
                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 48
                    radius: 9
                    color: root.btEnabled ? Colors.surface1 : Colors.surface0
                    border.color: root.btEnabled ? Colors.sapphire : Colors.surface1
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "󰂯"
                            font.pixelSize: 16
                            color: root.btEnabled ? Colors.sapphire : Colors.overlay1
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                text: "Bluetooth"
                                font.pixelSize: 11
                                font.bold: true
                                color: Colors.text
                            }

                            Text {
                                text: root.btEnabled ? "Activo" : "Apagado"
                                font.pixelSize: 9
                                color: Colors.subtext0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.LeftButton) {
                                let newState = !root.btEnabled;
                                root.btEnabled = newState;
                                Quickshell.execDetached(["bluetoothctl", "power", newState ? "on" : "off"]);
                            } else {
                                Quickshell.execDetached(["blueman-manager"]);
                            }
                        }
                    }
                }

                // Toggle DND (No Molestar)
                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 48
                    radius: 9
                    color: root.dndEnabled ? Colors.surface1 : Colors.surface0
                    border.color: root.dndEnabled ? Colors.mauve : Colors.surface1
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: root.dndEnabled ? "󰂛" : "󰂚"
                            font.pixelSize: 16
                            color: root.dndEnabled ? Colors.mauve : Colors.overlay1
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                text: "No Molestar"
                                font.pixelSize: 11
                                font.bold: true
                                color: Colors.text
                            }

                            Text {
                                text: root.dndEnabled ? "Silencio" : "Normal"
                                font.pixelSize: 9
                                color: Colors.subtext0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.dndEnabled = !root.dndEnabled;
                            Quickshell.execDetached(["dunstctl", "set-paused", "toggle"]);
                        }
                    }
                }

                // Toggle Cafeína (Keep Awake)
                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 48
                    radius: 9
                    color: root.caffeineActive ? Colors.surface1 : Colors.surface0
                    border.color: root.caffeineActive ? Colors.peach : Colors.surface1
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "󰅶"
                            font.pixelSize: 16
                            color: root.caffeineActive ? Colors.peach : Colors.overlay1
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                text: "Cafeína"
                                font.pixelSize: 11
                                font.bold: true
                                color: Colors.text
                            }

                            Text {
                                text: root.caffeineActive ? "Despierto" : "Inactivo"
                                font.pixelSize: 9
                                color: Colors.subtext0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.caffeineActive = !root.caffeineActive;
                        }
                    }
                }
            }

            // Separador
            Rectangle {
                width: parent.width
                height: 1
                color: Colors.surface0
            }

            // Acciones Rápidas (Iconos inferiores)
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Repeater {
                    model: [
                        { icon: "󰕾", tooltip: "Audio", cmd: "pavucontrol", accent: Colors.teal },
                        { icon: "󰍛", tooltip: "Btop", cmd: "kitty --class btop-floating -e btop", accent: Colors.sapphire },
                        { icon: "󰤨", tooltip: "Red", cmd: "kitty -e nmtui", accent: Colors.blue },
                        { icon: "󰂯", tooltip: "Bluetooth", cmd: "which blueman-manager >/dev/null 2>&1 && blueman-manager || kitty -e bluetoothctl", accent: Colors.lavender }
                    ]

                    Rectangle {
                        width: 38
                        height: 32
                        radius: 7
                        color: actionM.containsMouse ? Colors.surface1 : Colors.surface0
                        border.color: actionM.containsMouse ? modelData.accent : Colors.surface1
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.icon
                            font.pixelSize: 14
                            color: actionM.containsMouse ? modelData.accent : Colors.subtext0
                        }

                        MouseArea {
                            id: actionM
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.close();
                                Quickshell.execDetached(["sh", "-c", modelData.cmd]);
                            }
                        }
                    }
                }
            }
        }
    }
}
