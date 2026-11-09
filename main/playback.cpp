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
  } else if (cmd.type == CMD_HIT) {
    solenoidHit(cmd.nada);
    vTaskDelay(pdMS_TO_TICKS(PULSE_MS));
    solenoidRelease(cmd.nada);
  }
}

static void playbackTask(void* pvParameters) {
  PlaybackCommand cmd;
  Nada notes[MAX_NOTES];
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
        } else if (cmd.type == CMD_HIT) {
          semuaMati();
          solenoidHit(cmd.nada);
          vTaskDelay(pdMS_TO_TICKS(PULSE_MS));
          solenoidRelease(cmd.nada);
        }
      }
    } else {
      bool aborted = false;

      for (int i = 0; i < noteCount; i++) {
        Nada item = notes[i];
        int seperempatKetuk = 60000 / tempo / 4;
        int totalDurasi = item.panjang * seperempatKetuk;

        if (item.nada >= DO && item.nada <= DO_T) {
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
          solenoidHit(item.nada);

          TickType_t pulseTicks = pdMS_TO_TICKS(nyala);
          if (pulseTicks < 1) pulseTicks = 1;
          if (xQueueReceive(playbackQueue, &cmd, pulseTicks) == pdTRUE) {
            solenoidRelease(item.nada);
            semuaMati();
            handleCmdWhilePlaying(cmd, playing, notes, noteCount, tempo, currentId, aborted);
            if (aborted) break;
          } else {
            solenoidRelease(item.nada);
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
