#ifndef MCP23S17_H_
#define MCP23S17_H_

#include <Arduino.h> 

extern bool isInterrupt;

#define MCP23X17_GPIO_A 0
#define MCP23X17_GPIO_B 1

/// Сигнал тактирования
#define MCP23X17_SCK_PIN 11 //(ESP GPB pin 0x08 (GPB3->11))
/// Запись в ESP
#define MCP23X17_WRITE_PIN 10 //(ESP GPB pin 0x04 (GPB2->10))
/// Признак начала данных
#define MCP23X17_BEGIN_PIN 9 //(ESP GPB pin 0x02 (GPB1->9))
/// Признак конца данных
#define MCP23X17_END_PIN 8 //(ESP GPB pin 0x01 (GPB0->8))
/// ESP занят
#define MCP23X17_BUSY_PIN 15 //(ESP GPB pin 0x80 (GPB7->15))
/// ESP готов
#define MCP23X17_READY_PIN 14 //(ESP GPB pin 0x40 (GPB6->14))
/// ESP нет данных для передачи
#define MCP23X17_NODATA_PIN 13 //(ESP GPB pin 0x20 (GPB5->13))
/// ESP конец передачи
#define MCP23X17_ENDDATA_PIN 12 //(ESP GPB pin 0x10 (GPB4->12))

void MCP23S17Init(uint8_t cs_pin);
void MCP23S17InterruptPin(uint8_t int_pin);
uint8_t MCP23S17readGPIOA();
uint8_t MCP23S17readGPIOB();
void MCP23S17SetReady(bool ready);
void MCP23S17ClearInterrupts();
void MCP23S17SetBusy(bool ready);
void MCP23S17writeGPIOA(uint8_t data);
void MCP23S17SetNoData(bool ready);
void MCP23S17SetEndData(bool ready);
void MCP23S17DataMode(uint8_t mode);
void MCP23S17PortBLow();

#endif