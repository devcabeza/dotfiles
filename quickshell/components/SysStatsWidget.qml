import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Rectangle {
    id: root

    property int cpuPercent: 0
    property int ramPercent: 0

    Process {
        id: statsProc
        command: ["sh", "-c", "awk '/^cpu / {usage=($2+$4)*100/($2+$4+$5)} /^MemTotal:/ {total=$2} /^MemAvailable:/ {avail=$2} END {printf \"%.0f:%.0f\", usage, ((total-avail)*100/total)}' /proc/stat /proc/meminfo 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                let parts = out.split(":");
                if (parts.length >= 2) {
                    root.cpuPercent = parseInt(parts[0]) || 0;
                    root.ramPercent = parseInt(parts[1]) || 0;
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statsProc.running = true
    }

    implicitWidth: contentRow.implicitWidth + 12
    implicitHeight: 24
    radius: 7

    color: mouseArea.containsMouse ? Colors.surface0 : "transparent"

    Behavior on color { ColorAnimation { duration: 130 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        // CPU
        Row {
            spacing: 3
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "󰍛"
                font.pixelSize: 12
                color: root.cpuPercent > 80 ? Colors.red : Colors.sapphire
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.cpuPercent + "%"
                font.pixelSize: 11
                font.weight: Font.Medium
                color: root.cpuPercent > 80 ? Colors.red : Colors.text
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // RAM
        Row {
            spacing: 3
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "󰘚"
                font.pixelSize: 12
                color: root.ramPercent > 85 ? Colors.red : Colors.mauve
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.ramPercent + "%"
                font.pixelSize: 11
                font.weight: Font.Medium
                color: root.ramPercent > 85 ? Colors.red : Colors.text
                anchors.verticalCenter: parent.verticalCenter
            }
        }
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
