#pragma once
#include "config.h"

typedef void (*PlaybackStateCallback)(const char* state, int songId);
typedef void (*PlaybackNoteCallback)(byte nada, int noteIndex, int totalNotes);

void playbackInit();
void playbackSetCallbacks(PlaybackStateCallback stateCb, PlaybackNoteCallback noteCb);
void playbackPlay(int songId);
void playbackStop();
void playbackHit(byte nada);
bool playbackIsPlaying();
int playbackGetActiveSongId();
