//
//  AllertOkViewFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef AllertOkViewFunctions_h
#define AllertOkViewFunctions_h

void AllertOkViewShowHL() {
    AllertOkViewTitlePoint = hl;
    CurrentViewChangeAndPushIdA(a = AllertOkViewId);
    push_pop(bc, hl, de) {
        a = AllertOkViewX;
        h = a;
        a = AllertOkViewY;
        l = a;
        a = AllertOkViewDX;
        d = a;
        a = AllertOkViewDY;
        e = a;
        a = AllertOkViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
        
        // Ok Button
        a = AllertOkViewX;
        a += 10; //!
        h = a;
        a = AllertOkViewY;
        a += 4;
        l = a;
        d = 4;
        e = 3;
        ButtonShadowViewShow(bc = StringLocaleOK);
        ButtonShadowViewSelectA(a = 1);
    }
    AllertOkViewShowTitle();
    AllertOkViewLoopKey();
}

void AllertOkViewLoopKey() {
    push_pop(bc) {
        b = 0;
        do {
            getKeyboardCharA();
            c = a;
            if ((a = c) == 0x1B) { //ESC выход
                b = 1;
            } else if ((a = c) == 0x0D) { //Enter
                b = 1;
            }
        } while ((a = b) == 0);
        AllertOkViewClose();
    }
}

void AllertOkViewClose() {
    vboxClose();
    CurrentViewReturn();
}

void AllertOkViewShowTitle() {
    push_pop(hl, de, bc) {
        hl = AllertOkViewTitlePoint;
        b = 0;
        a = AllertOkViewDX;
        c = a;
        do {
            a = *hl;
            d = a;
            hl++;
            if (a > 0) {
                b++;
            }
            if ((a = b) >= c) {
                d = 0;
            }
        } while ((a = d) > 0);
        a = AllertOkViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        b = a;
        a = AllertOkViewX;
        a += b;
        myCharPosX = a;
        a = AllertOkViewY;
        a += 2;
        myCharPosY = a;
        printMyHLStr(hl = AllertOkViewTitlePoint);
    }
}

uint8_t AllertOkViewX = 12;
uint8_t AllertOkViewY = 12;
uint8_t AllertOkViewDX = 24;
uint8_t AllertOkViewDY = 9;
uint8_t AllertOkViewColor = 0x70; // 0x1F;

uint16_t AllertOkViewTitlePoint = 0;

#endif /* AllertOkViewFunctions_h */
