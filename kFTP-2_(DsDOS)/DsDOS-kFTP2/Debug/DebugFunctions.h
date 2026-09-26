//
//  DebugFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 22.08.2026.
//

#ifndef DebugFunctions_h
#define DebugFunctions_h

void Debug00Start() {
    push_pop(hl, bc, de) {
        Debug00X = (a = 0);
        Debug00Y = (a = 0);

        Debug00CharPrintA(a = 'D');
        Debug00CharPrintA(a = 'e');
        Debug00CharPrintA(a = 'b');
        Debug00CharPrintA(a = 'u');
        Debug00CharPrintA(a = 'g');
        Debug00CharPrintA(a = '-');
        Debug00CharPrintA(a = '>');
    }
}

void Debug00CharPrintA() {
    push_pop(bc, hl) {
        c = a;
        h = (a = Debug00Y);
        l = (a = Debug00X);
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintC);
        Debug00PosIncrement();
    }
}

void Debug00HexPrintA() {
    push_pop(bc, hl) {
        c = a;
        h = (a = Debug00Y);
        l = (a = Debug00X);
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintByteC);
        Debug00PosIncrement();
        Debug00PosIncrement();
    }
}

void Debug00PosIncrement() {
    a = Debug00X; // 48 32
    a++;
    if (a >= 49) {
        Debug00X = (a = 0);
        a = Debug00Y;
        a++;
        if (a >= 33) {
            Debug00Y = (a = 0);
        } else {
            Debug00Y = a;
        }
    } else {
        Debug00X = a;
    }
    
}

uint8_t Debug00X = 0;
uint8_t Debug00Y = 0;

uint8_t DebugRegA = 0;
uint8_t DebugRegB = 0;
uint8_t DebugRegC = 0;
uint8_t DebugRegD = 0;
uint8_t DebugRegE = 0;
uint8_t DebugRegH = 0;
uint8_t DebugRegL = 0;

uint8_t DebugError[] = "Error!";
uint8_t DebugOk[] = "Ok!";

#endif /* DebugFunctions_h */
