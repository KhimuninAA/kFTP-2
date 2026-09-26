//
//  FtpHeaderViewFunctions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef FtpHeaderViewFunctions_h
#define FtpHeaderViewFunctions_h

void FtpHeaderViewStart() {
    FtpHeaderViewShow();
}

void FtpHeaderViewShow() {
    bios(a = biosSetExtDRVConfigB, b = 0x02);
    c = (a = FtpHeaderViewColor);
    l = (a = FtpHeaderViewX);
    h = (a = FtpHeaderViewY);
    e = (a = FtpHeaderViewDX);
    d = (a = FtpHeaderViewDY);
    bios(a = biosWindowOpen);
    MyFuncSetFullScreen();
    FtpHeaderViewShowTitle();
    FtpHeaderViewShowValue();
}

void FtpHeaderViewShowTitle() {
    push_pop(hl, bc) {
        // TITLE
        a = FtpHeaderViewX;
        b = a;
        a = FtpHeaderViewDX;
        a += b;
        a -= 6; //len Title
        l = a;
        h = (a = FtpHeaderViewY);
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = FtpViewTitle);
        // IP
        a = FtpHeaderViewX;
        a += 1;
        l = a;
        a = FtpHeaderViewY;
        a += 1;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = FtpHeaderViewIpTitle);
        // STATUS
        a = FtpHeaderViewX;
        a += 1;
        l = a;
        a = FtpHeaderViewY;
        a += 2;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = FtpHeaderViewStateTitle);
    }
}

void FtpHeaderViewShowValue() {
    push_pop(hl, bc) {
        bios(c = (a = FtpHeaderViewColor), a = biosSetColorC);
        //IP
        a = FtpHeaderViewX;
        a += 5;
        l = a;
        a = FtpHeaderViewY;
        a += 1;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        MyFuncPrintHLStrLenA(hl = FtpHeaderViewIpValue, a = 16);
        // STATUS
        FtpHeaderViewShowStatus();
    }
}

void FtpHeaderViewShowStatus() {
    push_pop(hl, bc, de) {
        a = FtpHeaderViewX;
        a += 9;
        d = a; // X
        l = a;
        a = FtpHeaderViewY;
        a += 2;
        e = a; // Y
        h = a;
        bios(a = biosSetPositionCursoreHL);
        //--
        if ((a = FtpHeaderViewStatus) == 0) {
            hl = FtpHeaderViewStatus0;
            a = FtpHeaderViewColor;
            c = a;
        } else {
            hl = FtpHeaderViewStatus1;
            a = FtpHeaderViewConnectColor;
            c = a;
        }
        bios(a = biosSetColorC);
        MyFuncPrintHLStrLenA(a = 14);
    }
}

uint8_t FtpHeaderViewX = 0;
uint8_t FtpHeaderViewY = 0;
uint8_t FtpHeaderViewDX = 24;
uint8_t FtpHeaderViewDY = 4;
#ifdef _IS_STATUSBAR_BW
    uint8_t FtpHeaderViewColor = 0x07;
    uint8_t FtpHeaderViewConnectColor = 0x02; //0x52;
#else
    uint8_t FtpHeaderViewColor = 0x5f; //0x67;
    uint8_t FtpHeaderViewConnectColor = 0x52;
#endif

uint8_t FtpHeaderViewIpTitle[] =    "IP:";
uint8_t FtpHeaderViewStateTitle[] = "Status:";
uint8_t FtpHeaderViewIpValue[16] = "0.0.0.0";

uint8_t FtpHeaderViewStatus = 0;
uint8_t FtpHeaderViewStatus0[] = "DISCONNECT";
uint8_t FtpHeaderViewStatus1[] = "CONNECT";

#endif /* FtpHeaderViewFunctions_h */
