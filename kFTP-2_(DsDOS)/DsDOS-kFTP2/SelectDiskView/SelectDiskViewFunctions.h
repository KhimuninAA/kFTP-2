//
//  SelectDiskViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 25.08.2026.
//

#ifndef SelectDiskViewFunctions_h
#define SelectDiskViewFunctions_h

void SelectDiskViewShow() {
    CurrentViewChangeAndPushIdA(a = SelectDiskViewId);
    push_pop(bc, hl, de) {
        SelectDiskViewUpdateDiskList();
        SelectDiskViewUpdateSize();
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = SelectDiskViewColor);
        l = (a = SelectDiskViewX);
        h = (a = SelectDiskViewY);
        e = (a = SelectDiskViewDX);
        d = (a = SelectDiskViewDY);
        bios(a = biosWindowSafeOpen);
        MyFuncSetFullScreen();
        //--
        SelectDiskViewShowTitle();
        SelectDiskViewShowList();
        SelectDiskViewUpdateSelectA(a = 1);
    }
}

void SelectDiskViewShowTitle() {
    push_pop(bc, hl) {
        c = (a = SelectDiskViewY);
        c++;
        // Title 1 = 7
        b = 7;
        a = SelectDiskViewDX;
        a -= b;
        cyclic_rotate_right(a, 1);
        a &= 0x7F;
        a++;
        b = a;
        a = SelectDiskViewX;
        a += b;
        l = a;
        h = c;
        c++;
        push_pop(bc) {
            bios(a = biosSetPositionCursoreHL);
            bios(a = biosPrintMessageHL, hl = SelectDiskViewSelectTitle);
        }
        // Title 2 = 7
        b = 7;
        a = SelectDiskViewDX;
        a -= b;
        cyclic_rotate_right(a, 1);
        a &= 0x7F;
        a++;
        b = a;
        a = SelectDiskViewX;
        a += b;
        l = a;
        h = c;
        push_pop(bc) {
            bios(a = biosSetPositionCursoreHL);
            bios(a = biosPrintMessageHL, hl = SelectDiskViewSelectSubTitle);
        }
        c++;
        c++;
        //-- Line
        a = SelectDiskViewX;
        a += 1;
        l = a;
        h = c;
        push_pop(bc) {
            bios(a = biosSetPositionCursoreHL);
            a = SelectDiskViewDX;
            a -= 2;
            b = a;
            c = 0x90;
            do {
                bios(a = biosPrintC);
                b--;
            } while ((a = b) > 0);
        }
    }
}

void SelectDiskViewShowList() {
    push_pop(bc, hl, de) {
        a = SelectDiskViewX;
        a += 2;
        l = a;
        e = a;
        a = SelectDiskViewY;
        a += 6;
        h = a;
        d = a;
        bios(a = biosSetPositionCursoreHL);
        //--
        b = (a = SelectDiskViewListCount);
        hl = SelectDiskViewListDisk;
        do {
            bios(a = biosPrintC, c = *hl);
            //--
            push_pop(hl) {
                h = d;
                e++;
                e++;
                e++;
                l = e;
                bios(a = biosSetPositionCursoreHL);
            }
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void SelectDiskViewSetCurrentPosA() {
    push_pop(bc) {
        b = a;
        SelectDiskViewUpdateSelectA(a = 0);
        a = b;
        SelectDiskViewCurrentPos = a;
        SelectDiskViewUpdateSelectA(a = 1);
    }
}

/// 0 - прямой
/// 1 - инверсный
void SelectDiskViewUpdateSelectA() {
    push_pop(bc, hl, de) {
        if (a == 0) {
            a = SelectDiskViewColor;
        } else {
            a = SelectDiskViewInvColor;
        }
        c = a;
        //--
        a = SelectDiskViewCurrentPos;
        b = a;
        a += b;
        a += b;
        b = a;
        a = SelectDiskViewX;
        a += b;
        a += 1;
        l = a;
        //--
        a = SelectDiskViewY;
        a += 5;
        h = a;
        //--
        d = 3;
        e = 3;
        MyViewChangeBoxColor();
    }
}

void SelectDiskViewClose() {
    bios(a = biosWindowSafeClose);
    CurrentViewReturn();
}

void SelectDiskViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == SelectDiskViewId) {
            if ((a = l) == 0x1B) { //ESC выход
                SelectDiskViewClose();
            } else if ((a = l) == 0x0D) { // Выбор диска
                SelectDiskViewClose();
                push_pop(hl, de) {
                    e = (a = SelectDiskViewCurrentPos);
                    d = 0;
                    hl = SelectDiskViewListDisk;
                    hl += de;
                    a = *hl;
                }
                DiskViewSetDiskNumA();
            } else if ((a = l) == 0x18) { // Вправо
                h = (a = SelectDiskViewListCount);
                a = SelectDiskViewCurrentPos;
                a++;
                if (a == h) {
                    a = 0;
                }
                SelectDiskViewSetCurrentPosA();
            } else if ((a = l) == 0x08) { // Влево
                a = SelectDiskViewCurrentPos;
                if (a == 0) {
                    a = SelectDiskViewListCount;
                    a--;
                } else {
                    a--;
                }
                SelectDiskViewSetCurrentPosA();
            }
        }
    }
}

void SelectDiskViewUpdateSize() {
    //x = 48
    push_pop(bc) {
        a = SelectDiskViewListCount;
        b = a;
        a += b;
        a += b;
        a += 2;
        SelectDiskViewDX = a;
        b = a;
        a = 48;
        a -= b;
        cyclic_rotate_right(a, 1);
        SelectDiskViewX = a;
    }
}

void SelectDiskViewUpdateDiskList() {
    push_pop(bc, hl) {
        hl = SelectDiskViewListDisk;
        *hl = (a = 'A');
        hl++;
        *hl = (a = 'B');
        hl++;
        *hl = 0;
        SelectDiskViewListCount = (a = 2);
//        SelectDiskViewListCount = (a = 0);
//        //--
//        b = 8;
//        c = 'A';
//        hl = SelectDiskViewListDisk;
//        do {
//            bios(a = biosGetAccessDiskC);
//            if (flag_c) {
//                *hl = (a = c);
//                hl++;
//                a = SelectDiskViewListCount;
//                a++;
//                SelectDiskViewListCount = a;
//            }
//            c++;
//            b--;
//        } while ((a = b) > 0);
//        *hl = 0;
    }
}

uint8_t SelectDiskViewX = 17;
uint8_t SelectDiskViewY = 12;
uint8_t SelectDiskViewDX = 14;
uint8_t SelectDiskViewDY = 9;
uint8_t SelectDiskViewColor = 0x70; //0x1F;
uint8_t SelectDiskViewInvColor = 0x20; //0x2E;

uint8_t SelectDiskViewCurrentPos = 0;

uint8_t SelectDiskViewSelectTitle[7] = "Choose";
uint8_t SelectDiskViewSelectSubTitle[7] = "drive:";

uint8_t SelectDiskViewListDisk[9] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
uint8_t SelectDiskViewListCount = 0;

#endif /* SelectDiskViewFunctions_h */
