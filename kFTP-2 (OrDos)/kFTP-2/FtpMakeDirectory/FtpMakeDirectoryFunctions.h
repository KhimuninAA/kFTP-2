//
//  FtpMakeDirectoryFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 04.05.2026.
//

#ifndef FtpMakeDirectoryFunctions_h
#define FtpMakeDirectoryFunctions_h

void FtpMakeDirectoryShow() {
    CurrentViewChangeAndPushIdA(a = FtpMakeDirectoryId);
    push_pop(bc, hl, de) {
        a = FtpMakeDirectoryX;
        h = a;
        a = FtpMakeDirectoryY;
        l = a;
        a = FtpMakeDirectoryDX;
        d = a;
        a = FtpMakeDirectoryDY;
        e = a;
        a = FtpMakeDirectoryColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
    FtpMakeDirectoryInitValue();
    FtpMakeDirectoryShowTitle();
    FtpMakeDirectoryShowValue();
    FtpMakeDirectorySelectLineA(a = 1);
}

void FtpMakeDirectoryInitValue() {
    a = 0;
    FtpMakeDirectorySelectPos = a;
    // Value
    a = 'N';
    FtpMakeDirectoryValue[0] = a;
    a = 'e';
    FtpMakeDirectoryValue[1] = a;
    a = 'w';
    FtpMakeDirectoryValue[2] = a;
    a = 0;
    FtpMakeDirectoryValue[3] = a;
}

void FtpMakeDirectoryShowTitle() {
    push_pop(hl, bc, de) {
        // Title
        a = FtpMakeDirectoryX;
        a += 3;
        myCharPosX = a;
        a = FtpMakeDirectoryY;
        a += 1; //2;
        myCharPosY = a;
        printMyHLStr(hl = FtpMakeDirectoryTitle);
        // LINE!!!
        a = FtpMakeDirectoryX;
        a += 1;
        myCharPosX = a;
        a = FtpMakeDirectoryY;
        a += 2;
        myCharPosY = a;
        a = FtpMakeDirectoryDX;
        a -= 2;
        b = a;
        do {
            printMyCharA(a = 0x5F);
            b--;
        } while ((a = b) > 0);
        // DIRECTORY
        // Button
        bc = StringLocaleOK;
        
        d = 8; //13
        e = 3;
        a = FtpMakeDirectoryX;
        a += 6;
        h = a;
        a = FtpMakeDirectoryY;
        a += 7;
        l = a;
        ButtonShadowViewShow();
    }
}

void FtpMakeDirectoryShowValue() {
    push_pop(hl, bc) {
        // Directory
        a = FtpMakeDirectoryX;
        a += 2;
        myCharPosX = a;
        a = FtpMakeDirectoryY;
        a += 4;
        c = a; // Y
        myCharPosY = a;
        a = 16;
        printMyHLStrLenA(hl = FtpMakeDirectoryValue);
    }
}

/// вых [HL] -
/// вых [DE]-
void FtpMakeDirectoryByPosBoxValue() {
    push_pop(bc) {
        a = FtpMakeDirectoryX;
        a += 2;
        h = a;
        a = FtpMakeDirectoryY;
        a += 4;
        l = a;
        // DE
        a = 16;
        d = a;
        a = 1;
        e = a;
    }
}

/// вых [BC] -
void FtpMakeDirectoryByPosValue() {
    bc = FtpMakeDirectoryValue;
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpMakeDirectorySelectLineA() {
    push_pop(bc, hl, de) {
        c = a;
        // 0 - Button
        if ((a = FtpMakeDirectorySelectPos) == 0) {
            ButtonShadowViewSelectA(a = c);
        } else {
            FtpMakeDirectoryByPosBoxValue();
            // C
            if ((a = c) == 0) {
                a = FtpMakeDirectoryColor;
            } else {
                a = FtpMakeDirectoryInvColor;
            }
            c = a;
            // A
            a = vboxUMP;
            vboxOpenHLDECA();
        }
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void FtpMakeDirectoryPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            FtpMakeDirectorySelectLineA(a = 1);
        } else {
            a = 2;
            c = a;
            FtpMakeDirectorySelectLineA(a = 0);
            a = FtpMakeDirectorySelectPos;
            a += b;
            b = a;
            //-- FIX
            if ((a = b) == 0xFF) {
                a = c;
                a--;
            } else if ((a = b) == c) {
                a = 0;
            }
            //--
            FtpMakeDirectorySelectPos = a;
            FtpMakeDirectorySelectLineA(a = 1);
        }
    }
}

void FtpMakeDirectoryClose() {
    vboxClose();
    CurrentViewReturn();
}

void FtpMakeDirectoryKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == FtpMakeDirectoryId) {
            if ((a = l) == 0x1B) { //ESC выход
                FtpMakeDirectoryClose();
            } else if ((a = l) == 0x0D) { // Выбор
                if ((a = FtpMakeDirectorySelectPos) == 0) { // OK
                    FtpMakeDirectoryClose();
                    #ifdef _IS_SIMULATOR
                    #else
                        NetFtpMakeDirectory();
                        ThreadsTickNow();
                    #endif
                } else { // Переход в редактирование
                    FtpMakeDirectoryByPosBoxValue();
                    FtpMakeDirectoryByPosValue();
                    EditFieldViewShow();
                    if (a == 1) { // что то изменилось
                        FtpMakeDirectoryShowValue();
                    }
                }
            } else if ((a = l) == 0x1A) { //down
                FtpMakeDirectoryPosUpdateA(a = 0x01);
            } else if ((a = l) == 0x19) { //up
                FtpMakeDirectoryPosUpdateA(a = 0xFF);
            }
        }
    }
}

uint8_t FtpMakeDirectoryX = 14;
uint8_t FtpMakeDirectoryY = 11;
uint8_t FtpMakeDirectoryDX = 20;
uint8_t FtpMakeDirectoryDY = 12;
uint8_t FtpMakeDirectoryColor = 0x70;
uint8_t FtpMakeDirectoryInvColor = 0x07;

uint8_t FtpMakeDirectoryTitle[] = "Make directory";
uint8_t FtpMakeDirectoryValue[16] = "New";

uint8_t FtpMakeDirectorySelectPos = 0;

#endif /* FtpMakeDirectoryFunctions_h */
