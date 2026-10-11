import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import "../theme"

Rectangle {
    id: root

    signal openFlyout()

    readonly property var players: Mpris.players.values
    readonly property var player: players.length > 0 ? players[0] : null
    readonly property bool hasPlayer: player !== null && player.trackTitle !== undefined && player.trackTitle.length > 0
    readonly property bool isPlaying: hasPlayer && (player.playbackState === MprisPlaybackState.Playing)

    visible: hasPlayer

    implicitWidth: contentRow.implicitWidth + 12
    implicitHeight: 24
    radius: 7

    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0

    Behavior on color { ColorAnimation { duration: 130 } }
    Behavior on implicitWidth { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        // Icono de música
        Text {
            text: root.isPlaying ? "󰎆" : "󰏤"
            font.pixelSize: 12
            color: Colors.mauve
            anchors.verticalCenter: parent.verticalCenter
        }

        // Título y artista
        Text {
            text: {
                if (!root.hasPlayer || !root.player) return "";
                let title = root.player.trackTitle || "Música";
                let arts = root.player.trackArtists;
                let artist = "";
                if (arts) {
                    artist = Array.isArray(arts) ? arts.join(", ") : arts.toString();
                }
                return artist.length > 0 ? (title + " - " + artist) : title;
            }
            font.pixelSize: 11
            font.weight: Font.Medium
            color: Colors.text
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 140)
            anchors.verticalCenter: parent.verticalCenter
        }

        // Mini control play/pause
        Rectangle {
            width: 18
            height: 18
            radius: 5
            color: playMouse.containsMouse ? Colors.surface2 : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: root.isPlaying ? "󰏤" : "󰐊"
                font.pixelSize: 10
                color: Colors.mauve
            }

            MouseArea {
                id: playMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.player) root.player.playPause();
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: -1
        onClicked: root.openFlyout()
    }
}
