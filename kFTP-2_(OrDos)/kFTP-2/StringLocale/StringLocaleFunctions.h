//
//  StringLocaleFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 11.02.2026.
//

#ifndef StringLocaleFunctions_h
#define StringLocaleFunctions_h

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

uint16_t StringLocaleAddress = 0;

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

void StringLocaleCharAToAddress() {
    push_pop(hl) {
        hl = StringLocaleAddress;
        *hl = a;
        hl++;
        StringLocaleAddress = hl;
    }
}

void StringLocaleAsDec4095HL() {
    push_pop(bc, de) {
        de = 0x0FFF;
        compareHlDe();
        if (flag_nc) {
            c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
            //1000
            de = 0x03E8;
            compareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFC18;
                    hl += de;
                    b++;
                    de = 0x03E8;
                    compareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                StringLocaleCharAToAddress();
                c = 1;
            } else {
                StringLocaleCharAToAddress(a = ' ');
            }
            //0100
            de = 0x0064;
            compareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFF9C;
                    hl += de;
                    b++;
                    de = 0x0064;
                    compareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                StringLocaleCharAToAddress();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    StringLocaleCharAToAddress(a = ' ');
                } else {
                    StringLocaleCharAToAddress(a = '0');
                }
            }
            a = l;
            if ((a = l) >= 10) {
                b = 0;
                do {
                    a = l;
                    a -= 10;
                    l = a;
                    b++;
                } while ((a = l) >= 10);
                a = b;
                a += '0';
                StringLocaleCharAToAddress();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    StringLocaleCharAToAddress(a = ' ');
                } else {
                    StringLocaleCharAToAddress(a = '0');
                }
            }
            //0001
            a = l;
            a += '0';
            StringLocaleCharAToAddress();
        }
    }
}

void StringLocaleMyAsDec99AToHL() {
    if (a < 0x64) {
        push_pop(bc, de) {
            b = a;
            c = a;
            d = 0;
            e = 10;
            if ((a = b) < e) {
                StringLocaleCharAToHL(a = ' ');
                a = b;
                a += '0';
                StringLocaleCharAToHL();
            } else {
                do {
                    a = b;
                    a -= e;
                    b = a;
                    d++;
                } while ((a = b) >= e);
                a = d;
                a += '0';
                StringLocaleCharAToHL();
                a = b;
                a += '0';
                StringLocaleCharAToHL();
            }
        }
    }
}

void StringLocaleShow4CharSizeDEByHL() {
    if ((a = d) < 4) { // < 1024 в байтах //flag_c
        StringLocaleAddress = hl;
        push_pop(hl) {
            //hl = LoadViewInfoSubString;
            //StringLocaleAddress = hl;
            h = d;
            l = e;
            StringLocaleAsDec4095HL();
        }
        hl = StringLocaleAddress;
    } else { // В Кб
        a = d;
        a &= 0xFC;
        cyclic_rotate_right(a, 2);
        StringLocaleMyAsDec99AToHL();
        a = 'K';
        *hl = a;
        hl++;
        a = 'b';
        *hl = a;
        hl++;
    }
}

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
            if ((a = b) < (27 - 7 - 16 + 1)) {
                c = 1;
            }
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
        a = DiskViewDiskNum;
        *hl = a;
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
        StringLocaleShow4CharSizeDEByHL();
        // Stop
        *hl = 0;
    }
}

void StringLocaleCreateUploadTitleA() {
    push_pop(bc, hl, de) {
        hl = LoadViewInfoString;
        // From
        de = LoadViewStrFrom;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // Disk
        a = DiskViewDiskNum;
        *hl = a;
        hl++;
        *hl = ':';
        hl++;
        // Space 27
        b = 27 - 9;
        do {
            StringLocaleAddSpaceInHL();
            b--;
        } while ((a = b) > 0);
        // Name
        de = LoadViewStrName;
        StringLocaleAddDEInHL();
        StringLocaleAddSpaceInHL();
        // FileName
        push_pop(hl) {
            a ^= a;
            DiskViewCurrentFilePointToHL();
            d = h;
            e = l;
            // get address
            push_pop(de) {
                de = 10; //8;
                hl += de;
                d = h;
                e = l;
                a = *de;
                l = a;
                de++;
                a = *de;
                h = a;
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
        // ftp path
        de = FtpViewPath;
        b = 27 - 5;
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
            if ((a = b) < (27 - 5 - 16 + 1)) {
                c = 1;
            }
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
        StringLocaleShow4CharSizeDEByHL();
        // Stop
        *hl = 0;
    }
}

#endif /* StringLocaleFunctions_h */
