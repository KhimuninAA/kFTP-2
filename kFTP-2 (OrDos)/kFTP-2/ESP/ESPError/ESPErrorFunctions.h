//
//  ESPErrorFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 18.02.2026.
//

#ifndef ESPErrorFunctions_h
#define ESPErrorFunctions_h

void ESPErrorParserA() {
    if (a > 0) {
        push_pop(bc) {
            b = a;
            if ((a = b) == ESPError_FtpDeleteFileError) {
                AllertOkViewShowHL(hl = StringLocaleNetFtpDeleteFileError);
            } else if ((a = b) == ESPError_FtpConnectError) {
                AllertOkViewShowHL(hl = StringLocaleNetFtpConnectError);
            } else if ((a = b) == ESPError_WiFiConnectError) {
                AllertOkViewShowHL(hl = StringLocaleNetWiFiConnectError);
            }
        }
        // Сброс ошибки
        NetErrorClear();
    }
}

#endif /* ESPErrorFunctions_h */
