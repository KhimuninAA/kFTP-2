//
//  AllertYesNoViewInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef AllertYesNoViewInclude_h
#define AllertYesNoViewInclude_h

extern uint16_t AllertYesNoViewTitlePoint;

extern uint8_t AllertYesNoViewX;
extern uint8_t AllertYesNoViewY;
extern uint8_t AllertYesNoViewDX;
extern uint8_t AllertYesNoViewDY;
extern uint8_t AllertYesNoViewColor;

extern uint8_t AllertYesNoViewReturnValue;
extern uint8_t AllertYesNoViewPos;

void AllertYesNoViewShowHL();
void AllertYesNoViewShowTitle();
void AllertYesNoViewLoopKey();
void AllertYesNoViewClose();
void AllertYesNoViewPosUpdate();
void AllertYesNoViewPosNext();

#endif /* AllertYesNoViewInclude_h */
