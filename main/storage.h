#pragma once
#include "config.h"
#include <ArduinoJson.h>

extern SongHeader songList[MAX_SONGS];
extern int totalSongs;

bool storageInit();
void loadSongMetadata();
void saveSongMetadata();
bool loadSongNotes(int songId, Nada* outNotes, int& outCount, int& outTempo);
bool saveSong(int& id, const String& name, const String& cat, int tempo, JsonArrayConst notes);
bool deleteSong(int id);
void restoreDefaultSongs();
