//
//  ParserFileFunctions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 05.05.2026.
//

#ifndef ParserFileFunctions_h
#define ParserFileFunctions_h

//HL - указатель на файл
void ParserFileUploadInit() {
    push_pop(hl) {
        a = DiskViewDiskNum;
        ordos_wnd(); // Устанавливаем диск
    }
    push_pop(hl, bc, de) {
        ordos_sdma(); // уст.указ.имени
        ordos_pscf(); // a = 1 файл найден HL - адрес стоп-байта
        c = a;
        if ((a = c) == 0xFF) {
            ParserFileUploadStartAddress = hl;
            ordos_atf(); // hl = нач.адрес файла de = конеч.адрес файла
            hl = ParserFileUploadStartAddress;
            ParserFileDESubHL();
            h = d;
            l = e;
            ParserFileUploadLen = hl;
            ParserFileUploadCount = hl;
        } else {
            hl = 0;
            ParserFileUploadStartAddress = hl;
            ParserFileUploadLen = hl;
            ParserFileUploadCount = hl;
        }
    }
}

// Пачки по 16 байт
// b - sum, bb - len, b - isEnd
void ParserFileUploadCreateBuffer() {
    push_pop(hl, de, bc) {
        a = DiskViewDiskNum;
        ordos_wnd(); // Устанавливаем диск
        de = Net_buffer;
        hl = ParserFileUploadStartAddress;
        b = 16;
        c = 0;
        do {
            ordos_rdisk();
            *de = a;
            a += c;
            c = a;
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
        //-- SUM
        a = c;
        *de = a;
        de++;
        //-- LEN
        hl = ParserFileUploadLen;
        a = l;
        *de = a;
        de++;
        a = h;
        *de = a;
        de++;
        //-- IsEnd
        hl = ParserFileUploadCount;
        c = 0;
        if ((a = h) == 0) {
            if ( (a = l) < 17 ) {
                c = 1;
            }
        }
        a = c;
        *de = a;
    }
}

// b = 0x3C, b = isCorrect, b = progress, b = sum
// Вых [A] - 1 - дальше. 0 - выход
void ParserFileUploadParse() {
    ParserFileUploadParseSum();
    if (a == 1) {
        push_pop(hl, de, bc) {
            de = Net_buffer;
            de++;
            a = *de;
            if (a == 1) {
                // Отправить прогресс
                de++;
                a = ParserFileUploadProgress;
                b = a;
                a = *de;
                if (a != b) {
                    ParserFileUploadProgress = a;
                    LoadViewShowProgressA(); //a = *de;
                }
                // Следующий шаг отправки
                hl = ParserFileUploadStartAddress;
                bc = 16;
                hl += bc;
                ParserFileUploadStartAddress = hl; // Новый адрес чтения
                hl = ParserFileUploadCount;
                bc = 0xFFF0;
                hl += bc;
                ParserFileUploadCount = hl; // Оставшаяся длина файла
                
                // Условие что делаем дальше...
                c = 1;
                hl = ParserFileUploadCount;
                if ((a = h) == 0) {
                    if ((a = l) == 0) {
                        c = 0; // СТОП!
                    }
                }
                a = c;
            } else {
                a = 1; // Данные не корректны - отправляем еще раз!
            }
        }
    } else {
        a = 0;
    }
}

void ParserFileUploadParseSum() {
    push_pop(hl, de, bc) {
        de = Net_buffer;
        b = 3;
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

// DE = DE - HL
void ParserFileDESubHL() {
    a = e;  // Load low byte of E into accumulator
    a -= l; // Subtract low byte of L (A = E - L)
    e = a;  // Store result back in E
    
    a = d;  // Load high byte of D into accumulator
    carry_sub(a, h);    // Subtract high byte of DE with borrow (A = D - H - Carry)
    d = a;  // Store result back in D
}

uint16_t ParserFileUploadStartAddress = 0;
uint16_t ParserFileUploadLen = 0;
uint16_t ParserFileUploadCount = 0;
uint8_t ParserFileUploadProgress = 0;

#endif /* ParserFileFunctions_h */
