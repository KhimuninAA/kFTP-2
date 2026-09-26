//
//  MyViewInclude.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef MyViewInclude_h
#define MyViewInclude_h

/// Открыть окно
#define MyViewByteBorder 0x01;
#define MyViewByteFrame 0x02;

extern uint16_t MyViewDyDx;
extern uint8_t MyViewByte;

void MyViewClearBox();
void MyViewChangeBoxColor();
void MyViewShow();
void MyViewCalcCharByPosDE();

#endif /* MyViewInclude_h */
