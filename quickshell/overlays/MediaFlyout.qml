import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import "../theme"

PanelWindow {
    id: root

    property bool opened: false

    readonly property var players: Mpris.players.values
    readonly property var player: players.length > 0 ? players[0] : null
    readonly property bool hasPlayer: player !== null && player.trackTitle !== undefined && player.trackTitle.length > 0
    readonly property bool isPlaying: hasPlayer && (player.playbackState === MprisPlaybackState.Playing)

    visible: opened

    WlrLayershell.namespace: "quickshell-media"
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
        keyHandler.forceActiveFocus();
    }

    function close() {
        opened = false;
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
        Keys.onSpacePressed: {
            if (root.player) root.player.playPause();
        }
    }

    Rectangle {
        id: mediaCard
        anchors.top: parent.top
        anchors.topMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter

        width: 340
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
                    text: "󰎆 Reproductor Multimedia"
                    font.pixelSize: 12
                    font.bold: true
                    color: Colors.mauve
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰅖"
                    font.pixelSize: 13
                    color: closeMouse.containsMouse ? Colors.red : Colors.overlay1

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }

            // Carátula e información
            Row {
                width: parent.width
                spacing: 12

                // Carátula del álbum
                Rectangle {
                    width: 70
                    height: 70
                    radius: 10
                    color: Colors.surface0
                    clip: true
                    border.color: Colors.surface1
                    border.width: 1

                    Image {
                        id: artImage
                        anchors.fill: parent
                        source: root.hasPlayer ? (root.player.trackArtUrl || "") : ""
                        fillMode: Image.PreserveAspectCrop

                        Text {
                            anchors.centerIn: parent
                            visible: artImage.status !== Image.Ready
                            text: "󰎆"
                            font.pixelSize: 28
                            color: Colors.mauve
                        }
                    }
                }

                // Títulos
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 82
                    spacing: 4

                    Text {
                        text: root.hasPlayer ? (root.player.trackTitle || "Sin reproducción") : "No hay reproducción"
                        font.pixelSize: 13
                        font.bold: true
                        color: Colors.text
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: {
                            if (!root.hasPlayer) return "";
                            let arts = root.player.trackArtists;
                            if (!arts) return "Artista desconocido";
                            return Array.isArray(arts) ? arts.join(", ") : arts.toString();
                        }
                        font.pixelSize: 11
                        color: Colors.subtext0
                        elide: Text.ElideRight
                        width: parent.width
                        visible: text.length > 0
                    }

                    Text {
                        text: root.hasPlayer ? (root.player.trackAlbum || "") : ""
                        font.pixelSize: 10
                        color: Colors.overlay1
                        elide: Text.ElideRight
                        width: parent.width
                        visible: text.length > 0
                    }
                }
            }

            // Separador
            Rectangle {
                width: parent.width
                height: 1
                color: Colors.surface0
            }

            // Botones de control
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                // Anterior
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: prevM.containsMouse ? Colors.surface1 : Colors.surface0

                    Text {
                        anchors.centerIn: parent
                        text: "󰒮"
                        font.pixelSize: 16
                        color: Colors.text
                    }

                    MouseArea {
                        id: prevM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.player) root.player.previous();
                        }
                    }
                }

                // Play / Pausa
                Rectangle {
                    width: 44
                    height: 44
                    radius: 22
                    color: playM.containsMouse ? Colors.lavender : Colors.mauve

                    Text {
                        anchors.centerIn: parent
                        text: root.isPlaying ? "󰏤" : "󰐊"
                        font.pixelSize: 20
                        color: Colors.crust
                    }

                    MouseArea {
                        id: playM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.player) root.player.playPause();
                        }
                    }
                }

                // Siguiente
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: nextM.containsMouse ? Colors.surface1 : Colors.surface0

                    Text {
                        anchors.centerIn: parent
                        text: "󰒭"
                        font.pixelSize: 16
                        color: Colors.text
                    }

                    MouseArea {
                        id: nextM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.player) root.player.next();
                        }
                    }
                }
            }
        }
    }
}
