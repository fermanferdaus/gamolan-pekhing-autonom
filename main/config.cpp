#include "config.h"

const int relayPins[8] = { 26, 25, 19, 18, 17, 16, 14, 13 };
const int jumlahRelay = 8;

const byte DIAM = 0;
const byte DO = 1;
const byte RE = 2;
const byte MI = 3;
const byte FA = 4;
const byte SOL = 5;
const byte LA = 6;
const byte SI = 7;
const byte DO_T = 8;

const char* const namaNada[9] = { "-", "do", "re", "mi", "fa", "sol", "la", "si", "do'" };

const char* const AP_SSID = "GamolanPekhing";
const char* const AP_PASS = "";
const int WS_PORT = 81;

const int PULSE_MS = 40;
const int JEDA_MIN_MS = 25;

const int MAX_SONGS = 50;
const int MAX_NOTES = 256;
const int NUM_DEFAULT_SONGS = 20;
