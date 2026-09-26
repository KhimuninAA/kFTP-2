//
//  FtpSettingsViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 28.08.2026.
//

#ifndef FtpSettingsViewFunctions_h
#define FtpSettingsViewFunctions_h

void FtpSettingsViewShow() {
    push_pop(bc, hl, de) {
        CurrentViewChangeAndPushIdA(a = FtpSettingsViewId);
        //--
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = FtpSettingsViewColor);
        l = (a = FtpSettingsViewX);
        h = (a = FtpSettingsViewY);
        e = (a = FtpSettingsViewDX);
        d = (a = FtpSettingsViewDY);
        bios(a = biosWindowSafeOpen);
        MyFuncSetFullScreen();
    }
    a = 0;
    FtpSettingsViewSelectPos = a;
    FtpSettingsViewShowTitle();
    FtpSettingsViewShowValue();
    FtpSettingsViewSelectLineA(a = 1);
}

void FtpSettingsViewClose() {
    bios(a = biosWindowSafeClose);
    CurrentViewReturn();
}

void FtpSettingsViewShowTitle() {
    push_pop(hl, bc, de) {
        bios(c = (a = FtpSettingsViewColor), a = biosSetColorC);
        // LINE!!!
        a = FtpSettingsViewX;
        a += 1;
        l = a;
        a = FtpSettingsViewY;
        a += 2;
        h = a;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        a = FtpSettingsViewDX;
        a -= 2;
        b = a;
        do {
            bios(a = biosPrintC, c = 0x90);
            b--;
        } while ((a = b) > 0);
        // Title
        a = FtpSettingsViewX;
        a += 7;
        l = a;
        a = FtpSettingsViewY;
        a += 1; //2;
        h = a;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitle);
        }
        // IP
        a = FtpSettingsViewX;
        a += 2;
        l = a; // X
        a = FtpSettingsViewY;
        a += 4;
        h = a; // Y
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleIP);
        }
        // PORT
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitlePort);
        }
        // USER
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleUser);
        }
        // PASS
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitlePass);
        }
        // HOME dir
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleHomeDir);
        }
        // Button
        if ((a = FtpHeaderViewStatus) == 0) {
            bc = WiFiSettingsViewButtonTitle;
        } else {
            bc = StringLocaleOK;
        }
        
        // Button
        d = 13;
        e = 3;
        a = FtpSettingsViewX;
        a += 7;
        h = a;
        a = FtpSettingsViewY;
        a += 10;
        l = a;
        ButtonShadowViewShow();
    }
}

void FtpSettingsViewShowValue() {
    push_pop(hl, bc) {
        bios(c = (a = FtpSettingsViewColor), a = biosSetColorC);
        // IP
        a = FtpSettingsViewX;
        a += 8;
        l = a; // X
        a = FtpSettingsViewY;
        a += 4;
        h = a; // Y
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            MyFuncPrintHLStrLenA(hl = FtpHeaderViewIpValue, a = 18);
        }
        // PORT
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            MyFuncPrintHLStrLenA(hl = FtpSettingsViewValuePort, a = 18);
        }
        // USER
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            MyFuncPrintHLStrLenA(hl = FtpSettingsViewValueUser, a = 18);
        }
        // PASS
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            MyFuncPrintHLPassLenA(hl = FtpSettingsViewValuePass, a = 18);
        }
        // HOME DIR
        h++;
        bios(a = biosSetPositionCursoreHL); //h=y l=x
        push_pop(hl) {
            MyFuncPrintHLStrLenA(hl = FtpSettingsViewValueHomeDir, a = 18);
        }
    }
}

/// вых [BC] -
void FtpSettingsViewByPosValue() {
    if ((a = FtpSettingsViewSelectPos) == 1) {
        bc = FtpHeaderViewIpValue;
    } else if ((a = FtpSettingsViewSelectPos) == 2) {
        bc = FtpSettingsViewValuePort;
    } else if ((a = FtpSettingsViewSelectPos) == 3) {
        bc = FtpSettingsViewValueUser;
    } else if ((a = FtpSettingsViewSelectPos) == 4) {
        bc = FtpSettingsViewValuePass;
    } else if ((a = FtpSettingsViewSelectPos) == 5) {
        bc = FtpSettingsViewValueHomeDir;
    } else {
        bc = 0;
    }
}

/// вых [HL] -
/// вых [DE]-
void FtpSettingsViewByPosBoxValue() {
    push_pop(bc) {
        // HL
        a = FtpSettingsViewSelectPos;
        b = a;
        a = FtpSettingsViewY;
        a += 3;
        a += b;
        h = a;
        a = FtpSettingsViewX;
        a += 7;
        l = a;
        // DE
        a = FtpSettingsViewDX;
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
void FtpSettingsViewPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            FtpSettingsViewSelectLineA(a = 1);
        } else {
            a = 6;
            c = a;
            FtpSettingsViewSelectLineA(a = 0);
            a = FtpSettingsViewSelectPos;
            a += b;
            b = a;
            //-- FIX
            if ((a = b) == 0xFF) {
                a = c;
                a--;
            } else if ((a = b) == c) {
                a = 0;
            }
            //--
            FtpSettingsViewSelectPos = a;
            FtpSettingsViewSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpSettingsViewSelectLineA() {
    push_pop(bc, hl) {
        c = a;
        // 0 - Button
        if ((a = FtpSettingsViewSelectPos) == 0) {
            ButtonShadowViewSelectA(a = c);
        } else {
            FtpSettingsViewByPosBoxValue();
            // C
            if ((a = c) == 0) {
                a = FtpSettingsViewColor;
            } else {
                a = FtpSettingsViewInvColor;
            }
            c = a;
            // A
            MyViewChangeBoxColor();
        }
    }
}

void FtpSettingsViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = c) == 0) {
            if ((a = CurrentViewId) == FtpSettingsViewId) {
                if ((a = l) == 0x1B) { //ESC выход
                    FtpSettingsViewClose();
                } else if ((a = l) == 0x0D) { // Выбор
                    if ((a = FtpSettingsViewSelectPos) == 0) { // OK
                        WiFiSettingsViewClose();
                        if ((a = FtpHeaderViewStatus) == 0) {
                            #ifdef _IS_SIMULATOR

                            #else
                                NetFtpConnect();
                                ThreadsTickNow();
                            #endif
                        }
                    } else { // Переход в редактирование
                        FtpSettingsViewByPosBoxValue();
                        FtpSettingsViewByPosValue();
                        EditFieldViewShow();
                        if (a == 1) { // что то изменилось
                            if ((a = FtpSettingsViewSelectPos) == 5) {
                                #ifdef _IS_SIMULATOR

                                #else
                                    ThreadsNetFtpHomeDirUpdate();
                                #endif
                            } else if ((a = FtpSettingsViewSelectPos) == 3) {
                                #ifdef _IS_SIMULATOR

                                #else
                                    ThreadsNetFtpUserUpdate();
                                #endif
                            } else if ((a = FtpSettingsViewSelectPos) == 4) {
                                #ifdef _IS_SIMULATOR

                                #else
                                    ThreadsNetFtpPasswordUpdate();
                                #endif
                            } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
                                #ifdef _IS_SIMULATOR

                                #else
                                    ThreadsNetFtpServerUrlUpdate();
                                #endif
                                FtpHeaderViewShowValue();
                            } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
                                #ifdef _IS_SIMULATOR

                                #else
                                    ThreadsNetFtpPortUpdate();
                                #endif
                            }
                            //FtpSettingsViewShowValue();
                        }
                        FtpSettingsViewShowValue();
                        FtpSettingsViewSelectLineA(a = 1);
                    }
                } else if ((a = l) == 0x1A) { //down
                    FtpSettingsViewPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    FtpSettingsViewPosUpdateA(a = 0xFF);
                }
            }
        }
    }
}

uint8_t FtpSettingsViewX = 11;
uint8_t FtpSettingsViewY = 9;
uint8_t FtpSettingsViewDX = 27;
uint8_t FtpSettingsViewDY = 15;
uint8_t FtpSettingsViewColor = 0x70;
uint8_t FtpSettingsViewInvColor = 0x07;

uint8_t FtpSettingsViewSelectPos = 1; //0

uint8_t FtpSettingsViewTitle[] = "FTP settings";
uint8_t FtpSettingsViewTitleIP[] =      "  IP:";
uint8_t FtpSettingsViewTitlePort[] =    "Port:";
uint8_t FtpSettingsViewTitleHomeDir[] = "Home:";
uint8_t FtpSettingsViewTitleUser[] = "User:";

uint8_t FtpSettingsViewValuePort[16] = "21";
uint8_t FtpSettingsViewValueUser[16] = "-";
uint8_t FtpSettingsViewValuePass[16] = "-";
uint8_t FtpSettingsViewValueHomeDir[16] = "/";

#endif /* FtpSettingsViewFunctions_h */
