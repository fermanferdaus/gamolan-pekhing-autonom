# Rancangan Sistem: Gamolan Pekhing + Android (WiFi AP)

## Arsitektur

```
┌─────────────────┐     WiFi AP mode      ┌──────────────┐
│   Android App   │ ◄──── WebSocket ────► │    ESP32      │
│   (Kotlin/JC)   │    192.168.4.1:81     │  WiFi AP      │
│                 │                        │  + 8 Relay    │
└─────────────────┘                        │  + Gamolan    │
                                           └──────────────┘
```

- ESP32 = WiFi Access Point (SSID: `GamolanPekhing`, no password / password)
- Android konek ke WiFi ESP32 → WebSocket `ws://192.168.4.1:81`
- Komunikasi realtime 2 arah

## Protokol WebSocket (JSON)

```
Android → ESP32:
─────────────────
// Mainkan lagu dari daftar
{"cmd":"play","id":0}

// Stop
{"cmd":"stop"}

// Minta daftar lagu
{"cmd":"list"}

// Pukul 1 nada manual (piano mode)
{"cmd":"hit","n":3}            // pukul mi sekali

// Tambah lagu baru
{"cmd":"add","name":"Tanah Airku","tempo":100,
 "notes":[[1,3],[1,1],[4,4],[6,3],[6,1],[6,4]]}

// Hapus lagu
{"cmd":"del","id":2}

// Set tempo (saat play)
{"cmd":"tempo","bpm":140}


ESP32 → Android:
─────────────────
// Daftar lagu
{"t":"list","songs":[
  {"id":0,"name":"Indonesia Raya","tempo":120,"len":53},
  {"id":1,"name":"Tanah Airku","tempo":100,"len":40}
]}

// Status playing (tiap nada berganti)
{"t":"note","n":5,"idx":12,"total":53}

// Status idle
{"t":"idle"}

// Ack
{"t":"ack","ok":true}
```

## Fitur Android App — 3 Mode

### Mode 1: Playlist (List Lagu)

```
┌──────────────────────────────┐
│  Gamolan Pekhing             │
│  ● Terhubung                 │
├──────────────────────────────┤
│                              │
│  ┌──────────────────────┐    │
│  │ ▶ Indonesia Raya     │ 🗑 │
│  │   120 BPM · 53 nada  │    │
│  └──────────────────────┘    │
│  ┌──────────────────────┐    │
│  │ ▶ Tanah Airku        │ 🗑 │
│  │   100 BPM · 40 nada  │    │
│  └──────────────────────┘    │
│                              │
│  Now Playing: Indonesia Raya │
│  ████████░░░░░░░  12/53      │
│  [■ Stop]                    │
│                              │
├──────────────────────────────┤
│  [Playlist]  [Not Angka]  [Buat]│
└──────────────────────────────┘
```

### Mode 2: Not Angka (Manual Play) — Auto Landscape

Layar otomatis rotate ke **Landscape** saat masuk mode ini (kembali ke Portrait saat keluar).
Layout 8 bilah sejajar horizontal mirip gamolan pekhing asli:

```
┌──────────────────────────────────────────────────────────────┐
│  Gamolan Pekhing — Main Manual                      [Kembali]│
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐          │
│  │     │     │     │     │     │     │     │     │          │
│  │     │     │     │     │     │     │     │     │          │
│  │ 1   │ 2   │ 3   │ 4   │ 5   │ 6   │ 7   │ 8   │          │
│  │ DO  │ RE  │ MI  │ FA  │ SOL │ LA  │ SI  │ DO' │          │
│  │     │     │     │     │     │     │     │     │          │
│  │     │     │     │     │     │     │     │     │          │
│  └─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘          │
│                                                              │
│  Terakhir dipukul: MI (3)                                    │
└──────────────────────────────────────────────────────────────┘
```
Implementasi Flutter: `SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])` saat buka, restore ke portrait saat `dispose()`.

### Mode 3: Buat Lagu (Composer)

Buat lagu baru dengan not angka visual.

```
┌──────────────────────────────┐
│  Buat Lagu Baru              │
├──────────────────────────────┤
│  Nama:  [________________]   │
│  Tempo: [120] BPM            │
│                              │
│  Panjang nada: ○1 ○2 ●4 ○8  │
│  (4 = 1 ketuk penuh)        │
│                              │
│  ┌────┬────┬────┬────┐       │
│  │ DO │ RE │ MI │ FA │       │
│  ├────┼────┼────┼────┤       │
│  │SOL │ LA │ SI │DO' │       │
│  └────┴────┴────┴────┘       │
│  [  ─  DIAM  ─  ]           │
│                              │
│  Notasi: (scroll horizontal) │
│  ┌──────────────────────────┐│
│  │do. do re fa.. la. la la..││
│  │ 3   1  1  4   3   1   4 ││
│  └──────────────────────────┘│
│  28 nada    [⌫] [▶ Preview]  │
│                              │
│  [Simpan ke Gamolan]         │
│                              │
├──────────────────────────────┤
│  [Playlist]  [Not Angka]  [Buat]│
└──────────────────────────────┘
```

Alur composer:

1. Pilih panjang nada (1/2/3/4/8)
2. Ketuk not angka → nada masuk ke barisan notasi
3. Ketuk DIAM → jeda masuk
4. ⌫ hapus nada terakhir
5. ▶ Preview → kirim ke ESP32, dimainkan langsung
6. Simpan → kirim permanent ke ESP32 SPIFFS

## ESP32 — Perubahan dari Referensi

```
referensi (sekarang)          │  rancangan baru
──────────────────────────────┼────────────────────────────
1 lagu hardcoded              │  Multi-lagu di SPIFFS
delay() blocking              │  millis() non-blocking
Serial debug only             │  WiFi AP + WebSocket server
Auto-loop                     │  Command-driven
Tidak ada input               │  3 mode: play/piano/compose
```

### Storage (SPIFFS)

```
/songs/
  manifest.json    → {"songs":["Indonesia Raya","Tanah Airku"]}
  0.bin            → [tempo_hi, tempo_lo, n1,d1, n2,d2, ...]
  1.bin            → [tempo_hi, tempo_lo, n1,d1, n2,d2, ...]
```

Binary format hemat — 1 lagu 50 nada = 102 byte. ESP32 flash 1.5MB → ribuan lagu.

## Library yang Dipakai

| Komponen | Library |
|----------|---------|
| ESP32 WiFi AP | `WiFi.h` (built-in) |
| ESP32 WebSocket | `WebSocketsServer` (arduinoWebSockets) |
| ESP32 JSON | `ArduinoJson` |
| ESP32 Storage | `SPIFFS.h` / `LittleFS.h` (built-in) |
| Android UI | Flutter |
| Android WebSocket | `web_socket_channel` (official Dart team) |

## Tahapan Build

```
Phase 1: ESP32 Core
  ├── WiFi AP + WebSocket server
  ├── millis() non-blocking player
  ├── SPIFFS save/load lagu
  ├── Command handler (play/stop/list/hit/add/del)
  └── Indonesia Raya sebagai lagu default

Phase 2: Android — Koneksi + Playlist
  ├── WiFi connect detection
  ├── WebSocket client
  ├── List lagu + Play/Stop
  └── Progress nada realtime

Phase 3: Android — Not Angka + Composer
  ├── Not angka mode (hit realtime + auto-landscape 8 bilah)
  ├── Composer: not angka + panjang nada → notasi
  ├── Preview (mainkan draft)
  └── Simpan ke ESP32

Phase 4: Polish
  ├── Hapus lagu
  ├── Edit lagu existing
  ├── Animasi not angka (highlight nada saat playing)
  └── Visual notasi warna-warni
```
