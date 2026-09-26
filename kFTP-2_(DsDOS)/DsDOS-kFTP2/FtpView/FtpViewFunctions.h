//
//  FtpViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 12.07.2026.
//

#ifndef FtpViewFunctions_h
#define FtpViewFunctions_h

void FtpViewShow() {
    push_pop(bc, hl, de) {
        bios(a = biosSetExtDRVConfigB, b = 0x02);
        c = (a = FtpViewColor);
        l = (a = FtpViewX);
        h = (a = FtpViewY);
        e = (a = FtpViewDX);
        d = (a = FtpViewDY);
        bios(a = biosWindowOpen);
        MyFuncSetFullScreen();
        FtpViewShowTitle();
        
        #ifdef _IS_SIMULATOR
            FtpViewShowFileList();
            FtpViewShowPath();
            FtpViewFileCurrentPos = (a = 0);
            FtpViewShowSelectLineA(a = 1);
        #else
            FtpViewNetLoadAndUpdate();
        #endif
    }
}

void FtpViewShowTitle() {
    a = FtpViewX;
    a++;
    l = a;
    h = (a = FtpViewY);
    bios(a = biosSetPositionCursoreHL);
    bios(a = biosPrintMessageHL, hl = FtpViewTitle);
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpViewShowSelectLineA() {
    push_pop(bc) {
        c = a;
        // HL
        a = FtpViewFileCurrentPos;
        b = a;
        a = FtpViewY;
        a += 2;
        a += b;
        h = a;
        a = FtpViewX;
        a += 1;
        l = a;
        // DE
        a = FtpViewDX;
        a -= 2;
        e = a;
        a = 1;
        d = a;
        // C
        if ((a = c) == 0) {
            a = FtpViewColor;
        } else {
            a = FtpViewInvColor;
        }
        c = a;
        // A
        MyViewChangeBoxColor();
    }
}

void FtpViewShowPath() {
    push_pop(bc, de, hl) {
        bios(c = (a = FtpViewColor), a = biosSetColorC);
        //--
        a = FtpViewX;
        b = a;
        a = FtpViewDX;
        a += b;
        a -= 19;
        l = a;
        h = (a = FtpViewY);
        bios(a = biosSetPositionCursoreHL);
        de = FtpViewPath;
        bios(a = biosPrintC, c = 0x82);
        b = 16;
        c = 0;
        do {
            a = *de;
            de++;
            if (a == 0) {
                c = 1;
            }
            h = a;
            if ((a = c) == 0) {
                push_pop(bc) {
                    bios(a = biosPrintC, c = h);
                }
            } else {
                push_pop(bc) {
                    bios(a = biosPrintC, c = ' ');
                }
            }
            b--;
        } while ((a = b) > 0);
        bios(a = biosPrintC, c = 0x92);
    }
}

void FtpViewShowFileList() {
    //-- нельзя обновлять, если есть хоть какое то открытое окно
    CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
    if (a == 0) {
        return;
    }
    //--
    push_pop(bc, de, hl) {
        bios(c = (a = FtpViewColor), a = biosSetColorC);
        // Заполнить пустыми строками
        a = FtpViewX;
        a += 1;
        d = a; // X
        a = FtpViewY;
        a += 2;
        e = a; // Y
        //
        a = FtpViewDY;
        a -= 4;
        b = a;
        c = 0;
        do {
            a = e;
            a += c;
            push_pop(hl) {
                bios(l = d, h = a, a = biosSetPositionCursoreHL);
            }
            //
            a = FtpViewDX;
            a -= 2;
            h = a;
            do {
                push_pop(bc) {
                    bios(a = biosPrintC, c = ' ');
                }
                h--;
            } while ((a = h) > 0);
            b--;
            c++;
        } while ((a = b) > 0);
        //--
        b = 0;
        a = FtpViewFilesListCount;
        hl = FtpViewFilesList;
        c = a;
        do {
            push_pop(hl) {
                a = FtpViewY;
                a += 2;
                a += b;
                h = a;
                a = FtpViewX;
                a += 2;
                l = a;
                bios(a = biosSetPositionCursoreHL);
            }
            FtpViewShowFileHL();
            // HL + 16 next file
            a ^= a;
            a = 16;
            a += l;
            l = a;
            if (flag_c) {
                h++;
            }
            b++;
        } while ((a = b) < c);
    }
}

void FtpViewShowFileHL() {
    push_pop(bc, hl) {
        if ((a = b) == 0) {
            FtpViewShowFileName();
        } else {
            FtpViewShowFileName();
            FtpViewShowFileSize();
            FtpViewShowFileDate();
        }
    }
}

void FtpViewShowFileName() {
    push_pop(bc) {
        // X pos
        //    a = FtpViewX;
        //    a += 2;
        //    myCharPosX = a;
        //
        b = 8;
        do {
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void FtpViewShowFileSize() {
    push_pop(bc, de) {
        // X pos
        push_pop(hl) {
            bios(a = biosGetPositionCursoreHL);
            a = FtpViewX;
            a += 11;
            l = a;
            bios(a = biosSetPositionCursoreHL);
        }
        //
        a = *hl;
        d = a;
        hl++;
        a = *hl;
        e = a;
        hl++;
        a = *hl;
        hl++;
        a &= 0x01;
        if (a == 0x00) {
            push_pop(hl) {
                h = 0; // файл для Орион
                if ((a = d) == 0xFF) {
                    if ((a = e) == 0xFF) {
                        h = 1; // Файл слишком большой для Орион
                    }
                }
                if ((a = h) == 0) { // Показываем размер
                    FtpViewShow4CharSizeDE();
                } else { // Файл слишком большой
                    bios(a = biosPrintC, c = ' ');
                    bios(a = biosPrintC, c = 'B');
                    bios(a = biosPrintC, c = 'I');
                    bios(a = biosPrintC, c = 'G');
                }
            }
            FtpViewShowIsDirA(a = 0);
        } else {
            bios(a = biosPrintC, c = ' ');
            bios(a = biosPrintC, c = ' ');
            bios(a = biosPrintC, c = ' ');
            bios(a = biosPrintC, c = ' ');
            FtpViewShowIsDirA(a = 1);
        }
    }
}

void FtpViewShow4CharSizeDE() {
    push_pop(hl, bc) {
        MyFunc4CharSizeDE();
        hl = MyFunc4Chars;
        b = 4;
        do {
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

// A = 1 - Dir
void FtpViewShowIsDirA() {
    push_pop(bc) {
        a &= 0x01;
        b = a;
        push_pop(hl) {
            bios(a = biosGetPositionCursoreHL);
            a = FtpViewX;
            a += 1;
            l = a;
            bios(a = biosSetPositionCursoreHL);
        }
        if ((a = b) == 1) {
            bios(a = biosPrintC, c = 0xB3);
        } else {
            bios(a = biosPrintC, c = ' ');
        }
    }
}

void FtpViewShowFileDate() {
    push_pop(bc, de) {
        // X pos
        push_pop(hl) {
            bios(a = biosGetPositionCursoreHL);
            a = FtpViewX;
            a += 16;
            l = a;
            bios(a = biosSetPositionCursoreHL);
        }
        //-- GGGG
        d = *hl;
        hl++;
        e = *hl;
        hl++;
        push_pop(hl) {
            h = d;
            l = e;
            bios(a = biosPrintWordHL, b = 0x01);
        }
        //--
        bios(a = biosPrintC, c = '-');
        //--
        push_pop(hl, bc) {
            a = *hl;
            hl = MyFunc4Chars;
            MyFuncDec099A();
            hl = MyFunc4Chars;
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            bios(c = (a = *hl), a = biosPrintC);
        }
        hl++;
        //--
        bios(a = biosPrintC, c = '-');
        //--
        push_pop(hl, bc) {
            a = *hl;
            hl = MyFunc4Chars;
            MyFuncDec099A();
            hl = MyFunc4Chars;
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            bios(c = (a = *hl), a = biosPrintC);
        }
        hl++;
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void FtpViewFileCurrentPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            FtpViewShowSelectLineA(a = 1);
        } else {
            a = FtpViewFilesListCount;
            c = a;
            FtpViewShowSelectLineA(a = 0);
            a = FtpViewFileCurrentPos;
            a += b;
            //
            if (a == 0xFF) {
                a = c;
                a--;
            } else if (a == c) {
                a = 0;
            }
            FtpViewFileCurrentPos = a;
            FtpViewShowSelectLineA(a = 1);
        }
    }
}

void FtpViewNetLoadAndUpdate() {
    FtpViewShowSelectLineA(a = 0);
    NetSetIsDsDos();
    NetFtpGetCurrentPath();
    if ((a = FtpHeaderViewStatus) == 1) {
        NetSetIsDsDos();
        NetFtpUpdateList();
        NetFtpListFiles();
    }
    a = 0;
    FtpViewFileCurrentPos = a;
    FtpViewShowFileList();
    FtpViewShowPath();
    // Показываем курсор, если выбран FTP
    if ((a = CurrentViewId) == FtpViewId) {
        FtpViewShowSelectLineA(a = 1);
    }
}

void FtpViewGetFileNamePointByPosToHL() {
    push_pop(bc) {
        hl = FtpViewFilesList;
        //--
        a ^= a;
        a = FtpViewFileCurrentPos;
        a &= 0x3F;
        b = 0;
        carry_rotate_left(a, 4);
        if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
            b++;
        }
        c = a;
        //-- Смещаем на позицию файла
        hl += bc;
    }
}

void FtpViewCurrentPosIsDir() {
    push_pop(hl, bc) {
        hl = FtpViewFilesList;
        //--
        a ^= a;
        a = FtpViewFileCurrentPos;
        a &= 0x3F;
        b = 0;
        carry_rotate_left(a, 4);
        if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
            b++;
        }
        c = a;
        //-- Смещаем на позицию файла
        hl += bc;
        //-- Смещаем на признак директории
        bc = 10;
        hl += bc;
        //--
        a = *hl;
        a &= 0x01;
    }
}

void FtpViewEmptyList() {
    push_pop(hl) {
        a = 1;
        FtpViewFilesListCount = a;
        a = 0;
        FtpViewFileCurrentPos = a;
        hl = FtpViewFilesList;
        //--
        *hl = '.';
        hl++;
        *hl = '.';
        hl++;
        //--
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
    }
    //--
    FtpViewListUpdateUI();
}

void FtpViewListUpdateUI() {
    FtpViewShowSelectLineA(a = 0);
    a = 0;
    FtpViewFileCurrentPos = a;
    FtpViewShowPath();
    FtpViewShowFileList();
    if ((a = CurrentViewId) == FtpViewId) {
        FtpViewShowSelectLineA(a = 1);
    }
}

void FtpViewAccessDiskSpace() {
    push_pop(de, hl) {
        // Находим указатель на файл
        d = 0;
        a ^= a;
        a = FtpViewFileCurrentPos;
        carry_rotate_left(a, 4);
        e = a;
        if (flag_c) {
            d = 1;
        }
        hl = FtpViewFilesList;
        hl += de;
        // Сдвигаем к размеру файла и читаем размер
        de = 8;
        hl += de;
        //
        a = *hl;
        d = a;
        hl++;
        a = *hl;
        e = a;
        //
        DiskViewIsDiskSpaceDE();
        if (a == 1) {
            FtpViewLoadFile();
        } else {
            AllertOkViewShowHL(hl = StringLocaleDiskFull);
        }
    }
}

void FtpViewLoadFile() {
    StringLocaleCreateLoadTitleA();
    //--
    LoadViewShowHL(hl = LoadViewLoadTitle);
    #ifdef _IS_SIMULATOR
        push_pop(bc) {
            b = 0;
            do {
                LoadViewShowProgressA(a = b);
                c = 1;
                do {
                    delay50ms();
                    c--;
                } while ((a = c) > 0);
                b++;
            } while ((a = b) < 40);
            //--
            push_pop(bc, de, hl) {
                hl = MockFileData;
                de = Net_buffer;
                b = 77;
                do {
                    *de = (a = *hl);
                    de++;
                    hl++;
                    b--;
                } while ((a = b) > 0);
                Net_buffer_len = (a = 77);
                l = 77;
                FileParserFtpLoadFileNextParse();
            }
            //--
            LoadViewClose();
            DiskViewUpdateDateAndUI();
        }
    #else
        FtpViewNeedLoad();
        LoadViewClose();
        DiskViewUpdateDateAndUI();
    #endif
}

void FtpViewNeedLoad() {
    NetFtpLoadFileA(a = FtpViewFileCurrentPos);
    NetFtpLoadFileNext();
}

void FtpViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == FtpViewId) {
            if ((a = l) == 0x09) { //0x09 TAB
                CurrentViewChangeIdA(a = DiskViewId);
            } else if ((a = l) == 0x18) { //0x18 Вправо
                CurrentViewChangeIdA(a = DiskViewId);
            } else {
                if ((a = l) == 0x1A) { //down
                    FtpViewFileCurrentPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    FtpViewFileCurrentPosUpdateA(a = 0xFF);
                } else if ((a = l) == 0x0D) { //Enter
                    if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
                        #ifdef _IS_SIMULATOR

                        #else
                            NetFtpChangeDirUp();
                            FtpViewNetLoadAndUpdate();
                        #endif
                    } else {
                        FtpViewCurrentPosIsDir();
                        if (a == 1) { // Enter Dir
                            #ifdef _IS_SIMULATOR

                            #else
                                FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
                                NetFtpChangeDirIndexA(a = FtpViewFileCurrentPos);
                                FtpViewNetLoadAndUpdate();
                            #endif
                        } else { // Load file
                            FtpViewAccessDiskSpace();
                        }
                    }
                } else if ((a = l) == 'R') { // Обновление папки
                    FtpViewNetLoadAndUpdate();
                } else if ((a = l) == 'C') { // загрузка файла
                    FtpViewCurrentPosIsDir();
                    if (a == 0) { // Проверим что это файл
                        FtpViewAccessDiskSpace();
                    }
                } else if ((a = l) == 'H') { // Перейти в домашную папку
                    ThreadsNetFtpGoToHomeDir();
                } else if ((a = l) == 'E') { // Удалить файл
                    if ((a = FtpViewFileCurrentPos) > 0) {
                        AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
                        if (a == 1) {
                            #ifdef _IS_SIMULATOR

                            #else
                                ThreadsNetFtpDeleteFileA(a = FtpViewFileCurrentPos);
                            #endif
                        }
                    }
                } else if ((a = l) == 'D') { // Создание новой папки
                    #ifdef _IS_SIMULATOR

                    #else
                        //FtpMakeDirectoryShow()
                    #endif
                }
            }
        }
    }
}


uint8_t FtpViewX = 0;
uint8_t FtpViewY = 4;
uint8_t FtpViewDX = 28;
uint8_t FtpViewDY = 25;
uint8_t FtpViewColor = 0x1F;
uint8_t FtpViewInvColor = 0xF1;

uint8_t FtpViewTitle[] = {0x82, 'F', 'T', 'P', 0x92, '\0'};
uint8_t FtpViewPath[16] = "/";

uint8_t FtpViewFileCurrentPos = 0;
// NN NN NN NN NN NN NN NN ZZ ZZ Di GG GG MM DD 0x00
#ifdef _IS_SIMULATOR
    uint8_t FtpViewFilesListCount = 7;
    uint8_t FtpViewFilesList[16 * 23] = {
        '.', '.', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
        'f', 'i', 'l', 'e', '.', 'T', 'X', 'T', 0x00, 0xCF, 0x3C, 0x07, 0xCE, 0x0A, 0x1E, 0x00, // -00-12
        'S', 'o', 'f', 't', ' ', ' ', ' ', ' ', 0x00, 0x00, 0x3D, 0x07, 0xEA, 0x02, 0x0A, 0x00, // -00-31
        'V', 'C', '$', ' ', ' ', ' ', ' ', ' ', 0x0E, 0x00, 0x3C, 0x07, 0xEA, 0x02, 0x0A, 0x00, // -00-23
        'M', '1', '2', '8', '_', '2', '$', ' ', 0x08, 0xC0, 0x3C, 0x07, 0xEA, 0x02, 0x0A, 0x00, // -00-31
        'G', 'A', 'M', 'E', 'S', ' ', ' ', ' ', 0x00, 0x00, 0x3D, 0x07, 0xEA, 0x02, 0x0A, 0x00, // -00-31
        'S', 'A', 'B', 'O', 'T', '1', '$', ' ', 0x90, 0x20, 0x3C, 0x07, 0xEA, 0x02, 0x0A, 0x00, // -00-31
};
#else
    uint8_t FtpViewFilesListCount = 1;
    uint8_t FtpViewFilesList[16 * 23] = {
        '.', '.', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
};
#endif

#endif /* FtpViewFunctions_h */
