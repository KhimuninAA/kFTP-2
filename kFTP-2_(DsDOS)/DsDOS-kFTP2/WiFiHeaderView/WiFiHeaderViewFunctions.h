//
//  WiFiHeaderViewFunctions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef WiFiHeaderViewFunctions_h
#define WiFiHeaderViewFunctions_h

void WiFiHeaderViewStart() {
    WiFiHeaderViewShow();
}

void WiFiHeaderViewShow() {
    bios(a = biosSetExtDRVConfigB, b = 0x02);
    c = (a = WiFiHeaderViewColor);
    l = (a = WiFiHeaderViewX);
    h = (a = WiFiHeaderViewY);
    e = (a = WiFiHeaderViewDX);
    d = (a = WiFiHeaderViewDY);
    bios(a = biosWindowOpen);
    MyFuncSetFullScreen();
    WiFiHeaderViewShowTitle();
    WiFiHeaderViewShowValue();
}

void WiFiHeaderViewShowTitle() {
    push_pop(hl, bc) {
        //Title
        a = WiFiHeaderViewX;
        b = a;
        a = WiFiHeaderViewDX;
        a += b;
        a -= 8; //len Title
        l = a;
        h = (a = WiFiHeaderViewY);
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitle);
        //SSID
        a = WiFiHeaderViewX;
        a++;
        l = a;
        a = WiFiHeaderViewY;
        a++;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleSSID);
        //IP
        a = WiFiHeaderViewX;
        a += 1;
        l = a;
        a = WiFiHeaderViewY;
        a += 2;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitleIP);
    }
}



void WiFiHeaderViewShowValue() {
    // set color
    bios(c = (a = WiFiHeaderViewColor), a = biosSetColorC);
    // SSID
    a = WiFiHeaderViewX;
    a += 7;
    l = a;
    a = WiFiHeaderViewY;
    a += 1;
    h = a;
    bios(a = biosSetPositionCursoreHL);
    MyFuncPrintHLStrLenA(hl = WiFiSettingsViewSsidValue, a = 16);
    // IP
    a = WiFiHeaderViewX;
    a += 7;
    l = a;
    a = WiFiHeaderViewY;
    a += 2;
    h = a;
    bios(a = biosSetPositionCursoreHL);
    MyFuncPrintHLStrLenA(hl = WiFiSettingsViewIpValue, a = 16);
}

uint8_t WiFiHeaderViewX = 24;
uint8_t WiFiHeaderViewY = 0;
uint8_t WiFiHeaderViewDX = 24;
uint8_t WiFiHeaderViewDY = 4;
#ifdef _IS_STATUSBAR_BW
    uint8_t WiFiHeaderViewColor = 0x07;
#else
    uint8_t WiFiHeaderViewColor = 0x5f; //0x67;
#endif

uint8_t WiFiHeaderViewTitleIP[] =   "IP  : ";
uint8_t WiFiHeaderViewTitle[] = {0x82, 'W', 'i', '-', 'F', 'i', 0x92, '\0'};

uint8_t WiFiHeaderViewMNum = 0;

#endif /* WiFiHeaderViewFunctions_h */
