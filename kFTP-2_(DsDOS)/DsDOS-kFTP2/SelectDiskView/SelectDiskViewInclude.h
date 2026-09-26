//
//  SelectDiskViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 25.08.2026.
//

#ifndef SelectDiskViewInclude_h
#define SelectDiskViewInclude_h

extern uint8_t SelectDiskViewX;
extern uint8_t SelectDiskViewY;
extern uint8_t SelectDiskViewDX;
extern uint8_t SelectDiskViewDY;
extern uint8_t SelectDiskViewColor;
extern uint8_t SelectDiskViewInvColor;

extern uint8_t SelectDiskViewCurrentPos;

extern uint8_t SelectDiskViewSelectTitle[7];
extern uint8_t SelectDiskViewSelectSubTitle[7];

extern uint8_t SelectDiskViewListDisk[9];
extern uint8_t SelectDiskViewListCount;

void SelectDiskViewShow();
void SelectDiskViewKeyA();
void SelectDiskViewUpdateDiskList();
void SelectDiskViewUpdateSize();
void SelectDiskViewShowList();
void SelectDiskViewShowTitle();

void SelectDiskViewSetCurrentPosA();
/// 0 - прямой
/// 1 - инверсный
void SelectDiskViewUpdateSelectA();
void SelectDiskViewClose();

#endif /* SelectDiskViewInclude_h */
