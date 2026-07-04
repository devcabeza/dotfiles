function layout_dev --description "Configura el layout exacto de 3 paneles (Neovim/opencode arriba, terminal completa abajo)"
    if not set -q TMUX
        echo "Error: Este comando solo funciona dentro de una sesión de tmux."
        return 1
    end

    # 1. Creamos la terminal abajo a todo lo ancho.
    # El "-d" (detach) es el truco: crea el panel abajo pero mantiene tu cursor ARRIBA.
    # -p 30 le da el 30% del alto total a la terminal de abajo.
    tmux split-window -v -p 20 -d

    # 2. Ahora que seguimos arriba, dividimos este panel a la mitad hacia la derecha.
    # Tu cursor se moverá automáticamente al nuevo panel derecho (opencode).
    tmux split-window -h -p 25

    # 3. Como el cursor saltó al panel superior derecho, ejecutamos opencode aquí:
    tmux send-keys "opencode" C-m

    # 4. Movemos el cursor hacia el panel de la izquierda (el original donde ejecutaste el comando)
    tmux select-pane -L

    # 5. Transformamos este panel superior izquierdo en Neovim:
    tmux send-keys "nvim" C-m
end
