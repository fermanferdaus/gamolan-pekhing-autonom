#include "solenoid.h"

void solenoidInit() {
  for (int i = 0; i < jumlahRelay; i++) {
    pinMode(relayPins[i], OUTPUT);
  }
  semuaMati();
}

void semuaMati() {
  for (int i = 0; i < jumlahRelay; i++) {
    digitalWrite(relayPins[i], HIGH);
  }
}

void solenoidHit(byte nada) {
  if (nada >= DO && nada <= DO_T) {
    digitalWrite(relayPins[nada - 1], LOW);
  }
}

void solenoidRelease(byte nada) {
  if (nada >= DO && nada <= DO_T) {
    digitalWrite(relayPins[nada - 1], HIGH);
  }
}
