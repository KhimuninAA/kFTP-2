//
//  WiFiHeaderViewInclude.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef WiFiHeaderViewInclude_h
#define WiFiHeaderViewInclude_h

extern uint8_t WiFiHeaderViewX;
extern uint8_t WiFiHeaderViewY;
extern uint8_t WiFiHeaderViewDX;
extern uint8_t WiFiHeaderViewDY;
extern uint8_t WiFiHeaderViewColor;
extern uint8_t WiFiHeaderViewInvColor;

extern uint8_t WiFiHeaderViewTitleIP[7];
extern uint8_t WiFiHeaderViewTitle[8];

extern uint8_t WiFiHeaderViewMNum;

void WiFiHeaderViewStart();
void WiFiHeaderViewShow();
void WiFiHeaderViewShowTitle();
void WiFiHeaderViewShowValue();

#endif /* WiFiHeaderViewInclude_h */
