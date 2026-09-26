//
//  ParserFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 27.08.2026.
//

#ifndef ParserFunctions_h
#define ParserFunctions_h

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

void ParserDiskRequest() {
    push_pop(de, bc) {
        // SUMM
        c = 0;
        //-- Buffer
        de = Net_buffer;
        // - init
        a = 0x3C;
        *de = a;
        de++;
        a += c;
        c = a;
        // - disk
        push_pop(bc) {
            bios(a = biosGetDiskC);
            a = c;
        }
        *de = a;
        de++;
        a += c;
        c = a;
        // - summ
        a = c;
        *de = a;
    }
}

// Вых [A] - 1 - Успешно. 0 - Ошибка
void ParserDiskResponse() {
    ParserDiskResponseSum();
    if (a == 1) {
        push_pop(de, bc) {
            de = Net_buffer;
            // init == 0x3C
            a = *de;
            de++;
            if (a == 0x3C) {
                a = *de;
                bios(c = a , a = biosSetDiskC);
                a = 1;
            } else {
                a = 0;
            }
        }
    } else {
        a = 0;
    }
}

void ParserDiskResponseSum() {
    push_pop(de, bc) {
        de = Net_buffer;
        b = 2;
        c = 0;
        do {
            a = *de;
            a += c;
            c = a;
            de++;
            b--;
        } while ((a = b) > 0);
        a = *de;
        if (a == c) {
            a = 1;
        } else {
            a = 0;
        }
    }
}

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
                a ^= a;
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

uint8_t ParserBufferSumToHLSumState = 0;
uint8_t NetGetAllStatusParseSumState = 0;
uint8_t NetFtpListFilesParseSumState = 0;

#endif /* ParserFunctions_h */
