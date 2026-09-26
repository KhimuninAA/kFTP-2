//
//  HelpFooterViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 11.07.2026.
//

#ifndef HelpFooterViewFunctions_h
#define HelpFooterViewFunctions_h

void HelpFooterViewShow() {
    push_pop(bc, hl, de) {
        c = (a = HelpFooterViewColor);
        l = (a = HelpFooterViewX);
        h = (a = HelpFooterViewY);
        e = (a = HelpFooterViewDX);
        d = (a = HelpFooterViewDY);
        push_pop(bc, hl, de) {
            MyViewClearBox();
        }
        MyViewChangeBoxColor();
        MyFuncSetFullScreen();
        HelpFooterViewShowStr();
    }
}

void HelpFooterViewShowStr() {
    l = (a = HelpFooterViewX);
    l++;
    h = (a = HelpFooterViewY);
    h++;
    bios(a = biosSetPositionCursoreHL);
    
    bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF1);
    
    MyFuncPosXAddA(a = 5);
    bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF2);
    
    MyFuncPosXAddA(a = 5);
    bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF3);
    
    MyFuncPosXAddA(a = 5);
    bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF4);
}

uint8_t HelpFooterViewX = 0;
uint8_t HelpFooterViewY = 29;
uint8_t HelpFooterViewDX = 48;
uint8_t HelpFooterViewDY = 3;
#ifdef _IS_STATUSBAR_BW
    uint8_t HelpFooterViewColor = 0x07;
#else
    uint8_t HelpFooterViewColor = 0x5f; //0x67;
#endif

uint8_t HelpFooterViewTitleF1[] = "F1: ..";
uint8_t HelpFooterViewTitleF2[] = "F2: Wi-Fi";
uint8_t HelpFooterViewTitleF3[] = "F3: FTP ";
uint8_t HelpFooterViewTitleF4[] = "F4: Quit";

#endif /* HelpFooterViewFunctions_h */
