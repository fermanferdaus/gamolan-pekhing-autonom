#pragma once
#include "config.h"

void wsInit();
void wsLoop();
void wsSendSongList(uint8_t clientNum = 255);
void wsSendAck(uint8_t num, bool ok, const String& msg);
void wsBroadcastStatus(const String& jsonStr);
