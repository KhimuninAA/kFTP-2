//
//  WiFiSettingsViewFunctions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef WiFiSettingsViewFunctions_h
#define WiFiSettingsViewFunctions_h

void WiFiSettingsViewShow() {
    push_pop(bc, hl, de) {
        CurrentViewChangeAndPushIdA(a = WiFiSettingsViewId);
        //--
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = WiFiSettingsViewColor);
        l = (a = WiFiSettingsViewX);
        h = (a = WiFiSettingsViewY);
        e = (a = WiFiSettingsViewDX);
        d = (a = WiFiSettingsViewDY);
        bios(a = biosWindowSafeOpen);
        MyFuncSetFullScreen();
    }
    a = 0;
    WiFiSettingsViewSelectPos = a;
    WiFiSettingsViewShowTitle();
    WiFiSettingsViewShowValue();
    WiFiSettingsViewSelectLineA(a = 1);
}

void WiFiSettingsViewShowTitle() {
    push_pop(hl, bc, de) {
        // Title
        a = WiFiSettingsViewX;
        a += 7;
        l = a;
        a = WiFiSettingsViewY;
        a += 1; //2;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitle);
        // LINE!!!
        a = WiFiSettingsViewX;
        a += 1;
        h = a;
        a = WiFiSettingsViewY;
        a += 2;
        l = a;
        bios(a = biosSetPositionCursoreHL);
        a = WiFiSettingsViewDX;
        a -= 2;
        b = a;
        c = 0x90;
        do {
            bios(a = biosPrintC);
            b--;
        } while ((a = b) > 0);
        // SSID
        a = WiFiSettingsViewX;
        a += 2;
        l = a;
        a = WiFiSettingsViewY;
        a += 4;
        h = a;
        push_pop(hl) {
            bios(a = biosSetPositionCursoreHL);
            bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleSSID);
        }
        // PASS
        h++;
        push_pop(hl) {
            bios(a = biosSetPositionCursoreHL);
            bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitlePass);
        }
        // MAC
        h++;
        c = h;
        push_pop(hl) {
            bios(a = biosSetPositionCursoreHL);
            bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleMac);
        }
        // OK
        d = 13;
        e = 3;
        a = WiFiSettingsViewX;
        a += 7;
        h = a;
        a = WiFiSettingsViewY;
        a += 8;
        l = a;
        if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
            bc = WiFiSettingsViewButtonTitle;
        } else {
            bc = StringLocaleOK;
        }
        ButtonShadowViewShow();
    }
}

void WiFiSettingsViewShowValue() {
    push_pop(hl, bc) {
        // set color
        bios(c = (a = WiFiSettingsViewColor), a = biosSetColorC);
        // SSID
        a = WiFiSettingsViewX;
        a += 8;
        b = a; // X
        a = WiFiSettingsViewY;
        a += 4;
        c = a; // Y
        bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
        MyFuncPrintHLStrLenA(hl = WiFiSettingsViewSsidValue, a = 18);
        // PASS
        c++;
        bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
        MyFuncPrintHLPassLenA(hl = WiFiSettingsViewPassValue, a = 18);
        // MAC
        c++;
        bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
        MyFuncPrintHLStrLenA(hl = WiFiSettingsViewMacValue, a = 18);
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void WiFiSettingsViewSelectLineA() {
    push_pop(bc, hl) {
        c = a;
        // 0 - Button
        if ((a = WiFiSettingsViewSelectPos) == 0) {
            ButtonShadowViewSelectA(a = c);
        } else {
            WiFiSettingsViewByPosBoxValue();
            // C
            if ((a = c) == 0) {
                a = WiFiSettingsViewColor;
            } else {
                a = WiFiSettingsViewInvColor;
            }
            c = a;
            // A
            MyViewChangeBoxColor();
        }
    }
}

/// вых [HL] -
/// вых [DE]-
void WiFiSettingsViewByPosBoxValue() {
    push_pop(bc) {
        // HL
        a = WiFiSettingsViewSelectPos;
        b = a;
        a = WiFiSettingsViewY;
        a += 3;
        a += b;
        h = a;
        a = WiFiSettingsViewX;
        a += 7;
        l = a;
        // DE
        a = WiFiSettingsViewDX;
        a -= 8;
        e = a;
        a = 1;
        d = a;
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void WiFiSettingsViewPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            WiFiSettingsViewSelectLineA(a = 1);
        } else {
            a = 3;
            c = a;
            WiFiSettingsViewSelectLineA(a = 0);
            a = WiFiSettingsViewSelectPos;
            a += b;
            //-- FIX
            if (a == 0xFF) {
                a = c;
                a--;
            } else if (a == c) {
                a = 0;
            }
            //--
            WiFiSettingsViewSelectPos = a;
            WiFiSettingsViewSelectLineA(a = 1);
        }
    }
}

/// вых [BC] -
void WiFiSettingsViewByPosValue() {
    push_pop(hl) {
        if ((a = WiFiSettingsViewSelectPos) == 2) {
            bc = WiFiSettingsViewPassValue;
        } else {
            bc = 0;
        }
    }
}

void WiFiSettingsViewClose() {
    bios(a = biosWindowSafeClose);
    CurrentViewReturn();
}

void WiFiSettingsViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = c) == 0) {
            if ((a = CurrentViewId) == WiFiSettingsViewId) {
                if ((a = l) == 0x1B) { //ESC выход
                    WiFiSettingsViewClose();
                } else if ((a = l) == 0x0D) { // Выбор
                    if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
                        WiFiSettingsViewClose();
                        if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
                            #ifdef _IS_SIMULATOR

                            #else
                                NetWiFiConnect(); // Подключиться
                                ThreadsTickNow(); // Обновить
                                ThreadsNetDetectError();
                            #endif
                        }
                    } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
                        WiFiNetworksViewShow();
                    } else { // Переход в редактирование
                        WiFiSettingsViewByPosBoxValue();
                        WiFiSettingsViewByPosValue();
                        EditFieldViewShow();
                        if (a == 1) { // что то изменилось
                            #ifdef _IS_SIMULATOR

                            #else
                                ThreadsNetPasswordUpdate();
                            #endif
                            WiFiHeaderViewShowValue();
                        }
                        WiFiSettingsViewShowValue();
                        WiFiSettingsViewSelectLineA(a = 1);
                    }
                } else if ((a = l) == 0x1A) { //down
                    WiFiSettingsViewPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    WiFiSettingsViewPosUpdateA(a = 0xFF);
                }
            }
        }
    }
}

uint8_t WiFiSettingsViewX = 11;
uint8_t WiFiSettingsViewY = 10;
uint8_t WiFiSettingsViewDX = 27;
uint8_t WiFiSettingsViewDY = 13;
uint8_t WiFiSettingsViewColor = 0x70;
uint8_t WiFiSettingsViewInvColor = 0x07;

uint8_t WiFiSettingsViewSelectPos = 0;

uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
uint8_t WiFiSettingsViewTitleSSID[] = "SSID: ";
uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
uint8_t WiFiSettingsViewButtonTitle[] = "Connect";
uint8_t WiFiSettingsViewSSIDIsConnected = 0;

uint8_t WiFiSettingsViewSsidValue[16] = "-";
uint8_t WiFiSettingsViewPassValue[16] = "-";
uint8_t WiFiSettingsViewMacValue[18] = "00:00:00:00:00:00";
uint8_t WiFiSettingsViewIpValue[16] = "0.0.0.0";

#endif /* WiFiSettingsViewFunctions_h */
