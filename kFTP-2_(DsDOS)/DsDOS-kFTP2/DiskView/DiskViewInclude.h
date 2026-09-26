//
//  DiskViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 12.07.2026.
//

#ifndef DiskViewInclude_h
#define DiskViewInclude_h

extern uint8_t DiskViewX;
extern uint8_t DiskViewY;
extern uint8_t DiskViewDX;
extern uint8_t DiskViewDY;
extern uint8_t DiskViewColor;
extern uint8_t DiskViewInvColor;

extern uint8_t DiskViewTitle[9];
extern uint8_t DiskViewDirRootTitle[3];
extern uint8_t DiskViewDirNameEmpty[1];

extern uint8_t DiskViewDirCount;
extern uint16_t DiskViewDirBufer;
extern uint8_t DiskViewFileCurrentPos;

extern uint8_t DiskViewDirStartIndex;
extern uint8_t DiskViewDirPageCoint;
extern uint8_t DiskViewDirEndIndex;

extern uint8_t DiskViewDirProgressLen;
extern uint8_t DiskViewFileName[9];

void DiskViewStart();
void DiskViewShowTitle();
void DiskViewSetDiskNumA();
void DiskViewReload();
void DiskViewUpdateDiskTitle();
void DiskViewUpdateDateAndUI();
void DiskViewUpdateDir();
void DiskViewShowDir();
void DiskViewDirBuferBIndexToHL();
void DiskViewDirBuferFileName();
void DiskViewShow();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void DiskViewShowSelectLineA();
void DiskViewFileCurrentPosUpdateA();
void DiskViewDirEndIndexCalc();
void DiskViewShowFreeSpace();

void DiskViewKeyA();

void DiskViewShowEmptyFile();
void DiskViewShowFilePosB();
void DiskViewShowFileNameHL();
void DiskViewShowFileSizeHL();

void DiskViewIsDiskSpaceDE();
void DiskViewDiskFreeSpaceHL();
void DiskViewHLSubDE();
void DiskViewCopyFileNameByHL();

#endif /* DiskViewInclude_h */
