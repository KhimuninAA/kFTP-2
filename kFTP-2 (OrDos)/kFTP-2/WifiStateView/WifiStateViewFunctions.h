//
//  WifiStateViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef WifiStateViewFunctions_h
#define WifiStateViewFunctions_h

void WifiStateViewShow() {
    push_pop(hl, de, bc) {
        a = WifiStateViewX;
        h = a;
        a = WifiStateViewY;
        l = a;
        a = WifiStateViewDX;
        d = a;
        a = WifiStateViewDY;
        e = a;
        a = WifiStateViewColor;
        vboxOpenHLDE();
        vboxBorderHLDE();
        WifiStateViewShowTitle();
        WifiStateViewShowValue();
    }
}

void WifiStateViewShowTitle() {
    push_pop(hl, bc) {
        //Title
        a = WifiStateViewX;
        b = a;
        a = WifiStateViewDX;
        a += b;
        a -= 8; //len Title
        myCharPosX = a;
        a = WifiStateViewY;
        myCharPosY = a;
        printMyHLStr(hl = WifiStateViewTitle);
        //SSID
        a = WifiStateViewX;
        a++;
        myCharPosX = a;
        a = WifiStateViewY;
        a++;
        myCharPosY = a;
        printMyHLStr(hl = WiFiSettingsViewTitleSSID);
        //IP
        a = WifiStateViewX;
        a++;
        myCharPosX = a;
        a = WifiStateViewY;
        a++;
        a++;
        myCharPosY = a;
        printMyHLStr(hl = WifiStateViewTitleIP);
    }
}



void WifiStateViewShowValue() {
    // SSID
    a = WifiStateViewX;
    a += 7;
    myCharPosX = a;
    a = WifiStateViewY;
    a += 1;
    myCharPosY = a;
    a = 16;
    printMyHLStrLenA(hl = WiFiSettingsViewSsidValue);
    // IP
    a = WifiStateViewX;
    a += 7;
    myCharPosX = a;
    a = WifiStateViewY;
    a += 2;
    myCharPosY = a;
    a = 16;
    printMyHLStrLenA(hl = WiFiSettingsViewIpValue);
}

uint8_t WifiStateViewX = 24;
uint8_t WifiStateViewY = 0;
uint8_t WifiStateViewDX = 24;
uint8_t WifiStateViewDY = 4;
#ifdef _IS_STATUSBAR_BW
    uint8_t WifiStateViewColor = 0x07;
#else
    uint8_t WifiStateViewColor = 0x5f; //0x67;
#endif

uint8_t WifiStateViewTitleIP[] =   "IP  : ";
uint8_t WifiStateViewTitle[] = {0xB5, 'W', 'i', '-', 'F', 'i', 0xC6, '\0'};

#endif /* WifiStateViewFunctions_h */
