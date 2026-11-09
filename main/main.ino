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

// Tanah Airku (Ibu Sud, do=C, 4/4, Andante tempo 80) — transcribed bar-exact dari partitur kanonik
// Dede Suwanda (sahabatkuseni.com) & latihan not angka kanonik. Birama 4/4 = 16 unit.
// Rentang nada gamolan 8 bilah: 1 (DO) sampai 8 (DO_T); nada 1' adalah DO_T (bilah 8),
// nada oktaf tinggi (2', 3', 4') dirender ke bilah solmisasi RE, MI, FA.
// Mencakup 2 bait lengkap (Bait 1 & Bait 2) dengan transisi prima volta di birama 13 dan ending birama 25.
const Nada song_1[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: Intro / pickup "Ta-nah a-" (| 0 0 _0 5_ _3 4_ |)
  { DIAM, 8 }, { DIAM, 2 }, { SOL, 2 }, { MI, 2 }, { FA, 2 },
  // Birama 2: "-ir - ku ti-dak ku-lu-pa-" (| 5 ._1'_ =3'_2'=1' _7 6_ |)
  { SOL, 6 }, { DO_T, 2 }, { MI, 2 }, { RE, 1 }, { DO_T, 1 }, { SI, 2 }, { LA, 2 },
  // Birama 3: "-kan. Kan ter-ke-" (| 5 . ._5_ _1' 3'_ |)
  { SOL, 10 }, { SOL, 2 }, { DO_T, 2 }, { MI, 2 },
  // Birama 4: "-nang se-la-ma hi-dup-" (| 2' ._1'_ _7 7_ _6 7_ |)
  { RE, 6 }, { DO_T, 2 }, { SI, 2 }, { SI, 2 }, { LA, 2 }, { SI, 2 },
  // Birama 5: "-ku. Bi-ar-pun" (| 1' . ._1'_ _1' 7_ |)
  { DO_T, 10 }, { DO_T, 2 }, { DO_T, 2 }, { SI, 2 },
  // Birama 6: "sa-ya per-gi ja-" (| 6 6 ._1'_ _7 6_ |)
  { LA, 4 }, { LA, 6 }, { DO_T, 2 }, { SI, 2 }, { LA, 2 },
  // Birama 7: "-uh. Ti-dak-kan" (| 5 . ._3_ _4 5_ |)
  { SOL, 10 }, { MI, 2 }, { FA, 2 }, { SOL, 2 },
  // Birama 8: "hi-lang da-ri kal-" (| 7 6 ._2_ _3 4_ |)
  { SI, 4 }, { LA, 6 }, { RE, 2 }, { MI, 2 }, { FA, 2 },
  // Birama 9: "-bu. Ta-" (| 3 . . ._5_ |)
  { MI, 14 }, { SOL, 2 },
  // Birama 10: "-nah-ku yang ku-" (| 1' ._7_ 6 ._6_ |)
  { DO_T, 6 }, { SI, 2 }, { LA, 6 }, { LA, 2 },
  // Birama 11: "-cin-ta-i, Eng-" (| 2' ._3'_ 4' 6 |)
  { RE, 6 }, { MI, 2 }, { FA, 4 }, { LA, 4 },
  // Birama 12: "-kau ku-har-ga-" (| 5 1' 7 2' |)
  { SOL, 4 }, { DO_T, 4 }, { SI, 4 }, { RE, 4 },
  // Birama 13: Prima Volta / transisi: "-i. Wa-lau-pun ba-" (| 1' . _0 5_ _3 4_ |)
  { DO_T, 8 }, { DIAM, 2 }, { SOL, 2 }, { MI, 2 }, { FA, 2 },

  // --- BAIT 2 ---
  // Birama 14: "-nyak ne-ge-ri ku-ja-la-" (| 5 ._1'_ =3'_2'=1' _7 6_ |)
  { SOL, 6 }, { DO_T, 2 }, { MI, 2 }, { RE, 1 }, { DO_T, 1 }, { SI, 2 }, { LA, 2 },
  // Birama 15: "-ni. Yang mas-yhur per-" (| 5 . ._5_ _1' 3'_ |)
  { SOL, 10 }, { SOL, 2 }, { DO_T, 2 }, { MI, 2 },
  // Birama 16: "-mai di-ka-ta o-" (| 2' ._1'_ _7 7_ _6 7_ |)
  { RE, 6 }, { DO_T, 2 }, { SI, 2 }, { SI, 2 }, { LA, 2 }, { SI, 2 },
  // Birama 17: "-rang. Te-ta-pi" (| 1' . ._1'_ _1' 7_ |)
  { DO_T, 10 }, { DO_T, 2 }, { DO_T, 2 }, { SI, 2 },
  // Birama 18: "kam-pung dan ru-mah-ku" (| 6 6 ._1'_ _7 6_ |)
  { LA, 4 }, { LA, 6 }, { DO_T, 2 }, { SI, 2 }, { LA, 2 },
  // Birama 19: "Di-sa-na-lah ku" (| 5 . ._3_ _4 5_ |)
  { SOL, 10 }, { MI, 2 }, { FA, 2 }, { SOL, 2 },
  // Birama 20: "ra-sa se-" (| 7 6 ._2_ _3 4_ |)
  { SI, 4 }, { LA, 6 }, { RE, 2 }, { MI, 2 }, { FA, 2 },
  // Birama 21: "-nang. Ta-" (| 3 . . ._5_ |)
  { MI, 14 }, { SOL, 2 },
  // Birama 22: "-nah-ku tak ku-" (| 1' ._7_ 6 ._6_ |)
  { DO_T, 6 }, { SI, 2 }, { LA, 6 }, { LA, 2 },
  // Birama 23: "-lu-pa-kan, Eng-" (| 2' ._3'_ 4' 6 |)
  { RE, 6 }, { MI, 2 }, { FA, 4 }, { LA, 4 },
  // Birama 24: "-kau ku-bang-ga-kan" (| 5 1' 7 2' |)
  { SOL, 4 }, { DO_T, 4 }, { SI, 4 }, { RE, 4 },
  // Birama 25: Seconda Volta / akhir "-kan" (| 1' . . 0 ||)
  { DO_T, 12 }, { DIAM, 4 }
};

const Nada song_2[] PROGMEM = {
  // Birama 1: "Pa-da-mu ne-g'ri" (5_ 1 . 6_ 5_ 3_ 0)
  { SOL, 4 }, { DO_T, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 2 }, { DIAM, 2 },
  // Birama 2: "ka-mi ber-jan-ji" (5_ . 5_ 1 . 2 3 -)
  { SOL, 3 }, { SOL, 1 }, { DO, 3 }, { RE, 1 }, { MI, 8 },
  // Birama 3: "Pa-da-mu ne-g'ri" (4 5 . 5 3 1 0)
  { FA, 4 }, { SOL, 3 }, { SOL, 1 }, { MI, 4 }, { DO, 2 }, { DIAM, 2 },
  // Birama 4: "ka-mi ber-bak-ti" (1 . 1 2 . 3 2 -)
  { DO, 3 }, { DO, 1 }, { RE, 3 }, { MI, 1 }, { RE, 8 },
  // Birama 5: "Pa-da-mu ne-g'ri"
  { SOL, 4 }, { DO_T, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 2 }, { DIAM, 2 },
  // Birama 6: "ka-mi me-ngab-di"
  { SOL, 3 }, { SOL, 1 }, { DO, 3 }, { RE, 1 }, { MI, 8 },
  // Birama 7: "ba-gi-mu ne-g'ri" (4 5 . 5 3 1 0)
  { FA, 4 }, { SOL, 3 }, { SOL, 1 }, { MI, 4 }, { DO, 2 }, { DIAM, 2 },
  // Birama 8: "ji-wa-ra-ga-ka-mi"; triplet 2-3-4 dikuantisasi 1-2-1 (asli 1.33)
  { RE, 1 }, { MI, 2 }, { FA, 1 }, { MI, 2 }, { RE, 2 }, { DO, 8 }
};

const Nada song_3[] PROGMEM = {
  // Pickup (Beat 4): "Ga-ru" (5_ . 5_)
  { DO, 3 }, { DO, 1 },
  // Bar 1: "da Pan-ca-si" (1 1 2 2)
  { DO, 4 }, { DO, 4 }, { RE, 4 }, { RE, 4 },
  // Bar 2: "la - a-" (3 . 0 3 . 4)
  { MI, 8 }, { DIAM, 4 }, { MI, 3 }, { FA, 1 },
  // Bar 3: "ku-lah pen-du-kung" (5 1 . 2 3 4)
  { SOL, 4 }, { DO, 3 }, { RE, 1 }, { MI, 4 }, { FA, 4 },
  // Bar 4: "mu - Pa-tri-" (2 . 0 5_ . 5_)
  { RE, 8 }, { DIAM, 4 }, { DO, 3 }, { DO, 1 },
  // Bar 5: "ot prok-la-ma" (2 2 3 3)
  { RE, 4 }, { RE, 4 }, { MI, 4 }, { MI, 4 },
  // Bar 6: "si - se-di-" (4 . 0 3 . 2)
  { FA, 8 }, { DIAM, 4 }, { MI, 3 }, { RE, 1 },
  // Bar 7: "a ber-kor-ban un-tuk" (1 5_ . 5_ 5_ 6_ . 7_)
  { DO, 4 }, { SOL, 3 }, { SOL, 1 }, { SOL, 4 }, { LA, 3 }, { SI, 1 },
  // Bar 8: "mu - Pan-ca" (1' . 0 1 . 1)
  { DO_T, 8 }, { DIAM, 4 }, { DO, 3 }, { DO, 1 },
  // Bar 9: "si-la da-sar ne-ga" (1 . 6_ . 1 4 5 . 6)
  { DO, 4 }, { DO, 3 }, { DO, 1 }, { FA, 4 }, { SOL, 3 }, { LA, 1 },
  // Bar 10: "ra - Rak-yat" (5 . 0 1 . 1)
  { SOL, 8 }, { DIAM, 4 }, { DO, 3 }, { DO, 1 },
  // Bar 11: "a-dil mak-mur sen-to" (1 6_ . 1 4 5 . 6)
  { DO, 4 }, { DO, 3 }, { DO, 1 }, { FA, 4 }, { SOL, 3 }, { LA, 1 },
  // Bar 12: "sa - Pri-" (5 . 0 5)
  { SOL, 8 }, { DIAM, 4 }, { SOL, 4 },
  // Bar 13: "ba-di bang-sa" (6 . 5 4 3)
  { LA, 6 }, { SOL, 2 }, { FA, 4 }, { MI, 4 },
  // Bar 14: "ku - a yo-ma" (2 . 0 1 1 . 1)
  { RE, 8 }, { DIAM, 2 }, { DO, 2 }, { DO, 3 }, { DO, 1 },
  // Bar 15: "ju-ma-ju a-yo-ma" (1 . 6_ 5_ . 1 1 1)
  { DO, 6 }, { LA, 2 }, { SOL, 3 }, { DO, 1 }, { DO, 2 }, { DO, 2 },
  // Bar 16: "ju-ma-ju - a" (1 . 2 3 0 1)
  { DO, 6 }, { RE, 2 }, { MI, 2 }, { DIAM, 2 }, { DO, 4 },
  // Bar 17: "yo-ma-ju-ma" (1 6_ 5_ . 7_)
  { DO, 4 }, { LA, 4 }, { SOL, 6 }, { SI, 2 },
  // Bar 18: "ju!" (1 . . 0)
  { DO, 12 }, { DIAM, 4 }
};

const Nada song_4[] PROGMEM = {
  // Bar 1: "I-bu ki-ta" (1 . 2 3 4)
  { DO, 6 }, { RE, 2 }, { MI, 4 }, { FA, 4 },
  // Bar 2: "Kar-ti-ni" (5 . 3 1)
  { SOL, 8 }, { MI, 4 }, { DO, 4 },
  // Bar 3: "pu-tri se-ja-" (6 . 1' 7 6)
  { LA, 6 }, { DO_T, 2 }, { SI, 4 }, { LA, 4 },
  // Bar 4: "-ti" (5)
  { SOL, 12 }, { DIAM, 4 },
  // Bar 5: "Pu-tri In-do-" (4 . 6 5 4)
  { FA, 6 }, { LA, 2 }, { SOL, 4 }, { FA, 4 },
  // Bar 6: "-ne-sia" (3 . 1 .)
  { MI, 8 }, { DO, 8 },
  // Bar 7: "ha-rum na-ma-" (2 . 4 3 2)
  { RE, 6 }, { FA, 2 }, { MI, 4 }, { RE, 4 },
  // Bar 8: "-nya" (1)
  { DO, 12 }, { DIAM, 4 },

  // Bar 9: "Wa-hai I-bu" (4 . 3 4 6)
  { FA, 6 }, { MI, 2 }, { FA, 4 }, { LA, 4 },
  // Bar 10: "ki-ta Kar-ti-ni, Pu-" (5 6 5 3 1 3)
  { SOL, 2 }, { LA, 2 }, { SOL, 2 }, { MI, 2 }, { DO, 4 }, { MI, 4 },
  // Bar 11: "-tri yang mu-li-" (2 3 4 5)
  { RE, 4 }, { MI, 4 }, { FA, 4 }, { SOL, 4 },
  // Bar 12: "-a" (3)
  { MI, 12 }, { DIAM, 4 },
  // Bar 13: "Sung-guh be-sar" (4 . 3 4 6)
  { FA, 6 }, { MI, 2 }, { FA, 4 }, { LA, 4 },
  // Bar 14: "ci-ta-ci-ta-nya, ba-" (5 6 5 3 1 3)
  { SOL, 2 }, { LA, 2 }, { SOL, 2 }, { MI, 2 }, { DO, 4 }, { MI, 4 },
  // Bar 15: "-gi In-do-ne-" (2 4 3 2)
  { RE, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 },
  // Bar 16: "-sia" (1)
  { DO, 12 }, { DIAM, 4 }
};

// --- 2. LAGU DAERAH ---
// Anak Kambing Saya (Nusa Tenggara Timur, 4/4 / 2/4, Allegro tempo 112) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 5̣ (SOL rendah) dipetakan ke SOL (5), 6̣ (LA rendah) ke LA (6), 7̣ (SI rendah) ke SI (7).
// Birama 4/4 = 16 unit per birama (1=1/16, 2=1/8, 4=1/4, 6=3/8, 8=1/2, 16=1 bar utuh).
const Nada song_5[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: "Ma-na di-ma-na an-" (| 1_ 1_ 1_ 1_ 1 ._ 7̣_ |)
  { DO, 2 }, { DO, 2 }, { DO, 2 }, { DO, 2 }, { DO, 6 }, { SI, 2 },
  // Birama 2: "-ak kam-bing sa-ya a-" (| 6̣_ 1_ 7̣_ 6̣_ 5̣ ._ 5̣_ |)
  { LA, 2 }, { DO, 2 }, { SI, 2 }, { LA, 2 }, { SOL, 6 }, { SOL, 2 },
  // Birama 3: "-nak kam-bing tu-an a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Birama 4: "di po-hon wa-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 8 },

  // --- BAIT 2 ---
  // Birama 5: "Ma-na di-ma-na jan-" (| 1_ 1_ 1_ 1_ 1 ._ 7̣_ |)
  { DO, 2 }, { DO, 2 }, { DO, 2 }, { DO, 2 }, { DO, 6 }, { SI, 2 },
  // Birama 6: "-tung ha-ti sa-ya jan-" (| 6̣_ 1_ 7̣_ 6̣_ 5̣ ._ 5̣_ |)
  { LA, 2 }, { DO, 2 }, { SI, 2 }, { LA, 2 }, { SOL, 6 }, { SOL, 2 },
  // Birama 7: "-tung ha-ti tu-an a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Birama 8: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 8 },

  // --- REFF / CHORUS 1 ---
  // Birama 9: "Ca-ca ma-ri-ca he-hei" (| 4_ 4_ 4_ 4_ 4_ 6_ 6 |)
  { FA, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { LA, 2 }, { LA, 4 },
  // Birama 10: "Ca-ca ma-ri-ca he-hei" (| 3_ 3_ 3_ 3_ 3_ 5_ 5 |)
  { MI, 2 }, { MI, 2 }, { MI, 2 }, { MI, 2 }, { MI, 2 }, { SOL, 2 }, { SOL, 4 },
  // Birama 11: "Ca-ca ma-ri-ca a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Birama 12: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 8 },

  // --- REFF / CHORUS 2 ---
  // Birama 13: "Ca-ca ma-ri-ca he-hei" (| 4_ 4_ 4_ 4_ 4_ 6_ 6 |)
  { FA, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { LA, 2 }, { LA, 4 },
  // Birama 14: "Ca-ca ma-ri-ca he-hei" (| 3_ 3_ 3_ 3_ 3_ 5_ 5 |)
  { MI, 2 }, { MI, 2 }, { MI, 2 }, { MI, 2 }, { MI, 2 }, { SOL, 2 }, { SOL, 4 },
  // Birama 15: "Ca-ca ma-ri-ca a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Birama 16: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 8 }
};

// Cublak-Cublak Suweng (Jawa Timur - Sunan Giri, 4/4, Allegro tempo 140) — ditransposisi +5 semitone (Sol rendah = Bilah 1)
// agar kontur melodi 5̣ dan 6̣ (Pak Em-pong) turun alami ke bilah 1 & 2 tanpa melompat ke oktaf atas.
// Pemetaan 8 bilah: 5̣->1(DO), 6̣->2(RE), 1->4(FA), 2->5(SOL), 3->6(LA), 5->8(DO_T). Semua interval identik 100%.
// Birama 4/4 = 16 unit per birama (4=1/4 ketuk, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_6[] PROGMEM = {
  // Bar 0: Intro / pickup "Cub" (| 0 0 0 3 | -> 0 0 0 6)
  { DIAM, 12 }, { LA, 4 },
  // Bar 1: "lak cub lak su" (| 5 5 2 3 | -> 8 8 5 6)
  { DO_T, 4 }, { DO_T, 4 }, { SOL, 4 }, { LA, 4 },
  // Bar 2: "weng su weng e" (| 1 0 2 3 | -> 4 0 5 6)
  { FA, 4 }, { DIAM, 4 }, { SOL, 4 }, { LA, 4 },
  // Bar 3: "teng ge len" (| 2 5 3 2 | -> 5 8 6 5)
  { SOL, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 },
  // Bar 4: "ter Mam bu ke" (| 1 0 2 3 | -> 4 0 5 6)
  { FA, 4 }, { DIAM, 4 }, { SOL, 4 }, { LA, 4 },
  // Bar 5: "thu dung gu" (| 2 5 3 2 | -> 5 8 6 5)
  { SOL, 4 }, { DO_T, 4 }, { LA, 4 }, { SOL, 4 },
  // Bar 6: "del Pak Em" (| 1 0 1 5̣ | -> 4 0 4 1)
  { FA, 4 }, { DIAM, 4 }, { FA, 4 }, { DO, 4 },
  // Bar 7: "pong le ra le" (| 6̣ 1 2 3 | -> 2 4 5 6)
  { RE, 4 }, { FA, 4 }, { SOL, 4 }, { LA, 4 },
  // Bar 8: "le So po nggu" (| 1 1 1 5̣ | -> 4 4 4 1)
  { FA, 4 }, { FA, 4 }, { FA, 4 }, { DO, 4 },
  // Bar 9: "yu nde lik a" (| 6̣ 1 2 3 | -> 2 4 5 6)
  { RE, 4 }, { FA, 4 }, { SOL, 4 }, { LA, 4 },
  // Bar 10: "ke sir sir" (| 1 5 . 5 | -> 4 8 . 8)
  { FA, 4 }, { DO_T, 8 }, { DO_T, 4 },
  // Bar 11: "pong de le ko" (| 3 2 1 2 | -> 6 5 4 5)
  { LA, 4 }, { SOL, 4 }, { FA, 4 }, { SOL, 4 },
  // Bar 12: "pong sir sir" (| 3 5 . 5 | -> 6 8 . 8)
  { LA, 4 }, { DO_T, 8 }, { DO_T, 4 },
  // Bar 13: "pong de le ko" (| 3 2 1 2 | -> 6 5 4 5)
  { LA, 4 }, { SOL, 4 }, { FA, 4 }, { SOL, 4 },
  // Bar 14: Ending "pong" (| 3 . . 0 | -> 6 . . 0)
  { LA, 12 }, { DIAM, 4 }
};

// Gundhul Pacul (Jawa Tengah, 4/4, Moderato tempo 112) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 1' adalah DO_T (bilah 8); bagian "gembelengan" menggunakan 8 7 (DO_T SI).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 6=3/8, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_7[] PROGMEM = {
  // Birama 1: Intro / pickup "Gundhul" (| 0 0 0 1 |)
  { DIAM, 12 }, { DO, 4 },
  // Birama 2: "-gudhul pa-cul-" (| 3 ._1_ 3 4 |)
  { MI, 6 }, { DO, 2 }, { MI, 4 }, { FA, 4 },
  // Birama 3: "cul gem-" (| 5 5 0 7 |)
  { SOL, 4 }, { SOL, 4 }, { DIAM, 4 }, { SI, 4 },
  // Birama 4: "-be-leng-an," (| 1' 7 1' 7 | -> 8 7 8 7)
  { DO_T, 4 }, { SI, 4 }, { DO_T, 4 }, { SI, 4 },
  // Birama 5: "Nyung-" (| 5 . 0 1 |)
  { SOL, 8 }, { DIAM, 4 }, { DO, 4 },

  // Birama 6: "-nyunggi wa-kul-" (| 3 ._1_ 3 4 |)
  { MI, 6 }, { DO, 2 }, { MI, 4 }, { FA, 4 },
  // Birama 7: "kul gem-" (| 5 5 0 7 |)
  { SOL, 4 }, { SOL, 4 }, { DIAM, 4 }, { SI, 4 },
  // Birama 8: "-be-leng-an," (| 1' 7 1' 7 | -> 8 7 8 7)
  { DO_T, 4 }, { SI, 4 }, { DO_T, 4 }, { SI, 4 },
  // Birama 9: "Wa-" (| 5 . 1 . |)
  { SOL, 8 }, { DO, 8 },

  // Birama 10: "kul ngglim-" (| 3 . 5 . |)
  { MI, 8 }, { SOL, 8 },
  // Birama 11: "pang se-ga-ne" (| 4 4 5 4 |)
  { FA, 4 }, { FA, 4 }, { SOL, 4 }, { FA, 4 },
  // Birama 12: "da-di sak la-" (| 3 1 4 3 |)
  { MI, 4 }, { DO, 4 }, { FA, 4 }, { MI, 4 },
  // Birama 13: "tar, Wa-" (| 1 . 0 1 |)
  { DO, 8 }, { DIAM, 4 }, { DO, 4 },

  // Birama 14: "kul ngglim-" (| 3 . 5 . |)
  { MI, 8 }, { SOL, 8 },
  // Birama 15: "pang se-ga-ne" (| 4 4 5 4 |)
  { FA, 4 }, { FA, 4 }, { SOL, 4 }, { FA, 4 },
  // Birama 16: "da-di sak la-" (| 3 1 4 3 |)
  { MI, 4 }, { DO, 4 }, { FA, 4 }, { MI, 4 },
  // Birama 17: Ending "tar" (| 1 . . . ||)
  { DO, 12 }, { DIAM, 4 }
};

// Apuse (Papua, 4/4, Moderato tempo 96) — transcribed bar-exact dari partitur kanonik.
// Not angka: 1' dirender ke DO_T (bilah 8), 2' ke RE (bilah 2), 4/ (fi) ke FA (bilah 4).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 8=1/2, 16=1 bar utuh).
const Nada song_8[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: "A-pu-se" (| 2 5 7 . |)
  { RE, 4 }, { SOL, 4 }, { SI, 8 },
  // Birama 2: "ko-kon-da-o" (| _6 7_ 6 5 . |)
  { LA, 2 }, { SI, 2 }, { LA, 4 }, { SOL, 8 },
  // Birama 3: "ya-ra-be" (| 2 5 7 . |)
  { RE, 4 }, { SOL, 4 }, { SI, 8 },
  // Birama 4: "so-ren do-re-ri" (| _7 6_ _7 1'_ 6 . |)
  { SI, 2 }, { LA, 2 }, { SI, 2 }, { DO_T, 2 }, { LA, 8 },
  // Birama 5: "Wuf-len-so" (| 2 4/ 6 . |)
  { RE, 4 }, { FA, 4 }, { LA, 8 },
  // Birama 6: "ba-ni-ne-ma" (| 1' _2' 1'_ 7 . |)
  { DO_T, 4 }, { RE, 2 }, { DO_T, 2 }, { SI, 8 },
  // Birama 7: "ba-ki-pa-se" (| _6 7_ 6 5 . |)
  { LA, 2 }, { SI, 2 }, { LA, 4 }, { SOL, 8 },

  // --- BAIT 2 ---
  // Birama 8: "A-pu-se" (| 2 5 7 . |)
  { RE, 4 }, { SOL, 4 }, { SI, 8 },
  // Birama 9: "ko-kon-da-o" (| _6 7_ 6 5 . |)
  { LA, 2 }, { SI, 2 }, { LA, 4 }, { SOL, 8 },
  // Birama 10: "ya-ra-be" (| 2 5 7 . |)
  { RE, 4 }, { SOL, 4 }, { SI, 8 },
  // Birama 11: "so-ren do-re-ri" (| _7 6_ _7 1'_ 6 . |)
  { SI, 2 }, { LA, 2 }, { SI, 2 }, { DO_T, 2 }, { LA, 8 },
  // Birama 12: "Wuf-len-so" (| 2 4/ 6 . |)
  { RE, 4 }, { FA, 4 }, { LA, 8 },
  // Birama 13: "ba-ni-ne-ma" (| 1' _2' 1'_ 7 . |)
  { DO_T, 4 }, { RE, 2 }, { DO_T, 2 }, { SI, 8 },
  // Birama 14: "ba-ki-pa-se" (| _6 7_ 6 5 . |)
  { LA, 2 }, { SI, 2 }, { LA, 4 }, { SOL, 8 },

  // Birama 15: Akhir / rest
  { DIAM, 16 }
};

// Suwe Ora Jamu (Jawa Tengah, 4/4, Moderato tempo 104) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 1' adalah DO_T (bilah 8); ornamen (3 4) pada "Su-" disederhanakan ke 4 (FA).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 6=3/8, 12=3/4, 16=1 bar utuh).
const Nada song_9[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: Intro / pickup "Su-" (| 0 0 0 4 |)
  { DIAM, 12 }, { FA, 4 },
  // Birama 2: "-we o-ra ja-" (| 5 ._5_ 3 4 |)
  { SOL, 6 }, { SOL, 2 }, { MI, 4 }, { FA, 4 },
  // Birama 3: "-mu, Ja-" (| 5 . . 3 |)
  { SOL, 12 }, { MI, 4 },
  // Birama 4: "-mu go-dhong te-" (| 4 ._4_ 5 3 |)
  { FA, 6 }, { FA, 2 }, { SOL, 4 }, { MI, 4 },
  // Birama 5: "-lo, Su-" (| 4 . . 5 |)
  { FA, 12 }, { SOL, 4 },
  // Birama 6: "-we o-ra ke-te-" (| 7 ._7_ 1' 1' |)
  { SI, 6 }, { SI, 2 }, { DO_T, 4 }, { DO_T, 4 },
  // Birama 7: "-mu, ke-te-mu" (| 7 ._7_ 6 6 |)
  { SI, 6 }, { SI, 2 }, { LA, 4 }, { LA, 4 },
  // Birama 8: "pi-san ga-we" (| 4 ._4_ 3 3 |)
  { FA, 6 }, { FA, 2 }, { MI, 4 }, { MI, 4 },
  // Birama 9: "ge-lo. Su-" (| 1 . . 4 |)
  { DO, 12 }, { FA, 4 },

  // --- BAIT 2 ---
  // Birama 10: "-we o-ra ja-" (| 5 ._5_ 3 4 |)
  { SOL, 6 }, { SOL, 2 }, { MI, 4 }, { FA, 4 },
  // Birama 11: "-mu, Ja-mu" (| 5 . . 3 |)
  { SOL, 12 }, { MI, 4 },
  // Birama 12: "go-dhong te-" (| 4 ._4_ 5 3 |)
  { FA, 6 }, { FA, 2 }, { SOL, 4 }, { MI, 4 },
  // Birama 13: "-lo, Su-" (| 4 . . 5 |)
  { FA, 12 }, { SOL, 4 },
  // Birama 14: "-we o-ra ke-te-" (| 7 ._7_ 1' 1' |)
  { SI, 6 }, { SI, 2 }, { DO_T, 4 }, { DO_T, 4 },
  // Birama 15: "-mu, ke-te-mu" (| 7 ._7_ 6 6 |)
  { SI, 6 }, { SI, 2 }, { LA, 4 }, { LA, 4 },
  // Birama 16: "pi-san ga-we" (| 4 ._4_ 3 3 |)
  { FA, 6 }, { FA, 2 }, { MI, 4 }, { MI, 4 },
  // Birama 17: Ending "ge-lo." (| 1 . . . ||)
  { DO, 12 }, { DIAM, 4 }
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

// Pelangi-Pelangi (A.T. Mahmud, 2/4, Andante tempo 80) — transcribed bar-exact dari partitur kanonik.
// Not angka: 5 3 3 3 3 3 | 3 2 1 1 1 2 2 . | 5 4 4 4 3 2 | 4 3 2 1 2 3 3 . (rentang nada 1 s.d. 5).
// Birama 2/4 = 8 unit per birama (2=1/8, 4=1/4, 6=3/8, 8=1/2). Total 20 birama (56 not).
const Nada song_17[] PROGMEM = {
  // Bar 1: "Pe-" (| 0 5 |)
  { DIAM, 4 }, { SOL, 4 },
  // Bar 2: "la-ngi" (| 3 ._ 3_ |)
  { MI, 6 }, { MI, 2 },
  // Bar 3: "pe-la-ngi" (| 3_ 3_ 3 0 |)
  { MI, 2 }, { MI, 2 }, { MI, 4 },
  // Bar 4: "a-lang-kah" (| 3_ 2_ 1_ 1_ |)
  { MI, 2 }, { RE, 2 }, { DO, 2 }, { DO, 2 },
  // Bar 5: "in-dah-mu" (| 1_ 2_ 2 0 |)
  { DO, 2 }, { RE, 2 }, { RE, 4 },

  // Bar 6: "Me-" (| 0 5 |)
  { DIAM, 4 }, { SOL, 4 },
  // Bar 7: "rah ku-ning" (| 4 ._ 4_ |)
  { FA, 6 }, { FA, 2 },
  // Bar 8: "hi-jau" (| 4_ 3_ 2 0 |)
  { FA, 2 }, { MI, 2 }, { RE, 4 },
  // Bar 9: "di la-ngit" (| 4_ 3_ 2_ 1_ |)
  { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 2 },
  // Bar 10: "yang bi-ru" (| 2_ 3_ 3 0 |)
  { RE, 2 }, { MI, 2 }, { MI, 4 },

  // Bar 11: "Pe-" (| 0 3 |)
  { DIAM, 4 }, { MI, 4 },
  // Bar 12: "lu-kis-mu" (| 5_ 5_ 5_ 3_ |)
  { SOL, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 },
  // Bar 13: "a-gung" (| 4_ 4_ 4 0 |)
  { FA, 2 }, { FA, 2 }, { FA, 4 },
  // Bar 14: "sia-pa" (| 3_ 3_ 3_ 1_ |)
  { MI, 2 }, { MI, 2 }, { MI, 2 }, { DO, 2 },
  // Bar 15: "ge-ran-gan" (| 2 . 0 0 |)
  { RE, 8 },

  // Bar 16: "Pe-" (| 0 5 |)
  { DIAM, 4 }, { SOL, 4 },
  // Bar 17: "la-ngi pe-" (| 1_ 3_ 3_ 2_ |)
  { DO, 2 }, { MI, 2 }, { MI, 2 }, { RE, 2 },
  // Bar 18: "la-ngi" (| 4_ 3_ 3 0 |)
  { FA, 2 }, { MI, 2 }, { MI, 4 },
  // Bar 19: "cip-ta-an" (| 3_ 3_ 2_ 2_ |)
  { MI, 2 }, { MI, 2 }, { RE, 2 }, { RE, 2 },
  // Bar 20: "Tu-han" (| 1 . |)
  { DO, 8 }
};

// Balonku Ada Lima (A.T. Mahmud / Pak Kasur, 4/4 / 2/4, tempo 104) — transcribed bar-exact dari partitur kanonik.
// Not angka: rentang nada 1 (DO) s.d. 8 (DO_T), mencakup 7 (SI) & 8 (DO_T) saat "DOR" dan "kelabu/tinggal empat".
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 6=3/8, 10=5/8, 16=1 bar utuh).
const Nada song_18[] PROGMEM = {
  // Bar 1: "Ba-lon-ku a-da li-ma" (| 3_ 4_ 5_ 1'_ | 5_ 3_ 5 . |)
  { MI, 2 }, { FA, 2 }, { SOL, 2 }, { DO_T, 2 }, { SOL, 2 }, { MI, 2 }, { SOL, 4 },
  // Bar 2: "Ru-pa-ru-pa war-na-nya" (| 2_ 3_ 4_ 2_ | 5_ 4_ 3 . |)
  { RE, 2 }, { MI, 2 }, { FA, 2 }, { RE, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 4 },
  // Bar 3: "Hi-jau ku-ning ke-la-bu" (| 1_ 1_ 6_ 6_ | 7_ 1'_ 5 . |)
  { DO, 2 }, { DO, 2 }, { LA, 2 }, { LA, 2 }, { SI, 2 }, { DO_T, 2 }, { SOL, 4 },
  // Bar 4: "Me-rah mu-da dan bi-ru" (| 3_ 4_ 5_ 4_ | 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 4 },
  // Bar 5: "Me-le-tus ba-lon hi-jau" (| 3_ 4_ 5_ 1'_ | 5_ 3_ 5 . |)
  { MI, 2 }, { FA, 2 }, { SOL, 2 }, { DO_T, 2 }, { SOL, 2 }, { MI, 2 }, { SOL, 4 },
  // Bar 6: "DOR!" (| 1' . 0 . |)
  { DO_T, 6 }, { DIAM, 10 },
  // Bar 7: "Ha-ti-ku sa-ngat ka-cau" (| 2_ 3_ 4_ 2_ | 5_ 4_ 3 . |)
  { RE, 2 }, { MI, 2 }, { FA, 2 }, { RE, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 4 },
  // Bar 8: "Ba-lon-ku ting-gal em-pat" (| 1_ 1_ 6_ 6_ | 7_ 1'_ 5 . |)
  { DO, 2 }, { DO, 2 }, { LA, 2 }, { LA, 2 }, { SI, 2 }, { DO_T, 2 }, { SOL, 4 },
  // Bar 9: "Ku-pe-gang e-rat-e-rat" (| 3_ 4_ 5_ 4_ | 3_ 2_ 1 . |)
  { MI, 2 }, { FA, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 4 }
};

// Naik Delman (Ibu Sud / Pak Kasur, 4/4 / 2/4, Allegro tempo 120) — transcribed bar-exact dari partitur kanonik.
// Not angka: rentang nada 1 (DO) s.d. 6 (LA), sangat ritmis dan cocok untuk solenoid gamolan pada reff "Tuk-tik-tak".
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_19[] PROGMEM = {
  // --- BAIT ---
  // Bar 1: Intro / pickup "Pa-da" (| 0 0 0 5_ 5_ |)
  { DIAM, 12 }, { SOL, 2 }, { SOL, 2 },
  // Bar 2: "ha-ri Ming-gu ku tu-rut a-yah ke ko-ta" (| 1_ 1_ 1_ 3_ 5_ 5_ 5_ 3_ |)
  { DO, 2 }, { DO, 2 }, { DO, 2 }, { MI, 2 }, { SOL, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 },
  // Bar 3: "Na-ik del-man is-ti-me-wa ku du-duk di mu-ka" (| 6_ 6_ 6_ 3_ 5 . 0 5_ |)
  { LA, 2 }, { LA, 2 }, { LA, 2 }, { MI, 2 }, { SOL, 4 }, { DIAM, 2 }, { SOL, 2 },
  // Bar 4: "Na-ik del-man is-ti-me-wa ku du-duk di mu-ka" (| 1_ 1_ 1_ 3_ 5_ 5_ 5_ 3_ |)
  { DO, 2 }, { DO, 2 }, { DO, 2 }, { MI, 2 }, { SOL, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 },
  // Bar 5: "ku du-duk di mu-ka" (| 6_ 6_ 3_ 4_ 2 . 0 5_ |)
  { LA, 2 }, { LA, 2 }, { MI, 2 }, { FA, 2 }, { RE, 4 }, { DIAM, 2 }, { SOL, 2 },
  // Bar 6: "Ku du-duk sam-ping pak ku-sir yang se-dang be-ker-ja" (| 2_ 2_ 2_ 3_ 4_ 4_ 4_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { MI, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { RE, 2 },
  // Bar 7: "yang se-dang be-ker-ja" (| 5_ 5_ 4_ 3_ 2 . 0 5_ |)
  { SOL, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 4 }, { DIAM, 2 }, { SOL, 2 },
  // Bar 8: "Me-ngen-da-ra-i ku-da su-pa-ya ba-ik ja-lan-nya" (| 2_ 2_ 2_ 3_ 4_ 4_ 4_ 2_ |)
  { RE, 2 }, { RE, 2 }, { RE, 2 }, { MI, 2 }, { FA, 2 }, { FA, 2 }, { FA, 2 }, { RE, 2 },
  // Bar 9: "su-pa-ya ba-ik ja-lan-nya" (| 5_ 4_ 3_ 2_ 1 . 0 0 |)
  { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 4 }, { DIAM, 4 },

  // --- CHORUS 1 ---
  // Bar 10: "Tuk-tik-tak-tik-tuk tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 1_ 3_ 5_ 3_ |)
  { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 }, { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 },
  // Bar 11: "tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 2 . 0 0 |)
  { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 4 }, { DIAM, 4 },
  // Bar 12: "Tuk-tik-tak-tik-tuk tik-tak" (| 2_ 4_ 6_ 4_ 2_ 4_ 6_ 4_ |)
  { RE, 2 }, { FA, 2 }, { LA, 2 }, { FA, 2 }, { RE, 2 }, { FA, 2 }, { LA, 2 }, { FA, 2 },
  // Bar 13: "sua-ra se-pa-tu ku-da" (| 2_ 4_ 3_ 2_ 1 . 0 0 |)
  { RE, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 4 }, { DIAM, 4 },

  // --- CHORUS 2 ---
  // Bar 14: "Tuk-tik-tak-tik-tuk tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 1_ 3_ 5_ 3_ |)
  { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 }, { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 },
  // Bar 15: "tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 2 . 0 0 |)
  { DO, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 4 }, { DIAM, 4 },
  // Bar 16: "Tuk-tik-tak-tik-tuk tik-tak" (| 2_ 4_ 6_ 4_ 2_ 4_ 6_ 4_ |)
  { RE, 2 }, { FA, 2 }, { LA, 2 }, { FA, 2 }, { RE, 2 }, { FA, 2 }, { LA, 2 }, { FA, 2 },
  // Bar 17: "sua-ra se-pa-tu ku-da" (| 2_ 4_ 3_ 2_ 1 . . 0 |)
  { RE, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 8 }
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
  "Anak Kambing Saya", "Cublak-Cublak Suweng", "Gundul-Gundul Pacul", "Apuse", "Suwe Ora Jamu",
  "Tabuh Segata", "Sang Bumi Ruwa Jurai", "Tanoh Lado", "Gitar Tunggal Lampung", "Mulang Unyin",
  "Twinkle Twinkle Little Star", "Selamat Ulang Tahun", "Pelangi-Pelangi", "Balonku Ada Lima", "Naik Delman"
};

const char* const defaultSongCats[] = {
  "nasional", "nasional", "nasional", "nasional", "nasional",
  "daerah", "daerah", "daerah", "daerah", "daerah",
  "lampung", "lampung", "lampung", "lampung", "lampung",
  "lainnya", "lainnya", "lainnya", "lainnya", "lainnya"
};

const int defaultSongTempos[] = {
  96, 80, 80, 100, 88,
  112, 140, 112, 96, 104,
  96, 100, 92, 88, 92,
  100, 100, 80, 84, 92
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

const int PULSE_MS = 40;        // ms relay nyala (pukul solenoid) — gamolan perkusif
const int JEDA_MIN_MS = 25;     // ms jeda minimum antar nada

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

  bool isDel[NUM_DEFAULT_SONGS];
  for (int i = 0; i < NUM_DEFAULT_SONGS; i++) isDel[i] = false;
  if (LittleFS.exists("/deleted_defaults.json")) {
    File fDel = LittleFS.open("/deleted_defaults.json", "r");
    if (fDel) {
      JsonDocument docDel;
      if (!deserializeJson(docDel, fDel)) {
        for (JsonVariant v : docDel.as<JsonArray>()) {
          int d = v | -1;
          if (d >= 0 && d < NUM_DEFAULT_SONGS) isDel[d] = true;
        }
      }
      fDel.close();
    }
  }

  for (int i = 0; i < NUM_DEFAULT_SONGS; i++) {
    if (isDel[i]) continue;
    songList[totalSongs].id = i;
    songList[totalSongs].name = defaultSongNames[i];
    songList[totalSongs].category = defaultSongCats[i];
    songList[totalSongs].tempo = defaultSongTempos[i];
    songList[totalSongs].noteCount = defaultSongLengths[i];
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

  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id >= 20) {
      JsonObject obj = arr.add<JsonObject>();
      obj["id"] = songList[i].id;
      obj["name"] = songList[i].name;
      obj["cat"] = songList[i].category;
      obj["tempo"] = songList[i].tempo;
      obj["len"] = songList[i].noteCount;
    }
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

  } else if (strcmp(cmd, "get_notes") == 0) {
    int id = doc["id"] | -1;
    if (loadSongNotes(id)) {
      JsonDocument resp;
      resp["t"] = "song_detail";
      resp["id"] = id;
      resp["tempo"] = activeSongTempo;
      for (int i = 0; i < totalSongs; i++) {
        if (songList[i].id == id) {
          resp["name"] = songList[i].name;
          resp["cat"] = songList[i].category;
          break;
        }
      }
      JsonArray arr = resp["notes"].to<JsonArray>();
      for (int i = 0; i < activeSongNoteCount; i++) {
        JsonArray n = arr.add<JsonArray>();
        n.add(currentNotes[i].nada);
        n.add(currentNotes[i].panjang);
      }
      String out;
      serializeJson(resp, out);
      webSocket.sendTXT(num, out);
    } else {
      sendAck(num, false, "Lagu tidak ditemukan");
    }

  } else if (strcmp(cmd, "edit") == 0) {
    int id = doc["id"] | -1;
    const char* name = doc["name"] | "Lagu";
    const char* cat = doc["cat"] | "lainnya";
    int tempo = doc["tempo"] | 120;
    JsonArray notesArr = doc["notes"].as<JsonArray>();

    if (notesArr.size() == 0 || notesArr.size() > MAX_NOTES) {
      sendAck(num, false, "Jumlah nada tidak valid");
      return;
    }

    int targetId = id;
    if (targetId < NUM_DEFAULT_SONGS) {
      targetId = NUM_DEFAULT_SONGS;
      for (int i = 0; i < totalSongs; i++) {
        if (songList[i].id >= targetId) targetId = songList[i].id + 1;
      }
    }

    String path = "/song_" + String(targetId) + ".bin";
    File f = LittleFS.open(path, "w");
    if (!f) {
      sendAck(num, false, "Gagal menulis flash");
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

    int foundIdx = -1;
    for (int i = 0; i < totalSongs; i++) {
      if (songList[i].id == targetId) {
        foundIdx = i;
        break;
      }
    }

    if (foundIdx != -1) {
      songList[foundIdx].name = String(name);
      songList[foundIdx].category = String(cat);
      songList[foundIdx].tempo = tempo;
      songList[foundIdx].noteCount = notesArr.size();
    } else if (totalSongs < MAX_SONGS) {
      songList[totalSongs].id = targetId;
      songList[totalSongs].name = String(name);
      songList[totalSongs].category = String(cat);
      songList[totalSongs].tempo = tempo;
      songList[totalSongs].noteCount = notesArr.size();
      totalSongs++;
    }
    saveSongMetadata();

    sendAck(num, true, "Lagu berhasil diperbarui");
    sendSongList();

  } else if (strcmp(cmd, "del") == 0) {
    int id = doc["id"] | -1;
    if (id < 0) {
      sendAck(num, false, "ID tidak valid");
      return;
    }

    if (id < NUM_DEFAULT_SONGS) {
      JsonDocument docDel;
      if (LittleFS.exists("/deleted_defaults.json")) {
        File fDel = LittleFS.open("/deleted_defaults.json", "r");
        if (fDel) {
          deserializeJson(docDel, fDel);
          fDel.close();
        }
      }
      JsonArray arrDel;
      if (docDel.is<JsonArray>()) {
        arrDel = docDel.as<JsonArray>();
      } else {
        arrDel = docDel.to<JsonArray>();
      }
      bool already = false;
      for (JsonVariant v : arrDel) {
        if ((v | -1) == id) { already = true; break; }
      }
      if (!already) arrDel.add(id);
      File fDelW = LittleFS.open("/deleted_defaults.json", "w");
      if (fDelW) {
        serializeJson(docDel, fDelW);
        fDelW.close();
      }
    } else {
      String path = "/song_" + String(id) + ".bin";
      if (LittleFS.exists(path)) LittleFS.remove(path);
    }

    int foundIdx = -1;
    for (int i = 0; i < totalSongs; i++) {
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

    sendAck(num, true, "Lagu berhasil dihapus");
    sendSongList();

  } else if (strcmp(cmd, "reset_defaults") == 0) {
    if (LittleFS.exists("/deleted_defaults.json")) {
      LittleFS.remove("/deleted_defaults.json");
    }
    loadSongMetadata();
    sendAck(num, true, "Semua lagu bawaan dipulihkan");
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
