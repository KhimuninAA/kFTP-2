#include "FtpFileData.h"

FtpFileData FtpFileDataHelper::parse(String src) {
  FtpFileData parseFtpFileData;
  parseFtpFileData.name = "";
  parseFtpFileData.isDir = false;
  parseFtpFileData.data = "";
  parseFtpFileData.size = 0;
  parseFtpFileData.isHidden = true;
  parseFtpFileData.date = "";

  parseL(src, &parseFtpFileData);

  return parseFtpFileData;
}

void FtpFileDataHelper::parseL(String src, FtpFileData *ftpFileData) {
  int inxed = 0;
  int seek = -1;
  String temp = src;
  do {
    seek = temp.indexOf(';');
    if (seek >= 0) {
      String value = temp.substring(0, seek);
      paramValue(value, ftpFileData);
      temp = temp.substring(seek + 1);
    } else if (temp.length() > 0) {
      ftpFileData->name = temp;
      ftpFileData->name.trim();
      if (ftpFileData->name == ".DS_Store") {
        ftpFileData->isHidden = true;
      }
    }
  }while(seek >= 0);
}

//modify*;perm*;size*;type*;unique*;UNIX.group*;UNIX.mode*;UNIX.owner*;
// {
//     ["name"]=>
//     string(10) "public_ftp"
//     ["modify"]=>
//     string(14) "20171211174536"
//     ["perm"]=>
//     string(7) "flcdmpe"
//     ["type"]=>
//     string(3) "dir"
//     ["unique"]=>
//     string(11) "811U57405EE"
//     ["UNIX.group"]=>
//     string(2) "33"
//     ["UNIX.mode"]=>
//     string(4) "0755"
//     ["UNIX.owner"]=>
//     string(2) "33"
// }
void FtpFileDataHelper::paramValue(String src, FtpFileData *ftpFileData) {
  int seek = src.indexOf('=');
  if (seek >= 0) {
    String val = src.substring(seek + 1);
    String param = src.substring(0, seek);
    if (param == "size") {
      ftpFileData->size = val.toInt();
    } else if (param == "type") {
      if (val == "cdir") {
        ftpFileData->isHidden = true;
      } else {
        ftpFileData->isHidden = false;
        if ((val == "pdir") || (val == "dir")) {
          ftpFileData->isDir = true;
        } else {
          ftpFileData->isDir = false;
        }
      }
    } else if (param == "modify") {
      ftpFileData->date = val;
    }
  }
}