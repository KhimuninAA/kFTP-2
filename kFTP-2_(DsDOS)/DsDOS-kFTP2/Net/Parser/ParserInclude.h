//
//  ParserInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 27.08.2026.
//

#ifndef ParserInclude_h
#define ParserInclude_h

extern uint8_t NetGetAllStatusParseSumState;
extern uint8_t ParserBufferSumToHLSumState;
extern uint8_t NetFtpListFilesParseSumState;

void ParserBufferToHL();
void ParserHLToBuffer();

void NetGetAllStatusParse();
void NetGetAllStatusParseSum();

void ParserDiskRequest();
void ParserDiskResponse();
void ParserDiskResponseSum();

void ParserBufferSumToHL();
void ParserBufferSumToHLSum();

void NetFtpListFilesParse();
void NetFtpListFilesParseSum();

#endif /* ParserInclude_h */
