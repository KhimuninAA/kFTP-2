//
//  FileParserInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 04.09.2026.
//

#ifndef FileParserInclude_h
#define FileParserInclude_h

extern uint8_t FileParserSumStateNext;
extern uint16_t FileParserLoadFileAddress;
extern uint16_t FileParserLoadFileStopAddress;
extern uint16_t FileParserTempAddress;
extern uint8_t FileParserFileNum;
extern uint8_t FileParserDataCount;

extern uint8_t FileParserSectorPage;
extern uint8_t FileParserSectorNum;
extern uint8_t FileParserSectorDeltaPage;

void FileParserFtpLoadFileNextParse();
void FileParserFtpLoadFileNextParseSum();
void FileParserFtpLoadFileNeedFileCreate();
void FileParserSeekFileNum();
void FileParserFileNameCompareHLDEToA();
void FileParserFtpLoadSaveBufferInFile();
void FileParserFtpUpdatePosSectorByHL();
void FileParserNextSectorCPageB();

#endif /* FileParserInclude_h */
