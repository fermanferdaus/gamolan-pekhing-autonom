# Rancangan Simulator Gamolan Pekhing (Portable .EXE)

## 1. Konsep Utama

ESP32 tetap menjalankan kode yang sama persis dengan alat aslinya:
- Tetap memicu pin relay GPIO (untuk hardware asli nanti)
- Mengirimkan log serial ringkas setiap kali relay dipicu:
  ```
  [HIT] <nomor_nada> <nama_nada> <durasi_ms>
  [OFF] <nomor_nada>
  ```
- Simulator membaca serial port USB (COM Port) ESP32 di laptop, menampilkan animasi 8 bilah gamolan secara visual, dan **membunyikan audio gamolan secara realtime**.
- Dikemas menjadi **1 file `.exe` portable** (tanpa perlu install Python atau runtime lain).

---

## 2. Arsitektur Komunikasi

```
┌─────────────────────────────────┐
│     Android App (Flutter)       │
│  - Playlist Lagu                │
│  - Mode Not Angka (Manual)      │
│  - Buat Lagu (Composer)         │
└────────────────┬────────────────┘
                 │ WiFi AP (WebSocket ws://192.168.4.1:81)
                 ▼
┌────────────────────────────────────────────────────────┐
│                      ESP32                             │
│  - Mode WiFi Access Point                              │
│  - Kontrol Relay GPIO (Pin 26, 25, 19, 18, 17, 16, 14, 13)
│  - Output USB Serial: [HIT] / [OFF]                    │
└────────────────┬───────────────────────────────────────┘
                 │ USB Serial COM Port (Baud 115200)
                 ▼
┌────────────────────────────────────────────────────────┐
│        GamolanSimulator.exe (Portable Windows)         │
│  - Auto-detect COM Port ESP32                          │
│  - Visual 8 Bilah Gamolan (Animasi Getar & Glow)       │
│  - Audio Sintesis Gamolan Pekhing (Multi-channel)      │
│  - Log Monitor Serial Realtime                         │
│  - Bisa diklik mouse untuk tes manual audio            │
└────────────────────────────────────────────────────────┘
```

---

## 3. Fitur Aplikasi Simulator (.EXE)

### A. Tampilan Antarmuka (GUI)
- **Header:**
  - Dropdown pilihan COM Port (otomatis mendeteksi port ESP32).
  - Tombol **Connect / Disconnect** + Indikator Status (Merah = Terputus, Hijau = Terhubung).
  - Pengatur Volume Slider (0 - 100%).
- **Area Gamolan (8 Bilah Horisontal):**
  - Desain 8 bilah bambu/kuningan:
    `1 (DO)` | `2 (RE)` | `3 (MI)` | `4 (FA)` | `5 (SOL)` | `6 (LA)` | `7 (SI)` | `8 (DO')`
  - Efek visual saat nada terpukul:
    - Bilah menyala terang (glow effect).
    - Efek pemukul (mallet strike) turun menyentuh bilah.
    - Durasi highlight mengikuti durasi nada dari ESP32.
  - Setiap bilah bisa diklik dengan mouse untuk mengetes suara secara manual.
- **Log Monitor (Bawah):**
  - Teks serial incoming realtime (`[HIT] 1 do 280`).
  - Info lagu yang sedang dimainkan.

### B. Mesin Audio (Gamolan Sound Engine)
- **Akustik Gamolan Pekhing:**
  - Karakteristik suara instrumen gamolan bambu berresonator (nada dasar diatonis + harmonik metalik/bambu + percussive click attack + peluruhan eksponensial/decay natural).
  - Menggunakan polyphonic mixer (nada sebelumnya tetap beresonansi alami meskipun nada baru dipukul).
  - Frekuensi nada standar Gamolan Pekhing (C5 hingga C6):
    - `1 DO`  : 523.25 Hz (C5)
    - `2 RE`  : 587.33 Hz (D5)
    - `3 MI`  : 659.25 Hz (E5)
    - `4 FA`  : 698.46 Hz (F5)
    - `5 SOL` : 783.99 Hz (G5)
    - `6 LA`  : 880.00 Hz (A5)
    - `7 SI`  : 987.77 Hz (B5)
    - `8 DO'` : 1046.50 Hz (C6)

---

## 4. Teknologi Pembuatan .EXE

| Komponen | Pilihan Teknologi | Alasan |
|---|---|---|
| **GUI & Visual** | Python (Tkinter + Custom Styling) | Ringan, responsif, native Windows |
| **Audio Engine** | Pygame Mixer / NumPy WAV Synthesizer | Multi-channel audio, latency rendah (<10ms) |
| **Serial Engine** | `pyserial` (Background Thread) | Non-blocking, stabil membaca COM port |
| **Packaging .EXE** | PyInstaller (`--onefile --windowed`) | Menghasilkan satu file `GamolanSimulator.exe` portable |

*Catatan: File `.exe` yang dihasilkan bersifat standalone, dapat dipindahkan ke flashdisk dan dijalankan di komputer Windows manapun tanpa instalasi software tambahan.*

---

## 5. Sinkronisasi Kode ESP32

Fungsi `mainkan()` pada ESP32 hanya butuh penambahan baris `Serial.printf` agar kompatibel dengan simulator tanpa mengubah fungsi relay:

```cpp
void mainkan(byte nada, int durasi) {
  if (nada == DIAM) {
    delay(durasi);
    return;
  }

  int nyala = durasi - jedaNada;
  if (lamaNyala > 0 && lamaNyala < nyala) {
    nyala = lamaNyala;
  }

  // Protokol untuk Simulator & Debugging
  Serial.printf("[HIT] %d %s %d\n", nada, namaNada[nada], nyala);

  // Relay fisik tetap aktif normal
  digitalWrite(relayPins[nada - 1], LOW);  // Relay ON
  delay(nyala);
  digitalWrite(relayPins[nada - 1], HIGH); // Relay OFF

  Serial.printf("[OFF] %d\n", nada);

  delay(durasi - nyala);
}
```

---

## 6. Rencana Eksekusi

1. **Step 1:** Buat script Python simulator (`simulator/gamolan_simulator.py`) lengkap dengan GUI 8 bilah, audio synthesizer gamolan, dan koneksi serial.
2. **Step 2:** Compile menjadi `simulator/GamolanSimulator.exe` menggunakan PyInstaller.
3. **Step 3:** Update firmware ESP32 di `main/main.ino` (WiFi AP + WebSocket + Serial log simulator + Relay).
4. **Step 4:** Siapkan aplikasi Android (Flutter).
