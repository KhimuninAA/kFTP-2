//
//  FtpMakeDirectoryInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 04.05.2026.
//

#ifndef FtpMakeDirectoryInclude_h
#define FtpMakeDirectoryInclude_h

extern uint8_t FtpMakeDirectoryX;
extern uint8_t FtpMakeDirectoryY;
extern uint8_t FtpMakeDirectoryDX;
extern uint8_t FtpMakeDirectoryDY;
extern uint8_t FtpMakeDirectoryColor;
extern uint8_t FtpMakeDirectoryInvColor;

extern uint8_t FtpMakeDirectoryTitle[15];
extern uint8_t FtpMakeDirectoryValue[16];

extern uint8_t FtpMakeDirectorySelectPos;

void FtpMakeDirectoryShow();
void FtpMakeDirectoryKeyA();
void FtpMakeDirectoryClose();
void FtpMakeDirectoryShowTitle();
void FtpMakeDirectoryShowValue();
void FtpMakeDirectoryPosUpdateA();
void FtpMakeDirectorySelectLineA();
void FtpMakeDirectoryByPosBoxValue();
void FtpMakeDirectoryByPosValue();
void FtpMakeDirectoryInitValue();

#endif /* FtpMakeDirectoryInclude_h */
