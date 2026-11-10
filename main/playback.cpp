#include "playback.h"
#include "solenoid.h"
#include "storage.h"
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/queue.h>

static QueueHandle_t playbackQueue = NULL;
static TaskHandle_t playbackTaskHandle = NULL;
static PlaybackStateCallback stateCallback = NULL;
static PlaybackNoteCallback noteCallback = NULL;

static volatile bool playingState = false;
static volatile int activeSongIdVal = -1;

static Nada previewNotes[MAX_NOTES];
static int previewNoteCount = 0;
static int previewTempo = 120;

static void updateState(bool playing, int songId) {
  playingState = playing;
  activeSongIdVal = songId;
  if (stateCallback) {
    stateCallback(playing ? "playing" : "idle", songId);
  }
}

static void handleCmdWhilePlaying(const PlaybackCommand& cmd, bool& playing,
                                  Nada* notes, int& noteCount, int& tempo,
                                  int& currentId, bool& aborted) {
  if (cmd.type == CMD_STOP) {
    playing = false;
    currentId = -1;
    aborted = true;
    updateState(false, -1);
  } else if (cmd.type == CMD_PLAY) {
    if (loadSongNotes(cmd.songId, notes, noteCount, tempo)) {
      currentId = cmd.songId;
      playing = true;
      aborted = true;
      updateState(true, currentId);
    } else {
      playing = false;
      currentId = -1;
      aborted = true;
      updateState(false, -1);
    }
  } else if (cmd.type == CMD_PREVIEW) {
    memcpy(notes, previewNotes, previewNoteCount * sizeof(Nada));
    noteCount = previewNoteCount;
    tempo = previewTempo;
    currentId = PREVIEW_SONG_ID;
    playing = true;
    aborted = true;
    updateState(true, currentId);
  } else if (cmd.type == CMD_HIT) {
    solenoidHit(cmd.nada, PULSE_MS);
    vTaskDelay(pdMS_TO_TICKS(PULSE_MS));
    solenoidRelease(cmd.nada);
  }
}

static void hitBoth(byte kanan, byte kiri, int nyala) {
  solenoidHit(kanan, nyala);
  if (kiri != kanan) solenoidHit(kiri, nyala);
}

static void releaseBoth(byte kanan, byte kiri) {
  solenoidRelease(kanan);
  if (kiri != kanan) solenoidRelease(kiri);
}

static Nada notes[MAX_NOTES];

static void playbackTask(void* pvParameters) {
  PlaybackCommand cmd;
  int noteCount = 0;
  int tempo = 120;
  int currentId = -1;
  bool playing = false;

  for (;;) {
    if (!playing) {
      if (xQueueReceive(playbackQueue, &cmd, portMAX_DELAY) == pdTRUE) {
        if (cmd.type == CMD_PLAY) {
          if (loadSongNotes(cmd.songId, notes, noteCount, tempo)) {
            currentId = cmd.songId;
            playing = true;
            semuaMati();
            updateState(true, currentId);
          }
        } else if (cmd.type == CMD_PREVIEW) {
          memcpy(notes, previewNotes, previewNoteCount * sizeof(Nada));
          noteCount = previewNoteCount;
          tempo = previewTempo;
          currentId = PREVIEW_SONG_ID;
          playing = true;
          semuaMati();
          updateState(true, currentId);
        } else if (cmd.type == CMD_HIT) {
          semuaMati();
          solenoidHit(cmd.nada, PULSE_MS);
          vTaskDelay(pdMS_TO_TICKS(PULSE_MS));
          solenoidRelease(cmd.nada);
        }
      }
    } else {
      bool aborted = false;

      for (int i = 0; i < noteCount; i++) {
        Nada item = notes[i];
        byte kanan = stikKanan(item.nada);
        byte kiri = stikKiri(item.nada);
        int seperempatKetuk = 60000 / tempo / 4;
        int totalDurasi = item.panjang * seperempatKetuk;

        if (kanan != DIAM || kiri != DIAM) {
          int nyala = PULSE_MS;
          if (nyala > totalDurasi - JEDA_MIN_MS) {
            nyala = totalDurasi - JEDA_MIN_MS;
            if (nyala < 15) nyala = 15;
          }
          int sisa = totalDurasi - nyala;
          if (sisa < JEDA_MIN_MS) sisa = JEDA_MIN_MS;

          if (noteCallback) {
            noteCallback(item.nada, i, noteCount);
          }
          hitBoth(kanan, kiri, nyala);

          TickType_t pulseTicks = pdMS_TO_TICKS(nyala);
          if (pulseTicks < 1) pulseTicks = 1;
          if (xQueueReceive(playbackQueue, &cmd, pulseTicks) == pdTRUE) {
            releaseBoth(kanan, kiri);
            semuaMati();
            handleCmdWhilePlaying(cmd, playing, notes, noteCount, tempo, currentId, aborted);
            if (aborted) break;
          } else {
            releaseBoth(kanan, kiri);
          }

          TickType_t gapTicks = pdMS_TO_TICKS(sisa);
          if (gapTicks < 1) gapTicks = 1;
          if (xQueueReceive(playbackQueue, &cmd, gapTicks) == pdTRUE) {
            semuaMati();
            handleCmdWhilePlaying(cmd, playing, notes, noteCount, tempo, currentId, aborted);
            if (aborted) break;
          }
        } else {
          TickType_t restTicks = pdMS_TO_TICKS(totalDurasi);
          if (restTicks < 1) restTicks = 1;
          if (xQueueReceive(playbackQueue, &cmd, restTicks) == pdTRUE) {
            semuaMati();
            handleCmdWhilePlaying(cmd, playing, notes, noteCount, tempo, currentId, aborted);
            if (aborted) break;
          }
        }
      }

      if (!aborted && playing) {
        playing = false;
        currentId = -1;
        semuaMati();
        updateState(false, -1);
      }
    }
  }
}

void playbackInit() {
  if (playbackQueue == NULL) {
    playbackQueue = xQueueCreate(10, sizeof(PlaybackCommand));
  }
  if (playbackTaskHandle == NULL) {
    xTaskCreatePinnedToCore(
      playbackTask,
      "playback",
      4096,
      NULL,
      5,
      &playbackTaskHandle,
      1
    );
  }
}

void playbackSetCallbacks(PlaybackStateCallback stateCb, PlaybackNoteCallback noteCb) {
  stateCallback = stateCb;
  noteCallback = noteCb;
}

void playbackPlay(int songId) {
  if (!playbackQueue) return;
  PlaybackCommand cmd = { CMD_PLAY, songId, 0 };
  xQueueSend(playbackQueue, &cmd, 0);
}

void playbackPreview(const Nada* customNotes, int count, int tempo) {
  if (!playbackQueue || count <= 0 || customNotes == NULL) return;
  if (count > MAX_NOTES) count = MAX_NOTES;
  memcpy(previewNotes, customNotes, count * sizeof(Nada));
  previewNoteCount = count;
  previewTempo = tempo;

  PlaybackCommand cmd = { CMD_PREVIEW, PREVIEW_SONG_ID, 0 };
  xQueueSend(playbackQueue, &cmd, 0);
}

void playbackStop() {
  if (!playbackQueue) return;
  PlaybackCommand cmd = { CMD_STOP, 0, 0 };
  xQueueSend(playbackQueue, &cmd, 0);
}

void playbackHit(byte nada) {
  if (!playbackQueue) return;
  PlaybackCommand cmd = { CMD_HIT, 0, nada };
  xQueueSend(playbackQueue, &cmd, 0);
}

bool playbackIsPlaying() {
  return playingState;
}

int playbackGetActiveSongId() {
  return activeSongIdVal;
}
