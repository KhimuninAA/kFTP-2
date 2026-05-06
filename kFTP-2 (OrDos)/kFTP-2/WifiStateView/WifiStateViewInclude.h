//
//  WifiStateViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef WifiStateViewInclude_h
#define WifiStateViewInclude_h

extern uint8_t WifiStateViewX;
extern uint8_t WifiStateViewY;
extern uint8_t WifiStateViewDX;
extern uint8_t WifiStateViewDY;
extern uint8_t WifiStateViewColor;

extern uint8_t WifiStateViewTitleIP[7]; //6
extern uint8_t WifiStateViewTitle[8];

void WifiStateViewShow();
void WifiStateViewShowTitle();
void WifiStateViewShowValue();

#endif /* WifiStateViewInclude_h */
