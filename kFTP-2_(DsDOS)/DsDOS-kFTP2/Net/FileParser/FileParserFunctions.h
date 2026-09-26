//
//  FileParserFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 04.09.2026.
//

#ifndef FileParserFunctions_h
#define FileParserFunctions_h

void FileParserFtpLoadFileNextParse() {
    push_pop(hl, bc) {
        if ((a = l) > 0) {
            FileParserFtpLoadFileNextParseSum();
            if ((a = FileParserSumStateNext) == 0x01) {
                push_pop(bc, de) {
                    // FileParserDataCount = len Data
                    a = l;
                    a -= 5;
                    FileParserDataCount = a;
                    // Load Buffer
                    de = Net_buffer;
                    //-- Address
                    a = *de;
                    l = a;
                    de++;
                    a = *de;
                    h = a;
                    FileParserLoadFileAddress = hl;
                    de++;
                    //-- Progress
                    LoadViewShowProgressA(a = *de);
                    de++;
                    //-- 0x3C
                    de++;
                    //-- Если адрес = 0х0000 нужно создать файл
                    FileParserFtpLoadFileNeedFileCreate();
                    FileParserFtpLoadSaveBufferInFile();
                    
                }
            }
        } else {
            //hl = FileParserLoadFileStopAddress;
            //ordos_stop();
            // TODO Error!!!
        }
    }
}

///  Если address == 0, То пишем файл и сдвигаем буфер + 0x10 на данные
void FileParserFtpLoadFileNeedFileCreate() {
    push_pop(hl, bc) {
        hl = FileParserLoadFileAddress;
        a = h;
        a |= l;
        if (flag_z) {
            h = d;
            l = e;
            // Обрезаем имя файла
            DiskViewCopyFileNameByHL();
            // Устанавливаем Имя файла в DsDos
            push_pop(hl) {
                bios(a = biosSetNameBufferHL, hl = DiskViewFileName);
            }
            push_pop(de) {
                // Получаем атрибуты файла
                bc = 8;
                hl += bc;
                // адрес посадки
                e = (a = *hl);
                hl++;
                d = (a = *hl);
                hl++;
                push_pop(hl) {
                    h = d;
                    l = e;
                    FileParserTempAddress = hl;
                }
                // длина
                e = (a = *hl);
                hl++;
                d = (a = *hl);
                hl++;
                // атрибуты
                c = (a = *hl);
                hl++;
                // рабочая страница ОЗУ
                b = (a = *hl);
                push_pop(hl) {
                    hl = FileParserTempAddress;
                    // Записываем атрибуты файла
                    bios(a = biosSetFileAttributes);
                    // Записываем файл с данными из озу
                    bios(a = biosSaveFile);
                    if (flag_c) {
                        // Записать 0 в номер файла - ошибка
                        FileParserFileNum = (a = 0); // TODO надо прервать операцию
                    } else {
                        // Получить номер файла в ОС
                        FileParserSeekFileNum();
                        a = FileParserDataCount;
                        a -= 0x10;
                        FileParserDataCount = a;
                    }
                }
            }
            // Смещаем указатель за заголовок файла
            b = 16;
            do {
                de++;
                b--;
            } while ((a = b) > 0);
        } else {
            push_pop(de, hl) {
                // Если это не первая пачка - уменьшаем значение адреса на заголовок (0x10)
                de = 0xFFF0;
                hl = FileParserLoadFileAddress;
                hl += de;
                FileParserLoadFileAddress = hl;
            }
        }
    }
}

void FileParserSeekFileNum() {
    push_pop(hl, bc, de) {
        de = DiskViewFileName;
        hl = 0x2000;
        bc = 0x0010;
        do {
            push_pop(hl, bc, de) {
                FileParserFileNameCompareHLDEToA();
            }
            if (a == 1) {
                push_pop(hl, bc, de) {
                    de = 0x0FF0;
                    hl &= de;
                    hl <<= 4; //8;
                    // Индекс файла начинаеться с 1, а не с 0
                    a = h;
                    a += 2; //1; ??? TODO почему 2?
                    FileParserFileNum = a;
                }
            }
            hl += bc;
            push_pop(bc, hl) {
                ///hl - адрес, a - номер доп. страницы (1-3). выход: c - считанный байт
                readByteInOtherMem(a = 1);
                if ((a = h) >= 0x3F) {
                    a = 0;
                } else {
                    a = c;
                }
            }
        } while (a > 0);
    }
}

void FileParserFileNameCompareHLDEToA() {
    b = 8;
    do {
        push_pop(bc) {
            readByteInOtherMem(a = 1);
            a = c;
        }
        c = a;
        if ((a = *de) != c) {
            return a = 0;
        }
        b--;
        hl++;
        de++;
    } while ((a = b) > 0);
    return a = 1;
}

void FileParserFtpLoadFileNextParseSum() {
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
            FileParserSumStateNext = a;
        } else {
            a = 0x00;
            FileParserSumStateNext = a;
        }
        //-- 3 byte = byte 0x3C
        hl = Net_buffer;
        hl++;
        hl++;
        hl++;
        a = *hl;
        if (a != 0x3C) {
            a = 0x00;
            FileParserSumStateNext = a;
        }
    }
}

// DE = буфер
void FileParserFtpLoadSaveBufferInFile() {
    push_pop(hl, bc) {
        // Адрес с которого начинаем писатьв файл
        hl = FileParserLoadFileAddress;
        // Кол-во байт для записи
        c = (a = FileParserDataCount);
        FileParserFtpUpdatePosSectorByHL();
        do {
            //--
            push_pop(hl, bc) {
                c = (a = *de);
                h = (a = FileParserSectorNum);
                /// hl = addr a = page c = byte
                writeByteInOtherMem(a = FileParserSectorPage);
            }
            //--
            c--;
            hl++;
            de++;
            if ((a = l) == 0) {
                FileParserFtpUpdatePosSectorByHL();
            }
        } while ((a = c) > 0);
    }
}

void FileParserFtpUpdatePosSectorByHL() {
    push_pop(hl, bc, de) {
        // Обнуляем сектор начала поиска
        FileParserSectorDeltaPage = (a = 0);
        // Ищем h раз по номеру FileParserFileNum
        l = (a = FileParserFileNum);
        de = 0x3000;
        b = 0; // Page 2/3 4/5 5/7
        c = 0; // Sector
        do {
            push_pop(bc, hl) {
                ///hl - адрес, a - номер доп. страницы (1-3). выход: c - считанный байт
                h = d;
                l = e;
                readByteInOtherMem(a = 1);
                a = c;
            }
            //a = *de;
            if (a == l) {
                if ((a = h) == 0) {
                    a = b;
                    a += 2;
                    b = a;
                    a = FileParserSectorDeltaPage;
                    a += b;
                    FileParserSectorPage = a;
                    FileParserSectorNum = (a = c);
                    a = 1;
                } else {
                    h--;
                    FileParserNextSectorCPageB();
                    a = 0;
                }
            } else {
                FileParserNextSectorCPageB();
                a = 0;
            }
            de++;
        } while (a == 0);
    }
}

void FileParserNextSectorCPageB() {
    push_pop(a) {
        b++;
        if ((a = b) >= 0x02) {
            b = 0;
            c++;
            if ((a = c) == 0) {
                a = FileParserSectorDeltaPage;
                a += 2;
                FileParserSectorDeltaPage = a;
            }
        }
    }
}

uint8_t FileParserSectorDeltaPage = 0;
uint8_t FileParserSectorPage = 0;
uint8_t FileParserSectorNum = 0;

uint8_t FileParserDataCount = 0;
uint8_t FileParserFileNum = 0;
uint8_t FileParserSumStateNext = 0;
uint16_t FileParserLoadFileAddress = 0;
uint16_t FileParserLoadFileStopAddress = 0;
uint16_t FileParserTempAddress = 0;

#endif /* FileParserFunctions_h */
