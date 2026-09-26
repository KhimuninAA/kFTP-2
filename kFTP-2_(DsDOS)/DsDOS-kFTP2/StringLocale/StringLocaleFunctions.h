//
//  StringLocaleFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 26.08.2026.
//

#ifndef StringLocaleFunctions_h
#define StringLocaleFunctions_h

void StringLocaleCreateLoadTitleA() {
    push_pop(bc, hl, de) {
        hl = LoadViewInfoString;
        // From
        de = LoadViewStrFrom;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // ftp path
        de = FtpViewPath;
        b = 27 - 7;
        c = 0;
        do {
            if ((a = c) == 0) {
                a = *de;
                if (a > 0) {
                    *hl = a;
                    de++;
                    hl++;
                } else {
                    c = 1;
                    StringLocaleAddSpaceInHL();
                }
            } else {
                StringLocaleAddSpaceInHL();
            }
            b--;
        } while ((a = b) > 0);
        // Name
        de = LoadViewStrName;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // FileName
        de = FtpViewFilesList;
        push_pop(hl) {
            a ^= a;
            d = 0;
            a = FtpViewFileCurrentPos;
            carry_rotate_left(a, 4);
            e = a;
            if (flag_c) {
                d++;
            }
            hl = FtpViewFilesList;
            hl += de;
            d = h;
            e = l;
            // get address
            push_pop(de) {
                de = 8;
                hl += de;
                d = h;
                e = l;
                a = *de;
                h = a;
                de++;
                a = *de;
                l = a;
                StringLocaleAddress = hl;
            }
        }
        b = 8;
        do {
            a = *de;
            *hl = a;
            de++;
            hl++;
            b--;
        } while ((a = b) > 0);
        // Stop
        *hl = 0;
        
        hl = LoadViewInfoSubString;
        // to
        de = LoadViewStrTo;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // Disk
        bios(a = biosGetDiskC);
        *hl = (a = c);
        hl++;
        *hl = ':';
        hl++;
        // Space 27
        b = 27 - 7;
        do {
            StringLocaleAddSpaceInHL();
            b--;
        } while ((a = b) > 0);
        // Size
        de = LoadViewStrSize;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // Size value
        push_pop(hl) {
            hl = StringLocaleAddress;
            d = h;
            e = l;
        }
        MyFunc4CharSizeDE();
        b = 4;
        de = MyFunc4Chars;
        do {
            *hl = (a = *de);
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
        
        // Stop
        *hl = 0;
    }
}

void StringLocaleAddDEInHL() {
    do {
        a = *de;
        if (a > 0) {
            *hl = a;
            de++;
            hl++;
        }
    } while (a > 0);
}

void StringLocaleAddSpaceInHL() {
    a = ' ';
    StringLocaleCharAToHL();
}

void StringLocaleCharAToHL() {
    *hl = a;
    hl++;
}

uint8_t StringLocaleOK[] = "Ok";
uint8_t StringLocaleYes[] = "Yes";
uint8_t StringLocaleNo[] = "No";
uint8_t StringLocaleEraseFile[] = "Erase file";
uint8_t StringLocaleFileNotFound[] = "File not found";
uint8_t StringLocaleFileReadOnly[] = "File read-only";
uint8_t StringLocaleNetTimeOut[] = "Net timeout";

uint8_t StringLocaleNetFtpDeleteFileError[] = "FTP file not delete";
uint8_t StringLocaleNetFtpConnectError[] = "FTP connect error";
uint8_t StringLocaleNetWiFiConnectError[] = "WiFi connect error";
uint8_t StringLocaleDiskFull[] = "Disk full";
uint8_t StringLocaleDiskFormat[] = "Format the disk?";

uint8_t StringLocaleHardwareFail[] = "Not detect NetCard!";

uint16_t StringLocaleAddress = 0;

#endif /* StringLocaleFunctions_h */
