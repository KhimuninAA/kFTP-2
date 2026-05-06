//
//  ESPFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef ESPFunctions_h
#define ESPFunctions_h

/// C = 0, ESP_Reg_IsBegin or ESP_Reg_IsEnd
void ESPSendByteAC() {
    push_pop(bc) {
        b = a;
        // Проверим - не занят ли ESP
        i8255_WaitingForBusy();
        // A на выход
        i8255PortAOut();
        // Установить A в порт A
        i8255_WriteData(a = b);
        // Послать сигнал что данные готовы
        a = ESP_Reg_IsWrite;
        a |= c;
        i8255_SckIsWriteA();
        // Ждем подтверждения
        i8255_WaitingForReady();
        //
        i8255_Sck0();
    }
}

/// A - Data
/// D - Register
void ESPGetByteAD() {
    push_pop(bc) {
        // Проверим - не занят ли ESP
        i8255_WaitingForBusy();
        // A на вход
        i8255PortAIn();
        // Послать сигнал что готовы к данным
        i8255_SckIsWriteA(a = 0);
        // Ждем данные
        i8255_WaitingForReady();
        // Читаем данные
        i8255_ReadData();
        b = a;
        // Читаем регистр
        i8255_ReadReg();
        d = a;
        //
        i8255_Sck0();
        //
        a = b;
    }
}

/// h = key
/// l = len buffer
void ESPSendHL() {
    ESPErrorClear();
    push_pop(bc, hl) {
        //-- Send Key
        c = ESP_Reg_IsBegin;
        if ((a = l) == 0) {
            a = c;
            a |= ESP_Reg_IsEnd;
            c = a;
        }
        ESPSendByteAC(a = h);
        if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
            //-- Send Data
            if ((a = l) > 0) {
                b = l;
                hl = Net_buffer;
                do {
                    if ((a = b) == 1) {
                        c = ESP_Reg_IsEnd;
                    } else {
                        c = 0;
                    }
                    ESPSendByteAC(a = *hl);
                    if ((a = ESPError) > 0) { // Есть ошибки - выходим
                        b = 1;
                    }
                    hl++;
                    b--;
                } while ((a = b) > 0);
            }
        }
    }
}

/// [вх] h = key
/// [вх] l = len buffer
/// [вых] l = len buffer
void ESPSendAndGetHL() {
    ESPErrorClear();
    push_pop(bc, de) {
        //-- Send Key
        c = ESP_Reg_IsBegin;
        ESPSendByteAC(a = h);
        if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
            //-- Send Data
            if ((a = l) > 0) {
                b = l;
                hl = Net_buffer;
                do {
                    if ((a = b) == 1) {
                        c = ESP_Reg_IsEnd;
                    } else {
                        c = 0;
                    }
                    ESPSendByteAC(a = *hl);
                    hl++;
                    b--;
                } while ((a = b) > 0);
            }
            //-- Get Data
            b = 0;
            hl = Net_buffer;
            c = 1;
            do {
                ESPGetByteAD(); // a - data d - reg
                e = a;
                //ESP_Reg_In_IsEnd
                //a = ESP_Reg_In_NoData + ESP_Reg_In_IsEnd;
                a = ESP_Reg_In_NoData;
                a &= d;
                if (a == 0) {
                    a = ESP_Reg_In_IsEnd;
                    a &= d;
                    if (a > 0) {
                        c = 0;
                    }
                    a = e;
                    *hl = a;
                    hl++;
                    b++;
                    if ((a = b) == 0xFF) {
                        c = 0;
                    }
                } else {
                    c = 0;
                }
            } while ((a = c) == 1);
            l = b;
        }
    }
}

void ESPErrorClear() {
    a = ESPError_No;
    ESPError = a;
}

uint8_t ESPError = 0;

#endif /* ESPFunctions_h */
