#ifndef WIFI_MY_H_
#define WIFI_MY_H_

#include <WiFi.h>
#include "MCP23S17.h"
#include "EEPROMStore.h"
#include "ESPErrorData.h"

#define CONNECT_MAX_WAIT 50000
#define MAX_ENTRIES 16
#define MAX_RSSI -88

struct SSIDData {
  String ssid;
  char ssidCh[16];
  int32_t rssi;
};

void WIFIInit();
void updateStatus();
void updateListSSID();
void setSSIDByListID(int id);
void WIFIConnect();

#endif