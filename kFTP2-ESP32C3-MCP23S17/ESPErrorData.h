#ifndef ESP_ERROR_DATA_H_
#define ESP_ERROR_DATA_H_

#include <Arduino.h> 

enum ESPError_Action {
  ESPErrorAction_None = 0,
  ESPErrorAction_FtpDelete = 1,
};

enum ESPError_Value {
  ESPErrorValue_None = 0,
  ESPErrorValue_FtpDeleteFileError = 1,
  ESPErrorValue_FtpConnectError, // 2
  ESPErrorValue_WiFiConnectError, // 3
  ESPErrorValue_FtpDataConnectionOpening, // 4
};

struct ESPErrorData {
  ESPError_Action action;
  ESPError_Value error;
};

void ESPErrorData_FtpResponseCode(int16_t code);
void ESPErrorData_Clear();

#endif