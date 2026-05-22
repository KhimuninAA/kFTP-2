#ifndef ESP_EVENTS_H_
#define ESP_EVENTS_H_

#include "Interrupt.h"
#include "EEPROMStore.h"
#include "WIFIMy.h"
#include "FTPClient.h"
#include "EventsExt.h"
#include "ESPErrorData.h"

enum EspEvents_TYPE {
  NONE = -1,
  GET_BoardID = 0,
  GET_SSID_PASSWORD, // 1
  SET_SSID_PASSWORD, // 2
  GET_SSID_IP, // 3
  GET_SSID_MAC, // 4
  GET_SSID, // 5
  GET_FTP_URL, // 6
  SET_FTP_URL, // 7
  GET_FTP_USER, // 8
  SET_FTP_USER, // 9
  GET_FTP_PASS, // 10
  SET_FTP_PASS, // 11
  GET_FTP_HOME_DIR, // 12
  SET_FTP_HOME_DIR, // 13
  GET_FTP_PORT, // 14
  SET_FTP_PORT, // 15
  SSID_LIST_UPDATE, // 16
  SSID_LIST_NEXT, // 17
  SSID_SET_LIST_ID, // 18
  SSID_CONNECT, // 19
  GET_STATUS, // 20
  SET_FTP_TO_HOME_DIR, // 21
  GET_FTP_CURRENT_FOLDER, // 22
  FTP_CONNECT, // 23
  SET_FTP_CHANGE_DIR_UP, // 24
  SET_FTP_CHANGE_DIR_INDEX, // 25
  FTP_UPDATE_LIST, // 26
  FTP_LIST_FILE_NEXT, // 27
  FTP_FILE_DOWNLOAD, // 28
  FTP_FILE_DOWNLOAD_NEXT, // 29
  ESP_ERROR_CLEAR, // 30
  FTP_FILE_DELETE_INDEX, // 31
  FTP_FILE_UPLOAD_INIT, // 32
  FTP_MAKE_DIRECTORY, // 33
  FTP_FILE_UPLOAD_NEXT, // 34
  GET_DISK, // 35
  SET_DISK, // 36
};

void EspEventsExec();
bool EventsExtShowTypeLog(EspEvents_TYPE type);

#endif