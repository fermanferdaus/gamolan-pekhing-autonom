#include "solenoid.h"

static byte activeNada = DIAM;

void solenoidInit() {
  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();
}

void semuaMati() {
  if (activeNada != DIAM) {
    Serial.printf("[OFF] %d\n", activeNada);
    activeNada = DIAM;
  }
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);
  }
}

void solenoidHit(byte nada, int durasiMs) {
  if (nada >= DO && nada <= DO_T) {
    if (activeNada != DIAM && activeNada != nada) {
      solenoidRelease(activeNada);
    }
    activeNada = nada;
    Serial.printf("[HIT] %d %s %d\n", nada, namaNada[nada], durasiMs);
    digitalWrite(relayPins[nada - 1], LOW);
  }
}

void solenoidRelease(byte nada) {
  if (nada >= DO && nada <= DO_T) {
    digitalWrite(relayPins[nada - 1], HIGH);
    Serial.printf("[OFF] %d\n", nada);
    if (activeNada == nada) {
      activeNada = DIAM;
    }
  }
}
