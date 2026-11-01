// =========================================================================
// TEST SIMULATOR GAMOLAN PEKHING — INDONESIA RAYA (REFF)
// Modifikasi dari referensi asli:
//   - Relay = pulse pendek (pukul), bukan ditahan (gamolan perkusif)
//   - Nada panjang tidak dipotong paksa, biarkan resonansi natural
//   - Tempo disesuaikan agar mars terasa megah
//   - Jeda antar nada proporsional terhadap durasi
//   - Kompatibel simulator (serial [HIT]/[OFF])
// =========================================================================

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

const int tempo = 104;          // BPM — sedikit lebih lambat, mars lebih megah
const int pulseMs = 45;         // ms relay nyala (pukul solenoid), gamolan perkusif
const int jedaMinMs = 30;       // ms jeda minimum antar nada (supaya nada sama bisa kepukul ulang)
const int jedaUlang = 4000;     // ms diam sebelum lagu diulang

struct Nada {
  byte nada;
  byte panjang;   // satuan 1/4 ketuk: 1=1/16, 2=1/8, 3=3/16, 4=1/4, 8=1/2, dst
};

// Reff Indonesia Raya — notasi TIDAK dipotong, biarkan durasi asli
const Nada laguIndonesiaRaya[] = {
  // In-do-ne-sia Ra-ya,
  { DO,  3 },
  { DO,  1 },
  { FA,  4 },
  { LA,  3 },
  { LA,  1 },
  { LA,  4 },
  // mer-de-ka! Mer-de-ka!
  { LA,  3 },
  { LA,  1 },
  { SOL, 4 },
  { MI,  3 },
  { MI,  1 },
  { MI,  4 },
  // Ta-nah-ku, ne-ge-ri-ku
  { SOL, 3 },
  { SOL, 1 },
  { FA,  4 },
  { RE,  3 },
  { RE,  1 },
  { RE,  4 },
  // yang ku-cin-ta
  { SOL, 3 },
  { FA,  1 },
  { MI,  8 },      // nada panjang — 2 ketuk, biarkan resonansi
  { DO,  2 },
  { DIAM, 2 },
  // In-do-ne-sia Ra-ya,
  { DO,  3 },
  { DO,  1 },
  { FA,  4 },
  { LA,  3 },
  { LA,  1 },
  { LA,  4 },
  // mer-de-ka! Mer-de-ka!
  { LA,  3 },
  { LA,  1 },
  { SOL, 4 },
  { MI,  3 },
  { MI,  1 },
  { MI,  4 },
  // Hi-dup-lah In-do-ne-sia Ra-ya!
  { SOL, 3 },
  { SOL, 1 },
  { SOL, 4 },
  { FA,  3 },
  { MI,  1 },
  { RE,  4 },
  { MI,  3 },
  { RE,  1 },
  { DO,  10 },     // nada penutup panjang — 2.5 ketuk, biarkan bergema
  { DIAM, 2 }
};

const int jumlahNada = sizeof(laguIndonesiaRaya) / sizeof(laguIndonesiaRaya[0]);
const int seperempatKetuk = 60000 / tempo / 4;  // ms per 1/4 ketuk

void semuaMati() {
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);
  }
}

void mainkan(byte nada, int durasi) {
  if (nada == DIAM) {
    delay(durasi);
    return;
  }

  // Pulse pendek: pukul lalu lepas, biarkan bilah gamolan beresonansi natural
  int nyala = pulseMs;
  if (nyala > durasi - jedaMinMs) {
    nyala = durasi - jedaMinMs;
    if (nyala < 15) nyala = 15;
  }

  Serial.printf("[HIT] %d %s %d\n", nada, namaNada[nada], nyala);

  digitalWrite(relayPins[nada - 1], LOW);
  delay(nyala);
  digitalWrite(relayPins[nada - 1], HIGH);

  Serial.printf("[OFF] %d\n", nada);

  int sisa = durasi - nyala;
  if (sisa > 0) delay(sisa);
}

void tesTanggaNada() {
  Serial.println("[TEST] Tangga nada DO - DO'");
  for (byte nada = DO; nada <= DO_T; nada++) {
    mainkan(nada, 280);
  }
}

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();

  delay(1000);
  Serial.println("\n=== GAMOLAN PEKHING — TES SIMULATOR ===");
  Serial.printf("[CFG] Tempo: %d BPM, Pulse: %d ms, 1/4 ketuk: %d ms\n", tempo, pulseMs, seperempatKetuk);
  tesTanggaNada();
  delay(1500);
  Serial.println("[PLAY] Indonesia Raya (reff)");
}

void loop() {
  for (int i = 0; i < jumlahNada; i++) {
    int durasi = laguIndonesiaRaya[i].panjang * seperempatKetuk;
    mainkan(laguIndonesiaRaya[i].nada, durasi);
  }

  semuaMati();
  Serial.println("[END] Selesai. Mengulang...");
  delay(jedaUlang);
}
