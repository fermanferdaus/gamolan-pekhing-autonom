#pragma once
#include <Arduino.h>

extern const int relayPins[8];
extern const int jumlahRelay;

extern const byte DIAM;
extern const byte DO;
extern const byte RE;
extern const byte MI;
extern const byte FA;
extern const byte SOL;
extern const byte LA;
extern const byte SI;
extern const byte DO_T;

extern const char* const namaNada[9];

extern const char* const AP_SSID;
extern const char* const AP_PASS;
extern const int WS_PORT;

extern const int PULSE_MS;
extern const int JEDA_MIN_MS;

extern const int MAX_SONGS;
extern const int MAX_NOTES;
extern const int NUM_DEFAULT_SONGS;

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

enum PlaybackCmdType {
  CMD_NONE,
  CMD_PLAY,
  CMD_STOP,
  CMD_HIT
};

struct PlaybackCommand {
  PlaybackCmdType type;
  int songId;
  byte nada;
};
