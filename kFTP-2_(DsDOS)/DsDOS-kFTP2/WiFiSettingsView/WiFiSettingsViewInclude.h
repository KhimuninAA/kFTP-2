//
//  WiFiSettingsViewInclude.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef WiFiSettingsViewInclude_h
#define WiFiSettingsViewInclude_h

extern uint8_t WiFiSettingsViewSsidValue[16];
extern uint8_t WiFiSettingsViewPassValue[16];
extern uint8_t WiFiSettingsViewMacValue[18];
extern uint8_t WiFiSettingsViewIpValue[16];

extern uint8_t WiFiSettingsViewX;
extern uint8_t WiFiSettingsViewY;
extern uint8_t WiFiSettingsViewDX;
extern uint8_t WiFiSettingsViewDY;
extern uint8_t WiFiSettingsViewColor;
extern uint8_t WiFiSettingsViewInvColor;

extern uint8_t WiFiSettingsViewSelectPos;

extern uint8_t WiFiSettingsViewTitle[15];
extern uint8_t WiFiSettingsViewTitlePass[6];
extern uint8_t WiFiSettingsViewTitleMac[6];
extern uint8_t WiFiSettingsViewButtonTitle[8];
extern uint8_t WiFiSettingsViewTitleSSID[7];
extern uint8_t WiFiSettingsViewSSIDIsConnected;

void WiFiSettingsViewShow();
void WiFiSettingsViewShowTitle();
void WiFiSettingsViewKeyA();
void WiFiSettingsViewClose();
void WiFiSettingsViewShowValue();
void WiFiSettingsViewSelectLineA();
void WiFiSettingsViewByPosBoxValue();
void WiFiSettingsViewPosUpdateA();
void WiFiSettingsViewByPosValue();

#endif /* WiFiSettingsViewInclude_h */
