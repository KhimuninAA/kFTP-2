//
//  FtpViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 12.07.2026.
//

#ifndef FtpViewInclude_h
#define FtpViewInclude_h

extern uint8_t FtpViewX;
extern uint8_t FtpViewY;
extern uint8_t FtpViewDX;
extern uint8_t FtpViewDY;
extern uint8_t FtpViewColor;
extern uint8_t FtpViewInvColor;

extern uint8_t FtpViewTitle[6];
extern uint8_t FtpViewFilesListCount;
extern uint8_t FtpViewFilesList[16 * 23];
extern uint8_t FtpViewPath[16];
extern uint8_t FtpViewFileCurrentPos;

#ifdef _IS_SIMULATOR
    extern uint8_t MockFileData[77];
#else

#endif

void FtpViewShow();
void FtpViewShowTitle();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpViewShowSelectLineA();
void FtpViewFileCurrentPosUpdateA();
void FtpViewShowPath();
void FtpViewShowFileList();
void FtpViewShowFileHL();
void FtpViewShowFileName();
void FtpViewShowFileSize();
void FtpViewShow4CharSizeDE();
void FtpViewShowIsDirA();
void FtpViewShowFileDate();
void FtpViewNetLoadAndUpdate();
void FtpViewCurrentPosIsDir();
void FtpViewEmptyList();
void FtpViewListUpdateUI();

void FtpViewAccessDiskSpace();
void FtpViewLoadFile();
void FtpViewNeedLoad();

void FtpViewGetFileNamePointByPosToHL();

void FtpViewKeyA();

#endif /* FtpViewInclude_h */
