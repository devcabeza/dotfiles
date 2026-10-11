import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Rectangle {
    id: root

    property string ssid: "Conectado"
    property bool isConnected: true
    property bool isEthernet: false

    Process {
        id: netProc
        command: ["sh", "-c", "SSID=$(iwgetid -r 2>/dev/null); if [ -n \"$SSID\" ]; then echo \"wifi:$SSID\"; elif ip route show default | grep -q 'dev '; then echo \"eth:Cable\"; else echo \"none:Desconectado\"; fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                let parts = out.split(":");
                if (parts.length >= 2) {
                    let type = parts[0];
                    let name = parts.slice(1).join(":");
                    root.isConnected = (type !== "none");
                    root.isEthernet = (type === "eth");
                    root.ssid = name;
                }
            }
        }
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    implicitWidth: contentRow.implicitWidth + 18
    implicitHeight: 28
    radius: 8
    color: mouseArea.containsMouse ? Colors.surface1 : Colors.surface0
    border.color: mouseArea.containsMouse ? Colors.blue : Colors.surface1
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: !root.isConnected ? "󰤭" : (root.isEthernet ? "󰈀" : "󰤨")
            font.pixelSize: 13
            color: root.isConnected ? Colors.blue : Colors.red
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
            text: root.ssid
            font.pixelSize: 11
            font.weight: Font.Medium
            color: root.isConnected ? Colors.text : Colors.overlay0
            elide: Text.ElideRight
            maximumLineCount: 1
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["kitty", "-e", "nmtui"])
    }
}
