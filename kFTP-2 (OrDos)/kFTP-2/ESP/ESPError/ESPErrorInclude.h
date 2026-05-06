//
//  ESPErrorInclude.h
//  kFTP-2
//
//  Created by Алексей Химунин on 18.02.2026.
//

#ifndef ESPErrorInclude_h
#define ESPErrorInclude_h

const uint8_t ESPError_FtpDeleteFileError = 0x01;
const uint8_t ESPError_FtpConnectError = 0x02;
const uint8_t ESPError_WiFiConnectError = 0x03;

void ESPErrorParserA();

#endif /* ESPErrorInclude_h */
