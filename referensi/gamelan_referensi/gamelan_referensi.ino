// Angklung relay: Indonesia Raya (reff)
// Relay 1-8 = do re mi fa sol la si do'
// Urutan pin udah dibenerin: relay 1 (do) di GPIO 26 ... relay 8 (do') di GPIO 13
const int relayPins[8] = {
  26, 25, 19, 18, 17, 16, 14, 13
};

const int jumlahRelay = 8;

// Nomor nada = nomor relay (kayak not angka: 1 = do ... 8 = do tinggi), 0 = diam
const byte DIAM = 0;
const byte DO = 1;
const byte RE = 2;
const byte MI = 3;
const byte FA = 4;
const byte SOL = 5;
const byte LA = 6;
const byte SI = 7;
const byte DO_T = 8;  // do tinggi

const char* namaNada[] = { "-", "do", "re", "mi", "fa", "sol", "la", "si", "do'" };

const int tempo = 120;       // ketukan per menit
const int panjangMaks = 4;   // nada yang lebih panjang dari ini dipotong (4 = 1 ketuk),
                             // soalnya angklung nggak bisa nahan nada panjang
const int jedaNada = 40;     // ms relay mati di antara dua nada, biar nada yang sama kepukul ulang
const int lamaNyala = 0;     // ms relay ditahan nyala. 0 = sepanjang nada.
const int jedaUlang = 3000;  // ms diam sebelum lagu diulang

struct Nada {
  byte nada;     // DO..DO_T, atau DIAM
  byte panjang;  // 4 = 1 ketuk, 3 = 3/4 ketuk, 2 = 1/2 ketuk, 1 = 1/4 ketuk
};

// Reff Indonesia Raya. Aslinya do = G, jadi pas masuk di do sampai la.
const Nada laguIndonesiaRaya[] = {
  // In-do-ne-sia Ra-ya,
  { DO, 3 },
  { DO, 1 },
  { FA, 4 },
  { LA, 3 },
  { LA, 1 },
  { LA, 4 },
  // mer-de-ka! Mer-de-ka!
  { LA, 3 },
  { LA, 1 },
  { SOL, 4 },
  { MI, 3 },
  { MI, 1 },
  { MI, 4 },
  // Ta-nah-ku, ne-ge-ri-ku
  { SOL, 3 },
  { SOL, 1 },
  { FA, 4 },
  { RE, 3 },
  { RE, 1 },
  { RE, 4 },
  // yang ku-cin-ta
  { SOL, 3 },
  { FA, 1 },
  { MI, 8 },
  { DO, 2 },
  { DIAM, 2 },
  // In-do-ne-sia Ra-ya,
  { DO, 3 },
  { DO, 1 },
  { FA, 4 },
  { LA, 3 },
  { LA, 1 },
  { LA, 4 },
  // mer-de-ka! Mer-de-ka!
  { LA, 3 },
  { LA, 1 },
  { SOL, 4 },
  { MI, 3 },
  { MI, 1 },
  { MI, 4 },
  // Hi-dup-lah In-do-ne-sia Ra-ya!
  { SOL, 3 },
  { SOL, 1 },
  { SOL, 4 },
  { FA, 3 },
  { MI, 1 },
  { RE, 4 },
  { MI, 3 },
  { RE, 1 },
  { DO, 10 },
  { DIAM, 2 }
};

const int jumlahNada = sizeof(laguIndonesiaRaya) / sizeof(laguIndonesiaRaya[0]);
const int seperempatKetuk = 60000 / tempo / 4;  // ms

void semuaMati() {
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);  // HIGH = relay mati
  }
}

void mainkan(byte nada, int durasi) {
  if (nada == DIAM) {
    delay(durasi);
    return;
  }

  int nyala = durasi - jedaNada;
  if (lamaNyala > 0 && lamaNyala < nyala) {
    nyala = lamaNyala;
  }

  Serial.print("Nada: ");
  Serial.println(namaNada[nada]);

  digitalWrite(relayPins[nada - 1], LOW);  // LOW = relay nyala
  delay(nyala);
  digitalWrite(relayPins[nada - 1], HIGH);
  delay(durasi - nyala);
}

// Do re mi ... do' sekali pas nyala, buat ngecek urutan pin udah bener.
// Hapus pemanggilannya di setup() kalau udah yakin.
void tesTanggaNada() {
  for (byte nada = DO; nada <= DO_T; nada++) {
    mainkan(nada, 300);
  }
}

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();

  delay(1000);
  tesTanggaNada();
  delay(1000);
}

void loop() {
  for (int i = 0; i < jumlahNada; i++) {
    int panjang = min((int)laguIndonesiaRaya[i].panjang, panjangMaks);
    mainkan(laguIndonesiaRaya[i].nada, panjang * seperempatKetuk);
  }

  semuaMati();
  delay(jedaUlang);
}