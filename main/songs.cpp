#include "songs.h"

// 20 LAGU BAWAAN (PROGMEM)

// --- 1. LAGU NASIONAL ---
const Nada song_0[] PROGMEM = {
  { DO, 3 }, { DO, 1 }, { FA, 4 }, { LA, 3 }, { LA, 1 }, { LA, 4 }, { LA, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 3 }, { MI, 1 }, { MI, 4 }, { SOL, 3 }, { SOL, 1 }, { FA, 4 }, { RE, 3 }, { RE, 1 }, { RE, 4 }, { SOL, 3 }, { FA, 1 }, { MI, 8 }, { DO, 2 }, { DIAM, 2 }, { DO, 3 }, { DO, 1 }, { FA, 4 }, { LA, 3 }, { LA, 1 }, { LA, 4 }, { LA, 3 }, { LA, 1 }, { SOL, 4 }, { MI, 3 }, { MI, 1 }, { MI, 4 }, { SOL, 3 }, { SOL, 1 }, { SOL, 4 }, { FA, 3 }, { MI, 1 }, { RE, 4 }, { MI, 3 }, { RE, 1 }, { DO, 10 }, { DIAM, 2 }
};

// Tanah Airku (Ibu Sud, do=C, 4/4, Andante tempo 80) — transcribed bar-exact dari partitur kanonik
// Dede Suwanda (sahabatkuseni.com) & latihan not angka kanonik. Birama 4/4 = 16 unit.
// Rentang nada gamolan 8 bilah: 1 (DO) sampai 8 (DO_T); nada 1' adalah DO_T (bilah 8),
// nada oktaf tinggi (2', 3', 4') dirender ke bilah solmisasi RE, MI, FA.
// Mencakup 2 bait lengkap (Bait 1 & Bait 2) dengan transisi prima volta di birama 13 dan ending birama 25.
const Nada song_1[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: Intro / pickup "Ta-nah a-" (| 0 0 _0 5_ _3 4_ |)
  { DIAM, 8 },
  { DIAM, 2 },
  { SOL, 2 },
  { MI, 2 },
  { FA, 2 },
  // Birama 2: "-ir - ku ti-dak ku-lu-pa-" (| 5 ._1'_ =3'_2'=1' _7 6_ |)
  { SOL, 6 },
  { DO_T, 2 },
  { MI, 2 },
  { RE, 1 },
  { DO_T, 1 },
  { SI, 2 },
  { LA, 2 },
  // Birama 3: "-kan. Kan ter-ke-" (| 5 . ._5_ _1' 3'_ |)
  { SOL, 10 },
  { SOL, 2 },
  { DO_T, 2 },
  { MI, 2 },
  // Birama 4: "-nang se-la-ma hi-dup-" (| 2' ._1'_ _7 7_ _6 7_ |)
  { RE, 6 },
  { DO_T, 2 },
  { SI, 2 },
  { SI, 2 },
  { LA, 2 },
  { SI, 2 },
  // Birama 5: "-ku. Bi-ar-pun" (| 1' . ._1'_ _1' 7_ |)
  { DO_T, 10 },
  { DO_T, 2 },
  { DO_T, 2 },
  { SI, 2 },
  // Birama 6: "sa-ya per-gi ja-" (| 6 6 ._1'_ _7 6_ |)
  { LA, 4 },
  { LA, 6 },
  { DO_T, 2 },
  { SI, 2 },
  { LA, 2 },
  // Birama 7: "-uh. Ti-dak-kan" (| 5 . ._3_ _4 5_ |)
  { SOL, 10 },
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  // Birama 8: "hi-lang da-ri kal-" (| 7 6 ._2_ _3 4_ |)
  { SI, 4 },
  { LA, 6 },
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  // Birama 9: "-bu. Ta-" (| 3 . . ._5_ |)
  { MI, 14 },
  { SOL, 2 },
  // Birama 10: "-nah-ku yang ku-" (| 1' ._7_ 6 ._6_ |)
  { DO_T, 6 },
  { SI, 2 },
  { LA, 6 },
  { LA, 2 },
  // Birama 11: "-cin-ta-i, Eng-" (| 2' ._3'_ 4' 6 |)
  { RE, 6 },
  { MI, 2 },
  { FA, 4 },
  { LA, 4 },
  // Birama 12: "-kau ku-har-ga-" (| 5 1' 7 2' |)
  { SOL, 4 },
  { DO_T, 4 },
  { SI, 4 },
  { RE, 4 },
  // Birama 13: Prima Volta / transisi: "-i. Wa-lau-pun ba-" (| 1' . _0 5_ _3 4_ |)
  { DO_T, 8 },
  { DIAM, 2 },
  { SOL, 2 },
  { MI, 2 },
  { FA, 2 },

  // --- BAIT 2 ---
  // Birama 14: "-nyak ne-ge-ri ku-ja-la-" (| 5 ._1'_ =3'_2'=1' _7 6_ |)
  { SOL, 6 },
  { DO_T, 2 },
  { MI, 2 },
  { RE, 1 },
  { DO_T, 1 },
  { SI, 2 },
  { LA, 2 },
  // Birama 15: "-ni. Yang mas-yhur per-" (| 5 . ._5_ _1' 3'_ |)
  { SOL, 10 },
  { SOL, 2 },
  { DO_T, 2 },
  { MI, 2 },
  // Birama 16: "-mai di-ka-ta o-" (| 2' ._1'_ _7 7_ _6 7_ |)
  { RE, 6 },
  { DO_T, 2 },
  { SI, 2 },
  { SI, 2 },
  { LA, 2 },
  { SI, 2 },
  // Birama 17: "-rang. Te-ta-pi" (| 1' . ._1'_ _1' 7_ |)
  { DO_T, 10 },
  { DO_T, 2 },
  { DO_T, 2 },
  { SI, 2 },
  // Birama 18: "kam-pung dan ru-mah-ku" (| 6 6 ._1'_ _7 6_ |)
  { LA, 4 },
  { LA, 6 },
  { DO_T, 2 },
  { SI, 2 },
  { LA, 2 },
  // Birama 19: "Di-sa-na-lah ku" (| 5 . ._3_ _4 5_ |)
  { SOL, 10 },
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  // Birama 20: "ra-sa se-" (| 7 6 ._2_ _3 4_ |)
  { SI, 4 },
  { LA, 6 },
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  // Birama 21: "-nang. Ta-" (| 3 . . ._5_ |)
  { MI, 14 },
  { SOL, 2 },
  // Birama 22: "-nah-ku tak ku-" (| 1' ._7_ 6 ._6_ |)
  { DO_T, 6 },
  { SI, 2 },
  { LA, 6 },
  { LA, 2 },
  // Birama 23: "-lu-pa-kan, Eng-" (| 2' ._3'_ 4' 6 |)
  { RE, 6 },
  { MI, 2 },
  { FA, 4 },
  { LA, 4 },
  // Birama 24: "-kau ku-bang-ga-kan" (| 5 1' 7 2' |)
  { SOL, 4 },
  { DO_T, 4 },
  { SI, 4 },
  { RE, 4 },
  // Birama 25: Seconda Volta / akhir "-kan" (| 1' . . 0 ||)
  { DO_T, 12 },
  { DIAM, 4 }
};

const Nada song_2[] PROGMEM = {
  // Birama 1: "Pa-da-mu ne-g'ri" (5_ 1 . 6_ 5_ 3_ 0)
  { SOL, 4 },
  { DO_T, 3 },
  { LA, 1 },
  { SOL, 4 },
  { MI, 2 },
  { DIAM, 2 },
  // Birama 2: "ka-mi ber-jan-ji" (5_ . 5_ 1 . 2 3 -)
  { SOL, 3 },
  { SOL, 1 },
  { DO, 3 },
  { RE, 1 },
  { MI, 8 },
  // Birama 3: "Pa-da-mu ne-g'ri" (4 5 . 5 3 1 0)
  { FA, 4 },
  { SOL, 3 },
  { SOL, 1 },
  { MI, 4 },
  { DO, 2 },
  { DIAM, 2 },
  // Birama 4: "ka-mi ber-bak-ti" (1 . 1 2 . 3 2 -)
  { DO, 3 },
  { DO, 1 },
  { RE, 3 },
  { MI, 1 },
  { RE, 8 },
  // Birama 5: "Pa-da-mu ne-g'ri"
  { SOL, 4 },
  { DO_T, 3 },
  { LA, 1 },
  { SOL, 4 },
  { MI, 2 },
  { DIAM, 2 },
  // Birama 6: "ka-mi me-ngab-di"
  { SOL, 3 },
  { SOL, 1 },
  { DO, 3 },
  { RE, 1 },
  { MI, 8 },
  // Birama 7: "ba-gi-mu ne-g'ri" (4 5 . 5 3 1 0)
  { FA, 4 },
  { SOL, 3 },
  { SOL, 1 },
  { MI, 4 },
  { DO, 2 },
  { DIAM, 2 },
  // Birama 8: "ji-wa-ra-ga-ka-mi"; triplet 2-3-4 dikuantisasi 1-2-1 (asli 1.33)
  { RE, 1 },
  { MI, 2 },
  { FA, 1 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 }
};

const Nada song_3[] PROGMEM = {
  // Pickup (Beat 4): "Ga-ru" (5_ . 5_)
  { DO, 3 },
  { DO, 1 },
  // Bar 1: "da Pan-ca-si" (1 1 2 2)
  { DO, 4 },
  { DO, 4 },
  { RE, 4 },
  { RE, 4 },
  // Bar 2: "la - a-" (3 . 0 3 . 4)
  { MI, 8 },
  { DIAM, 4 },
  { MI, 3 },
  { FA, 1 },
  // Bar 3: "ku-lah pen-du-kung" (5 1 . 2 3 4)
  { SOL, 4 },
  { DO, 3 },
  { RE, 1 },
  { MI, 4 },
  { FA, 4 },
  // Bar 4: "mu - Pa-tri-" (2 . 0 5_ . 5_)
  { RE, 8 },
  { DIAM, 4 },
  { DO, 3 },
  { DO, 1 },
  // Bar 5: "ot prok-la-ma" (2 2 3 3)
  { RE, 4 },
  { RE, 4 },
  { MI, 4 },
  { MI, 4 },
  // Bar 6: "si - se-di-" (4 . 0 3 . 2)
  { FA, 8 },
  { DIAM, 4 },
  { MI, 3 },
  { RE, 1 },
  // Bar 7: "a ber-kor-ban un-tuk" (1 5_ . 5_ 5_ 6_ . 7_)
  { DO, 4 },
  { SOL, 3 },
  { SOL, 1 },
  { SOL, 4 },
  { LA, 3 },
  { SI, 1 },
  // Bar 8: "mu - Pan-ca" (1' . 0 1 . 1)
  { DO_T, 8 },
  { DIAM, 4 },
  { DO, 3 },
  { DO, 1 },
  // Bar 9: "si-la da-sar ne-ga" (1 . 6_ . 1 4 5 . 6)
  { DO, 4 },
  { DO, 3 },
  { DO, 1 },
  { FA, 4 },
  { SOL, 3 },
  { LA, 1 },
  // Bar 10: "ra - Rak-yat" (5 . 0 1 . 1)
  { SOL, 8 },
  { DIAM, 4 },
  { DO, 3 },
  { DO, 1 },
  // Bar 11: "a-dil mak-mur sen-to" (1 6_ . 1 4 5 . 6)
  { DO, 4 },
  { DO, 3 },
  { DO, 1 },
  { FA, 4 },
  { SOL, 3 },
  { LA, 1 },
  // Bar 12: "sa - Pri-" (5 . 0 5)
  { SOL, 8 },
  { DIAM, 4 },
  { SOL, 4 },
  // Bar 13: "ba-di bang-sa" (6 . 5 4 3)
  { LA, 6 },
  { SOL, 2 },
  { FA, 4 },
  { MI, 4 },
  // Bar 14: "ku - a yo-ma" (2 . 0 1 1 . 1)
  { RE, 8 },
  { DIAM, 2 },
  { DO, 2 },
  { DO, 3 },
  { DO, 1 },
  // Bar 15: "ju-ma-ju a-yo-ma" (1 . 6_ 5_ . 1 1 1)
  { DO, 6 },
  { LA, 2 },
  { SOL, 3 },
  { DO, 1 },
  { DO, 2 },
  { DO, 2 },
  // Bar 16: "ju-ma-ju - a" (1 . 2 3 0 1)
  { DO, 6 },
  { RE, 2 },
  { MI, 2 },
  { DIAM, 2 },
  { DO, 4 },
  // Bar 17: "yo-ma-ju-ma" (1 6_ 5_ . 7_)
  { DO, 4 },
  { LA, 4 },
  { SOL, 6 },
  { SI, 2 },
  // Bar 18: "ju!" (1 . . 0)
  { DO, 12 },
  { DIAM, 4 }
};

const Nada song_4[] PROGMEM = {
  // Bar 1: "I-bu ki-ta" (1 . 2 3 4)
  { DO, 6 },
  { RE, 2 },
  { MI, 4 },
  { FA, 4 },
  // Bar 2: "Kar-ti-ni" (5 . 3 1)
  { SOL, 8 },
  { MI, 4 },
  { DO, 4 },
  // Bar 3: "pu-tri se-ja-" (6 . 1' 7 6)
  { LA, 6 },
  { DO_T, 2 },
  { SI, 4 },
  { LA, 4 },
  // Bar 4: "-ti" (5)
  { SOL, 12 },
  { DIAM, 4 },
  // Bar 5: "Pu-tri In-do-" (4 . 6 5 4)
  { FA, 6 },
  { LA, 2 },
  { SOL, 4 },
  { FA, 4 },
  // Bar 6: "-ne-sia" (3 . 1 .)
  { MI, 8 },
  { DO, 8 },
  // Bar 7: "ha-rum na-ma-" (2 . 4 3 2)
  { RE, 6 },
  { FA, 2 },
  { MI, 4 },
  { RE, 4 },
  // Bar 8: "-nya" (1)
  { DO, 12 },
  { DIAM, 4 },

  // Bar 9: "Wa-hai I-bu" (4 . 3 4 6)
  { FA, 6 },
  { MI, 2 },
  { FA, 4 },
  { LA, 4 },
  // Bar 10: "ki-ta Kar-ti-ni, Pu-" (5 6 5 3 1 3)
  { SOL, 2 },
  { LA, 2 },
  { SOL, 2 },
  { MI, 2 },
  { DO, 4 },
  { MI, 4 },
  // Bar 11: "-tri yang mu-li-" (2 3 4 5)
  { RE, 4 },
  { MI, 4 },
  { FA, 4 },
  { SOL, 4 },
  // Bar 12: "-a" (3)
  { MI, 12 },
  { DIAM, 4 },
  // Bar 13: "Sung-guh be-sar" (4 . 3 4 6)
  { FA, 6 },
  { MI, 2 },
  { FA, 4 },
  { LA, 4 },
  // Bar 14: "ci-ta-ci-ta-nya, ba-" (5 6 5 3 1 3)
  { SOL, 2 },
  { LA, 2 },
  { SOL, 2 },
  { MI, 2 },
  { DO, 4 },
  { MI, 4 },
  // Bar 15: "-gi In-do-ne-" (2 4 3 2)
  { RE, 4 },
  { FA, 4 },
  { MI, 4 },
  { RE, 4 },
  // Bar 16: "-sia" (1)
  { DO, 12 },
  { DIAM, 4 }
};

// --- 2. LAGU DAERAH ---
// Anak Kambing Saya (Nusa Tenggara Timur, 4/4 / 2/4, Allegro tempo 112) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 5̣ (SOL rendah) dipetakan ke SOL (5), 6̣ (LA rendah) ke LA (6), 7̣ (SI rendah) ke SI (7).
// Birama 4/4 = 16 unit per birama (1=1/16, 2=1/8, 4=1/4, 6=3/8, 8=1/2, 16=1 bar utuh).
const Nada song_5[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: "Ma-na di-ma-na an-" (| 1_ 1_ 1_ 1_ 1 ._ 7̣_ |)
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { DO, 6 },
  { SI, 2 },
  // Birama 2: "-ak kam-bing sa-ya a-" (| 6̣_ 1_ 7̣_ 6̣_ 5̣ ._ 5̣_ |)
  { LA, 2 },
  { DO, 2 },
  { SI, 2 },
  { LA, 2 },
  { SOL, 6 },
  { SOL, 2 },
  // Birama 3: "-nak kam-bing tu-an a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 4 },
  { DO, 2 },
  { RE, 2 },
  // Birama 4: "di po-hon wa-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 },

  // --- BAIT 2 ---
  // Birama 5: "Ma-na di-ma-na jan-" (| 1_ 1_ 1_ 1_ 1 ._ 7̣_ |)
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { DO, 6 },
  { SI, 2 },
  // Birama 6: "-tung ha-ti sa-ya jan-" (| 6̣_ 1_ 7̣_ 6̣_ 5̣ ._ 5̣_ |)
  { LA, 2 },
  { DO, 2 },
  { SI, 2 },
  { LA, 2 },
  { SOL, 6 },
  { SOL, 2 },
  // Birama 7: "-tung ha-ti tu-an a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 4 },
  { DO, 2 },
  { RE, 2 },
  // Birama 8: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 },

  // --- REFF / CHORUS 1 ---
  // Birama 9: "Ca-ca ma-ri-ca he-hei" (| 4_ 4_ 4_ 4_ 4_ 6_ 6 |)
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { LA, 2 },
  { LA, 4 },
  // Birama 10: "Ca-ca ma-ri-ca he-hei" (| 3_ 3_ 3_ 3_ 3_ 5_ 5 |)
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { SOL, 2 },
  { SOL, 4 },
  // Birama 11: "Ca-ca ma-ri-ca a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 4 },
  { DO, 2 },
  { RE, 2 },
  // Birama 12: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 },

  // --- REFF / CHORUS 2 ---
  // Birama 13: "Ca-ca ma-ri-ca he-hei" (| 4_ 4_ 4_ 4_ 4_ 6_ 6 |)
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { LA, 2 },
  { LA, 4 },
  // Birama 14: "Ca-ca ma-ri-ca he-hei" (| 3_ 3_ 3_ 3_ 3_ 5_ 5 |)
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { SOL, 2 },
  { SOL, 4 },
  // Birama 15: "Ca-ca ma-ri-ca a-da" (| 2_ 2_ 2_ 2_ 2 1_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { RE, 4 },
  { DO, 2 },
  { RE, 2 },
  // Birama 16: "di kam-pung ba-ru" (| 3_ 4_ 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 }
};

// Cublak-Cublak Suweng (Jawa Timur - Sunan Giri, 4/4, Allegro tempo 140) — ditransposisi +5 semitone (Sol rendah = Bilah 1)
// agar kontur melodi 5̣ dan 6̣ (Pak Em-pong) turun alami ke bilah 1 & 2 tanpa melompat ke oktaf atas.
// Pemetaan 8 bilah: 5̣->1(DO), 6̣->2(RE), 1->4(FA), 2->5(SOL), 3->6(LA), 5->8(DO_T). Semua interval identik 100%.
// Birama 4/4 = 16 unit per birama (4=1/4 ketuk, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_6[] PROGMEM = {
  // Bar 0: Intro / pickup "Cub" (| 0 0 0 3 | -> 0 0 0 6)
  { DIAM, 12 },
  { LA, 4 },
  // Bar 1: "lak cub lak su" (| 5 5 2 3 | -> 8 8 5 6)
  { DO_T, 4 },
  { DO_T, 4 },
  { SOL, 4 },
  { LA, 4 },
  // Bar 2: "weng su weng e" (| 1 0 2 3 | -> 4 0 5 6)
  { FA, 4 },
  { DIAM, 4 },
  { SOL, 4 },
  { LA, 4 },
  // Bar 3: "teng ge len" (| 2 5 3 2 | -> 5 8 6 5)
  { SOL, 4 },
  { DO_T, 4 },
  { LA, 4 },
  { SOL, 4 },
  // Bar 4: "ter Mam bu ke" (| 1 0 2 3 | -> 4 0 5 6)
  { FA, 4 },
  { DIAM, 4 },
  { SOL, 4 },
  { LA, 4 },
  // Bar 5: "thu dung gu" (| 2 5 3 2 | -> 5 8 6 5)
  { SOL, 4 },
  { DO_T, 4 },
  { LA, 4 },
  { SOL, 4 },
  // Bar 6: "del Pak Em" (| 1 0 1 5̣ | -> 4 0 4 1)
  { FA, 4 },
  { DIAM, 4 },
  { FA, 4 },
  { DO, 4 },
  // Bar 7: "pong le ra le" (| 6̣ 1 2 3 | -> 2 4 5 6)
  { RE, 4 },
  { FA, 4 },
  { SOL, 4 },
  { LA, 4 },
  // Bar 8: "le So po nggu" (| 1 1 1 5̣ | -> 4 4 4 1)
  { FA, 4 },
  { FA, 4 },
  { FA, 4 },
  { DO, 4 },
  // Bar 9: "yu nde lik a" (| 6̣ 1 2 3 | -> 2 4 5 6)
  { RE, 4 },
  { FA, 4 },
  { SOL, 4 },
  { LA, 4 },
  // Bar 10: "ke sir sir" (| 1 5 . 5 | -> 4 8 . 8)
  { FA, 4 },
  { DO_T, 8 },
  { DO_T, 4 },
  // Bar 11: "pong de le ko" (| 3 2 1 2 | -> 6 5 4 5)
  { LA, 4 },
  { SOL, 4 },
  { FA, 4 },
  { SOL, 4 },
  // Bar 12: "pong sir sir" (| 3 5 . 5 | -> 6 8 . 8)
  { LA, 4 },
  { DO_T, 8 },
  { DO_T, 4 },
  // Bar 13: "pong de le ko" (| 3 2 1 2 | -> 6 5 4 5)
  { LA, 4 },
  { SOL, 4 },
  { FA, 4 },
  { SOL, 4 },
  // Bar 14: Ending "pong" (| 3 . . 0 | -> 6 . . 0)
  { LA, 12 },
  { DIAM, 4 }
};

// Gundhul Pacul (Jawa Tengah, 4/4, Moderato tempo 112) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 1' adalah DO_T (bilah 8); bagian "gembelengan" menggunakan 8 7 (DO_T SI).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 6=3/8, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_7[] PROGMEM = {
  // Birama 1: Intro / pickup "Gundhul" (| 0 0 0 1 |)
  { DIAM, 12 },
  { DO, 4 },
  // Birama 2: "-gudhul pa-cul-" (| 3 ._1_ 3 4 |)
  { MI, 6 },
  { DO, 2 },
  { MI, 4 },
  { FA, 4 },
  // Birama 3: "cul gem-" (| 5 5 0 7 |)
  { SOL, 4 },
  { SOL, 4 },
  { DIAM, 4 },
  { SI, 4 },
  // Birama 4: "-be-leng-an," (| 1' 7 1' 7 | -> 8 7 8 7)
  { DO_T, 4 },
  { SI, 4 },
  { DO_T, 4 },
  { SI, 4 },
  // Birama 5: "Nyung-" (| 5 . 0 1 |)
  { SOL, 8 },
  { DIAM, 4 },
  { DO, 4 },

  // Birama 6: "-nyunggi wa-kul-" (| 3 ._1_ 3 4 |)
  { MI, 6 },
  { DO, 2 },
  { MI, 4 },
  { FA, 4 },
  // Birama 7: "kul gem-" (| 5 5 0 7 |)
  { SOL, 4 },
  { SOL, 4 },
  { DIAM, 4 },
  { SI, 4 },
  // Birama 8: "-be-leng-an," (| 1' 7 1' 7 | -> 8 7 8 7)
  { DO_T, 4 },
  { SI, 4 },
  { DO_T, 4 },
  { SI, 4 },
  // Birama 9: "Wa-" (| 5 . 1 . |)
  { SOL, 8 },
  { DO, 8 },

  // Birama 10: "kul ngglim-" (| 3 . 5 . |)
  { MI, 8 },
  { SOL, 8 },
  // Birama 11: "pang se-ga-ne" (| 4 4 5 4 |)
  { FA, 4 },
  { FA, 4 },
  { SOL, 4 },
  { FA, 4 },
  // Birama 12: "da-di sak la-" (| 3 1 4 3 |)
  { MI, 4 },
  { DO, 4 },
  { FA, 4 },
  { MI, 4 },
  // Birama 13: "tar, Wa-" (| 1 . 0 1 |)
  { DO, 8 },
  { DIAM, 4 },
  { DO, 4 },

  // Birama 14: "kul ngglim-" (| 3 . 5 . |)
  { MI, 8 },
  { SOL, 8 },
  // Birama 15: "pang se-ga-ne" (| 4 4 5 4 |)
  { FA, 4 },
  { FA, 4 },
  { SOL, 4 },
  { FA, 4 },
  // Birama 16: "da-di sak la-" (| 3 1 4 3 |)
  { MI, 4 },
  { DO, 4 },
  { FA, 4 },
  { MI, 4 },
  // Birama 17: Ending "tar" (| 1 . . . ||)
  { DO, 12 },
  { DIAM, 4 }
};

// Apuse (Papua, 4/4, Moderato tempo 96) — transcribed bar-exact dari partitur kanonik.
// Not angka: 1' dirender ke DO_T (bilah 8), 2' ke RE (bilah 2), 4/ (fi) ke FA (bilah 4).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 8=1/2, 16=1 bar utuh).
const Nada song_8[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: "A-pu-se" (| 2 5 7 . |)
  { RE, 4 },
  { SOL, 4 },
  { SI, 8 },
  // Birama 2: "ko-kon-da-o" (| _6 7_ 6 5 . |)
  { LA, 2 },
  { SI, 2 },
  { LA, 4 },
  { SOL, 8 },
  // Birama 3: "ya-ra-be" (| 2 5 7 . |)
  { RE, 4 },
  { SOL, 4 },
  { SI, 8 },
  // Birama 4: "so-ren do-re-ri" (| _7 6_ _7 1'_ 6 . |)
  { SI, 2 },
  { LA, 2 },
  { SI, 2 },
  { DO_T, 2 },
  { LA, 8 },
  // Birama 5: "Wuf-len-so" (| 2 4/ 6 . |)
  { RE, 4 },
  { FA, 4 },
  { LA, 8 },
  // Birama 6: "ba-ni-ne-ma" (| 1' _2' 1'_ 7 . |)
  { DO_T, 4 },
  { RE, 2 },
  { DO_T, 2 },
  { SI, 8 },
  // Birama 7: "ba-ki-pa-se" (| _6 7_ 6 5 . |)
  { LA, 2 },
  { SI, 2 },
  { LA, 4 },
  { SOL, 8 },

  // --- BAIT 2 ---
  // Birama 8: "A-pu-se" (| 2 5 7 . |)
  { RE, 4 },
  { SOL, 4 },
  { SI, 8 },
  // Birama 9: "ko-kon-da-o" (| _6 7_ 6 5 . |)
  { LA, 2 },
  { SI, 2 },
  { LA, 4 },
  { SOL, 8 },
  // Birama 10: "ya-ra-be" (| 2 5 7 . |)
  { RE, 4 },
  { SOL, 4 },
  { SI, 8 },
  // Birama 11: "so-ren do-re-ri" (| _7 6_ _7 1'_ 6 . |)
  { SI, 2 },
  { LA, 2 },
  { SI, 2 },
  { DO_T, 2 },
  { LA, 8 },
  // Birama 12: "Wuf-len-so" (| 2 4/ 6 . |)
  { RE, 4 },
  { FA, 4 },
  { LA, 8 },
  // Birama 13: "ba-ni-ne-ma" (| 1' _2' 1'_ 7 . |)
  { DO_T, 4 },
  { RE, 2 },
  { DO_T, 2 },
  { SI, 8 },
  // Birama 14: "ba-ki-pa-se" (| _6 7_ 6 5 . |)
  { LA, 2 },
  { SI, 2 },
  { LA, 4 },
  { SOL, 8 },

  // Birama 15: Akhir / rest
  { DIAM, 16 }
};

// Suwe Ora Jamu (Jawa Tengah, 4/4, Moderato tempo 104) — transcribed bar-exact dari partitur kanonik.
// Not angka: nada 1' adalah DO_T (bilah 8); ornamen (3 4) pada "Su-" disederhanakan ke 4 (FA).
// Birama 4/4 = 16 unit (1=1/16, 2=1/8, 4=1/4, 6=3/8, 12=3/4, 16=1 bar utuh).
const Nada song_9[] PROGMEM = {
  // --- BAIT 1 ---
  // Birama 1: Intro / pickup "Su-" (| 0 0 0 4 |)
  { DIAM, 12 },
  { FA, 4 },
  // Birama 2: "-we o-ra ja-" (| 5 ._5_ 3 4 |)
  { SOL, 6 },
  { SOL, 2 },
  { MI, 4 },
  { FA, 4 },
  // Birama 3: "-mu, Ja-" (| 5 . . 3 |)
  { SOL, 12 },
  { MI, 4 },
  // Birama 4: "-mu go-dhong te-" (| 4 ._4_ 5 3 |)
  { FA, 6 },
  { FA, 2 },
  { SOL, 4 },
  { MI, 4 },
  // Birama 5: "-lo, Su-" (| 4 . . 5 |)
  { FA, 12 },
  { SOL, 4 },
  // Birama 6: "-we o-ra ke-te-" (| 7 ._7_ 1' 1' |)
  { SI, 6 },
  { SI, 2 },
  { DO_T, 4 },
  { DO_T, 4 },
  // Birama 7: "-mu, ke-te-mu" (| 7 ._7_ 6 6 |)
  { SI, 6 },
  { SI, 2 },
  { LA, 4 },
  { LA, 4 },
  // Birama 8: "pi-san ga-we" (| 4 ._4_ 3 3 |)
  { FA, 6 },
  { FA, 2 },
  { MI, 4 },
  { MI, 4 },
  // Birama 9: "ge-lo. Su-" (| 1 . . 4 |)
  { DO, 12 },
  { FA, 4 },

  // --- BAIT 2 ---
  // Birama 10: "-we o-ra ja-" (| 5 ._5_ 3 4 |)
  { SOL, 6 },
  { SOL, 2 },
  { MI, 4 },
  { FA, 4 },
  // Birama 11: "-mu, Ja-mu" (| 5 . . 3 |)
  { SOL, 12 },
  { MI, 4 },
  // Birama 12: "go-dhong te-" (| 4 ._4_ 5 3 |)
  { FA, 6 },
  { FA, 2 },
  { SOL, 4 },
  { MI, 4 },
  // Birama 13: "-lo, Su-" (| 4 . . 5 |)
  { FA, 12 },
  { SOL, 4 },
  // Birama 14: "-we o-ra ke-te-" (| 7 ._7_ 1' 1' |)
  { SI, 6 },
  { SI, 2 },
  { DO_T, 4 },
  { DO_T, 4 },
  // Birama 15: "-mu, ke-te-mu" (| 7 ._7_ 6 6 |)
  { SI, 6 },
  { SI, 2 },
  { LA, 4 },
  { LA, 4 },
  // Birama 16: "pi-san ga-we" (| 4 ._4_ 3 3 |)
  { FA, 6 },
  { FA, 2 },
  { MI, 4 },
  { MI, 4 },
  // Birama 17: Ending "ge-lo." (| 1 . . . ||)
  { DO, 12 },
  { DIAM, 4 }
};

// --- 3. TRADISIONAL LAMPUNG (Gamolan Pekhing Asli) ---

// Tabuh Alau-Alau (Tradisi Gamolan Pekhing Kembahang, Lampung Barat, 4/4, Tempo Rancak 104 BPM)
// Pola tabuhan klasik gamolan bambu dengan ketukan 1/8 (2 unit) berulang (ostinato) dan gendang buka pada bilah 6 (LA).
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 6=3/8). Total 12 birama (84 not).
const Nada song_10[] PROGMEM = {
  // --- BAGIAN A: Buka / Alau-Alau Utama ---
  // Bar 1: [ - - 2 6 6 6 5 6 ] (Gendang buka masuk di 6)
  { DIAM, 4 }, { RE, 2 }, { LA, 2 }, { LA, 2 }, { LA, 2 }, { SOL, 2 }, { LA, 2 },
  // Bar 2: [ - - 6 5 5 3 2 (3) ]
  { DIAM, 4 }, { LA, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { MI, 2 },
  // Bar 3: [ - - 2 6 6 6 5 6 ]
  { DIAM, 4 }, { RE, 2 }, { LA, 2 }, { LA, 2 }, { LA, 2 }, { SOL, 2 }, { LA, 2 },
  // Bar 4: [ - - 6 5 5 3 2 (3) ]
  { DIAM, 4 }, { LA, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { MI, 2 },
  // Bar 5: [ - - 3 5 6 5 3 2 ] (Peralihan melodi bawah)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 },
  // Bar 6: [ - - 2 3 5 3 2 (3) ]
  { DIAM, 4 }, { RE, 2 }, { MI, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { MI, 2 },

  // --- BAGIAN B: Ngigel / Variasi Bilah Atas ---
  // Bar 7: [ - - 3 5 6 1' 6 5 ]
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 2 }, { DO_T, 2 }, { LA, 2 }, { SOL, 2 },
  // Bar 8: [ - - 6 5 3 2 1 (2) ]
  { DIAM, 4 }, { LA, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { DO, 2 }, { RE, 2 },
  // Bar 9: [ - - 3 5 6 1' 6 5 ]
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 2 }, { DO_T, 2 }, { LA, 2 }, { SOL, 2 },
  // Bar 10: [ - - 6 5 3 2 1 (1) ]
  { DIAM, 4 }, { LA, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { DO, 2 }, { DO, 2 },

  // --- BAGIAN C: Penutup Alau-Alau ---
  // Bar 11: [ - - 2 6 6 6 5 6 ]
  { DIAM, 4 }, { RE, 2 }, { LA, 2 }, { LA, 2 }, { LA, 2 }, { SOL, 2 }, { LA, 2 },
  // Bar 12: [ - - 6 5 5 3 2 (3.) ] (Gong penutup)
  { DIAM, 4 }, { LA, 2 }, { SOL, 2 }, { SOL, 2 }, { MI, 2 }, { RE, 2 }, { MI, 6 }
};

// Sang Bumi Ruwa Jurai (Syaiful Anwar, 4/4, Moderato Megah 92 BPM) — transcribed bar-exact dari partitur kanonik.
// Rentang nada: 1 (DO) s.d. 8 (DO_T). Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 8=1/2, 12=3/4). Total 18 birama (73 not).
const Nada song_11[] PROGMEM = {
  // --- BAIT 1 ---
  // Bar 1: "Jak u-jung Da-nau Ra-" (| 0 5_ 6_ 1' 1'_ 7_ |)
  { DIAM, 4 }, { SOL, 2 }, { LA, 2 }, { DO_T, 4 }, { DO_T, 2 }, { SI, 2 },
  // Bar 2: "-nau" (| 6 5 . 0 |)
  { LA, 4 }, { SOL, 8 }, { DIAM, 4 },
  // Bar 3: "Te-li-u mit Way Ka-" (| 0 3_ 5_ 6 5_ 3_ |)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { MI, 2 },
  // Bar 4: "-nan" (| 2 . . 0 |)
  { RE, 12 }, { DIAM, 4 },
  // Bar 5: "Sam-pai pan-tai la-wok ja-" (| 0 3_ 5_ 6 1'_ 7_ |)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 4 }, { DO_T, 2 }, { SI, 2 },
  // Bar 6: "-oh" (| 6 5 . 0 |)
  { LA, 4 }, { SOL, 8 }, { DIAM, 4 },
  // Bar 7: "Pe-si-sir khik Pe-pa-" (| 0 3_ 5_ 6 5_ 3_ |)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { MI, 2 },
  // Bar 8: "-dun" (| 2 . . 0 |)
  { RE, 12 }, { DIAM, 4 },
  // Bar 9: "Ja-di sai di-lom lam-" (| 0 1_ 2_ 3 2_ 1_ |)
  { DIAM, 4 }, { DO, 2 }, { RE, 2 }, { MI, 4 }, { RE, 2 }, { DO, 2 },
  // Bar 10: "-bang" (| 2 1 . 0 |)
  { RE, 4 }, { DO, 8 }, { DIAM, 4 },
  // Bar 11: "Lam-pung sai ka-ya kha-" (| 0 1_ 2_ 3 4_ 3_ |)
  { DIAM, 4 }, { DO, 2 }, { RE, 2 }, { MI, 4 }, { FA, 2 }, { MI, 2 },
  // Bar 12: "-ya" (| 2 . . 0 |)
  { RE, 12 }, { DIAM, 4 },

  // --- REFF ---
  // Bar 13: "Lam-pung sai..." (| 3 5 6 . |)
  { MI, 4 }, { SOL, 4 }, { LA, 8 },
  // Bar 14: "Sang bu-mi ru-wa ju-" (| 0 5_ 3_ 2 3_ 5_ |)
  { DIAM, 4 }, { SOL, 2 }, { MI, 2 }, { RE, 4 }, { MI, 2 }, { SOL, 2 },
  // Bar 15: "-rai" (| 6 . . 0 |)
  { LA, 12 }, { DIAM, 4 },
  // Bar 16: "Lam-pung sai..." (| 3 5 6 . |)
  { MI, 4 }, { SOL, 4 }, { LA, 8 },
  // Bar 17: "Sang bu-mi ru-wa ju-" (| 0 5_ 3_ 2 3_ 2_ |)
  { DIAM, 4 }, { SOL, 2 }, { MI, 2 }, { RE, 4 }, { MI, 2 }, { RE, 2 },
  // Bar 18: "-rai" (| 1 . . 0 |)
  { DO, 12 }, { DIAM, 4 }
};

// Tanoh Lado (Fath Syahbudin, 4/4, Andante 88 BPM) — transcribed bar-exact dari partitur kanonik.
// Rentang nada: 1 (DO) s.d. 7 (SI). Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 6=3/8, 8=1/2, 12=3/4). Total 15 birama (72 not).
const Nada song_12[] PROGMEM = {
  // --- BAIT 1 ---
  // Bar 1: Pickup "Jak Ra-" (| 0 0 0 1_ 2_ |)
  { DIAM, 12 }, { DO, 2 }, { RE, 2 },
  // Bar 2: "-nau ti-goh di Te-la-" (| 3 ._ 3_ 3_ 2_ 1_ 2_ |)
  { MI, 6 }, { MI, 2 }, { MI, 2 }, { RE, 2 }, { DO, 2 }, { RE, 2 },
  // Bar 3: "-das, Jak Pa-" (| 3 . 0 4_ 5_ |)
  { MI, 8 }, { DIAM, 4 }, { FA, 2 }, { SOL, 2 },
  // Bar 4: "-las mung-gak mit Beng-ku-" (| 6 ._ 6_ 6_ 5_ 4_ 3_ |)
  { LA, 6 }, { LA, 2 }, { LA, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 2 },
  // Bar 5: "-nat. Gu-nung" (| 4 . 0 2_ 3_ |)
  { FA, 8 }, { DIAM, 4 }, { RE, 2 }, { MI, 2 },
  // Bar 6: "rim-ba ti-uh pu-ma-" (| 4 ._ 4_ 4_ 3_ 2_ 3_ |)
  { FA, 6 }, { FA, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { MI, 2 },
  // Bar 7: "-tang, Pu-lau" (| 2 . 0 1_ 2_ |)
  { RE, 8 }, { DIAM, 4 }, { DO, 2 }, { RE, 2 },
  // Bar 8: "pu-lau di la-wok le-" (| 3 ._ 3_ 2_ 1_ 2_ 3_ |)
  { MI, 6 }, { MI, 2 }, { RE, 2 }, { DO, 2 }, { RE, 2 }, { MI, 2 },
  // Bar 9: "-pas. Me-re-" (| 1 . 0 3_ 5_ |)
  { DO, 8 }, { DIAM, 4 }, { MI, 2 }, { SOL, 2 },

  // --- REFF ---
  // Bar 10: "-gai bu-ai ghik ba-ha-" (| 6 ._ 6_ 6_ 5_ 4_ 5_ |)
  { LA, 6 }, { LA, 2 }, { LA, 2 }, { SOL, 2 }, { FA, 2 }, { SOL, 2 },
  // Bar 11: "-sa, Na-yah" (| 6 3 0 5_ 6_ |)
  { LA, 4 }, { MI, 4 }, { DIAM, 4 }, { SOL, 2 }, { LA, 2 },
  // Bar 12: "si-na tan-da gham ka-" (| 7 ._ 6_ 5_ 4_ 3_ 2_ |)
  { SI, 6 }, { LA, 2 }, { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 },
  // Bar 13: "-ya. Ta-noh" (| 3 . 0 3_ 5_ |)
  { MI, 8 }, { DIAM, 4 }, { MI, 2 }, { SOL, 2 },
  // Bar 14: "Lam-pung-ku ta-noh la-" (| 6 ._ 5_ 4_ 3_ 2_ 3_ |)
  { LA, 6 }, { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { MI, 2 },
  // Bar 15: "-do." (| 1 . . 0 |)
  { DO, 12 }, { DIAM, 4 }
};

// Cangget Agung (Syaiful Anwar, 4/4, Moderato Agung 92 BPM) — transcribed bar-exact dari partitur kanonik.
// Seluruh melodi asli berada pada rentang 1 (DO) s.d. 6 (LA) tanpa penyempitan oktaf.
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 6=3/8, 8=1/2). Total 20 birama (106 not).
const Nada song_13[] PROGMEM = {
  // --- BAIT 1 ---
  // Bar 1: "Se-sat a-gung sai wa-" (| 3 4_ 5_ 6 5_ 4_ |)
  { MI, 4 }, { FA, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { FA, 2 },
  // Bar 2: "-wai" (| 3 2 3 0 |)
  { MI, 4 }, { RE, 4 }, { MI, 4 }, { DIAM, 4 },
  // Bar 3: "Ta-lo bu-ta-buh ta-khi cang-" (| 3 4_ 5_ 6 5_ 4_ |)
  { MI, 4 }, { FA, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { FA, 2 },
  // Bar 4: "-get" (| 3 2 1 0 |)
  { MI, 4 }, { RE, 4 }, { DO, 4 }, { DIAM, 4 },
  // Bar 5: "Ga-wi a-dat ta-no te-goh" (| 1_ 2_ 3_ 4_ 5 6 |)
  { DO, 2 }, { RE, 2 }, { MI, 2 }, { FA, 2 }, { SOL, 4 }, { LA, 4 },
  // Bar 6: "ca-kak pe-pa-dun" (| 5_ 4_ 3_ 2_ 3 ._ 0_ |)
  { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { MI, 6 }, { DIAM, 2 },

  // --- BAIT 2 ---
  // Bar 7: "A-dat bu-da-yo Lam-" (| 3 4_ 5_ 6 5_ 4_ |)
  { MI, 4 }, { FA, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { FA, 2 },
  // Bar 8: "-pung" (| 3 2 3 0 |)
  { MI, 4 }, { RE, 4 }, { MI, 4 }, { DIAM, 4 },
  // Bar 9: "Na-yah te-mon ra-gam wa-" (| 3 4_ 5_ 6 5_ 4_ |)
  { MI, 4 }, { FA, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { FA, 2 },
  // Bar 10: "-wai no" (| 3 2 1 0 |)
  { MI, 4 }, { RE, 4 }, { DO, 4 }, { DIAM, 4 },
  // Bar 11: "Je-pa-na ga-ru-da-no" (| 1_ 2_ 3_ 4_ 5 6 |)
  { DO, 2 }, { RE, 2 }, { MI, 2 }, { FA, 2 }, { SOL, 4 }, { LA, 4 },
  // Bar 12: "gha-ta se-ba-tin" (| 5_ 4_ 3_ 2_ 1 ._ 0_ |)
  { SOL, 2 }, { FA, 2 }, { MI, 2 }, { RE, 2 }, { DO, 6 }, { DIAM, 2 },

  // --- REFF ---
  // Bar 13: "Cang-get a-gung..." (| 5 5_ 6_ 5 3 |)
  { SOL, 4 }, { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 },
  // Bar 14: "Cang-get a-gung..." (| 5 5_ 6_ 5 3 |)
  { SOL, 4 }, { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 },
  // Bar 15: "Mu-li ba-tang-an..." (| 1_ 2_ 3_ 4_ 5 ._ 0_ |)
  { DO, 2 }, { RE, 2 }, { MI, 2 }, { FA, 2 }, { SOL, 6 }, { DIAM, 2 },
  // Bar 16: "Di-lom ku-to-ma-ro..." (| 5 5_ 6_ 5 3 |)
  { SOL, 4 }, { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 },
  // Bar 17: "Me-jeng bu-san-ding..." (| 1_ 2_ 3_ 2_ 1 ._ 0_ |)
  { DO, 2 }, { RE, 2 }, { MI, 2 }, { RE, 2 }, { DO, 6 }, { DIAM, 2 },
  // Bar 18: "La-pah gham ja-mo ja-mo" (| 5 6_ 5_ 4 3_ 2_ |)
  { SOL, 4 }, { LA, 2 }, { SOL, 2 }, { FA, 4 }, { MI, 2 }, { RE, 2 },
  // Bar 19: "Nge-les-ta-ri-ko a-dat" (| 3 1_ 2_ 3 4_ 3_ |)
  { MI, 4 }, { DO, 2 }, { RE, 2 }, { MI, 4 }, { FA, 2 }, { MI, 2 },
  // Bar 20: "Lam-pung." (| 2 1 . 0 |)
  { RE, 4 }, { DO, 8 }, { DIAM, 4 }
};

// Pang Lipang Dang (Lagu Daerah Klasik Lampung, 4/4, Allegro Riang 104 BPM) — transcribed bar-exact dari partitur kanonik.
// Rentang nada: 1 (DO) s.d. 8 (DO_T). Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 8=1/2, 12=3/4). Total 16 birama (80 not).
const Nada song_14[] PROGMEM = {
  // --- REFF / CHORUS UTAMA ---
  // Bar 1: "Pang li-pang dang, pang li-" (| 3 3_ 2_ 1 2_ 3_ |)
  { MI, 4 }, { MI, 2 }, { RE, 2 }, { DO, 4 }, { RE, 2 }, { MI, 2 },
  // Bar 2: "-pang dang ki-li-dang" (| 5 5_ 6_ 5 3 |)
  { SOL, 4 }, { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 },
  // Bar 3: "Pang li-pang dang, sa-kik" (| 5 3_ 5_ 2 1_ 2_ |)
  { SOL, 4 }, { MI, 2 }, { SOL, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Bar 4: "li-pang dang kun-dang" (| 3 1_ 2_ 3_ 2_ 1 |)
  { MI, 4 }, { DO, 2 }, { RE, 2 }, { MI, 2 }, { RE, 2 }, { DO, 4 },
  // Bar 5: "Yu yu pa-yu, yu pa-" (| 3 3_ 2_ 1 2_ 3_ |)
  { MI, 4 }, { MI, 2 }, { RE, 2 }, { DO, 4 }, { RE, 2 }, { MI, 2 },
  // Bar 6: "-yu ku te-khi-ma" (| 5 5_ 6_ 5 3 |)
  { SOL, 4 }, { SOL, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 },
  // Bar 7: "Yu yu pa-yu, yu pa-" (| 5 3_ 5_ 2 1_ 2_ |)
  { SOL, 4 }, { MI, 2 }, { SOL, 2 }, { RE, 4 }, { DO, 2 }, { RE, 2 },
  // Bar 8: "-yu ka-ya di-a" (| 3 2_ 1_ 2 1 |)
  { MI, 4 }, { RE, 2 }, { DO, 2 }, { RE, 4 }, { DO, 4 },

  // --- BAIT 1 ---
  // Bar 9: "A-pi peng-ga-li la-" (| 0 5_ 6_ 1' 1'_ 7_ |)
  { DIAM, 4 }, { SOL, 2 }, { LA, 2 }, { DO_T, 4 }, { DO_T, 2 }, { SI, 2 },
  // Bar 10: "-was" (| 6 5 . 0 |)
  { LA, 4 }, { SOL, 8 }, { DIAM, 4 },
  // Bar 11: "Pa-kai tem-bi-lang be-" (| 0 3_ 5_ 6 5_ 3_ |)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { LA, 4 }, { SOL, 2 }, { MI, 2 },
  // Bar 12: "-si" (| 2 3 . 0 |)
  { RE, 4 }, { MI, 8 }, { DIAM, 4 },
  // Bar 13: "Hai mu-li a-was a-" (| 0 5_ 6_ 1' 1'_ 7_ |)
  { DIAM, 4 }, { SOL, 2 }, { LA, 2 }, { DO_T, 4 }, { DO_T, 2 }, { SI, 2 },
  // Bar 14: "-was" (| 6 5 . 0 |)
  { LA, 4 }, { SOL, 8 }, { DIAM, 4 },
  // Bar 15: "Na-yah ra-gah mem-bu-" (| 0 3_ 5_ 4 3_ 2_ |)
  { DIAM, 4 }, { MI, 2 }, { SOL, 2 }, { FA, 4 }, { MI, 2 }, { RE, 2 },
  // Bar 16: "-di." (| 1 . . 0 |)
  { DO, 12 }, { DIAM, 4 }
};

// --- 4. LAINNYA ---
const Nada song_15[] PROGMEM = {
  { DO, 4 }, { DO, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 8 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 4 }, { RE, 4 }, { DO, 8 }, { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 8 }, { SOL, 4 }, { SOL, 4 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 8 }, { DO, 4 }, { DO, 4 }, { SOL, 4 }, { SOL, 4 }, { LA, 4 }, { LA, 4 }, { SOL, 8 }, { FA, 4 }, { FA, 4 }, { MI, 4 }, { MI, 4 }, { RE, 4 }, { RE, 4 }, { DO, 8 }
};

const Nada song_16[] PROGMEM = {
  { DO, 2 }, { DO, 2 }, { RE, 4 }, { DO, 4 }, { FA, 4 }, { MI, 8 }, { DO, 2 }, { DO, 2 }, { RE, 4 }, { DO, 4 }, { SOL, 4 }, { FA, 8 }, { DO, 2 }, { DO, 2 }, { DO_T, 4 }, { LA, 4 }, { FA, 4 }, { MI, 4 }, { RE, 4 }, { DIAM, 4 }, { LA, 2 }, { LA, 2 }, { SOL, 4 }, { MI, 4 }, { FA, 4 }, { MI, 8 }
};

// Pelangi-Pelangi (A.T. Mahmud, 2/4, Tempo Sedang 80 BPM) — transcribed bar-exact dari partitur kanonik.
// Not angka: |. 0 5 | 3_ 3_ 3_ 3_ | 3 ._ 3_ | 2_ 1_ 7_ 1_ | 2 0_ 5_ | ... (rentang nada 1 s.d. 5).
// Birama 2/4 = 8 unit per birama (2=1/8, 4=1/4, 6=3/8, 8=1/2). Total 17 birama (49 not).
const Nada song_17[] PROGMEM = {
  // Bar 1: Intro / "Pe-" (| . 0 5 |)
  { DIAM, 6 },
  { SOL, 2 },
  // Bar 2: "la-ngi pe-la-" (| 3_ 3_ 3_ 3_ |)
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  // Bar 3: "-ngi a-" (| 3 ._ 3_ |)
  { MI, 6 },
  { MI, 2 },
  // Bar 4: "lang-kah in-dah" (| 2_ 1_ 7_ 1_ | -> 7 disesuaikan ke DO)
  { RE, 2 },
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  // Bar 5: "-mu Me-" (| 2 0_ 5_ |)
  { RE, 4 },
  { DIAM, 2 },
  { SOL, 2 },
  // Bar 6: "rah ku-ning hi-" (| 4_ 4_ 4_ 3_ |)
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { MI, 2 },
  // Bar 7: "-jau Di" (| 2 ._ 4_ |)
  { RE, 6 },
  { FA, 2 },
  // Bar 8: "la-ngit yang bi-" (| 3_ 2_ 1_ 2_ |)
  { MI, 2 },
  { RE, 2 },
  { DO, 2 },
  { RE, 2 },
  // Bar 9: "-ru Pe-" (| 3 ._ 3_ |)
  { MI, 6 },
  { MI, 2 },
  // Bar 10: "lu-kis-mu a-" (| 5_ 5_ 5_ 3_ |)
  { SOL, 2 },
  { SOL, 2 },
  { SOL, 2 },
  { MI, 2 },
  // Bar 11: "-gung Si-" (| 4 ._ 4_ |)
  { FA, 6 },
  { FA, 2 },
  // Bar 12: "a-pa ge-ran-" (| 3_ 3_ 3_ 1_ |)
  { MI, 2 },
  { MI, 2 },
  { MI, 2 },
  { DO, 2 },
  // Bar 13: "-gan Pe-" (| 2 ._ 5_ |)
  { RE, 6 },
  { SOL, 2 },
  // Bar 14: "la-ngi pe-" (| 1 3_ 3_ |)
  { DO, 4 },
  { MI, 2 },
  { MI, 2 },
  // Bar 15: "la-ngi" (| 2 4 |)
  { RE, 4 },
  { FA, 4 },
  // Bar 16: "cip-ta-an Tu-" (| 3_ 3_ 2_ 2_ |)
  { MI, 2 },
  { MI, 2 },
  { RE, 2 },
  { RE, 2 },
  // Bar 17: "-han" (| 1 . |)
  { DO, 8 }
};

// Balonku Ada Lima (A.T. Mahmud / Pak Kasur, 4/4 / 2/4, tempo 68) — transcribed bar-exact dari partitur kanonik.
// Not angka: rentang nada 1 (DO) s.d. 8 (DO_T), mencakup 7 (SI) & 8 (DO_T) saat "DOR" dan "kelabu/tinggal empat".
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 6=3/8, 10=5/8, 16=1 bar utuh).
const Nada song_18[] PROGMEM = {
  // Bar 1: "Ba-lon-ku a-da li-ma" (| 3_ 4_ 5_ 1'_ | 5_ 3_ 5 . |)
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  { DO_T, 2 },
  { SOL, 2 },
  { MI, 2 },
  { SOL, 4 },
  // Bar 2: "Ru-pa-ru-pa war-na-nya" (| 2_ 3_ 4_ 2_ | 5_ 4_ 3 . |)
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  { RE, 2 },
  { SOL, 2 },
  { FA, 2 },
  { MI, 4 },
  // Bar 3: "Hi-jau ku-ning ke-la-bu" (| 1_ 1_ 6_ 6_ | 7_ 1'_ 5 . |)
  { DO, 2 },
  { DO, 2 },
  { LA, 2 },
  { LA, 2 },
  { SI, 2 },
  { DO_T, 2 },
  { SOL, 4 },
  // Bar 4: "Me-rah mu-da dan bi-ru" (| 3_ 4_ 5_ 4_ | 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 4 },
  // Bar 5: "Me-le-tus ba-lon hi-jau" (| 3_ 4_ 5_ 1'_ | 5_ 3_ 5 . |)
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  { DO_T, 2 },
  { SOL, 2 },
  { MI, 2 },
  { SOL, 4 },
  // Bar 6: "DOR!" (| 1' . 0 . |)
  { DO_T, 6 },
  { DIAM, 10 },
  // Bar 7: "Ha-ti-ku sa-ngat ka-cau" (| 2_ 3_ 4_ 2_ | 5_ 4_ 3 . |)
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  { RE, 2 },
  { SOL, 2 },
  { FA, 2 },
  { MI, 4 },
  // Bar 8: "Ba-lon-ku ting-gal em-pat" (| 1_ 1_ 6_ 6_ | 7_ 1'_ 5 . |)
  { DO, 2 },
  { DO, 2 },
  { LA, 2 },
  { LA, 2 },
  { SI, 2 },
  { DO_T, 2 },
  { SOL, 4 },
  // Bar 9: "Ku-pe-gang e-rat-e-rat" (| 3_ 4_ 5_ 4_ | 3_ 2_ 1 . |)
  { MI, 2 },
  { FA, 2 },
  { SOL, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 4 }
};

// Naik Delman (Ibu Sud / Pak Kasur, 4/4 / 2/4, Allegro tempo 120) — transcribed bar-exact dari partitur kanonik.
// Not angka: rentang nada 1 (DO) s.d. 6 (LA), sangat ritmis dan cocok untuk solenoid gamolan pada reff "Tuk-tik-tak".
// Birama 4/4 = 16 unit per birama (2=1/8, 4=1/4, 8=1/2, 12=3/4, 16=1 bar utuh).
const Nada song_19[] PROGMEM = {
  // --- BAIT ---
  // Bar 1: Intro / pickup "Pa-da" (| 0 0 0 5_ 5_ |)
  { DIAM, 12 },
  { SOL, 2 },
  { SOL, 2 },
  // Bar 2: "ha-ri Ming-gu ku tu-rut a-yah ke ko-ta" (| 1_ 1_ 1_ 3_ 5_ 5_ 5_ 3_ |)
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { SOL, 2 },
  { SOL, 2 },
  { MI, 2 },
  // Bar 3: "Na-ik del-man is-ti-me-wa ku du-duk di mu-ka" (| 6_ 6_ 6_ 3_ 5 . 0 5_ |)
  { LA, 2 },
  { LA, 2 },
  { LA, 2 },
  { MI, 2 },
  { SOL, 4 },
  { DIAM, 2 },
  { SOL, 2 },
  // Bar 4: "Na-ik del-man is-ti-me-wa ku du-duk di mu-ka" (| 1_ 1_ 1_ 3_ 5_ 5_ 5_ 3_ |)
  { DO, 2 },
  { DO, 2 },
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { SOL, 2 },
  { SOL, 2 },
  { MI, 2 },
  // Bar 5: "ku du-duk di mu-ka" (| 6_ 6_ 3_ 4_ 2 . 0 5_ |)
  { LA, 2 },
  { LA, 2 },
  { MI, 2 },
  { FA, 2 },
  { RE, 4 },
  { DIAM, 2 },
  { SOL, 2 },
  // Bar 6: "Ku du-duk sam-ping pak ku-sir yang se-dang be-ker-ja" (| 2_ 2_ 2_ 3_ 4_ 4_ 4_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { RE, 2 },
  // Bar 7: "yang se-dang be-ker-ja" (| 5_ 5_ 4_ 3_ 2 . 0 5_ |)
  { SOL, 2 },
  { SOL, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 4 },
  { DIAM, 2 },
  { SOL, 2 },
  // Bar 8: "Me-ngen-da-ra-i ku-da su-pa-ya ba-ik ja-lan-nya" (| 2_ 2_ 2_ 3_ 4_ 4_ 4_ 2_ |)
  { RE, 2 },
  { RE, 2 },
  { RE, 2 },
  { MI, 2 },
  { FA, 2 },
  { FA, 2 },
  { FA, 2 },
  { RE, 2 },
  // Bar 9: "su-pa-ya ba-ik ja-lan-nya" (| 5_ 4_ 3_ 2_ 1 . 0 0 |)
  { SOL, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 4 },
  { DIAM, 4 },

  // --- CHORUS 1 ---
  // Bar 10: "Tuk-tik-tak-tik-tuk tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 1_ 3_ 5_ 3_ |)
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  // Bar 11: "tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 2 . 0 0 |)
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  { RE, 4 },
  { DIAM, 4 },
  // Bar 12: "Tuk-tik-tak-tik-tuk tik-tak" (| 2_ 4_ 6_ 4_ 2_ 4_ 6_ 4_ |)
  { RE, 2 },
  { FA, 2 },
  { LA, 2 },
  { FA, 2 },
  { RE, 2 },
  { FA, 2 },
  { LA, 2 },
  { FA, 2 },
  // Bar 13: "sua-ra se-pa-tu ku-da" (| 2_ 4_ 3_ 2_ 1 . 0 0 |)
  { RE, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 4 },
  { DIAM, 4 },

  // --- CHORUS 2 ---
  // Bar 14: "Tuk-tik-tak-tik-tuk tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 1_ 3_ 5_ 3_ |)
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  // Bar 15: "tik-tak-tik-tuk" (| 1_ 3_ 5_ 3_ 2 . 0 0 |)
  { DO, 2 },
  { MI, 2 },
  { SOL, 2 },
  { MI, 2 },
  { RE, 4 },
  { DIAM, 4 },
  // Bar 16: "Tuk-tik-tak-tik-tuk tik-tak" (| 2_ 4_ 6_ 4_ 2_ 4_ 6_ 4_ |)
  { RE, 2 },
  { FA, 2 },
  { LA, 2 },
  { FA, 2 },
  { RE, 2 },
  { FA, 2 },
  { LA, 2 },
  { FA, 2 },
  // Bar 17: "sua-ra se-pa-tu ku-da" (| 2_ 4_ 3_ 2_ 1 . . 0 |)
  { RE, 2 },
  { FA, 2 },
  { MI, 2 },
  { RE, 2 },
  { DO, 8 }
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
  "Tabuh Alau-Alau", "Sang Bumi Ruwa Jurai", "Tanoh Lado", "Cangget Agung", "Pang Lipang Dang",
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
  104, 92, 88, 92, 104,
  100, 100, 80, 68, 92
};
