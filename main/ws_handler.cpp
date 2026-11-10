#include "ws_handler.h"

#include <ArduinoJson.h>
#include <WebSocketsServer.h>
#include <freertos/FreeRTOS.h>
#include <freertos/semphr.h>

#include "playback.h"
#include "storage.h"

static WebSocketsServer webSocket(WS_PORT);
static SemaphoreHandle_t wsMutex = NULL;

static void onPlaybackState(const char* state, int songId) {
  JsonDocument doc;
  doc["t"] = "state";
  doc["state"] = state;
  if (songId >= 0) {
    doc["id"] = songId;
  }
  String out;
  serializeJson(doc, out);
  wsBroadcastStatus(out);
}

static void onPlaybackNote(byte nada, int noteIndex, int totalNotes) {
  JsonDocument doc;
  doc["t"] = "note";
  doc["n"] = stikKanan(nada) ? stikKanan(nada) : stikKiri(nada);
  doc["l"] = stikKiri(nada);
  doc["idx"] = noteIndex;
  doc["total"] = totalNotes;
  String out;
  serializeJson(doc, out);
  wsBroadcastStatus(out);
}

void wsSendAck(uint8_t num, bool ok, const String& msg) {
  JsonDocument doc;
  doc["t"] = "ack";
  doc["ok"] = ok;
  doc["msg"] = msg;
  String out;
  serializeJson(doc, out);

  if (wsMutex && xSemaphoreTakeRecursive(wsMutex, pdMS_TO_TICKS(50)) == pdTRUE) {
    webSocket.sendTXT(num, out.c_str());
    xSemaphoreGiveRecursive(wsMutex);
  }
}

void wsBroadcastStatus(const String& jsonStr) {
  if (wsMutex && xSemaphoreTakeRecursive(wsMutex, pdMS_TO_TICKS(50)) == pdTRUE) {
    webSocket.broadcastTXT(jsonStr.c_str());
    xSemaphoreGiveRecursive(wsMutex);
  }
}

void wsSendSongList(uint8_t clientNum) {
  JsonDocument doc;
  doc["t"] = "list";
  JsonArray arr = doc["songs"].to<JsonArray>();

  for (int i = 0; i < totalSongs; i++) {
    JsonObject obj = arr.add<JsonObject>();
    obj["id"] = songList[i].id;
    obj["name"] = songList[i].name;
    obj["cat"] = songList[i].category;
    obj["tempo"] = songList[i].tempo;
    obj["len"] = songList[i].noteCount;
  }

  String out;
  serializeJson(doc, out);

  if (wsMutex && xSemaphoreTakeRecursive(wsMutex, pdMS_TO_TICKS(50)) == pdTRUE) {
    if (clientNum == 255) {
      webSocket.broadcastTXT(out.c_str());
    } else {
      webSocket.sendTXT(clientNum, out.c_str());
    }
    xSemaphoreGiveRecursive(wsMutex);
  }
}

static void handleWebSocketMessage(uint8_t num, uint8_t* payload, size_t length) {
  JsonDocument doc;
  DeserializationError err = deserializeJson(doc, payload, length);
  if (err)
    return;

  const char* cmd = doc["cmd"];
  if (!cmd)
    return;

  if (strcmp(cmd, "list") == 0) {
    wsSendSongList(num);
  } else if (strcmp(cmd, "play") == 0) {
    int id = doc["id"] | 0;
    playbackPlay(id);
    wsSendAck(num, true, "Playback started");
  } else if (strcmp(cmd, "stop") == 0) {
    playbackStop();
    wsSendAck(num, true, "Playback stopped");
  } else if (strcmp(cmd, "hit") == 0) {
    byte n = doc["n"] | 0;
    playbackHit(n);
  } else if (strcmp(cmd, "preview") == 0) {
    int tempo = doc["tempo"] | 120;
    JsonArrayConst notesArr = doc["notes"].as<JsonArrayConst>();
    static Nada tempNotes[MAX_NOTES];
    int count = 0;
    for (JsonArrayConst item : notesArr) {
      if (count >= MAX_NOTES)
        break;
      byte nada = item[0] | 0;
      byte panjang = item[1] | 4;
      tempNotes[count++] = {nada, panjang};
    }
    if (count > 0) {
      playbackPreview(tempNotes, count, tempo);
      wsSendAck(num, true, "Pratinjau lagu dimulai");
    } else {
      wsSendAck(num, false, "Notasi lagu kosong");
    }
  } else if (strcmp(cmd, "add") == 0) {
    const char* name = doc["name"] | "Lagu Baru";
    const char* cat = doc["cat"] | "lainnya";
    int tempo = doc["tempo"] | 120;
    JsonArrayConst notesArr = doc["notes"].as<JsonArrayConst>();

    int newId = -1;
    if (saveSong(newId, name, cat, tempo, notesArr)) {
      wsSendAck(num, true, "Lagu berhasil disimpan");
      wsSendSongList();
    } else {
      wsSendAck(num, false, "Gagal menyimpan lagu");
    }
  } else if (strcmp(cmd, "get_notes") == 0) {
    int id = doc["id"] | -1;
    static Nada tempNotes[MAX_NOTES];
    int noteCount = 0;
    int tempo = 120;

    if (loadSongNotes(id, tempNotes, noteCount, tempo)) {
      JsonDocument resp;
      resp["t"] = "song_detail";
      resp["id"] = id;
      resp["tempo"] = tempo;
      for (int i = 0; i < totalSongs; i++) {
        if (songList[i].id == id) {
          resp["name"] = songList[i].name;
          resp["cat"] = songList[i].category;
          break;
        }
      }
      JsonArray arr = resp["notes"].to<JsonArray>();
      for (int i = 0; i < noteCount; i++) {
        JsonArray n = arr.add<JsonArray>();
        n.add(tempNotes[i].nada);
        n.add(tempNotes[i].panjang);
      }
      String out;
      serializeJson(resp, out);
      if (wsMutex && xSemaphoreTakeRecursive(wsMutex, pdMS_TO_TICKS(50)) == pdTRUE) {
        webSocket.sendTXT(num, out.c_str());
        xSemaphoreGiveRecursive(wsMutex);
      }
    } else {
      wsSendAck(num, false, "Lagu tidak ditemukan");
    }
  } else if (strcmp(cmd, "edit") == 0) {
    int id = doc["id"] | -1;
    const char* name = doc["name"] | "Lagu";
    const char* cat = doc["cat"] | "lainnya";
    int tempo = doc["tempo"] | 120;
    JsonArrayConst notesArr = doc["notes"].as<JsonArrayConst>();

    if (saveSong(id, name, cat, tempo, notesArr)) {
      wsSendAck(num, true, "Lagu berhasil diperbarui");
      wsSendSongList();
    } else {
      wsSendAck(num, false, "Gagal memperbarui lagu");
    }
  } else if (strcmp(cmd, "del") == 0) {
    int id = doc["id"] | -1;
    if (id >= 0 && deleteSong(id)) {
      wsSendAck(num, true, "Lagu berhasil dihapus");
      wsSendSongList();
    } else {
      wsSendAck(num, false, "ID tidak valid");
    }
  } else if (strcmp(cmd, "reset_defaults") == 0) {
    restoreDefaultSongs();
    wsSendAck(num, true, "Semua lagu bawaan dipulihkan");
    wsSendSongList();
  }
}

static void webSocketEvent(uint8_t num, WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.printf("[WS] Client #%u disconnected\n", num);
      break;
    case WStype_CONNECTED:
      Serial.printf("[WS] Client #%u connected\n", num);
      wsSendSongList(num);
      break;
    case WStype_TEXT:
      handleWebSocketMessage(num, payload, length);
      break;
    default:
      break;
  }
}

void wsInit() {
  if (wsMutex == NULL) {
    wsMutex = xSemaphoreCreateRecursiveMutex();
  }
  playbackSetCallbacks(onPlaybackState, onPlaybackNote);
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

void wsLoop() {
  if (wsMutex && xSemaphoreTakeRecursive(wsMutex, pdMS_TO_TICKS(10)) == pdTRUE) {
    webSocket.loop();
    xSemaphoreGiveRecursive(wsMutex);
  }
}
