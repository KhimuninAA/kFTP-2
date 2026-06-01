//
//  DebugInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DebugInclude_h
#define DebugInclude_h

extern uint8_t DebugFileCreateName[16];

void DebugShowIn00HexA();
void DebugFileCreate();
void DebugFilesCreate();

void EDivBToE();
void HLDivDEToHL();
void MulHLx10();

#endif /* DebugInclude_h */
