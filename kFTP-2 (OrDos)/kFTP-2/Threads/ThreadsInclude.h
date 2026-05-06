//
//  ThreadsInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 12.02.2026.
//

#ifndef ThreadsInclude_h
#define ThreadsInclude_h

extern uint8_t ThreadsTickCount;
extern uint16_t ThreadsTickSubCount;

void ThreadsTick();
void ThreadsTickNow();
void ThreadsTickCountNext();
void ThreadsNetUpdateState();
void ThreadsNetNeedStateChange();
void delay50ms();
void NetUpdateData();
void ThreadsNetDetectError();

/// WiFi
void ThreadsNetNeedUpdateWiFiData();
void ThreadsNetPasswordUpdate();
void ThreadsNetNeedUpdateWiFiValue();
void ThreadsNetSsidUpdateA();
void ThreadsNetSetWiFiStateA();

/// FTP
void ThreadsNetNeedUpdateFtpData();
void ThreadsNetNeedUpdateFtpValue();
void ThreadsNetFtpHomeDirUpdate();
void ThreadsNetFtpUserUpdate();
void ThreadsNetFtpPasswordUpdate();
void ThreadsNetFtpServerUrlUpdate();
void ThreadsNetFtpPortUpdate();
void ThreadsNetFtpGoToHomeDir();
void ThreadsNetSetFtpStateA();
void ThreadsNetFtpDeleteFileA();

#endif /* ThreadsInclude_h */
