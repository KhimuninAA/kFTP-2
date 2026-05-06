//
//  ButtonShadowView2Functions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef ButtonShadowView2Functions_h
#define ButtonShadowView2Functions_h

/// H - x, L - y
/// D - dx, E - dy
/// BC - text
void ButtonShadowView2Show() {
    push_pop(hl) {
        h = b;
        l = c;
        ButtonShadowView2TitlePoint = hl;
    }
    //- SAVE -
    a = h;
    ButtonShadowView2X = a;
    //printHexA(a = ButtonShadowViewX);
    a = l;
    ButtonShadowView2Y = a;
    //printHexA(a = ButtonShadowViewY);
    a = d;
    ButtonShadowView2DX = a;
    //printHexA(a = ButtonShadowViewDX);
    a = e;
    ButtonShadowView2DY = a;
    //printHexA(a = ButtonShadowViewDY);
    //--
    a = ButtonShadowView2Color;
    c = a;
    a = vboxCLW;
    a |= vboxFRM;
    a |= vboxSDW;
    a |= vboxUMP;
    vboxOpenHLDECA();
    //
    ButtonShadowView2ShowTitleBC();
}

/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowView2SelectA() {
    push_pop(bc, de, hl) {
        b = a;
        a = ButtonShadowView2X;
        h = a;
        a = ButtonShadowView2Y;
        l = a;
        a = ButtonShadowView2DX;
        d = a;
        a = ButtonShadowView2DY;
        e = a;
        //--------
        if ((a = b) == 0) {
            a = ButtonShadowView2Color;
        } else {
            a = ButtonShadowView2InvColor;
        }
        c = a;
        //----
        a = vboxFRM;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
}

void ButtonShadowView2ShowTitleBC() {
    push_pop(hl, de, bc) {
        hl = ButtonShadowView2TitlePoint;
        b = 0;
        a = ButtonShadowView2DX;
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
        a = ButtonShadowView2DX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        b = a;
        a = ButtonShadowView2X;
        a += b;
        myCharPosX = a;
        a = ButtonShadowView2Y;
        a += 1;
        myCharPosY = a;
        printMyHLStr(hl = ButtonShadowView2TitlePoint);
    }
}

uint8_t ButtonShadowView2X = 0;
uint8_t ButtonShadowView2Y = 0;
uint8_t ButtonShadowView2DX = 0;
uint8_t ButtonShadowView2DY = 0;

uint8_t ButtonShadowView2Color = 0xF7;
uint8_t ButtonShadowView2InvColor = 0xE2; //0xE6

uint16_t ButtonShadowView2TitlePoint = 0x0000;

#endif /* ButtonShadowView2Functions_h */
