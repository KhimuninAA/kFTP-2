#include "EspEvents.h"

extern InterruptData interruptData;
extern EEPROMData data;
extern bool WIFIflag;
extern SSIDData ssidsData[MAX_ENTRIES];
extern uint8_t SSIDListCount;
extern uint8_t SSIDListSendCount;
extern FTPClient ftpClientA;

void EspEventsExec() {
  SerialExpanderSetBusy(true);

  String tempStr;
  EspEvents_TYPE type = static_cast<EspEvents_TYPE>(interruptData.key);
  if (EventsExtShowTypeLog(type)) {
    Serial.print(F("Received request -> "));
    Serial.print(interruptData.key);
    Serial.println("");
  }
  interruptData.key = -1;
  switch (type) {
    case GET_STATUS:
      createStatusToBuffer();
      break;
    case ESP_ERROR_CLEAR:
      ESPErrorData_Clear();
      break;
    case GET_SSID_PASSWORD:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ssidPass, 16);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SET_SSID_PASSWORD:
      interruptData.isProcessed = true;
      memcpy(data.ssidPass, interruptData.buffer, 16);
      EEPROMStoreSave();
      EEPROMStoreLoad();
      break;
    case GET_SSID:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ssid, 16); //ftpHomeDir ssid
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case GET_SSID_MAC:
      interruptData.isProcessed = true;
      createBufferByString(WiFi.macAddress());
      interruptData.answerIndex = 0;
      break;
    case GET_SSID_IP:
      interruptData.isProcessed = true;
      WiFi.localIP().toString().toCharArray((char*)interruptData.answerBuffer, WiFi.localIP().toString().length() + 1);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SSID_LIST_UPDATE:
      updateListSSID();
      SSIDListSendCount = 0;
      break;
    case SSID_LIST_NEXT:
      interruptData.isProcessed = true;
      if (SSIDListSendCount < SSIDListCount) {
        interruptData.answerCount = 16;
        memcpy(interruptData.answerBuffer, ssidsData[SSIDListSendCount].ssidCh, 16);
        SSIDListSendCount += 1;
      } else {
        interruptData.answerCount = 0;
      }
      interruptData.answerIndex = 0;
      break;
    case SSID_CONNECT:
      WIFIConnect();
      break;
    case SSID_SET_LIST_ID:
      if (interruptData.index > 0) {
        setSSIDByListID((int)interruptData.buffer[0]);
      }
      break;
    case GET_FTP_URL:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ftpServerUrl, 16);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_URL:
      interruptData.isProcessed = true;
      memcpy(data.ftpServerUrl, interruptData.buffer, 16);
      EEPROMStoreSave();
      break;
    case GET_FTP_USER:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ftpUser, 16);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_USER:
      interruptData.isProcessed = true;
      memcpy(data.ftpUser, interruptData.buffer, 16);
      EEPROMStoreSave();
      break;
    case GET_FTP_PASS:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ftpPass, 16);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_PASS:
      interruptData.isProcessed = true;
      memcpy(data.ftpPass, interruptData.buffer, 16);
      EEPROMStoreSave();
      break;
    case GET_FTP_HOME_DIR:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ftpHomeDir, 16);
      interruptData.answerCount = 16;
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_HOME_DIR:
      interruptData.isProcessed = true;
      memcpy(data.ftpHomeDir, interruptData.buffer, 16);
      EEPROMStoreSave();
      break;

    case GET_FTP_PORT:
      interruptData.isProcessed = true;
      memcpy(interruptData.answerBuffer, data.ftpPort, 6);
      interruptData.answerCount = 6;
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_PORT:
      interruptData.isProcessed = true;
      memcpy(data.ftpPort, interruptData.buffer, 6);
      EEPROMStoreSave();
      break;
    case FTP_CONNECT:
      ftpClientA.ftpConnect();
      break;
    case GET_FTP_CURRENT_FOLDER:
      interruptData.isProcessed = true;
      interruptData.answerCount = 16;
      tempStr = ftpClientA.getCurrentFolder();
      tempStr.toCharArray((char*)interruptData.answerBuffer, tempStr.length() + 1);
      interruptData.answerIndex = 0;
      break;
    case SET_FTP_TO_HOME_DIR:
      ftpClientA.goToHomeDir();
      break;
    case SET_FTP_CHANGE_DIR_INDEX:
      if (interruptData.index > 0) {
        ftpClientA.changeDirByIndex((int)interruptData.buffer[0]);
      }
      break;
    case SET_FTP_CHANGE_DIR_UP:
      ftpClientA.changeDirUp();
      break;
    case FTP_LIST_FILE_NEXT:
      if (interruptData.index > 0) {
        if (interruptData.buffer[0] == 0x01) {
          ftpClientA.ftpFilesSendCount += 1;
        }
      }
      if (ftpClientA.ftpFilesSendCount < ftpClientA.ftpFilesCount) {
        interruptData.isProcessed = true;
        interruptData.answerCount = 16;
        ftpFileToBuffer();
        interruptData.answerIndex = 0;
      } else {
        interruptData.isProcessed = true;
        interruptData.answerCount = 0;
        interruptData.answerIndex = 0;
      }
      break;
    case FTP_UPDATE_LIST:
      if (interruptData.index > 0) {
        ftpClientA.updateFtpList((int)interruptData.buffer[0]);
        ftpClientA.ftpFilesSendCount = 0;
      }
      break;
    case FTP_FILE_DELETE_INDEX:
      if (interruptData.index > 0) {
        ftpClientA.deleteFile((int)interruptData.buffer[0]);
      }
      break;
    case FTP_FILE_DOWNLOAD_NEXT:
      if (interruptData.index > 0) {
        if (interruptData.buffer[0] == 0) { //0 еще раз
          ftpClientA.downloadFileAgain();
        } else if (interruptData.buffer[0] == 1) { //1 - следующий дамп
          ftpClientA.downloadFileNext();
        } else { // Фиг знает что...
          interruptData.isProcessed = true;
          interruptData.answerCount = 0;
          interruptData.answerIndex = 0;
        }
      } else {
        interruptData.isProcessed = true;
        interruptData.answerCount = 0;
        interruptData.answerIndex = 0;
      }
      break;
    case FTP_FILE_DOWNLOAD:
      if (interruptData.index > 0) {
        ftpClientA.downloadFile((int)interruptData.buffer[0]);
      }
      break;
    case FTP_FILE_UPLOAD_INIT:
      if (interruptData.index > 0) {
        tempStr = (char*)interruptData.buffer; 
        ftpClientA.uploadFile(tempStr);
      }
      break;
    case FTP_FILE_UPLOAD_NEXT:
      interruptData.isProcessed = true;
      interruptData.answerCount = 4;
      interruptData.answerIndex = 0;
      //b - sum, bb - len, b - isEnd
      if (interruptData.index > 18) {
        if (EventsExt_VerifyAnswerBufferSum(0, 16)) {
          ftpClientA.uploadFileData();
          EventsExt_UploadAnswer(1, ftpClientA.uploadProgress);
        } else {
          EventsExt_UploadAnswer(0, 0);
        }
      } else {
        EventsExt_UploadAnswer(0, 0);
      }
      break;
    case FTP_MAKE_DIRECTORY:
      if (interruptData.index > 0) {
        tempStr = (char*)interruptData.buffer; 
        ftpClientA.makeDirectory(tempStr);
      }
      break;

    case GET_DISK:
      interruptData.isProcessed = true;
      EventsExt_Disk_Request();
      interruptData.answerCount = 3;
      interruptData.answerIndex = 0;
      break;
    case SET_DISK:
      interruptData.isProcessed = true;
      EventsExt_Disk_Response();
      EEPROMStoreSave();
      EEPROMStoreLoad();
      break;  
    default:
      break;
  }

  SerialExpanderSetBusy(false);
}

bool EventsExtShowTypeLog(EspEvents_TYPE type) {
  bool ret = true;
  switch (type) {
    case GET_STATUS:
    case FTP_LIST_FILE_NEXT:
    case FTP_FILE_DOWNLOAD_NEXT:
      ret = false;
      break;
    default:
      break;
  }
  return ret;
}
