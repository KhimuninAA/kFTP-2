//
//  ButtonShadowView2Functions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 29.08.2026.
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
    ButtonShadowView2X = (a = h);
    ButtonShadowView2Y = (a = l);
    ButtonShadowView2DX = (a = d);
    ButtonShadowView2DY = (a = e);
    //--
    ButtonShadowView2ShowTitleBC();
    //--
    c = (a = ButtonShadowView2Color);
    l = (a = ButtonShadowView2X);
    h = (a = ButtonShadowView2Y);
    e = (a = ButtonShadowView2DX);
    d = (a = ButtonShadowView2DY);
    MyViewChangeBoxColor();
}

/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowView2SelectA() {
    push_pop(bc, de, hl) {
        b = a;
        l = (a = ButtonShadowView2X);
        h = (a = ButtonShadowView2Y);
        e = (a = ButtonShadowView2DX);
        d = (a = ButtonShadowView2DY);
        //--------
        if ((a = b) == 0) {
            a = ButtonShadowView2Color;
        } else {
            a = ButtonShadowView2InvColor;
        }
        c = a;
        //----
        MyViewChangeBoxColor();
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
        l = a;
        a = ButtonShadowView2Y;
        a += 1;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = ButtonShadowView2TitlePoint);
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
