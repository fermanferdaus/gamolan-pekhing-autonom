#pragma once
#include <Arduino.h>

constexpr byte DIAM = 0;
constexpr byte DO = 1;
constexpr byte RE = 2;
constexpr byte MI = 3;
constexpr byte FA = 4;
constexpr byte SOL = 5;
constexpr byte LA = 6;
constexpr byte SI = 7;
constexpr byte DO_T = 8;

constexpr int jumlahRelay = 8;
constexpr int PULSE_MS = 40;
constexpr int JEDA_MIN_MS = 25;

constexpr int MAX_SONGS = 50;
constexpr int MAX_NOTES = 512;
constexpr int MAX_CUSTOM_NOTES = 255;
constexpr int NUM_DEFAULT_SONGS = 20;
constexpr int WS_PORT = 81;

extern const int relayPins[8];
extern const char* const namaNada[9];
extern const char* const AP_SSID;
extern const char* const AP_PASS;

// nada: nibble bawah = stik kanan (melodi), nibble atas = stik kiri (ketukan). 0 = diam.
struct Nada {
  byte nada;
  byte panjang;
};

constexpr byte duo(byte kanan, byte kiri) {
  return kanan | (kiri << 4);
}
constexpr byte stikKanan(byte nada) {
  return nada & 0x0F;
}
constexpr byte stikKiri(byte nada) {
  return nada >> 4;
}

struct SongHeader {
  int id;
  String name;
  String category;
  int tempo;
  int noteCount;
};

constexpr int PREVIEW_SONG_ID = -99;

enum PlaybackCmdType { CMD_NONE, CMD_PLAY, CMD_STOP, CMD_HIT, CMD_PREVIEW };

struct PlaybackCommand {
  PlaybackCmdType type;
  int songId;
  byte nada;
};
