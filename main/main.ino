#include <WiFi.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
#include <LittleFS.h>

const int relayPins[8] = {
  26, 25, 19, 18, 17, 16, 14, 13
};
const int jumlahRelay = 8;

const byte DIAM = 0;
const byte DO   = 1;
const byte RE   = 2;
const byte MI   = 3;
const byte FA   = 4;
const byte SOL  = 5;
const byte LA   = 6;
const byte SI   = 7;
const byte DO_T = 8;

const char* namaNada[] = { "-", "do", "re", "mi", "fa", "sol", "la", "si", "do'" };

const char* AP_SSID = "GamolanPekhing";
const char* AP_PASS = "";
const int WS_PORT = 81;

WebSocketsServer webSocket = WebSocketsServer(WS_PORT);

struct Nada {
  byte nada;
  byte panjang;
};

struct SongHeader {
  int id;
  String name;
  String category;
  int tempo;
  int noteCount;
};

// ============================================
// 20 LAGU BAWAAN (PROGMEM)
// ============================================

// --- 1. LAGU NASIONAL ---
const Nada song_0[] PROGMEM = {
  { DO, 3 }, { DO, 1 }, { FA, 4 }, { LA, 3 }, { LA, 1 }, { LA, 4 },
  { LA, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 3 }, { MI, 1 }, { MI, 4 },
  { SOL, 3 }, { SOL, 1 }, { FA, 4 }, { RE, 3 }, { RE, 1 }, { RE, 4 },
  { SOL, 3 }, { FA, 1 }, { MI, 8 }, { DO, 2 }, { DIAM, 2 },
  { DO, 3 }, { DO, 1 }, { FA, 4 }, { LA, 3 }, { LA, 1 }, { LA, 4 },
  { LA, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 3 }, { MI, 1 }, { MI, 4 },
  { SOL, 3 }, { SOL, 1 }, { SOL, 4 }, { FA, 3 }, { MI, 1 }, { RE, 4 },
  { MI, 3 }, { RE, 1 }, { DO, 10 }, { DIAM, 2 }
};

const Nada song_1[] PROGMEM = {
  // "Ta-nah a-ir-ku ti-dak ku-lu-pa-kan"
  { DO, 6 }, { MI, 2 }, { RE, 6 }, { DO, 2 }, { RE, 4 }, { MI, 4 }, { DO, 8 },
  // "Kan ter-ke-nang se-la-ma hi-dup-ku"
  { DO, 6 }, { MI, 2 }, { RE, 6 }, { DO, 2 }, { FA, 12 }, { FA, 4 },
  // "Biar-pun sa-ya per-gi ja-uh"
  { MI, 6 }, { SOL, 2 }, { SOL, 6 }, { MI, 2 }, { RE, 4 }, { MI, 4 }, { DO, 6 }, { RE, 2 },
  // "Ti-dak-kan hi-lang da-ri kal-bu"
  { DO, 6 }, { RE, 2 }, { DO, 6 }, { RE, 2 }, { DO, 12 }, { DIAM, 4 },
  // "Wa-lau-pun ba-nyak ne-ge-ri ku-ja-la-ni"
  { MI, 6 }, { FA, 2 }, { SOL, 6 }, { MI, 2 }, { RE, 4 }, { MI, 4 }, { FA, 12 }, { FA, 4 },
  // "Yang mas-yhur per-mai di-ka-ta o-rang"
  { FA, 6 }, { SOL, 2 }, { LA, 6 }, { SOL, 2 }, { FA, 4 }, { MI, 4 }, { RE, 8 }, { DIAM, 4 },
  // "Te-ta-pi kam-pung dan ru-mah-ku"
  { SOL, 6 }, { SOL, 2 }, { DO_T, 6 }, { SI, 2 }, { LA, 4 }, { SI, 4 }, { DO_T, 6 }, { LA, 2 },
  // "Di sa-na-lah ku ra-sa se-nang"
  { SOL, 6 }, { FA, 2 }, { MI, 6 }, { SOL, 2 }, { RE, 12 }, { DIAM, 4 },
  // "Ta-nah-ku tak ku-lu-pa-kan"
  { DO, 6 }, { MI, 2 }, { RE, 6 }, { DO, 2 }, { FA, 12 }, { FA, 4 },
  // "Eng-kau ku-bang-ga-kan"
  { MI, 6 }, { SOL, 2 }, { RE, 6 }, { MI, 2 }, { DO, 12 }, { DIAM, 4 }
};

const Nada song_2[] PROGMEM = {
  // "Pa-da-mu ne-ge-ri"
  { DO, 4 }, { MI, 4 }, { RE, 2 }, { DO, 2 }, { RE, 8 },
  // "ka-mi ber-jan-ji"
  { MI, 4 }, { FA, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 8 },
  // "Pa-da-mu ne-ge-ri"
  { DO, 4 }, { MI, 4 }, { RE, 2 }, { DO, 2 }, { RE, 8 },
  // "ka-mi ber-bak-ti"
  { MI, 4 }, { FA, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 8 },
  // "Pa-da-mu ne-ge-ri"
  { SOL, 4 }, { DO_T, 4 }, { SI, 2 }, { LA, 2 }, { SOL, 8 },
  // "ka-mi meng-ab-di"
  { FA, 4 }, { MI, 4 }, { RE, 2 }, { MI, 2 }, { FA, 8 },
  // "Ba-gi-mu ne-ge-ri"
  { SOL, 4 }, { LA, 2 }, { SOL, 2 }, { FA, 4 }, { MI, 4 }, { RE, 8 },
  // "ji-wa ra-ga ka-mi"
  { MI, 4 }, { FA, 4 }, { RE, 6 }, { RE, 2 }, { DO, 12 }, { DIAM, 4 }
};

const Nada song_3[] PROGMEM = {
  // "Ga-ru-da pan-ca-si-la"
  { DO, 2 }, { DO, 2 }, { DO, 4 }, { DO, 4 }, { RE, 4 }, { RE, 4 }, { MI, 3 }, { RE, 1 }, { MI, 2 }, { FA, 2 }, { SOL, 6 },
  // "a-ku-lah pen-du-kung-mu"
  { LA, 6 }, { LA, 2 }, { SOL, 4 }, { FA, 2 }, { MI, 2 }, { RE, 8 },
  // "pa-tri-ot pro-kla-ma-si"
  { RE, 2 }, { RE, 2 }, { RE, 4 }, { RE, 4 }, { MI, 4 }, { MI, 4 }, { FA, 3 }, { MI, 1 }, { FA, 2 }, { SOL, 6 },
  // "se-di-a ber-kor-ban un-tuk-mu"
  { LA, 6 }, { LA, 2 }, { SI, 4 }, { LA, 2 }, { SI, 2 }, { DO_T, 8 },
  // "Pan-ca-si-la da-sar ne-ga-ra"
  { DO_T, 2 }, { DO_T, 2 }, { DO_T, 2 }, { DO_T, 2 }, { LA, 8 },
  // "rak-yat a-dil mak-mur sen-to-sa"
  { SI, 2 }, { SI, 2 }, { SI, 2 }, { SI, 2 }, { SOL, 8 },
  // "pri-ba-di bang-sa-ku"
  { LA, 2 }, { LA, 2 }, { LA, 2 }, { LA, 2 }, { FA, 8 },
  { SOL, 2 }, { SOL, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 8 },
  { RE, 2 }, { MI, 2 }, { FA, 2 }, { SOL, 2 }, { LA, 8 },
  // "A-yo ma-ju ma-ju, a-yo ma-ju ma-ju, a-yo ma-ju ma-ju!"
  { SOL, 4 }, { DO_T, 4 }, { SI, 2 }, { LA, 2 }, { SOL, 4 },
  { FA, 4 }, { LA, 4 }, { SOL, 2 }, { FA, 2 }, { MI, 4 },
  { RE, 4 }, { FA, 4 }, { MI, 2 }, { RE, 2 }, { DO, 8 }, { DIAM, 4 }
};

const Nada song_4[] PROGMEM = {
  // "I-bu ki-ta Kar-ti-ni"
  { DO, 2 }, { RE, 2 }, { MI, 6 }, { SOL, 2 }, { MI, 4 }, { DO, 4 },
  // "pu-tri se-ja-ti"
  { RE, 4 }, { FA, 4 }, { MI, 2 }, { RE, 2 }, { DO, 8 },
  // "pu-tri In-do-ne-sia"
  { DO, 2 }, { RE, 2 }, { MI, 6 }, { SOL, 2 }, { MI, 4 }, { DO, 4 },
  // "ha-rum na-ma-nya"
  { RE, 4 }, { FA, 4 }, { MI, 2 }, { RE, 2 }, { DO, 8 },
  // "Wa-hai I-bu Kar-ti-ni"
  { FA, 6 }, { LA, 2 }, { SOL, 4 }, { FA, 2 }, { MI, 2 }, { DO, 8 },
  // "pu-tri yang mu-li-a"
  { RE, 4 }, { FA, 4 }, { MI, 2 }, { RE, 2 }, { FA, 4 }, { MI, 8 },
  // "Sung-guh be-sar ci-ta-ci-ta-nya"
  { FA, 6 }, { LA, 2 }, { SOL, 4 }, { FA, 2 }, { MI, 2 }, { DO, 8 },
  // "ba-gi In-do-ne-sia"
  { RE, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 }, { DO, 12 }, { DIAM, 4 }
};

// --- 2. LAGU DAERAH ---
const Nada song_5[] PROGMEM = {
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 8 },
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 8 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

const Nada song_6[] PROGMEM = {
  { DO, 4 }, { DO, 2 }, { DO, 2 }, { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 },
  { RE, 4 }, { RE, 2 }, { RE, 2 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  { DO, 4 }, { DO, 2 }, { DO, 2 }, { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 },
  { SOL, 4 }, { MI, 4 }, { FA, 4 }, { RE, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { DIAM, 4 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { FA, 4 }, { RE, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { FA, 4 }, { RE, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

const Nada song_7[] PROGMEM = {
  { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 8 },
  { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 8 },
  { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 8 }
};

const Nada song_8[] PROGMEM = {
  { DO, 4 }, { MI, 4 }, { MI, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 },
  { RE, 4 }, { FA, 4 }, { FA, 4 }, { FA, 4 }, { LA, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  { MI, 4 }, { SOL, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { DIAM, 4 },
  { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { RE, 8 }, { RE, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

const Nada song_9[] PROGMEM = {
  { DO, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { MI, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 },
  { SOL, 8 }, { SOL, 4 }, { DIAM, 4 },
  { SOL, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 },
  { RE, 8 }, { RE, 4 }, { DIAM, 4 },
  { RE, 4 }, { RE, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 4 },
  { RE, 8 }, { RE, 4 }, { DIAM, 4 },
  { SOL, 4 }, { MI, 4 }, { RE, 4 }, { MI, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { RE, 4 },
  { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

// --- 3. TRADISIONAL LAMPUNG (Gamolan Pekhing Asli) ---
const Nada song_10[] PROGMEM = {
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 8 },
  { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 },
  { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 8 },
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 },
  { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 8 },
  { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 }
};

const Nada song_11[] PROGMEM = {
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 8 },
  { MI, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 8 }, { LA, 4 }, { SOL, 4 },
  { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 },
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { DO, 8 },
  { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 8 },
  { MI, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 4 }, { DO, 8 }
};

const Nada song_12[] PROGMEM = {
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 8 }, { MI, 4 }, { DIAM, 4 },
  { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 8 }, { MI, 4 }, { DIAM, 4 },
  { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 8 },
  { MI, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 4 }, { DO, 8 },
  { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 8 },
  { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

const Nada song_13[] PROGMEM = {
  { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { SOL, 8 },
  { LA, 2 }, { DO_T, 2 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 8 },
  { SOL, 2 }, { MI, 2 }, { DO, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 8 },
  { MI, 2 }, { SOL, 2 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 4 }, { DO, 8 },
  { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 },
  { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 },
  { SOL, 2 }, { LA, 2 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 8 }
};

const Nada song_14[] PROGMEM = {
  { MI, 4 }, { SOL, 4 }, { LA, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 8 },
  { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 8 }, { MI, 4 }, { DIAM, 4 },
  { LA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 8 },
  { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 },
  { DO, 4 }, { MI, 4 }, { SOL, 4 }, { LA, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 8 },
  { MI, 4 }, { SOL, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 4 }, { DO, 8 }
};

// --- 4. LAINNYA ---
const Nada song_15[] PROGMEM = {
  { DO, 4 }, { DO, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 8 },
  { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 4 }, { RE, 4 }, { DO, 8 },
  { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 8 },
  { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 8 },
  { DO, 4 }, { DO, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 8 },
  { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 4 }, { RE, 4 }, { DO, 8 }
};

const Nada song_16[] PROGMEM = {
  { DO, 2 }, { DO, 2 }, { RE, 4 }, { DO, 4 }, { FA, 4 }, { MI, 8 },
  { DO, 2 }, { DO, 2 }, { RE, 4 }, { DO, 4 }, { SOL, 4 }, { FA, 8 },
  { DO, 2 }, { DO, 2 }, { DO_T, 4 }, { LA, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 }, { DIAM, 4 },
  { LA, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 }, { FA, 4 }, { MI, 8 }
};

const Nada song_17[] PROGMEM = {
  { MI, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  { DO, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { MI, 6 }, { RE, 2 }, { RE, 8 },
  { MI, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  { DO, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { RE, 6 }, { DO, 2 }, { DO, 8 },
  { RE, 4 }, { RE, 4 }, { MI, 4 }, { DO, 4 }, { RE, 4 }, { MI, 2 }, { FA, 2 }, { MI, 4 }, { DO, 4 },
  { RE, 4 }, { MI, 2 }, { FA, 2 }, { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 4 }, { SOL, 4 }, { DIAM, 4 },
  { MI, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  { DO, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { RE, 6 }, { DO, 2 }, { DO, 8 }
};

const Nada song_18[] PROGMEM = {
  { DO, 4 }, { RE, 4 }, { MI, 4 }, { DO, 4 }, { MI, 4 }, { DO, 4 }, { MI, 8 },
  { RE, 4 }, { MI, 4 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 }, { FA, 8 },
  { MI, 4 }, { FA, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 4 }, { MI, 4 }, { SOL, 8 },
  { FA, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 4 }, { FA, 4 }, { LA, 8 },
  { SOL, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { LA, 8 },
  { LA, 4 }, { RE, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { LA, 4 }, { SI, 8 },
  { SI, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 }, { LA, 4 }, { SI, 4 }, { DO_T, 8 },
  { DO_T, 4 }, { SI, 4 }, { LA, 4 }, { SOL, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 }, { DO, 4 }
};

const Nada song_19[] PROGMEM = {
  { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { MI, 4 }, { MI, 8 },
  { RE, 4 }, { RE, 4 }, { RE, 8 }, { MI, 4 }, { SOL, 4 }, { SOL, 8 },
  { MI, 4 }, { RE, 4 }, { DO, 4 }, { RE, 4 }, { MI, 4 }, { MI, 4 }, { MI, 4 }, { MI, 4 },
  { RE, 4 }, { RE, 4 }, { MI, 4 }, { RE, 4 }, { DO, 8 }, { DO, 4 }, { DIAM, 4 }
};

const Nada* const defaultSongNotes[] = {
  song_0, song_1, song_2, song_3, song_4,
  song_5, song_6, song_7, song_8, song_9,
  song_10, song_11, song_12, song_13, song_14,
  song_15, song_16, song_17, song_18, song_19
};

const int defaultSongLengths[] = {
  sizeof(song_0) / sizeof(song_0[0]),
  sizeof(song_1) / sizeof(song_1[0]),
  sizeof(song_2) / sizeof(song_2[0]),
  sizeof(song_3) / sizeof(song_3[0]),
  sizeof(song_4) / sizeof(song_4[0]),
  sizeof(song_5) / sizeof(song_5[0]),
  sizeof(song_6) / sizeof(song_6[0]),
  sizeof(song_7) / sizeof(song_7[0]),
  sizeof(song_8) / sizeof(song_8[0]),
  sizeof(song_9) / sizeof(song_9[0]),
  sizeof(song_10) / sizeof(song_10[0]),
  sizeof(song_11) / sizeof(song_11[0]),
  sizeof(song_12) / sizeof(song_12[0]),
  sizeof(song_13) / sizeof(song_13[0]),
  sizeof(song_14) / sizeof(song_14[0]),
  sizeof(song_15) / sizeof(song_15[0]),
  sizeof(song_16) / sizeof(song_16[0]),
  sizeof(song_17) / sizeof(song_17[0]),
  sizeof(song_18) / sizeof(song_18[0]),
  sizeof(song_19) / sizeof(song_19[0]),
};

const char* const defaultSongNames[] = {
  "Indonesia Raya", "Tanah Airku", "Bagimu Negeri", "Garuda Pancasila", "Ibu Kita Kartini",
  "Bubuy Bulan", "Ampar-Ampar Pisang", "Gundul-Gundul Pacul", "Apuse", "Suwe Ora Jamu",
  "Tabuh Segata", "Sang Bumi Ruwa Jurai", "Tanoh Lado", "Gitar Tunggal Lampung", "Mulang Unyin",
  "Twinkle Twinkle Little Star", "Selamat Ulang Tahun", "Ode to Joy", "Do Re Mi", "Mary Had a Little Lamb"
};

const char* const defaultSongCats[] = {
  "nasional", "nasional", "nasional", "nasional", "nasional",
  "daerah", "daerah", "daerah", "daerah", "daerah",
  "lampung", "lampung", "lampung", "lampung", "lampung",
  "lainnya", "lainnya", "lainnya", "lainnya", "lainnya"
};

const int defaultSongTempos[] = {
  104, 96, 88, 120, 108,
  108, 112, 116, 100, 112,
  100, 108, 96, 92, 96,
  120, 120, 120, 120, 120
};

const int NUM_DEFAULT_SONGS = 20;

// ============================================
// SYSTEM DATA
// ============================================

const int MAX_SONGS = 50;
const int MAX_NOTES = 256;
SongHeader songList[MAX_SONGS];
int totalSongs = 0;

int activeSongId = -1;
int activeSongTempo = 120;
int activeSongNoteCount = 0;
Nada currentNotes[MAX_NOTES];

enum PlayerState {
  STATE_IDLE,
  STATE_NOTE_PLAYING,
  STATE_NOTE_GAP
};

PlayerState playerState = STATE_IDLE;
int currentNoteIndex = 0;
unsigned long nextActionTime = 0;
byte currentPlayingNada = DIAM;

int manualHitPin = -1;
unsigned long manualReleaseTime = 0;

const int PULSE_MS = 45;        // ms relay nyala (pukul solenoid) — gamolan perkusif
const int JEDA_MIN_MS = 30;     // ms jeda minimum antar nada

void semuaMati() {
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);
  }
}

void broadcastStatus(const String& jsonStr) {
  webSocket.broadcastTXT(jsonStr.c_str());
}

void sendAck(uint8_t num, bool ok, const String& msg) {
  JsonDocument doc;
  doc["t"] = "ack";
  doc["ok"] = ok;
  doc["msg"] = msg;
  String out;
  serializeJson(doc, out);
  webSocket.sendTXT(num, out.c_str());
}

void sendSongList(uint8_t clientNum = 255) {
  JsonDocument doc;
  doc["t"] = "list";
  JsonArray arr = doc["songs"].to<JsonArray>();

  for (int i = 0; i < totalSongs; i++) {
    JsonObject obj = arr.add<JsonObject>();
    obj["id"] = songList[i].id;
    obj["name"] = songList[i].name;
    obj["cat"] = songList[i].category;
    obj["tempo"] = songList[i].tempo;
    obj["len"] = songList[i].noteCount;
  }

  String out;
  serializeJson(doc, out);
  if (clientNum == 255) {
    webSocket.broadcastTXT(out.c_str());
  } else {
    webSocket.sendTXT(clientNum, out.c_str());
  }
}

void loadSongMetadata() {
  totalSongs = 0;
  for (int i = 0; i < NUM_DEFAULT_SONGS; i++) {
    songList[i].id = i;
    songList[i].name = defaultSongNames[i];
    songList[i].category = defaultSongCats[i];
    songList[i].tempo = defaultSongTempos[i];
    songList[i].noteCount = defaultSongLengths[i];
    totalSongs++;
  }

  if (!LittleFS.exists("/songs.json")) {
    return;
  }

  File f = LittleFS.open("/songs.json", "r");
  if (!f) return;

  JsonDocument doc;
  DeserializationError err = deserializeJson(doc, f);
  f.close();

  if (err) return;

  JsonArray arr = doc.as<JsonArray>();
  for (JsonObject obj : arr) {
    if (totalSongs >= MAX_SONGS) break;
    songList[totalSongs].id = obj["id"] | totalSongs;
    songList[totalSongs].name = obj["name"] | "Lagu";
    songList[totalSongs].category = (const char*)(obj["cat"] | "lainnya");
    songList[totalSongs].tempo = obj["tempo"] | 120;
    songList[totalSongs].noteCount = obj["len"] | 0;
    totalSongs++;
  }
}

void saveSongMetadata() {
  File f = LittleFS.open("/songs.json", "w");
  if (!f) return;

  JsonDocument doc;
  JsonArray arr = doc.to<JsonArray>();

  for (int i = NUM_DEFAULT_SONGS; i < totalSongs; i++) {
    JsonObject obj = arr.add<JsonObject>();
    obj["id"] = songList[i].id;
    obj["name"] = songList[i].name;
    obj["cat"] = songList[i].category;
    obj["tempo"] = songList[i].tempo;
    obj["len"] = songList[i].noteCount;
  }

  serializeJson(doc, f);
  f.close();
}

bool loadSongNotes(int songId) {
  if (songId >= 0 && songId < NUM_DEFAULT_SONGS) {
    activeSongId = songId;
    activeSongTempo = defaultSongTempos[songId];
    activeSongNoteCount = defaultSongLengths[songId];
    const Nada* src = defaultSongNotes[songId];
    for (int i = 0; i < activeSongNoteCount; i++) {
      currentNotes[i].nada = pgm_read_byte(&(src[i].nada));
      currentNotes[i].panjang = pgm_read_byte(&(src[i].panjang));
    }
    return true;
  }

  String path = "/song_" + String(songId) + ".bin";
  if (!LittleFS.exists(path)) return false;

  File f = LittleFS.open(path, "r");
  if (!f) return false;

  int count = f.read();
  if (count <= 0 || count > MAX_NOTES) {
    f.close();
    return false;
  }

  for (int i = 0; i < count; i++) {
    currentNotes[i].nada = f.read();
    currentNotes[i].panjang = f.read();
  }
  f.close();

  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id == songId) {
      activeSongId = songId;
      activeSongTempo = songList[i].tempo;
      activeSongNoteCount = count;
      return true;
    }
  }

  return false;
}

void hitNadaManual(byte nada) {
  if (nada < DO || nada > DO_T) return;

  semuaMati();
  int pin = relayPins[nada - 1];

  Serial.printf("[HIT] %d %s %d\n", nada, namaNada[nada], PULSE_MS);
  digitalWrite(pin, LOW);

  manualHitPin = pin;
  manualReleaseTime = millis() + PULSE_MS;
}

void startPlayback(int songId) {
  if (!loadSongNotes(songId)) return;

  semuaMati();
  currentNoteIndex = 0;
  playerState = STATE_NOTE_PLAYING;
  nextActionTime = millis();

  JsonDocument doc;
  doc["t"] = "state";
  doc["state"] = "playing";
  doc["id"] = songId;
  String out;
  serializeJson(doc, out);
  broadcastStatus(out);
}

void stopPlayback() {
  semuaMati();
  if (currentPlayingNada != DIAM) {
    Serial.printf("[OFF] %d\n", currentPlayingNada);
    currentPlayingNada = DIAM;
  }
  playerState = STATE_IDLE;

  JsonDocument doc;
  doc["t"] = "state";
  doc["state"] = "idle";
  String out;
  serializeJson(doc, out);
  broadcastStatus(out);
}

void processPlayer() {
  if (playerState == STATE_IDLE) return;

  unsigned long now = millis();
  if (now < nextActionTime) return;

  if (playerState == STATE_NOTE_PLAYING) {
    if (currentNoteIndex >= activeSongNoteCount) {
      stopPlayback();
      return;
    }

    Nada item = currentNotes[currentNoteIndex];
    int seperempatKetuk = 60000 / activeSongTempo / 4;
    int totalDurasi = item.panjang * seperempatKetuk;

    if (item.nada >= DO && item.nada <= DO_T) {
      int nyala = PULSE_MS;
      if (nyala > totalDurasi - JEDA_MIN_MS) {
        nyala = totalDurasi - JEDA_MIN_MS;
        if (nyala < 15) nyala = 15;
      }

      currentPlayingNada = item.nada;
      Serial.printf("[HIT] %d %s %d\n", item.nada, namaNada[item.nada], nyala);
      digitalWrite(relayPins[item.nada - 1], LOW);

      nextActionTime = now + nyala;
    } else {
      currentPlayingNada = DIAM;
      nextActionTime = now + totalDurasi;
      currentNoteIndex++;
      return;
    }

    JsonDocument doc;
    doc["t"] = "note";
    doc["n"] = item.nada;
    doc["idx"] = currentNoteIndex;
    doc["total"] = activeSongNoteCount;
    String out;
    serializeJson(doc, out);
    broadcastStatus(out);

    playerState = STATE_NOTE_GAP;

  } else if (playerState == STATE_NOTE_GAP) {
    if (currentPlayingNada != DIAM) {
      digitalWrite(relayPins[currentPlayingNada - 1], HIGH);
      Serial.printf("[OFF] %d\n", currentPlayingNada);
      currentPlayingNada = DIAM;
    }

    Nada item = currentNotes[currentNoteIndex];
    int seperempatKetuk = 60000 / activeSongTempo / 4;
    int totalDurasi = item.panjang * seperempatKetuk;

    int nyala = PULSE_MS;
    if (nyala > totalDurasi - JEDA_MIN_MS) {
      nyala = totalDurasi - JEDA_MIN_MS;
      if (nyala < 15) nyala = 15;
    }
    int sisa = totalDurasi - nyala;
    if (sisa < JEDA_MIN_MS) sisa = JEDA_MIN_MS;

    nextActionTime = now + sisa;
    currentNoteIndex++;
    playerState = STATE_NOTE_PLAYING;
  }
}

void handleWebSocketMessage(uint8_t num, uint8_t * payload, size_t length) {
  JsonDocument doc;
  DeserializationError err = deserializeJson(doc, payload, length);
  if (err) return;

  const char* cmd = doc["cmd"];
  if (!cmd) return;

  if (strcmp(cmd, "list") == 0) {
    sendSongList(num);

  } else if (strcmp(cmd, "play") == 0) {
    int id = doc["id"] | 0;
    startPlayback(id);
    sendAck(num, true, "Playback started");

  } else if (strcmp(cmd, "stop") == 0) {
    stopPlayback();
    sendAck(num, true, "Playback stopped");

  } else if (strcmp(cmd, "hit") == 0) {
    byte n = doc["n"] | 0;
    hitNadaManual(n);

  } else if (strcmp(cmd, "add") == 0) {
    const char* name = doc["name"] | "Lagu Baru";
    const char* cat = doc["cat"] | "lainnya";
    int tempo = doc["tempo"] | 120;
    JsonArray notesArr = doc["notes"].as<JsonArray>();

    if (notesArr.size() == 0 || notesArr.size() > MAX_NOTES) {
      sendAck(num, false, "Invalid note count");
      return;
    }

    int newId = NUM_DEFAULT_SONGS;
    for (int i = 0; i < totalSongs; i++) {
      if (songList[i].id >= newId) newId = songList[i].id + 1;
    }

    String path = "/song_" + String(newId) + ".bin";
    File f = LittleFS.open(path, "w");
    if (!f) {
      sendAck(num, false, "Flash write error");
      return;
    }

    f.write((uint8_t)notesArr.size());
    for (JsonVariant v : notesArr) {
      byte n = v[0] | 0;
      byte d = v[1] | 4;
      f.write(n);
      f.write(d);
    }
    f.close();

    if (totalSongs < MAX_SONGS) {
      songList[totalSongs].id = newId;
      songList[totalSongs].name = String(name);
      songList[totalSongs].category = String(cat);
      songList[totalSongs].tempo = tempo;
      songList[totalSongs].noteCount = notesArr.size();
      totalSongs++;
      saveSongMetadata();
    }

    sendAck(num, true, "Lagu berhasil disimpan");
    sendSongList();

  } else if (strcmp(cmd, "del") == 0) {
    int id = doc["id"] | -1;
    if (id < NUM_DEFAULT_SONGS) {
      sendAck(num, false, "Tidak bisa menghapus lagu bawaan");
      return;
    }

    String path = "/song_" + String(id) + ".bin";
    if (LittleFS.exists(path)) LittleFS.remove(path);

    int foundIdx = -1;
    for (int i = NUM_DEFAULT_SONGS; i < totalSongs; i++) {
      if (songList[i].id == id) {
        foundIdx = i;
        break;
      }
    }

    if (foundIdx != -1) {
      for (int i = foundIdx; i < totalSongs - 1; i++) {
        songList[i] = songList[i + 1];
      }
      totalSongs--;
      saveSongMetadata();
    }

    sendAck(num, true, "Lagu dihapus");
    sendSongList();
  }
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.printf("[WS] Client #%u disconnected\n", num);
      break;
    case WStype_CONNECTED:
      Serial.printf("[WS] Client #%u connected\n", num);
      sendSongList(num);
      break;
    case WStype_TEXT:
      handleWebSocketMessage(num, payload, length);
      break;
    default:
      break;
  }
}

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== Gamolan Pekhing Autonomous ESP32 ===");

  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();

  if (!LittleFS.begin(true)) {
    Serial.println("[FS] Gagal inisialisasi LittleFS!");
  } else {
    Serial.println("[FS] LittleFS siap.");
  }
  loadSongMetadata();
  Serial.printf("[FS] Total lagu siap: %d\n", totalSongs);

  WiFi.softAP(AP_SSID, AP_PASS);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("[WIFI] Access Point aktif: ");
  Serial.println(AP_SSID);
  Serial.print("[WIFI] IP Address: ");
  Serial.println(IP);

  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  Serial.println("[WS] WebSocket Server siap di port 81");

  Serial.println("[INIT] Tes tangga nada (1-8)...");
  for (byte n = DO; n <= DO_T; n++) {
    digitalWrite(relayPins[n - 1], LOW);
    Serial.printf("[HIT] %d %s %d\n", n, namaNada[n], PULSE_MS);
    delay(PULSE_MS);
    digitalWrite(relayPins[n - 1], HIGH);
    Serial.printf("[OFF] %d\n", n);
    delay(200);
  }
  Serial.println("[INIT] Siap digunakan!");
}

void loop() {
  webSocket.loop();
  processPlayer();

  if (manualHitPin != -1 && millis() >= manualReleaseTime) {
    digitalWrite(manualHitPin, HIGH);
    manualHitPin = -1;
  }
}
