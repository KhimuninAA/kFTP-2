#ifndef FTP_FILE_DATA_H_
#define FTP_FILE_DATA_H_

#include <Arduino.h> 

#pragma pack(push, 1) 
struct FtpFileDownloadData {
  byte structSize;
  uint16_t addr;
  byte progressAndNext;
  byte buffer[17];
  uint16_t fileSize;
};
#pragma pack(pop)

struct FtpFileDownloadInfo {
  uint8_t loadSize;
  uint16_t fileSize;
  uint16_t addr;
  uint8_t answerCount;
  uint8_t buffer[128];
};

struct FtpFileData {
  public:
    String name;
    bool isDir;
    String data;
    int size;
    bool isHidden;
    String date;
};

class FtpFileDataHelper {
  private:
  static void parseL(String src, FtpFileData *ftpFileData);
  static void paramValue(String src, FtpFileData *ftpFileData);

  public:
  static FtpFileData parse(String src);
};

#endif