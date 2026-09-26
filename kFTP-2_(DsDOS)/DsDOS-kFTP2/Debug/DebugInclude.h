//
//  DebugInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 22.08.2026.
//

#ifndef DebugInclude_h
#define DebugInclude_h

extern uint8_t DebugRegA;
extern uint8_t DebugRegB;
extern uint8_t DebugRegC;
extern uint8_t DebugRegD;
extern uint8_t DebugRegE;
extern uint8_t DebugRegH;
extern uint8_t DebugRegL;

extern uint8_t DebugError[7];
extern uint8_t DebugOk[4];

extern uint8_t Debug00X;
extern uint8_t Debug00Y;

void Debug00Start();
void Debug00CharPrintA();
void Debug00HexPrintA();
void Debug00PosIncrement();

#endif /* DebugInclude_h */
