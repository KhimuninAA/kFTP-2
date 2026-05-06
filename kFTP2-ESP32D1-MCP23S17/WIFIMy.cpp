#include "WIFIMy.h"

extern EEPROMData data;
extern ESPErrorData espError;

bool WIFIflag = false;
SSIDData ssidsData[MAX_ENTRIES];
uint8_t SSIDListCount = 0;
uint8_t SSIDListSendCount = 0;

void WIFIInit() {
  WiFi.mode(WIFI_STA);
  //WiFi.setSleep(false); //ToDo
  WiFi.disconnect(true);
}

void WIFIConnect() {
  WiFi.disconnect(true);
  WiFi.begin(String(data.ssid), String(data.ssidPass));
  //WiFi.setTxPower(WIFI_POWER_8_5dBm); //ToDo
  //WiFi.setTxPower(WIFI_POWER_19_5dBm); //WIFI_POWER_19_5dBm WIFI_POWER_11dBm
  WIFIflag = false;
  int i = 0;
  while (WiFi.status() != WL_CONNECTED && i < 50) {
    delay(200);
    i++;
    Serial.print(".");
  }
  //
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WiFi CONNECTED");
    WIFIflag = true;
  } else {
    Serial.println("WiFi CONNECTED ERROR");
    WIFIflag = false;
    espError.error = ESPErrorValue_WiFiConnectError;
  }
}

void updateStatus() {
  if (WiFi.status() != WL_CONNECTED) {
    WIFIflag = false;
  } else {
    WIFIflag = true;
  }
}

void setSSIDByListID(int id) {
  ssidsData[id].ssid.toCharArray(data.ssid,ssidsData[id].ssid.length() + 1);
  EEPROMStoreSave();
}

void updateListSSID() {
  memset(ssidsData, 0, sizeof(ssidsData));
  int numberOfNetworks = WiFi.scanNetworks();
  SSIDListCount = 0;
  SSIDListSendCount = 0;
  if (numberOfNetworks == 0) {

  } else {
    char ssidCh[40];
    int pos = 0;
    for (int i = 0; i < numberOfNetworks; i++) {
      if ((SSIDListCount < MAX_ENTRIES)&&(WiFi.RSSI(i) > MAX_RSSI)) {
        ssidsData[SSIDListCount].ssid = WiFi.SSID(i);
        ssidsData[SSIDListCount].rssi = WiFi.RSSI(i);
        strncpy(ssidCh, WiFi.SSID(i).c_str(), 40);
        pos = 0;
        for(int j = 0; j < 40; j++) {
          char c = ssidCh[j];
          if (c < 0x80) {
            ssidsData[SSIDListCount].ssidCh[pos] = c;
            pos ++;
          } else if (c == 0xD0) {
            i++;
            uint8_t utC = ssidCh[i];
            utC -= 0x10;
            ssidsData[SSIDListCount].ssidCh[pos] = utC;
            pos ++;
          } else if (c == 0xD1) {
            i++;
            uint8_t utC = ssidCh[i];
            utC += 0x60;
            ssidsData[SSIDListCount].ssidCh[pos] = utC;
            pos ++;
          }
          if (pos >= 15) {
            break;
          }
        }
        ssidsData[SSIDListCount].ssidCh[15] = 0;
        SSIDListCount += 1;
      }
    }
  }
}