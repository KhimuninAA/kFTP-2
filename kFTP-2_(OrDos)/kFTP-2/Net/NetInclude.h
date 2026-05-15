//
//  NetInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 11.02.2026.
//

#ifndef NetInclude_h
#define NetInclude_h

extern uint8_t Net_buffer_len;
extern uint8_t Net_buffer[1];

void NetGetAllStatus();
void NetErrorClear();

void NetWiFiGetSsidPassword();
void NetWiFiSetSsidPassword();
void NetWiFiGetSsidIp();
void NetWiFiGetSsidMac();
void NetWiFiGetSsid();
void NetWiFiListUpdate();
void NetWiFiGetList();
void NetWiFiSetListA();
void NetWiFiConnect();

void NetFtpGetUrl();
void NetFtpSetUrl();
void NetFtpGetUser();
void NetFtpSetUser();
void NetFtpGetPassword();
void NetFtpSetPassword();
void NetFtpGetHomeDir();
void NetFtpSetHomeDir();
void NetFtpGetPort();
void NetFtpSetPort();
void NetFtpGoToHomeDir();
void NetFtpGetCurrentPath();
void NetFtpConnect();
void NetFtpChangeDirUp();
void NetFtpChangeDirIndexA();
void NetFtpUpdateList();
void NetFtpListFiles();
void NetFtpLoadFileA();
void NetFtpLoadFileNext();
void NetFtpDeleteFileIndexA();
void NetFtpUploadFileInitHL();
void NetFtpMakeDirectory();

#endif /* NetInclude_h */
