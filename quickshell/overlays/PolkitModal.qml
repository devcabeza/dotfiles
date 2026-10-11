import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Polkit
import "../theme"

PanelWindow {
    id: root

    property alias polkitAgent: agent

    PolkitAgent {
        id: agent
        onAuthenticationRequestStarted: {
            passwordInput.text = "";
            passwordInput.forceActiveFocus();
        }
    }

    visible: agent.isActive

    WlrLayershell.namespace: "quickshell-polkit"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: agent.isActive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    function submitAuth() {
        if (agent.flow && passwordInput.text.length > 0) {
            agent.flow.submit(passwordInput.text);
            passwordInput.text = "";
        }
    }

    function cancelAuth() {
        if (agent.flow) {
            agent.flow.cancelAuthenticationRequest();
        }
        passwordInput.text = "";
    }

    // Telón de fondo
    Rectangle {
        id: scrim
        anchors.fill: parent
        color: "#6611111b"

        MouseArea {
            anchors.fill: parent
            onClicked: root.cancelAuth()
        }
    }

    // Cuadro de diálogo centrado
    Rectangle {
        id: dialogCard
        anchors.centerIn: parent
        width: 380
        height: dialogCol.implicitHeight + 36
        radius: 14
        color: Colors.cardBg
        border.color: Colors.cardBorder
        border.width: 1.5

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {}
        }

        Column {
            id: dialogCol
            anchors.top: parent.top
            anchors.topMargin: 18
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.right: parent.right
            anchors.rightMargin: 18
            spacing: 14

            // Encabezado
            Row {
                width: parent.width
                spacing: 12

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: Colors.surface0
                    border.color: Colors.red
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󰌾"
                        font.pixelSize: 20
                        color: Colors.red
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 52
                    spacing: 2

                    Text {
                        text: "Autenticación requerida"
                        font.pixelSize: 14
                        font.bold: true
                        color: Colors.text
                    }

                    Text {
                        text: (agent.flow && agent.flow.message) ? agent.flow.message : "Se requieren privilegios administrativos"
                        font.pixelSize: 11
                        color: Colors.subtext0
                        wrapMode: Text.Wrap
                        width: parent.width
                    }
                }
            }

            // Mensaje de error si la contraseña fue incorrecta
            Text {
                visible: agent.flow && (agent.flow.failed || (agent.flow.supplementaryMessage && agent.flow.supplementaryMessage.length > 0))
                text: (agent.flow && agent.flow.supplementaryMessage) ? agent.flow.supplementaryMessage : "Contraseña incorrecta. Inténtalo nuevamente."
                font.pixelSize: 11
                color: Colors.red
                wrapMode: Text.Wrap
                width: parent.width
            }

            // Campo de contraseña
            Rectangle {
                width: parent.width
                height: 40
                radius: 8
                color: Colors.surface0
                border.color: passwordInput.activeFocus ? Colors.mauve : Colors.surface1
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        text: "󰌋"
                        font.pixelSize: 14
                        color: Colors.mauve
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextInput {
                        id: passwordInput
                        width: parent.width - 30
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 13
                        color: Colors.text
                        echoMode: TextInput.Password

                        Text {
                            text: "Introduce tu contraseña..."
                            color: Colors.overlay0
                            font.pixelSize: 13
                            visible: !passwordInput.text && !passwordInput.activeFocus
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Keys.onReturnPressed: root.submitAuth()
                        Keys.onEnterPressed: root.submitAuth()
                        Keys.onEscapePressed: root.cancelAuth()
                    }
                }
            }

            // Botones de acción
            Row {
                anchors.right: parent.right
                spacing: 10

                // Cancelar
                Rectangle {
                    width: 90
                    height: 34
                    radius: 7
                    color: cancelM.containsMouse ? Colors.surface1 : Colors.surface0
                    border.color: Colors.surface1
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Cancelar"
                        font.pixelSize: 12
                        color: Colors.text
                    }

                    MouseArea {
                        id: cancelM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cancelAuth()
                    }
                }

                // Autenticar
                Rectangle {
                    width: 100
                    height: 34
                    radius: 7
                    color: authM.containsMouse ? Colors.lavender : Colors.mauve

                    Text {
                        anchors.centerIn: parent
                        text: "Autenticar"
                        font.pixelSize: 12
                        font.bold: true
                        color: Colors.crust
                    }

                    MouseArea {
                        id: authM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.submitAuth()
                    }
                }
            }
        }
    }
}
