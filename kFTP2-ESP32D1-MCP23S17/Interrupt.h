#ifndef INTERRUPT_H_
#define INTERRUPT_H_

#include "SerialExpander.h"
#include "EspEvents.h"

struct InterruptData {
  uint8_t key;
  uint8_t buffer[256];
  uint8_t index;
  uint8_t answerBuffer[256];
  uint8_t answerIndex;
  uint8_t answerCount;
  bool isProcessed;
};

void InterruptIn();

#endif