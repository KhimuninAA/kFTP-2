//
//  ESPInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef ESPInclude_h
#define ESPInclude_h

const uint8_t ESPError_No = 0x00;
const uint8_t ESPError_TimeOut = 0x01;

/// Сигнал тактирования
#define ESP_Reg_Sck 0x10; //(ESP GPB pin 0x08 (GPB3->11))
/// Запись в ESP
#define ESP_Reg_IsWrite 0x20; //(ESP GPB pin 0x04 (GPB2->10))
/// Признак начала данных
#define ESP_Reg_IsBegin 0x40; //(ESP GPB pin 0x02 (GPB1->9))
/// Признак конца данных
#define ESP_Reg_IsEnd 0x80; //(ESP GPB pin 0x01 (GPB0->8))

/// ESP занят
#define ESP_Reg_Busy 0x01; //(ESP GPB pin 0x80 (GPB7->15))
/// ESP готов
#define ESP_Reg_Ready 0x02; //(ESP GPB pin 0x40 (GPB6->14))
/// ESP нет данных для передачи
#define ESP_Reg_In_NoData 0x04; //(ESP GPB pin 0x20 (GPB5->13))
/// ESP конец передачи
#define ESP_Reg_In_IsEnd 0x08; //(ESP GPB pin 0x10 (GPB4->12))

extern uint8_t ESPError;

/// C = 0, ESP_Reg_IsBegin or ESP_Reg_IsEnd
void ESPSendByteAC();
/// h = key
/// l = len buffer
void ESPSendHL();
/// [вх] h = key
/// [вх] l = len buffer
/// [вых] l = len buffer
void ESPSendAndGetHL();
void ESPErrorClear();

#endif /* ESPInclude_h */
