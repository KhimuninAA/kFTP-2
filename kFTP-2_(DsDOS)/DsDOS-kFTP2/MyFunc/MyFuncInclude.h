//
//  MyFuncInclude.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef MyFuncInclude_h
#define MyFuncInclude_h

extern uint8_t MyFuncEXTDRV_FileName[7];
extern uint8_t MyFunc4Chars[4];

extern uint8_t MyFunc_DefExtDrv_Version;

/// Выводит строку из HL с текущего положения
/// Длиной A. Если текст короче , то добиват до A пробелами
void MyFuncPrintHLStrLenA();
void MyFuncPosXAddA();
void MyFunc4CharSizeDE();

void MyFuncLoadEXTDRV();
void MyFuncCheckExtDrv();
void MyFuncSetFullScreen();
void MyFuncPrintHLPassLenA();

void MyFuncDec099A();

#endif /* MyFuncInclude_h */
