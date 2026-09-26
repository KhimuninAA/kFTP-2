//
//  MyFuncFunctions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef MyFuncFunctions_h
#define MyFuncFunctions_h

/// Выводит строку из HL с текущего положения
/// Длиной A. Если текст короче , то добиват до A пробелами
void MyFuncPrintHLStrLenA() {
    push_pop(bc, de) {
        b = a;
        d = 0;
        do {
            a = *hl;
            if (a > 0) {
                d++;
                c = a;
                bios(a = biosPrintC);
            }
            a = *hl;
            hl++;
        } while (a > 0);
        if ((a = d) < b) {
            a = b;
            a -= d;
            b = a;
            do {
                bios(a = biosPrintC, c = ' ');
                b--;
            } while ((a = b) > 0);
        }
    }
}

/// Выводит строку из HL с текущего положения заменяя все символы *
/// Длиной A. Если текст короче , то добиват до A пробелами
void MyFuncPrintHLPassLenA() {
    push_pop(bc, de) {
        b = a;
        d = 0;
        do {
            a = *hl;
            if (a > 0) {
                d++;
                bios(a = biosPrintC, c = '*');
            }
            a = *hl;
            hl++;
        } while (a > 0);
        if ((a = d) < b) {
            a = b;
            a -= d;
            b = a;
            do {
                bios(a = biosPrintC, c = ' ');
                b--;
            } while ((a = b) > 0);
        }
    }
}

void MyFuncPosXAddA() {
    push_pop(hl, bc) {
        b = a;
        bios(a = biosGetPositionCursoreHL);
        a = b;
        a += l;
        l = a;
        bios(a = biosSetPositionCursoreHL);
    }
}

/// Спавнение HL и DE
/// CF=1 when DE < HL
/// CF=0 DE >= HL
void MyFuncCompareHlDe() {
    a = d;
    a ^= h;
    if (flag_p) {
    } else {
        a ^= d;
        if (flag_m) {
            return;
        }
        set_flag_c();
        return;
    }
    a = e;
    a -= l;
    a = d;
    carry_sub(a, h);
    return;
}

/// Вывести на экран значение A как десятичное число с ведущем 0
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void MyFuncDec099A() {
    if (a < 0x64) {
        push_pop(bc, de) {
            b = a;
            c = a;
            d = 0;
            e = 10;
            if ((a = b) < e) {
                *hl = (a = '0');
                hl++;
                a = b;
                a += '0';
                *hl = a;
                hl++;
            } else {
                do {
                    a = b;
                    a -= e;
                    b = a;
                    d++;
                } while ((a = b) >= e);
                a = d;
                a += '0';
                *hl = a;
                hl++;
                a = b;
                a += '0';
                *hl = a;
                hl++;
            }
        }
    }
}

/// Вывести на экран значение A как десятичное число
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void MyFuncDec99A() {
    if (a < 0x64) {
        push_pop(bc, de) {
            b = a;
            c = a;
            d = 0;
            e = 10;
            if ((a = b) < e) {
                *hl = (a = ' ');
                hl++;
                a = b;
                a += '0';
                *hl = a;
                hl++;
            } else {
                do {
                    a = b;
                    a -= e;
                    b = a;
                    d++;
                } while ((a = b) >= e);
                a = d;
                a += '0';
                *hl = a;
                hl++;
                a = b;
                a += '0';
                *hl = a;
                hl++;
            }
        }
    }
}

uint16_t MyFuncDec4095HL = 0;
void MyFuncDec4095SaveA(){
    push_pop(hl) {
        hl = MyFuncDec4095HL;
        *hl = a;
        hl++;
        MyFuncDec4095HL = hl;
    }
}
void MyFuncDec4095DeByHl() {
    MyFuncDec4095HL = hl;
    push_pop(bc, de, hl) {
        swap(hl, de);
        de = 0x0FFF;
        MyFuncCompareHlDe();
        if (flag_nc) {
            c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
            //1000
            de = 0x03E8;
            MyFuncCompareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFC18;
                    hl += de;
                    b++;
                    de = 0x03E8;
                    MyFuncCompareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                MyFuncDec4095SaveA();
                c = 1;
            } else {
                MyFuncDec4095SaveA(a = ' ');
            }
            //0100
            de = 0x0064;
            MyFuncCompareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFF9C;
                    hl += de;
                    b++;
                    de = 0x0064;
                    MyFuncCompareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                MyFuncDec4095SaveA();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    MyFuncDec4095SaveA(a = ' ');
                } else {
                    MyFuncDec4095SaveA(a = '0');
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
                MyFuncDec4095SaveA();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    MyFuncDec4095SaveA(a = ' ');
                } else {
                    MyFuncDec4095SaveA(a = '0');
                }
            }
            //0001
            a = l;
            a += '0';
            MyFuncDec4095SaveA();
        }
    }
}

void MyFunc4CharSizeDE() {
    push_pop(hl, de) {
        hl = MyFunc4Chars;
        if ((a = d) < 4) { // < 1024 в байтах //flag_c
            MyFuncDec4095DeByHl();
        } else { // В Кб
            a = d;
            a &= 0xFC;
            cyclic_rotate_right(a, 2);
            MyFuncDec99A();
            *hl = (a = 'K');
            hl++;
            *hl = (a = 'b');
        }
    }
}

uint8_t MyFunc4Chars[4] = {0x00, 0x00, 0x00, 0x00};

void MyFuncLoadEXTDRV() {
    // проверка наличия драйвера
    bios(a = biosGetExtDRVVersion);
    if (flag_c) {
        // Загрузка драйвера в (WP)
        bios(a = biosSetNameBufferHL, hl = MyFuncEXTDRV_FileName);
        bios(a = biosLoadFileBC, b = 0x01, c = 0x00);
        if (flag_c) {
            // ошибка
        } else {
            // Установка драйвера в CONIO
            bios(a = biosSetDriverExtensionHL);
        }
    } else {
        // есть
    }
}
uint8_t MyFuncEXTDRV_FileName[] = "EXTDRV";

void MyFuncCheckExtDrv() {
    bios(a = biosGetExtDRVVersion);
    if (flag_c) {
    } else {
        compare(a, 0x27);
        if (flag_nc) {
            a = 0xBB;
            a -= b;
            if (flag_z) return;
        }
    }
}
uint8_t MyFunc_DefExtDrv_Version = 0x27;

void MyFuncSetFullScreen() {
    push_pop(hl) {
        bios(a = biosSetScreenBeginHL, hl = 0x0000);
        bios(a = biosSetScreenSizeHL, h = 32, l = 48);
    }
}

#endif /* MyFuncFunctions_h */
