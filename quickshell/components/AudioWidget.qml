import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../theme"

Rectangle {
    id: root

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0.0
    readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false

    function getVolumePercent() {
        return Math.round(volume * 100);
    }

    function getAudioIcon() {
        if (muted) return "󰝟";
        let pct = getVolumePercent();
        if (pct >= 60) return "󰕾";
        if (pct >= 20) return "󰖀";
        return "󰕿";
    }

    implicitWidth: contentRow.implicitWidth + 12
    implicitHeight: 24
    radius: 7
    color: mouseArea.containsMouse ? Colors.surface0 : "transparent"

    Behavior on color { ColorAnimation { duration: 130 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: root.getAudioIcon()
            font.pixelSize: 13
            color: root.muted ? Colors.red : Colors.teal
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.muted ? "Silenciado" : (root.getVolumePercent() + "%")
            font.pixelSize: 11
            font.weight: Font.Medium
            color: root.muted ? Colors.overlay0 : Colors.text
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (root.sink && root.sink.audio) {
                    root.sink.audio.muted = !root.sink.audio.muted;
                }
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["pavucontrol"]);
            }
        }

        onWheel: wheel => {
            if (root.sink && root.sink.audio) {
                let step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                let newVol = Math.max(0.0, Math.min(1.0, root.volume + step));
                root.sink.audio.volume = newVol;
                if (root.sink.audio.muted && step > 0) {
                    root.sink.audio.muted = false;
                }
            }
        }
    }
}
