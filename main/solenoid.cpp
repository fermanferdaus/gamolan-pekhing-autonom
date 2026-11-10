#include "solenoid.h"

static uint16_t activeMask = 0;

static bool isValid(byte nada) {
  return nada >= DO && nada <= DO_T;
}

void solenoidInit() {
  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();
}

void semuaMati() {
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);
    if (activeMask & (1 << (i + 1))) {
      Serial.printf("[OFF] %d\n", i + 1);
    }
  }
  activeMask = 0;
}

void solenoidHit(byte nada, int durasiMs) {
  if (!isValid(nada)) return;
  digitalWrite(relayPins[nada - 1], LOW);
  activeMask |= (1 << nada);
  Serial.printf("[HIT] %d %s %d\n", nada, namaNada[nada], durasiMs);
}

void solenoidRelease(byte nada) {
  if (!isValid(nada)) return;
  digitalWrite(relayPins[nada - 1], HIGH);
  activeMask &= ~(1 << nada);
  Serial.printf("[OFF] %d\n", nada);
}
