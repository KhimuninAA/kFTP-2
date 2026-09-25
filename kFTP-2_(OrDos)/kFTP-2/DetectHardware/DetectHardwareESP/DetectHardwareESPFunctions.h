//
//  DetectHardwareESPFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 25.09.2026.
//

#ifndef DetectHardwareESPFunctions_h
#define DetectHardwareESPFunctions_h

void DetectHardwareESPSendAndGetHL() {
    ESPErrorClear();
    push_pop(bc, de) {
        //-- Send Key
        c = ESP_Reg_IsBegin;
        DetectHardwareESPSendByteAC(a = h);
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
                    DetectHardwareESPSendByteAC(a = *hl);
                    hl++;
                    b--;
                } while ((a = b) > 0);
            }
            //-- Get Data
            b = 0;
            hl = Net_buffer;
            c = 1;
            do {
                DetectHardwareESPGetByteAD(); // a - data d - reg
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
                    *hl = (a = e);
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

void DetectHardwareESPGetByteAD() {
    push_pop(hl, bc) {
        // Проверим - не занят ли ESP
        DetectHardwareESPWaitingForBusy();
        // A на вход
        i8255PortAIn();
        // Послать сигнал что готовы к данным
        i8255_SckIsWriteA(a = 0);
        // Ждем данные
        DetectHardwareESPWaitingForReady();
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

void DetectHardwareESPSendByteAC() {
    push_pop(bc) {
        b = a;
        // Проверим - не занят ли ESP
        DetectHardwareESPWaitingForBusy();
        // A на выход
        i8255PortAOut();
        // Установить A в порт A
        i8255_WriteData(a = b);
        // Послать сигнал что данные готовы
        a = ESP_Reg_IsWrite;
        a |= c;
        i8255_SckIsWriteA();
        // Ждем подтверждения
        DetectHardwareESPWaitingForReady();
        //
        i8255_Sck0();
    }
}

/// Проверка что ESP занят
void DetectHardwareESPWaitingForBusy() {
    DetectHardwareESPErrorInitHL(hl = 30000);
    push_pop(bc) {
        do {
            a = i8255_PORT_C;
            a &= ESP_Reg_Busy;
            if (a > 0) {
                c = 0;
            } else {
                c = 1;
            }
            DetectHardwareESPErrorStep();
        } while ((a = c) == 0);
    }
}

void DetectHardwareESPWaitingForReady() {
    DetectHardwareESPErrorInitHL(hl = 30000);
    push_pop(bc) {
        b = 0;
        do {
            a = i8255_PORT_C;
            a &= ESP_Reg_Ready;
            c = a;
            DetectHardwareESPErrorStep();
        } while ((a = c) == 0);
    }
}

void DetectHardwareESPErrorInitHL() {
    DetectHardwareESPErrorStepCount = hl;
}

void DetectHardwareESPErrorStep() {
    push_pop(hl) {
        hl = DetectHardwareESPErrorStepCount;
        // Compare hl == 0
        a = h;
        a |= l;
        if (a == 0) {
            //-- Error!!! --
            ESPError = (a = ESPError_TimeOut);
            c = 1;
        } else {
            hl--;
        }
        DetectHardwareESPErrorStepCount = hl;
    }
}

uint16_t DetectHardwareESPErrorStepCount = 0;

#endif /* DetectHardwareESPFunctions_h */
