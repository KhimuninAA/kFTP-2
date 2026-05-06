#ifndef EVENT_EXT_H_
#define EVENT_EXT_H_

#include "FTPClient.h"
#include "Interrupt.h"

void ftpFileToBuffer();
void createStatusToBuffer();
void createBufferByString(String data);

#endif