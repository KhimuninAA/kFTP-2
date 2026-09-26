//
//  FtpHeaderViewInclude.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef FtpHeaderViewInclude_h
#define FtpHeaderViewInclude_h

extern uint8_t FtpHeaderViewX;
extern uint8_t FtpHeaderViewY;
extern uint8_t FtpHeaderViewDX;
extern uint8_t FtpHeaderViewDY;
extern uint8_t FtpHeaderViewColor;
extern uint8_t FtpHeaderViewInvColor;
extern uint8_t FtpHeaderViewConnectColor;

extern uint8_t FtpHeaderViewIpTitle[4];
extern uint8_t FtpHeaderViewStateTitle[8];
extern uint8_t FtpHeaderViewIpValue[16];

extern uint8_t FtpHeaderViewStatus;
extern uint8_t FtpHeaderViewStatus0[11];
extern uint8_t FtpHeaderViewStatus1[8];

void FtpHeaderViewStart();
void FtpHeaderViewShow();

void FtpHeaderViewShowTitle();
void FtpHeaderViewShowValue();
void FtpHeaderViewShowStatus();

#endif /* FtpHeaderViewInclude_h */
