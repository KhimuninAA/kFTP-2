//
//  i8255Include.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef i8255Include_h
#define i8255Include_h

const uint8_t i8255SETUPPortAOut = 0x81;
const uint8_t i8255SETUPPortAIn = 0x91;

extern uint16_t i8255_SETUP __address(0xF603);
extern uint16_t i8255_PORT_C __address(0xF602);
extern uint16_t i8255_PORT_A __address(0xF600);

extern uint8_t i8255_PortA_IsOut;

void i8255Init();
void i8255PortAOut();
void i8255PortAIn();

void i8255_ReadReg();
void i8255_ReadData();
void i8255_WriteData();

/// Сигнал Clock
/// A = 0 - Read
/// A = 1 - Write
void i8255_SckIsWriteA();
void i8255_Sck0();
void i8255_WaitingForReady();
/// Проверка что ESP занят
void i8255_WaitingForBusy();

void i8255_DelayA();

#endif /* i8255Include_h */
