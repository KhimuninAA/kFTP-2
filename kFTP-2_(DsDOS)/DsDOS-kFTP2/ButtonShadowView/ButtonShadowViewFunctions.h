//
//  ButtonShadowViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 26.08.2026.
//

#ifndef ButtonShadowViewFunctions_h
#define ButtonShadowViewFunctions_h

/// H - x, L - y
/// D - dx, E - dy
/// BC - text
void ButtonShadowViewShow() {
    push_pop(hl) {
        h = b;
        l = c;
        ButtonShadowViewTitlePoint = hl;
    }
    //- SAVE -
    a = h;
    ButtonShadowViewX = a;
    a = l;
    ButtonShadowViewY = a;
    a = d;
    ButtonShadowViewDX = a;
    a = e;
    ButtonShadowViewDY = a;

    ButtonShadowViewShowTitleBC();
    
    c = (a = ButtonShadowViewColor);
    l = (a = ButtonShadowViewX);
    h = (a = ButtonShadowViewY);
    e = (a = ButtonShadowViewDX);
    d = (a = ButtonShadowViewDY);
    MyViewChangeBoxColor();
}

/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowViewSelectA() {
    push_pop(bc, de, hl) {
        b = a;
        l = (a = ButtonShadowViewX);
        h = (a = ButtonShadowViewY);
        e = (a = ButtonShadowViewDX);
        d = (a = ButtonShadowViewDY);
        //--------
        if ((a = b) == 0) {
            a = ButtonShadowViewColor;
        } else {
            a = ButtonShadowViewInvColor;
        }
        c = a;
        //----
        MyViewChangeBoxColor();
    }
}

void ButtonShadowViewShowTitleBC() {
    push_pop(hl, de, bc) {
        hl = ButtonShadowViewTitlePoint;
        b = 0;
        a = ButtonShadowViewDX;
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
        a = ButtonShadowViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        b = a;
        a = ButtonShadowViewX;
        a += b;
        l = a;
        a = ButtonShadowViewY;
        a += 1;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = ButtonShadowViewTitlePoint);
    }
}

uint8_t ButtonShadowViewX = 0;
uint8_t ButtonShadowViewY = 0;
uint8_t ButtonShadowViewDX = 0;
uint8_t ButtonShadowViewDY = 0;

uint8_t ButtonShadowViewColor = 0xF7;
uint8_t ButtonShadowViewInvColor = 0xE2; //0xE6
uint16_t ButtonShadowViewTitlePoint = 0x0000;

#endif /* ButtonShadowViewFunctions_h */
