//
//  MyViewFunctions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef MyViewFunctions_h
#define MyViewFunctions_h

// [L]-X, [H]-Y
// [E]-dX, [D]-dY
// [C] - color
void MyViewChangeBoxColor() {
    push_pop(bc) {
        push_pop(de) {
            b = l;
            a = h;
            carry_rotate_left(a, 3);
            l = a;
            h = 0;
            de = 0xC000;
            hl += de;
            e = 0;
            d = b;
            hl += de;
        }
        a = d;
        carry_rotate_left(a, 3);
        d = a;
        // X
        b = 0;
        do {
            push_pop(bc, hl) {
                //-- Y
                b = d;
                do {
                    writeByteInOtherMem(a = 1);
                    b--;
                    hl++;
                } while ((a = b) > 0);
                
                
            }
            //-- Inc
            b++;
            push_pop(de) {
                de = 0x0100;
                hl += de;
            }
        } while ((a = b) < e);
    }
}

// [L]-X, [H]-Y
// [E]-dX, [D]-dY
void MyViewClearBox() {
    push_pop(bc) {
        push_pop(de) {
            b = l;
            a = h;
            carry_rotate_left(a, 3);
            l = a;
            h = 0;
            de = 0xC000;
            hl += de;
            e = 0;
            d = b;
            hl += de;
        }
        a = d;
        carry_rotate_left(a, 3);
        d = a;
        // X
        b = 0;
        do {
            push_pop(bc, hl) {
                //-- Y
                b = d;
                do {
                    *hl = 0;
                    b--;
                    hl++;
                } while ((a = b) > 0);
                
                
            }
            //-- Inc
            b++;
            push_pop(de) {
                de = 0x0100;
                hl += de;
            }
        } while ((a = b) < e);
    }
}

// [L]-X, [H]-Y
// [E]-dX, [D]-dY
// [C] - color
// [B]
void MyViewShow() {
    MyViewByte = (a = b);
    bios(a = biosSetColorC);
    push_pop(hl) {
        h = d;
        l = e;
        MyViewDyDx = hl;
    }
    do {
        bios(a = biosSetPositionCursoreHL);
        push_pop(de) {
            do {
                MyViewCalcCharByPosDE();
                bios(a = biosPrintC);
                e--;
            } while ((a = e) > 0);
        }
        h++;
        d--;
    } while ((a = d) > 0);
}

void MyViewCalcCharByPosDE() {
    //c = MyViewByteBorder + MyViewByteFrame;
    a = MyViewByteBorder;
    a += MyViewByteFrame;
    c = a;
    a = MyViewByte;
    a &= c;
    if (a > 0) {
        push_pop(hl) {
            hl = MyViewDyDx;
            if ((a = d) == 1) { // Нижняя линия
                if ((a = e) == 1) {
                    c = 0x89;
                } else if ((a = e) == l) {
                    c = 0x94;
                } else {
                    c = 0x99;
                }
            } else if ((a = d) == h) { // Верхняя линия
                if ((a = e) == 1) {
                    c = 0x88;
                } else if ((a = e) == l) {
                    c = 0x95;
                } else {
                    c = 0x99;
                }
            } else { // Между верхней и нижней
                if ((a = e) == 1) {
                    c = 0x87;
                } else if ((a = e) == l) {
                    c = 0x87;
                } else {
                    c = ' ';
                }
            }
        }
    } else {
        c = ' ';
    }
}

uint16_t MyViewDyDx = 0;
uint8_t MyViewByte = 0;

#endif /* MyViewFunctions_h */
