#include "SerialExpander.h"
#include <Adafruit_MCP23X17.h>

Adafruit_MCP23X17 mcp;

void IRAM_ATTR handleInterrupt() {
  isInterrupt = true;
}

void SerialExpanderInit(uint8_t cs_pin) {
  // ~/Documents/Arduino/libraries/Adafruit_MCP23017_Arduino_Library/src/Adafruit_MCP23XXX.cpp
  if (!mcp.begin_SPI(cs_pin)) {
    Serial.println("Error.");
  }
  SerialExpanderRegSettings();
  SerialExpanderDataMode(0);
}

void SerialExpanderRegSettings() {
  mcp.pinMode(MCP23X17_SCK_PIN, INPUT); //INPUT INPUT_PULLUP
  mcp.pinMode(MCP23X17_WRITE_PIN, INPUT); //!!! TEST INPUT_PULLUP
  mcp.pinMode(MCP23X17_BEGIN_PIN, INPUT);
  mcp.pinMode(MCP23X17_END_PIN, INPUT);
  mcp.pinMode(MCP23X17_BUSY_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_READY_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_NODATA_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_ENDDATA_PIN, OUTPUT);

  SerialExpanderSetReady(true);
}

void SerialExpanderInterruptPin(uint8_t int_pin) {
  mcp.setupInterrupts(false, false, LOW);
  mcp.setupInterruptPin(MCP23X17_SCK_PIN, CHANGE);
  pinMode(int_pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(int_pin), handleInterrupt, FALLING);
  mcp.clearInterrupts();
}

void SerialExpanderSetBusy(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_BUSY_PIN, val);
}

void SerialExpanderSetReady(bool ready) {
  mcp.digitalWrite(MCP23X17_READY_PIN, LOW);
  delayMicroseconds(1);
  mcp.digitalWrite(MCP23X17_READY_PIN, HIGH);
}

uint8_t SerialExpanderReadGPIOB() {
  uint8_t readByte = mcp.readGPIO(MCP23X17_GPIO_B);
  return readByte;
}

uint8_t SerialExpanderReadGPIOA() {
  uint8_t readByte = mcp.readGPIO(MCP23X17_GPIO_A);
  return readByte;
}

void SerialExpanderWriteGPIOA(uint8_t data) {
  mcp.writeGPIO(data, MCP23X17_GPIO_A);
}

bool currentMCP23S17DataMode = 0xFF;
//0 = output , 1 = input
void SerialExpanderDataMode(uint8_t mode) {
  if (currentMCP23S17DataMode == mode) {
    return;
  }
  currentMCP23S17DataMode = mode;
  for(uint8_t i = 0; i < 8; i++) {
    mcp.pinMode(i, mode);
  }
  //INPUT              0x01
  //OUTPUT            0x03
}

void SerialExpanderSetNoData(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_NODATA_PIN, val);
}

void SerialExpanderSetEndData(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_ENDDATA_PIN, val);
}

void SerialExpanderClearInterrupts() {
  mcp.clearInterrupts();
}