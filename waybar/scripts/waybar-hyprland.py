#!/usr/bin/env python3
import asyncio
import os
import re
import signal
import subprocess
import sys

def get_real_signature():
    try:
        out = subprocess.check_output(["hyprctl", "instances"], text=True)
        matches = re.findall(r"instance\s+([a-zA-Z0-9_]+):.*?pid:\s+(\d+)", out, re.DOTALL)
        for sig, pid in matches:
            if os.path.exists(f"/proc/{pid}"):
                return sig
    except Exception:
        pass
    
    # Fallback to HYPRLAND_INSTANCE_SIGNATURE env
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if sig and sig != "waybar_compat":
        return sig
    return None

def translate_command(cmd_str):
    cmd_str = cmd_str.strip()
    m = re.match(r"^dispatch\s+(?:workspace|focusworkspaceoncurrentmonitor)\s+(.+)$", cmd_str)
    if m:
        target = m.group(1).strip()
        if target.startswith("name:"):
            target = target[5:]
        return f'dispatch hl.dsp.focus({{ workspace = "{target}" }})'

    m = re.match(r"^dispatch\s+togglespecialworkspace(?:\s+(.+))?$", cmd_str)
    if m:
        target = (m.group(1) or "").strip()
        if target:
            return f'dispatch hl.dsp.workspace.toggle_special("{target}")'
        return 'dispatch hl.dsp.workspace.toggle_special()'

    return cmd_str

async def handle_client(reader, writer, real_sock):
    try:
        data = await reader.read(4096)
        if not data:
            writer.close()
            await writer.wait_closed()
            return
        cmd = data.decode("utf-8", errors="ignore")
        translated = translate_command(cmd)

        real_r, real_w = await asyncio.open_unix_connection(real_sock)
        real_w.write(translated.encode("utf-8"))
        await real_w.drain()

        resp = await real_r.read(4096)
        real_w.close()
        await real_w.wait_closed()

        writer.write(resp)
        await writer.drain()
    except Exception:
        pass
    finally:
        try:
            writer.close()
            await writer.wait_closed()
        except Exception:
            pass

async def main():
    sig = get_real_signature()
    if not sig:
        os.execvp("waybar", ["waybar"])

    uid = os.getuid()
    compat_dir = f"/run/user/{uid}/hypr/waybar_compat"
    real_dir = f"/run/user/{uid}/hypr/{sig}"
    real_sock = f"{real_dir}/.socket.sock"
    real_sock2 = f"{real_dir}/.socket2.sock"

    os.makedirs(compat_dir, exist_ok=True)
    compat_sock = f"{compat_dir}/.socket.sock"
    compat_sock2 = f"{compat_dir}/.socket2.sock"

    if os.path.exists(compat_sock):
        os.remove(compat_sock)
    if os.path.islink(compat_sock2) or os.path.exists(compat_sock2):
        os.remove(compat_sock2)
    os.symlink(real_sock2, compat_sock2)

    server = await asyncio.start_unix_server(
        lambda r, w: handle_client(r, w, real_sock),
        path=compat_sock
    )

    env = os.environ.copy()
    env["HYPRLAND_INSTANCE_SIGNATURE"] = "waybar_compat"

    proc = await asyncio.create_subprocess_exec("waybar", env=env)

    loop = asyncio.get_running_loop()
    stop_event = asyncio.Event()

    def on_signal():
        stop_event.set()

    for s in (signal.SIGINT, signal.SIGTERM):
        loop.add_signal_handler(s, on_signal)

    wait_task = asyncio.create_task(proc.wait())
    stop_task = asyncio.create_task(stop_event.wait())

    done, _ = await asyncio.wait([wait_task, stop_task], return_when=asyncio.FIRST_COMPLETED)

    if stop_task in done:
        try:
            proc.terminate()
            await proc.wait()
        except Exception:
            pass

    server.close()
    await server.wait_closed()
    if os.path.exists(compat_sock):
        os.remove(compat_sock)
    if os.path.islink(compat_sock2):
        os.remove(compat_sock2)

if __name__ == "__main__":
    asyncio.run(main())
