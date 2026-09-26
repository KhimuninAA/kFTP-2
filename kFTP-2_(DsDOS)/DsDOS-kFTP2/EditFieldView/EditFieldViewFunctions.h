//
//  EditFieldViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 27.08.2026.
//

#ifndef EditFieldViewFunctions_h
#define EditFieldViewFunctions_h

// Старый!!!
/// H - x, L - y
/// D - dx, E - dy
/// НОвый
///[L]-X, [H]-Y
///[E]-dX, [D]-dY
/// BC - text
void EditFieldViewShow() {
    CurrentViewChangeAndPushIdA(a = EditFieldViewId);
    //-- clear
    a = 0;
    EditFieldViewTextIsChanged = a;
    //-- Save
    EditFieldViewX = (a = l);
    EditFieldViewY = (a = h);
    EditFieldViewDX = (a = e);
    EditFieldViewDY = (a = d);
    //--
    push_pop(bc) {
        a = EditFieldViewColor;
        c = a;
        // A
        MyViewChangeBoxColor();
    }
    // Save text point
    h = b;
    l = c;
    EditFieldViewTextPoint = hl;
    //-- Copy text to edit
    EditFieldViewTextCopy();
    //--
    EditFieldViewShowTextValue();
    //--
    EditFieldViewLoopKey();
}

void EditFieldViewClose() {
    //vboxClose();
    CurrentViewReturn();
    a = EditFieldViewTextIsChanged;
}

void EditFieldViewLoopKey() {
    push_pop(bc, de) {
        b = 0;
        do {
            getKeyboardCharA();
            c = a;
            if ((a = c) == 0x1B) { //ESC выход
                b = 1;
            } else if ((a = c) == 0x7F) { //Забой... (удаление символа)
                a = EditFieldViewEditTextPos;
                if (a > 0) {
                    a--;
                    EditFieldViewEditTextPos = a;
                }
                EditFieldViewShowTextValue();
            } else if ((a = c) == 0x0D) { // Сохранить и выйти из редактирования
                a = 1;
                EditFieldViewTextIsChanged = a;
                EditFieldViewTextSave();
                b = 1;
            } else if ((a = c) < 0x20) { // ничего не делаем
                
            } else {
                a = EditFieldViewEditTextPos;
                if (a < 15) {
                    d = 0;
                    e = a;
                    hl = EditFieldViewEditText;
                    hl += de;
                    a = c;
                    //convertKeyToMyFontA(); // перевести данные
                    *hl = a;
                    //--
                    a = EditFieldViewEditTextPos;
                    a++;
                    EditFieldViewEditTextPos = a;
                    //--
                    EditFieldViewShowTextValue();
                }
            }
        } while ((a = b) == 0);
    }
    EditFieldViewClose();
}

void EditFieldViewShowTextValue() {
    //EditFieldViewSetCursore();
    push_pop(bc, hl) {
        //-- Set color
        bios(c = (a = EditFieldViewColor), a = biosSetColorC);
        //-- POS
        a = EditFieldViewX;
        a += 1;
        l = a;
        a = EditFieldViewY;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        //--
        a = EditFieldViewEditTextPos;
        b = a;
        c = a;
        hl = EditFieldViewEditText;
        if ((a = b) > 0) {
            do {
                push_pop(bc) {
                    bios(c = (a = *hl) ,a = biosPrintC);
                }
                hl++;
                c--;
            } while ((a = c) > 0);
        }
        // Clear
        a = 16; // Max char array
        a -= b;
        c = a;
        do {
            push_pop(bc) {
                bios(c = ' ' ,a = biosPrintC);
            }
            c--;
        } while ((a = c) > 0);
        
    }
}

void EditFieldViewTextCopy() {
    push_pop(bc, de, hl) {
        hl = EditFieldViewTextPoint;
        de = EditFieldViewEditText;
        c = 1;
        b = 0;
        do {
            a = *hl;
            if (a > 0) {
                b++;
                *de = a;
                hl++;
                de++;
            } else {
                a = b;
                EditFieldViewEditTextPos = a;
                c = 0;
            }
        } while ((a = c) == 1);
    }
}

void EditFieldViewTextSave() {
    a = EditFieldViewEditTextPos;
    if (a == 0) {
        push_pop(hl) {
            hl = EditFieldViewTextPoint;
            *hl = 0;
        }
    } else {
        push_pop(bc, de, hl) {
            b = a;
            de = EditFieldViewEditText;
            hl = EditFieldViewTextPoint;
            do {
                a = *de;
                *hl = a;
                hl++;
                de++;
                b--;
            } while ((a = b) > 0);
            *hl = 0;
        }
    }
}

void EditFieldViewSetCursore() {
    push_pop(hl, a, bc) {
        h = (a = EditFieldViewY);
        l = (a = EditFieldViewEditTextPos);
        a = EditFieldViewX;
        a += l;
        l = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosCursorShowC, c = '_');
    }
}

uint8_t EditFieldViewX = 0;
uint8_t EditFieldViewY = 0;
uint8_t EditFieldViewDX = 0;
uint8_t EditFieldViewDY = 0;
uint8_t EditFieldViewColor = 0xA0; //0xF0;

uint16_t EditFieldViewTextPoint = 0;
uint8_t EditFieldViewEditText[16];
uint8_t EditFieldViewEditTextPos = 0;

uint8_t EditFieldViewTextIsChanged = 0;

#endif /* EditFieldViewFunctions_h */
