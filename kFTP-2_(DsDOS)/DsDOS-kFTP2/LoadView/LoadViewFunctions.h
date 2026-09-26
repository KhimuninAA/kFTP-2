//
//  LoadViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 02.09.2026.
//

#ifndef LoadViewFunctions_h
#define LoadViewFunctions_h

void LoadViewShowHL() {
    CurrentViewChangeAndPushIdA(a = LoadViewId);
    push_pop(bc, hl, de) {
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = LoadViewColor);
        l = (a = LoadViewX);
        h = (a = LoadViewY);
        e = (a = LoadViewDX);
        d = (a = LoadViewDY);
        bios(a = biosWindowSafeOpen);
        MyFuncSetFullScreen();
    }
    LoadViewShowTitleHL();
    LoadViewShowInfoString();
    LoadViewShowInfoSubString();
}

void LoadViewClose() {
    bios(a = biosWindowSafeClose);
    CurrentViewReturn();
}

void LoadViewShowTitleHL() {
    push_pop(bc) {
        push_pop(hl) {
            b = 0;
            do {
                a = *hl;
                c = a;
                hl++;
                b++;
                if ((a = LoadViewDX) < b) {
                    a = 0;
                    c = a;
                }
            } while ((a = c) > 0);
        }
        a = LoadViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        c = a;
        push_pop(hl) {
            // X
            a = LoadViewX;
            a += c;
            l = a;
            // Y
            a = LoadViewY;
            a += 1;
            h = a;
            bios(a = biosSetPositionCursoreHL);
        }
        bios(a = biosPrintMessageHL);
    }
}

void LoadViewShowInfoString() {
    push_pop(hl) {
        // X
        a = LoadViewX;
        a += 1;
        l = a;
        // Y
        a = LoadViewY;
        a += 3;
        h = a;
        //
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = LoadViewInfoString);
    }
}

void LoadViewShowInfoSubString() {
    push_pop(hl) {
        // X
        a = LoadViewX;
        a += 1;
        l = a;
        // Y
        a = LoadViewY;
        a += 7;
        h = a;
        //
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = LoadViewInfoSubString);
    }
}

uint8_t LoadViewShowProgressOld = 0xFF;
void LoadViewShowProgressA() {
    push_pop(bc, hl) {
        b = a; //Save
        if ((a = LoadViewShowProgressOld) != b) {
            a = b;
            LoadViewShowProgressOld = a;
            // X
            a = LoadViewX;
            a += 1;
            l = a;
            // Y
            a = LoadViewY;
            a += 5; //2;
            h = a;
            bios(a = biosSetPositionCursoreHL);
            h = 0;
            do {
                if ((a = h) < b) {
                    bios(a = biosPrintC, c = 0xBF);
                } else {
                    bios(a = biosPrintC, c = 0xBC);
                }
                h++;
            } while ((a = h) < 40);
        }
    }
}

uint8_t LoadViewX = 3;
uint8_t LoadViewY = 11; //14;
uint8_t LoadViewDX = 42;
uint8_t LoadViewDY = 9; //4;
uint8_t LoadViewColor = 0x70; // 0x1F;

uint8_t LoadViewProgress = 0;

uint8_t LoadViewLoadTitle[] = "Load...";
uint8_t LoadViewUploadTitle[] = "Upload...";

uint8_t LoadViewFTPPrefix[] = "ftp:";
uint8_t LoadViewInfoString[41] = "";
uint8_t LoadViewInfoSubString[41] = "";

uint8_t LoadViewStrFrom[] = "From:";
uint8_t LoadViewStrTo[] = "To:";
uint8_t LoadViewStrName[] = "Name:";
uint8_t LoadViewStrSize[] = "Size:";

#endif /* LoadViewFunctions_h */
