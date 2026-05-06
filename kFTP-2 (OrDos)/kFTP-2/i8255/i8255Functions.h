//
//  i8255Functions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef i8255Functions_h
#define i8255Functions_h

void i8255Init() {
    
}

void i8255PortAOut() {
    a = i8255SETUPPortAOut;
    i8255_SETUP = a;
}

void i8255_WaitingForReady() {
    push_pop(bc) {
        b = 0;
        do {
            a = i8255_PORT_C;
            a &= ESP_Reg_Ready;
            c = a;
            #ifdef _IS_ESP_DELAY
                if ((a = c) == 0) {
                    i8255_DelayA(a = 1); //5 200
                    b++;
                    if ((a = b) >= 100) { //253
                        c = ESP_Reg_Ready;
                        a = ESPError_TimeOut;
                        ESPError = a;
                    }
                }
            #endif
        } while ((a = c) == 0);
    }
}

/// Проверка что ESP занят
void i8255_WaitingForBusy() {
    do {
        a = i8255_PORT_C;
        a &= ESP_Reg_Busy;
    } while (a > 0);
}

void i8255PortAIn() {
    a = i8255SETUPPortAIn;
    i8255_SETUP = a;
}

/// Сигнал Clock
/// A include IsWrite, IsBegin, IsEnd
/// A = 1 - Write
void i8255_SckIsWriteA() {
    a |= ESP_Reg_Sck;
    i8255_PORT_C = a;
    #ifdef _IS_ESP_DELAY
        i8255_DelayA(a = 1); //20 40
    #endif
}

void i8255_Sck0() {
    a = 0;
    i8255_PORT_C = a;
    #ifdef _IS_ESP_DELAY
        i8255_DelayA(a = 1); //20 40
    #endif
}

void i8255_DelayA() {
    do {
        nop();
        a--;
    } while (a > 0);
}

void i8255_ReadReg() {
    a = i8255_PORT_C;
}

void i8255_ReadData() {
    a = i8255_PORT_A;
}

void i8255_WriteData() {
    i8255_PORT_A = a;
}

uint8_t i8255_PortA_IsOut = 1;

#endif /* i8255Functions_h */
