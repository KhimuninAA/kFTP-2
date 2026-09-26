//
//  main.c
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#include <cmm.h>
#include "Include.h"
void KeyboardEventA();
void KeyCurDelay();

asm{
    org 0x0FF0
}

///App Name
uint8_t appName[] = {'K','F','T','P','-','D','S','$'};
//uint8_t appName[] = {'K','$',' ',' ',' ',' ',' ',' '};

asm{
    //адрес посадки (2 байта)
    DB 0x00, 0x10
    //длина (2 байта)
    DB 0x00, 0x32
    //атрибуты, рабочая страница ОЗУ , дата создания/модификации
    //DB 0x00, 0x01, 0x01, 0x0B
    DB 0x00, 0x00, 0x01, 0x0B
}

void main(){
    
    DetectHardwareVersion();
    if (a == 0) {
        bios(a = biosPrintMessageHL, hl = StringLocaleHardwareFail);
        getKeyboardCharA();
        return exit();
    }
    
    bios(a = biosSetTempDiskC, c = 'B');
    MyFuncSetFullScreen();
    bios(a = biosSetColorModeC, c = 0);
    //bios(a = biosCursorShowC, c = 0);
    h = 0;
    l = 0;
    setPosCursor();
    //sp = 0x6FFF;
    
    //MyFuncLoadEXTDRV();
    //MyFuncCheckExtDrv();
    
    FtpHeaderViewStart();
    WiFiHeaderViewStart();
    HelpFooterViewShow();
    DiskViewStart();
    FtpViewShow();
    
    CurrentViewChangeIdA(a = DiskViewId); //FtpViewId
    
    #ifdef _IS_SIMULATOR
        //DiskViewReload();
    #else
        NetUpdateData();
        ThreadsTickNow();
    #endif
    
    for (;;) {
        bios(a = biosCheckKeyA, c = 1);
        if (flag_z) {
            ThreadsTick();
        } else {
            KeyCurDelay();
            KeyboardEventA();
        }
    }
}

void Key256Delay() {
    push_pop(bc, a) {
        b = 0x40; //0xFF;
        do {
            c = 0xFF;
            do {
                c--;
            } while ((a = c) > 0);
            b--;
        } while ((a = b) > 0);
    }
}

void KeyCurDelay() {
    push_pop(bc, a) {
        b = a; //Save
        if ((a = b) == 0x08) {
            Key256Delay();
        } else if ((a = b) == 0x18) {
            Key256Delay();
        } else if ((a = b) == 0x19) {
            Key256Delay();
        } else if ((a = b) == 0x1A) {
            Key256Delay();
        }
    }
}

void KeyboardEventA() {
    push_pop(bc) {
        b = a; //Save
        if ((a = b) == 0x03) { //F4
            
            return exit();
        } else if ((a = b) == 0x02) { //F3 Open FTP settings
            CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
            if (a == 1) {
                FtpSettingsViewShow();
            }
        } else if ((a = b) == 0x01) { //F2 Open WiFi settings
            CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
            if (a == 1) {
                WiFiSettingsViewShow();
            }
        }
        
        c = 0;
        if ((a = CurrentViewId) == DiskViewId) {
            DiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpViewId) {
            FtpViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
            WiFiSettingsViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == SelectDiskViewId) {
            SelectDiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
            WiFiNetworksViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpSettingsViewId) {
            FtpSettingsViewKeyA(a = b);
            c = 1;
        }
        
    }
}

#include "Functions.h"

asm(" savebin \"KFTP-2D.ord\", 0x0ff0, 0x3210");
