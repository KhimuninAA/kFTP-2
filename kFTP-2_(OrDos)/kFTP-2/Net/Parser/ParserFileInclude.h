//
//  ParserFileInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 05.05.2026.
//

#ifndef ParserFileInclude_h
#define ParserFileInclude_h

extern uint16_t ParserFileUploadStartAddress;
extern uint16_t ParserFileUploadLen;
extern uint16_t ParserFileUploadCount;
extern uint8_t ParserFileUploadProgress;

void ParserFileUploadInit();
void ParserFileUploadCreateBuffer();
void ParserFileUploadParse();
void ParserFileUploadParseSum();

void ParserFileDiskRequest();
void ParserFileDiskResponse();
void ParserFileDiskResponseSum();

void ParserFileDESubHL();

#endif /* ParserFileInclude_h */
