#ifndef FTP_CLIENT_H_
#define FTP_CLIENT_H_

#include <Arduino.h> 
#include "EEPROMStore.h"
#include <WiFi.h>
#include "FtpFileData.h"
#include "Interrupt.h"
#include "ESPErrorData.h"

extern EEPROMData data;

class FTPClient {
  private:
    WiFiClient ftpClient;
    uint16_t timeout = 3000; //10000; //1000;
    WiFiClient ftpDataClient;
    int16_t ftpClientResponseOldCode;
    String ftpClientResponse;
    int16_t ftpClientResponseCode;
    String ftpClientResponses[5];
    int ftpClientResponsesCount = 0;
    bool ftpDataConnected = false;
    char chDir[128] = "/";
    int ftpDataPort;
    char tempName[128];
    float progressCount = 40;
    uint8_t maxFilesInList = 13;
    enum TransferModeType {ASCII, BINARY};
    FtpFileDownloadInfo fileDownloadInfo;

    void getStatus();
    void parseStatus();
    void seek227Code();
    void needActionByChangeCode();
    void ftpDataClientConnect();
    void sendAuthenticationUsername();
    void sendAuthenticationPassword();
    void setPassiveMode();
    bool activeConnect();
    void setTransferMode(TransferModeType type);
    bool activeDataConnect();
    bool reconnectDataConnect();
    bool changeDir(char * dir);
    bool isCodeError();

  public:
    FtpFileData ftpFiles[20];
    uint8_t ftpFilesCount = 0;
    uint8_t ftpFilesSendCount = 0;
    int16_t uploadCount = 0;
    int8_t uploadProgress = 0;

    FTPClient();
    void goToHomeDir();
    String getCurrentFolder();
    bool getFtpDataConnected();
    void ftpConnect();
    void changeDirByIndex(int index);
    void changeDirUp();
    void updateFtpList(uint8_t fileCount);
    uint8_t downloadFile(int index);
    void downloadFileAgain();
    void downloadFileNext();
    uint8_t deleteFile(int index);
    void makeDirectory(String dir);
    uint8_t uploadFile(String fileName);
    uint8_t uploadFileData();
    void noop();
};

#endif