#include "Interrupt.h"

InterruptData interruptData;

void InterruptRead() {
  MCP23S17DataMode(OUTPUT); //3 OUTPUT
  if (interruptData.isProcessed == false) {
    EspEventsExec();
  }
  if (interruptData.answerCount == 0) {
    MCP23S17SetNoData(true);
  } else {
    uint8_t dataByte = interruptData.answerBuffer[interruptData.answerIndex];
    MCP23S17writeGPIOA(dataByte);
    interruptData.answerIndex += 1;
    if (interruptData.answerIndex >= interruptData.answerCount) {
      MCP23S17SetEndData(true);
    }
  }
  MCP23S17SetReady(true);
}

void InterruptWrite(uint8_t reg) {
  MCP23S17DataMode(0); //0 1 6 INPUT_PULLUP INPUT INPUT_PULLDOWN
  uint8_t readByte = MCP23S17readGPIOA();
  if ((reg & 0x02) == 0x02) { // Begin data (key)
    MCP23S17SetEndData(false);
    MCP23S17SetNoData(false);
    interruptData.index = 0;
    interruptData.answerIndex = 0;
    interruptData.isProcessed = false;
    interruptData.answerCount = 0;
    interruptData.key = readByte;
  } else {
    interruptData.buffer[interruptData.index] = readByte;
    interruptData.index += 1;
  }
  MCP23S17SetReady(true);
}

void InterruptIn() {
  MCP23S17ClearInterrupts();
  uint8_t registerByte = MCP23S17readGPIOB();
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
