#include "SerialExpander.h"
#include "EEPROMStore.h"
#include "Interrupt.h"
#include "EspEvents.h"
#include "WIFIMy.h"
#include "FTPClient.h"

FTPClient ftpClientA = FTPClient();

#define CS_PIN 5
#define INT_PIN 26

bool isInterrupt = false;
int loopCount = 0;

//#define USE_DEBUG_MODE

void setup() {
  Serial.begin(115200);
  Serial.println("Start!");

  EEPROMStoreInit();
  EEPROMStoreLoad();

  WIFIInit();
  ftpClientA.goToHomeDir();

  SerialExpanderInit(CS_PIN);
  SerialExpanderInterruptPin(INT_PIN);
  SerialExpanderSetBusy(false);

  #ifdef USE_DEBUG_MODE
    EEPROMStoreTest();
  #endif
}

void loop() {
  if (isInterrupt == true) {
    isInterrupt = false;
    InterruptIn();
  } else {
    loopCount++;
    if (loopCount == 5000) { //32000
      loopCount == 0;
      if (ftpClientA.getFtpDataConnected() == true) {
        ftpClientA.noop();
      }
    }
  }
}
