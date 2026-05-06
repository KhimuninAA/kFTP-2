#include "Interrupt.h"

InterruptData interruptData;

void InterruptRead() {
  SerialExpanderDataMode(OUTPUT); //1
  if (interruptData.isProcessed == false) {
    EspEventsExec();
  }
  if (interruptData.answerCount == 0) {
    SerialExpanderSetNoData(true);
  } else {
    uint8_t dataByte = interruptData.answerBuffer[interruptData.answerIndex];
    SerialExpanderWriteGPIOA(dataByte);
    interruptData.answerIndex += 1;
    if (interruptData.answerIndex >= interruptData.answerCount) {
      SerialExpanderSetEndData(true);
    }
  }
  SerialExpanderSetReady(true);
}

void InterruptWrite(uint8_t reg) {
  SerialExpanderDataMode(0); // 0 1
  uint8_t readByte = SerialExpanderReadGPIOA();
  if ((reg & 0x02) == 0x02) { // Begin data (key)
    SerialExpanderSetEndData(false);
    SerialExpanderSetNoData(false);
    interruptData.index = 0;
    interruptData.answerIndex = 0;
    interruptData.isProcessed = false;
    interruptData.answerCount = 0;
    interruptData.key = readByte;
    memset(interruptData.buffer, 0, sizeof(interruptData.buffer));
    memset(interruptData.answerBuffer, 0, sizeof(interruptData.answerBuffer));
  } else {
    interruptData.buffer[interruptData.index] = readByte;
    interruptData.index += 1;
  }
  SerialExpanderSetReady(true);
}

void InterruptIn() {
  SerialExpanderClearInterrupts();
  uint8_t registerByte = SerialExpanderReadGPIOB();
  if ((registerByte & 0x08) == 0x08) { // front interrupt detect
    if ((registerByte & 0x04) == 0x04) { // Read or write
      InterruptWrite(registerByte);
    } else {
      InterruptRead();
    }
    if ((registerByte & 0x01) == 0x01) { // End data
      EspEventsExec();
    }
  }
}