//
//  AllertYesNoViewFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef AllertYesNoViewFunctions_h
#define AllertYesNoViewFunctions_h

void AllertYesNoViewShowHL() {
    AllertYesNoViewTitlePoint = hl;
    CurrentViewChangeAndPushIdA(a = AllertYesNoViewId);
    a = 0;
    AllertYesNoViewReturnValue = a;
    a = 0;
    AllertYesNoViewPos = a;
    push_pop(bc, hl, de) {
        a = AllertYesNoViewX;
        h = a;
        a = AllertYesNoViewY;
        l = a;
        a = AllertYesNoViewDX;
        d = a;
        a = AllertYesNoViewDY;
        e = a;
        a = AllertYesNoViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
        
        // NO Button
        a = AllertYesNoViewX;
        a += 6; //!
        h = a;
        a = AllertYesNoViewY;
        a += 4;
        l = a;
        d = 4;
        e = 3;
        ButtonShadowViewShow(bc = StringLocaleNo);
        // YES Button
        a = AllertYesNoViewX;
        a += 6 + 7; //!
        h = a;
        a = AllertYesNoViewY;
        a += 4;
        l = a;
        d = 5;
        e = 3;
        ButtonShadowView2Show(bc = StringLocaleYes);
    }
    AllertYesNoViewShowTitle();
    AllertYesNoViewPosUpdate();
    AllertYesNoViewLoopKey();
}

void AllertYesNoViewLoopKey() {
    push_pop(bc) {
        b = 0;
        do {
            getKeyboardCharA();
            c = a;
            if ((a = c) == 0x1B) { //ESC выход
                b = 1;
            } else if ((a = c) == 0x0D) { //Enter
                a = AllertYesNoViewPos;
                AllertYesNoViewReturnValue = a;
                b = 1;
            } else if ((a = c) == 0x18) { // Вправл
                AllertYesNoViewPosNext();
                AllertYesNoViewPosUpdate();
            } else if ((a = c) == 0x08) { // Влево
                AllertYesNoViewPosNext();
                AllertYesNoViewPosUpdate();
            } else if ((a = c) == 'Y') {
                a = 1;
                AllertYesNoViewReturnValue = a;
                b = 1;
            } else if ((a = c) == 'N') {
                a = 0;
                AllertYesNoViewReturnValue = a;
                b = 1;
            }
        } while ((a = b) == 0);
    }
    AllertYesNoViewClose();
}

void AllertYesNoViewPosNext() {
    if ((a = AllertYesNoViewPos) == 0) {
        a = 1;
        AllertYesNoViewPos = a;
    } else {
        a = 0;
        AllertYesNoViewPos = a;
    }
}

void AllertYesNoViewPosUpdate() {
    if ((a = AllertYesNoViewPos) == 0) {
        ButtonShadowViewSelectA(a = 1);
        ButtonShadowView2SelectA(a = 0);
    } else {
        ButtonShadowViewSelectA(a = 0);
        ButtonShadowView2SelectA(a = 1);
    }
}

void AllertYesNoViewClose() {
    vboxClose();
    CurrentViewReturn();
    a = AllertYesNoViewReturnValue;
}

void AllertYesNoViewShowTitle() {
    push_pop(hl, de, bc) {
        hl = AllertYesNoViewTitlePoint;
        b = 0;
        a = AllertYesNoViewDX;
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
        a = AllertYesNoViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        b = a;
        a = AllertYesNoViewX;
        a += b;
        myCharPosX = a;
        a = AllertYesNoViewY;
        a += 2;
        myCharPosY = a;
        printMyHLStr(hl = AllertYesNoViewTitlePoint);
    }
}

uint8_t AllertYesNoViewX = 12;
uint8_t AllertYesNoViewY = 12;
uint8_t AllertYesNoViewDX = 24;
uint8_t AllertYesNoViewDY = 9;
uint8_t AllertYesNoViewColor = 0x70; // 0x1F;

uint8_t AllertYesNoViewPos = 0;
uint8_t AllertYesNoViewReturnValue = 0;

uint16_t AllertYesNoViewTitlePoint = 0;

#endif /* AllertYesNoViewFunctions_h */
