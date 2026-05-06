#include "ESPErrorData.h"

ESPErrorData espError;

void ESPErrorData_FtpResponseCode(int16_t code) {
  if (espError.action == ESPErrorAction_FtpDelete) {
    //550 Окончательный отрицательный ответ: файл не найден, файл недоступен или у вас нет необходимых прав для его удаления
    if (code == 550) {
      espError.error = ESPErrorValue_FtpDeleteFileError;
    } else if (code == 150) { // 150 (Data connection opening)
      espError.error = ESPErrorValue_FtpDataConnectionOpening;
    }
  }
}

void ESPErrorData_Clear() {
  espError.error = ESPErrorValue_None;
  espError.action = ESPErrorAction_None;
}