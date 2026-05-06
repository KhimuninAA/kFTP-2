#include "FTPClient.h"

extern InterruptData interruptData;
extern ESPErrorData espError;

FTPClient::FTPClient() {
  ftpDataConnected = false;
  fileDownloadInfo.loadSize = 64; //240; //128;
}

void FTPClient::ftpConnect() {
  ftpClient.stop();
  ftpClientResponseOldCode = 0;
  uint16_t numPort = (uint16_t)strtoul(data.ftpPort, NULL, 10);
  if (!ftpClient.connect(data.ftpServerUrl, numPort)) {
    Serial.println("C connection failed");
    espError.action = ESPErrorAction_None;
    espError.error = ESPErrorValue_FtpConnectError;
    return;
  }
  Serial.println("C FTP connected");
  getStatus();
}

void FTPClient::getStatus() {
  if (activeConnect() == false) {
    return;
  }

  ftpClientResponse = "";
  ftpClientResponsesCount = 0;

  unsigned long _m = millis();
  while (!ftpClient.available() && millis() < _m + timeout) delay(1);
  Serial.println("getStatus start");

  while (ftpClient.available()) {
    char c = ftpClient.read();
    if (c == '\n' || c == '\r') {
      Serial.println("getStatus next step");
      if (ftpClientResponse.length() > 0) {
        ftpClientResponses[ftpClientResponsesCount] = ftpClientResponse;
        ftpClientResponse = "";
        ftpClientResponsesCount++;
      }
    } else {
      ftpClientResponse += c;
    }
  }
  parseStatus();
}

void FTPClient::parseStatus() {
  if (ftpClientResponsesCount == 0) {
    Serial.println("getStatus empty buffer");
  }

  for (int i = 0; i < ftpClientResponsesCount; i++) {
    ftpClientResponse = ftpClientResponses[i];
    ftpClientResponse.trim();
    ftpClientResponseCode = atoi(ftpClientResponse.c_str());

    seek227Code();

    if (ftpClientResponseOldCode != ftpClientResponseCode) {
      ftpClientResponseOldCode = ftpClientResponseCode;
      Serial.print(F("C "));
      Serial.println(ftpClientResponse);
      needActionByChangeCode();
    }
  }
}

void FTPClient::seek227Code() {
    if ((ftpClientResponseCode == 227)) {
    int index = ftpClientResponse.indexOf(',');
    if (index >= 0) {
      int index1 = ftpClientResponse.indexOf(',', index + 1);
      int index2 = ftpClientResponse.indexOf(',', index1 + 1);
      int indexD1 = ftpClientResponse.indexOf(',', index2 + 1);
      int indexDE1 = ftpClientResponse.indexOf(',', indexD1 + 1);
      String dSrt = ftpClientResponse.substring(indexD1 + 1, indexDE1);
      int indexDE2 = ftpClientResponse.indexOf(')', indexDE1 + 1);
      String dSrt2 = ftpClientResponse.substring(indexDE1 + 1, indexDE2);

      int lo = dSrt2.toInt();
      int hi = dSrt.toInt();
      hi = hi << 8;
      hi += lo;
      ftpDataPort = hi;
      Serial.print(F("New port: "));
      Serial.println(ftpDataPort);
      ftpDataClientConnect();
    }
  }
}

void FTPClient::needActionByChangeCode() {
  if (activeConnect() == false) {
    return;
  }

  if (ftpClientResponseCode == 220) {
    sendAuthenticationUsername();
  } else if (ftpClientResponseCode == 331) {
    sendAuthenticationPassword();
  } else if (ftpClientResponseCode == 230) {
    setPassiveMode();
  } else {
    Serial.print("Uncnown Response Code: ");
    Serial.println(ftpClientResponseCode);
    //200 227 150 250 226
  }

  ESPErrorData_FtpResponseCode(ftpClientResponseCode);
}

void FTPClient::sendAuthenticationUsername() {
  ftpClient.print(F("USER "));
  ftpClient.println(data.ftpUser);
  getStatus();
}

void FTPClient::sendAuthenticationPassword() {
  ftpClient.print(F("PASS "));
  ftpClient.println(data.ftpPass);
  getStatus();
}

void FTPClient::setPassiveMode() {
  ftpClient.println("PASV");
  getStatus();
}

void FTPClient::ftpDataClientConnect() {
  ftpDataClient.stop(); //disconnect();
  if (ftpDataClient.connect(data.ftpServerUrl, ftpDataPort)) { //, timeout
    Serial.println(F("C Data connection established"));
    ftpDataConnected = true;
  } else {
    ftpDataConnected = false;
  }
}

bool FTPClient::getFtpDataConnected() {
  return ftpDataConnected;
}

bool FTPClient::activeConnect() {
  if (ftpClient.connected() == true) {
    return true;
  } else {
    ftpConnect();
    if (ftpClient.connected() == true) {
      return true;
    }
    espError.action = ESPErrorAction_None;
    espError.error = ESPErrorValue_FtpConnectError;
    Serial.println(F("C ReConnect Error!!!"));
  }
  return false;
}

bool FTPClient::activeDataConnect() {
  if (ftpDataClient.connected() == true) {
    return true;
  } else {
    int reconnectCount = 0;
    bool isConnect = false;
    do {
      delay(10);
      isConnect = reconnectDataConnect();
      reconnectCount++;
    }while(!isConnect && reconnectCount < 5);
    if (isConnect) {
      return true;
    }
    
    Serial.println(F("C ReDataConnect Error!!!"));
  }
  return false;
}

bool FTPClient::reconnectDataConnect() {
  ftpDataClientConnect();
  return ftpDataClient.connected();
}

void FTPClient::setTransferMode(TransferModeType type) {
  if (activeConnect() == false) {
    return;
  }
  if (type == ASCII) {
    ftpClient.println(F("Type A"));
  } else if (type == BINARY) {
    ftpClient.println(F("Type I"));
  }
  getStatus();

  setPassiveMode();
}

bool FTPClient::isCodeError() {
  int codeLen = floor(log10(abs(ftpClientResponseCode))) + 1;
  if (codeLen == 3) {
    int first = ftpClientResponseCode;
    while (first >= 10) {
      first /= 10;
    }
    if (first == 5) {
      return true;
    }
  }
  return false;
}

bool FTPClient::changeDir(char * dir) {
  if (activeConnect() == false) {
    return false;
  }
  ftpClient.print(F("CWD "));
  ftpClient.println(dir);

  do {
    getStatus();
  }while(ftpClientResponseCode != 250 && !isCodeError());

  if (isCodeError() == true) {
    return false;
  } else {
    return true;
  }
}

void FTPClient::goToHomeDir() {
  int homeDirLength = strlen(data.ftpHomeDir);
  memset(chDir, 0, sizeof(chDir));
  strncpy(chDir, data.ftpHomeDir, homeDirLength);
}

void FTPClient::changeDirByIndex(int index) {
  int chDirLength = strlen(chDir);
  int addDirLength = ftpFiles[index].name.length();
  if ((chDirLength + addDirLength + 1) > 128) {
    return;
  }
  strncpy(tempName, ftpFiles[index].name.c_str(), 23);
  strcat(chDir, tempName);
  strcat(chDir, "/");
}

void FTPClient::changeDirUp() {
  int length = strlen(chDir);
  length -= 2; // Remove last "/+0"
  int index = 0;
  for (int i = length; i >= 0 ; i--) {
    char c = chDir[i];
    if (c == '/') {
      index = i;
      break;
    }
  }
  if (index >= 0) {
    index += 1;
    strncpy(tempName, chDir + 0, index);
    tempName[index] = '\0';
    strncpy(chDir, tempName, 127);
  }
}

String FTPClient::getCurrentFolder() {
  int maxStrLen = 16; //21; //23;
  char tempDir[128];
  int pos = 0;
  for (int i = 0; i < 128; i++) {
    char c = chDir[i];
    if (c < 0x80) {
      tempDir[pos] = c;
      pos ++;
    } else if (c == 0xD0) {
      i++;
      uint8_t utC = chDir[i];
      utC -= 0x10;
      tempDir[pos] = utC;
      pos ++;
    } else if (c == 0xD1) {
      i++;
      uint8_t utC = chDir[i];
      utC += 0x60;
      tempDir[pos] = utC;
      pos ++;
    }
  }
  String curDir = String(tempDir);
  if (curDir.length() > maxStrLen) {
    int from = curDir.length() - maxStrLen + 2; //(2 = "..")
    curDir = ".." + curDir.substring(from);
  }
  return curDir;
}

void FTPClient::updateFtpList(uint8_t fileCount) {
  // Очистить список и интедкс

  if (activeConnect() == false) {
    return;
  }

  setTransferMode(BINARY);

  ftpClient.print(F("MLSD "));
  ftpClient.println(chDir);
  getStatus();

  if (activeDataConnect() == false) {
    return;
  }

  ftpFilesCount = 0;
  unsigned long _m = millis();
  while( !ftpDataClient.available() && millis() < _m + timeout) delay(1);

  uint8_t maxFileCount = maxFilesInList;
  if (fileCount > maxFilesInList) {
    maxFileCount = fileCount;
  }
  while(ftpDataClient.available()) {
    if( ftpFilesCount < maxFileCount ) {
      String fileDataStr = ftpDataClient.readStringUntil('\n');
      FtpFileData ftpFileData = FtpFileDataHelper::parse(fileDataStr);
      if (ftpFileData.isHidden == false) {
        Serial.println(ftpFileData.name);
        ftpFiles[ftpFilesCount] = ftpFileData;
        ftpFilesCount++;
      }
    } else {
      String empty = ftpDataClient.readStringUntil('\n');
    }
  }
}

uint8_t FTPClient::downloadFile(int index) {
  changeDir(chDir);
  setTransferMode(BINARY);

  strncpy(tempName, ftpFiles[index].name.c_str(), 16);
  fileDownloadInfo.fileSize = (uint16_t)ftpFiles[index].size;

  ftpClient.print(F("RETR "));
  ftpClient.println(tempName);
  getStatus();

  if (activeDataConnect() == false) {
    return 0;
  }

  uint16_t addr = 0;
  fileDownloadInfo.addr = addr;

  unsigned long _m = millis();
  while( !ftpDataClient.available() && millis() < _m + timeout) delay(1);

  return 1;
}

void FTPClient::downloadFileAgain() {
  interruptData.isProcessed = true;
  interruptData.answerIndex = 0;
  interruptData.answerCount = fileDownloadInfo.answerCount;
  memcpy(interruptData.answerBuffer, fileDownloadInfo.buffer, 128); 
}

void FTPClient::downloadFileNext() {
  if (activeConnect() == false) {
    Serial.println("downloadFileNext - error connect");
    return; //TODO ошибка
  }

  interruptData.isProcessed = true;
  interruptData.answerIndex = 0;
  //-- Compare page size
  // size_t bytesToRead = 0;
  // do {
  //   bytesToRead = ftpDataClient.available();
  // } while (bytesToRead < (size_t)fileDownloadInfo.loadSize);

  // if (activeDataConnect() == false) {
  //   Serial.println("downloadFileNext - error data connect");
  //   return;
  // }

  unsigned long _m = millis();
  while (!ftpDataClient.available() && millis() < _m + timeout) delay(1);
  //ftpDataClient.available();

  //-- Load
  size_t getSize = ftpDataClient.readBytes(interruptData.answerBuffer + 4, fileDownloadInfo.loadSize);
  if (getSize == 0) {
    interruptData.answerCount = 0;
    fileDownloadInfo.answerCount = 0;
  } else {
    uint8_t sum = 0;
    interruptData.answerCount = 5 + (uint8_t)getSize;
    fileDownloadInfo.answerCount = 5 + (uint8_t)getSize;
    //
    //Serial.print("getSize: ");
    //Serial.print(getSize);
    //Serial.print(" addr: ");
    //Serial.println(fileDownloadInfo.addr, HEX);
    //-- Addr 2 byte
    interruptData.answerBuffer[0] = (uint8_t)(fileDownloadInfo.addr & 0x00FF);
    interruptData.answerBuffer[1] = (uint8_t)((fileDownloadInfo.addr & 0xFF00) >> 8);
    sum += interruptData.answerBuffer[0];
    sum += interruptData.answerBuffer[1];
    //-- Progress 1 byte
    uint16_t newAddr = fileDownloadInfo.addr + (uint16_t)getSize;
    fileDownloadInfo.addr = newAddr;
    float progress = (progressCount + 1) * ( ((float)newAddr) / ((float)fileDownloadInfo.fileSize) );
    interruptData.answerBuffer[2] = (uint8_t)progress;
    sum += interruptData.answerBuffer[2];
    //-- Reserved 1 byte 0x3C
    interruptData.answerBuffer[3] = 0x3C;
    sum += 0x3C;
    //-- Chech Summ 1 byte
    for (int i = 0; i < getSize; i++) {
      sum += interruptData.answerBuffer[4 + i];
    }
    interruptData.answerBuffer[4 + getSize] = sum;
    //-- Save buffer
    memcpy(fileDownloadInfo.buffer, interruptData.answerBuffer, 128); 
  }
}

uint8_t FTPClient::deleteFile(int index) {
  if (activeConnect() == false) {
    return 0;
  }

  changeDir(chDir);
  //setTransferMode(BINARY);
  int fileLength = ftpFiles[index].name.length() + 1;
  strncpy(tempName, ftpFiles[index].name.c_str(), fileLength);

  espError.error = ESPErrorValue_None;
  espError.action = ESPErrorAction_FtpDelete;

  ftpClient.print(F("DELE "));
  ftpClient.println(ftpFiles[index].name); //tempName
  getStatus();
}

uint8_t FTPClient::uploadFile(String fileName) {
  if (activeConnect() == false) {
    return 0;
  }

  changeDir(chDir);
  setTransferMode(BINARY);

  ftpClient.print(F("STOR "));
  ftpClient.println(fileName);

  do {
    getStatus();
  } while ( ftpClientResponseCode != 150 && !isCodeError() );

  //Serial.println("uploadFile Start Next");
  uploadCount = 0;
  if (isCodeError() == true) {
    return false;
  } else {
    //ftpDataClient.stop();
    //uploadFileData();
    return true;
  }
//"STOR"
// 150 code 
//ftpDataClient close // end!
}

void FTPClient::noop() {
  if (activeConnect() == false) {
    return;
  }
  ftpDataClient.println(F("NOOP"));
  ftpClient.println(F("NOOP"));
}

void FTPClient::makeDirectory(String dir) {
  if (activeConnect() == false) {
    return;
  }

  changeDir(chDir);
  setTransferMode(BINARY);

  ftpClient.print(F("MKD "));
  ftpClient.println(dir);

  getStatus();
  //550 error
}

uint8_t FTPClient::uploadFileData() {

  uint16_t l =interruptData.buffer[17]; // l
  uint16_t h = interruptData.buffer[18]; // h
  h = h << 8;
  h += l;
  uint8_t isEnd = interruptData.buffer[19]; // isEnd

  size_t bytesSent = ftpDataClient.write(interruptData.buffer, 16);
  uploadCount += bytesSent;

  float progress = (progressCount + 1) * ( ((float)uploadCount) / ((float)h) );
  uploadProgress = (uint8_t)progress;

  if (isEnd == 0x01) {
    ftpDataClient.stop();
  }

  return 0;
}