import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "../theme"

PanelWindow {
    id: root

    property bool isVisible: false
    property real lastVolume: -1.0

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0.0
    readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false

    visible: isVisible

    WlrLayershell.namespace: "quickshell-osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        bottom: true
        left: false
        right: false
        top: false
    }

    margins {
        bottom: 80
    }

    implicitWidth: 240
    implicitHeight: 52
    color: "transparent"

    onVolumeChanged: {
        if (lastVolume < 0) {
            lastVolume = volume;
            return;
        }
        if (Math.abs(volume - lastVolume) > 0.005) {
            lastVolume = volume;
            showOSD();
        }
    }

    onMutedChanged: {
        showOSD();
    }

    function showOSD() {
        isVisible = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1800
        onTriggered: root.isVisible = false
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.cardBg
        border.color: Colors.cardBorder
        border.width: 1.5

        Row {
            anchors.centerIn: parent
            spacing: 12
            width: parent.width - 24

            Text {
                text: root.muted ? "󰝟" : (root.volume > 0.5 ? "󰕾" : "󰖀")
                font.pixelSize: 20
                color: root.muted ? Colors.red : Colors.mauve
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6
                width: parent.width - 40

                Item {
                    width: parent.width
                    height: 14

                    Text {
                        anchors.left: parent.left
                        text: "Volumen"
                        font.pixelSize: 11
                        color: Colors.subtext0
                    }

                    Text {
                        anchors.right: parent.right
                        text: root.muted ? "Mudo" : (Math.round(root.volume * 100) + "%")
                        font.pixelSize: 11
                        font.bold: true
                        color: root.muted ? Colors.red : Colors.text
                    }
                }

                // Barra de progreso
                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Colors.surface0

                    Rectangle {
                        width: parent.width * Math.min(1.0, root.volume)
                        height: parent.height
                        radius: 3
                        color: root.muted ? Colors.overlay0 : Colors.mauve

                        Behavior on width { NumberAnimation { duration: 100 } }
                    }
                }
            }
        }
    }
}
