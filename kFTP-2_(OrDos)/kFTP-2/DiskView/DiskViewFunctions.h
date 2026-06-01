//
//  DiskViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DiskViewFunctions_h
#define DiskViewFunctions_h

void DiskViewShow() {
    a = DiskViewX;
    h = a;
    a = DiskViewY;
    l = a;
    a = DiskViewDX;
    d = a;
    a = DiskViewDY;
    e = a;
    a = DiskViewColor;
    vboxOpenHLDE();
    vboxBorderHLDE();
    DiskViewShowTitle();
    
    //DEBUG!!!
    DiskViewSetDiskNumA(a = 'B');
}

void DiskViewShowTitle() {
    a = DiskViewX;
    a++;
    myCharPosX = a;
    a = DiskViewY;
    myCharPosY = a;
    printMyHLStr(hl = DiskViewTitle);
}

void DiskViewUpdateDir() {
    push_pop(hl) {
        a = DiskViewDiskNum;
        ordos_wnd();
        hl = DiskViewDirBufer;
        ordos_dirm();
        DiskViewDirCount = a;
    }
}

/// HL
void DiskViewDirBuferStartIndexToHL() {
    push_pop(de) {
        hl = DiskViewDirBufer;
        d = 0;
        a ^= a;
        a = DiskViewDirStartIndex;
        carry_rotate_left(a, 4);
        e = a;
        if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
            d++;
        }
        hl += de;
    }
}

void DiskViewDirEndIndexCalc() {
    push_pop(bc) {
        //--
        a = DiskViewDirPageCoint;
        c = a;
        //--
        a = DiskViewDirStartIndex;
        b = a;
        a = DiskViewDirCount;
        a -= b;
        if (a >= c) {
            a = c;
        }
        DiskViewDirEndIndex = a;
    }
}

void DiskViewDirProgressLineCalk() {
    push_pop(bc) {
        a = DiskViewDirPageCoint;
        b = a;
        a = DiskViewDirCount;
        a -= b;
        b = a;
        if (a < DiskViewDirProgressCount) {
            a = DiskViewDirProgressCount;
            a -= b;
            DiskViewDirProgressLen = a;
        } else {
            a = 1;
            DiskViewDirProgressLen = a;
        }
    }
}

void DiskViewDirProgressCharByIndexA() {
    push_pop(bc, de) {
        b = a;
        //--
        a = DiskViewDirProgressLen;
        d = a;
        //--
        a = DiskViewDirStartIndex;
        c = a;
        a = b;
        a -= c;
        c = a;
        if (a == 0) {
            a = 0xB1;
        } else if ((a = c) < d ) {
            a = 0xB1;
        } else if ((a = DiskViewDirStartIndex) >= DiskViewDirProgressCount ) {
            //printMyCharA(a = 'F');
            if ((a = b) == DiskViewDirProgressCount-1) {
                a = 0xB1;
            } else {
                a = 0xB0;
            }
        } else {
            a = 0xB0;
        }
    }
}

void DiskViewDirProgress() {
    push_pop(bc, de) {
        //-- d = x
        a = DiskViewX;
        d = a;
        a = DiskViewDX;
        a += d;
        a--;
        d = a;
        //-- e = start y
        a = DiskViewY;
        a += 2; //4;
        e = a;
        //--
        a = DiskViewDirCount;
        c = a;
        if ((a = DiskViewDirPageCoint) < c) {
            DiskViewDirProgressLineCalk();
            //-- TOP
            a = d;
            myCharPosX = a;
            a = e;
            myCharPosY = a;
            e++;
            printMyCharA(a = 0x1E);
            //--
            b = 0;
            do {
                //-- Set pos
                a = d;
                myCharPosX = a;
                a = e;
                myCharPosY = a;
                //--
                DiskViewDirProgressCharByIndexA(a = b);
                printMyCharA();
                //-- Inc pos
                e++;
                //--
                b++;
            } while ((a = b) < DiskViewDirProgressCount);
            //-- BOTTOM
            a = d;
            myCharPosX = a;
            a = e;
            myCharPosY = a;
            printMyCharA(a = 0x1F);
        } else {
            b = DiskViewDirProgressCount;
            b++; // Добавлены 2 символа вверх и вниз
            b++;
            do {
                //-- Set pos
                a = d;
                myCharPosX = a;
                a = e;
                myCharPosY = a;
                //--
                printMyCharA(a = 0xBA);
                //-- Inc pos
                e++;
                //--
                b--;
            } while ((a = b) > 0);
        }
    }
}

void DiskViewDirEndIndexCalcFix() {
    DiskViewDirEndIndexCalc();
    push_pop(bc) {
        a = DiskViewDirPageCoint;
        c = a;
        a = DiskViewDirCount;
        b = a;
        if ((a = DiskViewDirStartIndex) > 0) {
            if ((a = DiskViewDirEndIndex) < c) {
                if ((a = c) >= b) { // Если кол-во файлов равно странице
                    a = 0;
                    DiskViewDirStartIndex = a;
                    a = DiskViewDirCount;
                    DiskViewDirEndIndex = a;
                } else {
                    a = DiskViewDirPageCoint;
                    DiskViewDirEndIndex = a;
                    b = a;
                    a = DiskViewDirCount;
                    a -= b;
                    DiskViewDirStartIndex = a;
                }
            }
        }
    }
}

void DiskViewShowDir() {
    DiskViewDirEndIndexCalcFix();
    DiskViewDirProgress();
    push_pop(hl, bc, de) {
        //-----
        a = DiskViewX;
        a += 2;
        d = a; // X
        a = DiskViewY;
        a += 3;
        e = a; // Y
        //-----
        a = d;
        myCharPosX = a;
        a = e;
        a--;
        myCharPosY = a;
        printMyHLStr(hl = DiskViewDirRootTitle);
        //-----
        if ((a = DiskViewDirCount) >= 1) {
            //hl = DiskViewDirBufer;
            DiskViewDirBuferStartIndexToHL();
            b = 0;
            do {
                a = d;
                myCharPosX = a;
                a = e;
                a += b;
                myCharPosY = a;
                c = 8;
                do {
                    printMyCharA(a = *hl);
                    hl++;
                    c--;
                } while ((a = c) > 0);
                hl++;
                hl++;
                push_pop(de) {
                    a = *hl;
                    e = a;
                    hl++;
                    a = *hl;
                    d = a;
                    printMyCharA(a = ' ');
                    printMyCharA(a = ' ');
                    printMyCharA(a = ' ');
                    printMyCharA(a = ' ');
                    FtpViewShow4CharSizeDE();
                    hl++;
                }
                hl++;
                hl++;
                hl++;
                hl++;
                b++;
                a = DiskViewDirEndIndex;
                a--;
            } while (a >= b);
        }
        // show empty rows
        a = DiskViewDirEndIndex;
        b = a;
        // PosY
        a = e;
        a += b;
        e = a;
        // DY - 4 позиции и - b (кол-во отображаемых файлов)
        a = DiskViewDY;
        a -= 4;
        a -= b;
        b = a;
        c = 0;
        do {
            a = d;
            myCharPosX = a;
            a = e;
            a += c;
            myCharPosY = a;
            //
            a = DiskViewDX;
            a -= 3;
            h = a;
            do {
                printMyCharA(a = ' ');
                h--;
            } while ((a = h) > 0);
            b--;
            c++;
        } while ((a = b) > 0);
    }
}

void DiskViewCurrentFileNameHL() {
    push_pop(bc) {
        h = 0;
        a = DiskViewDirStartIndex;
        c = a;
        a = DiskViewFileCurrentPos;
        a += c; // Прибавить скрол
        a -= 1; // Удалить корневой переход на другой диск
        l = a;
        hl <<= 4;
        b = h;
        c = l;
        hl = DiskViewDirBufer;
        
        hl += bc;
        push_pop(hl) { // Проставляем 0 в конце строки
            bc = 7;
            hl += bc;
            b = 7;
            do {
                a = *hl;
                if (a == 0x20) {
                    a = 0;
                    *hl = a;
                } else {
                    b = 1;
                }
                hl--;
                b--;
            } while ((a = b) > 0);
        }
    }
}

void DiskViewDeleteSelectedFile() {
    push_pop(hl, bc) {
        a = DiskViewDiskNum;
        ordos_wnd();
        DiskViewCurrentFileNameHL();
        ordos_sdma();
        ordos_eras();
        //а = 1 - нет файла
        //а = 4 - файл 'r/o'
        b = a;
        if ((a = b) == 0) {
            DiskViewShowSelectLineA(a = 0);
            a = 0;
            DiskViewFileCurrentPos = a;
            DiskViewUpdateDateAndUI();
            DiskViewShowSelectLineA(a = 1);
        } else if ((a = b) == 1) { // нет файла
            AllertOkViewShowHL(hl = StringLocaleFileNotFound);
        } else if ((a = b) == 4) { // файл 'r/o'
            AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
        } else if ((a = b) == 0x41) { // Диск A
            AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
        } else {
            //printMyHexA(a = b);
        }
    }
}

void DiskViewUploadSelectedFile() {
    push_pop(hl, bc) {
        // Open progress view
        LoadViewShowHL(hl = LoadViewUploadTitle);
        LoadViewShowProgressA(a = 0);
        //-- create point File
        DiskViewCurrentFileNameHL();
        // NET
        NetFtpUploadFileInitHL();
        // Close progress
        LoadViewClose();
    }
}

void DiskViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == DiskViewId) {
            if ((a = l) == 0x09) { //0x09 TAB
                CurrentViewChangeIdA(a = FtpViewId);
            } else {
                if ((a = l) == 0x1A) { //down
                    DiskViewFileCurrentPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    DiskViewFileCurrentPosUpdateA(a = 0xFF);
                } else if ((a = l) == 0x0D) { //Enter
                    if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
                        DiskViewNextDiskNum();
                    } else { // Запуск приложения
                        DiskViewSelectFileExec();
                    }
                } else if ((a = l) == 'E') {
                    if ((a = DiskViewFileCurrentPos) > 0) {
                        AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
                        if (a == 1) {
                            DiskViewDeleteSelectedFile();
                        }
                    }
                } else if ((a = l) == 'D') { //  Показать выбор диска
                    SelectDiskViewShow();
                } else if ((a = l) == 'C') { // Загрузка файла на FTP
                    if ((a = DiskViewFileCurrentPos) != 0) {
                        DiskViewUploadSelectedFile();
                        FtpViewNetLoadAndUpdate(); // обновляем список файлов FTP
                    }
                } else if ((a = l) == 'F') { //  Отформатировать диск
                    DiskViewFormat();
                }
            }
        }
    }
}

void DiskViewFormat() {
    push_pop(hl) {
        AllertYesNoViewShowHL(hl = StringLocaleDiskFormat);
        if (a == 1) {
            a = DiskViewDiskNum;
            ordos_wnd();
            hl = 0;
            ordos_wdisk(a = 0xFF);
            DiskViewReload();
        }
    }
}

void DiskViewSelectFileExec() {
    push_pop(hl,de,bc) {
        //
        unpackCharCode();
        //-- ResidentProgram Copy
        push_pop(de,bc) {
            de = DiskViewExecData;
            hl = 0xA800; //0xF000;
            b = 8;
            do {
                a = *de;
                *hl = a;
                de++;
                hl++;
                b--;
            } while ((a = b) > 0);
        }
        a = DiskViewDiskNum;
        ordos_wnd();
        DiskViewCurrentFileNameHL();
        DiskViewResidentProgram();
        //-- Go to height
//        ordos_sdma();
//        ordos_rfile();
//        
//        return hl();
    }
}

/// Проверка, хватит ли места на текущем диске для файла
/// вх[DE] - размер предпологаемого файла. Еще надо прибавить 16 - для заголовка
/// вых[A] - 0 - места нет, 1 - место есть
void DiskViewIsDiskSpaceDE() {
    push_pop(hl, de) {
        //-- Add 16
        hl = 16;
        hl += de;
        d = h;
        e = l;
        //--
        DiskViewDiskFreeSpaceHL();
        DiskViewHLSubDE();
    }
}

/// HL = HL + (-DE)
/// вх[DE,HL]
/// вых[HL, A] - HL - результат вычитания , A = 1 HL > DE
void DiskViewHLSubDE() {
    push_pop(de) {
        a = d; // Инвертируем старший байт D
        invert(a);
        d = a;
        a = e; // Инвертируем младший байт E
        invert(a);
        e = a;
        de++; // Получаем точный дополнительный код DE (-DE)
        a ^= a;
        hl += de; // HL = HL + (-DE), что эквивалентно HL - DE
        if (flag_c) { // Если HL > DE: перенос будет C = 1.
            a = 1;
        } else {
            a = 0;
        }
    }
}

/// Возвращает свободное место на диске
/// вых[HL] - результат
void DiskViewDiskFreeSpaceHL() {
    push_pop(de) {
        a = DiskViewDiskNum;
        ordos_wnd();
        ordos_mxdsk();
        d = h;
        e = l;
        //--
        ordos_rmax();
        //--
        DiskViewHLSubDE();
    }
}

void DiskViewShowFreeSpace() {
    push_pop(de, hl) {
        a = DiskViewX;
        e = a;
        a = DiskViewDX;
        a += e;
        a -= 7;
        myCharPosX = a;
        a = DiskViewY;
        e = a;
        a = DiskViewDY;
        a += e;
        a--;
        myCharPosY = a;
        //-- 0xB5
        printMyCharA(a = 0xB5);
        //--
        DiskViewDiskFreeSpaceHL();
        d = h;
        e = l;
        FtpViewShow4CharSizeDE();
        //-- 0xC6
        printMyCharA(a = 0xC6);
    }
}

void DiskViewNextDiskNum() {
    a = DiskViewDiskNum;
    a++;
    if (a == 'E') {
        a = 'A';
    }
    DiskViewSetDiskNumA();
}

void DiskViewSetDiskNumA() {
    push_pop(bc) {
        c = a;
        a = DiskViewDiskNum;
        if (a != c) {
            a = c;
            DiskViewDiskNum = a;
            #ifdef _IS_SIMULATOR
            #else
                NetDiskSetNum();
            #endif
            DiskViewReload();
        }
    }
}

void DiskViewReload() {
    DiskViewShowSelectLineA(a = 0);
    a = 0;
    DiskViewDirStartIndex = a;
    DiskViewFileCurrentPos = a;
    DiskViewUpdateDiskTitle();
    DiskViewUpdateDateAndUI();
}

void DiskViewUpdateDateAndUI() {
    DiskViewUpdateDir();
    DiskViewShowDir();
    if ((a = CurrentViewId) == DiskViewId) {
        DiskViewShowSelectLineA(a = 1);
    }
    DiskViewShowFreeSpace();
}

void DiskViewUpdateDiskTitle() {
    a = DiskViewX;
    a += 7;
    myCharPosX = a;
    a = DiskViewY;
    myCharPosY = a;
    printMyCharA(a = DiskViewDiskNum);
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void DiskViewFileCurrentPosUpdateA() {
    push_pop(bc, de) {
        b = a;
        DiskViewDirEndIndexCalc();
        if (a == 0) {
            DiskViewShowSelectLineA(a = 1);
        } else {
            a = DiskViewDirEndIndex; //DiskViewDirCount;
            a += 1;
            c = a;
            DiskViewShowSelectLineA(a = 0);
            a = DiskViewFileCurrentPos;
            a += b;
            d = a;
            //
            if (a == 0xFF) {
                // Можно ли скролить вверх
                a = DiskViewDirStartIndex;
                if (a > 0) {
                    a--;
                    DiskViewDirStartIndex = a;
                    DiskViewShowDir();
                    a = 0;
                } else {
                    #ifdef _IS_CYCLIC_MOVEMENT_THROUGH_THE_LIST_OF_FILES
                        a = 0;
                    #else
                        push_pop(bc) {
                            a = DiskViewDirPageCoint;
                            b = a;
                            a = DiskViewDirCount;
                            if (a >= b) {
                                a -= b;
                                DiskViewDirStartIndex = a;
                            } else {
                                a = 0;
                                DiskViewDirStartIndex = a;
                            }
                        }
                        DiskViewShowDir();
                        a = c;
                        a--;
                    #endif
                }
            } else if (a == c) {
                // Можно ли еще скролить вниз
                push_pop(bc) {
                    b = a;
                    a = DiskViewDirCount;
                    a++;
                    c = a;
                    a = DiskViewDirStartIndex;
                    a += b;
                    if (a < c) {
                        a = DiskViewDirStartIndex;
                        a++;
                        DiskViewDirStartIndex = a;
                        DiskViewShowDir();
                        a = b;
                        a--;
                    } else {
                        #ifdef _IS_CYCLIC_MOVEMENT_THROUGH_THE_LIST_OF_FILES
                            a = d;
                            a--;
                        #else
                            a = 0;
                            DiskViewDirStartIndex = a;
                            DiskViewShowDir();
                            a = 0;
                        #endif
                    }
                }
            }
            DiskViewFileCurrentPos = a;
            DiskViewShowSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void DiskViewShowSelectLineA() {
    push_pop(bc, hl, de) {
        c = a;
        // HL
        a = DiskViewFileCurrentPos;
        b = a;
        a = DiskViewY;
        a += 2;
        a += b;
        l = a;
        a = DiskViewX;
        a += 1;
        h = a;
        // DE
        a = DiskViewDX;
        a -= 2;
        d = a;
        a = 1;
        e = a;
        // C
        if ((a = c) == 0) {
            a = DiskViewColor;
        } else {
            a = DiskViewInvColor;
        }
        c = a;
        // A
        a = vboxUMP;
        vboxOpenHLDECA();
    }
}

uint8_t DiskViewX = 28;
uint8_t DiskViewY = 4;
uint8_t DiskViewDX = 20;
uint8_t DiskViewDY = 25;
uint8_t DiskViewColor = 0x1F;
uint8_t DiskViewInvColor = 0xF1;

uint8_t DiskViewDiskNum = 'B';
uint8_t DiskViewDirCount = 0;
uint16_t DiskViewDirBufer = 0x0000;
uint8_t DiskViewFileCurrentPos = 0;

uint8_t DiskViewDirStartIndex = 0;
uint8_t DiskViewDirEndIndex = 0;
uint8_t DiskViewDirPageCoint = 20;

uint8_t DiskViewDirProgressLen = 0;

uint16_t DiskViewStartNewFile = 0x0000;

uint8_t DiskViewDirRootTitle[] = "..";
uint8_t DiskViewTitle[] = {0xB5, 'D', 'i', 's', 'k', ':', 'A', 0xC6, '\0'};


uint8_t DiskViewExecData[] = {0xCD , 0xD0 , 0xBF , 0xCD , 0xFA , 0xBF , 0xE9 , 0x00};

#endif /* DiskViewFunctions_h */
