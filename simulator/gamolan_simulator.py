import ctypes
import os
import queue
import re
import sys
import threading
import time
import tkinter as tk
from tkinter import ttk, messagebox

import numpy as np
import pygame
import serial
import serial.tools.list_ports

try:
    ctypes.windll.shcore.SetProcessDpiAwareness(1)
except Exception:
    pass

NOTES_DATA = [
    {"num": 1, "solfege": "DO", "freq": 523.25, "name": "do"},
    {"num": 2, "solfege": "RE", "freq": 587.33, "name": "re"},
    {"num": 3, "solfege": "MI", "freq": 659.25, "name": "mi"},
    {"num": 4, "solfege": "FA", "freq": 698.46, "name": "fa"},
    {"num": 5, "solfege": "SOL", "freq": 783.99, "name": "sol"},
    {"num": 6, "solfege": "LA", "freq": 880.00, "name": "la"},
    {"num": 7, "solfege": "SI", "freq": 987.77, "name": "si"},
    {"num": 8, "solfege": "DO'", "freq": 1046.50, "name": "do'"},
]

NAME_TO_NUM = {
    "do": 1, "re": 2, "mi": 3, "fa": 4,
    "sol": 5, "la": 6, "si": 7, "do'": 8, "do_t": 8
}

def generate_gamolan_sounds(sample_rate=44100, duration=1.4):
    if not pygame.mixer.get_init():
        pygame.mixer.init(frequency=sample_rate, size=-16, channels=2, buffer=512)

    sounds = {}
    t = np.linspace(0, duration, int(sample_rate * duration), False)
    
    for item in NOTES_DATA:
        freq = item["freq"]
        env_fund = np.exp(-t / 0.65)
        env_harm1 = np.exp(-t / 0.30)
        env_harm2 = np.exp(-t / 0.15)
        env_body = np.exp(-t / 0.45)
        env_click = np.exp(-t / 0.012)
        
        signal = (
            0.62 * np.sin(2 * np.pi * freq * t) * env_fund +
            0.22 * np.sin(2 * np.pi * freq * 2.756 * t) * env_harm1 +
            0.12 * np.sin(2 * np.pi * freq * 5.404 * t) * env_harm2 +
            0.08 * np.sin(2 * np.pi * freq * 2.0 * t) * env_body +
            0.18 * (np.random.rand(len(t)) * 2 - 1) * env_click
        )
        
        signal = signal / (np.max(np.abs(signal)) + 1e-6)
        pcm = (signal * 32760).astype(np.int16)
        stereo = np.column_stack((pcm, pcm))
        sounds[item["num"]] = pygame.sndarray.make_sound(stereo)
        
    return sounds

class GamolanSimulatorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Gamolan Pekhing Simulator (ESP32 Autonomous)")
        self.root.geometry("980x640")
        self.root.minsize(860, 560)
        self.root.configure(bg="#1E1E24")

        pygame.mixer.init(frequency=44100, size=-16, channels=2, buffer=512)
        pygame.mixer.set_num_channels(16)
        self.sounds = generate_gamolan_sounds()

        self.ser = None
        self.ser_thread = None
        self.is_connected = False
        self.msg_queue = queue.Queue()
        self.active_bars = {}
        self.last_hit_time = 0

        self._setup_ui()
        self._refresh_ports()
        self._poll_queue()

    def _setup_ui(self):
        top_frame = tk.Frame(self.root, bg="#262730", padx=12, pady=10)
        top_frame.pack(side=tk.TOP, fill=tk.X)

        lbl_port = tk.Label(top_frame, text="COM Port:", font=("Segoe UI", 10, "bold"), fg="#E0E0E0", bg="#262730")
        lbl_port.pack(side=tk.LEFT, padx=(0, 6))

        self.port_combobox = ttk.Combobox(top_frame, width=28, state="readonly", font=("Segoe UI", 9))
        self.port_combobox.pack(side=tk.LEFT, padx=(0, 6))

        btn_refresh = tk.Button(
            top_frame, text="⟳ Refresh", command=self._refresh_ports,
            bg="#3B3D4A", fg="#FFFFFF", activebackground="#4B4E5E",
            relief=tk.FLAT, padx=8, pady=2, font=("Segoe UI", 9)
        )
        btn_refresh.pack(side=tk.LEFT, padx=(0, 10))

        self.btn_connect = tk.Button(
            top_frame, text="Connect ESP32", command=self._toggle_connection,
            bg="#2E7D32", fg="#FFFFFF", activebackground="#388E3C",
            font=("Segoe UI", 9, "bold"), relief=tk.FLAT, padx=14, pady=2
        )
        self.btn_connect.pack(side=tk.LEFT, padx=(0, 15))

        self.status_indicator = tk.Label(
            top_frame, text="● Disconnected", font=("Segoe UI", 9, "bold"),
            fg="#F44336", bg="#262730"
        )
        self.status_indicator.pack(side=tk.LEFT, padx=(0, 20))

        lbl_vol = tk.Label(top_frame, text="Vol:", font=("Segoe UI", 9), fg="#B0B0B0", bg="#262730")
        lbl_vol.pack(side=tk.LEFT, padx=(10, 4))

        self.vol_scale = ttk.Scale(top_frame, from_=0, to=100, value=85, command=self._on_volume_change, length=90)
        self.vol_scale.pack(side=tk.LEFT, padx=(0, 15))

        btn_test = tk.Button(
            top_frame, text="▶ Tes Tangga Nada", command=self._run_scale_test,
            bg="#455A64", fg="#FFFFFF", activebackground="#546E7A",
            font=("Segoe UI", 9), relief=tk.FLAT, padx=10, pady=2
        )
        btn_test.pack(side=tk.RIGHT, padx=5)

        center_frame = tk.Frame(self.root, bg="#1E1E24", padx=16, pady=10)
        center_frame.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

        info_label = tk.Label(
            center_frame,
            text="Instrumen Gamolan Pekhing (8 Bilah) — Ketuk bilah dengan mouse untuk tes manual",
            font=("Segoe UI", 11, "bold"), fg="#D4AF37", bg="#1E1E24"
        )
        info_label.pack(side=tk.TOP, pady=(0, 8))

        self.canvas = tk.Canvas(center_frame, bg="#16171B", highlightthickness=1, highlightbackground="#3A3C4A")
        self.canvas.pack(fill=tk.BOTH, expand=True)
        self.canvas.bind("<Configure>", lambda e: self._draw_gamolan())
        self.canvas.bind("<Button-1>", self._on_canvas_click)

        bottom_frame = tk.Frame(self.root, bg="#1A1A20", padx=12, pady=6)
        bottom_frame.pack(side=tk.BOTTOM, fill=tk.X)

        lbl_log = tk.Label(bottom_frame, text="Log Serial ESP32:", font=("Segoe UI", 9, "bold"), fg="#8E9297", bg="#1A1A20")
        lbl_log.pack(side=tk.TOP, anchor="w")

        log_container = tk.Frame(bottom_frame, bg="#1A1A20")
        log_container.pack(fill=tk.X, expand=True)

        self.txt_log = tk.Text(
            log_container, height=5, bg="#0E0F12", fg="#00FF66",
            font=("Consolas", 9), relief=tk.FLAT, insertbackground="#00FF66"
        )
        self.txt_log.pack(side=tk.LEFT, fill=tk.X, expand=True)

        scrollbar = ttk.Scrollbar(log_container, orient="vertical", command=self.txt_log.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.txt_log.config(yscrollcommand=scrollbar.set)

        self.bar_hit_boxes = []

    def _refresh_ports(self):
        ports = serial.tools.list_ports.comports()
        port_list = []
        default_index = 0
        for i, p in enumerate(ports):
            desc = f"{p.device} ({p.description})"
            port_list.append(desc)
            if "CH340" in desc or "CP210" in desc or "USB" in desc or "ESP32" in desc:
                default_index = i

        self.port_combobox["values"] = port_list
        if port_list:
            self.port_combobox.current(default_index)
        else:
            self.port_combobox.set("Tidak ada Port COM")

    def _toggle_connection(self):
        if self.is_connected:
            self._disconnect()
        else:
            self._connect()

    def _connect(self):
        val = self.port_combobox.get()
        if not val or "Tidak ada" in val:
            messagebox.showwarning("Peringatan", "Pilih Port COM ESP32 terlebih dahulu.")
            return

        port_name = val.split()[0]
        try:
            self.ser = serial.Serial(port_name, 115200, timeout=0.1)
            self.is_connected = True
            self.btn_connect.config(text="Disconnect", bg="#C62828", activebackground="#D32F2F")
            self.status_indicator.config(text=f"● Connected ({port_name})", fg="#00E676")
            self._log_msg(f"[SYS] Terhubung ke {port_name} (115200 baud)")

            self.ser_thread = threading.Thread(target=self._serial_worker, daemon=True)
            self.ser_thread.start()
        except Exception as e:
            messagebox.showerror("Error Koneksi", f"Gagal membuka port {port_name}:\n{e}")

    def _disconnect(self):
        self.is_connected = False
        if self.ser and self.ser.is_open:
            try:
                self.ser.close()
            except Exception:
                pass
        self.ser = None
        self.btn_connect.config(text="Connect ESP32", bg="#2E7D32", activebackground="#388E3C")
        self.status_indicator.config(text="● Disconnected", fg="#F44336")
        self._log_msg("[SYS] Koneksi serial diputus.")

    def _serial_worker(self):
        buf = ""
        while self.is_connected and self.ser and self.ser.is_open:
            try:
                raw = self.ser.read(64)
                if raw:
                    buf += raw.decode("utf-8", errors="ignore")
                    while "\n" in buf:
                        line, buf = buf.split("\n", 1)
                        line = line.strip()
                        if line:
                            self.msg_queue.put(line)
                else:
                    time.sleep(0.01)
            except Exception as e:
                self.msg_queue.put(f"[ERR] Serial error: {e}")
                break
        self.msg_queue.put("__DISCONNECTED__")

    def _poll_queue(self):
        try:
            while not self.msg_queue.empty():
                msg = self.msg_queue.get_nowait()
                if msg == "__DISCONNECTED__":
                    self._disconnect()
                else:
                    self._handle_serial_message(msg)
        except Exception:
            pass
        self.root.after(20, self._poll_queue)

    def _handle_serial_message(self, line):
        self._log_msg(line)
        
        hit_match = re.search(r"\[HIT\]\s+(\d+)(?:\s+([a-zA-Z'\d_]+))?(?:\s+(\d+))?", line)
        if hit_match:
            nada = int(hit_match.group(1))
            durasi = int(hit_match.group(3)) if hit_match.group(3) else 220
            self.last_hit_time = time.time()
            self.play_note(nada, durasi)
            return

        off_match = re.search(r"\[OFF\]\s+(\d+)", line)
        if off_match:
            nada = int(off_match.group(1))
            self.release_note(nada)
            return

        nada_match = re.search(r"Nada:\s*([a-zA-Z'\d_]+)", line, re.IGNORECASE)
        if nada_match and (time.time() - self.last_hit_time > 0.08):
            nama = nada_match.group(1).lower()
            if nama in NAME_TO_NUM:
                self.play_note(NAME_TO_NUM[nama], 200)

    def _log_msg(self, msg):
        self.txt_log.insert(tk.END, msg + "\n")
        self.txt_log.see(tk.END)

    def play_note(self, note_num, duration_ms=220):
        if note_num not in self.sounds:
            return

        vol = self.vol_scale.get() / 100.0
        snd = self.sounds[note_num]
        snd.set_volume(vol)
        snd.play()

        self.active_bars[note_num] = True
        self._draw_gamolan()

        timer_id = self.root.after(duration_ms, lambda: self.release_note(note_num))
        self.active_bars[f"timer_{note_num}"] = timer_id

    def release_note(self, note_num):
        if note_num in self.active_bars:
            self.active_bars[note_num] = False
            self._draw_gamolan()

    def _on_volume_change(self, val):
        pass

    def _draw_gamolan(self):
        self.canvas.delete("all")
        self.bar_hit_boxes.clear()

        w = self.canvas.winfo_width()
        h = self.canvas.winfo_height()
        if w < 100 or h < 100:
            return

        frame_top = int(h * 0.12)
        frame_bottom = int(h * 0.88)
        self.canvas.create_rectangle(15, frame_top - 12, w - 15, frame_top + 4, fill="#5C3A21", outline="#8B5A2B", width=2)
        self.canvas.create_rectangle(15, frame_bottom - 4, w - 15, frame_bottom + 12, fill="#5C3A21", outline="#8B5A2B", width=2)

        n_bars = 8
        margin_x = 35
        avail_w = w - 2 * margin_x
        spacing = 14
        bar_w = (avail_w - (n_bars - 1) * spacing) / n_bars

        for i, item in enumerate(NOTES_DATA):
            num = item["num"]
            is_active = self.active_bars.get(num, False)

            x0 = margin_x + i * (bar_w + spacing)
            x1 = x0 + bar_w

            h_factor = 1.0 - (i * 0.038)
            actual_h = (frame_bottom - frame_top) * h_factor
            y_center = (frame_top + frame_bottom) / 2
            y0 = y_center - (actual_h / 2)
            y1 = y_center + (actual_h / 2)

            if is_active:
                bar_fill = "#FFE066"
                outline_col = "#FFFFFF"
                out_w = 4
                self.canvas.create_oval(
                    (x0 + x1) / 2 - 14, y0 - 24, (x0 + x1) / 2 + 14, y0 + 4,
                    fill="#FF4081", outline="#FFFFFF", width=2
                )
                self.canvas.create_line(
                    (x0 + x1) / 2, y0 - 24, (x0 + x1) / 2 - 20, y0 - 45,
                    fill="#CCCCCC", width=3
                )
            else:
                bar_fill = "#D4AF37" if i % 2 == 0 else "#C5A059"
                outline_col = "#8C6D23"
                out_w = 2

            bar_id = self.canvas.create_rectangle(
                x0, y0, x1, y1,
                fill=bar_fill, outline=outline_col, width=out_w
            )
            self.bar_hit_boxes.append((x0, y0, x1, y1, num))

            pin_radius = 4
            self.canvas.create_oval(x0 + bar_w * 0.2 - pin_radius, y0 + 16 - pin_radius,
                                    x0 + bar_w * 0.2 + pin_radius, y0 + 16 + pin_radius, fill="#333333", outline="")
            self.canvas.create_oval(x0 + bar_w * 0.8 - pin_radius, y0 + 16 - pin_radius,
                                    x0 + bar_w * 0.8 + pin_radius, y0 + 16 + pin_radius, fill="#333333", outline="")
            self.canvas.create_oval(x0 + bar_w * 0.2 - pin_radius, y1 - 16 - pin_radius,
                                    x0 + bar_w * 0.2 + pin_radius, y1 - 16 + pin_radius, fill="#333333", outline="")
            self.canvas.create_oval(x0 + bar_w * 0.8 - pin_radius, y1 - 16 - pin_radius,
                                    x0 + bar_w * 0.8 + pin_radius, y1 - 16 + pin_radius, fill="#333333", outline="")

            text_color = "#000000" if is_active else "#1A1A1A"
            self.canvas.create_text(
                (x0 + x1) / 2, y0 + actual_h * 0.35,
                text=str(num), font=("Segoe UI", 20, "bold"), fill=text_color
            )
            self.canvas.create_text(
                (x0 + x1) / 2, y0 + actual_h * 0.60,
                text=item["solfege"], font=("Segoe UI", 12, "bold"), fill=text_color
            )
            self.canvas.create_text(
                (x0 + x1) / 2, y0 + actual_h * 0.80,
                text=f"{int(item['freq'])} Hz", font=("Segoe UI", 8), fill="#4A4A4A"
            )

    def _on_canvas_click(self, event):
        x, y = event.x, event.y
        for x0, y0, x1, y1, num in self.bar_hit_boxes:
            if x0 <= x <= x1 and y0 <= y <= y1:
                self.play_note(num, 220)
                self._log_msg(f"[MANUAL] Pukul bilah {num} ({NOTES_DATA[num - 1]['solfege']})")
                break

    def _run_scale_test(self):
        def _runner():
            for num in range(1, 9):
                self.msg_queue.put(f"[HIT] {num} test 250")
                time.sleep(0.32)
        threading.Thread(target=_runner, daemon=True).start()

def main():
    root = tk.Tk()
    app = GamolanSimulatorApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()
