#include "EventsExt.h"

extern InterruptData interruptData;
extern FTPClient ftpClientA;
extern ESPErrorData espError;
extern bool WIFIflag;

bool EventsExt_VerifyAnswerBufferSum(int from, int count) {
  //interruptData.index
  uint8_t sum = 0;
  for (int i = from; i < (count + from); i++) {
    sum += interruptData.buffer[i];
  }
  if (interruptData.buffer[count] == sum) {
    return true;
  } else {
    return false;
  }
}

//b = 0x3C, b = isCorrect, b = progress, b = sum
void EventsExt_UploadAnswer(bool isCorrect, uint8_t progress) {
  uint8_t sum = 0;
  interruptData.answerBuffer[0] = 0x3C;
  if (isCorrect == true) {
    interruptData.answerBuffer[1] = 1;
  } else {
    interruptData.answerBuffer[1] = 0;
  }
  interruptData.answerBuffer[2] = progress;
  //-- SUM
  sum += interruptData.answerBuffer[0];
  sum += interruptData.answerBuffer[1];
  sum += interruptData.answerBuffer[2];
  interruptData.answerBuffer[3] = sum;
}

void createBufferByString(String data) {
  int length = data.length() + 1;
  uint8_t sum = 0;
  data.toCharArray((char*)interruptData.answerBuffer, length);
  for(int i = 0; i < length; i++) {
    sum += interruptData.answerBuffer[i];
  }
  interruptData.answerBuffer[length] = 0x3C;
  sum += 0x3C;
  interruptData.answerBuffer[length + 1] = sum;
  interruptData.answerCount = length + 2;
}

void createStatusToBuffer() {
  interruptData.isProcessed = true;
  uint8_t sum = 0;
  updateStatus();
  interruptData.answerBuffer[0] = 0x3C;
  if(WIFIflag == true) {
    interruptData.answerBuffer[1] = 1;
  } else {
    interruptData.answerBuffer[1] = 0;
  }
  if (ftpClientA.getFtpDataConnected() == true) {
    interruptData.answerBuffer[2] = 1;
  } else {
    interruptData.answerBuffer[2] = 0;
  }
  interruptData.answerBuffer[3] = (uint8_t)espError.error;
  //--
  sum += interruptData.answerBuffer[0];
  sum += interruptData.answerBuffer[1];
  sum += interruptData.answerBuffer[2];
  sum += interruptData.answerBuffer[3];
  //--
  interruptData.answerBuffer[4] = sum;
  interruptData.answerCount = 5;
  interruptData.answerIndex = 0;
}

void ftpFileToBuffer() {
  char tempName[36];
  FtpFileData file = ftpClientA.ftpFiles[ftpClientA.ftpFilesSendCount];
  memset(interruptData.answerBuffer, 0, 16);
  // Name 8 byte
  file.name.toCharArray(tempName , 34);
  int pos = 0;
  uint8_t c;
  uint8_t sum = 0;
  for (int i = 0; i < 34; i++) {
    c = tempName[i];
    if (c < 0x80) {
      interruptData.answerBuffer[pos] = c;
      sum += c;
      pos ++;
      if (c == 0x00) {
        break;
      }
    } else if (c == 0xD0) {
      i++;
      c = tempName[i];
      c -= 0x10;
      interruptData.answerBuffer[pos] = c;
      sum += c;
      pos ++;
    } else if (c == 0xD1) {
      i++;
      c = tempName[i];
      c += 0x60;
      interruptData.answerBuffer[pos] = c;
      sum += c;
      pos ++;
    }
    if (pos >= 8) {
      break;
    }
  }
  //-- Size
  int fileSize = file.size;
  if (fileSize > 0xFFFF) {
    fileSize = 0xFFFF;
  }
  uint16_t dbSize = (uint16_t)fileSize;
  interruptData.answerBuffer[9] = (uint8_t)(dbSize & 0x00FF);
  sum += interruptData.answerBuffer[9];
  interruptData.answerBuffer[8] = (uint8_t)((dbSize & 0xFF00) >> 8);
  sum += interruptData.answerBuffer[8];
  //-- isDir
  uint8_t isDirByte = (file.isDir == true) ? 0x01 : 0x00;
  isDirByte += 0x3C;
  interruptData.answerBuffer[10] = isDirByte;
  sum += isDirByte;
  //-- Date
  if (file.date.length() >= 8) {
    //"20171211171525"
    String date = file.date.substring(0, 8);
    //"20171211"
    uint16_t gggg = (uint16_t)date.substring(0, 4).toInt();
    interruptData.answerBuffer[11] = (uint8_t)((gggg & 0xFF00) >> 8);
    sum += interruptData.answerBuffer[11];
    interruptData.answerBuffer[12] = (uint8_t)(gggg & 0x00FF);
    sum += interruptData.answerBuffer[12];
    uint8_t mm = (uint8_t)date.substring(4, 6).toInt();
    interruptData.answerBuffer[13] = mm;
    sum += mm;
    uint8_t dd = (uint8_t)date.substring(6, 8).toInt();
    interruptData.answerBuffer[14] = dd;
    sum += dd;
  } else {
    interruptData.answerBuffer[11] = 0;
    interruptData.answerBuffer[12] = 0;
    interruptData.answerBuffer[13] = 0;
    interruptData.answerBuffer[14] = 0;
  }
  //--
  interruptData.answerBuffer[15] = sum;
}