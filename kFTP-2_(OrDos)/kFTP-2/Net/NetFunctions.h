//
//  NetFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 11.02.2026.
//

#ifndef NetFunctions_h
#define NetFunctions_h

void NetWiFiGetSsidPassword() {
    push_pop(hl, bc) {
        h = 1; // GET_SSID_PASSWORD, // 1
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = WiFiSettingsViewPassValue;
        ParserBufferToHL();
    }
}

void NetWiFiSetSsidPassword() {
    push_pop(hl, bc) {
        hl = WiFiSettingsViewPassValue;
        ParserHLToBuffer(b = 16);
        h = 2; // SET_SSID_PASSWORD, // 2
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetWiFiGetSsidIp() {
    push_pop(hl, bc) {
        h = 3; // GET_SSID_IP, // 3
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = WiFiSettingsViewIpValue;
        ParserBufferToHL();
    }
}

void NetWiFiGetSsidMac() {
    push_pop(hl, bc) {
        h = 4; // GET_SSID_MAC, // 4
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 18;
        c = l;
        hl = WiFiSettingsViewMacValue;
        ParserBufferSumToHL();
    }
}

void NetWiFiGetSsid() {
    push_pop(hl, bc) {
        h = 5; // GET_SSID, // 5
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = WiFiSettingsViewSsidValue;
        ParserBufferToHL();
    }
}

void NetFtpGetUrl() {
    push_pop(hl, bc) {
        h = 6; // GET_FTP_URL, // 6
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = FtpStateViewIpValue;
        ParserBufferToHL();
    }
}

void NetFtpSetUrl() {
    push_pop(hl, bc) {
        hl = FtpStateViewIpValue;
        ParserHLToBuffer(b = 16);
        h = 7; // SET_FTP_URL, // 7
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpGetUser() {
    push_pop(hl, bc) {
        h = 8; // GET_FTP_USER, // 8
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = FtpSettingsViewValueUser;
        ParserBufferToHL();
    }
}

void NetFtpSetUser() {
    push_pop(hl, bc) {
        hl = FtpSettingsViewValueUser;
        ParserHLToBuffer(b = 16);
        h = 9; // SET_FTP_USER, // 9
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpGetPassword() {
    push_pop(hl, bc) {
        h = 10; // GET_FTP_PASS, // 10
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = FtpSettingsViewValuePass;
        ParserBufferToHL();
    }
}

void NetFtpSetPassword() {
    push_pop(hl, bc) {
        hl = FtpSettingsViewValuePass;
        ParserHLToBuffer(b = 16);
        h = 11; // SET_FTP_PASS, // 11
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpGetHomeDir() {
    push_pop(hl, bc) {
        h = 12; // GET_FTP_HOME_DIR, // 12
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = FtpSettingsViewValueHomeDir;
        ParserBufferToHL();
    }
}

void NetFtpSetHomeDir() {
    push_pop(hl, bc) {
        hl = FtpSettingsViewValueHomeDir;
        ParserHLToBuffer(b = 16);
        h = 13; // SET_FTP_HOME_DIR, // 13
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpGetPort() {
    push_pop(hl, bc) {
        h = 14; // GET_FTP_PORT, // 14
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 6;
        c = l;
        hl = FtpSettingsViewValuePort;
        ParserBufferToHL();
    }
}

void NetFtpSetPort() {
    push_pop(hl, bc) {
        hl = FtpSettingsViewValuePort;
        ParserHLToBuffer(b = 16);
        h = 15; // SET_FTP_PORT, // 15
        l = 6; // Len NedBuffer
        ESPSendHL();
    }
}

void NetWiFiListUpdate() {
    push_pop(hl) {
        h = 16; // SSID_LIST_UPDATE, // 16
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetWiFiGetList() {
    a = 0;
    WiFiNetworksViewSSIDCount = a;
    push_pop(hl, bc, de) {
        c = 0;
        do {
            h = 17; // SSID_LIST_NEXT, // 17
            l = 0; // Len NedBuffer
            ESPSendAndGetHL();
            if ((a = l) > 0) {
                b = l;
                //--
                hl = WiFiNetworksViewSSIDList;
                d = 0;
                a = c;
                carry_rotate_left(a, 4);
                if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
                    d++;
                }
                e = a;
                hl += de;
                push_pop(bc) {
                    c = b;
                    b = 16;
                    ParserBufferToHL();
                }
                //--
                c++;
            }
        } while ((a = l) > 0);
        a = c;
        WiFiNetworksViewSSIDCount = a;
    }
}

void NetWiFiSetListA() {
    push_pop(hl) {
        hl = Net_buffer;
        *hl = a;
        h = 18; // SSID_SET_LIST_ID, // 18
        l = 1; // Len NedBuffer
        ESPSendHL();
    }
}

void NetWiFiConnect() {
    push_pop(hl) {
        h = 19; // SSID_CONNECT, // 19
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetGetAllStatus() {
    push_pop(hl) {
        h = 20; //  GET_STATUS, // 20
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        //--
        NetGetAllStatusParse();
    }
}

void NetFtpGoToHomeDir() {
    push_pop(hl) {
        h = 21; // SET_FTP_TO_HOME_DIR, // 21
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpGetCurrentPath() {
    push_pop(hl) {
        h = 22; //  GET_FTP_CURRENT_FOLDER, // 22
        l = 0; // Len NedBuffer
        ESPSendAndGetHL();
        b = 16;
        c = l;
        hl = FtpViewPath;
        ParserBufferToHL();
    }
}

void NetFtpConnect() {
    push_pop(hl) {
        h = 23; // FTP_CONNECT, // 23
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpChangeDirUp() {
    push_pop(hl) {
        h = 24; // SET_FTP_CHANGE_DIR_UP, // 24
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpChangeDirIndexA() {
    push_pop(hl) {
        hl = Net_buffer;
        *hl = a;
        h = 25; // SET_FTP_CHANGE_DIR_INDEX, // 25
        l = 1; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpUpdateList() {
    push_pop(hl) {
        hl = Net_buffer;
        a = 20; // Получить 20 файлов
        *hl = a;
        h = 26; // FTP_UPDATE_LIST, // 26
        l = 1; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpListFiles() {
    push_pop(hl, bc, de) {
        a = 0;
        NetFtpListFilesParseSumState = a;
        c = 0;
        do {
            //--
            hl = Net_buffer;
            a = NetFtpListFilesParseSumState;
            *hl = a;
            //--
            h = 27; // FTP_LIST_FILE_NEXT, // 27
            l = 1; // Len NedBuffer
            ESPSendAndGetHL();
            //--
            NetFtpListFilesParse(); // пока l > 0 (ответ от ESP что то содержит)
        } while ((a = l) > 0);
        a = c;
        FtpViewFilesListCount = a;
    }
}

void NetFtpLoadFileA() {
    push_pop(hl) {
        hl = Net_buffer;
        *hl = a;
        h = 28; // FTP_FILE_DOWNLOAD, // 28
        l = 1; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpLoadFileNext() {
    push_pop(hl) {
        a = 1;
        NetFtpLoadFileNextParseSumState = a;
        do {
            //--
            hl = Net_buffer;
            a = NetFtpLoadFileNextParseSumState;
            *hl = a;
            //--
            h = 29; // FTP_FILE_DOWNLOAD_NEXT, // 29
            l = 1; // Len NedBuffer
            ESPSendAndGetHL();
            //--
            NetFtpLoadFileNextParse();
        } while ((a = l) > 0);
    }
}

void NetErrorClear() {
    push_pop(hl) {
        h = 30; // ESP_ERROR_CLEAR, // 30
        l = 0; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpDeleteFileIndexA() {
    push_pop(hl) {
        hl = Net_buffer;
        *hl = a;
        h = 31; // FTP_FILE_DELETE_INDEX, // 31
        l = 1; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpMakeDirectory() {
    push_pop(hl) {
        hl = FtpMakeDirectoryValue;
        ParserHLToBuffer(b = 16);
        h = 33; // FTP_MAKE_DIRECTORY, // 33
        l = 16; // Len NedBuffer
        ESPSendHL();
    }
}

void NetFtpUploadFileInitHL() {
    ParserFileUploadInit();
    // Отправляем данные о файле
    push_pop(hl, bc) {
        ParserFileUploadInit();
        
        ParserHLToBuffer(b = 8);
        h = 32; // FTP_FILE_UPLOAD_INIT, // 32
        l = 8; // Len NedBuffer
        ESPSendHL();
    }
    // Начинаем передавать содержимое файла
    do {
        ParserFileUploadCreateBuffer();
        h = 34; // FTP_FILE_UPLOAD_NEXT, // 34
        l = 20; // Len NedBuffer 16 + 1 + 2 + 1 = 20
        ESPSendAndGetHL();
        // Parse 
        // b = 0x3C, b = isCorrect, b = progress, b = sum
        ParserFileUploadParse();
    } while (a > 0);
}

#endif /* NetFunctions_h */
