//
//  DebugFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DebugFunctions_h
#define DebugFunctions_h

void DebugShowIn00HexA() {
    push_pop(bc, de) {
        b = a;
        a = 0;
        myCharPosX = a;
        a = 0;
        myCharPosY = a;
        printMyHexA(a = b);
    }
}

void DebugFilesCreate() {
    push_pop(bc, de, hl) {
        d = 0;
        e = 1;
        b = 38; //40; //44;
        do {
            hl = DebugFileCreateName;
            hl++;
            a = 0x30;
            a += d;
            *hl = a;
            hl++;
            a = 0x30;
            a += e;
            *hl = a;
            DebugFileCreate();
            //-- Inc
            e++;
            if ((a = e) >= 10) {
                e = 0;
                d++;
            }
            //--
            b--;
        } while ((a = b) > 0);
        //-- Reload disk
        DiskViewReload();
    }
}

void DebugFileCreate() {
    push_pop(bc, de, hl) {
        //-- Set current drive
        a = DiskViewDiskNum;
        ordos_wnd();
        //-- Get new point HL
        ordos_mxdsk();
        //-- write name
        de = DebugFileCreateName;
        b = 16;
        do {
            a = *de;
            ordos_wdisk();
            de++;
            hl++;
            b--;
        } while ((a = b) > 0);
        //-- write data
        b = 17;
        do {
            a = 0xFF;
            ordos_wdisk();
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

/// Деление E на B
/// вх[E, B] - E = делимое, B = делитель
/// вых[E, D] - E = частное, D = остаток
void EDivBToE() {
    push_pop(bc) {
        d = 0; //Очищаем D (здесь будем накапливать остаток)
        c = 8; //Счетчик итераций: 8 бит
        do {
            a = e; //Сдвигаем делимое влево через перенос (CF)
            carry_rotate_left(a, 1);
            e = a;
            
            a = d; //Сдвигаем остаток влево с учетом выдвинутого бита
            carry_rotate_left(a, 1);
            d = a;
            
            a -= b; //Вычитаем делитель из старшей части (остатка)
            
            if (flag_nc) { //Если делитель больше, переходим к следующему шагу
                d = a; //Иначе сохраняем новый остаток
            }
            
            c--; //Уменьшаем счетчик цикла
        } while (flag_nz); //Повторяем 8 раз (JNZ)
        
        // Корректируем частное (инвертируем остаток операции вычитания)
        a = e;
        invert(a);
        e = a;
    }
    return;
}

/// Деление BC / DE
/// вх[BC, DE] - BC - делимое, DE - делитель.
/// вых[BC, DE] - BC - частное, DE - остаток.
void HLDivDEToHL() {
    push_pop(hl) {
        //NEGATE THE DIVISOR
        a = d;
        invert(a);
        d = a;
        a = e;
        invert(a);
        e = a;
        

//        INX D ;FOR TWO'S COMPLEMENT
//        LXI H, 0 ;INITIAL VALUE FOR REMAINDER
//        MVI A, 17 ;INITIALIZE LOOP COUNTER
//        DV0: PUSH H ;SAVE REMAINDER
//        DAD D ;SUBTRACT DIVISOR (ADD NEGATIVE)
//        JNC DV1 ;UNDER FLOW, RESTORE HL
//        XTHL
//        DV1: POP H
//        PUSH PSW ;SAVE LOOP COUNTER (A)
//        MOV A, C ;4 REGISTER LEFT SHIFT WITH CARRY CY->C->B->L->H
//        RAL
//        MOV C, A
//        MOV A, B
//        RAL
//        MOV B, A
//        MOV A, L
//        RAL
//        MOV L, A
//        MOV A, H
//        RAL
//        MOV H, A
//        POP PSW ;RESTORE LOOP COUNTER (A)
//        DCR A ;DECREMENT IT
//        JNZ DV0 ;KEEP LOOPING
//        ;POST-DIVIDE CLEAN UP
//        ;SHIFT REMAINDER RIGHT AND RETURN IN DE
//        ORA A
//        MOV A, H
//        RAR
//        MOV D, A
//        MOV A, L
//        RAR
//        MOV E, A
    }
}

/// Умножение HL на 10 (HL = HL * 10)
void MulHLx10() {
    push_pop(de) { // Сохраняем DE
        d = h; // DE = HL
        e = l;
        
        hl += hl; // HL = HL * 2
        
        d = h; // DE = HL (HL * 2)
        e = l;
        
        hl += hl; // HL = HL * 4
        hl += hl; // HL = HL * 8
        
        hl += de; // (HL * 8) + (HL * 2)
    }
}

uint8_t DebugFileCreateName[] = {0x54, 0x30 , 0x30 , 0x24 , 0x20 , 0x20 , 0x20 , 0x20 , 0x00 , 0x10 , 0x10 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00};

#endif /* DebugFunctions_h */
