//
//  LoadViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 02.09.2026.
//

#ifndef LoadViewInclude_h
#define LoadViewInclude_h

extern uint8_t LoadViewX;
extern uint8_t LoadViewY;
extern uint8_t LoadViewDX;
extern uint8_t LoadViewDY;
extern uint8_t LoadViewColor;
extern uint8_t LoadViewProgress;

extern uint8_t LoadViewLoadTitle[8];
extern uint8_t LoadViewUploadTitle[10];

extern uint8_t LoadViewFTPPrefix[5];
extern uint8_t LoadViewInfoString[41];
extern uint8_t LoadViewInfoSubString[41];

extern uint8_t LoadViewStrFrom[6];
extern uint8_t LoadViewStrTo[4];
extern uint8_t LoadViewStrName[6];
extern uint8_t LoadViewStrSize[6];

void LoadViewShowHL();
void LoadViewShowTitleHL();
void LoadViewShowProgressA();
void LoadViewClose();
void LoadViewShowInfoString();
void LoadViewShowInfoSubString();

#endif /* LoadViewInclude_h */
