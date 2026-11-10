#include <WiFi.h>
#include "config.h"
#include "solenoid.h"
#include "storage.h"
#include "playback.h"
#include "ws_handler.h"

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== Gamolan Pekhing Autonomous ESP32 ===");

  solenoidInit();

  if (!storageInit()) {
    Serial.println("[FS] Gagal inisialisasi LittleFS!");
  } else {
    Serial.println("[FS] LittleFS siap.");
  }
  loadSongMetadata();
  Serial.printf("[FS] Total lagu siap: %d\n", totalSongs);

  playbackInit();

  WiFi.softAP(AP_SSID, AP_PASS);
  Serial.print("[WIFI] Access Point aktif: ");
  Serial.println(AP_SSID);
  Serial.print("[WIFI] IP Address: ");
  Serial.println(WiFi.softAPIP());

  wsInit();
  Serial.println("[WS] WebSocket Server siap di port 81");

  Serial.println("[INIT] Tes tangga nada (1-8)...");
  for (byte n = DO; n <= DO_T; n++) {
    solenoidHit(n, PULSE_MS);
    delay(PULSE_MS);
    solenoidRelease(n);
    delay(200);
  }
  Serial.println("[INIT] Siap digunakan!");
}

void loop() {
  wsLoop();
}
