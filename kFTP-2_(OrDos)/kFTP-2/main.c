//
//  main.c
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#include <cmm.h>
#include "Include.h"

void goToVBOX() __address(0x0106);
void mainStart();
void KeyboardEventA();

asm{
    org 0x00F0
}

///App Name
uint8_t appName[] = {'K','F','T','P','2','$',' ',' '};

asm{
    //Start
    DB 0x00, 0x01
    //Len
    DB 0x00, 0x3A //0x34C0 0x00, 0x35
    //Reserved
    DB 0x00, 0x00, 0x00, 0x00
}

void main(){
    #ifdef _IS_MAIN_STACK
        sp = 0x6FFF;
    #else
        nop();
        nop();
        nop();
    #endif
    mainStart();
}

///Exec VBOX
uint8_t jmpToVBOX = 0xc3;
uint16_t startVboxAddr = 0x0000;

void mainStart() {
    h = 24;
    l = 60;
    setPosCursor();
    
    HelpViewShow();
    FtpStateViewShow();
    WifiStateViewShow();
    FtpViewShow();
    DiskViewShow();
    
    CurrentViewChangeIdA(a = FtpViewId);
    
    #ifdef _IS_SIMULATOR
        DiskViewReload();
    #else
        NetUpdateData();
        ThreadsTickNow();
    #endif
    
    for(;;){
        #ifdef _IS_SIMULATOR
            getKeyboardCharA();
            KeyboardEventA();
        #else
            getKeyboardStateA();
            if (a == 0xFF) {
                getKeyboardCodeA();
                KeyboardEventA();
            } else {
                ThreadsTick();
            }
        #endif
    }
}

void KeyboardEventA() {
    push_pop(bc) {
        b = a; //Save
        if ((a = b) == 0x03) { //F4
            vboxClearCash();
            ordos_start();
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
        } else if ((a = b) == 0x00) { //F1 Open help
            CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
            if (a == 1) {
                HelpInfoViewShow();
            }
        }
        
        c = 0;
        if ((a = CurrentViewId) == DiskViewId) {
            DiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpViewId) {
            FtpViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == SelectDiskViewId) {
            SelectDiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
            WiFiSettingsViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
            WiFiNetworksViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpSettingsViewId) {
            FtpSettingsViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
            FtpMakeDirectoryKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == HelpInfoViewId) {
            HelpInfoViewKeyA(a = b);
            c = 1;
        }
    }
}

#include "Functions.h"

asm(" savebin \"kFTP2.ORD\", 0x00f0, 0x3A10"); //0x3210 3510
asm(" savebin \"test.ORD\", 0x00f0, 0x3A10");
