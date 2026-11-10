#include "storage.h"
#include "songs.h"
#include <LittleFS.h>

SongHeader songList[MAX_SONGS];
int totalSongs = 0;

bool storageInit() {
  return LittleFS.begin(true);
}

void loadSongMetadata() {
  totalSongs = 0;

  bool isDel[NUM_DEFAULT_SONGS];
  for (int i = 0; i < NUM_DEFAULT_SONGS; i++) isDel[i] = false;

  if (LittleFS.exists("/deleted_defaults.json")) {
    File fDel = LittleFS.open("/deleted_defaults.json", "r");
    if (fDel) {
      JsonDocument docDel;
      if (!deserializeJson(docDel, fDel)) {
        for (JsonVariant v : docDel.as<JsonArray>()) {
          int d = v | -1;
          if (d >= 0 && d < NUM_DEFAULT_SONGS) isDel[d] = true;
        }
      }
      fDel.close();
    }
  }

  for (int i = 0; i < NUM_DEFAULT_SONGS; i++) {
    if (isDel[i]) continue;
    songList[totalSongs].id = i;
    songList[totalSongs].name = defaultSongNames[i];
    songList[totalSongs].category = defaultSongCats[i];
    songList[totalSongs].tempo = defaultSongTempos[i];
    songList[totalSongs].noteCount = defaultSongLengths[i];
    totalSongs++;
  }

  if (!LittleFS.exists("/songs.json")) return;

  File f = LittleFS.open("/songs.json", "r");
  if (!f) return;

  JsonDocument doc;
  DeserializationError err = deserializeJson(doc, f);
  f.close();

  if (err) return;

  for (JsonObject obj : doc.as<JsonArray>()) {
    if (totalSongs >= MAX_SONGS) break;
    songList[totalSongs].id = obj["id"] | totalSongs;
    songList[totalSongs].name = obj["name"] | "Lagu";
    songList[totalSongs].category = (const char*)(obj["cat"] | "lainnya");
    songList[totalSongs].tempo = obj["tempo"] | 120;
    songList[totalSongs].noteCount = obj["len"] | 0;
    totalSongs++;
  }
}

void saveSongMetadata() {
  File f = LittleFS.open("/songs.json", "w");
  if (!f) return;

  JsonDocument doc;
  JsonArray arr = doc.to<JsonArray>();

  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id >= NUM_DEFAULT_SONGS) {
      JsonObject obj = arr.add<JsonObject>();
      obj["id"] = songList[i].id;
      obj["name"] = songList[i].name;
      obj["cat"] = songList[i].category;
      obj["tempo"] = songList[i].tempo;
      obj["len"] = songList[i].noteCount;
    }
  }

  serializeJson(doc, f);
  f.close();
}

bool loadSongNotes(int songId, Nada* outNotes, int& outCount, int& outTempo) {
  if (songId >= 0 && songId < NUM_DEFAULT_SONGS) {
    outTempo = defaultSongTempos[songId];
    outCount = defaultSongLengths[songId];
    const Nada* src = defaultSongNotes[songId];
    for (int i = 0; i < outCount; i++) {
      outNotes[i].nada = pgm_read_byte(&(src[i].nada));
      outNotes[i].panjang = pgm_read_byte(&(src[i].panjang));
    }
    return true;
  }

  String path = "/song_" + String(songId) + ".bin";
  if (!LittleFS.exists(path)) return false;

  File f = LittleFS.open(path, "r");
  if (!f) return false;

  int count = f.read();
  if (count <= 0 || count > MAX_NOTES) {
    f.close();
    return false;
  }

  for (int i = 0; i < count; i++) {
    outNotes[i].nada = f.read();
    outNotes[i].panjang = f.read();
  }
  f.close();

  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id == songId) {
      outTempo = songList[i].tempo;
      outCount = count;
      return true;
    }
  }

  return false;
}

bool saveSong(int& id, const String& name, const String& cat, int tempo, JsonArrayConst notes) {
  if (notes.size() == 0 || notes.size() > MAX_CUSTOM_NOTES) return false;

  int targetId = id;
  if (targetId < NUM_DEFAULT_SONGS) {
    targetId = NUM_DEFAULT_SONGS;
    for (int i = 0; i < totalSongs; i++) {
      if (songList[i].id >= targetId) targetId = songList[i].id + 1;
    }
  }

  String path = "/song_" + String(targetId) + ".bin";
  File f = LittleFS.open(path, "w");
  if (!f) return false;

  f.write((uint8_t)notes.size());
  for (JsonVariantConst v : notes) {
    byte n = v[0] | 0;
    byte d = v[1] | 4;
    f.write(n);
    f.write(d);
  }
  f.close();

  int foundIdx = -1;
  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id == targetId) {
      foundIdx = i;
      break;
    }
  }

  if (foundIdx != -1) {
    songList[foundIdx].name = name;
    songList[foundIdx].category = cat;
    songList[foundIdx].tempo = tempo;
    songList[foundIdx].noteCount = notes.size();
  } else if (totalSongs < MAX_SONGS) {
    songList[totalSongs].id = targetId;
    songList[totalSongs].name = name;
    songList[totalSongs].category = cat;
    songList[totalSongs].tempo = tempo;
    songList[totalSongs].noteCount = notes.size();
    totalSongs++;
  }

  id = targetId;
  saveSongMetadata();
  return true;
}

bool deleteSong(int id) {
  if (id < 0) return false;

  if (id < NUM_DEFAULT_SONGS) {
    JsonDocument docDel;
    if (LittleFS.exists("/deleted_defaults.json")) {
      File fDel = LittleFS.open("/deleted_defaults.json", "r");
      if (fDel) {
        deserializeJson(docDel, fDel);
        fDel.close();
      }
    }
    JsonArray arrDel = docDel.to<JsonArray>();
    bool exists = false;
    for (JsonVariant v : arrDel) {
      if ((v | -1) == id) {
        exists = true;
        break;
      }
    }
    if (!exists) arrDel.add(id);

    File fDelW = LittleFS.open("/deleted_defaults.json", "w");
    if (fDelW) {
      serializeJson(docDel, fDelW);
      fDelW.close();
    }
  } else {
    String path = "/song_" + String(id) + ".bin";
    if (LittleFS.exists(path)) LittleFS.remove(path);
  }

  int foundIdx = -1;
  for (int i = 0; i < totalSongs; i++) {
    if (songList[i].id == id) {
      foundIdx = i;
      break;
    }
  }

  if (foundIdx != -1) {
    for (int i = foundIdx; i < totalSongs - 1; i++) {
      songList[i] = songList[i + 1];
    }
    totalSongs--;
    saveSongMetadata();
  }

  return true;
}

void restoreDefaultSongs() {
  if (LittleFS.exists("/deleted_defaults.json")) {
    LittleFS.remove("/deleted_defaults.json");
  }
  loadSongMetadata();
}
