//
//  DiskViewFunctions.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 12.07.2026.
//

#ifndef DiskViewFunctions_h
#define DiskViewFunctions_h

void DiskViewStart() {
    DiskViewSetDiskNumA(a = 'A');
    //DiskViewReload();
    DiskViewShow();
}

void DiskViewShow() {
    c = (a = DiskViewColor);
    l = (a = DiskViewX);
    h = (a = DiskViewY);
    e = (a = DiskViewDX);
    d = (a = DiskViewDY);
    b = MyViewByteFrame;
    MyViewShow();
    DiskViewShowTitle();
    DiskViewUpdateDiskTitle();
    DiskViewReload();
}

void DiskViewShowTitle() {
    a = DiskViewX;
    a++;
    l = a;
    h = (a = DiskViewY);
    bios(a = biosSetPositionCursoreHL);
    bios(a = biosPrintMessageHL, hl = DiskViewTitle);
}

void DiskViewSetDiskNumA() {
    push_pop(bc, de) {
        b = a;
        bios(a = biosGetDiskC);
        if ((a = b) != c) {
            d = c;
            bios(a = biosSetDiskC, c = b);
            if (flag_c) {

            } else {
                #ifdef _IS_SIMULATOR
                    
                #else
                    NetDiskSetNum();
                #endif
                DiskViewReload();
            }
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

void DiskViewUpdateDiskTitle() {
    push_pop(hl, bc) {
        bios(c = (a = DiskViewColor), a = biosSetColorC);
        a = DiskViewX;
        a += 7;
        l = a;
        h = (a = DiskViewY);
        bios(a = biosSetPositionCursoreHL);
        bios(a = biosGetDiskC);
        bios(a = biosPrintC);
    }
}

void DiskViewUpdateDateAndUI() {
    DiskViewUpdateDir();
    DiskViewShowDir();
    if ((a = CurrentViewId) == DiskViewId) {
        DiskViewShowSelectLineA(a = 1);
    }
    DiskViewShowFreeSpace();
}

void DiskViewShowFreeSpace() {
    push_pop(de, hl, bc) {
        a = DiskViewX;
        e = a;
        a = DiskViewDX;
        a += e;
        a -= 7;
        l = a;
        a = DiskViewY;
        e = a;
        a = DiskViewDY;
        a += e;
        a--;
        h = a;
        bios(a = biosSetPositionCursoreHL);
        //-- 0x82
        bios(a = biosPrintC, c = 0x82);
        //--
        bios(a = biosUpdateInfoDisk);
        bios(a = biosGetInfoDisk, c = 0x01);
        d = h;
        e = l;
        MyFunc4CharSizeDE();
        //--
        hl = MyFunc4Chars;
        b = 4;
        do {
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            b--;
        } while ((a = b) > 0);
        //-- 0x92
        bios(a = biosPrintC, c = 0x92);
    }
}

void DiskViewUpdateDir() {
    push_pop(hl, bc) {
        //[C] – номер первого
        c = (a = DiskViewDirStartIndex);
        c++;
        //[B] – max кол-во
        b = (a = DiskViewDirPageCoint);
        hl = DiskViewDirBufer;
        bios(a = biosUpdateDirHL);
        if (flag_c) {
            a = 0;
            DiskViewDirCount = a;
        } else {
            DiskViewDirCount = a;
        }
    }
}

void DiskViewShowFileSizeHL() {
    e = (a = *hl);
    hl++;
    d = (a = *hl);
    hl++;
    MyFunc4CharSizeDE();
    //--
    push_pop(bc, hl) {
        // Отступ
        b = 4;
        do {
            bios(c = ' ', a = biosPrintC);
            b--;
        } while ((a = b) > 0);
        //--
        hl = MyFunc4Chars;
        b = 4;
        do {
            bios(c = (a = *hl), a = biosPrintC);
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void DiskViewShowFileNameHL() {
    push_pop(bc) {
        b = 8;
        do {
            bios(c = (a = *hl), a = biosPrintC);
            //--
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void DiskViewShowFilePosB() {
    push_pop(hl, de, bc) {
        h = 0;
        l = b;
        hl <<= 4;
        d = h;
        e = l;
        hl = DiskViewDirBufer;
        hl += de;
        //--
        DiskViewShowFileNameHL();
        hl++;
        hl++;
        DiskViewShowFileSizeHL();
    }
}

void DiskViewShowEmptyFile() {
    push_pop(bc) {
        a = DiskViewDX;
        a -= 4;
        b = a;
        do {
            bios(a = biosPrintC, c = ' ');
            b--;
        } while ((a = b) > 0);
    }
}

void DiskViewShowDir() {
    push_pop(hl, bc, de) {
        bios(c = (a = DiskViewColor), a = biosSetColorC);
        a = DiskViewX;
        a += 2;
        l = a;
        a = DiskViewY;
        a += 2;
        h = a;
        //-- HL позиция
        a = DiskViewDirCount;
        if (a > 0) {
            b = 0;
            do {
                bios(a = biosSetPositionCursoreHL);
                h++;
                //--
                a = DiskViewDirCount;
                a--;
                if (a >= b) {
                    DiskViewShowFilePosB();
                } else {
                    DiskViewShowEmptyFile();
                }
                //--
                b++;
                a = DiskViewDirPageCoint;
                a--;
            } while (a >= b);
        } else {
            b = (a = DiskViewDirPageCoint);
            do {
                bios(a = biosSetPositionCursoreHL);
                h++;
                DiskViewShowEmptyFile();
                b--;
            } while ((a = b) > 0);
        }
    }
    
    //DiskViewDirProgress();
//    push_pop(hl, bc, de) {
//        a = DiskViewX;
//        a += 2;
//        l = a;
//        a = DiskViewY;
//        a += 2;
//        h = a;
//        // В HL храним курсор
//        //-- RootTitle
//        bios(a = biosSetPositionCursoreHL);
//        push_pop(hl) {
//            bios(a = biosPrintMessageHL, hl = DiskViewDirRootTitle);
//        }
//        //-- List DiskViewDirPageCoint
//        b = 0;
//        c = (a = DiskViewDirCount);
//        c--;
//        do {
//            h++;
//            bios(a = biosSetPositionCursoreHL);
//            push_pop(hl) {
//                if ((a = c) >= b) {
//                    DiskViewDirBuferBIndexToHL();
//                    DiskViewDirBuferFileName();
//                } else {
//                    MyFuncPrintHLStrLenA(hl = DiskViewDirNameEmpty, a = 16);
//                }
//            }
//            b++;
//            a = DiskViewDirPageCoint;
//            a--;
//        } while (a >= b);
//    }
}

void DiskViewDirBuferFileName() {
    push_pop(bc) {
        b = 8;
        do {
            bios(a = biosPrintC, c = (a = *hl));
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void DiskViewDirBuferBIndexToHL() {
    push_pop(de) {
        hl = DiskViewDirBufer;
        d = 0;
        a ^= a;
        a = b;
        carry_rotate_left(a, 4);
        e = a;
        if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
            d++;
        }
        hl += de;
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
        h = a;
        a = DiskViewX;
        a += 1;
        l = a;
        // DE
        a = DiskViewDX;
        a -= 2;
        e = a;
        a = 1;
        d = a;
        // C
        if ((a = c) == 0) {
            a = DiskViewColor;
        } else {
            a = DiskViewInvColor;
        }
        c = a;
        // A
        MyViewChangeBoxColor();
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

/// Проверка, хватит ли места на текущем диске для файла
/// вх[DE] - размер предпологаемого файла. Еще надо прибавить 16 - для заголовка
/// вых[A] - 0 - места нет, 1 - место есть
void DiskViewIsDiskSpaceDE() {
    push_pop(hl, de) {
        //-- Add 16
        hl = 16;
        hl += de;
        //-- byte -> kByte
        a = h;
        a &= 0xFC;
        cyclic_rotate_right(a, 2);
        if (a == 0) {
            a++;
        }
        d = 0;
        e = a;
        //--
        DiskViewDiskFreeSpaceHL();
        //--
        DiskViewHLSubDE();
    }
}

/// Возвращает свободное место на диске
/// вых[HL] - результат
void DiskViewDiskFreeSpaceHL() {
    push_pop(bc, de) {
        bios(a = biosUpdateInfoDisk);
        bios(a = biosGetInfoDisk, c = 0x01);
//        d = h;
//        e = l;
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

void DiskViewCopyFileNameByHL() {
    push_pop(hl, de, bc) {
        de = DiskViewFileName;
        b = 8;
        do {
            *de = (a = *hl);
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
        *de = (a = 0);
    }
}

void DiskViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == DiskViewId) {
            if ((a = l) == 0x09) { //0x09 TAB
                CurrentViewChangeIdA(a = FtpViewId);
            } else if ((a = l) == 0x08) { // 0x08 Влево
                CurrentViewChangeIdA(a = FtpViewId);
            } else {
                if ((a = l) == 0x1A) { //down
                    DiskViewFileCurrentPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    DiskViewFileCurrentPosUpdateA(a = 0xFF);
                } else if ((a = l) == 0x0D) { //Enter
                    if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
                        //DiskViewNextDiskNum();
                    } else { // Запуск приложения
                        //DiskViewSelectFileExec();
                    }
                } else if ((a = l) == 'E') {
                    if ((a = DiskViewFileCurrentPos) > 0) {
                        AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
                        if (a == 1) {
                            //DiskViewDeleteSelectedFile();
                        }
                    }
                } else if ((a = l) == 'D') { //  Показать выбор диска
                    SelectDiskViewShow();
                } else if ((a = l) == 'C') { // Загрузка файла на FTP
                    if ((a = DiskViewFileCurrentPos) != 0) {
                        //DiskViewUploadSelectedFile();
                        FtpViewNetLoadAndUpdate(); // обновляем список файлов FTP
                    }
                } else if ((a = l) == 'F') { //  Отформатировать диск
                    //DiskViewFormat();
                }
            }
        }
    }
}

uint8_t DiskViewX = 28;
uint8_t DiskViewY = 4;
uint8_t DiskViewDX = 20;
uint8_t DiskViewDY = 25;
uint8_t DiskViewColor = 0x1F;
uint8_t DiskViewInvColor = 0xF1;

uint8_t DiskViewDirCount = 0;
uint16_t DiskViewDirBufer = 0x0000;
uint8_t DiskViewFileCurrentPos = 0;

uint8_t DiskViewDirStartIndex = 0;
uint8_t DiskViewDirEndIndex = 0;
uint8_t DiskViewDirPageCoint = 20;

uint8_t DiskViewDirProgressLen = 0;

uint8_t DiskViewDirRootTitle[] = "..";
uint8_t DiskViewDirNameEmpty[] = "";
uint8_t DiskViewTitle[] = {0x82, 'D', 'i', 's', 'k', ':', 'A', 0x92, '\0'};

uint8_t DiskViewFileName[9];

#endif /* DiskViewFunctions_h */
