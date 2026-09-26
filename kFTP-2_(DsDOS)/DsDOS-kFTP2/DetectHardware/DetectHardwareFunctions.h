//
//  DetectHardwareFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 25.09.2026.
//

#ifndef DetectHardwareFunctions_h
#define DetectHardwareFunctions_h

#include "DetectHardwareESP/DetectHardwareESPFunctions.h"

/// a  = 0; - Нет платы
/// a = 1;  - Есть плата и версия в
void DetectHardwareVersion() {
    DetectHardwareGetBoardID();
    if ((a = ESPError) == 0) {
        a = 1;
    } else {
        a = 0;
    }
}

void DetectHardwareGetBoardID() {
    push_pop(hl, bc, de) {
        h = 0; // GET_BoardID = 0,
        l = 0; // Len NedBuffer
        DetectHardwareESPSendAndGetHL();
        //--
        // l - длина Net_buffer - буфер
        b = l;
        b--;
        c = 0; // Сумма
        d = 0; // Последний байт
        hl = Net_buffer;
        do {
            a = *hl;
            //a = *hl;
            d = a;
            a = *hl;
            a += c;
            c = a;
            hl++;
            b--;
        } while ((a = b) > 0);
        // Если контроьная сумма не совпала
        if ((a = *hl) != c) {
            ESPError = (a = ESPError_Response);
        }
        // Если последный байт не 0x3C
        if ((a = d) != 0x3C) {
            ESPError = (a = ESPError_Response);
        }
    }
}

#endif /* DetectHardwareFunctions_h */
