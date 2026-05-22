#ifndef EVENT_EXT_H_
#define EVENT_EXT_H_

#include "FTPClient.h"
#include "Interrupt.h"

void ftpFileToBuffer();
void createStatusToBuffer();
void createBufferByString(String data);
void EventsExt_UploadAnswer(bool isCorrect, uint8_t progress);
bool EventsExt_VerifyAnswerBufferSum(int from, int count);
void EventsExt_Disk_Request();
void EventsExt_Disk_Response();

#endif