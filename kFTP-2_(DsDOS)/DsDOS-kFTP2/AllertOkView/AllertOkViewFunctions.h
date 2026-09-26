//
//  AllertOkViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 29.08.2026.
//

#ifndef AllertOkViewFunctions_h
#define AllertOkViewFunctions_h

void AllertOkViewShowHL() {
    AllertOkViewTitlePoint = hl;
    CurrentViewChangeAndPushIdA(a = AllertOkViewId);
    push_pop(bc, hl, de) {
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = AllertOkViewColor);
        l = (a = AllertOkViewX);
        h = (a = AllertOkViewY);
        e = (a = AllertOkViewDX);
        d = (a = AllertOkViewDY);
        bios(a = biosWindowSafeOpen);
        MyFuncSetFullScreen();
        
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
    bios(a = biosWindowSafeClose);
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
        l = a;
        a = AllertOkViewY;
        a += 2;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = AllertOkViewTitlePoint);
    }
}

uint8_t AllertOkViewX = 12;
uint8_t AllertOkViewY = 12;
uint8_t AllertOkViewDX = 24;
uint8_t AllertOkViewDY = 9;
uint8_t AllertOkViewColor = 0x70; // 0x1F;

uint16_t AllertOkViewTitlePoint = 0;

#endif /* AllertOkViewFunctions_h */
