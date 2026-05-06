//
//  ThreadsFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 12.02.2026.
//

#ifndef ThreadsFunctions_h
#define ThreadsFunctions_h

void ThreadsTickNow() {
    a = 101;
    ThreadsTickCount = a;
}

void ThreadsTick() {
    #ifdef _IS_SIMULATOR
        
    #else
    if ((a = ThreadsTickCount) >= 50) { //50
        a = 0;
        ThreadsTickCount = a;
        //--
        ThreadsNetUpdateState();
    } else {
        ThreadsTickCountNext();
    }
    #endif
}

void ThreadsNetUpdateState() {
    CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
    if (a == 1) {
        NetGetAllStatus();
        ThreadsNetNeedStateChange();
    }
}

void ThreadsNetNeedStateChange() {
    if ((a = WiFiNetStateChange) == 1) {
        ThreadsNetNeedUpdateWiFiData();
        a = 0;
        WiFiNetStateChange = a;
    }
    if ((a = FtpNetStateChange) == 1) {
        ThreadsNetNeedUpdateFtpData();
        a = 0;
        FtpNetStateChange = a;
    }
}

void ThreadsTickCountNext() {
    push_pop(hl) {
        hl = ThreadsTickSubCount;
        // Compare hl == 0
        a = h;
        a |= l;
        if (a == 0) {
            //-- TickCount ++
            a = ThreadsTickCount;
            a++;
            ThreadsTickCount = a;
            //-- TickSubCount = max
            hl = 0x100; //0x800; //0x1000; //0x300;
        } else {
            hl--;
        }
        ThreadsTickSubCount = hl;
    }
}

void delay50ms() {
    push_pop(bc) {
        bc = 0xFFFF;
        do {
            bc--;
            a = b;
            a |= c;
        } while (flag_nz);
    }
}

void NetUpdateData() {
    ThreadsNetNeedUpdateFtpValue();
    ThreadsNetNeedUpdateWiFiValue();
}

// ----------------------------------
// ------------ WiFi ----------------
// ----------------------------------
void ThreadsNetNeedUpdateWiFiData() {
    NetWiFiGetSsidIp();
    WifiStateViewShowValue();
}

void ThreadsNetPasswordUpdate() {
    NetWiFiSetSsidPassword();
    nop();
    NetWiFiGetSsidPassword();
    nop();
}

void ThreadsNetNeedUpdateWiFiValue() {
    NetWiFiGetSsidIp();
    NetWiFiGetSsidMac();
    NetWiFiGetSsid();
    NetWiFiGetSsidPassword();
    // UI
    WifiStateViewShowValue();
}

void ThreadsNetSsidUpdateA() {
    NetWiFiSetListA();
    NetWiFiGetSsid();
    WifiStateViewShowValue();
}

void ThreadsNetSetWiFiStateA() {
    push_pop(bc) {
        a &= 0x01;
        b = a;
        // Old Value
        a = WiFiSettingsViewSSIDIsConnected;
        c = a;
        // --
        a = b;
        WiFiSettingsViewSSIDIsConnected = a;
        if(a != c){
            a = 0x01;
            WiFiNetStateChange = a;
        }
    }
}

// ----------------------------------
// ------------ Ftp  ----------------
// ----------------------------------
void ThreadsNetNeedUpdateFtpData() {
    FtpStateViewShowValue();
    // Update ftp dir
    NetFtpGetCurrentPath();
    FtpViewShowPath();
    //
    CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
    if (a == 1) {
        if ((a = FtpStateViewStatus) == 1) {
            NetFtpUpdateList();
            NetFtpListFiles();
        } else {
            FtpViewEmptyList();
        }
        FtpViewListUpdateUI();
    }
}

void ThreadsNetNeedUpdateFtpValue() {
    NetFtpGetUrl();
    NetFtpGetHomeDir();
    NetFtpGetPort();
    NetFtpGetUser();
    NetFtpGetPassword();
    // UI
    FtpStateViewShowValue();
}

void ThreadsNetFtpHomeDirUpdate() {
    NetFtpSetHomeDir();
    NetFtpGetHomeDir();
}

void ThreadsNetFtpUserUpdate() {
    NetFtpSetUser();
    NetFtpGetUser();
}

void ThreadsNetFtpPasswordUpdate() {
    NetFtpSetPassword();
    NetFtpGetPassword();
}

void ThreadsNetFtpServerUrlUpdate() {
    NetFtpSetUrl();
    NetFtpGetUrl();
}

void ThreadsNetFtpPortUpdate() {
    NetFtpSetPort();
    NetFtpGetPort();
}

void ThreadsNetFtpGoToHomeDir() {
    NetFtpGoToHomeDir();
    NetFtpGetCurrentPath();
    FtpViewShowPath();
    if ((a = FtpStateViewStatus) == 1) {
        NetFtpUpdateList();
        NetFtpListFiles();
    } else {
        FtpViewEmptyList();
    }
    FtpViewListUpdateUI();
}

void ThreadsNetFtpDeleteFileA() {
    NetFtpDeleteFileIndexA();
    NetFtpUpdateList();
    NetFtpListFiles();
    FtpViewListUpdateUI();
}

void ThreadsNetSetFtpStateA() {
    push_pop(bc) {
        a &= 0x01;
        b = a;
        // Old Value
        a = FtpStateViewStatus;
        c = a;
        // --
        a = b;
        FtpStateViewStatus = a;
        if(a != c){
            a = 0x01;
            FtpNetStateChange = a;
        }
    }
}

void ThreadsNetDetectError() {
    push_pop(bc, hl) {
        if ((a = ESPError) > 0) {
            b = a;
            // Clear error
            a = 0;
            ESPError = a;
            //-- ENUM
            if ((a = b) == ESPError_TimeOut) {
                AllertOkViewShowHL(hl = StringLocaleNetTimeOut);
            }
        }
    }
}

uint16_t ThreadsTickSubCount = 0x0000;
uint8_t ThreadsTickCount = 0;

#endif /* ThreadsFunctions_h */
