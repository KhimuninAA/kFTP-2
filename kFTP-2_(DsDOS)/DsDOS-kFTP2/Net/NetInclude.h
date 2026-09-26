//
//  NetInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 27.08.2026.
//

#ifndef NetInclude_h
#define NetInclude_h

extern uint8_t Net_buffer_len;
extern uint8_t Net_buffer[1];

void NetErrorClear();
void NetGetAllStatus();
void NetDiskGetNum();
void NetDiskSetNum();
void NetSetIsDsDos();

/// WiFi
void NetWiFiGetSsidIp();
void NetWiFiGetSsidPassword();
void NetWiFiSetSsidPassword();
void NetWiFiGetSsidMac();
void NetWiFiGetSsid();
void NetWiFiSetListA();
void NetWiFiConnect();
void NetWiFiListUpdate();
void NetWiFiGetList();

/// FTP
void NetFtpConnect();
void NetFtpGetHomeDir();
void NetFtpSetHomeDir();
void NetFtpGetUser();
void NetFtpSetUser();
void NetFtpGetPassword();
void NetFtpSetPassword();
void NetFtpGetUrl();
void NetFtpSetUrl();
void NetFtpGetPort();
void NetFtpSetPort();
void NetFtpGetCurrentPath();
void NetFtpUpdateList();
void NetFtpListFiles();
void NetFtpChangeDirUp();
void NetFtpChangeDirIndexA();
void NetFtpGoToHomeDir();
void NetFtpDeleteFileIndexA();
void NetFtpLoadFileA();
void NetFtpLoadFileNext();

#endif /* NetInclude_h */
