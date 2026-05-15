//
//  ParserInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 11.02.2026.
//

#ifndef ParserInclude_h
#define ParserInclude_h

extern uint8_t NetFtpListFilesParseSumState;
extern uint8_t NetFtpLoadFileNextParseSumState;
extern uint16_t NetFtpLoadFileNextParseAddressEnd;
extern uint16_t NetFtpLoadFileNextParseAddress;
extern uint8_t NetGetAllStatusParseSumState;
extern uint8_t ParserBufferSumToHLSumState;

/// HL - point Str
/// B - Len Str
/// C - Len buffer
void ParserBufferToHL();
void ParserHLToBuffer();

void NetFtpListFilesParse();
void NetFtpListFilesParseSum();

void NetFtpLoadFileNextParse();
void NetFtpLoadFileNextParseSum();
void NetFtpLoadFileNextParseCalkDiskPosToHL();

void NetGetAllStatusParse();
void NetGetAllStatusParseSum();

/// HL - point Str
/// B - Len Str
/// C - Len buffer
void ParserBufferSumToHL();
void ParserBufferSumToHLSum();
void ParserBufferErrorSumShow();

#endif /* ParserInclude_h */
