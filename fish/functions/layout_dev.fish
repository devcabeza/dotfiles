function layout_dev --description "Configura un layout de 3 paneles (2 arriba, 1 abajo) en el tmux actual"
    # Verificar si realmente estamos dentro de tmux
    if not set -q TMUX
        echo "Error: Este comando solo funciona dentro de una sesión de tmux."
        return 1
    end

    # 1. El panel actual se convertirá en Neovim, pero primero creamos los demás.
    # Dividimos verticalmente para crear el panel de abajo (Terminal)
    # -v: división vertical (arriba/abajo), -p 35: el panel de abajo tendrá el 35% del alto
    tmux split-window -v -p 35

    # 2. Volvemos al panel de arriba (que ahora es el .1) para dividirlo horizontalmente
    tmux select-pane -t :.+
    
    # Dividimos horizontalmente (izquierda/derecha) para crear el panel de opencode
    # -h: división horizontal, -p 50: mitad y mitad
    tmux split-window -h -p 50

    # 3. Ahora que tenemos los 3 paneles, ejecutamos los comandos enviando "teclas"
    # Panel 1 (Arriba Izquierda) -> Neovim
    tmux send-keys -t :.1 "nvim" C-m

    # Panel 2 (Arriba Derecha) -> opencode
    # Usamos send-keys por si 'opencode' es un alias de tu shell
    tmux send-keys -t :.2 "opencode" C-m

    # Panel 3 (Abajo) -> Queda libre como terminal, solo le damos foco si quieres
    # Si prefieres empezar escribiendo en Neovim, cambia el foco al panel 1:
    tmux select-pane -t :.1
end

# Crear un alias corto para llamarlo fácilmente
