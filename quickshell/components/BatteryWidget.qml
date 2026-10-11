import QtQuick
import Quickshell.Io
import "../theme"

Rectangle {
    id: root

    property int percent: 100
    property string status: "Full"

    readonly property bool isCharging: status === "Charging"
    readonly property bool isLow: percent <= 20 && !isCharging

    function getBatteryIcon() {
        if (isCharging) return "󰂄";
        if (percent >= 90) return "󰁹";
        if (percent >= 70) return "󰂀";
        if (percent >= 50) return "󰁾";
        if (percent >= 30) return "󰁼";
        if (percent >= 15) return "󰁻";
        return "󰁺";
    }

    Process {
        id: proc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n");
                if (lines.length >= 2) {
                    root.percent = parseInt(lines[0]) || 100;
                    root.status = lines[1].trim();
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
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
            text: root.getBatteryIcon()
            font.pixelSize: 13
            color: root.isLow ? Colors.red : (root.isCharging ? Colors.green : Colors.teal)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.percent + "%"
            font.pixelSize: 11
            font.weight: Font.Medium
            color: root.isLow ? Colors.red : Colors.text
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
