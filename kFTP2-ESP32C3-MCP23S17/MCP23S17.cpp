#include "MCP23S17.h"
#include <Adafruit_MCP23X17.h>

Adafruit_MCP23X17 mcp;
uint8_t esp_cs_pin = 10;

// Время выполнения (мкс): 32
// Время выполнения (мкс): 17
// Время выполнения (мкс): 31
// Время выполнения (мкс): 9
// i8080 NOP -> 2 мкс
void MCP23S17PortBLow() {
  //unsigned long startTime = micros();
  digitalWrite(esp_cs_pin, LOW);
  SPI.transfer(0x40);    // MCP23S17 Write Opcode (Device Addr 0)
  SPI.transfer(0x13);    // GPIOB Register Address
  SPI.transfer(0x00);    // Set all Port B pins HIGH (0xFF)
  digitalWrite(esp_cs_pin, HIGH);
  //unsigned long duration = micros() - startTime;
  //Serial.print("Время выполнения (мкс): ");
  //Serial.println(duration);
}

void IRAM_ATTR handleInterrupt() {
  isInterrupt = true;
}

void MCP23S17RegSettings() {
  mcp.pinMode(MCP23X17_SCK_PIN, INPUT); //INPUT INPUT_PULLUP
  mcp.pinMode(MCP23X17_WRITE_PIN, INPUT); //!!! TEST INPUT_PULLUP
  mcp.pinMode(MCP23X17_BEGIN_PIN, INPUT);
  mcp.pinMode(MCP23X17_END_PIN, INPUT);
  mcp.pinMode(MCP23X17_BUSY_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_READY_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_NODATA_PIN, OUTPUT);
  mcp.pinMode(MCP23X17_ENDDATA_PIN, OUTPUT);

  MCP23S17SetReady(true);
}

bool currentMCP23S17DataMode = 0xFF;
void MCP23S17DataMode(uint8_t mode) {
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

void MCP23S17Init(uint8_t cs_pin) {
  // pinMode(esp_cs_pin, OUTPUT);
  // pinMode(4, OUTPUT);
  // digitalWrite(4, HIGH);  // Turn ON (inverted logic)
  // delay(100);
  // digitalWrite(4, LOW);  // Turn ON (inverted logic)
  // delay(100);
  // digitalWrite(4, HIGH);  // Turn ON (inverted logic)
  // delay(100);
  // digitalWrite(4, LOW);

  esp_cs_pin = cs_pin;
  // ~/Documents/Arduino/libraries/Adafruit_MCP23017_Arduino_Library/src/Adafruit_MCP23XXX.cpp
  if (!mcp.begin_SPI(cs_pin)) {
  //if (!mcp.begin_SPI(cs_pin, 4, 6, 5, 0)) {
    /// Переделать!!!!
    Serial.println("Error.");
    while (1);
  }
  MCP23S17RegSettings();
  MCP23S17DataMode(0); //INPUT INPUT_PULLUP INPUT_PULLDOWN MCP23XXX_GPPU
}

void MCP23S17InterruptPin(uint8_t int_pin) {
  mcp.setupInterrupts(false, false, LOW);
  mcp.setupInterruptPin(MCP23X17_SCK_PIN, CHANGE);
  pinMode(int_pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(int_pin), handleInterrupt, FALLING);
  mcp.clearInterrupts();
}

uint8_t MCP23S17readGPIOA() {
  uint8_t readByte = mcp.readGPIO(MCP23X17_GPIO_A);
  return readByte;
}

void MCP23S17writeGPIOA(uint8_t data) {
  mcp.writeGPIO(data, MCP23X17_GPIO_A);
}

uint8_t MCP23S17readGPIOB() {
  uint8_t readByte = mcp.readGPIO(MCP23X17_GPIO_B);
  return readByte;
}

void MCP23S17SetReady(bool ready) {
  //uint8_t val = (ready == true) ? HIGH : LOW;
  //mcp.digitalWrite(MCP23X17_READY_PIN, val);

  mcp.digitalWrite(MCP23X17_READY_PIN, LOW);
  delayMicroseconds(1);
  mcp.digitalWrite(MCP23X17_READY_PIN, HIGH);
}

void MCP23S17SetBusy(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_BUSY_PIN, val);
}

void MCP23S17SetNoData(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_NODATA_PIN, val);
}

void MCP23S17SetEndData(bool ready) {
  uint8_t val = (ready == true) ? HIGH : LOW;
  mcp.digitalWrite(MCP23X17_ENDDATA_PIN, val);
}

void MCP23S17ClearInterrupts() {
  mcp.clearInterrupts();
  // mcp.digitalWrite(MCP23X17_ENDDATA_PIN, LOW);
  // mcp.digitalWrite(MCP23X17_NODATA_PIN, LOW);
  // mcp.digitalWrite(MCP23X17_BUSY_PIN, LOW);
  // mcp.digitalWrite(MCP23X17_READY_PIN, LOW);
}