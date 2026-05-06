#include "MCP23S17.h"
#include "Interrupt.h"
#include "EEPROMStore.h"
#include "EspEvents.h"
#include "WIFIMy.h"
#include "FTPClient.h"

FTPClient ftpClientA = FTPClient();

#define CS_PIN 10
#define INT_PIN 8 //9

bool isInterrupt = false;

void setup() {
  Serial.begin(115200); //115200 9600
  Serial.println("Start!");

  EEPROMStoreInit();
  EEPROMStoreLoad();

  WIFIInit();
  ftpClientA.goToHomeDir();

  MCP23S17Init(CS_PIN);
  MCP23S17InterruptPin(INT_PIN);
  MCP23S17SetBusy(false);
  disableCore0WDT();
}

void loop() {
  if (isInterrupt == true) {
    //MCP23S17PortBLow();
    isInterrupt = false;
    InterruptIn();
  }
  //Serial.println("loop");
  //delay(10); 
}
