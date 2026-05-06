//
//  DebugFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DebugFunctions_h
#define DebugFunctions_h

void DebugShowIn00HexA() {
    push_pop(bc, de) {
        b = a;
        a = 0;
        myCharPosX = a;
        a = 0;
        myCharPosY = a;
        printMyHexA(a = b);
    }
}

#endif /* DebugFunctions_h */
