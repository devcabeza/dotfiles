import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme"

Rectangle {
    id: root

    property string windowTitle: "Escritorio"
    property string windowClass: ""

    function updateTitle() {
        if (!Hyprland.toplevels || !Hyprland.toplevels.values) {
            windowTitle = "Escritorio";
            windowClass = "";
            return;
        }
        let vals = Hyprland.toplevels.values;
        for (let i = 0; i < vals.length; ++i) {
            let top = vals[i];
            if (top && top.activated) {
                windowTitle = top.title && top.title.length > 0 ? top.title : "Escritorio";
                windowClass = (top.wmClass || "").toLowerCase();
                return;
            }
        }
        windowTitle = "Escritorio";
        windowClass = "";
    }

    function getWindowIcon() {
        let t = (windowTitle + " " + windowClass).toLowerCase();
        if (t.includes("kitty") || t.includes("terminal") || t.includes("foot") || t.includes("alacritty") || t.includes("bash") || t.includes("zsh")) {
            return "󰄛";
        }
        if (t.includes("firefox") || t.includes("chrome") || t.includes("zen") || t.includes("brave")) {
            return "󰈹";
        }
        if (t.includes("nvim") || t.includes("neovim") || t.includes("code") || t.includes("vsc")) {
            return "󰨞";
        }
        if (t.includes("discord") || t.includes("telegram") || t.includes("vesktop") || t.includes("slack")) {
            return "󰙯";
        }
        if (t.includes("spotify")) {
            return "󰓇";
        }
        if (t.includes("ranger") || t.includes("thunar") || t.includes("dolphin") || t.includes("files")) {
            return "󰉋";
        }
        return "󰣆";
    }

    function getIconColor() {
        let t = (windowTitle + " " + windowClass).toLowerCase();
        if (t.includes("kitty") || t.includes("terminal")) return Colors.green;
        if (t.includes("firefox") || t.includes("chrome")) return Colors.peach;
        if (t.includes("nvim") || t.includes("code")) return Colors.sapphire;
        if (t.includes("discord")) return Colors.mauve;
        if (t.includes("spotify")) return Colors.green;
        return Colors.blue;
    }

    Component.onCompleted: updateTitle()

    Connections {
        target: Hyprland
        function onRawEvent(name, data) {
            if (name === "activewindow" || name === "activewindowv2" || name === "windowtitle") {
                root.updateTitle();
            }
        }
    }

    implicitWidth: Math.min(titleRow.implicitWidth + 14, 220)
    implicitHeight: 26
    radius: 7
    color: mouseArea.containsMouse ? Colors.surface0 : "transparent"

    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on implicitWidth { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Row {
        id: titleRow
        anchors.centerIn: parent
        spacing: 6

        // Icono
        Text {
            text: root.getWindowIcon()
            font.pixelSize: 13
            color: root.getIconColor()
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        // Título
        Text {
            text: root.windowTitle
            font.pixelSize: 11
            font.weight: Font.Medium
            color: Colors.text
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 180)
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
