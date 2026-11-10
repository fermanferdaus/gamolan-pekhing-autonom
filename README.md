# Gamolan Pekhing - Robotic Instrument Controller

[![CI](https://github.com/fermanferdaus/gamolan-pekhing-autonom/actions/workflows/ci.yml/badge.svg)](https://github.com/fermanferdaus/gamolan-pekhing-autonom/actions/workflows/ci.yml)

Sistem aktuator mekanik dan kontroler nirkabel untuk instrumen bambu tradisional Lampung, Gamolan Pekhing (Cetik). Proyek ini menggabungkan firmware ESP32 berbasis FreeRTOS untuk menggerakkan 8 bilah solenoid dengan aplikasi mobile Flutter via WebSocket.

## Spesifikasi Teknis

| Parameter | Spesifikasi |
| --- | --- |
| Mikrokontroler | ESP32-WROOM-32 (Dual Core 240 MHz) |
| RTOS / Task Core | FreeRTOS, task pemutaran berjalan di Core 1 (Prioritas 5) |
| Aktuator | 8 unit solenoid push-pull 12V DC |
| Modul Driver | 8-Channel Relay Module (Active-LOW, isolasi optocoupler) |
| Durasi Pulsa Solenoid | 40 ms aktif, jeda minimum antar-ketuk 25 ms |
| Protokol Kontrol | WebSocket Server (`ws://192.168.4.1:81`), mode SoftAP tanpa internet |
| Format Penyimpanan | LittleFS (partisi Flash internal ESP32) |
| Aplikasi Kontroler | Flutter (Android & Web) |

## Skema Pinout & Wiring

Hubungkan pin GPIO ESP32 ke pin masukan modul relay (IN1 - IN8):

| Nada | Bilah | Frekuensi Relatif | GPIO ESP32 | Relay |
| --- | --- | --- | --- | --- |
| 1 | Do | Rendah | GPIO 26 | IN 1 |
| 2 | Re | | GPIO 25 | IN 2 |
| 3 | Mi | | GPIO 19 | IN 3 |
| 4 | Fa | | GPIO 18 | IN 4 |
| 5 | Sol | | GPIO 17 | IN 5 |
| 6 | La | | GPIO 16 | IN 6 |
| 7 | Si | | GPIO 14 | IN 7 |
| 8 | Do' | Tinggi | GPIO 13 | IN 8 |

### Kebutuhan Catu Daya & Proteksi
- **ESP32**: 5V DC via kabel USB atau modul step-down LM2596.
- **Solenoid**: 12V DC terpisah dengan kapasitas arus minimal 3A - 5A. Saat dua stik memukul bersamaan, penarikan arus sesaat mencapai ~2A.
- **Common Ground**: Terminal GND ESP32 wajib dihubungkan ke GND catu daya 12V dan modul relay.
- **Dioda Flyback**: Pasang dioda 1N4007 secara antiparalel di setiap koil solenoid jika modul driver belum memiliki proteksi snubber induktif.

## Arsitektur Perangkat Lunak

```
gamolan-pekhing/
├── main/                       # Firmware ESP32 (C++ Modular / Arduino)
│   ├── main.ino                # Setup SoftAP, LittleFS, task RTOS, dan POST test
│   ├── config.h / config.cpp   # Konfigurasi pinout, tempo, nada, dan ID pratinjau
│   ├── solenoid.h / .cpp       # Driver relay Active-LOW dengan serial logging
│   ├── storage.h / .cpp        # Serialisasi & persistensi lagu LittleFS (JSON)
│   ├── playback.h / .cpp       # Engine FreeRTOS playback dan live preview di RAM
│   ├── ws_handler.h / .cpp     # WebSocket server (port 81) dengan mutex rekursif
│   └── songs.h / songs.cpp     # 20 Repertoar partitur kanonik di PROGMEM
└── app/                        # Aplikasi Mobile (Flutter)
    ├── lib/
    │   ├── models/             # SongModel, DefaultSongs, NoteItem
    │   ├── screens/            # PlaylistScreen, NotAngkaScreen, ComposerScreen
    │   ├── services/           # GamolanService (Centralized WebSocket Client)
    │   └── theme/              # LampungTheme (Tapis Lampung & Navy/Gold)
    └── test/                   # Test suite unit & widget (13/13 lolos)
```

### 1. Firmware ESP32 (`/main`)
Firmware memisahkan beban kerja jaringan dan aktuasi mekanik:
- Jaringan Wi-Fi SoftAP dan polling WebSocket berjalan di Core 0 (`wsLoop`).
- Pemutaran nada berjalan secara independen di Core 1 melalui task `playbackTask` dengan prioritas tinggi (Priority 5) untuk menjamin akurasi tempo mikroskopik tanpa terganggu overhead jaringan.
- Mode `preview` memproses susunan nada kustom langsung di buffer RAM tanpa menulis ke LittleFS flash, mencegah keausan sel memori flash.

### 2. Struktur Data 2 Stik (`duo`)
Firmware mereproduksi teknik permainan dua tangan Gamolan Pekhing:
- Tangan Kanan (*Ka*): Melodi utama.
- Tangan Kiri (*Ki*): Pola aksen atau ketukan ostinato.

Setiap elemen nada direpresentasikan dalam struct 2-byte:
```cpp
struct Nada {
  byte nada;     // Nibble bawah (bit 0-3) = Stik Kanan, Nibble atas (bit 4-7) = Stik Kiri
  byte panjang;  // Durasi dalam kelipatan 1/16 ketuk
};
```
Fungsi `duo(kanan, kiri)` menggabungkan dua bilah nada sehingga solenoid kanan dan kiri dapat dipicu bersamaan pada ketukan yang sama.

### 3. Aplikasi Mobile (`/app`)
Aplikasi Flutter bertindak sebagai kontroler nirkabel:
- **Daftar Lagu**: Memuat metadata lagu dari flash ESP32 saat terhubung.
- **Mode Manual (Bilah)**: Papan ketuk 8 bilah not angka untuk interaksi langsung ke solenoid.
- **Komposer Musik**: Editor nada visual dengan tombol **Pratinjau Suara** langsung ke solenoid sebelum konfirmasi simpan ke flash.

## Daftar Repertoar Bawaan

| ID | Judul Lagu | Kategori | Tempo (BPM) | Keterangan |
| :---: | :--- | :--- | :---: | :--- |
| 0 | Indonesia Raya | Nasional | 96 | 4/4 |
| 1 | Tanah Airku | Nasional | 80 | 4/4 |
| 2 | Bagimu Negeri | Nasional | 80 | 4/4 |
| 3 | Garuda Pancasila | Nasional | 100 | 4/4 |
| 4 | Ibu Kita Kartini | Nasional | 88 | 4/4 |
| 5 | Anak Kambing Saya | Daerah | 112 | 2/4 |
| 6 | Cublak-Cublak Suweng | Daerah | 140 | 4/4 |
| 7 | Gundul-Gundul Pacul | Daerah | 112 | 4/4 |
| 8 | Apuse | Daerah | 96 | 4/4 |
| 9 | Suwe Ora Jamu | Daerah | 104 | 4/4 |
| 10 | Tabuh Sambai Agung | Lampung | 100 | Notasi 2 stik, ostinato Do pada stik kiri |
| 11 | Tabuh Sekeli | Lampung | 100 | Notasi 2 stik, ritem bilah 2 beralih ke bilah 1 |
| 12 | Tabuh Jakhang | Lampung | 66 | Notasi 2 stik, interlocking ketuk 1/16 |
| 13 | Tabuh Tari | Lampung | 76 | Melodi pembuka solo kanan, variasi 5-3 interlocking |
| 14 | Tabuh Alau-Alau Kembahang | Lampung | 132 | Notasi 2 stik, ketukan cepat sinkopasi |
| 15 | Twinkle Twinkle Little Star | Lainnya | 100 | 4/4 |
| 16 | Selamat Ulang Tahun | Lainnya | 100 | 3/4 |
| 17 | Pelangi-Pelangi | Lainnya | 80 | 2/4 |
| 18 | Balonku Ada Lima | Lainnya | 68 | 2/4 |
| 19 | Naik Delman | Lainnya | 92 | 2/4 |

*Catatan lagu Lampung:* Ditranskripsi dari riset etnomusikologi Muhammad Yoga Saputra dan Maestro Syapril Yamin (*Teknik Permainan dan Bentuk Notasi Pada Alat Musik Gamolan Pekhing*). Setiap birama 4/4 dihitung tepat 16 unit untuk menjaga aksen sinkopasi gantung.

## Protokol Komunikasi WebSocket

Komunikasi data menggunakan JSON murni via WebSocket (`ws://192.168.4.1:81`):

### Perintah dari Klien ke ESP32
```json
// Mengambil daftar lagu tersimpan
{"cmd": "list"}

// Memutar lagu berdasarkan ID
{"cmd": "play", "id": 10}

// Menghentikan pemutaran
{"cmd": "stop"}

// Memukul bilah langsung (mode manual, nada 1-8)
{"cmd": "hit", "n": 1}

// Pratinjau susunan nada langsung di solenoid tanpa simpan ke flash
{"cmd": "preview", "tempo": 120, "notes": [[1, 4], [2, 4], [3, 4]]}

// Menambah lagu baru ke LittleFS
{"cmd": "add", "name": "Lagu Baru", "tempo": 120, "cat": "lainnya", "notes": [[1, 4], [2, 4]]}

// Mengedit lagu
{"cmd": "edit", "id": 20, "name": "Judul Baru", "tempo": 110, "cat": "lainnya", "notes": [[1, 4]]}

// Menghapus lagu kustom
{"cmd": "del", "id": 20}

// Memulihkan lagu bawaan pabrik
{"cmd": "reset_defaults"}
```

### Pesan Broadcast dari ESP32
```json
// Status pemutaran
{"t": "state", "state": "playing", "id": 10}
{"t": "state", "state": "idle"}

// Event nada aktif saat pemutaran
{"t": "note", "n": 2, "l": 1, "idx": 0, "total": 272}

// Konfirmasi eksekusi perintah
{"t": "ack", "ok": true, "msg": "Lagu berhasil disimpan"}
```

## Panduan Instalasi & Build

### 1. Kompilasi & Flash Firmware (ESP32)

Prasyarat:
- Arduino IDE atau Arduino CLI
- Core board: `esp32` by Espressif Systems
- Library: `WebSockets` (Markus Sattler), `ArduinoJson` (v7)

Menggunakan Arduino CLI:
```bash
arduino-cli compile --fqbn esp32:esp32:esp32 main
arduino-cli upload -p COMx --fqbn esp32:esp32:esp32 main
```

### 2. Build Aplikasi Mobile (Flutter)

Prasyarat:
- Flutter SDK (Channel stable >= 3.13)
- Android SDK / Java 17

```bash
cd app

# Menjalankan unit & widget test
flutter test

# Build file APK (Debug)
flutter build apk --debug
# Output: app/build/app/outputs/flutter-apk/app-debug.apk

# Build file APK (Release)
flutter build apk --release
# Output: app/build/app/outputs/flutter-apk/app-release.apk

# Build Web
flutter build web --release
# Output: app/build/web/
```

## Pengujian & Standarisasi Kode (CI/CD)

Proyek ini dilengkapi dengan konfigurasi code formatter, automated testing, dan GitHub Actions CI workflow (`.github/workflows/ci.yml`) yang berjalan otomatis pada setiap `push` dan `pull_request` ke branch `main` dan `develop`.

### 1. Formatter & Linter

```bash
# Format kode Flutter / Dart
cd app
dart format --output=none --set-exit-if-changed .  # Mode verifikasi (CI)
dart format .                                     # Format in-place (Lokal)
flutter analyze --fatal-infos --fatal-warnings    # Analisis statis linter

# Format kode C++ / ESP32 Firmware
clang-format --dry-run --Werror main/*.h main/*.cpp main/*.ino  # Mode verifikasi (CI)
clang-format -i main/*.h main/*.cpp main/*.ino                  # Format in-place (Lokal)
```

Konfigurasi gaya format C++ tersimpan di file root `.clang-format` berbasis standar Google C++ Style Guide (2 spasi, batas kolom 100 karakter).

### 2. Automated Test Suite

```bash
# Menjalankan seluruh test suite unit & widget Flutter (13 skenario uji)
cd app
flutter test --coverage
```

Test suite mencakup verifikasi:
- Parsing model data lagu (`SongModel`) dan label notasi durasi (`NoteItem`).
- Integritas 20 repertoar kanonik bawaan (`DefaultSongs`) sinkron dengan firmware PROGMEM.
- Rendering UI navigasi dan kanvas penuh (*full-bleed edge-to-edge* dengan safe area notch) pada `NotAngkaScreen`.
- Mode komposer musik, penyuntingan nada, dan pratinjau suara live (`ComposerScreen`).
- Siklus hidup state `GamolanService` WebSocket (koneksi, pemutusan, dan sinkronisasi playlist).

## Pengoperasian Sistem

1. Berikan daya pada modul solenoid (12V DC) dan ESP32 (5V DC).
2. ESP32 otomatis menjalankan Power-On Self Test (POST) dengan memicu bilah 1 sampai 8 secara berurutan.
3. Hubungkan perangkat mobile ke Wi-Fi Access Point `GamolanPekhing` (IP: `192.168.4.1`, tanpa password).
4. Buka aplikasi Gamolan Pekhing. Koneksi WebSocket akan tersambung secara otomatis dan menampilkan playlist dari flash.
