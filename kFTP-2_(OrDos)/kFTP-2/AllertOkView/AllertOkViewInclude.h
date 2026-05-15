//
//  AllertOkViewInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef AllertOkViewInclude_h
#define AllertOkViewInclude_h

extern uint8_t AllertOkViewX;
extern uint8_t AllertOkViewY;
extern uint8_t AllertOkViewDX;
extern uint8_t AllertOkViewDY;
extern uint8_t AllertOkViewColor;

extern uint16_t AllertOkViewTitlePoint;

void AllertOkViewShowHL();
void AllertOkViewShowTitle();
void AllertOkViewLoopKey();
void AllertOkViewClose();

#endif /* AllertOkViewInclude_h */
