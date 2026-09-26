//
//  EditFieldViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 27.08.2026.
//

#ifndef EditFieldViewInclude_h
#define EditFieldViewInclude_h

extern uint8_t EditFieldViewX;
extern uint8_t EditFieldViewY;
extern uint8_t EditFieldViewDX;
extern uint8_t EditFieldViewDY;
extern uint8_t EditFieldViewColor;

extern uint16_t EditFieldViewTextPoint;
extern uint8_t EditFieldViewEditText[16];
extern uint8_t EditFieldViewEditTextPos;
extern uint8_t EditFieldViewTextIsChanged;

void EditFieldViewShow();
void EditFieldViewTextCopy();
void EditFieldViewTextSave();
void EditFieldViewShowTextValue();
void EditFieldViewLoopKey();
void EditFieldViewClose();
void EditFieldViewSetCursore();

#endif /* EditFieldViewInclude_h */
