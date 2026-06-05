#!/usr/bin/env python3
import os
import sys
import glob
import json
import urllib.request
import subprocess

OLLAMA_URL = "http://localhost:11434/api/generate"
OLLAMA_MODEL = "qwen2.5:3b"

# 1. Phonetic Correction Dictionary (Speech-to-Text Corrections)
PHONETIC_MAP = {
    "eslaf": "slack", "eslac": "slack", "eslak": "slack", "deflect": "slack", "slack": "slack", "like": "slack",
    "zet": "zed", "sed": "zed", "se": "zed", "set": "zed", "zed": "zed", "teatres": "zed", "test": "zed",
    "breiv": "brave", "break": "brave", "brace": "brave", "brave": "brave", "brave-browser": "brave",
    "gosty": "ghostty", "ghosty": "ghostty", "ghostty": "ghostty", "ostía": "ghostty", "ostia": "ghostty", "gostia": "ghostty", "hostia": "ghostty",
    "nautilo": "files", "notilus": "files", "nautilus": "files", "archivos": "files", "explorador": "files",
    "terminal": "alacritty", "consola": "alacritty", "alacritty": "alacritty", "alacrite": "alacritty",
    "postman": "postman", "pazman": "postman", "pasman": "postman",
    "discord": "discord", "spotify": "spotify", "obsidian": "obsidian"
}

def preprocess_transcript(transcript):
    words = transcript.lower().split()
    cleaned_words = []
    for w in words:
        w_clean = w.strip(".,?!;:")
        if w_clean in PHONETIC_MAP:
            cleaned_words.append(PHONETIC_MAP[w_clean])
        else:
            cleaned_words.append(w)
    return " ".join(cleaned_words)

SYSTEM_PROMPT = """Eres un clasificador de comandos de voz para un entorno Linux (Hyprland).
Clasifica la solicitud del usuario en uno de los siguientes intents y devuelve ÚNICAMENTE un objeto JSON válido.

Intents disponibles:
1. "launch_app": El usuario quiere abrir una aplicación instalada o un documento.
   Campos: {"intent": "launch_app", "target": "<nombre de app>"}
2. "system_command": El usuario quiere realizar un control del sistema (volumen, cerrar ventana, etc.).
   Campos: {"intent": "system_command", "target": "<accion>"}
3. "search_web": El usuario quiere buscar en internet o abrir una web.
   Campos: {"intent": "search_web", "target": "<consulta o url>"}
4. "open_launcher": El usuario quiere abrir el lanzador de aplicaciones general.
   Campos: {"intent": "open_launcher", "target": ""}
5. "create_note": El usuario quiere crear una nota, un archivo o escribir un documento con contenido generado por la IA en Obsidian.
   Campos: {"intent": "create_note", "target": "Obsidian", "title": "<nombre_de_archivo.md>", "prompt": "<instruccion_de_lo_que_debe_explicar_la_nota>"}

Reglas de salida:
- Devuelve SOLO el JSON crudo, sin markdown, sin explicaciones.
- Si no estás seguro o no encaja, usa {"intent": "unknown", "target": ""}."""

def ensure_hyprland_signature():
    uid = os.getuid()
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    sock_path = f"/run/user/{uid}/hypr/{sig}/.socket.sock" if sig else ""
    if not sig or not os.path.exists(sock_path):
        hypr_dir = f"/run/user/{uid}/hypr"
        if os.path.exists(hypr_dir):
            sockets = []
            for d in os.listdir(hypr_dir):
                sp = os.path.join(hypr_dir, d, ".socket.sock")
                if os.path.exists(sp):
                    sockets.append(d)
            if sockets:
                sockets.sort() # Sort alphabetically, newest is last (highest timestamp)
                newest_signature = sockets[-1]
                os.environ["HYPRLAND_INSTANCE_SIGNATURE"] = newest_signature
                print(f"[Info] Set Hyprland signature: {newest_signature}")

def call_ollama(prompt):
    data = {
        "model": OLLAMA_MODEL,
        "prompt": prompt,
        "system": SYSTEM_PROMPT,
        "stream": False
    }
    req = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(data).encode("utf-8"),
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req, timeout=12) as response:
            res = json.loads(response.read().decode("utf-8"))
            return res.get("response", "").strip()
    except Exception as e:
        print(f"[Error] Ollama call failed: {e}")
        return None

def scan_desktop_applications():
    paths = [
        "/usr/share/applications/*.desktop",
        os.path.expanduser("~/.local/share/applications/*.desktop"),
        os.path.expanduser("~/.nix-profile/share/applications/*.desktop"),
        "/run/current-system/sw/share/applications/*.desktop",
        "/var/lib/flatpak/exports/share/applications/*.desktop",
        os.path.expanduser("~/.local/share/flatpak/exports/share/applications/*.desktop")
    ]
    apps = {}
    for path_pattern in paths:
        for filepath in glob.glob(path_pattern):
            try:
                with open(filepath, "r", errors="ignore") as f:
                    name = None
                    for line in f:
                        if line.startswith("Name="):
                            name = line.split("=", 1)[1].strip()
                            break
                    if name:
                        desktop_name = os.path.basename(filepath).replace(".desktop", "")
                        # Store display name as key, desktop ID and command as values
                        apps[name] = {
                            "desktop_name": desktop_name,
                            "command": f"gtk-launch {desktop_name}"
                        }
            except Exception as e:
                pass
    return apps

def run_in_hyprland(cmd):
    ensure_hyprland_signature()
    # Escape double quotes to prevent breaking the Lua string wrapping
    escaped_cmd = cmd.replace('"', '\\"')
    full_cmd = f"hyprctl dispatch 'hl.dsp.exec_cmd(\"{escaped_cmd}\")'"
    print(f"[Executing via Hyprland] {full_cmd}")
    res = subprocess.run(full_cmd, shell=True, capture_output=True, text=True)
    print(f"[Hyprland Output] Stdout: {res.stdout.strip()} | Stderr: {res.stderr.strip()}")

def main():
    if len(sys.argv) < 2:
        print("[Error] No transcript provided.")
        sys.exit(1)
        
    transcript = sys.argv[1].strip()
    if not transcript:
        print("[Info] Empty transcript.")
        sys.exit(0)

    # Apply phonetic pre-processing to fix spelling and pronunciation errors in speech
    transcript = preprocess_transcript(transcript)
    print(f"[Info] Transcript received (preprocessed): {transcript}")
    
    # Custom Intercept: Open the AI guide document if requested
    transcript_lower = transcript.lower()
    if any(x in transcript_lower for x in ["guia de la ia", "documento de la ia", "documento explicativo", "como funciona la ia", "guia de ia", "funciona la ia", "explicacion de la ia"]):
        print("[Custom Intercept] Launching AI guide document.")
        run_in_hyprland("xdg-open /home/alejandrocabeza/Documentos/guia_ia.md")
        subprocess.run(
            'notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Documento AI" "Abriendo guía de la IA..."',
            shell=True
        )
        sys.exit(0)
    
    # Classify intent via Ollama
    ollama_res = call_ollama(transcript)
    if not ollama_res:
        print("[Error] Failed to get response from Ollama.")
        sys.exit(1)
        
    print(f"[Ollama Response] {ollama_res}")
    
    try:
        # Clean response if it contains markdown codeblock
        if "```" in ollama_res:
            lines = ollama_res.split("\n")
            json_lines = [l for l in lines if not l.strip().startswith("```")]
            ollama_res = "\n".join(json_lines).strip()
            
        data = json.loads(ollama_res)
    except Exception as e:
        print(f"[Error] Failed to parse JSON: {e}. Raw: {ollama_res}")
        # Default fallback
        data = {"intent": "unknown", "target": transcript}

    intent = data.get("intent", "unknown")
    target = data.get("target", "").strip()
    
    print(f"[Parsed] Intent: {intent} | Target: {target}")

    if intent == "launch_app":
        apps = scan_desktop_applications()
        target_clean = target.lower()
        
        # Apply phonetic map if available
        if target_clean in PHONETIC_MAP:
            mapped_name = PHONETIC_MAP[target_clean]
            print(f"[Phonetic Correction] {target_clean} -> {mapped_name}")
            target_clean = mapped_name
            
        # Find matches
        matches = []
        for app_name, app_info in apps.items():
            if target_clean == app_name.lower() or target_clean == app_info["desktop_name"].lower():
                matches.append((app_name, app_info))
                break
        
        # If no exact match, try substring match
        if not matches:
            for app_name, app_info in apps.items():
                if target_clean in app_name.lower() or target_clean in app_info["desktop_name"].lower():
                    matches.append((app_name, app_info))

        if matches:
            # If there is exactly ONE match, launch it immediately!
            if len(matches) == 1:
                app_name, app_info = matches[0]
                print(f"[Single Match] Launching {app_name} directly.")
                run_in_hyprland(app_info["command"])
                subprocess.run(
                    f'notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Launcher" "Lanzando {app_name}..."',
                    shell=True
                )
                return

            # We found matching application(s)!
            # We will display them via hyprlauncher --dmenu as requested
            print(f"[Matches Found] {[m[0] for m in matches]}")
            
            # Format option list
            options = "\n".join([m[0] for m in matches]) + "\n"
            
            try:
                proc = subprocess.Popen(
                    ["hyprlauncher", "--dmenu"],
                    stdin=subprocess.PIPE,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True
                )
                stdout, stderr = proc.communicate(input=options, timeout=30)
                selected = stdout.strip()
                print(f"[Hyprlauncher Selection] Selected: '{selected}'")
                
                if selected:
                    # Find the selected app launch command
                    selected_info = None
                    for name, info in matches:
                        if name == selected:
                            selected_info = info
                            break
                    
                    if selected_info:
                        run_in_hyprland(selected_info["command"])
                        # Notify user
                        subprocess.run(
                            f'notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Launcher" "Lanzando {selected}..."',
                            shell=True
                        )
                    else:
                        print(f"[Warning] Selected app '{selected}' not found in matches.")
                else:
                    print("[Info] Hyprlauncher closed without selection.")
            except subprocess.TimeoutExpired:
                proc.kill()
                print("[Error] Hyprlauncher execution timed out.")
            except Exception as e:
                print(f"[Error] Failed to run hyprlauncher: {e}")
                # Fallback to direct launching the first match if launcher fails
                print("[Info] Falling back to direct launch.")
                run_in_hyprland(matches[0][1]["command"])
        else:
            print(f"[Warning] No applications found matching '{target}'. Opening full launcher.")
            run_in_hyprland("hyprlauncher")

    elif intent == "create_note":
        title = data.get("title", "nota_ia.md").strip()
        note_prompt = data.get("prompt", target).strip()
        
        # Notify user that note is being generated
        subprocess.run(
            f'notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Voice AI" "Generando nota: {title}..."',
            shell=True
        )
        
        # Call Ollama to generate the content for this note
        gen_prompt = f"Genera un documento Markdown detallado, completo y profesional en español para una nota de Obsidian sobre el tema: '{note_prompt}'. Explica todos los puntos solicitados de manera clara y exhaustiva. Escribe UNICAMENTE el contenido de la nota en formato Markdown, sin introducciones ni comentarios adicionales."
        content = call_ollama(gen_prompt)
        
        if content:
            # Clean markdown code block wraps if Ollama output them
            if content.startswith("```markdown"):
                content = content[11:]
            elif content.startswith("```"):
                content = content[3:]
            if content.endswith("```"):
                content = content[:-3]
            content = content.strip()
            
            # Obsidian Vault path
            vault_dir = "/home/alejandrocabeza/Documentos/Alejandro Cabeza/Notas"
            if not os.path.exists(vault_dir):
                vault_dir = "/home/alejandrocabeza/Documentos/Alejandro Cabeza"
                
            # If title does not end with .md, add it
            if not title.lower().endswith(".md"):
                title += ".md"
                
            filepath = os.path.join(vault_dir, title)
            try:
                with open(filepath, "w") as f:
                    f.write(content)
                print(f"[Create Note] Note saved to {filepath}")
                
                # Notify success
                subprocess.run(
                    f'notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Voice AI" "Nota guardada en Obsidian!"',
                    shell=True
                )
                
                # Open the note in Obsidian using its native URI scheme
                import urllib.parse
                vault_name = "Alejandro Cabeza"
                rel_path = f"Notas/{title}" if "Notas" in vault_dir else title
                obsidian_uri = f"obsidian://open?vault={urllib.parse.quote(vault_name)}&file={urllib.parse.quote(rel_path)}"
                
                run_in_hyprland(f'xdg-open "{obsidian_uri}"')
            except Exception as e:
                print(f"[Error] Failed to write note: {e}")
                subprocess.run(
                    f'notify-send "Voice AI" "Error al guardar la nota en Obsidian: {e}"',
                    shell=True
                )
        else:
            print("[Error] Ollama content generation returned empty result.")
            subprocess.run(
                'notify-send "Voice AI" "Error al generar contenido con Ollama"',
                shell=True
            )

    elif intent == "open_launcher":
        run_in_hyprland("hyprlauncher")
        
    elif intent == "system_command":
        # Map target system actions
        action = target.lower()
        if action == "volume_up":
            run_in_hyprland("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
        elif action == "volume_down":
            run_in_hyprland("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        elif action == "mute":
            run_in_hyprland("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        elif action == "close_window":
            run_in_hyprland("hl.dsp.window.close()")
        else:
            print(f"[Warning] Unknown system action: {action}")
            
    elif intent == "search_web":
        query = target
        if query.startswith("http://") or query.startswith("https://") or "." in query and " " not in query:
            url = query if query.startswith("http") else f"https://{query}"
        else:
            # URL encode query
            import urllib.parse
            url = f"https://google.com/search?q={urllib.parse.quote(query)}"
        run_in_hyprland(f"xdg-open '{url}'")
        
    else:
        # Fallback: search web for the transcription
        import urllib.parse
        url = f"https://google.com/search?q={urllib.parse.quote(transcript)}"
        run_in_hyprland(f"xdg-open '{url}'")

if __name__ == "__main__":
    main()
