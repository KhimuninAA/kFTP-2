//
//  HelpInfoViewInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 21.05.2026.
//

#ifndef HelpInfoViewInclude_h
#define HelpInfoViewInclude_h

extern uint8_t HelpInfoViewX;
extern uint8_t HelpInfoViewY;
extern uint8_t HelpInfoViewDX;
extern uint8_t HelpInfoViewDY;
extern uint8_t HelpInfoViewColor;

extern uint8_t HelpInfoViewStringY;

extern uint8_t HelpInfoViewTitle[18];
extern uint8_t HelpInfoViewStrAll[37];
extern uint8_t HelpInfoViewStrAll2[10];
extern uint8_t HelpInfoViewDiskHelp1[36];
extern uint8_t HelpInfoViewDiskHelp2[26];
extern uint8_t HelpInfoViewFTPHelp1[30];
extern uint8_t HelpInfoViewFTPHelp2[35];
extern uint8_t HelpInfoViewFTPHelp3[36];
extern uint8_t HelpInfoViewFTPHelp4[31];
extern uint8_t HelpInfoViewFooterHelp1[36];
extern uint8_t HelpInfoViewFooterHelp2[35];
extern uint8_t HelpInfoViewFooterHelp3[32];
extern uint8_t HelpInfoViewFooterHelp4[31];
extern uint8_t HelpInfoViewFooterHelp5[16];
extern uint8_t HelpInfoViewGitHubHelp1[37];

void HelpInfoViewShow();
void HelpInfoViewKeyA();
void HelpInfoViewShowTitle();
void HelpInfoViewShowStringHL();
void HelpInfoViewShowNewLine();

#endif /* HelpInfoViewInclude_h */
