//
//  DetectHardwareESPInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 25.09.2026.
//

#ifndef DetectHardwareESPInclude_h
#define DetectHardwareESPInclude_h

extern uint16_t DetectHardwareESPErrorStepCount;

void DetectHardwareESPSendAndGetHL();
void DetectHardwareESPSendByteAC();
void DetectHardwareESPGetByteAD();
void DetectHardwareESPWaitingForBusy();
void DetectHardwareESPWaitingForReady();

void DetectHardwareESPErrorInitHL();
void DetectHardwareESPErrorStep();

#endif /* DetectHardwareESPInclude_h */
