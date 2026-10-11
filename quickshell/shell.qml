import QtQuick
import Quickshell
import Quickshell.Io
import "components"
import "overlays"

ShellRoot {
    id: root

    // Controlador IPC para permitir llamadas desde atajos de teclado de Hyprland
    // Comando: quickshell ipc call launcher toggle
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            launcherModal.toggle();
        }
    }

    // Controlador IPC para el menú de apagado
    // Comando: quickshell ipc call power toggle
    IpcHandler {
        target: "power"
        function toggle(): void {
            powerModal.toggle();
        }
    }

    // Modal del lanzador de aplicaciones
    AppLauncher {
        id: launcherModal
    }

    // Modal del menú de apagado/sesión
    PowerMenuModal {
        id: powerModal
    }

    // OSD flotante de volumen
    VolumeOSD {
        id: osdModal
    }

    // Barra superior instanciada en cada monitor conectado
    Variants {
        model: Quickshell.screens

        Bar {
            property var modelData
            screen: modelData
            onOpenLauncher: launcherModal.toggle()
            onOpenPowerMenu: powerModal.toggle()
        }
    }
}
