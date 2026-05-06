//
//  ParserFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 11.02.2026.
//

#ifndef ParserFunctions_h
#define ParserFunctions_h

/// HL - point Str
/// B - Len Str
/// C - Len buffer
void ParserBufferToHL() {
    push_pop(de) {
        de = Net_buffer;
        do {
            if ((a = c) > 0) {
                a = *de;
                *hl = a;
                c--;
                de++;
            } else {
                a = 0;
                *hl = a;
            }
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void ParserHLToBuffer() {
    push_pop(bc, de) {
        de = Net_buffer;
        do {
            a = *hl;
            *de = a;
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
    }
}

/// C - count (не трогаем)
/// l - Len NedBuffer
void NetFtpListFilesParse() {
    if ((a = l) == 16) {
        NetFtpListFilesParseSum();
        if ((a = NetFtpListFilesParseSumState) == 0x01) {
            push_pop(hl, de) {
                b = l;
                //--
                hl = FtpViewFilesList;
                d = 0;
                a = c;
                carry_rotate_left(a, 4);
                if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
                    d++;
                }
                e = a;
                hl += de;
                push_pop(bc) {
                    c = b;
                    b = 16;
                    ParserBufferToHL();
                }
                //--
                c++;
            }
        }
    } else {
        a = 0x00;
        NetFtpListFilesParseSumState = a;
    }
}

void NetFtpListFilesParseSum() {
    push_pop(hl, bc) {
        b = 15;
        c = 0;
        hl = Net_buffer;
        do {
            a = *hl;
            a += c;
            c = a;
            hl++;
            b--;
        } while ((a = b) > 0);
        a = *hl;
        if (a == c) {
            a = 0x01;
            NetFtpListFilesParseSumState = a;
        } else {
            a = 0x00;
            NetFtpListFilesParseSumState = a;
        }
        // 10 byte = 0x3C
        hl = Net_buffer;
        bc = 10;
        hl += bc;
        a = *hl;
        a &= 0xFE;
        if (a != 0x3C) {
            a = 0x00;
            NetFtpListFilesParseSumState = a;
        }
    }
}

void NetFtpLoadFileNextParse() {
    push_pop(hl) {
        if ((a = l) > 0) {
            NetFtpLoadFileNextParseSum();
            if ((a = NetFtpLoadFileNextParseSumState) == 0x01) {
                push_pop(bc, de) {
                    b = l;
                    de = Net_buffer;
                    //-- Address
                    a = *de;
                    l = a;
                    de++;
                    a = *de;
                    h = a;
                    NetFtpLoadFileNextParseAddress = hl;
                    de++;
                    //-- Progress
                    LoadViewShowProgressA(a = *de);
                    de++;
                    //-- 0x3C
                    de++;
                    //--
                    b--;
                    b--;
                    b--;
                    b--;
                    b--;
                    NetFtpLoadFileNextParseCalkDiskPosToHL();
                    do {
                        a = *de;
                        ordos_wdisk();
                        hl++;
                        de++;
                        b--;
                    } while ((a = b) > 0);
                    NetFtpLoadFileNextParseAddressEnd = hl;
                }
            }
        } else {
            hl = NetFtpLoadFileNextParseAddressEnd;
            ordos_stop();
        }
    }
}

/// Считаем адрес куда писать данные на диск
void NetFtpLoadFileNextParseCalkDiskPosToHL() {
    push_pop(de) {
        // получаем адрес пакета
        hl = NetFtpLoadFileNextParseAddress;
        // прибавляем к точке начала файла на диске
        d = h;
        e = l;
        hl = DiskViewStartNewFile;
        a = l;
        a += e;
        if (flag_c) {
            h++;
        }
        l = a;
        a = h;
        a += d;
        h = a;
        push_pop(hl) {
            a = l;
            a &= 0x01;
            if (a > 0) {
                a = 0;
                myCharPosX = a;
                a = 0;
                myCharPosY = a;
                printMyHexA(a = h);
                printMyHexA(a = l);
            }
        }
        // В HL адрес записи, полученных данных, на диск
    }
}

void NetFtpLoadFileNextParseSum() {
    push_pop(hl, bc) {
        b = l;
        b--;
        hl = Net_buffer;
        c = 0;
        do {
            a = *hl;
            a += c;
            c = a;
            hl++;
            b--;
        } while ((a = b) > 0);
        a = *hl;
        if (a == c) {
            a = 0x01;
            NetFtpLoadFileNextParseSumState = a;
        } else {
            a = 0x00;
            NetFtpLoadFileNextParseSumState = a;
        }
        //-- 3 byte = byte 0x3C
        hl = Net_buffer;
        hl++;
        hl++;
        hl++;
        a = *hl;
        if (a != 0x3C) {
            a = 0x00;
            NetFtpLoadFileNextParseSumState = a;
        }
    }
}

void NetGetAllStatusParse() {
    if ((a = l) > 0) {
        NetGetAllStatusParseSum();
        if ((a = NetGetAllStatusParseSumState) == 1) {
            hl = Net_buffer;
            //-- 0x3C
            hl++;
            //-- WIFIflag
            ThreadsNetSetWiFiStateA(a = *hl);
            hl++;
            //-- FtpConnected
            ThreadsNetSetFtpStateA(a = *hl);
            hl++;
            //-- espError
            ESPErrorParserA(a = *hl);
            hl++;
        }
    }
}

void NetGetAllStatusParseSum() {
    push_pop(hl, bc) {
        b = l;
        b--;
        hl = Net_buffer;
        c = 0;
        a = *hl;
        if (a == 0x3C) {
            do {
                a = *hl;
                a += c;
                c = a;
                hl++;
                b--;
            } while ((a = b) > 0);
            a = *hl;
            if (a == c) {
                a = 0x01;
                NetGetAllStatusParseSumState = a;
            } else {
                a = 0x00;
                NetGetAllStatusParseSumState = a;
            }
        } else {
            a = 0x00;
            NetGetAllStatusParseSumState = a;
        }
    }
}

/// HL - point Str
/// B - Len Str
/// C - Len buffer
void ParserBufferSumToHL() {
    ParserBufferSumToHLSum();
    if ((a = ParserBufferSumToHLSumState) == 1) {
        push_pop(hl, bc, de) {
            de = Net_buffer;
            c--;
            c--;
            do {
                if ((a = c) > 0) {
                    a = *de;
                    *hl = a;
                    de++;
                    c--;
                } else {
                    *hl = 0;
                }
                hl++;
                b--;
            } while ((a = b) > 0);
        }
    } else {
        //ParserBufferErrorSumShow();
    }
}

void ParserBufferErrorSumShow() {
    push_pop(hl, bc) {
        //Show Len Buffer
        a = 0;
        myCharPosX = a;
        a = 0;
        myCharPosY = a;
        printMyHexA(a = c);
        //-- Buffer
        a = 0;
        myCharPosX = a;
        a = 1;
        myCharPosY = a;
        hl = Net_buffer;
        c--; //
        b = 0;
        do {
            a = *hl;
            a += b;
            b = a;
            //-- Show
            printMyHexA(a = *hl);
            printMyCharA(a = 0x20);
            //--
            hl++;
            c--;
        } while ((a = c) > 0);
        printMyHexA(a = *hl);
        printMyCharA(a = 0x20);
        //-- SUM
        a = 0;
        myCharPosX = a;
        a = 3;
        myCharPosY = a;
        printMyHexA(a = b);
        //--
        for(;;){}
    }
}

void ParserBufferSumToHLSum() {
    push_pop(hl, bc) {
        if ((a = c) >= 3) {
            b = c;
            b--;
            c = 0;
            hl = Net_buffer;
            do {
                a = *hl;
                a += c;
                c = a;
                hl++;
                b--;
            } while ((a = b) > 0);
            // 3C
            hl--;
            a = *hl;
            if (a == 0x3C) {
                hl++;
                // SUM
                a = *hl;
                if (a == c) {
                    a = 1;
                    ParserBufferSumToHLSumState = a;
                } else {
                    a = 0;
                    ParserBufferSumToHLSumState = a;
                }
            } else {
                a = 0;
                ParserBufferSumToHLSumState = a;
            }
        } else {
            a = 0;
            ParserBufferSumToHLSumState = a;
        }
    }
}

uint8_t ParserBufferSumToHLSumState = 0;
uint8_t NetGetAllStatusParseSumState = 0;
uint16_t NetFtpLoadFileNextParseAddress = 0;
uint16_t NetFtpLoadFileNextParseAddressEnd = 0;
uint8_t NetFtpLoadFileNextParseSumState = 0;
uint8_t NetFtpListFilesParseSumState = 0;

#endif /* ParserFunctions_h */
