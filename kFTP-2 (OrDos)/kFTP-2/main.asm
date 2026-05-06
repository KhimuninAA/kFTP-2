    device zxspectrum48 ; There is no ZX Spectrum, it is needed for the sjasmplus assembler.
ordos_wnd equ 49110
ordos_sdma equ 49104
ordos_watf equ 49098
ordos_wfile equ 49143
ordos_stop equ 49122
ordos_dirm equ 49128
ordos_start equ 49149
ordos_mxdsk equ 49080
ordos_rmax equ 49089
ordos_wdisk equ 49119
ordos_rdisk equ 49116
ordos_rfile equ 49146
ordos_pscf equ 49125
ordos_rnd equ 49113
ordos_eras equ 49134
ordos_atf equ 49101
fontaddress equ 62417
inverceaddress equ 62419
keyrusaddress equ 62437
printhexa equ 63509
printchata equ 63503
printchatc equ 63497
writebyteinothermem equ 63545
setposcursor equ 63548
getposcursor equ 63518
printhlstr equ 63512
getkeyboardchara equ 63491
getkeyboardstatea equ 63506
getkeyboardcodea equ 63515
unpackcharcode equ 63533
i8255_setup equ 62979
i8255_port_c equ 62978
i8255_port_a equ 62976
gotovbox equ 262
; 13 void ordos_wnd() __address(0xbfd6);
; 14 ///запись н/адреса буфера имени файла
; 15 void ordos_sdma() __address(0xbfd0);
; 16 ///запись адресов (н/к) блока озу
; 17 void ordos_watf() __address(0xbfca);
; 18 ///пп.записи файла на диск
; 19 void ordos_wfile() __address(0xbff7);
; 20 ///запись стоп-слова в диск
; 21 void ordos_stop() __address(0xbfe2);
; 22 /// вывод каталога диска в буфер
; 23 void ordos_dirm() __address(0xbfe8);
; 24 /// вход в ос "ordos"
; 25 void ordos_start() __address(0xbffd);
; 26 /// конеч.адрес программ.на диске (FF адрес стоп байта) HL
; 27 void ordos_mxdsk() __address(0xbfb8);
; 28 /// чтение максимального адреса диска HL
; 29 void ordos_rmax() __address(0xbfc1);
; 30 /// запись байта в диск HL-addr A-byte
; 31 void ordos_wdisk() __address(0xbfdf);
; 32 /// чтение байта из диска HL-addr A-byte
; 33 void ordos_rdisk() __address(0xbfdc);
; 34 /// пп.чтения файла с диска
; 35 void ordos_rfile() __address(0xbffa);
; 36 /// поиск файла в диске
; 37 void ordos_pscf() __address(0xbfe5);
; 38 /// чтение имени текущего диска
; 39 void ordos_rnd() __address(0xbfd9);
; 40 ///уничтожение файла на диске
; 41 void ordos_eras() __address(0xBFEE);
; 42 ///чтение адресов размещения файла на диске (портит hl,de,bc)
; 43 void ordos_atf() __address(0xbfcd); //hl = нач.адрес файла de = конеч.адрес файла
; 12 extern uint16_t fontAddress __address(0xF3D1);
; 13 ///ячейка, хранящая признак прямого (00Н) вывода (светлые символы на темном фоне) или инверсного (0FFH) вывода (темные символы на светлом фоне)
; 14 extern uint16_t inverceAddress __address(0xF3D3);
; 15 /// признак рус (0ffh)/лат (00)
; 16 extern uint16_t keyRusAddress __address(0xF3E5);
; 17 
; 18 ///-----* Функции Монитора *-------
; 19 ///Вывод на экран HEX из регистра A
; 20 void printHexA() __address(0xF815);
; 21 ///Вывод символа на экран из регистра A
; 22 void printChatA() __address(0xF80F);
; 23 ///Вывод символа на экран из регистра С
; 24 void printChatC() __address(0xF809);
; 25 ///ЗАПИСЬ БАЙТА В ДОП. СТРАНИЦУ HL — АДРЕСА — N СТРАНИЦЫ (0-3) C — ЗАПИСЫВАЕМЫЙ БАЙТ
; 26 void writeByteInOtherMem() __address(0xF839);
; 27 ///УСТАНОВКА КУРСОРА ВХ. Н — НОМЕР СТРОКИ — Y L — НОМЕР ПОЗИЦИИ — X
; 28 void setPosCursor() __address(0xF83C);
; 29 ///ЗАПРОС ПОЛОЖЕНИЯ КУРСОРА Н - НОМЕР СТРОКИ - Y , L - НОМЕР ПОЗИЦИИ - X
; 30 void getPosCursor() __address(0xF81E);
; 31 ///ВЫВОД НА ЭКРАН СООБЩЕНИЯ ВХ.: HL- - АДРЕС НАЧАЛА КОНЕЧНЫЙ БАЙТ - 00Н
; 32 void printHLStr() __address(0xF818);
; 33 
; 34 ///ВВОД C СИМВОЛА С КЛАВИАТУРЫ А - ВВЕДЕННЫЙ СИМВОЛ
; 35 void getKeyboardCharA() __address(0xF803);
; 36 ///ОПРОС СОСТОЯНИЯ КЛАВИАТУРЫ А = 00Н - НЕ НАЖАТА , А = 0FFH - НАЖАТА
; 37 void getKeyboardStateA() __address(0xF812);
; 38 ///ВВОД КОДА НАЖАТОЙ КЛАВИШИ А = 0FFH - НЕ НАЖАТА А = 0FEH - РУС/ЛАТ ИНАЧЕ - КОД КЛАВИШИ
; 39 void getKeyboardCodeA() __address(0xF81B);
; 40 
; 41 ///РАСПАКОВКА ВНУТРЕННЕГО ЗНАКОГЕНЕРАТОРА
; 42 void unpackCharCode() __address(0xF82D);
; 14 extern uint16_t i8255_SETUP __address(0xF603);
; 15 extern uint16_t i8255_PORT_C __address(0xF602);
; 16 extern uint16_t i8255_PORT_A __address(0xF600);
; 11 void goToVBOX() __address(0x0106);

    org 0x00F0

; 12 void mainStart();
; 13 void KeyboardEventA();
; 14 
; 15 asm{
; 16     org 0x00F0
; 17 }
; 18 
; 19 ///App Name
; 20 uint8_t appName[] = {'K','F','T','P','2','$',' ',' '};
appname:
	db 75
	db 70
	db 84
	db 80
	db 50
	db 36
	db 32
	db 32


    DB 0x00, 0x01

    DB 0x00, 0x35

    DB 0x00, 0x00, 0x00, 0x00

; 31 void main(){
main:
; 32     #ifdef _IS_MAIN_STACK
; 33         sp = 0x6FFF;
; 34     #else
; 35         nop();
	nop
; 36         nop();
	nop
; 37         nop();
	nop
; 38     #endif
; 39     mainStart();
	jp mainstart
; 40 }
; 41 
; 42 ///Exec VBOX
; 43 uint8_t jmpToVBOX = 0xc3;
jmptovbox:
	db 195
; 44 uint16_t startVboxAddr = 0x0000;
startvboxaddr:
	dw 0
; 46 void mainStart() {
mainstart:
; 47     h = 24;
	ld h, 24
; 48     l = 60;
	ld l, 60
; 49     setPosCursor();
	call setposcursor
; 50     
; 51     HelpViewShow();
	call helpviewshow
; 52     FtpStateViewShow();
	call ftpstateviewshow
; 53     WifiStateViewShow();
	call wifistateviewshow
; 54     FtpViewShow();
	call ftpviewshow
; 55     DiskViewShow();
	call diskviewshow
; 56     
; 57     CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
; 58     
; 59     #ifdef _IS_SIMULATOR
; 60     #else
; 61         NetUpdateData();
	call netupdatedata
; 62         ThreadsTickNow();
	call threadsticknow
; 63     #endif
; 64     
; 65     for(;;){
l_1:
; 66         #ifdef _IS_SIMULATOR
; 67             getKeyboardCharA();
; 68             KeyboardEventA();
; 69         #else
; 70             getKeyboardStateA();
	call getkeyboardstatea
; 71             if (a == 0xFF) {
	cp 255
	jp nz, l_3
; 72                 getKeyboardCodeA();
	call getkeyboardcodea
; 73                 KeyboardEventA();
	call keyboardeventa
	jp l_4
l_3:
; 74             } else {
; 75                 ThreadsTick();
	call threadstick
l_4:
	jp l_1
; 76             }
; 77         #endif
; 78     }
; 79 }
; 80 
; 81 void KeyboardEventA() {
keyboardeventa:
; 82     push_pop(bc) {
	push bc
; 83         b = a; //Save
	ld b, a
; 84         if ((a = b) == 0x03) { //F4
	ld a, b
	cp 3
	jp nz, l_5
; 85             vboxClearCash();
	call vboxclearcash
; 86             ordos_start();
	call ordos_start
	jp l_6
l_5:
; 87         } else if ((a = b) == 0x02) { //F3 Open FTP settings
	ld a, b
	cp 2
	jp nz, l_7
; 88             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 89             if (a == 1) {
	cp 1
	jp nz, l_9
; 90                 FtpSettingsViewShow();
	call ftpsettingsviewshow
l_9:
	jp l_8
l_7:
; 91             }
; 92         } else if ((a = b) == 0x01) { //F2 Open WiFi settings
	ld a, b
	cp 1
	jp nz, l_11
; 93             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 94             if (a == 1) {
	cp 1
	jp nz, l_13
; 95                 WiFiSettingsViewShow();
	call wifisettingsviewshow
l_13:
l_11:
l_8:
l_6:
; 96             }
; 97         }
; 98         
; 99         c = 0;
	ld c, 0
; 100         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_15
; 101             DiskViewKeyA(a = b);
	ld a, b
	call diskviewkeya
; 102             c = 1;
	ld c, 1
	jp l_16
l_15:
; 103         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_17
; 104             FtpViewKeyA(a = b);
	ld a, b
	call ftpviewkeya
; 105             c = 1;
	ld c, 1
	jp l_18
l_17:
; 106         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_19
; 107             SelectDiskViewKeyA(a = b);
	ld a, b
	call selectdiskviewkeya
; 108             c = 1;
	ld c, 1
	jp l_20
l_19:
; 109         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_21
; 110             WiFiSettingsViewKeyA(a = b);
	ld a, b
	call wifisettingsviewkeya
; 111             c = 1;
	ld c, 1
	jp l_22
l_21:
; 112         } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, l_23
; 113             WiFiNetworksViewKeyA(a = b);
	ld a, b
	call wifinetworksviewkeya
; 114             c = 1;
	ld c, 1
	jp l_24
l_23:
; 115         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_25
; 116             FtpSettingsViewKeyA(a = b);
	ld a, b
	call ftpsettingsviewkeya
; 117             c = 1;
	ld c, 1
	jp l_26
l_25:
; 118         } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, l_27
; 119             FtpMakeDirectoryKeyA(a = b);
	ld a, b
	call ftpmakedirectorykeya
; 120             c = 1;
	ld c, 1
l_27:
l_26:
l_24:
l_22:
l_20:
l_18:
l_16:
	pop bc
	ret
; 11 void i8255Init() {
i8255init:
	ret
; 12     
; 13 }
; 14 
; 15 void i8255PortAOut() {
i8255portaout:
; 16     a = i8255SETUPPortAOut;
	ld a, 129
; 17     i8255_SETUP = a;
	ld (i8255_setup), a
	ret
; 18 }
; 19 
; 20 void i8255_WaitingForReady() {
i8255_waitingforready:
; 21     push_pop(bc) {
	push bc
; 22         b = 0;
	ld b, 0
; 23         do {
l_29:
; 24             a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 25             a &= ESP_Reg_Ready;
	and 2
; 26             c = a;
	ld c, a
l_30:
; 27             #ifdef _IS_ESP_DELAY
; 28                 if ((a = c) == 0) {
; 29                     i8255_DelayA(a = 1); //5 200
; 30                     b++;
; 31                     if ((a = b) >= 100) { //253
; 32                         c = ESP_Reg_Ready;
; 33                         a = ESPError_TimeOut;
; 34                         ESPError = a;
; 35                     }
; 36                 }
; 37             #endif
; 38         } while ((a = c) == 0);
	ld a, c
	or a
	jp z, l_29
	pop bc
	ret
; 39     }
; 40 }
; 41 
; 42 /// Проверка что ESP занят
; 43 void i8255_WaitingForBusy() {
i8255_waitingforbusy:
; 44     do {
l_32:
; 45         a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 46         a &= ESP_Reg_Busy;
	and 1
l_33:
; 47     } while (a > 0);
	or a
	jp nz, l_32
	ret
; 48 }
; 49 
; 50 void i8255PortAIn() {
i8255portain:
; 51     a = i8255SETUPPortAIn;
	ld a, 145
; 52     i8255_SETUP = a;
	ld (i8255_setup), a
	ret
; 53 }
; 54 
; 55 /// Сигнал Clock
; 56 /// A include IsWrite, IsBegin, IsEnd
; 57 /// A = 1 - Write
; 58 void i8255_SckIsWriteA() {
i8255_sckiswritea:
; 59     a |= ESP_Reg_Sck;
	or 16
; 60     i8255_PORT_C = a;
	ld (i8255_port_c), a
	ret
; 61     #ifdef _IS_ESP_DELAY
; 62         i8255_DelayA(a = 1); //20 40
; 63     #endif
; 64 }
; 65 
; 66 void i8255_Sck0() {
i8255_sck0:
; 67     a = 0;
	ld a, 0
; 68     i8255_PORT_C = a;
	ld (i8255_port_c), a
	ret
; 69     #ifdef _IS_ESP_DELAY
; 70         i8255_DelayA(a = 1); //20 40
; 71     #endif
; 72 }
; 73 
; 74 void i8255_DelayA() {
i8255_delaya:
; 75     do {
l_35:
; 76         nop();
	nop
; 77         a--;
	dec a
l_36:
; 78     } while (a > 0);
	or a
	jp nz, l_35
	ret
; 79 }
; 80 
; 81 void i8255_ReadReg() {
i8255_readreg:
; 82     a = i8255_PORT_C;
	ld a, (i8255_port_c)
	ret
; 83 }
; 84 
; 85 void i8255_ReadData() {
i8255_readdata:
; 86     a = i8255_PORT_A;
	ld a, (i8255_port_a)
	ret
; 87 }
; 88 
; 89 void i8255_WriteData() {
i8255_writedata:
; 90     i8255_PORT_A = a;
	ld (i8255_port_a), a
	ret
; 91 }
; 92 
; 93 uint8_t i8255_PortA_IsOut = 1;
i8255_porta_isout:
	db 1
; 12 void ESPSendByteAC() {
espsendbyteac:
; 13     push_pop(bc) {
	push bc
; 14         b = a;
	ld b, a
; 15         // Проверим - не занят ли ESP
; 16         i8255_WaitingForBusy();
	call i8255_waitingforbusy
; 17         // A на выход
; 18         i8255PortAOut();
	call i8255portaout
; 19         // Установить A в порт A
; 20         i8255_WriteData(a = b);
	ld a, b
	call i8255_writedata
; 21         // Послать сигнал что данные готовы
; 22         a = ESP_Reg_IsWrite;
	ld a, 32
; 23         a |= c;
	or c
; 24         i8255_SckIsWriteA();
	call i8255_sckiswritea
; 25         // Ждем подтверждения
; 26         i8255_WaitingForReady();
	call i8255_waitingforready
; 27         //
; 28         i8255_Sck0();
	call i8255_sck0
	pop bc
	ret
; 29     }
; 30 }
; 31 
; 32 /// A - Data
; 33 /// D - Register
; 34 void ESPGetByteAD() {
espgetbytead:
; 35     push_pop(bc) {
	push bc
; 36         // Проверим - не занят ли ESP
; 37         i8255_WaitingForBusy();
	call i8255_waitingforbusy
; 38         // A на вход
; 39         i8255PortAIn();
	call i8255portain
; 40         // Послать сигнал что готовы к данным
; 41         i8255_SckIsWriteA(a = 0);
	ld a, 0
	call i8255_sckiswritea
; 42         // Ждем данные
; 43         i8255_WaitingForReady();
	call i8255_waitingforready
; 44         // Читаем данные
; 45         i8255_ReadData();
	call i8255_readdata
; 46         b = a;
	ld b, a
; 47         // Читаем регистр
; 48         i8255_ReadReg();
	call i8255_readreg
; 49         d = a;
	ld d, a
; 50         //
; 51         i8255_Sck0();
	call i8255_sck0
; 52         //
; 53         a = b;
	ld a, b
	pop bc
	ret
; 54     }
; 55 }
; 56 
; 57 /// h = key
; 58 /// l = len buffer
; 59 void ESPSendHL() {
espsendhl:
; 60     ESPErrorClear();
	call esperrorclear
; 61     push_pop(bc, hl) {
	push bc
	push hl
; 62         //-- Send Key
; 63         c = ESP_Reg_IsBegin;
	ld c, 64
; 64         if ((a = l) == 0) {
	ld a, l
	or a
	jp nz, l_38
; 65             a = c;
	ld a, c
; 66             a |= ESP_Reg_IsEnd;
	or 128
; 67             c = a;
	ld c, a
l_38:
; 68         }
; 69         ESPSendByteAC(a = h);
	ld a, h
	call espsendbyteac
; 70         if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
	ld a, (esperror)
	or a
	jp nz, l_40
; 71             //-- Send Data
; 72             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, l_42
; 73                 b = l;
	ld b, l
; 74                 hl = Net_buffer;
	ld hl, net_buffer
; 75                 do {
l_44:
; 76                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_47
; 77                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp l_48
l_47:
; 78                     } else {
; 79                         c = 0;
	ld c, 0
l_48:
; 80                     }
; 81                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 82                     if ((a = ESPError) > 0) { // Есть ошибки - выходим
	ld a, (esperror)
	or a
	jp z, l_49
; 83                         b = 1;
	ld b, 1
l_49:
; 84                     }
; 85                     hl++;
	inc hl
; 86                     b--;
	dec b
l_45:
; 87                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_44
l_42:
l_40:
	pop hl
	pop bc
	ret
; 88             }
; 89         }
; 90     }
; 91 }
; 92 
; 93 /// [вх] h = key
; 94 /// [вх] l = len buffer
; 95 /// [вых] l = len buffer
; 96 void ESPSendAndGetHL() {
espsendandgethl:
; 97     ESPErrorClear();
	call esperrorclear
; 98     push_pop(bc, de) {
	push bc
	push de
; 99         //-- Send Key
; 100         c = ESP_Reg_IsBegin;
	ld c, 64
; 101         ESPSendByteAC(a = h);
	ld a, h
	call espsendbyteac
; 102         if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
	ld a, (esperror)
	or a
	jp nz, l_51
; 103             //-- Send Data
; 104             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, l_53
; 105                 b = l;
	ld b, l
; 106                 hl = Net_buffer;
	ld hl, net_buffer
; 107                 do {
l_55:
; 108                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_58
; 109                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp l_59
l_58:
; 110                     } else {
; 111                         c = 0;
	ld c, 0
l_59:
; 112                     }
; 113                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 114                     hl++;
	inc hl
; 115                     b--;
	dec b
l_56:
; 116                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_55
l_53:
; 117             }
; 118             //-- Get Data
; 119             b = 0;
	ld b, 0
; 120             hl = Net_buffer;
	ld hl, net_buffer
; 121             c = 1;
	ld c, 1
; 122             do {
l_60:
; 123                 ESPGetByteAD(); // a - data d - reg
	call espgetbytead
; 124                 e = a;
	ld e, a
; 125                 //ESP_Reg_In_IsEnd
; 126                 //a = ESP_Reg_In_NoData + ESP_Reg_In_IsEnd;
; 127                 a = ESP_Reg_In_NoData;
	ld a, 4
; 128                 a &= d;
	and d
; 129                 if (a == 0) {
	or a
	jp nz, l_63
; 130                     a = ESP_Reg_In_IsEnd;
	ld a, 8
; 131                     a &= d;
	and d
; 132                     if (a > 0) {
	or a
	jp z, l_65
; 133                         c = 0;
	ld c, 0
l_65:
; 134                     }
; 135                     a = e;
	ld a, e
; 136                     *hl = a;
	ld (hl), a
; 137                     hl++;
	inc hl
; 138                     b++;
	inc b
; 139                     if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, l_67
; 140                         c = 0;
	ld c, 0
l_67:
	jp l_64
l_63:
; 141                     }
; 142                 } else {
; 143                     c = 0;
	ld c, 0
l_64:
l_61:
; 144                 }
; 145             } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, l_60
; 146             l = b;
	ld l, b
l_51:
	pop de
	pop bc
	ret
; 147         }
; 148     }
; 149 }
; 150 
; 151 void ESPErrorClear() {
esperrorclear:
; 152     a = ESPError_No;
	ld a, 0
; 153     ESPError = a;
	ld (esperror), a
	ret
; 154 }
; 155 
; 156 uint8_t ESPError = 0;
esperror:
	db 0
; 11 void NetWiFiGetSsidPassword() {
netwifigetssidpassword:
; 12     push_pop(hl, bc) {
	push hl
	push bc
; 13         h = 1; // GET_SSID_PASSWORD, // 1
	ld h, 1
; 14         l = 0; // Len NedBuffer
	ld l, 0
; 15         ESPSendAndGetHL();
	call espsendandgethl
; 16         b = 16;
	ld b, 16
; 17         c = l;
	ld c, l
; 18         hl = WiFiSettingsViewPassValue;
	ld hl, wifisettingsviewpassvalue
; 19         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 20     }
; 21 }
; 22 
; 23 void NetWiFiSetSsidPassword() {
netwifisetssidpassword:
; 24     push_pop(hl, bc) {
	push hl
	push bc
; 25         hl = WiFiSettingsViewPassValue;
	ld hl, wifisettingsviewpassvalue
; 26         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 27         h = 2; // SET_SSID_PASSWORD, // 2
	ld h, 2
; 28         l = 16; // Len NedBuffer
	ld l, 16
; 29         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 30     }
; 31 }
; 32 
; 33 void NetWiFiGetSsidIp() {
netwifigetssidip:
; 34     push_pop(hl, bc) {
	push hl
	push bc
; 35         h = 3; // GET_SSID_IP, // 3
	ld h, 3
; 36         l = 0; // Len NedBuffer
	ld l, 0
; 37         ESPSendAndGetHL();
	call espsendandgethl
; 38         b = 16;
	ld b, 16
; 39         c = l;
	ld c, l
; 40         hl = WiFiSettingsViewIpValue;
	ld hl, wifisettingsviewipvalue
; 41         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 42     }
; 43 }
; 44 
; 45 void NetWiFiGetSsidMac() {
netwifigetssidmac:
; 46     push_pop(hl, bc) {
	push hl
	push bc
; 47         h = 4; // GET_SSID_MAC, // 4
	ld h, 4
; 48         l = 0; // Len NedBuffer
	ld l, 0
; 49         ESPSendAndGetHL();
	call espsendandgethl
; 50         b = 18;
	ld b, 18
; 51         c = l;
	ld c, l
; 52         hl = WiFiSettingsViewMacValue;
	ld hl, wifisettingsviewmacvalue
; 53         ParserBufferSumToHL();
	call parserbuffersumtohl
	pop bc
	pop hl
	ret
; 54     }
; 55 }
; 56 
; 57 void NetWiFiGetSsid() {
netwifigetssid:
; 58     push_pop(hl, bc) {
	push hl
	push bc
; 59         h = 5; // GET_SSID, // 5
	ld h, 5
; 60         l = 0; // Len NedBuffer
	ld l, 0
; 61         ESPSendAndGetHL();
	call espsendandgethl
; 62         b = 16;
	ld b, 16
; 63         c = l;
	ld c, l
; 64         hl = WiFiSettingsViewSsidValue;
	ld hl, wifisettingsviewssidvalue
; 65         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 66     }
; 67 }
; 68 
; 69 void NetFtpGetUrl() {
netftpgeturl:
; 70     push_pop(hl, bc) {
	push hl
	push bc
; 71         h = 6; // GET_FTP_URL, // 6
	ld h, 6
; 72         l = 0; // Len NedBuffer
	ld l, 0
; 73         ESPSendAndGetHL();
	call espsendandgethl
; 74         b = 16;
	ld b, 16
; 75         c = l;
	ld c, l
; 76         hl = FtpStateViewIpValue;
	ld hl, ftpstateviewipvalue
; 77         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 78     }
; 79 }
; 80 
; 81 void NetFtpSetUrl() {
netftpseturl:
; 82     push_pop(hl, bc) {
	push hl
	push bc
; 83         hl = FtpStateViewIpValue;
	ld hl, ftpstateviewipvalue
; 84         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 85         h = 7; // SET_FTP_URL, // 7
	ld h, 7
; 86         l = 16; // Len NedBuffer
	ld l, 16
; 87         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 88     }
; 89 }
; 90 
; 91 void NetFtpGetUser() {
netftpgetuser:
; 92     push_pop(hl, bc) {
	push hl
	push bc
; 93         h = 8; // GET_FTP_USER, // 8
	ld h, 8
; 94         l = 0; // Len NedBuffer
	ld l, 0
; 95         ESPSendAndGetHL();
	call espsendandgethl
; 96         b = 16;
	ld b, 16
; 97         c = l;
	ld c, l
; 98         hl = FtpSettingsViewValueUser;
	ld hl, ftpsettingsviewvalueuser
; 99         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 100     }
; 101 }
; 102 
; 103 void NetFtpSetUser() {
netftpsetuser:
; 104     push_pop(hl, bc) {
	push hl
	push bc
; 105         hl = FtpSettingsViewValueUser;
	ld hl, ftpsettingsviewvalueuser
; 106         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 107         h = 9; // SET_FTP_USER, // 9
	ld h, 9
; 108         l = 16; // Len NedBuffer
	ld l, 16
; 109         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 110     }
; 111 }
; 112 
; 113 void NetFtpGetPassword() {
netftpgetpassword:
; 114     push_pop(hl, bc) {
	push hl
	push bc
; 115         h = 10; // GET_FTP_PASS, // 10
	ld h, 10
; 116         l = 0; // Len NedBuffer
	ld l, 0
; 117         ESPSendAndGetHL();
	call espsendandgethl
; 118         b = 16;
	ld b, 16
; 119         c = l;
	ld c, l
; 120         hl = FtpSettingsViewValuePass;
	ld hl, ftpsettingsviewvaluepass
; 121         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 122     }
; 123 }
; 124 
; 125 void NetFtpSetPassword() {
netftpsetpassword:
; 126     push_pop(hl, bc) {
	push hl
	push bc
; 127         hl = FtpSettingsViewValuePass;
	ld hl, ftpsettingsviewvaluepass
; 128         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 129         h = 11; // SET_FTP_PASS, // 11
	ld h, 11
; 130         l = 16; // Len NedBuffer
	ld l, 16
; 131         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 132     }
; 133 }
; 134 
; 135 void NetFtpGetHomeDir() {
netftpgethomedir:
; 136     push_pop(hl, bc) {
	push hl
	push bc
; 137         h = 12; // GET_FTP_HOME_DIR, // 12
	ld h, 12
; 138         l = 0; // Len NedBuffer
	ld l, 0
; 139         ESPSendAndGetHL();
	call espsendandgethl
; 140         b = 16;
	ld b, 16
; 141         c = l;
	ld c, l
; 142         hl = FtpSettingsViewValueHomeDir;
	ld hl, ftpsettingsviewvaluehomedir
; 143         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 144     }
; 145 }
; 146 
; 147 void NetFtpSetHomeDir() {
netftpsethomedir:
; 148     push_pop(hl, bc) {
	push hl
	push bc
; 149         hl = FtpSettingsViewValueHomeDir;
	ld hl, ftpsettingsviewvaluehomedir
; 150         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 151         h = 13; // SET_FTP_HOME_DIR, // 13
	ld h, 13
; 152         l = 16; // Len NedBuffer
	ld l, 16
; 153         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 154     }
; 155 }
; 156 
; 157 void NetFtpGetPort() {
netftpgetport:
; 158     push_pop(hl, bc) {
	push hl
	push bc
; 159         h = 14; // GET_FTP_PORT, // 14
	ld h, 14
; 160         l = 0; // Len NedBuffer
	ld l, 0
; 161         ESPSendAndGetHL();
	call espsendandgethl
; 162         b = 6;
	ld b, 6
; 163         c = l;
	ld c, l
; 164         hl = FtpSettingsViewValuePort;
	ld hl, ftpsettingsviewvalueport
; 165         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 166     }
; 167 }
; 168 
; 169 void NetFtpSetPort() {
netftpsetport:
; 170     push_pop(hl, bc) {
	push hl
	push bc
; 171         hl = FtpSettingsViewValuePort;
	ld hl, ftpsettingsviewvalueport
; 172         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 173         h = 15; // SET_FTP_PORT, // 15
	ld h, 15
; 174         l = 6; // Len NedBuffer
	ld l, 6
; 175         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 176     }
; 177 }
; 178 
; 179 void NetWiFiListUpdate() {
netwifilistupdate:
; 180     push_pop(hl) {
	push hl
; 181         h = 16; // SSID_LIST_UPDATE, // 16
	ld h, 16
; 182         l = 0; // Len NedBuffer
	ld l, 0
; 183         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 184     }
; 185 }
; 186 
; 187 void NetWiFiGetList() {
netwifigetlist:
; 188     a = 0;
	ld a, 0
; 189     WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
; 190     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 191         c = 0;
	ld c, 0
; 192         do {
l_69:
; 193             h = 17; // SSID_LIST_NEXT, // 17
	ld h, 17
; 194             l = 0; // Len NedBuffer
	ld l, 0
; 195             ESPSendAndGetHL();
	call espsendandgethl
; 196             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, l_72
; 197                 b = l;
	ld b, l
; 198                 //--
; 199                 hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 200                 d = 0;
	ld d, 0
; 201                 a = c;
	ld a, c
; 202                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 203                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_74
; 204                     d++;
	inc d
l_74:
; 205                 }
; 206                 e = a;
	ld e, a
; 207                 hl += de;
	add hl, de
; 208                 push_pop(bc) {
	push bc
; 209                     c = b;
	ld c, b
; 210                     b = 16;
	ld b, 16
; 211                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 212                 }
; 213                 //--
; 214                 c++;
	inc c
l_72:
l_70:
; 215             }
; 216         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, l_69
; 217         a = c;
	ld a, c
; 218         WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
	pop de
	pop bc
	pop hl
	ret
; 219     }
; 220 }
; 221 
; 222 void NetWiFiSetListA() {
netwifisetlista:
; 223     push_pop(hl) {
	push hl
; 224         hl = Net_buffer;
	ld hl, net_buffer
; 225         *hl = a;
	ld (hl), a
; 226         h = 18; // SSID_SET_LIST_ID, // 18
	ld h, 18
; 227         l = 1; // Len NedBuffer
	ld l, 1
; 228         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 229     }
; 230 }
; 231 
; 232 void NetWiFiConnect() {
netwificonnect:
; 233     push_pop(hl) {
	push hl
; 234         h = 19; // SSID_CONNECT, // 19
	ld h, 19
; 235         l = 0; // Len NedBuffer
	ld l, 0
; 236         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 237     }
; 238 }
; 239 
; 240 void NetGetAllStatus() {
netgetallstatus:
; 241     push_pop(hl) {
	push hl
; 242         h = 20; //  GET_STATUS, // 20
	ld h, 20
; 243         l = 0; // Len NedBuffer
	ld l, 0
; 244         ESPSendAndGetHL();
	call espsendandgethl
; 245         //--
; 246         NetGetAllStatusParse();
	call netgetallstatusparse
	pop hl
	ret
; 247     }
; 248 }
; 249 
; 250 void NetFtpGoToHomeDir() {
netftpgotohomedir:
; 251     push_pop(hl) {
	push hl
; 252         h = 21; // SET_FTP_TO_HOME_DIR, // 21
	ld h, 21
; 253         l = 0; // Len NedBuffer
	ld l, 0
; 254         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 255     }
; 256 }
; 257 
; 258 void NetFtpGetCurrentPath() {
netftpgetcurrentpath:
; 259     push_pop(hl) {
	push hl
; 260         h = 22; //  GET_FTP_CURRENT_FOLDER, // 22
	ld h, 22
; 261         l = 0; // Len NedBuffer
	ld l, 0
; 262         ESPSendAndGetHL();
	call espsendandgethl
; 263         b = 16;
	ld b, 16
; 264         c = l;
	ld c, l
; 265         hl = FtpViewPath;
	ld hl, ftpviewpath
; 266         ParserBufferToHL();
	call parserbuffertohl
	pop hl
	ret
; 267     }
; 268 }
; 269 
; 270 void NetFtpConnect() {
netftpconnect:
; 271     push_pop(hl) {
	push hl
; 272         h = 23; // FTP_CONNECT, // 23
	ld h, 23
; 273         l = 0; // Len NedBuffer
	ld l, 0
; 274         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 275     }
; 276 }
; 277 
; 278 void NetFtpChangeDirUp() {
netftpchangedirup:
; 279     push_pop(hl) {
	push hl
; 280         h = 24; // SET_FTP_CHANGE_DIR_UP, // 24
	ld h, 24
; 281         l = 0; // Len NedBuffer
	ld l, 0
; 282         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 283     }
; 284 }
; 285 
; 286 void NetFtpChangeDirIndexA() {
netftpchangedirindexa:
; 287     push_pop(hl) {
	push hl
; 288         hl = Net_buffer;
	ld hl, net_buffer
; 289         *hl = a;
	ld (hl), a
; 290         h = 25; // SET_FTP_CHANGE_DIR_INDEX, // 25
	ld h, 25
; 291         l = 1; // Len NedBuffer
	ld l, 1
; 292         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 293     }
; 294 }
; 295 
; 296 void NetFtpUpdateList() {
netftpupdatelist:
; 297     push_pop(hl) {
	push hl
; 298         hl = Net_buffer;
	ld hl, net_buffer
; 299         a = 20; // Получить 20 файлов
	ld a, 20
; 300         *hl = a;
	ld (hl), a
; 301         h = 26; // FTP_UPDATE_LIST, // 26
	ld h, 26
; 302         l = 1; // Len NedBuffer
	ld l, 1
; 303         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 304     }
; 305 }
; 306 
; 307 void NetFtpListFiles() {
netftplistfiles:
; 308     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 309         a = 0;
	ld a, 0
; 310         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
; 311         c = 0;
	ld c, 0
; 312         do {
l_76:
; 313             //--
; 314             hl = Net_buffer;
	ld hl, net_buffer
; 315             a = NetFtpListFilesParseSumState;
	ld a, (netftplistfilesparsesumstate)
; 316             *hl = a;
	ld (hl), a
; 317             //--
; 318             h = 27; // FTP_LIST_FILE_NEXT, // 27
	ld h, 27
; 319             l = 1; // Len NedBuffer
	ld l, 1
; 320             ESPSendAndGetHL();
	call espsendandgethl
; 321             //--
; 322             NetFtpListFilesParse(); // пока l > 0 (ответ от ESP что то содержит)
	call netftplistfilesparse
l_77:
; 323         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, l_76
; 324         a = c;
	ld a, c
; 325         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
	pop de
	pop bc
	pop hl
	ret
; 326     }
; 327 }
; 328 
; 329 void NetFtpLoadFileA() {
netftploadfilea:
; 330     push_pop(hl) {
	push hl
; 331         hl = Net_buffer;
	ld hl, net_buffer
; 332         *hl = a;
	ld (hl), a
; 333         h = 28; // FTP_FILE_DOWNLOAD, // 28
	ld h, 28
; 334         l = 1; // Len NedBuffer
	ld l, 1
; 335         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 336     }
; 337 }
; 338 
; 339 void NetFtpLoadFileNext() {
netftploadfilenext:
; 340     push_pop(hl) {
	push hl
; 341         a = 1;
	ld a, 1
; 342         NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
; 343         do {
l_79:
; 344             //--
; 345             hl = Net_buffer;
	ld hl, net_buffer
; 346             a = NetFtpLoadFileNextParseSumState;
	ld a, (netftploadfilenextparsesumstate)
; 347             *hl = a;
	ld (hl), a
; 348             //--
; 349             h = 29; // FTP_FILE_DOWNLOAD_NEXT, // 29
	ld h, 29
; 350             l = 1; // Len NedBuffer
	ld l, 1
; 351             ESPSendAndGetHL();
	call espsendandgethl
; 352             //--
; 353             NetFtpLoadFileNextParse();
	call netftploadfilenextparse
l_80:
; 354         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, l_79
	pop hl
	ret
; 355     }
; 356 }
; 357 
; 358 void NetErrorClear() {
neterrorclear:
; 359     push_pop(hl) {
	push hl
; 360         h = 30; // ESP_ERROR_CLEAR, // 30
	ld h, 30
; 361         l = 0; // Len NedBuffer
	ld l, 0
; 362         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 363     }
; 364 }
; 365 
; 366 void NetFtpDeleteFileIndexA() {
netftpdeletefileindexa:
; 367     push_pop(hl) {
	push hl
; 368         hl = Net_buffer;
	ld hl, net_buffer
; 369         *hl = a;
	ld (hl), a
; 370         h = 31; // FTP_FILE_DELETE_INDEX, // 31
	ld h, 31
; 371         l = 1; // Len NedBuffer
	ld l, 1
; 372         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 373     }
; 374 }
; 375 
; 376 void NetFtpMakeDirectory() {
netftpmakedirectory:
; 377     push_pop(hl) {
	push hl
; 378         hl = FtpMakeDirectoryValue;
	ld hl, ftpmakedirectoryvalue
; 379         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 380         h = 33; // FTP_MAKE_DIRECTORY, // 33
	ld h, 33
; 381         l = 16; // Len NedBuffer
	ld l, 16
; 382         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 383     }
; 384 }
; 385 
; 386 void NetFtpUploadFileInitHL() {
netftpuploadfileinithl:
; 387     ParserFileUploadInit();
	call parserfileuploadinit
; 388     // Отправляем данные о файле
; 389     push_pop(hl, bc) {
	push hl
	push bc
; 390         ParserFileUploadInit();
	call parserfileuploadinit
; 391         
; 392         ParserHLToBuffer(b = 8);
	ld b, 8
	call parserhltobuffer
; 393         h = 32; // FTP_FILE_UPLOAD_INIT, // 32
	ld h, 32
; 394         l = 8; // Len NedBuffer
	ld l, 8
; 395         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
; 396     }
; 397     // Начинаем передавать содержимое файла
; 398     do {
l_82:
; 399         ParserFileUploadCreateBuffer();
	call parserfileuploadcreatebuffer
; 400         h = 34; // FTP_FILE_UPLOAD_NEXT, // 34
	ld h, 34
; 401         l = 20; // Len NedBuffer 16 + 1 + 2 + 1 = 20
	ld l, 20
; 402         ESPSendAndGetHL();
	call espsendandgethl
; 403         // Parse 
; 404         // b = 0x3C, b = isCorrect, b = progress, b = sum
; 405         ParserFileUploadParse();
	call parserfileuploadparse
l_83:
; 406     } while (a > 0);
	or a
	jp nz, l_82
	ret
; 14 void ParserBufferToHL() {
parserbuffertohl:
; 15     push_pop(de) {
	push de
; 16         de = Net_buffer;
	ld de, net_buffer
; 17         do {
l_85:
; 18             if ((a = c) > 0) {
	ld a, c
	or a
	jp z, l_88
; 19                 a = *de;
	ld a, (de)
; 20                 *hl = a;
	ld (hl), a
; 21                 c--;
	dec c
; 22                 de++;
	inc de
	jp l_89
l_88:
; 23             } else {
; 24                 a = 0;
	ld a, 0
; 25                 *hl = a;
	ld (hl), a
l_89:
; 26             }
; 27             hl++;
	inc hl
; 28             b--;
	dec b
l_86:
; 29         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_85
	pop de
	ret
; 30     }
; 31 }
; 32 
; 33 void ParserHLToBuffer() {
parserhltobuffer:
; 34     push_pop(bc, de) {
	push bc
	push de
; 35         de = Net_buffer;
	ld de, net_buffer
; 36         do {
l_90:
; 37             a = *hl;
	ld a, (hl)
; 38             *de = a;
	ld (de), a
; 39             hl++;
	inc hl
; 40             de++;
	inc de
; 41             b--;
	dec b
l_91:
; 42         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_90
	pop de
	pop bc
	ret
; 43     }
; 44 }
; 45 
; 46 /// C - count (не трогаем)
; 47 /// l - Len NedBuffer
; 48 void NetFtpListFilesParse() {
netftplistfilesparse:
; 49     if ((a = l) == 16) {
	ld a, l
	cp 16
	jp nz, l_93
; 50         NetFtpListFilesParseSum();
	call netftplistfilesparsesum
; 51         if ((a = NetFtpListFilesParseSumState) == 0x01) {
	ld a, (netftplistfilesparsesumstate)
	cp 1
	jp nz, l_95
; 52             push_pop(hl, de) {
	push hl
	push de
; 53                 b = l;
	ld b, l
; 54                 //--
; 55                 hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 56                 d = 0;
	ld d, 0
; 57                 a = c;
	ld a, c
; 58                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 59                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_97
; 60                     d++;
	inc d
l_97:
; 61                 }
; 62                 e = a;
	ld e, a
; 63                 hl += de;
	add hl, de
; 64                 push_pop(bc) {
	push bc
; 65                     c = b;
	ld c, b
; 66                     b = 16;
	ld b, 16
; 67                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 68                 }
; 69                 //--
; 70                 c++;
	inc c
	pop de
	pop hl
l_95:
	jp l_94
l_93:
; 71             }
; 72         }
; 73     } else {
; 74         a = 0x00;
	ld a, 0
; 75         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
l_94:
	ret
; 76     }
; 77 }
; 78 
; 79 void NetFtpListFilesParseSum() {
netftplistfilesparsesum:
; 80     push_pop(hl, bc) {
	push hl
	push bc
; 81         b = 15;
	ld b, 15
; 82         c = 0;
	ld c, 0
; 83         hl = Net_buffer;
	ld hl, net_buffer
; 84         do {
l_99:
; 85             a = *hl;
	ld a, (hl)
; 86             a += c;
	add c
; 87             c = a;
	ld c, a
; 88             hl++;
	inc hl
; 89             b--;
	dec b
l_100:
; 90         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_99
; 91         a = *hl;
	ld a, (hl)
; 92         if (a == c) {
	cp c
	jp nz, l_102
; 93             a = 0x01;
	ld a, 1
; 94             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
	jp l_103
l_102:
; 95         } else {
; 96             a = 0x00;
	ld a, 0
; 97             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
l_103:
; 98         }
; 99         // 10 byte = 0x3C
; 100         hl = Net_buffer;
	ld hl, net_buffer
; 101         bc = 10;
	ld bc, 10
; 102         hl += bc;
	add hl, bc
; 103         a = *hl;
	ld a, (hl)
; 104         a &= 0xFE;
	and 254
; 105         if (a != 0x3C) {
	cp 60
	jp z, l_104
; 106             a = 0x00;
	ld a, 0
; 107             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
l_104:
	pop bc
	pop hl
	ret
; 108         }
; 109     }
; 110 }
; 111 
; 112 void NetFtpLoadFileNextParse() {
netftploadfilenextparse:
; 113     push_pop(hl) {
	push hl
; 114         if ((a = l) > 0) {
	ld a, l
	or a
	jp z, l_106
; 115             NetFtpLoadFileNextParseSum();
	call netftploadfilenextparsesum
; 116             if ((a = NetFtpLoadFileNextParseSumState) == 0x01) {
	ld a, (netftploadfilenextparsesumstate)
	cp 1
	jp nz, l_108
; 117                 push_pop(bc, de) {
	push bc
	push de
; 118                     b = l;
	ld b, l
; 119                     de = Net_buffer;
	ld de, net_buffer
; 120                     //-- Address
; 121                     a = *de;
	ld a, (de)
; 122                     l = a;
	ld l, a
; 123                     de++;
	inc de
; 124                     a = *de;
	ld a, (de)
; 125                     h = a;
	ld h, a
; 126                     NetFtpLoadFileNextParseAddress = hl;
	ld (netftploadfilenextparseaddress), hl
; 127                     de++;
	inc de
; 128                     //-- Progress
; 129                     LoadViewShowProgressA(a = *de);
	ld a, (de)
	call loadviewshowprogressa
; 130                     de++;
	inc de
; 131                     //-- 0x3C
; 132                     de++;
	inc de
; 133                     //--
; 134                     b--;
	dec b
; 135                     b--;
	dec b
; 136                     b--;
	dec b
; 137                     b--;
	dec b
; 138                     b--;
	dec b
; 139                     NetFtpLoadFileNextParseCalkDiskPosToHL();
	call netftploadfilenextparsecalkdiskp
; 140                     do {
l_110:
; 141                         a = *de;
	ld a, (de)
; 142                         ordos_wdisk();
	call ordos_wdisk
; 143                         hl++;
	inc hl
; 144                         de++;
	inc de
; 145                         b--;
	dec b
l_111:
; 146                     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_110
; 147                     NetFtpLoadFileNextParseAddressEnd = hl;
	ld (netftploadfilenextparseaddressen), hl
	pop de
	pop bc
l_108:
	jp l_107
l_106:
; 148                 }
; 149             }
; 150         } else {
; 151             hl = NetFtpLoadFileNextParseAddressEnd;
	ld hl, (netftploadfilenextparseaddressen)
; 152             ordos_stop();
	call ordos_stop
l_107:
	pop hl
	ret
; 153         }
; 154     }
; 155 }
; 156 
; 157 /// Считаем адрес куда писать данные на диск
; 158 void NetFtpLoadFileNextParseCalkDiskPosToHL() {
netftploadfilenextparsecalkdiskp:
; 159     push_pop(de) {
	push de
; 160         // получаем адрес пакета
; 161         hl = NetFtpLoadFileNextParseAddress;
	ld hl, (netftploadfilenextparseaddress)
; 162         // прибавляем к точке начала файла на диске
; 163         d = h;
	ld d, h
; 164         e = l;
	ld e, l
; 165         hl = DiskViewStartNewFile;
	ld hl, (diskviewstartnewfile)
; 166         a = l;
	ld a, l
; 167         a += e;
	add e
; 168         if (flag_c) {
	jp nc, l_113
; 169             h++;
	inc h
l_113:
; 170         }
; 171         l = a;
	ld l, a
; 172         a = h;
	ld a, h
; 173         a += d;
	add d
; 174         h = a;
	ld h, a
; 175         push_pop(hl) {
	push hl
; 176             a = l;
	ld a, l
; 177             a &= 0x01;
	and 1
; 178             if (a > 0) {
	or a
	jp z, l_115
; 179                 a = 0;
	ld a, 0
; 180                 myCharPosX = a;
	ld (mycharposx), a
; 181                 a = 0;
	ld a, 0
; 182                 myCharPosY = a;
	ld (mycharposy), a
; 183                 printMyHexA(a = h);
	ld a, h
	call printmyhexa
; 184                 printMyHexA(a = l);
	ld a, l
	call printmyhexa
l_115:
	pop hl
	pop de
	ret
; 185             }
; 186         }
; 187         // В HL адрес записи, полученных данных, на диск
; 188     }
; 189 }
; 190 
; 191 void NetFtpLoadFileNextParseSum() {
netftploadfilenextparsesum:
; 192     push_pop(hl, bc) {
	push hl
	push bc
; 193         b = l;
	ld b, l
; 194         b--;
	dec b
; 195         hl = Net_buffer;
	ld hl, net_buffer
; 196         c = 0;
	ld c, 0
; 197         do {
l_117:
; 198             a = *hl;
	ld a, (hl)
; 199             a += c;
	add c
; 200             c = a;
	ld c, a
; 201             hl++;
	inc hl
; 202             b--;
	dec b
l_118:
; 203         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_117
; 204         a = *hl;
	ld a, (hl)
; 205         if (a == c) {
	cp c
	jp nz, l_120
; 206             a = 0x01;
	ld a, 1
; 207             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
	jp l_121
l_120:
; 208         } else {
; 209             a = 0x00;
	ld a, 0
; 210             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
l_121:
; 211         }
; 212         //-- 3 byte = byte 0x3C
; 213         hl = Net_buffer;
	ld hl, net_buffer
; 214         hl++;
	inc hl
; 215         hl++;
	inc hl
; 216         hl++;
	inc hl
; 217         a = *hl;
	ld a, (hl)
; 218         if (a != 0x3C) {
	cp 60
	jp z, l_122
; 219             a = 0x00;
	ld a, 0
; 220             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
l_122:
	pop bc
	pop hl
	ret
; 221         }
; 222     }
; 223 }
; 224 
; 225 void NetGetAllStatusParse() {
netgetallstatusparse:
; 226     if ((a = l) > 0) {
	ld a, l
	or a
	jp z, l_124
; 227         NetGetAllStatusParseSum();
	call netgetallstatusparsesum
; 228         if ((a = NetGetAllStatusParseSumState) == 1) {
	ld a, (netgetallstatusparsesumstate)
	cp 1
	jp nz, l_126
; 229             hl = Net_buffer;
	ld hl, net_buffer
; 230             //-- 0x3C
; 231             hl++;
	inc hl
; 232             //-- WIFIflag
; 233             ThreadsNetSetWiFiStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetwifistatea
; 234             hl++;
	inc hl
; 235             //-- FtpConnected
; 236             ThreadsNetSetFtpStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetftpstatea
; 237             hl++;
	inc hl
; 238             //-- espError
; 239             ESPErrorParserA(a = *hl);
	ld a, (hl)
	call esperrorparsera
; 240             hl++;
	inc hl
l_126:
l_124:
	ret
; 241         }
; 242     }
; 243 }
; 244 
; 245 void NetGetAllStatusParseSum() {
netgetallstatusparsesum:
; 246     push_pop(hl, bc) {
	push hl
	push bc
; 247         b = l;
	ld b, l
; 248         b--;
	dec b
; 249         hl = Net_buffer;
	ld hl, net_buffer
; 250         c = 0;
	ld c, 0
; 251         a = *hl;
	ld a, (hl)
; 252         if (a == 0x3C) {
	cp 60
	jp nz, l_128
; 253             do {
l_130:
; 254                 a = *hl;
	ld a, (hl)
; 255                 a += c;
	add c
; 256                 c = a;
	ld c, a
; 257                 hl++;
	inc hl
; 258                 b--;
	dec b
l_131:
; 259             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_130
; 260             a = *hl;
	ld a, (hl)
; 261             if (a == c) {
	cp c
	jp nz, l_133
; 262                 a = 0x01;
	ld a, 1
; 263                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
	jp l_134
l_133:
; 264             } else {
; 265                 a = 0x00;
	ld a, 0
; 266                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
l_134:
	jp l_129
l_128:
; 267             }
; 268         } else {
; 269             a = 0x00;
	ld a, 0
; 270             NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
l_129:
	pop bc
	pop hl
	ret
; 271         }
; 272     }
; 273 }
; 274 
; 275 /// HL - point Str
; 276 /// B - Len Str
; 277 /// C - Len buffer
; 278 void ParserBufferSumToHL() {
parserbuffersumtohl:
; 279     ParserBufferSumToHLSum();
	call parserbuffersumtohlsum
; 280     if ((a = ParserBufferSumToHLSumState) == 1) {
	ld a, (parserbuffersumtohlsumstate)
	cp 1
	jp nz, l_135
; 281         push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 282             de = Net_buffer;
	ld de, net_buffer
; 283             c--;
	dec c
; 284             c--;
	dec c
; 285             do {
l_137:
; 286                 if ((a = c) > 0) {
	ld a, c
	or a
	jp z, l_140
; 287                     a = *de;
	ld a, (de)
; 288                     *hl = a;
	ld (hl), a
; 289                     de++;
	inc de
; 290                     c--;
	dec c
	jp l_141
l_140:
; 291                 } else {
; 292                     *hl = 0;
	ld (hl), 0
l_141:
; 293                 }
; 294                 hl++;
	inc hl
; 295                 b--;
	dec b
l_138:
; 296             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_137
	pop de
	pop bc
	pop hl
	jp l_136
l_135:
; 297         }
; 298     } else {
l_136:
	ret
; 299         //ParserBufferErrorSumShow();
; 300     }
; 301 }
; 302 
; 303 void ParserBufferErrorSumShow() {
parserbuffererrorsumshow:
; 304     push_pop(hl, bc) {
	push hl
	push bc
; 305         //Show Len Buffer
; 306         a = 0;
	ld a, 0
; 307         myCharPosX = a;
	ld (mycharposx), a
; 308         a = 0;
	ld a, 0
; 309         myCharPosY = a;
	ld (mycharposy), a
; 310         printMyHexA(a = c);
	ld a, c
	call printmyhexa
; 311         //-- Buffer
; 312         a = 0;
	ld a, 0
; 313         myCharPosX = a;
	ld (mycharposx), a
; 314         a = 1;
	ld a, 1
; 315         myCharPosY = a;
	ld (mycharposy), a
; 316         hl = Net_buffer;
	ld hl, net_buffer
; 317         c--; //
	dec c
; 318         b = 0;
	ld b, 0
; 319         do {
l_142:
; 320             a = *hl;
	ld a, (hl)
; 321             a += b;
	add b
; 322             b = a;
	ld b, a
; 323             //-- Show
; 324             printMyHexA(a = *hl);
	ld a, (hl)
	call printmyhexa
; 325             printMyCharA(a = 0x20);
	ld a, 32
	call printmychara
; 326             //--
; 327             hl++;
	inc hl
; 328             c--;
	dec c
l_143:
; 329         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_142
; 330         printMyHexA(a = *hl);
	ld a, (hl)
	call printmyhexa
; 331         printMyCharA(a = 0x20);
	ld a, 32
	call printmychara
; 332         //-- SUM
; 333         a = 0;
	ld a, 0
; 334         myCharPosX = a;
	ld (mycharposx), a
; 335         a = 3;
	ld a, 3
; 336         myCharPosY = a;
	ld (mycharposy), a
; 337         printMyHexA(a = b);
	ld a, b
	call printmyhexa
; 338         //--
; 339         for(;;){}
l_146:
	jp l_146
	pop bc
	pop hl
	ret
; 340     }
; 341 }
; 342 
; 343 void ParserBufferSumToHLSum() {
parserbuffersumtohlsum:
; 344     push_pop(hl, bc) {
	push hl
	push bc
; 345         if ((a = c) >= 3) {
	ld a, c
	cp 3
	jp c, l_148
; 346             b = c;
	ld b, c
; 347             b--;
	dec b
; 348             c = 0;
	ld c, 0
; 349             hl = Net_buffer;
	ld hl, net_buffer
; 350             do {
l_150:
; 351                 a = *hl;
	ld a, (hl)
; 352                 a += c;
	add c
; 353                 c = a;
	ld c, a
; 354                 hl++;
	inc hl
; 355                 b--;
	dec b
l_151:
; 356             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_150
; 357             // 3C
; 358             hl--;
	dec hl
; 359             a = *hl;
	ld a, (hl)
; 360             if (a == 0x3C) {
	cp 60
	jp nz, l_153
; 361                 hl++;
	inc hl
; 362                 // SUM
; 363                 a = *hl;
	ld a, (hl)
; 364                 if (a == c) {
	cp c
	jp nz, l_155
; 365                     a = 1;
	ld a, 1
; 366                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
	jp l_156
l_155:
; 367                 } else {
; 368                     a = 0;
	ld a, 0
; 369                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
l_156:
	jp l_154
l_153:
; 370                 }
; 371             } else {
; 372                 a = 0;
	ld a, 0
; 373                 ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
l_154:
	jp l_149
l_148:
; 374             }
; 375         } else {
; 376             a = 0;
	ld a, 0
; 377             ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
l_149:
	pop bc
	pop hl
	ret
; 378         }
; 379     }
; 380 }
; 381 
; 382 uint8_t ParserBufferSumToHLSumState = 0;
parserbuffersumtohlsumstate:
	db 0
; 383 uint8_t NetGetAllStatusParseSumState = 0;
netgetallstatusparsesumstate:
	db 0
; 384 uint16_t NetFtpLoadFileNextParseAddress = 0;
netftploadfilenextparseaddress:
	dw 0
; 385 uint16_t NetFtpLoadFileNextParseAddressEnd = 0;
netftploadfilenextparseaddressen:
	dw 0
; 386 uint8_t NetFtpLoadFileNextParseSumState = 0;
netftploadfilenextparsesumstate:
	db 0
; 387 uint8_t NetFtpListFilesParseSumState = 0;
netftplistfilesparsesumstate:
	db 0
; 12 void ParserFileUploadInit() {
parserfileuploadinit:
; 13     push_pop(hl) {
	push hl
; 14         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 15         ordos_wnd(); // Устанавливаем диск
	call ordos_wnd
	pop hl
; 16     }
; 17     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 18         ordos_sdma(); // уст.указ.имени
	call ordos_sdma
; 19         ordos_pscf(); // a = 1 файл найден HL - адрес стоп-байта
	call ordos_pscf
; 20         c = a;
	ld c, a
; 21         if ((a = c) == 0xFF) {
	ld a, c
	cp 255
	jp nz, l_157
; 22             ParserFileUploadStartAddress = hl;
	ld (parserfileuploadstartaddress), hl
; 23             ordos_atf(); // hl = нач.адрес файла de = конеч.адрес файла
	call ordos_atf
; 24             hl = ParserFileUploadStartAddress;
	ld hl, (parserfileuploadstartaddress)
; 25             ParserFileDESubHL();
	call parserfiledesubhl
; 26             h = d;
	ld h, d
; 27             l = e;
	ld l, e
; 28             ParserFileUploadLen = hl;
	ld (parserfileuploadlen), hl
; 29             ParserFileUploadCount = hl;
	ld (parserfileuploadcount), hl
	jp l_158
l_157:
; 30         } else {
; 31             hl = 0;
	ld hl, 0
; 32             ParserFileUploadStartAddress = hl;
	ld (parserfileuploadstartaddress), hl
; 33             ParserFileUploadLen = hl;
	ld (parserfileuploadlen), hl
; 34             ParserFileUploadCount = hl;
	ld (parserfileuploadcount), hl
l_158:
	pop de
	pop bc
	pop hl
	ret
; 35         }
; 36     }
; 37 }
; 38 
; 39 // Пачки по 16 байт
; 40 // b - sum, bb - len, b - isEnd
; 41 void ParserFileUploadCreateBuffer() {
parserfileuploadcreatebuffer:
; 42     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 43         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 44         ordos_wnd(); // Устанавливаем диск
	call ordos_wnd
; 45         de = Net_buffer;
	ld de, net_buffer
; 46         hl = ParserFileUploadStartAddress;
	ld hl, (parserfileuploadstartaddress)
; 47         b = 16;
	ld b, 16
; 48         c = 0;
	ld c, 0
; 49         do {
l_159:
; 50             ordos_rdisk();
	call ordos_rdisk
; 51             *de = a;
	ld (de), a
; 52             a += c;
	add c
; 53             c = a;
	ld c, a
; 54             hl++;
	inc hl
; 55             de++;
	inc de
; 56             b--;
	dec b
l_160:
; 57         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_159
; 58         //-- SUM
; 59         a = c;
	ld a, c
; 60         *de = a;
	ld (de), a
; 61         de++;
	inc de
; 62         //-- LEN
; 63         hl = ParserFileUploadLen;
	ld hl, (parserfileuploadlen)
; 64         a = l;
	ld a, l
; 65         *de = a;
	ld (de), a
; 66         de++;
	inc de
; 67         a = h;
	ld a, h
; 68         *de = a;
	ld (de), a
; 69         de++;
	inc de
; 70         //-- IsEnd
; 71         hl = ParserFileUploadCount;
	ld hl, (parserfileuploadcount)
; 72         c = 0;
	ld c, 0
; 73         if ((a = h) == 0) {
	ld a, h
	or a
	jp nz, l_162
; 74             if ( (a = l) < 17 ) {
	ld a, l
	cp 17
	jp nc, l_164
; 75                 c = 1;
	ld c, 1
l_164:
l_162:
; 76             }
; 77         }
; 78         a = c;
	ld a, c
; 79         *de = a;
	ld (de), a
	pop bc
	pop de
	pop hl
	ret
; 80     }
; 81 }
; 82 
; 83 // b = 0x3C, b = isCorrect, b = progress, b = sum
; 84 // Вых [A] - 1 - дальше. 0 - выход
; 85 void ParserFileUploadParse() {
parserfileuploadparse:
; 86     ParserFileUploadParseSum();
	call parserfileuploadparsesum
; 87     if (a == 1) {
	cp 1
	jp nz, l_166
; 88         push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 89             de = Net_buffer;
	ld de, net_buffer
; 90             de++;
	inc de
; 91             a = *de;
	ld a, (de)
; 92             if (a == 1) {
	cp 1
	jp nz, l_168
; 93                 // Отправить прогресс
; 94                 de++;
	inc de
; 95                 a = ParserFileUploadProgress;
	ld a, (parserfileuploadprogress)
; 96                 b = a;
	ld b, a
; 97                 a = *de;
	ld a, (de)
; 98                 if (a != b) {
	cp b
	jp z, l_170
; 99                     ParserFileUploadProgress = a;
	ld (parserfileuploadprogress), a
; 100                     LoadViewShowProgressA(); //a = *de;
	call loadviewshowprogressa
l_170:
; 101                 }
; 102                 // Следующий шаг отправки
; 103                 hl = ParserFileUploadStartAddress;
	ld hl, (parserfileuploadstartaddress)
; 104                 bc = 16;
	ld bc, 16
; 105                 hl += bc;
	add hl, bc
; 106                 ParserFileUploadStartAddress = hl; // Новый адрес чтения
	ld (parserfileuploadstartaddress), hl
; 107                 hl = ParserFileUploadCount;
	ld hl, (parserfileuploadcount)
; 108                 bc = 0xFFF0;
	ld bc, 65520
; 109                 hl += bc;
	add hl, bc
; 110                 ParserFileUploadCount = hl; // Оставшаяся длина файла
	ld (parserfileuploadcount), hl
; 111                 
; 112                 // Условие что делаем дальше...
; 113                 c = 1;
	ld c, 1
; 114                 hl = ParserFileUploadCount;
	ld hl, (parserfileuploadcount)
; 115                 if ((a = h) == 0) {
	ld a, h
	or a
	jp nz, l_172
; 116                     if ((a = l) == 0) {
	ld a, l
	or a
	jp nz, l_174
; 117                         c = 0; // СТОП!
	ld c, 0
l_174:
l_172:
; 118                     }
; 119                 }
; 120                 a = c;
	ld a, c
	jp l_169
l_168:
; 121             } else {
; 122                 a = 1; // Данные не корректны - отправляем еще раз!
	ld a, 1
l_169:
	pop bc
	pop de
	pop hl
	jp l_167
l_166:
; 123             }
; 124         }
; 125     } else {
; 126         a = 0;
	ld a, 0
l_167:
	ret
; 127     }
; 128 }
; 129 
; 130 void ParserFileUploadParseSum() {
parserfileuploadparsesum:
; 131     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 132         de = Net_buffer;
	ld de, net_buffer
; 133         b = 3;
	ld b, 3
; 134         c = 0;
	ld c, 0
; 135         do {
l_176:
; 136             a = *de;
	ld a, (de)
; 137             a += c;
	add c
; 138             c = a;
	ld c, a
; 139             de++;
	inc de
; 140             b--;
	dec b
l_177:
; 141         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_176
; 142         a = *de;
	ld a, (de)
; 143         if (a == c) {
	cp c
	jp nz, l_179
; 144             a = 1;
	ld a, 1
	jp l_180
l_179:
; 145         } else {
; 146             a = 0;
	ld a, 0
l_180:
	pop bc
	pop de
	pop hl
	ret
; 147         }
; 148     }
; 149 }
; 150 
; 151 // DE = DE - HL
; 152 void ParserFileDESubHL() {
parserfiledesubhl:
; 153     a = e;  // Load low byte of E into accumulator
	ld a, e
; 154     a -= l; // Subtract low byte of L (A = E - L)
	sub l
; 155     e = a;  // Store result back in E
	ld e, a
; 156     
; 157     a = d;  // Load high byte of D into accumulator
	ld a, d
; 158     carry_sub(a, h);    // Subtract high byte of DE with borrow (A = D - H - Carry)
	sbc h
; 159     d = a;  // Store result back in D
	ld d, a
	ret
; 160 }
; 161 
; 162 uint16_t ParserFileUploadStartAddress = 0;
parserfileuploadstartaddress:
	dw 0
; 163 uint16_t ParserFileUploadLen = 0;
parserfileuploadlen:
	dw 0
; 164 uint16_t ParserFileUploadCount = 0;
parserfileuploadcount:
	dw 0
; 165 uint8_t ParserFileUploadProgress = 0;
parserfileuploadprogress:
	db 0
; 11 void WiFiSettingsViewShow() {
wifisettingsviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         CurrentViewChangeAndPushIdA(a = WiFiSettingsViewId);
	ld a, 5
	call currentviewchangeandpushida
; 14         //--
; 15         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 16         h = a;
	ld h, a
; 17         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 18         l = a;
	ld l, a
; 19         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 20         d = a;
	ld d, a
; 21         a = WiFiSettingsViewDY;
	ld a, (wifisettingsviewdy)
; 22         e = a;
	ld e, a
; 23         a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
; 24         c = a;
	ld c, a
; 25         a = vboxCLW;
	ld a, 64
; 26         a |= vboxFRM;
	or 32
; 27         a |= vboxSDW;
	or 16
; 28         a |= vboxSAV;
	or 8
; 29         a |= vboxUMP;
	or 4
; 30         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 31     }
; 32     a = 0;
	ld a, 0
; 33     WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 34     WiFiSettingsViewShowTitle();
	call wifisettingsviewshowtitle
; 35     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 36     WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp wifisettingsviewselectlinea
; 37 }
; 38 
; 39 void WiFiSettingsViewShowTitle() {
wifisettingsviewshowtitle:
; 40     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 41         // Title
; 42         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 43         a += 7;
	add 7
; 44         myCharPosX = a;
	ld (mycharposx), a
; 45         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 46         a += 1; //2;
	add 1
; 47         myCharPosY = a;
	ld (mycharposy), a
; 48         printMyHLStr(hl = WiFiSettingsViewTitle);
	ld hl, wifisettingsviewtitle
	call printmyhlstr
; 49         // LINE!!!
; 50         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 51         a += 1;
	add 1
; 52         myCharPosX = a;
	ld (mycharposx), a
; 53         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 54         a += 2;
	add 2
; 55         myCharPosY = a;
	ld (mycharposy), a
; 56         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 57         a -= 2;
	sub 2
; 58         b = a;
	ld b, a
; 59         do {
l_181:
; 60             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 61             b--;
	dec b
l_182:
; 62         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_181
; 63         // SSID
; 64         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 65         a += 2;
	add 2
; 66         b = a; // X
	ld b, a
; 67         myCharPosX = a;
	ld (mycharposx), a
; 68         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 69         a += 4;
	add 4
; 70         c = a; // Y
	ld c, a
; 71         myCharPosY = a;
	ld (mycharposy), a
; 72         printMyHLStr(hl = WiFiSettingsViewTitleSSID);
	ld hl, wifisettingsviewtitlessid
	call printmyhlstr
; 73         // PASS
; 74         a = b;
	ld a, b
; 75         myCharPosX = a;
	ld (mycharposx), a
; 76         a = c;
	ld a, c
; 77         a += 1;
	add 1
; 78         myCharPosY = a;
	ld (mycharposy), a
; 79         printMyHLStr(hl = WiFiSettingsViewTitlePass);
	ld hl, wifisettingsviewtitlepass
	call printmyhlstr
; 80         // MAC
; 81         a = b;
	ld a, b
; 82         myCharPosX = a;
	ld (mycharposx), a
; 83         a = c;
	ld a, c
; 84         a += 2;
	add 2
; 85         myCharPosY = a;
	ld (mycharposy), a
; 86         printMyHLStr(hl = WiFiSettingsViewTitleMac);
	ld hl, wifisettingsviewtitlemac
	call printmyhlstr
; 87         // OK
; 88         d = 13;
	ld d, 13
; 89         e = 3;
	ld e, 3
; 90         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 91         a += 7;
	add 7
; 92         h = a;
	ld h, a
; 93         a = c;
	ld a, c
; 94         a += 4;
	add 4
; 95         l = a;
	ld l, a
; 96         if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
	ld a, (wifisettingsviewssidisconnected)
	or a
	jp nz, l_184
; 97             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp l_185
l_184:
; 98         } else {
; 99             bc = StringLocaleOK;
	ld bc, stringlocaleok
l_185:
; 100         }
; 101         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 102     }
; 103 }
; 104 
; 105 void WiFiSettingsViewShowValue() {
wifisettingsviewshowvalue:
; 106     push_pop(hl, bc) {
	push hl
	push bc
; 107         // SSID
; 108         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 109         a += 8;
	add 8
; 110         b = a; // X
	ld b, a
; 111         myCharPosX = a;
	ld (mycharposx), a
; 112         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 113         a += 4;
	add 4
; 114         c = a; // Y
	ld c, a
; 115         myCharPosY = a;
	ld (mycharposy), a
; 116         a = 18;
	ld a, 18
; 117         printMyHLStrLenA(hl = WiFiSettingsViewSsidValue);
	ld hl, wifisettingsviewssidvalue
	call printmyhlstrlena
; 118         // PASS
; 119         a = b;
	ld a, b
; 120         myCharPosX = a;
	ld (mycharposx), a
; 121         a = c;
	ld a, c
; 122         a += 1;
	add 1
; 123         myCharPosY = a;
	ld (mycharposy), a
; 124         a = 18;
	ld a, 18
; 125         printMyHLPassLenA(hl = WiFiSettingsViewPassValue);
	ld hl, wifisettingsviewpassvalue
	call printmyhlpasslena
; 126         // MAC
; 127         a = b;
	ld a, b
; 128         myCharPosX = a;
	ld (mycharposx), a
; 129         a = c;
	ld a, c
; 130         a += 2;
	add 2
; 131         myCharPosY = a;
	ld (mycharposy), a
; 132         a = 18;
	ld a, 18
; 133         printMyHLStrLenA(hl = WiFiSettingsViewMacValue);
	ld hl, wifisettingsviewmacvalue
	call printmyhlstrlena
	pop bc
	pop hl
	ret
; 134     }
; 135 }
; 136 
; 137 void WiFiSettingsViewClose() {
wifisettingsviewclose:
; 138     vboxClose();
	call vboxclose
; 139     CurrentViewReturn();
	jp currentviewreturn
; 140 }
; 141 
; 142 void WiFiSettingsViewKeyA() {
wifisettingsviewkeya:
; 143     push_pop(hl) {
	push hl
; 144         l = a;
	ld l, a
; 145         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_186
; 146             if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_188
; 147                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_190
; 148                     WiFiSettingsViewClose();
	call wifisettingsviewclose
	jp l_191
l_190:
; 149                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_192
; 150                     if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, l_194
; 151                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 152                         if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
	ld a, (wifisettingsviewssidisconnected)
	or a
	jp nz, l_196
; 153                             NetWiFiConnect(); // Подключиться
	call netwificonnect
; 154                             ThreadsTickNow(); // Обновить
	call threadsticknow
; 155                             ThreadsNetDetectError();
	call threadsnetdetecterror
l_196:
	jp l_195
l_194:
; 156                         }
; 157                     } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
	ld a, (wifisettingsviewselectpos)
	cp 1
	jp nz, l_198
; 158                         WiFiNetworksViewShow();
	call wifinetworksviewshow
	jp l_199
l_198:
; 159                     } else { // Переход в редактирование
; 160                         WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 161                         WiFiSettingsViewByPosValue();
	call wifisettingsviewbyposvalue
; 162                         EditFieldViewShow();
	call editfieldviewshow
; 163                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, l_200
; 164                             #ifdef _IS_SIMULATOR
; 165 
; 166                             #else
; 167                                 ThreadsNetPasswordUpdate();
	call threadsnetpasswordupdate
; 168                             #endif
; 169                             WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 170                             WifiStateViewShowValue();
	call wifistateviewshowvalue
l_200:
l_199:
l_195:
	jp l_193
l_192:
; 171                         }
; 172                     }
; 173                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_202
; 174                     WiFiSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifisettingsviewposupdatea
	jp l_203
l_202:
; 175                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_204
; 176                     WiFiSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifisettingsviewposupdatea
l_204:
l_203:
l_193:
l_191:
l_188:
l_186:
	pop hl
	ret
; 177                 }
; 178             }
; 179         }
; 180     }
; 181 }
; 182 
; 183 /// вых [BC] -
; 184 void WiFiSettingsViewByPosValue() {
wifisettingsviewbyposvalue:
; 185     push_pop(hl) {
	push hl
; 186         if ((a = WiFiSettingsViewSelectPos) == 2) {
	ld a, (wifisettingsviewselectpos)
	cp 2
	jp nz, l_206
; 187             bc = WiFiSettingsViewPassValue;
	ld bc, wifisettingsviewpassvalue
	jp l_207
l_206:
; 188         } else {
; 189             bc = 0;
	ld bc, 0
l_207:
	pop hl
	ret
; 190         }
; 191     }
; 192 }
; 193 
; 194 /// вых [HL] -
; 195 /// вых [DE]-
; 196 void WiFiSettingsViewByPosBoxValue() {
wifisettingsviewbyposboxvalue:
; 197     push_pop(bc) {
	push bc
; 198         // HL
; 199         a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 200         b = a;
	ld b, a
; 201         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 202         a += 3;
	add 3
; 203         a += b;
	add b
; 204         l = a;
	ld l, a
; 205         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 206         a += 7;
	add 7
; 207         h = a;
	ld h, a
; 208         // DE
; 209         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 210         a -= 8;
	sub 8
; 211         d = a;
	ld d, a
; 212         a = 1;
	ld a, 1
; 213         e = a;
	ld e, a
	pop bc
	ret
; 214     }
; 215 }
; 216 
; 217 /// Рисование линии прямым или инверсным цветом
; 218 /// 0 - прямой
; 219 /// 1 - инверсный
; 220 void WiFiSettingsViewSelectLineA() {
wifisettingsviewselectlinea:
; 221     push_pop(bc, hl) {
	push bc
	push hl
; 222         c = a;
	ld c, a
; 223         // 0 - Button
; 224         if ((a = WiFiSettingsViewSelectPos) == 0) {
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, l_208
; 225             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp l_209
l_208:
; 226         } else {
; 227             WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 228             // C
; 229             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_210
; 230                 a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
	jp l_211
l_210:
; 231             } else {
; 232                 a = WiFiSettingsViewInvColor;
	ld a, (wifisettingsviewinvcolor)
l_211:
; 233             }
; 234             c = a;
	ld c, a
; 235             // A
; 236             a = vboxUMP;
	ld a, 4
; 237             vboxOpenHLDECA();
	call vboxopenhldeca
l_209:
	pop hl
	pop bc
	ret
; 238         }
; 239     }
; 240 }
; 241 
; 242 /// Обновление позиции
; 243 /// вх[A]
; 244 /// 0 - без изменений
; 245 /// 1 - вверх
; 246 /// 0xFF - вниз
; 247 void WiFiSettingsViewPosUpdateA() {
wifisettingsviewposupdatea:
; 248     push_pop(bc) {
	push bc
; 249         b = a;
	ld b, a
; 250         if (a == 0) {
	or a
	jp nz, l_212
; 251             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
	jp l_213
l_212:
; 252         } else {
; 253             a = 3;
	ld a, 3
; 254             c = a;
	ld c, a
; 255             WiFiSettingsViewSelectLineA(a = 0);
	ld a, 0
	call wifisettingsviewselectlinea
; 256             a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 257             a += b;
	add b
; 258             //-- FIX
; 259             if (a == 0xFF) {
	cp 255
	jp nz, l_214
; 260                 a = c;
	ld a, c
; 261                 a--;
	dec a
	jp l_215
l_214:
; 262             } else if (a == c) {
	cp c
	jp nz, l_216
; 263                 a = 0;
	ld a, 0
l_216:
l_215:
; 264             }
; 265             //--
; 266             WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 267             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
l_213:
	pop bc
	ret
; 268         }
; 269     }
; 270 }
; 271 
; 272 uint8_t WiFiSettingsViewX = 11;
wifisettingsviewx:
	db 11
; 273 uint8_t WiFiSettingsViewY = 10;
wifisettingsviewy:
	db 10
; 274 uint8_t WiFiSettingsViewDX = 27;
wifisettingsviewdx:
	db 27
; 275 uint8_t WiFiSettingsViewDY = 13;
wifisettingsviewdy:
	db 13
; 276 uint8_t WiFiSettingsViewColor = 0x70;
wifisettingsviewcolor:
	db 112
; 277 uint8_t WiFiSettingsViewInvColor = 0x07;
wifisettingsviewinvcolor:
	db 7
; 279 uint8_t WiFiSettingsViewSelectPos = 0;
wifisettingsviewselectpos:
	db 0
; 281 uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
wifisettingsviewtitle:
	db 87
	db 105
	db 45
	db 70
	db 105
	db 32
	db 115
	db 101
	db 116
	db 116
	db 105
	db 110
	db 103
	db 115
	ds 1
; 282 uint8_t WiFiSettingsViewTitleSSID[] = "SSID: ";
wifisettingsviewtitlessid:
	db 83
	db 83
	db 73
	db 68
	db 58
	db 32
	ds 1
; 283 uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
wifisettingsviewtitlepass:
	db 80
	db 97
	db 115
	db 115
	db 58
	ds 1
; 284 uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
wifisettingsviewtitlemac:
	db 32
	db 77
	db 65
	db 67
	db 58
	ds 1
; 285 uint8_t WiFiSettingsViewButtonTitle[] = "Connect";
wifisettingsviewbuttontitle:
	db 67
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	ds 1
; 286 uint8_t WiFiSettingsViewSSIDIsConnected = 0;
wifisettingsviewssidisconnected:
	db 0
; 288 uint8_t WiFiSettingsViewSsidValue[16] = "-";
wifisettingsviewssidvalue:
	db 45
	ds 15
; 289 uint8_t WiFiSettingsViewPassValue[16] = "-";
wifisettingsviewpassvalue:
	db 45
	ds 15
; 290 uint8_t WiFiSettingsViewMacValue[18] = "00:00:00:00:00:00";
wifisettingsviewmacvalue:
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	ds 1
; 291 uint8_t WiFiSettingsViewIpValue[16] = "0.0.0.0";
wifisettingsviewipvalue:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 11 void printMyHexA() {
printmyhexa:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         a &= 0xF0;
	and 240
; 15         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 16         if (a < 10) {
	cp 10
	jp nc, l_218
; 17             a += 0x30;
	add 48
	jp l_219
l_218:
; 18         } else {
; 19             a += 0x37;
	add 55
l_219:
; 20         }
; 21         printMyCharA();
	call printmychara
; 22         a = b;
	ld a, b
; 23         a &= 0x0F;
	and 15
; 24         if (a < 10) {
	cp 10
	jp nc, l_220
; 25             a += 0x30;
	add 48
	jp l_221
l_220:
; 26         } else {
; 27             a += 0x37;
	add 55
l_221:
; 28         }
; 29         printMyCharA();
	call printmychara
	pop bc
	ret
; 30     }
; 31 }
; 32 
; 33 void printMyUTF8HLStr() {
printmyutf8hlstr:
; 34     do {
l_222:
; 35         a = *hl;
	ld a, (hl)
; 36         if (a == 0xD0) {
	cp 208
	jp nz, l_225
; 37             hl++;
	inc hl
; 38             a = *hl;
	ld a, (hl)
; 39             a += 0xF0;
	add 240
	jp l_226
l_225:
; 40         } else if (a == 0xD1) {
	cp 209
	jp nz, l_227
; 41             hl++;
	inc hl
; 42             a = *hl;
	ld a, (hl)
; 43             a += 0x60;
	add 96
l_227:
l_226:
; 44         }
; 45         if (a > 0 ) {
	or a
	jp z, l_229
; 46             printMyCharA();
	call printmychara
l_229:
; 47         }
; 48         //
; 49         a = *hl;
	ld a, (hl)
; 50         hl++;
	inc hl
l_223:
; 51     } while (a > 0);
	or a
	jp nz, l_222
	ret
; 52 }
; 53 
; 54 void printMyHLStr() {
printmyhlstr:
; 55     do {
l_231:
; 56         a = *hl;
	ld a, (hl)
; 57         if (a > 0) {
	or a
	jp z, l_234
; 58             printMyCharA();
	call printmychara
l_234:
; 59         }
; 60         a = *hl;
	ld a, (hl)
; 61         hl++;
	inc hl
l_232:
; 62     } while (a > 0);
	or a
	jp nz, l_231
	ret
; 63 }
; 64 
; 65 /// Выводит строку из HL с текущего положения
; 66 /// Длиной A. Если текст короче , то добиват до A пробелами
; 67 void printMyHLStrLenA() {
printmyhlstrlena:
; 68     push_pop(bc) {
	push bc
; 69         b = a;
	ld b, a
; 70         c = 0;
	ld c, 0
; 71         do {
l_236:
; 72             a = *hl;
	ld a, (hl)
; 73             if (a > 0) {
	or a
	jp z, l_239
; 74                 c++;
	inc c
; 75                 printMyCharA();
	call printmychara
l_239:
; 76             }
; 77             a = *hl;
	ld a, (hl)
; 78             hl++;
	inc hl
l_237:
; 79         } while (a > 0);
	or a
	jp nz, l_236
; 80         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, l_241
; 81             a = b;
	ld a, b
; 82             a -= c;
	sub c
; 83             b = a;
	ld b, a
; 84             do {
l_243:
; 85                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 86                 b--;
	dec b
l_244:
; 87             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_243
l_241:
	pop bc
	ret
; 88         }
; 89     }
; 90 }
; 91 
; 92 /// Выводит строку из HL с текущего положения заменяя все символы *
; 93 /// Длиной A. Если текст короче , то добиват до A пробелами
; 94 void printMyHLPassLenA() {
printmyhlpasslena:
; 95     push_pop(bc) {
	push bc
; 96         b = a;
	ld b, a
; 97         c = 0;
	ld c, 0
; 98         do {
l_246:
; 99             a = *hl;
	ld a, (hl)
; 100             if (a > 0) {
	or a
	jp z, l_249
; 101                 c++;
	inc c
; 102                 printMyCharA(a = '*');
	ld a, 42
	call printmychara
l_249:
; 103             }
; 104             a = *hl;
	ld a, (hl)
; 105             hl++;
	inc hl
l_247:
; 106         } while (a > 0);
	or a
	jp nz, l_246
; 107         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, l_251
; 108             a = b;
	ld a, b
; 109             a -= c;
	sub c
; 110             b = a;
	ld b, a
; 111             do {
l_253:
; 112                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 113                 b--;
	dec b
l_254:
; 114             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_253
l_251:
	pop bc
	ret
; 115         }
; 116     }
; 117 }
; 118 
; 119 void printMyCharA() {
printmychara:
; 120     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 121         // Char POS
; 122         hl = FONT_8_8_RUS;
	ld hl, font_8_8_rus
; 123         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 124         b = a;
	ld b, a
; 125         a &= 0x07;
	and 7
; 126         a += h;
	add h
; 127         h = a;
	ld h, a
; 128         a = b;
	ld a, b
; 129         a &= 0xF8;
	and 248
; 130         a += l;
	add l
; 131         if (flag_c) {
	jp nc, l_256
; 132             h++;
	inc h
l_256:
; 133         }
; 134         l = a;
	ld l, a
; 135         // Video POS
; 136         //de = 0xC000;
; 137         a = myCharPosY;
	ld a, (mycharposy)
; 138         a &= 0x1F;
	and 31
; 139         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 140         e = a;
	ld e, a
; 141         a = myCharPosX;
	ld a, (mycharposx)
; 142         a += 0xC0;
	add 192
; 143         d = a;
	ld d, a
; 144         //
; 145         b = 8;
	ld b, 8
; 146         do {
l_258:
; 147             a = *hl;
	ld a, (hl)
; 148             *de = a;
	ld (de), a
; 149             hl++;
	inc hl
; 150             de++;
	inc de
; 151             b--;
	dec b
l_259:
; 152         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_258
; 153         // Inc POS
; 154         a = myCharPosX;
	ld a, (mycharposx)
; 155         a++;
	inc a
; 156         if (a >= 0x30) { //0x2F
	cp 48
	jp c, l_261
; 157             a = 0;
	ld a, 0
; 158             b = a;
	ld b, a
; 159             // Inc Y
; 160             a = myCharPosY;
	ld a, (mycharposy)
; 161             a++;
	inc a
; 162             if (a >= 0x20) { //0x1F
	cp 32
	jp c, l_263
; 163                 a = 0;
	ld a, 0
l_263:
; 164             }
; 165             myCharPosY = a;
	ld (mycharposy), a
; 166             //
; 167             a = b;
	ld a, b
l_261:
; 168         }
; 169         myCharPosX = a;
	ld (mycharposx), a
	pop de
	pop bc
	pop hl
	ret
; 170     }
; 171 }
; 172 
; 173 void myCharPosXSpaceA(){
mycharposxspacea:
; 174     push_pop(bc) {
	push bc
; 175         b = a;
	ld b, a
; 176         a = myCharPosX;
	ld a, (mycharposx)
; 177         a += b;
	add b
; 178         myCharPosX = a;
	ld (mycharposx), a
	pop bc
	ret
; 179     }
; 180 }
; 181 
; 182 void myCharPosYSpaceA(){
mycharposyspacea:
; 183     push_pop(bc) {
	push bc
; 184         b = a;
	ld b, a
; 185         a = myCharPosY;
	ld a, (mycharposy)
; 186         a += b;
	add b
; 187         myCharPosY = a;
	ld (mycharposy), a
	pop bc
	ret
; 188     }
; 189 }
; 190 
; 191 /// Вывести на экран значение A как десятичное число
; 192 /// A не больше 99 или 0x63
; 193 /// Если больше - ничего не выводит
; 194 void printMyAsDec99A() {
printmyasdec99a:
; 195     if (a < 0x64) {
	cp 100
	jp nc, l_265
; 196         push_pop(bc, de) {
	push bc
	push de
; 197             b = a;
	ld b, a
; 198             c = a;
	ld c, a
; 199             d = 0;
	ld d, 0
; 200             e = 10;
	ld e, 10
; 201             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, l_267
; 202                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 203                 a = b;
	ld a, b
; 204                 a += '0';
	add 48
; 205                 printMyCharA();
	call printmychara
	jp l_268
l_267:
; 206             } else {
; 207                 do {
l_269:
; 208                     a = b;
	ld a, b
; 209                     a -= e;
	sub e
; 210                     b = a;
	ld b, a
; 211                     d++;
	inc d
l_270:
; 212                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, l_269
; 213                 a = d;
	ld a, d
; 214                 a += '0';
	add 48
; 215                 printMyCharA();
	call printmychara
; 216                 a = b;
	ld a, b
; 217                 a += '0';
	add 48
; 218                 printMyCharA();
	call printmychara
l_268:
	pop de
	pop bc
l_265:
	ret
; 219             }
; 220         }
; 221     }
; 222 }
; 223 
; 224 /// Вывести на экран значение A как десятичное число с ведущими нулями
; 225 /// A не больше 99 или 0x63
; 226 /// Если больше - ничего не выводит
; 227 void printMyAs00Dec99A() {
printmyas00dec99a:
; 228     if (a < 0x64) {
	cp 100
	jp nc, l_272
; 229         push_pop(bc, de) {
	push bc
	push de
; 230             b = a;
	ld b, a
; 231             c = a;
	ld c, a
; 232             d = 0;
	ld d, 0
; 233             e = 10;
	ld e, 10
; 234             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, l_274
; 235                 printMyCharA(a = '0');
	ld a, 48
	call printmychara
; 236                 a = b;
	ld a, b
; 237                 a += '0';
	add 48
; 238                 printMyCharA();
	call printmychara
	jp l_275
l_274:
; 239             } else {
; 240                 do {
l_276:
; 241                     a = b;
	ld a, b
; 242                     a -= e;
	sub e
; 243                     b = a;
	ld b, a
; 244                     d++;
	inc d
l_277:
; 245                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, l_276
; 246                 a = d;
	ld a, d
; 247                 a += '0';
	add 48
; 248                 printMyCharA();
	call printmychara
; 249                 a = b;
	ld a, b
; 250                 a += '0';
	add 48
; 251                 printMyCharA();
	call printmychara
l_275:
	pop de
	pop bc
l_272:
	ret
; 252             }
; 253         }
; 254     }
; 255 }
; 256 
; 257 /// Вывести на экран значение HL как десятичное число
; 258 /// A не больше 4095 или 0x0FFF
; 259 /// Если больше - ничего не выводит
; 260 void printMyAsDec4095HL() {
printmyasdec4095hl:
; 261     push_pop(bc, de) {
	push bc
	push de
; 262         de = 0x0FFF;
	ld de, 4095
; 263         compareHlDe();
	call comparehlde
; 264         if (flag_nc) {
	jp c, l_279
; 265             c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
	ld c, 0
; 266             //1000
; 267             de = 0x03E8;
	ld de, 1000
; 268             compareHlDe();
	call comparehlde
; 269             if (flag_c) {
	jp nc, l_281
; 270                 b = 0;
	ld b, 0
; 271                 do {
l_283:
; 272                     de = 0xFC18;
	ld de, 64536
; 273                     hl += de;
	add hl, de
; 274                     b++;
	inc b
; 275                     de = 0x03E8;
	ld de, 1000
; 276                     compareHlDe();
	call comparehlde
l_284:
	jp c, l_283
; 277                 } while (flag_c);
; 278                 a = b;
	ld a, b
; 279                 a += '0';
	add 48
; 280                 printMyCharA();
	call printmychara
; 281                 c = 1;
	ld c, 1
	jp l_282
l_281:
; 282             } else {
; 283                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
l_282:
; 284             }
; 285             //0100
; 286             de = 0x0064;
	ld de, 100
; 287             compareHlDe();
	call comparehlde
; 288             if (flag_c) {
	jp nc, l_286
; 289                 b = 0;
	ld b, 0
; 290                 do {
l_288:
; 291                     de = 0xFF9C;
	ld de, 65436
; 292                     hl += de;
	add hl, de
; 293                     b++;
	inc b
; 294                     de = 0x0064;
	ld de, 100
; 295                     compareHlDe();
	call comparehlde
l_289:
	jp c, l_288
; 296                 } while (flag_c);
; 297                 a = b;
	ld a, b
; 298                 a += '0';
	add 48
; 299                 printMyCharA();
	call printmychara
; 300                 c = 1;
	ld c, 1
	jp l_287
l_286:
; 301             } else {
; 302                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_291
; 303                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
	jp l_292
l_291:
; 304                 } else {
; 305                     printMyCharA(a = '0');
	ld a, 48
	call printmychara
l_292:
l_287:
; 306                 }
; 307             }
; 308             //0010
; 309 //            de = 0x000A;
; 310 //            compareHlDe();
; 311 //            if (flag_c) {
; 312 //                b = 0;
; 313 //                do {
; 314 //                    de = 0xFFF6;
; 315 //                    hl += de;
; 316 //                    b++;
; 317 //                    de = 0x000A;
; 318 //                    compareHlDe();
; 319 //                } while (flag_c);
; 320 //                a = b;
; 321 //                a += '0';
; 322 //                printMyCharA();
; 323 //            } else {
; 324 //                printMyCharA(a = '0');
; 325 //            }
; 326             a = l;
	ld a, l
; 327             if ((a = l) >= 10) {
	ld a, l
	cp 10
	jp c, l_293
; 328                 b = 0;
	ld b, 0
; 329                 do {
l_295:
; 330                     a = l;
	ld a, l
; 331                     a -= 10;
	sub 10
; 332                     l = a;
	ld l, a
; 333                     b++;
	inc b
l_296:
; 334                 } while ((a = l) >= 10);
	ld a, l
	cp 10
	jp nc, l_295
; 335                 a = b;
	ld a, b
; 336                 a += '0';
	add 48
; 337                 printMyCharA();
	call printmychara
; 338                 c = 1;
	ld c, 1
	jp l_294
l_293:
; 339             } else {
; 340                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_298
; 341                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
	jp l_299
l_298:
; 342                 } else {
; 343                     printMyCharA(a = '0');
	ld a, 48
	call printmychara
l_299:
l_294:
; 344                 }
; 345             }
; 346             //0001
; 347             a = l;
	ld a, l
; 348             a += '0';
	add 48
; 349             printMyCharA();
	call printmychara
l_279:
	pop de
	pop bc
	ret
; 350         }
; 351     }
; 352 }
; 353 
; 354 /// Спавнение HL и DE
; 355 /// CF=1 when DE < HL
; 356 /// CF=0 DE >= HL
; 357 void compareHlDe() {
comparehlde:
; 358     a = d;
	ld a, d
; 359     a ^= h;
	xor h
; 360     if (flag_p) {
	jp m, l_300
	jp l_301
l_300:
; 361     } else {
; 362         a ^= d;
	xor d
; 363         if (flag_m) {
	jp p, l_302
; 364             return;
	ret
l_302:
; 365         }
; 366         set_flag_c();
	scf
; 367         return;
	ret
l_301:
; 368     }
; 369     a = e;
	ld a, e
; 370     a -= l; //0x95
	sub l
; 371     a = d;
	ld a, d
; 372     //a -= h; //0x9C
; 373     //asm{ SBB h };
; 374     carry_sub(a, h);
	sbc h
; 375     return;
	ret
; 376 }
; 377 
; 378 uint8_t myCharPosX = 0;
mycharposx:
	db 0
; 379 uint8_t myCharPosY = 0;
mycharposy:
	db 0
; 11 void HelpViewShow() {
helpviewshow:
; 12     a = HelpViewX;
	ld a, (helpviewx)
; 13     h = a;
	ld h, a
; 14     a = HelpViewY;
	ld a, (helpviewy)
; 15     l = a;
	ld l, a
; 16     a = HelpViewDX;
	ld a, (helpviewdx)
; 17     d = a;
	ld d, a
; 18     a = HelpViewDY;
	ld a, (helpviewdy)
; 19     e = a;
	ld e, a
; 20     a = HelpViewColor;
	ld a, (helpviewcolor)
; 21     vboxOpenHLDE();
	call vboxopenhlde
; 22     HelpViewShowStr();
; 23 }
; 24 
; 25 void HelpViewShowStr() {
helpviewshowstr:
; 26     a = HelpViewX;
	ld a, (helpviewx)
; 27     a++;
	inc a
; 28     myCharPosX = a;
	ld (mycharposx), a
; 29     a = HelpViewY;
	ld a, (helpviewy)
; 30     a++;
	inc a
; 31     myCharPosY = a;
	ld (mycharposy), a
; 32     printMyHLStr(hl = HelpViewTitleF1);
	ld hl, helpviewtitlef1
	call printmyhlstr
; 33     
; 34     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 35     printMyHLStr(hl = HelpViewTitleF2);
	ld hl, helpviewtitlef2
	call printmyhlstr
; 36     
; 37     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 38     printMyHLStr(hl = HelpViewTitleF3);
	ld hl, helpviewtitlef3
	call printmyhlstr
; 39     
; 40     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 41     printMyHLStr(hl = HelpViewTitleF4);
	ld hl, helpviewtitlef4
	jp printmyhlstr
; 42 }
; 43 
; 44 uint8_t HelpViewX = 0;
helpviewx:
	db 0
; 45 uint8_t HelpViewY = 29;
helpviewy:
	db 29
; 46 uint8_t HelpViewDX = 48;
helpviewdx:
	db 48
; 47 uint8_t HelpViewDY = 3;
helpviewdy:
	db 3
; 51 uint8_t HelpViewColor = 0x5f; //0x67;
helpviewcolor:
	db 95
; 54 uint8_t HelpViewTitleF1[] = "F1: ..";
helpviewtitlef1:
	db 70
	db 49
	db 58
	db 32
	db 46
	db 46
	ds 1
; 55 uint8_t HelpViewTitleF2[] = "F2: Wi-Fi";
helpviewtitlef2:
	db 70
	db 50
	db 58
	db 32
	db 87
	db 105
	db 45
	db 70
	db 105
	ds 1
; 56 uint8_t HelpViewTitleF3[] = "F3: FTP ";
helpviewtitlef3:
	db 70
	db 51
	db 58
	db 32
	db 70
	db 84
	db 80
	db 32
	ds 1
; 57 uint8_t HelpViewTitleF4[] = "F4: Quit";
helpviewtitlef4:
	db 70
	db 52
	db 58
	db 32
	db 81
	db 117
	db 105
	db 116
	ds 1
; 11 void CurrentViewChangeAndPushIdA() {
currentviewchangeandpushida:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         // Save old Id
; 15         CurrentViewPushCurrentId();
	call currentviewpushcurrentid
; 16         //
; 17         a = b;
	ld a, b
; 18         CurrentViewSetIdA();
	call currentviewsetida
	pop bc
	ret
; 19     }
; 20 }
; 21 
; 22 void CurrentViewChangeIdA() {
currentviewchangeida:
; 23     push_pop(bc) {
	push bc
; 24         b = a;
	ld b, a
; 25         // Save new
; 26         a = b;
	ld a, b
; 27         CurrentViewSetIdA();
	call currentviewsetida
	pop bc
	ret
; 28     }
; 29 }
; 30 
; 31 void CurrentViewSetIdA() {
currentviewsetida:
; 32     CurrentViewId = a;
	ld (currentviewid), a
; 33     
; 34     if ((a = CurrentViewReturnIdPos) == 0) {
	ld a, (currentviewreturnidpos)
	or a
	jp nz, l_304
; 35         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_306
; 36             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 37             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp l_307
l_306:
; 38         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_308
; 39             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
; 40             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_309
l_308:
; 41         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_310
; 42             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 43             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_311
l_310:
; 44         } else if ((a = CurrentViewId) == LoadViewId) {
	ld a, (currentviewid)
	cp 4
	jp nz, l_312
; 45             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 46             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_313
l_312:
; 47         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_314
; 48             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 49             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_315
l_314:
; 50         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_316
; 51             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 52             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_317
l_316:
; 53         } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, l_318
; 54             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 55             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
l_318:
l_317:
l_315:
l_313:
l_311:
l_309:
l_307:
l_304:
	ret
; 56         }
; 57     }
; 58 }
; 59 
; 60 void CurrentViewPushCurrentId() {
currentviewpushcurrentid:
; 61     push_pop(de, hl) {
	push de
	push hl
; 62         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 63         // Add delta
; 64         d = 0;
	ld d, 0
; 65         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 66         e = a;
	ld e, a
; 67         a++;
	inc a
; 68         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 69         hl += de;
	add hl, de
; 70         // Save current ID
; 71         a = CurrentViewId;
	ld a, (currentviewid)
; 72         *hl = a;
	ld (hl), a
	pop hl
	pop de
	ret
; 73     }
; 74 }
; 75 
; 76 // Return A - ID
; 77 void CurrentViewPopId() {
currentviewpopid:
; 78     if ((a = CurrentViewReturnIdPos) > 0) {
	ld a, (currentviewreturnidpos)
	or a
	jp z, l_320
; 79         // Decriment
; 80         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 81         a--;
	dec a
; 82         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 83         //--
; 84         e = a;
	ld e, a
; 85         d = 0;
	ld d, 0
; 86         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 87         hl += de;
	add hl, de
; 88         a = *hl;
	ld a, (hl)
	jp l_321
l_320:
; 89     } else {
; 90         a = CurrentViewId;
	ld a, (currentviewid)
l_321:
	ret
; 91     }
; 92 }
; 93 
; 94 void CurrentViewReturn() {
currentviewreturn:
; 95     CurrentViewPopId();
	call currentviewpopid
; 96     CurrentViewChangeIdA();
	jp currentviewchangeida
; 97 }
; 98 
; 99 /// вых [A] 1 - если активное окно DiskView или FtpView
; 100 /// 0 - если любое другое
; 101 void CurrentViewDiskOrFtpViewByIdA() {
currentviewdiskorftpviewbyida:
; 102     push_pop(bc) {
	push bc
; 103         b = a;
	ld b, a
; 104         if ((a = b) == DiskViewId) {
	ld a, b
	cp 1
	jp nz, l_322
; 105             a = 1;
	ld a, 1
; 106             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp l_323
l_322:
; 107         } else if ((a = b) == FtpViewId) {
	ld a, b
	cp 2
	jp nz, l_324
; 108             a = 1;
	ld a, 1
; 109             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp l_325
l_324:
; 110         } else {
; 111             a = 0;
	ld a, 0
; 112             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
l_325:
l_323:
	pop bc
; 113         }
; 114     }
; 115     a =  CurrentViewDiskOrFtpViewFocus;
	ld a, (currentviewdiskorftpviewfocus)
	ret
; 116 }
; 117 
; 118 uint8_t CurrentViewDiskOrFtpViewFocus = 0;
currentviewdiskorftpviewfocus:
	db 0
; 120 uint8_t CurrentViewReturnIds[16];
currentviewreturnids:
	ds 16
; 121 uint8_t CurrentViewReturnIdPos = 0;
currentviewreturnidpos:
	db 0
; 122 uint8_t CurrentViewId = FtpViewId;
currentviewid:
	db 2
; 123 uint8_t FtpNetStateChange = 0;
ftpnetstatechange:
	db 0
; 124 uint8_t WiFiNetStateChange = 0;
wifinetstatechange:
	db 0
; 11 uint8_t StringLocaleOK[] = "Ok";
stringlocaleok:
	db 79
	db 107
	ds 1
; 12 uint8_t StringLocaleYes[] = "Yes";
stringlocaleyes:
	db 89
	db 101
	db 115
	ds 1
; 13 uint8_t StringLocaleNo[] = "No";
stringlocaleno:
	db 78
	db 111
	ds 1
; 14 uint8_t StringLocaleEraseFile[] = "Erase file";
stringlocaleerasefile:
	db 69
	db 114
	db 97
	db 115
	db 101
	db 32
	db 102
	db 105
	db 108
	db 101
	ds 1
; 15 uint8_t StringLocaleFileNotFound[] = "File not found";
stringlocalefilenotfound:
	db 70
	db 105
	db 108
	db 101
	db 32
	db 110
	db 111
	db 116
	db 32
	db 102
	db 111
	db 117
	db 110
	db 100
	ds 1
; 16 uint8_t StringLocaleFileReadOnly[] = "File read-only";
stringlocalefilereadonly:
	db 70
	db 105
	db 108
	db 101
	db 32
	db 114
	db 101
	db 97
	db 100
	db 45
	db 111
	db 110
	db 108
	db 121
	ds 1
; 17 uint8_t StringLocaleNetTimeOut[] = "Net timeout";
stringlocalenettimeout:
	db 78
	db 101
	db 116
	db 32
	db 116
	db 105
	db 109
	db 101
	db 111
	db 117
	db 116
	ds 1
; 19 uint8_t StringLocaleNetFtpDeleteFileError[] = "FTP file not delete";
stringlocalenetftpdeletefileerro:
	db 70
	db 84
	db 80
	db 32
	db 102
	db 105
	db 108
	db 101
	db 32
	db 110
	db 111
	db 116
	db 32
	db 100
	db 101
	db 108
	db 101
	db 116
	db 101
	ds 1
; 20 uint8_t StringLocaleNetFtpConnectError[] = "FTP connect error";
stringlocalenetftpconnecterror:
	db 70
	db 84
	db 80
	db 32
	db 99
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	db 32
	db 101
	db 114
	db 114
	db 111
	db 114
	ds 1
; 21 uint8_t StringLocaleNetWiFiConnectError[] = "WiFi connect error";
stringlocalenetwificonnecterror:
	db 87
	db 105
	db 70
	db 105
	db 32
	db 99
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	db 32
	db 101
	db 114
	db 114
	db 111
	db 114
	ds 1
; 14 void ButtonShadowViewShow() {
buttonshadowviewshow:
; 15     push_pop(hl) {
	push hl
; 16         h = b;
	ld h, b
; 17         l = c;
	ld l, c
; 18         ButtonShadowViewTitlePoint = hl;
	ld (buttonshadowviewtitlepoint), hl
	pop hl
; 19     }
; 20     //- SAVE -
; 21     a = h;
	ld a, h
; 22     ButtonShadowViewX = a;
	ld (buttonshadowviewx), a
; 23     //printHexA(a = ButtonShadowViewX);
; 24     a = l;
	ld a, l
; 25     ButtonShadowViewY = a;
	ld (buttonshadowviewy), a
; 26     //printHexA(a = ButtonShadowViewY);
; 27     a = d;
	ld a, d
; 28     ButtonShadowViewDX = a;
	ld (buttonshadowviewdx), a
; 29     //printHexA(a = ButtonShadowViewDX);
; 30     a = e;
	ld a, e
; 31     ButtonShadowViewDY = a;
	ld (buttonshadowviewdy), a
; 32     //printHexA(a = ButtonShadowViewDY);
; 33     //--
; 34     a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
; 35     c = a;
	ld c, a
; 36     a = vboxCLW;
	ld a, 64
; 37     a |= vboxFRM;
	or 32
; 38     a |= vboxSDW;
	or 16
; 39     a |= vboxUMP;
	or 4
; 40     vboxOpenHLDECA();
	call vboxopenhldeca
; 41     //
; 42     ButtonShadowViewShowTitleBC();
	jp buttonshadowviewshowtitlebc
; 43 }
; 44 
; 45 /// Закраска кнопки
; 46 /// 0 - прямой
; 47 /// 1 - инверсный
; 48 void ButtonShadowViewSelectA() {
buttonshadowviewselecta:
; 49     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 50         b = a;
	ld b, a
; 51         a = ButtonShadowViewX;
	ld a, (buttonshadowviewx)
; 52         h = a;
	ld h, a
; 53         a = ButtonShadowViewY;
	ld a, (buttonshadowviewy)
; 54         l = a;
	ld l, a
; 55         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 56         d = a;
	ld d, a
; 57         a = ButtonShadowViewDY;
	ld a, (buttonshadowviewdy)
; 58         e = a;
	ld e, a
; 59         //--------
; 60         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_326
; 61             a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
	jp l_327
l_326:
; 62         } else {
; 63             a = ButtonShadowViewInvColor;
	ld a, (buttonshadowviewinvcolor)
l_327:
; 64         }
; 65         c = a;
	ld c, a
; 66         //----
; 67         a = vboxFRM;
	ld a, 32
; 68         a |= vboxUMP;
	or 4
; 69         vboxOpenHLDECA();
	call vboxopenhldeca
	pop hl
	pop de
	pop bc
	ret
; 70     }
; 71 }
; 72 
; 73 void ButtonShadowViewShowTitleBC() {
buttonshadowviewshowtitlebc:
; 74     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 75         hl = ButtonShadowViewTitlePoint;
	ld hl, (buttonshadowviewtitlepoint)
; 76         b = 0;
	ld b, 0
; 77         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 78         c = a;
	ld c, a
; 79         do {
l_328:
; 80             a = *hl;
	ld a, (hl)
; 81             d = a;
	ld d, a
; 82             hl++;
	inc hl
; 83             if (a > 0) {
	or a
	jp z, l_331
; 84                 b++;
	inc b
l_331:
; 85             }
; 86             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, l_333
; 87                 d = 0;
	ld d, 0
l_333:
l_329:
; 88             }
; 89         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, l_328
; 90         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 91         a -= b;
	sub b
; 92         a &= 0xFE;
	and 254
; 93         cyclic_rotate_right(a, 1);
	rrca
; 94         b = a;
	ld b, a
; 95         a = ButtonShadowViewX;
	ld a, (buttonshadowviewx)
; 96         a += b;
	add b
; 97         myCharPosX = a;
	ld (mycharposx), a
; 98         a = ButtonShadowViewY;
	ld a, (buttonshadowviewy)
; 99         a += 1;
	add 1
; 100         myCharPosY = a;
	ld (mycharposy), a
; 101         printMyHLStr(hl = ButtonShadowViewTitlePoint);
	ld hl, (buttonshadowviewtitlepoint)
	call printmyhlstr
	pop bc
	pop de
	pop hl
	ret
; 102     }
; 103 }
; 104 
; 105 uint8_t ButtonShadowViewX = 0;
buttonshadowviewx:
	db 0
; 106 uint8_t ButtonShadowViewY = 0;
buttonshadowviewy:
	db 0
; 107 uint8_t ButtonShadowViewDX = 0;
buttonshadowviewdx:
	db 0
; 108 uint8_t ButtonShadowViewDY = 0;
buttonshadowviewdy:
	db 0
; 110 uint8_t ButtonShadowViewColor = 0xF7;
buttonshadowviewcolor:
	db 247
; 111 uint8_t ButtonShadowViewInvColor = 0xE2; //0xE6
buttonshadowviewinvcolor:
	db 226
; 113 uint16_t ButtonShadowViewTitlePoint = 0x0000;
buttonshadowviewtitlepoint:
	dw 0
; 14 void EditFieldViewShow() {
editfieldviewshow:
; 15     CurrentViewChangeAndPushIdA(a = EditFieldViewId);
	ld a, 6
	call currentviewchangeandpushida
; 16     //-- clear
; 17     a = 0;
	ld a, 0
; 18     EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 19     //-- Save
; 20     a = h;
	ld a, h
; 21     EditFieldViewX = a;
	ld (editfieldviewx), a
; 22     a = l;
	ld a, l
; 23     EditFieldViewY = a;
	ld (editfieldviewy), a
; 24     a = d;
	ld a, d
; 25     EditFieldViewDX = a;
	ld (editfieldviewdx), a
; 26     a = e;
	ld a, e
; 27     EditFieldViewDY = a;
	ld (editfieldviewdy), a
; 28     //--
; 29     push_pop(bc) {
	push bc
; 30         a = EditFieldViewColor;
	ld a, (editfieldviewcolor)
; 31         c = a;
	ld c, a
; 32         // A
; 33         a = vboxCLW
	ld a, 64
; 34         a |= vboxSAV
	or 8
; 35         a |= vboxUMP;
	or 4
; 36         vboxOpenHLDECA();
	call vboxopenhldeca
	pop bc
; 37     }
; 38     // Save text point
; 39     h = b;
	ld h, b
; 40     l = c;
	ld l, c
; 41     EditFieldViewTextPoint = hl;
	ld (editfieldviewtextpoint), hl
; 42     //-- Copy text to edit
; 43     EditFieldViewTextCopy();
	call editfieldviewtextcopy
; 44     //--
; 45     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
; 46     //--
; 47     EditFieldViewLoopKey();
	jp editfieldviewloopkey
; 48 }
; 49 
; 50 void EditFieldViewClose() {
editfieldviewclose:
; 51     vboxClose();
	call vboxclose
; 52     CurrentViewReturn();
	call currentviewreturn
; 53     a = EditFieldViewTextIsChanged;
	ld a, (editfieldviewtextischanged)
	ret
; 54 }
; 55 
; 56 void EditFieldViewLoopKey() {
editfieldviewloopkey:
; 57     push_pop(bc, de) {
	push bc
	push de
; 58         b = 0;
	ld b, 0
; 59         do {
l_335:
; 60             getKeyboardCharA();
	call getkeyboardchara
; 61             c = a;
	ld c, a
; 62             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, l_338
; 63                 b = 1;
	ld b, 1
	jp l_339
l_338:
; 64             } else if ((a = c) == 0x7F) { //Забой... (удаление символа)
	ld a, c
	cp 127
	jp nz, l_340
; 65                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 66                 if (a > 0) {
	or a
	jp z, l_342
; 67                     a--;
	dec a
; 68                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
l_342:
; 69                 }
; 70                 EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
	jp l_341
l_340:
; 71             } else if ((a = c) == 0x0D) { // Сохранить и выйти из редактирования
	ld a, c
	cp 13
	jp nz, l_344
; 72                 a = 1;
	ld a, 1
; 73                 EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 74                 EditFieldViewTextSave();
	call editfieldviewtextsave
; 75                 b = 1;
	ld b, 1
	jp l_345
l_344:
; 76             } else if ((a = c) < 0x20) { // ничего не делаем
	ld a, c
	cp 32
	jp nc, l_346
	jp l_347
l_346:
; 77                 
; 78             } else {
; 79                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 80                 if (a < 15) {
	cp 15
	jp nc, l_348
; 81                     d = 0;
	ld d, 0
; 82                     e = a;
	ld e, a
; 83                     hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 84                     hl += de;
	add hl, de
; 85                     a = c;
	ld a, c
; 86                     convertKeyToMyFontA(); // перевести данные
	call convertkeytomyfonta
; 87                     *hl = a;
	ld (hl), a
; 88                     //--
; 89                     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 90                     a++;
	inc a
; 91                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 92                     //--
; 93                     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
l_348:
l_347:
l_345:
l_341:
l_339:
l_336:
; 94                 }
; 95             }
; 96         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, l_335
	pop de
	pop bc
; 97     }
; 98     EditFieldViewClose();
	jp editfieldviewclose
; 99 }
; 100 
; 101 void EditFieldViewShowTextValue() {
editfieldviewshowtextvalue:
; 102     push_pop(bc, hl) {
	push bc
	push hl
; 103         //-- POS
; 104         a = EditFieldViewX;
	ld a, (editfieldviewx)
; 105         a += 1;
	add 1
; 106         myCharPosX = a;
	ld (mycharposx), a
; 107         a = EditFieldViewY;
	ld a, (editfieldviewy)
; 108         myCharPosY = a;
	ld (mycharposy), a
; 109         //--
; 110         a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 111         b = a;
	ld b, a
; 112         c = a;
	ld c, a
; 113         hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 114         if ((a = b) > 0) {
	ld a, b
	or a
	jp z, l_350
; 115             do {
l_352:
; 116                 printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 117                 hl++;
	inc hl
; 118                 c--;
	dec c
l_353:
; 119             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_352
l_350:
; 120         }
; 121         // Clear
; 122         a = 16; // Max char array
	ld a, 16
; 123         a -= b;
	sub b
; 124         c = a;
	ld c, a
; 125         do {
l_355:
; 126             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 127             c--;
	dec c
l_356:
; 128         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_355
	pop hl
	pop bc
	ret
; 129         
; 130     }
; 131 }
; 132 
; 133 void EditFieldViewTextCopy() {
editfieldviewtextcopy:
; 134     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 135         hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 136         de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 137         c = 1;
	ld c, 1
; 138         b = 0;
	ld b, 0
; 139         do {
l_358:
; 140             a = *hl;
	ld a, (hl)
; 141             if (a > 0) {
	or a
	jp z, l_361
; 142                 b++;
	inc b
; 143                 *de = a;
	ld (de), a
; 144                 hl++;
	inc hl
; 145                 de++;
	inc de
	jp l_362
l_361:
; 146             } else {
; 147                 a = b;
	ld a, b
; 148                 EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 149                 c = 0;
	ld c, 0
l_362:
l_359:
; 150             }
; 151         } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, l_358
	pop hl
	pop de
	pop bc
	ret
; 152     }
; 153 }
; 154 
; 155 void EditFieldViewTextSave() {
editfieldviewtextsave:
; 156     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 157     if (a == 0) {
	or a
	jp nz, l_363
; 158         push_pop(hl) {
	push hl
; 159             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 160             *hl = 0;
	ld (hl), 0
	pop hl
	jp l_364
l_363:
; 161         }
; 162     } else {
; 163         push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 164             b = a;
	ld b, a
; 165             de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 166             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 167             do {
l_365:
; 168                 a = *de;
	ld a, (de)
; 169                 *hl = a;
	ld (hl), a
; 170                 hl++;
	inc hl
; 171                 de++;
	inc de
; 172                 b--;
	dec b
l_366:
; 173             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_365
; 174             *hl = 0;
	ld (hl), 0
	pop hl
	pop de
	pop bc
l_364:
	ret
; 175         }
; 176     }
; 177 }
; 178 
; 179 uint8_t EditFieldViewX = 0;
editfieldviewx:
	db 0
; 180 uint8_t EditFieldViewY = 0;
editfieldviewy:
	db 0
; 181 uint8_t EditFieldViewDX = 0;
editfieldviewdx:
	db 0
; 182 uint8_t EditFieldViewDY = 0;
editfieldviewdy:
	db 0
; 183 uint8_t EditFieldViewColor = 0xA0; //0xF0;
editfieldviewcolor:
	db 160
; 185 uint16_t EditFieldViewTextPoint = 0;
editfieldviewtextpoint:
	dw 0
; 186 uint8_t EditFieldViewEditText[16];
editfieldviewedittext:
	ds 16
; 187 uint8_t EditFieldViewEditTextPos = 0;
editfieldviewedittextpos:
	db 0
; 189 uint8_t EditFieldViewTextIsChanged = 0;
editfieldviewtextischanged:
	db 0
; 11 void convertKeyToMyFontA() {
convertkeytomyfonta:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         c = a;
	ld c, a
; 15         if ((a = keyRusAddress) == 0) { //0 лат
	ld a, (keyrusaddress)
	or a
	jp nz, l_368
; 16             // Меняем заглавные на маленькие
; 17             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, l_370
; 18                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, l_372
; 19                     a = b;
	ld a, b
; 20                     a += 0x20;
	add 32
; 21                     c = a;
	ld c, a
l_372:
l_370:
; 22                 }
; 23             }
; 24             // Меняем маленькие на заглавные
; 25             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, l_374
; 26                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, l_376
; 27                     a = b;
	ld a, b
; 28                     a -= 0x20;
	sub 32
; 29                     c = a;
	ld c, a
l_376:
l_374:
	jp l_369
l_368:
; 30                 }
; 31             }
; 32         } else if ((a = keyRusAddress) == 0xFF) { // rus
	ld a, (keyrusaddress)
	cp 255
	jp nz, l_378
; 33             // Меняем заглавные английские на заглавные русские
; 34             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, l_380
; 35                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, l_382
; 36                     a = b;
	ld a, b
; 37                     a += 0x3F;
	add 63
; 38                     c = a;
	ld c, a
; 39                     KeyboardConverRusCharC(a = 1);
	ld a, 1
	call keyboardconverruscharc
l_382:
l_380:
; 40                 }
; 41             }
; 42             // Меняем маленькие английские на маленькие русские
; 43             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, l_384
; 44                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, l_386
; 45                     a = b;
	ld a, b
; 46                     a += 0x3F;
	add 63
; 47                     c = a;
	ld c, a
; 48                     //
; 49                     KeyboardConverRusCharC(a = 0);
	ld a, 0
	call keyboardconverruscharc
; 50                     // если больше "п" то + 30
; 51                     if ((a = c) >= 0xB0) {
	ld a, c
	cp 176
	jp c, l_388
; 52                         a = c;
	ld a, c
; 53                         a += 0x30;
	add 48
; 54                         c = a;
	ld c, a
l_388:
l_386:
l_384:
; 55                     }
; 56                 }
; 57             }
; 58             // Ю
; 59             d = 0x40;
	ld d, 64
; 60             e = 0x60;
	ld e, 96
; 61             KeyboardBOrDOrE();
	call keyboardbordore
; 62             if (a == 1) {
	cp 1
	jp nz, l_390
; 63                 a = b;
	ld a, b
; 64                 a += 0x5E;
	add 94
; 65                 c = a;
	ld c, a
l_390:
; 66             }
; 67             // Э
; 68             d = 0x5C;
	ld d, 92
; 69             e = 0x7C;
	ld e, 124
; 70             KeyboardBOrDOrE();
	call keyboardbordore
; 71             if (a == 1) {
	cp 1
	jp nz, l_392
; 72                 a = b;
	ld a, b
; 73                 a += 0x41;
	add 65
; 74                 c = a;
	ld c, a
l_392:
; 75             }
; 76             // Ч
; 77             d = 0x5E;
	ld d, 94
; 78             e = 0x7E;
	ld e, 126
; 79             KeyboardBOrDOrE();
	call keyboardbordore
; 80             if (a == 1) {
	cp 1
	jp nz, l_394
; 81                 a = b;
	ld a, b
; 82                 a += 0x39;
	add 57
; 83                 c = a;
	ld c, a
l_394:
; 84             }
; 85             // Ш
; 86             d = 0x5B;
	ld d, 91
; 87             e = 0x7B;
	ld e, 123
; 88             KeyboardBOrDOrE();
	call keyboardbordore
; 89             if (a == 1) {
	cp 1
	jp nz, l_396
; 90                 a = b;
	ld a, b
; 91                 a += 0x3D;
	add 61
; 92                 c = a;
	ld c, a
l_396:
; 93             }
; 94             // Щ
; 95             d = 0x5D;
	ld d, 93
; 96             e = 0x7D;
	ld e, 125
; 97             KeyboardBOrDOrE();
	call keyboardbordore
; 98             if (a == 1) {
	cp 1
	jp nz, l_398
; 99                 a = b;
	ld a, b
; 100                 a += 0x3C;
	add 60
; 101                 c = a;
	ld c, a
l_398:
; 102             }
; 103             if ((a = c) >= 0xB0) {
	ld a, c
	cp 176
	jp c, l_400
; 104                 if ((a = c) < 0xC0) {
	ld a, c
	cp 192
	jp nc, l_402
; 105                     a = c;
	ld a, c
; 106                     a += 0x30;
	add 48
; 107                     c = a;
	ld c, a
l_402:
l_400:
	jp l_379
l_378:
; 108                 }
; 109             }
; 110         } else {
l_379:
l_369:
; 111             
; 112         }
; 113         a = c;
	ld a, c
	pop bc
	ret
; 114     }
; 115 }
; 116 
; 117 void KeyboardBOrDOrE() {
keyboardbordore:
; 118     push_pop(hl) {
	push hl
; 119         if ((a = b) == d) {
	ld a, b
	cp d
	jp nz, l_404
; 120             h = 1;
	ld h, 1
	jp l_405
l_404:
; 121         } else if ((a = b) == e) {
	ld a, b
	cp e
	jp nz, l_406
; 122             h = 1;
	ld h, 1
	jp l_407
l_406:
; 123         } else {
; 124             h = 0;
	ld h, 0
l_407:
l_405:
; 125         }
; 126         a = h;
	ld a, h
	pop hl
	ret
; 127     }
; 128 }
; 129 
; 130 /// A - 0 происная, 1 - заглавная
; 131 /// C - Символ
; 132 void KeyboardConverRusCharC() {
keyboardconverruscharc:
; 133     push_pop(hl, de) {
	push hl
	push de
; 134         if (a == 0) {
	or a
	jp nz, l_408
; 135             a = c;
	ld a, c
; 136             a -= 0xA0;
	sub 160
; 137             e = a;
	ld e, a
	jp l_409
l_408:
; 138         } else {
; 139             a = c;
	ld a, c
; 140             a -= 0x80;
	sub 128
; 141             e = a;
	ld e, a
l_409:
; 142         }
; 143         d = 0;
	ld d, 0
; 144         hl = KeyboardRusCharConver;
	ld hl, keyboardruscharconver
; 145         hl += de;
	add hl, de
; 146         a = *hl;
	ld a, (hl)
; 147         a += c;
	add c
; 148         c = a;
	ld c, a
	pop de
	pop hl
	ret
; 149     }
; 150 }
; 151 
; 152 uint8_t KeyboardRusCharConver[32] = {
keyboardruscharconver:
	db 0
	db 0
	db 20
	db 1
	db 1
	db 15
	db 253
	db 14
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 15
	db 255
	db 255
	db 255
	db 255
	db 241
	db 236
	db 5
	db 3
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 11 void ThreadsTickNow() {
threadsticknow:
; 12     a = 101;
	ld a, 101
; 13     ThreadsTickCount = a;
	ld (threadstickcount), a
	ret
; 14 }
; 15 
; 16 void ThreadsTick() {
threadstick:
; 17     #ifdef _IS_SIMULATOR
; 18         
; 19     #else
; 20     if ((a = ThreadsTickCount) >= 50) { //50
	ld a, (threadstickcount)
	cp 50
	jp c, l_410
; 21         a = 0;
	ld a, 0
; 22         ThreadsTickCount = a;
	ld (threadstickcount), a
; 23         //--
; 24         ThreadsNetUpdateState();
	call threadsnetupdatestate
	jp l_411
l_410:
; 25     } else {
; 26         ThreadsTickCountNext();
	call threadstickcountnext
l_411:
	ret
; 27     }
; 28     #endif
; 29 }
; 30 
; 31 void ThreadsNetUpdateState() {
threadsnetupdatestate:
; 32     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 33     if (a == 1) {
	cp 1
	jp nz, l_412
; 34         NetGetAllStatus();
	call netgetallstatus
; 35         ThreadsNetNeedStateChange();
	call threadsnetneedstatechange
l_412:
	ret
; 36     }
; 37 }
; 38 
; 39 void ThreadsNetNeedStateChange() {
threadsnetneedstatechange:
; 40     if ((a = WiFiNetStateChange) == 1) {
	ld a, (wifinetstatechange)
	cp 1
	jp nz, l_414
; 41         ThreadsNetNeedUpdateWiFiData();
	call threadsnetneedupdatewifidata
; 42         a = 0;
	ld a, 0
; 43         WiFiNetStateChange = a;
	ld (wifinetstatechange), a
l_414:
; 44     }
; 45     if ((a = FtpNetStateChange) == 1) {
	ld a, (ftpnetstatechange)
	cp 1
	jp nz, l_416
; 46         ThreadsNetNeedUpdateFtpData();
	call threadsnetneedupdateftpdata
; 47         a = 0;
	ld a, 0
; 48         FtpNetStateChange = a;
	ld (ftpnetstatechange), a
l_416:
	ret
; 49     }
; 50 }
; 51 
; 52 void ThreadsTickCountNext() {
threadstickcountnext:
; 53     push_pop(hl) {
	push hl
; 54         hl = ThreadsTickSubCount;
	ld hl, (threadsticksubcount)
; 55         // Compare hl == 0
; 56         a = h;
	ld a, h
; 57         a |= l;
	or l
; 58         if (a == 0) {
	or a
	jp nz, l_418
; 59             //-- TickCount ++
; 60             a = ThreadsTickCount;
	ld a, (threadstickcount)
; 61             a++;
	inc a
; 62             ThreadsTickCount = a;
	ld (threadstickcount), a
; 63             //-- TickSubCount = max
; 64             hl = 0x100; //0x800; //0x1000; //0x300;
	ld hl, 256
	jp l_419
l_418:
; 65         } else {
; 66             hl--;
	dec hl
l_419:
; 67         }
; 68         ThreadsTickSubCount = hl;
	ld (threadsticksubcount), hl
	pop hl
	ret
; 69     }
; 70 }
; 71 
; 72 void delay50ms() {
delay50ms:
; 73     push_pop(bc) {
	push bc
; 74         bc = 0xFFFF;
	ld bc, 65535
; 75         do {
l_420:
; 76             bc--;
	dec bc
; 77             a = b;
	ld a, b
; 78             a |= c;
	or c
l_421:
	jp nz, l_420
	pop bc
	ret
; 79         } while (flag_nz);
; 80     }
; 81 }
; 82 
; 83 void NetUpdateData() {
netupdatedata:
; 84     ThreadsNetNeedUpdateFtpValue();
	call threadsnetneedupdateftpvalue
; 85     ThreadsNetNeedUpdateWiFiValue();
	jp threadsnetneedupdatewifivalue
; 86 }
; 87 
; 88 // ----------------------------------
; 89 // ------------ WiFi ----------------
; 90 // ----------------------------------
; 91 void ThreadsNetNeedUpdateWiFiData() {
threadsnetneedupdatewifidata:
; 92     NetWiFiGetSsidIp();
	call netwifigetssidip
; 93     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 94 }
; 95 
; 96 void ThreadsNetPasswordUpdate() {
threadsnetpasswordupdate:
; 97     NetWiFiSetSsidPassword();
	call netwifisetssidpassword
; 98     nop();
	nop
; 99     NetWiFiGetSsidPassword();
	call netwifigetssidpassword
; 100     nop();
	nop
	ret
; 101 }
; 102 
; 103 void ThreadsNetNeedUpdateWiFiValue() {
threadsnetneedupdatewifivalue:
; 104     NetWiFiGetSsidIp();
	call netwifigetssidip
; 105     NetWiFiGetSsidMac();
	call netwifigetssidmac
; 106     NetWiFiGetSsid();
	call netwifigetssid
; 107     NetWiFiGetSsidPassword();
	call netwifigetssidpassword
; 108     // UI
; 109     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 110 }
; 111 
; 112 void ThreadsNetSsidUpdateA() {
threadsnetssidupdatea:
; 113     NetWiFiSetListA();
	call netwifisetlista
; 114     NetWiFiGetSsid();
	call netwifigetssid
; 115     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 116 }
; 117 
; 118 void ThreadsNetSetWiFiStateA() {
threadsnetsetwifistatea:
; 119     push_pop(bc) {
	push bc
; 120         a &= 0x01;
	and 1
; 121         b = a;
	ld b, a
; 122         // Old Value
; 123         a = WiFiSettingsViewSSIDIsConnected;
	ld a, (wifisettingsviewssidisconnected)
; 124         c = a;
	ld c, a
; 125         // --
; 126         a = b;
	ld a, b
; 127         WiFiSettingsViewSSIDIsConnected = a;
	ld (wifisettingsviewssidisconnected), a
; 128         if(a != c){
	cp c
	jp z, l_423
; 129             a = 0x01;
	ld a, 1
; 130             WiFiNetStateChange = a;
	ld (wifinetstatechange), a
l_423:
	pop bc
	ret
; 131         }
; 132     }
; 133 }
; 134 
; 135 // ----------------------------------
; 136 // ------------ Ftp  ----------------
; 137 // ----------------------------------
; 138 void ThreadsNetNeedUpdateFtpData() {
threadsnetneedupdateftpdata:
; 139     FtpStateViewShowValue();
	call ftpstateviewshowvalue
; 140     // Update ftp dir
; 141     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 142     FtpViewShowPath();
	call ftpviewshowpath
; 143     //
; 144     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 145     if (a == 1) {
	cp 1
	jp nz, l_425
; 146         if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_427
; 147             NetFtpUpdateList();
	call netftpupdatelist
; 148             NetFtpListFiles();
	call netftplistfiles
	jp l_428
l_427:
; 149         } else {
; 150             FtpViewEmptyList();
	call ftpviewemptylist
l_428:
; 151         }
; 152         FtpViewListUpdateUI();
	call ftpviewlistupdateui
l_425:
	ret
; 153     }
; 154 }
; 155 
; 156 void ThreadsNetNeedUpdateFtpValue() {
threadsnetneedupdateftpvalue:
; 157     NetFtpGetUrl();
	call netftpgeturl
; 158     NetFtpGetHomeDir();
	call netftpgethomedir
; 159     NetFtpGetPort();
	call netftpgetport
; 160     NetFtpGetUser();
	call netftpgetuser
; 161     NetFtpGetPassword();
	call netftpgetpassword
; 162     // UI
; 163     FtpStateViewShowValue();
	jp ftpstateviewshowvalue
; 164 }
; 165 
; 166 void ThreadsNetFtpHomeDirUpdate() {
threadsnetftphomedirupdate:
; 167     NetFtpSetHomeDir();
	call netftpsethomedir
; 168     NetFtpGetHomeDir();
	jp netftpgethomedir
; 169 }
; 170 
; 171 void ThreadsNetFtpUserUpdate() {
threadsnetftpuserupdate:
; 172     NetFtpSetUser();
	call netftpsetuser
; 173     NetFtpGetUser();
	jp netftpgetuser
; 174 }
; 175 
; 176 void ThreadsNetFtpPasswordUpdate() {
threadsnetftppasswordupdate:
; 177     NetFtpSetPassword();
	call netftpsetpassword
; 178     NetFtpGetPassword();
	jp netftpgetpassword
; 179 }
; 180 
; 181 void ThreadsNetFtpServerUrlUpdate() {
threadsnetftpserverurlupdate:
; 182     NetFtpSetUrl();
	call netftpseturl
; 183     NetFtpGetUrl();
	jp netftpgeturl
; 184 }
; 185 
; 186 void ThreadsNetFtpPortUpdate() {
threadsnetftpportupdate:
; 187     NetFtpSetPort();
	call netftpsetport
; 188     NetFtpGetPort();
	jp netftpgetport
; 189 }
; 190 
; 191 void ThreadsNetFtpGoToHomeDir() {
threadsnetftpgotohomedir:
; 192     NetFtpGoToHomeDir();
	call netftpgotohomedir
; 193     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 194     FtpViewShowPath();
	call ftpviewshowpath
; 195     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_429
; 196         NetFtpUpdateList();
	call netftpupdatelist
; 197         NetFtpListFiles();
	call netftplistfiles
	jp l_430
l_429:
; 198     } else {
; 199         FtpViewEmptyList();
	call ftpviewemptylist
l_430:
; 200     }
; 201     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 202 }
; 203 
; 204 void ThreadsNetFtpDeleteFileA() {
threadsnetftpdeletefilea:
; 205     NetFtpDeleteFileIndexA();
	call netftpdeletefileindexa
; 206     NetFtpUpdateList();
	call netftpupdatelist
; 207     NetFtpListFiles();
	call netftplistfiles
; 208     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 209 }
; 210 
; 211 void ThreadsNetSetFtpStateA() {
threadsnetsetftpstatea:
; 212     push_pop(bc) {
	push bc
; 213         a &= 0x01;
	and 1
; 214         b = a;
	ld b, a
; 215         // Old Value
; 216         a = FtpStateViewStatus;
	ld a, (ftpstateviewstatus)
; 217         c = a;
	ld c, a
; 218         // --
; 219         a = b;
	ld a, b
; 220         FtpStateViewStatus = a;
	ld (ftpstateviewstatus), a
; 221         if(a != c){
	cp c
	jp z, l_431
; 222             a = 0x01;
	ld a, 1
; 223             FtpNetStateChange = a;
	ld (ftpnetstatechange), a
l_431:
	pop bc
	ret
; 224         }
; 225     }
; 226 }
; 227 
; 228 void ThreadsNetDetectError() {
threadsnetdetecterror:
; 229     push_pop(bc, hl) {
	push bc
	push hl
; 230         if ((a = ESPError) > 0) {
	ld a, (esperror)
	or a
	jp z, l_433
; 231             b = a;
	ld b, a
; 232             // Clear error
; 233             a = 0;
	ld a, 0
; 234             ESPError = a;
	ld (esperror), a
; 235             //-- ENUM
; 236             if ((a = b) == ESPError_TimeOut) {
	ld a, b
	cp 1
	jp nz, l_435
; 237                 AllertOkViewShowHL(hl = StringLocaleNetTimeOut);
	ld hl, stringlocalenettimeout
	call allertokviewshowhl
l_435:
l_433:
	pop hl
	pop bc
	ret
; 238             }
; 239         }
; 240     }
; 241 }
; 242 
; 243 uint16_t ThreadsTickSubCount = 0x0000;
threadsticksubcount:
	dw 0
; 244 uint8_t ThreadsTickCount = 0;
threadstickcount:
	db 0
; 11 void WifiStateViewShow() {
wifistateviewshow:
; 12     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 13         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 14         h = a;
	ld h, a
; 15         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 16         l = a;
	ld l, a
; 17         a = WifiStateViewDX;
	ld a, (wifistateviewdx)
; 18         d = a;
	ld d, a
; 19         a = WifiStateViewDY;
	ld a, (wifistateviewdy)
; 20         e = a;
	ld e, a
; 21         a = WifiStateViewColor;
	ld a, (wifistateviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         WifiStateViewShowTitle();
	call wifistateviewshowtitle
; 25         WifiStateViewShowValue();
	call wifistateviewshowvalue
	pop bc
	pop de
	pop hl
	ret
; 26     }
; 27 }
; 28 
; 29 void WifiStateViewShowTitle() {
wifistateviewshowtitle:
; 30     push_pop(hl, bc) {
	push hl
	push bc
; 31         //Title
; 32         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 33         b = a;
	ld b, a
; 34         a = WifiStateViewDX;
	ld a, (wifistateviewdx)
; 35         a += b;
	add b
; 36         a -= 8; //len Title
	sub 8
; 37         myCharPosX = a;
	ld (mycharposx), a
; 38         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 39         myCharPosY = a;
	ld (mycharposy), a
; 40         printMyHLStr(hl = WifiStateViewTitle);
	ld hl, wifistateviewtitle
	call printmyhlstr
; 41         //SSID
; 42         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 43         a++;
	inc a
; 44         myCharPosX = a;
	ld (mycharposx), a
; 45         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 46         a++;
	inc a
; 47         myCharPosY = a;
	ld (mycharposy), a
; 48         printMyHLStr(hl = WiFiSettingsViewTitleSSID);
	ld hl, wifisettingsviewtitlessid
	call printmyhlstr
; 49         //IP
; 50         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 51         a++;
	inc a
; 52         myCharPosX = a;
	ld (mycharposx), a
; 53         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 54         a++;
	inc a
; 55         a++;
	inc a
; 56         myCharPosY = a;
	ld (mycharposy), a
; 57         printMyHLStr(hl = WifiStateViewTitleIP);
	ld hl, wifistateviewtitleip
	call printmyhlstr
	pop bc
	pop hl
	ret
; 58     }
; 59 }
; 60 
; 61 
; 62 
; 63 void WifiStateViewShowValue() {
wifistateviewshowvalue:
; 64     // SSID
; 65     a = WifiStateViewX;
	ld a, (wifistateviewx)
; 66     a += 7;
	add 7
; 67     myCharPosX = a;
	ld (mycharposx), a
; 68     a = WifiStateViewY;
	ld a, (wifistateviewy)
; 69     a += 1;
	add 1
; 70     myCharPosY = a;
	ld (mycharposy), a
; 71     a = 16;
	ld a, 16
; 72     printMyHLStrLenA(hl = WiFiSettingsViewSsidValue);
	ld hl, wifisettingsviewssidvalue
	call printmyhlstrlena
; 73     // IP
; 74     a = WifiStateViewX;
	ld a, (wifistateviewx)
; 75     a += 7;
	add 7
; 76     myCharPosX = a;
	ld (mycharposx), a
; 77     a = WifiStateViewY;
	ld a, (wifistateviewy)
; 78     a += 2;
	add 2
; 79     myCharPosY = a;
	ld (mycharposy), a
; 80     a = 16;
	ld a, 16
; 81     printMyHLStrLenA(hl = WiFiSettingsViewIpValue);
	ld hl, wifisettingsviewipvalue
	jp printmyhlstrlena
; 82 }
; 83 
; 84 uint8_t WifiStateViewX = 24;
wifistateviewx:
	db 24
; 85 uint8_t WifiStateViewY = 0;
wifistateviewy:
	db 0
; 86 uint8_t WifiStateViewDX = 24;
wifistateviewdx:
	db 24
; 87 uint8_t WifiStateViewDY = 4;
wifistateviewdy:
	db 4
; 91 uint8_t WifiStateViewColor = 0x5f; //0x67;
wifistateviewcolor:
	db 95
; 94 uint8_t WifiStateViewTitleIP[] =   "IP  : ";
wifistateviewtitleip:
	db 73
	db 80
	db 32
	db 32
	db 58
	db 32
	ds 1
; 95 uint8_t WifiStateViewTitle[] = {0xB5, 'W', 'i', '-', 'F', 'i', 0xC6, '\0'};
wifistateviewtitle:
	db 181
	db 87
	db 105
	db 45
	db 70
	db 105
	db 198
	db 0
; 11 void DiskViewShow() {
diskviewshow:
; 12     a = DiskViewX;
	ld a, (diskviewx)
; 13     h = a;
	ld h, a
; 14     a = DiskViewY;
	ld a, (diskviewy)
; 15     l = a;
	ld l, a
; 16     a = DiskViewDX;
	ld a, (diskviewdx)
; 17     d = a;
	ld d, a
; 18     a = DiskViewDY;
	ld a, (diskviewdy)
; 19     e = a;
	ld e, a
; 20     a = DiskViewColor;
	ld a, (diskviewcolor)
; 21     vboxOpenHLDE();
	call vboxopenhlde
; 22     vboxBorderHLDE();
	call vboxborderhlde
; 23     DiskViewShowTitle();
	call diskviewshowtitle
; 24     
; 25     //DEBUG!!!
; 26     DiskViewSetDiskNumA(a = 'B');
	ld a, 66
	jp diskviewsetdisknuma
; 27 }
; 28 
; 29 void DiskViewShowTitle() {
diskviewshowtitle:
; 30     a = DiskViewX;
	ld a, (diskviewx)
; 31     a++;
	inc a
; 32     myCharPosX = a;
	ld (mycharposx), a
; 33     a = DiskViewY;
	ld a, (diskviewy)
; 34     myCharPosY = a;
	ld (mycharposy), a
; 35     printMyHLStr(hl = DiskViewTitle);
	ld hl, diskviewtitle
	jp printmyhlstr
; 36 }
; 37 
; 38 void DiskViewUpdateDir() {
diskviewupdatedir:
; 39     push_pop(hl) {
	push hl
; 40         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 41         ordos_wnd();
	call ordos_wnd
; 42         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 43         ordos_dirm();
	call ordos_dirm
; 44         DiskViewDirCount = a;
	ld (diskviewdircount), a
	pop hl
	ret
; 45     }
; 46 }
; 47 
; 48 void DiskViewShowDir() {
diskviewshowdir:
; 49     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 50         //-----
; 51         a = DiskViewX;
	ld a, (diskviewx)
; 52         a += 2;
	add 2
; 53         d = a; // X
	ld d, a
; 54         a = DiskViewY;
	ld a, (diskviewy)
; 55         a += 3;
	add 3
; 56         e = a; // Y
	ld e, a
; 57         //-----
; 58         a = d;
	ld a, d
; 59         myCharPosX = a;
	ld (mycharposx), a
; 60         a = e;
	ld a, e
; 61         a--;
	dec a
; 62         myCharPosY = a;
	ld (mycharposy), a
; 63         printMyHLStr(hl = DiskViewDirRootTitle);
	ld hl, diskviewdirroottitle
	call printmyhlstr
; 64         //-----
; 65         if ((a = DiskViewDirCount) >= 1) {
	ld a, (diskviewdircount)
	or a
	jp z, l_437
; 66             hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 67             b = 0;
	ld b, 0
; 68             do {
l_439:
; 69                 a = d;
	ld a, d
; 70                 myCharPosX = a;
	ld (mycharposx), a
; 71                 a = e;
	ld a, e
; 72                 a += b;
	add b
; 73                 myCharPosY = a;
	ld (mycharposy), a
; 74                 c = 8;
	ld c, 8
; 75                 do {
l_442:
; 76                     printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 77                     hl++;
	inc hl
; 78                     c--;
	dec c
l_443:
; 79                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_442
; 80                 hl++;
	inc hl
; 81                 hl++;
	inc hl
; 82                 hl++;
	inc hl
; 83                 hl++;
	inc hl
; 84                 hl++;
	inc hl
; 85                 hl++;
	inc hl
; 86                 hl++;
	inc hl
; 87                 hl++;
	inc hl
; 88                 b++;
	inc b
; 89                 a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 90                 a--;
	dec a
l_440:
; 91             } while (a >= b);
	cp b
	jp nc, l_439
l_437:
; 92         }
; 93         // show empty rows
; 94         a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 95         b = a;
	ld b, a
; 96         // PosY
; 97         a = e;
	ld a, e
; 98         a += b;
	add b
; 99         e = a;
	ld e, a
; 100         //
; 101         a = DiskViewDY;
	ld a, (diskviewdy)
; 102         a -= 4;
	sub 4
; 103         a -= b;
	sub b
; 104         b = a;
	ld b, a
; 105         c = 0;
	ld c, 0
; 106         do {
l_445:
; 107             a = d;
	ld a, d
; 108             myCharPosX = a;
	ld (mycharposx), a
; 109             a = e;
	ld a, e
; 110             a += c;
	add c
; 111             myCharPosY = a;
	ld (mycharposy), a
; 112             //
; 113             a = DiskViewDX;
	ld a, (diskviewdx)
; 114             a -= 3;
	sub 3
; 115             h = a;
	ld h, a
; 116             do {
l_448:
; 117                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 118                 h--;
	dec h
l_449:
; 119             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, l_448
; 120             b--;
	dec b
; 121             c++;
	inc c
l_446:
; 122         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_445
	pop de
	pop bc
	pop hl
	ret
; 123     }
; 124 }
; 125 
; 126 void DiskViewDeleteSelectedFile() {
diskviewdeleteselectedfile:
; 127     push_pop(hl, bc) {
	push hl
	push bc
; 128         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 129         ordos_wnd();
	call ordos_wnd
; 130         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 131         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 132         a -= 1; // Удалить корневой переход на другой диск
	sub 1
; 133         b = 0;
	ld b, 0
; 134         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 135         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_451
; 136             b++;
	inc b
l_451:
; 137         }
; 138         c = a;
	ld c, a
; 139         hl += bc;
	add hl, bc
; 140         push_pop(hl) { // Проставляем 0 в конце строки
	push hl
; 141             bc = 7;
	ld bc, 7
; 142             hl += bc;
	add hl, bc
; 143             b = 7;
	ld b, 7
; 144             do {
l_453:
; 145                 a = *hl;
	ld a, (hl)
; 146                 if (a == 0x20) {
	cp 32
	jp nz, l_456
; 147                     a = 0;
	ld a, 0
; 148                     *hl = a;
	ld (hl), a
	jp l_457
l_456:
; 149                 } else {
; 150                     b = 1;
	ld b, 1
l_457:
; 151                 }
; 152                 hl--;
	dec hl
; 153                 b--;
	dec b
l_454:
; 154             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_453
	pop hl
; 155         }
; 156         ordos_sdma();
	call ordos_sdma
; 157         ordos_eras();
	call ordos_eras
; 158         //а = 1 - нет файла
; 159         //а = 4 - файл 'r/o'
; 160         b = a;
	ld b, a
; 161         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_458
; 162             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 163             a = 0;
	ld a, 0
; 164             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 165             DiskViewUpdateDateAndUI();
	call diskviewupdatedateandui
; 166             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp l_459
l_458:
; 167         } else if ((a = b) == 1) { // нет файла
	ld a, b
	cp 1
	jp nz, l_460
; 168             AllertOkViewShowHL(hl = StringLocaleFileNotFound);
	ld hl, stringlocalefilenotfound
	call allertokviewshowhl
	jp l_461
l_460:
; 169         } else if ((a = b) == 4) { // файл 'r/o'
	ld a, b
	cp 4
	jp nz, l_462
; 170             AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
	ld hl, stringlocalefilereadonly
	call allertokviewshowhl
	jp l_463
l_462:
; 171         } else if ((a = b) == 0x41) { // Диск A
	ld a, b
	cp 65
	jp nz, l_464
; 172             AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
	ld hl, stringlocalefilereadonly
	call allertokviewshowhl
	jp l_465
l_464:
; 173         } else {
l_465:
l_463:
l_461:
l_459:
	pop bc
	pop hl
	ret
; 174             //printMyHexA(a = b);
; 175         }
; 176     }
; 177 }
; 178 
; 179 void DiskViewUploadSelectedFile() {
diskviewuploadselectedfile:
; 180     push_pop(hl, bc) {
	push hl
	push bc
; 181         // Open progress view
; 182         LoadViewShowHL(hl = LoadViewUploadTitle);
	ld hl, loadviewuploadtitle
	call loadviewshowhl
; 183         LoadViewShowProgressA(a = 0);
	ld a, 0
	call loadviewshowprogressa
; 184         //-- create point File
; 185         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 186         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 187         a -= 1; // Удалить корневой переход на другой диск
	sub 1
; 188         b = 0;
	ld b, 0
; 189         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 190         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_466
; 191             b++;
	inc b
l_466:
; 192         }
; 193         c = a;
	ld c, a
; 194         hl += bc;
	add hl, bc
; 195         push_pop(hl) { // Проставляем 0 в конце строки
	push hl
; 196             bc = 7;
	ld bc, 7
; 197             hl += bc;
	add hl, bc
; 198             b = 7;
	ld b, 7
; 199             do {
l_468:
; 200                 a = *hl;
	ld a, (hl)
; 201                 if (a == 0x20) {
	cp 32
	jp nz, l_471
; 202                     a = 0;
	ld a, 0
; 203                     *hl = a;
	ld (hl), a
	jp l_472
l_471:
; 204                 } else {
; 205                     b = 1;
	ld b, 1
l_472:
; 206                 }
; 207                 hl--;
	dec hl
; 208                 b--;
	dec b
l_469:
; 209             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_468
	pop hl
; 210         }
; 211         // NET
; 212         NetFtpUploadFileInitHL();
	call netftpuploadfileinithl
; 213         // Close progress
; 214         LoadViewClose();
	call loadviewclose
	pop bc
	pop hl
	ret
; 215     }
; 216 }
; 217 
; 218 void DiskViewKeyA() {
diskviewkeya:
; 219     push_pop(hl) {
	push hl
; 220         l = a;
	ld l, a
; 221         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_473
; 222             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, l_475
; 223                 CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
	jp l_476
l_475:
; 224             } else {
; 225                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_477
; 226                     DiskViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call diskviewfilecurrentposupdatea
	jp l_478
l_477:
; 227                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_479
; 228                     DiskViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call diskviewfilecurrentposupdatea
	jp l_480
l_479:
; 229                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, l_481
; 230                     if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
	ld a, (diskviewfilecurrentpos)
	or a
	jp nz, l_483
; 231                         DiskViewNextDiskNum();
	call diskviewnextdisknum
	jp l_484
l_483:
; 232                     } else { // Закачка на FTP
l_484:
	jp l_482
l_481:
; 233                         
; 234                     }
; 235                 } else if ((a = l) == 'E') {
	ld a, l
	cp 69
	jp nz, l_485
; 236                     if ((a = DiskViewFileCurrentPos) > 0) {
	ld a, (diskviewfilecurrentpos)
	or a
	jp z, l_487
; 237                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 238                         if (a == 1) {
	cp 1
	jp nz, l_489
; 239                             DiskViewDeleteSelectedFile();
	call diskviewdeleteselectedfile
l_489:
l_487:
	jp l_486
l_485:
; 240                         }
; 241                     }
; 242                 } else if ((a = l) == 'D') { //  Показать выбор диска
	ld a, l
	cp 68
	jp nz, l_491
; 243                     SelectDiskViewShow();
	call selectdiskviewshow
	jp l_492
l_491:
; 244                 } else if ((a = l) == 'C') { // Загрузка файла на FTP
	ld a, l
	cp 67
	jp nz, l_493
; 245                     DiskViewUploadSelectedFile();
	call diskviewuploadselectedfile
; 246                     FtpViewNetLoadAndUpdate(); // обновляем список файлов FTP
	call ftpviewnetloadandupdate
l_493:
l_492:
l_486:
l_482:
l_480:
l_478:
l_476:
l_473:
	pop hl
	ret
; 247                 }
; 248             }
; 249         }
; 250     }
; 251 }
; 252 
; 253 void DiskViewNextDiskNum() {
diskviewnextdisknum:
; 254     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 255     a++;
	inc a
; 256     if (a == 'E') {
	cp 69
	jp nz, l_495
; 257         a = 'A';
	ld a, 65
l_495:
; 258     }
; 259     DiskViewSetDiskNumA();
; 260 }
; 261 
; 262 void DiskViewSetDiskNumA() {
diskviewsetdisknuma:
; 263     DiskViewDiskNum = a;
	ld (diskviewdisknum), a
; 264     DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 265     a = 0;
	ld a, 0
; 266     DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 267     DiskViewUpdateDiskTitle();
	call diskviewupdatedisktitle
; 268     DiskViewUpdateDateAndUI();
; 269 }
; 270 
; 271 void DiskViewUpdateDateAndUI() {
diskviewupdatedateandui:
; 272     DiskViewUpdateDir();
	call diskviewupdatedir
; 273     DiskViewShowDir();
	call diskviewshowdir
; 274     if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_497
; 275         DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
l_497:
	ret
; 276     }
; 277 }
; 278 
; 279 void DiskViewUpdateDiskTitle() {
diskviewupdatedisktitle:
; 280     a = DiskViewX;
	ld a, (diskviewx)
; 281     a += 7;
	add 7
; 282     myCharPosX = a;
	ld (mycharposx), a
; 283     a = DiskViewY;
	ld a, (diskviewy)
; 284     myCharPosY = a;
	ld (mycharposy), a
; 285     printMyCharA(a = DiskViewDiskNum);
	ld a, (diskviewdisknum)
	jp printmychara
; 286 }
; 287 
; 288 /// Обновление позиции
; 289 /// вх[A]
; 290 /// 0 - без изменений
; 291 /// 1 - вверх
; 292 /// 0xFF - вниз
; 293 void DiskViewFileCurrentPosUpdateA() {
diskviewfilecurrentposupdatea:
; 294     push_pop(bc) {
	push bc
; 295         b = a;
	ld b, a
; 296         if (a == 0) {
	or a
	jp nz, l_499
; 297             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp l_500
l_499:
; 298         } else {
; 299             a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 300             a += 1;
	add 1
; 301             c = a;
	ld c, a
; 302             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 303             a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 304             a += b;
	add b
; 305             //
; 306             if (a == 0xFF) {
	cp 255
	jp nz, l_501
; 307                 a = c;
	ld a, c
; 308                 a--;
	dec a
	jp l_502
l_501:
; 309             } else if (a == c) {
	cp c
	jp nz, l_503
; 310                 a = 0;
	ld a, 0
l_503:
l_502:
; 311             }
; 312             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 313             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
l_500:
	pop bc
	ret
; 314         }
; 315     }
; 316 }
; 317 
; 318 /// Рисование линии прямым или инверсным цветом
; 319 /// 0 - прямой
; 320 /// 1 - инверсный
; 321 void DiskViewShowSelectLineA() {
diskviewshowselectlinea:
; 322     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 323         c = a;
	ld c, a
; 324         // HL
; 325         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 326         b = a;
	ld b, a
; 327         a = DiskViewY;
	ld a, (diskviewy)
; 328         a += 2;
	add 2
; 329         a += b;
	add b
; 330         l = a;
	ld l, a
; 331         a = DiskViewX;
	ld a, (diskviewx)
; 332         a += 1;
	add 1
; 333         h = a;
	ld h, a
; 334         // DE
; 335         a = DiskViewDX;
	ld a, (diskviewdx)
; 336         a -= 2;
	sub 2
; 337         d = a;
	ld d, a
; 338         a = 1;
	ld a, 1
; 339         e = a;
	ld e, a
; 340         // C
; 341         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_505
; 342             a = DiskViewColor;
	ld a, (diskviewcolor)
	jp l_506
l_505:
; 343         } else {
; 344             a = DiskViewInvColor;
	ld a, (diskviewinvcolor)
l_506:
; 345         }
; 346         c = a;
	ld c, a
; 347         // A
; 348         a = vboxUMP;
	ld a, 4
; 349         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 350     }
; 351 }
; 352 
; 353 uint8_t DiskViewX = 28;
diskviewx:
	db 28
; 354 uint8_t DiskViewY = 4;
diskviewy:
	db 4
; 355 uint8_t DiskViewDX = 20;
diskviewdx:
	db 20
; 356 uint8_t DiskViewDY = 25;
diskviewdy:
	db 25
; 357 uint8_t DiskViewColor = 0x1F;
diskviewcolor:
	db 31
; 358 uint8_t DiskViewInvColor = 0xF1;
diskviewinvcolor:
	db 241
; 360 uint8_t DiskViewDiskNum = 'B';
diskviewdisknum:
	db 66
; 361 uint8_t DiskViewDirCount = 0;
diskviewdircount:
	db 0
; 362 uint16_t DiskViewDirBufer = 0x0000;
diskviewdirbufer:
	dw 0
; 363 uint8_t DiskViewFileCurrentPos = 0;
diskviewfilecurrentpos:
	db 0
; 365 uint16_t DiskViewStartNewFile = 0x0000;
diskviewstartnewfile:
	dw 0
; 367 uint8_t DiskViewDirRootTitle[] = "..";
diskviewdirroottitle:
	db 46
	db 46
	ds 1
; 368 uint8_t DiskViewTitle[] = {0xB5, 'D', 'i', 's', 'k', ':', 'A', 0xC6, '\0'};
diskviewtitle:
	db 181
	db 68
	db 105
	db 115
	db 107
	db 58
	db 65
	db 198
	db 0
; 11 void SelectDiskViewShow() {
selectdiskviewshow:
; 12     CurrentViewChangeAndPushIdA(a = SelectDiskViewId);
	ld a, 3
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 15         h = a;
	ld h, a
; 16         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 17         l = a;
	ld l, a
; 18         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 19         d = a;
	ld d, a
; 20         a = SelectDiskViewDY;
	ld a, (selectdiskviewdy)
; 21         e = a;
	ld e, a
; 22         a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
; 30         
; 31         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 32         a -= 'A';
	sub 65
; 33         SelectDiskViewCurrentPos = a;
	ld (selectdiskviewcurrentpos), a
; 34         
; 35         SelectDiskViewShowDiskList();
	call selectdiskviewshowdisklist
; 36         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop de
	pop hl
	pop bc
	ret
; 37     }
; 38 }
; 39 
; 40 void SelectDiskViewShowDiskList() {
selectdiskviewshowdisklist:
; 41     push_pop(bc) {
	push bc
; 42         // Title
; 43         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 44         a += 1;
	add 1
; 45         myCharPosY = a;
	ld (mycharposy), a
; 46         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 47         a += 4;
	add 4
; 48         myCharPosX = a;
	ld (mycharposx), a
; 49         printMyHLStr(hl = SelectDiskViewSelectTitle);
	ld hl, selectdiskviewselecttitle
	call printmyhlstr
; 50         // SubTitle
; 51         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 52         a += 2;
	add 2
; 53         myCharPosY = a;
	ld (mycharposy), a
; 54         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 55         a += 4;
	add 4
; 56         myCharPosX = a;
	ld (mycharposx), a
; 57         printMyHLStr(hl = SelectDiskViewSelectSubTitle);
	ld hl, selectdiskviewselectsubtitle
	call printmyhlstr
; 58         // LINE!!!
; 59         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 60         a += 1;
	add 1
; 61         myCharPosX = a;
	ld (mycharposx), a
; 62         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 63         a += 3;
	add 3
; 64         myCharPosY = a;
	ld (mycharposy), a
; 65         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 66         a -= 2;
	sub 2
; 67         b = a;
	ld b, a
; 68         do {
l_507:
; 69             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 70             b--;
	dec b
l_508:
; 71         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_507
; 72         // Disk List
; 73         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 74         a += 6;
	add 6
; 75         myCharPosY = a;
	ld (mycharposy), a
; 76         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 77         a += 2;
	add 2
; 78         myCharPosX = a;
	ld (mycharposx), a
; 79         b = 0;
	ld b, 0
; 80         do {
l_510:
; 81             a = b;
	ld a, b
; 82             a += 'A';
	add 65
; 83             printMyCharA();
	call printmychara
; 84             myCharPosXSpaceA(a = 2);
	ld a, 2
	call mycharposxspacea
; 85             b++;
	inc b
l_511:
; 86         } while ((a = b) < 4);
	ld a, b
	cp 4
	jp c, l_510
	pop bc
	ret
; 87     }
; 88 }
; 89 
; 90 /// 0 - прямой
; 91 /// 1 - инверсный
; 92 void SelectDiskViewUpdateSelectA() {
selectdiskviewupdateselecta:
; 93     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 94         c = a;
	ld c, a
; 95         // HL
; 96         a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 97         b = a;
	ld b, a
; 98         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 99         a += 1;
	add 1
; 100         h = a;
	ld h, a
; 101         if ((a = b) > 0) {
	ld a, b
	or a
	jp z, l_513
; 102             do {
l_515:
; 103                 a = h;
	ld a, h
; 104                 a += 3;
	add 3
; 105                 h = a;
	ld h, a
; 106                 b--;
	dec b
l_516:
; 107             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_515
l_513:
; 108         }
; 109         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 110         a += 5;
	add 5
; 111         l = a;
	ld l, a
; 112         // DE
; 113         a = 3;
	ld a, 3
; 114         d = a;
	ld d, a
; 115         a = 3;
	ld a, 3
; 116         e = a;
	ld e, a
; 117         // C
; 118         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_518
; 119             a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
	jp l_519
l_518:
; 120         } else {
; 121             a = SelectDiskViewInvColor;
	ld a, (selectdiskviewinvcolor)
l_519:
; 122         }
; 123         c = a;
	ld c, a
; 124         // A
; 125         a = vboxUMP;
	ld a, 4
; 126         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 127     }
; 128 }
; 129 
; 130 void SelectDiskViewSetCurrentPosA() {
selectdiskviewsetcurrentposa:
; 131     push_pop(bc) {
	push bc
; 132         b = a;
	ld b, a
; 133         SelectDiskViewUpdateSelectA(a = 0);
	ld a, 0
	call selectdiskviewupdateselecta
; 134         a = b;
	ld a, b
; 135         SelectDiskViewCurrentPos = a;
	ld (selectdiskviewcurrentpos), a
; 136         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop bc
	ret
; 137     }
; 138 }
; 139 
; 140 void SelectDiskViewKeyA() {
selectdiskviewkeya:
; 141     push_pop(hl) {
	push hl
; 142         l = a;
	ld l, a
; 143         if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_520
; 144             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_522
; 145                 vboxClose();
	call vboxclose
; 146                 CurrentViewReturn();
	call currentviewreturn
	jp l_523
l_522:
; 147             } else if ((a = l) == 0x0D) { // Выбор диска
	ld a, l
	cp 13
	jp nz, l_524
; 148                 vboxClose();
	call vboxclose
; 149                 CurrentViewReturn();
	call currentviewreturn
; 150                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 151                 a += 'A';
	add 65
; 152                 DiskViewSetDiskNumA();
	call diskviewsetdisknuma
	jp l_525
l_524:
; 153             } else if ((a = l) == 0x18) { // Вправл
	ld a, l
	cp 24
	jp nz, l_526
; 154                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 155                 a++;
	inc a
; 156                 if (a == 4) {
	cp 4
	jp nz, l_528
; 157                     a = 0;
	ld a, 0
l_528:
; 158                 }
; 159                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
	jp l_527
l_526:
; 160             } else if ((a = l) == 0x08) { // Влево
	ld a, l
	cp 8
	jp nz, l_530
; 161                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 162                 if (a == 0) {
	or a
	jp nz, l_532
; 163                     a = 3;
	ld a, 3
	jp l_533
l_532:
; 164                 } else {
; 165                     a--;
	dec a
l_533:
; 166                 }
; 167                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
l_530:
l_527:
l_525:
l_523:
l_520:
	pop hl
	ret
; 168             }
; 169         }
; 170     }
; 171 }
; 172 
; 173 uint8_t SelectDiskViewX = 17;
selectdiskviewx:
	db 17
; 174 uint8_t SelectDiskViewY = 12;
selectdiskviewy:
	db 12
; 175 uint8_t SelectDiskViewDX = 14;
selectdiskviewdx:
	db 14
; 176 uint8_t SelectDiskViewDY = 9;
selectdiskviewdy:
	db 9
; 177 uint8_t SelectDiskViewColor = 0x70; //0x1F;
selectdiskviewcolor:
	db 112
; 178 uint8_t SelectDiskViewInvColor = 0x20; //0x2E;
selectdiskviewinvcolor:
	db 32
; 180 uint8_t SelectDiskViewCurrentPos = 0;
selectdiskviewcurrentpos:
	db 0
; 182 uint8_t SelectDiskViewSelectTitle[7] = "Choose";
selectdiskviewselecttitle:
	db 67
	db 104
	db 111
	db 111
	db 115
	db 101
	ds 1
; 183 uint8_t SelectDiskViewSelectSubTitle[7] = "drive:";
selectdiskviewselectsubtitle:
	db 100
	db 114
	db 105
	db 118
	db 101
	db 58
	ds 1
; 11 void FtpStateViewShow() {
ftpstateviewshow:
; 12     push_pop(hl, de) {
	push hl
	push de
; 13         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 14         h = a;
	ld h, a
; 15         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 16         l = a;
	ld l, a
; 17         a = FtpStateViewDX;
	ld a, (ftpstateviewdx)
; 18         d = a;
	ld d, a
; 19         a = FtpStateViewDY;
	ld a, (ftpstateviewdy)
; 20         e = a;
	ld e, a
; 21         a = FtpStateViewColor;
	ld a, (ftpstateviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         FtpStateViewShowTitle();
	call ftpstateviewshowtitle
; 25         FtpStateViewShowValue();
	call ftpstateviewshowvalue
	pop de
	pop hl
	ret
; 26     }
; 27 }
; 28 
; 29 void FtpStateViewShowTitle() {
ftpstateviewshowtitle:
; 30     push_pop(hl, bc) {
	push hl
	push bc
; 31         // TITLE
; 32         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 33         b = a;
	ld b, a
; 34         a = FtpStateViewDX;
	ld a, (ftpstateviewdx)
; 35         a += b;
	add b
; 36         a -= 6; //len Title
	sub 6
; 37         myCharPosX = a;
	ld (mycharposx), a
; 38         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 39         myCharPosY = a;
	ld (mycharposy), a
; 40         printMyHLStr(hl = FtpViewTitle);
	ld hl, ftpviewtitle
	call printmyhlstr
; 41         // IP
; 42         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 43         a += 1;
	add 1
; 44         myCharPosX = a;
	ld (mycharposx), a
; 45         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 46         a += 1;
	add 1
; 47         myCharPosY = a;
	ld (mycharposy), a
; 48         printMyHLStr(hl = FtpStateViewIpTitle);
	ld hl, ftpstateviewiptitle
	call printmyhlstr
; 49         // STATUS
; 50         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 51         a += 1;
	add 1
; 52         myCharPosX = a;
	ld (mycharposx), a
; 53         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 54         a += 2;
	add 2
; 55         myCharPosY = a;
	ld (mycharposy), a
; 56         printMyHLStr(hl = FtpStateViewStateTitle);
	ld hl, ftpstateviewstatetitle
	call printmyhlstr
	pop bc
	pop hl
	ret
; 57     }
; 58 }
; 59 
; 60 void FtpStateViewShowValue() {
ftpstateviewshowvalue:
; 61     push_pop(hl) {
	push hl
; 62         //IP
; 63         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 64         a += 5;
	add 5
; 65         myCharPosX = a;
	ld (mycharposx), a
; 66         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 67         a += 1;
	add 1
; 68         myCharPosY = a;
	ld (mycharposy), a
; 69         a = 16;
	ld a, 16
; 70         printMyHLStrLenA(hl = FtpStateViewIpValue);
	ld hl, ftpstateviewipvalue
	call printmyhlstrlena
; 71         // STATUS
; 72         FtpStateViewShowStatus();
	call ftpstateviewshowstatus
	pop hl
	ret
; 73     }
; 74 }
; 75 
; 76 void FtpStateViewShowStatus() {
ftpstateviewshowstatus:
; 77     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 78         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_534
; 79             hl = FtpStateViewStatus0;
	ld hl, ftpstateviewstatus0
; 80             a = FtpStateViewColor;
	ld a, (ftpstateviewcolor)
; 81             c = a;
	ld c, a
	jp l_535
l_534:
; 82         } else {
; 83             hl = FtpStateViewStatus1;
	ld hl, ftpstateviewstatus1
; 84             a = FtpStateViewConnectColor;
	ld a, (ftpstateviewconnectcolor)
; 85             c = a;
	ld c, a
l_535:
; 86         }
; 87         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 88         a += 9;
	add 9
; 89         d = a; // X
	ld d, a
; 90         myCharPosX = a;
	ld (mycharposx), a
; 91         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 92         a += 2;
	add 2
; 93         e = a; // Y
	ld e, a
; 94         myCharPosY = a;
	ld (mycharposy), a
; 95         printMyHLStrLenA(a = 14);
	ld a, 14
	call printmyhlstrlena
; 96         //COLOR BOX
; 97         h = d;
	ld h, d
; 98         l = e;
	ld l, e
; 99         d = 14;
	ld d, 14
; 100         e = 1;        
	ld e, 1
; 101         a = 0;
	ld a, 0
; 102         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop bc
	pop hl
	ret
; 103     }
; 104 }
; 105 
; 106 uint8_t FtpStateViewX = 0;
ftpstateviewx:
	db 0
; 107 uint8_t FtpStateViewY = 0;
ftpstateviewy:
	db 0
; 108 uint8_t FtpStateViewDX = 24;
ftpstateviewdx:
	db 24
; 109 uint8_t FtpStateViewDY = 4;
ftpstateviewdy:
	db 4
; 114 uint8_t FtpStateViewColor = 0x5f; //0x67; 07
ftpstateviewcolor:
	db 95
; 115 uint8_t FtpStateViewConnectColor = 0x52;
ftpstateviewconnectcolor:
	db 82
; 118 uint8_t FtpStateViewIpTitle[] =    "IP:";
ftpstateviewiptitle:
	db 73
	db 80
	db 58
	ds 1
; 119 uint8_t FtpStateViewStateTitle[] = "Status:";
ftpstateviewstatetitle:
	db 83
	db 116
	db 97
	db 116
	db 117
	db 115
	db 58
	ds 1
; 120 uint8_t FtpStateViewIpValue[16] = "0.0.0.0";
ftpstateviewipvalue:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 122 uint8_t FtpStateViewStatus = 0;
ftpstateviewstatus:
	db 0
; 123 uint8_t FtpStateViewStatus0[] = "DISCONNECT"; //a = 14
ftpstateviewstatus0:
	db 68
	db 73
	db 83
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	ds 1
; 124 uint8_t FtpStateViewStatus1[] = "CONNECT"; //a = 14
ftpstateviewstatus1:
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	ds 1
; 11 void FtpSettingsViewShow() {
ftpsettingsviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         CurrentViewChangeAndPushIdA(a = FtpSettingsViewId);
	ld a, 8
	call currentviewchangeandpushida
; 14         //--
; 15         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 16         h = a;
	ld h, a
; 17         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 18         l = a;
	ld l, a
; 19         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 20         d = a;
	ld d, a
; 21         a = FtpSettingsViewDY;
	ld a, (ftpsettingsviewdy)
; 22         e = a;
	ld e, a
; 23         a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
; 24         c = a;
	ld c, a
; 25         a = vboxCLW;
	ld a, 64
; 26         a |= vboxFRM;
	or 32
; 27         a |= vboxSDW;
	or 16
; 28         a |= vboxSAV;
	or 8
; 29         a |= vboxUMP;
	or 4
; 30         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 31     }
; 32     a = 0;
	ld a, 0
; 33     FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 34     FtpSettingsViewShowTitle();
	call ftpsettingsviewshowtitle
; 35     FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
; 36     FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp ftpsettingsviewselectlinea
; 37 }
; 38 
; 39 void FtpSettingsViewClose() {
ftpsettingsviewclose:
; 40     vboxClose();
	call vboxclose
; 41     CurrentViewReturn();
	jp currentviewreturn
; 42 }
; 43 
; 44 void FtpSettingsViewShowTitle() {
ftpsettingsviewshowtitle:
; 45     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 46         // Title
; 47         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 48         a += 7;
	add 7
; 49         myCharPosX = a;
	ld (mycharposx), a
; 50         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 51         a += 1; //2;
	add 1
; 52         myCharPosY = a;
	ld (mycharposy), a
; 53         printMyHLStr(hl = FtpSettingsViewTitle);
	ld hl, ftpsettingsviewtitle
	call printmyhlstr
; 54         // LINE!!!
; 55         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 56         a += 1;
	add 1
; 57         myCharPosX = a;
	ld (mycharposx), a
; 58         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 59         a += 2;
	add 2
; 60         myCharPosY = a;
	ld (mycharposy), a
; 61         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 62         a -= 2;
	sub 2
; 63         b = a;
	ld b, a
; 64         do {
l_536:
; 65             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 66             b--;
	dec b
l_537:
; 67         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_536
; 68         // IP
; 69         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 70         a += 2;
	add 2
; 71         b = a; // X
	ld b, a
; 72         myCharPosX = a;
	ld (mycharposx), a
; 73         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 74         a += 4;
	add 4
; 75         c = a; // Y
	ld c, a
; 76         myCharPosY = a;
	ld (mycharposy), a
; 77         printMyHLStr(hl = FtpSettingsViewTitleIP);
	ld hl, ftpsettingsviewtitleip
	call printmyhlstr
; 78         // PORT
; 79         a = b;
	ld a, b
; 80         myCharPosX = a;
	ld (mycharposx), a
; 81         a = c;
	ld a, c
; 82         a += 1;
	add 1
; 83         myCharPosY = a;
	ld (mycharposy), a
; 84         printMyHLStr(hl = FtpSettingsViewTitlePort);
	ld hl, ftpsettingsviewtitleport
	call printmyhlstr
; 85         // USER
; 86         a = b;
	ld a, b
; 87         myCharPosX = a;
	ld (mycharposx), a
; 88         a = c;
	ld a, c
; 89         a += 2;
	add 2
; 90         myCharPosY = a;
	ld (mycharposy), a
; 91         printMyHLStr(hl = FtpSettingsViewTitleUser);
	ld hl, ftpsettingsviewtitleuser
	call printmyhlstr
; 92         // PASS
; 93         a = b;
	ld a, b
; 94         myCharPosX = a;
	ld (mycharposx), a
; 95         a = c;
	ld a, c
; 96         a += 3;
	add 3
; 97         myCharPosY = a;
	ld (mycharposy), a
; 98         printMyHLStr(hl = WiFiSettingsViewTitlePass);
	ld hl, wifisettingsviewtitlepass
	call printmyhlstr
; 99         // HOME dir
; 100         a = b;
	ld a, b
; 101         myCharPosX = a;
	ld (mycharposx), a
; 102         a = c;
	ld a, c
; 103         a += 4;
	add 4
; 104         myCharPosY = a;
	ld (mycharposy), a
; 105         printMyHLStr(hl = FtpSettingsViewTitleHomeDir);
	ld hl, ftpsettingsviewtitlehomedir
	call printmyhlstr
; 106         // Button
; 107         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_539
; 108             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp l_540
l_539:
; 109         } else {
; 110             bc = StringLocaleOK;
	ld bc, stringlocaleok
l_540:
; 111         }
; 112         
; 113         d = 13;
	ld d, 13
; 114         e = 3;
	ld e, 3
; 115         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 116         a += 7;
	add 7
; 117         h = a;
	ld h, a
; 118         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 119         a += 10;
	add 10
; 120         l = a;
	ld l, a
; 121         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 122     }
; 123 }
; 124 
; 125 void FtpSettingsViewShowValue() {
ftpsettingsviewshowvalue:
; 126     push_pop(hl, bc) {
	push hl
	push bc
; 127         // IP
; 128         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 129         a += 8;
	add 8
; 130         b = a; // X
	ld b, a
; 131         myCharPosX = a;
	ld (mycharposx), a
; 132         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 133         a += 4;
	add 4
; 134         c = a; // Y
	ld c, a
; 135         myCharPosY = a;
	ld (mycharposy), a
; 136         a = 18;
	ld a, 18
; 137         printMyHLStrLenA(hl = FtpStateViewIpValue);
	ld hl, ftpstateviewipvalue
	call printmyhlstrlena
; 138         // PORT
; 139         a = b;
	ld a, b
; 140         myCharPosX = a;
	ld (mycharposx), a
; 141         a = c;
	ld a, c
; 142         a += 1;
	add 1
; 143         myCharPosY = a;
	ld (mycharposy), a
; 144         a = 18;
	ld a, 18
; 145         printMyHLStrLenA(hl = FtpSettingsViewValuePort);
	ld hl, ftpsettingsviewvalueport
	call printmyhlstrlena
; 146         // USER
; 147         a = b;
	ld a, b
; 148         myCharPosX = a;
	ld (mycharposx), a
; 149         a = c;
	ld a, c
; 150         a += 2;
	add 2
; 151         myCharPosY = a;
	ld (mycharposy), a
; 152         a = 18;
	ld a, 18
; 153         printMyHLStrLenA(hl = FtpSettingsViewValueUser);
	ld hl, ftpsettingsviewvalueuser
	call printmyhlstrlena
; 154         // PASS
; 155         a = b;
	ld a, b
; 156         myCharPosX = a;
	ld (mycharposx), a
; 157         a = c;
	ld a, c
; 158         a += 3;
	add 3
; 159         myCharPosY = a;
	ld (mycharposy), a
; 160         a = 18;
	ld a, 18
; 161         printMyHLPassLenA(hl = FtpSettingsViewValuePass);
	ld hl, ftpsettingsviewvaluepass
	call printmyhlpasslena
; 162         // HOME DIR
; 163         a = b;
	ld a, b
; 164         myCharPosX = a;
	ld (mycharposx), a
; 165         a = c;
	ld a, c
; 166         a += 4;
	add 4
; 167         myCharPosY = a;
	ld (mycharposy), a
; 168         a = 18;
	ld a, 18
; 169         printMyHLStrLenA(hl = FtpSettingsViewValueHomeDir);
	ld hl, ftpsettingsviewvaluehomedir
	call printmyhlstrlena
	pop bc
	pop hl
	ret
; 170     }
; 171 }
; 172 
; 173 /// вых [BC] -
; 174 void FtpSettingsViewByPosValue() {
ftpsettingsviewbyposvalue:
; 175     if ((a = FtpSettingsViewSelectPos) == 1) {
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, l_541
; 176         bc = FtpStateViewIpValue;
	ld bc, ftpstateviewipvalue
	jp l_542
l_541:
; 177     } else if ((a = FtpSettingsViewSelectPos) == 2) {
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, l_543
; 178         bc = FtpSettingsViewValuePort;
	ld bc, ftpsettingsviewvalueport
	jp l_544
l_543:
; 179     } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, l_545
; 180         bc = FtpSettingsViewValueUser;
	ld bc, ftpsettingsviewvalueuser
	jp l_546
l_545:
; 181     } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, l_547
; 182         bc = FtpSettingsViewValuePass;
	ld bc, ftpsettingsviewvaluepass
	jp l_548
l_547:
; 183     } else if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, l_549
; 184         bc = FtpSettingsViewValueHomeDir;
	ld bc, ftpsettingsviewvaluehomedir
	jp l_550
l_549:
; 185     } else {
; 186         bc = 0;
	ld bc, 0
l_550:
l_548:
l_546:
l_544:
l_542:
	ret
; 187     }
; 188 }
; 189 
; 190 /// вых [HL] -
; 191 /// вых [DE]-
; 192 void FtpSettingsViewByPosBoxValue() {
ftpsettingsviewbyposboxvalue:
; 193     push_pop(bc) {
	push bc
; 194         // HL
; 195         a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 196         b = a;
	ld b, a
; 197         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 198         a += 3;
	add 3
; 199         a += b;
	add b
; 200         l = a;
	ld l, a
; 201         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 202         a += 7;
	add 7
; 203         h = a;
	ld h, a
; 204         // DE
; 205         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 206         a -= 8;
	sub 8
; 207         d = a;
	ld d, a
; 208         a = 1;
	ld a, 1
; 209         e = a;
	ld e, a
	pop bc
	ret
; 210     }
; 211 }
; 212 
; 213 /// Обновление позиции
; 214 /// вх[A]
; 215 /// 0 - без изменений
; 216 /// 1 - вверх
; 217 /// 0xFF - вниз
; 218 void FtpSettingsViewPosUpdateA() {
ftpsettingsviewposupdatea:
; 219     push_pop(bc) {
	push bc
; 220         b = a;
	ld b, a
; 221         if (a == 0) {
	or a
	jp nz, l_551
; 222             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
	jp l_552
l_551:
; 223         } else {
; 224             a = 6;
	ld a, 6
; 225             c = a;
	ld c, a
; 226             FtpSettingsViewSelectLineA(a = 0);
	ld a, 0
	call ftpsettingsviewselectlinea
; 227             a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 228             a += b;
	add b
; 229             b = a;
	ld b, a
; 230             //-- FIX
; 231             if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, l_553
; 232                 a = c;
	ld a, c
; 233                 a--;
	dec a
	jp l_554
l_553:
; 234             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, l_555
; 235                 a = 0;
	ld a, 0
l_555:
l_554:
; 236             }
; 237             //--
; 238             FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 239             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
l_552:
	pop bc
	ret
; 240         }
; 241     }
; 242 }
; 243 
; 244 /// Рисование линии прямым или инверсным цветом
; 245 /// 0 - прямой
; 246 /// 1 - инверсный
; 247 void FtpSettingsViewSelectLineA() {
ftpsettingsviewselectlinea:
; 248     push_pop(bc, hl) {
	push bc
	push hl
; 249         c = a;
	ld c, a
; 250         // 0 - Button
; 251         if ((a = FtpSettingsViewSelectPos) == 0) {
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, l_557
; 252             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp l_558
l_557:
; 253         } else {
; 254             FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 255             // C
; 256             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_559
; 257                 a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
	jp l_560
l_559:
; 258             } else {
; 259                 a = FtpSettingsViewInvColor;
	ld a, (ftpsettingsviewinvcolor)
l_560:
; 260             }
; 261             c = a;
	ld c, a
; 262             // A
; 263             a = vboxUMP;
	ld a, 4
; 264             vboxOpenHLDECA();
	call vboxopenhldeca
l_558:
	pop hl
	pop bc
	ret
; 265         }
; 266     }
; 267 }
; 268 
; 269 void FtpSettingsViewKeyA() {
ftpsettingsviewkeya:
; 270     push_pop(hl) {
	push hl
; 271         l = a;
	ld l, a
; 272         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_561
; 273             if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_563
; 274                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_565
; 275                     FtpSettingsViewClose();
	call ftpsettingsviewclose
	jp l_566
l_565:
; 276                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_567
; 277                     if ((a = FtpSettingsViewSelectPos) == 0) { // OK
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, l_569
; 278                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 279                         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_571
; 280                             NetFtpConnect();
	call netftpconnect
; 281                             ThreadsTickNow();
	call threadsticknow
l_571:
	jp l_570
l_569:
; 282                         }
; 283                     } else { // Переход в редактирование
; 284                         FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 285                         FtpSettingsViewByPosValue();
	call ftpsettingsviewbyposvalue
; 286                         EditFieldViewShow();
	call editfieldviewshow
; 287                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, l_573
; 288                             if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, l_575
; 289                                 ThreadsNetFtpHomeDirUpdate();
	call threadsnetftphomedirupdate
	jp l_576
l_575:
; 290                             } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, l_577
; 291                                 ThreadsNetFtpUserUpdate();
	call threadsnetftpuserupdate
	jp l_578
l_577:
; 292                             } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, l_579
; 293                                 ThreadsNetFtpPasswordUpdate();
	call threadsnetftppasswordupdate
	jp l_580
l_579:
; 294                             } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, l_581
; 295                                 ThreadsNetFtpServerUrlUpdate();
	call threadsnetftpserverurlupdate
; 296                                 FtpStateViewShowValue();
	call ftpstateviewshowvalue
	jp l_582
l_581:
; 297                             } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, l_583
; 298                                 ThreadsNetFtpPortUpdate();
	call threadsnetftpportupdate
l_583:
l_582:
l_580:
l_578:
l_576:
; 299                             }
; 300                             FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
l_573:
l_570:
	jp l_568
l_567:
; 301                         }
; 302                     }
; 303                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_585
; 304                     FtpSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call ftpsettingsviewposupdatea
	jp l_586
l_585:
; 305                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_587
; 306                     FtpSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpsettingsviewposupdatea
l_587:
l_586:
l_568:
l_566:
l_563:
l_561:
	pop hl
	ret
; 307                 }
; 308             }
; 309         }
; 310     }
; 311 }
; 312 
; 313 uint8_t FtpSettingsViewX = 11;
ftpsettingsviewx:
	db 11
; 314 uint8_t FtpSettingsViewY = 9;
ftpsettingsviewy:
	db 9
; 315 uint8_t FtpSettingsViewDX = 27;
ftpsettingsviewdx:
	db 27
; 316 uint8_t FtpSettingsViewDY = 15;
ftpsettingsviewdy:
	db 15
; 317 uint8_t FtpSettingsViewColor = 0x70;
ftpsettingsviewcolor:
	db 112
; 318 uint8_t FtpSettingsViewInvColor = 0x07;
ftpsettingsviewinvcolor:
	db 7
; 320 uint8_t FtpSettingsViewSelectPos = 1; //0
ftpsettingsviewselectpos:
	db 1
; 322 uint8_t FtpSettingsViewTitle[] = "FTP settings";
ftpsettingsviewtitle:
	db 70
	db 84
	db 80
	db 32
	db 115
	db 101
	db 116
	db 116
	db 105
	db 110
	db 103
	db 115
	ds 1
; 323 uint8_t FtpSettingsViewTitleIP[] =      "  IP:";
ftpsettingsviewtitleip:
	db 32
	db 32
	db 73
	db 80
	db 58
	ds 1
; 324 uint8_t FtpSettingsViewTitlePort[] =    "Port:";
ftpsettingsviewtitleport:
	db 80
	db 111
	db 114
	db 116
	db 58
	ds 1
; 325 uint8_t FtpSettingsViewTitleHomeDir[] = "Home:";
ftpsettingsviewtitlehomedir:
	db 72
	db 111
	db 109
	db 101
	db 58
	ds 1
; 326 uint8_t FtpSettingsViewTitleUser[] = "User:";
ftpsettingsviewtitleuser:
	db 85
	db 115
	db 101
	db 114
	db 58
	ds 1
; 328 uint8_t FtpSettingsViewValuePort[16] = "21";
ftpsettingsviewvalueport:
	db 50
	db 49
	ds 14
; 329 uint8_t FtpSettingsViewValueUser[16] = "-";
ftpsettingsviewvalueuser:
	db 45
	ds 15
; 330 uint8_t FtpSettingsViewValuePass[16] = "-";
ftpsettingsviewvaluepass:
	db 45
	ds 15
; 331 uint8_t FtpSettingsViewValueHomeDir[16] = "/";
ftpsettingsviewvaluehomedir:
	db 47
	ds 15
; 11 void FtpViewShow() {
ftpviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         a = FtpViewX;
	ld a, (ftpviewx)
; 14         h = a;
	ld h, a
; 15         a = FtpViewY;
	ld a, (ftpviewy)
; 16         l = a;
	ld l, a
; 17         a = FtpViewDX;
	ld a, (ftpviewdx)
; 18         d = a;
	ld d, a
; 19         a = FtpViewDY;
	ld a, (ftpviewdy)
; 20         e = a;
	ld e, a
; 21         a = FtpViewColor;
	ld a, (ftpviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         FtpViewShowTitle();
	call ftpviewshowtitle
; 25         
; 26         #ifdef _IS_SIMULATOR
; 27             FtpViewShowFileList();
; 28             FtpViewShowPath();
; 29             a = 0;
; 30             FtpViewFileCurrentPos = a;
; 31             FtpViewShowSelectLineA(a = 1);
; 32         #else
; 33             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	pop de
	pop hl
	pop bc
	ret
; 34         #endif
; 35     }
; 36 }
; 37 
; 38 void FtpViewShowTitle() {
ftpviewshowtitle:
; 39     a = FtpViewX;
	ld a, (ftpviewx)
; 40     a++;
	inc a
; 41     myCharPosX = a;
	ld (mycharposx), a
; 42     a = FtpViewY;
	ld a, (ftpviewy)
; 43     myCharPosY = a;
	ld (mycharposy), a
; 44     printMyHLStr(hl = FtpViewTitle);
	ld hl, ftpviewtitle
	jp printmyhlstr
; 45 }
; 46 
; 47 void FtpViewShowFileList() {
ftpviewshowfilelist:
; 48     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 49         b = 0;
	ld b, 0
; 50         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 51         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 52         c = a;
	ld c, a
; 53         do {
l_589:
; 54             a = FtpViewY;
	ld a, (ftpviewy)
; 55             a += 2;
	add 2
; 56             a += b;
	add b
; 57             myCharPosY = a;
	ld (mycharposy), a
; 58             FtpViewShowFileHL();
	call ftpviewshowfilehl
; 59             // HL + 16 next file
; 60             a = 16;
	ld a, 16
; 61             a += l;
	add l
; 62             l = a;
	ld l, a
; 63             if (flag_c) {
	jp nc, l_592
; 64                 h++;
	inc h
l_592:
; 65             }
; 66             b++;
	inc b
l_590:
; 67         } while ((a = b) < c);
	ld a, b
	cp c
	jp c, l_589
; 68         // Заполнить пустыми строками
; 69         a = FtpViewX;
	ld a, (ftpviewx)
; 70         a += 1;
	add 1
; 71         d = a; // X
	ld d, a
; 72         a = FtpViewY;
	ld a, (ftpviewy)
; 73         a += 2;
	add 2
; 74         e = a; // Y
	ld e, a
; 75         //--
; 76         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 77         b = a;
	ld b, a
; 78         // PosY
; 79         a = e;
	ld a, e
; 80         a += b;
	add b
; 81         e = a;
	ld e, a
; 82         //
; 83         a = FtpViewDY;
	ld a, (ftpviewdy)
; 84         a -= 4;
	sub 4
; 85         a -= b;
	sub b
; 86         b = a;
	ld b, a
; 87         c = 0;
	ld c, 0
; 88         do {
l_594:
; 89             a = d;
	ld a, d
; 90             myCharPosX = a;
	ld (mycharposx), a
; 91             a = e;
	ld a, e
; 92             a += c;
	add c
; 93             myCharPosY = a;
	ld (mycharposy), a
; 94             //
; 95             a = FtpViewDX;
	ld a, (ftpviewdx)
; 96             a -= 3;
	sub 3
; 97             h = a;
	ld h, a
; 98             do {
l_597:
; 99                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 100                 h--;
	dec h
l_598:
; 101             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, l_597
; 102             b--;
	dec b
; 103             c++;
	inc c
l_595:
; 104         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_594
	pop hl
	pop de
	pop bc
	ret
; 105     }
; 106 }
; 107 
; 108 void FtpViewShowFileHL() {
ftpviewshowfilehl:
; 109     push_pop(bc, hl) {
	push bc
	push hl
; 110         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_600
; 111             FtpViewShowFileName();
	call ftpviewshowfilename
	jp l_601
l_600:
; 112         } else {
; 113             FtpViewShowFileName();
	call ftpviewshowfilename
; 114             FtpViewShowFileSize();
	call ftpviewshowfilesize
; 115             FtpViewShowFileDate();
	call ftpviewshowfiledate
l_601:
	pop hl
	pop bc
	ret
; 116         }
; 117     }
; 118 }
; 119 
; 120 // A = 1 - Dir
; 121 void FtpViewShowIsDirA() {
ftpviewshowisdira:
; 122     push_pop(bc) {
	push bc
; 123         a &= 0x01;
	and 1
; 124         b = a;
	ld b, a
; 125         a = FtpViewX;
	ld a, (ftpviewx)
; 126         a += 1;
	add 1
; 127         myCharPosX = a;
	ld (mycharposx), a
; 128         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_602
; 129             printMyCharA(a = 0x1F); //0x10
	ld a, 31
	call printmychara
	jp l_603
l_602:
; 130         } else {
; 131             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
l_603:
	pop bc
	ret
; 132         }
; 133     }
; 134 }
; 135 
; 136 void FtpViewShowFileName() {
ftpviewshowfilename:
; 137     // X pos
; 138     a = FtpViewX;
	ld a, (ftpviewx)
; 139     a += 2;
	add 2
; 140     myCharPosX = a;
	ld (mycharposx), a
; 141     //
; 142     b = 8;
	ld b, 8
; 143     do {
l_604:
; 144         printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 145         hl++;
	inc hl
; 146         b--;
	dec b
l_605:
; 147     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_604
	ret
; 148 }
; 149 
; 150 void FtpViewShowFileSize() {
ftpviewshowfilesize:
; 151     push_pop(bc, de) {
	push bc
	push de
; 152         // X pos
; 153         a = FtpViewX;
	ld a, (ftpviewx)
; 154         a += 11;
	add 11
; 155         myCharPosX = a;
	ld (mycharposx), a
; 156         //
; 157         a = *hl;
	ld a, (hl)
; 158         d = a;
	ld d, a
; 159         hl++;
	inc hl
; 160         a = *hl;
	ld a, (hl)
; 161         e = a;
	ld e, a
; 162         hl++;
	inc hl
; 163         a = *hl;
	ld a, (hl)
; 164         hl++;
	inc hl
; 165         a &= 0x01;
	and 1
; 166         if (a == 0x00) {
	or a
	jp nz, l_607
; 167             push_pop(hl) {
	push hl
; 168                 h = 0; // файл для Орион
	ld h, 0
; 169                 if ((a = d) == 0xFF) {
	ld a, d
	cp 255
	jp nz, l_609
; 170                     if ((a = e) == 0xFF) {
	ld a, e
	cp 255
	jp nz, l_611
; 171                         h = 1; // Файл слишком большой для Орион
	ld h, 1
l_611:
l_609:
; 172                     }
; 173                 }
; 174                 if ((a = h) == 0) { // Показываем размер
	ld a, h
	or a
	jp nz, l_613
; 175                     //hl = 0x0400;
; 176                     //compareHlDe();
; 177                     if ((a = d) < 4) { // < 1024 в байтах //flag_c
	ld a, d
	cp 4
	jp nc, l_615
; 178                         push_pop(hl) {
	push hl
; 179                             h = d;
	ld h, d
; 180                             l = e;
	ld l, e
; 181                             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
	jp l_616
l_615:
; 182                         }
; 183                     } else { // В Кб
; 184                         a = d;
	ld a, d
; 185                         a &= 0xFC;
	and 252
; 186                         cyclic_rotate_right(a, 2);
	rrca
	rrca
; 187                         printMyAsDec99A();
	call printmyasdec99a
; 188                         printMyCharA(a = 'K');
	ld a, 75
	call printmychara
; 189                         printMyCharA(a = 'b');
	ld a, 98
	call printmychara
l_616:
	jp l_614
l_613:
; 190                     }
; 191                 } else { // Файл слишком большой
; 192                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 193                     printMyCharA(a = 'B');
	ld a, 66
	call printmychara
; 194                     printMyCharA(a = 'I');
	ld a, 73
	call printmychara
; 195                     printMyCharA(a = 'G');
	ld a, 71
	call printmychara
l_614:
	pop hl
; 196                 }
; 197             }
; 198             FtpViewShowIsDirA(a = 0);
	ld a, 0
	call ftpviewshowisdira
	jp l_608
l_607:
; 199         } else {
; 200             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 201             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 202             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 203             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 204             FtpViewShowIsDirA(a = 1);
	ld a, 1
	call ftpviewshowisdira
l_608:
	pop de
	pop bc
	ret
; 205         }
; 206     }
; 207 }
; 208 
; 209 void FtpViewShowFileDate() {
ftpviewshowfiledate:
; 210     push_pop(bc, de) {
	push bc
	push de
; 211         // X pos
; 212         a = FtpViewX;
	ld a, (ftpviewx)
; 213         a += 16;
	add 16
; 214         myCharPosX = a;
	ld (mycharposx), a
; 215         //-- GGGG
; 216         d = *hl;
	ld d, (hl)
; 217         hl++;
	inc hl
; 218         e = *hl;
	ld e, (hl)
; 219         hl++;
	inc hl
; 220         push_pop(hl) {
	push hl
; 221             h = d;
	ld h, d
; 222             l = e;
	ld l, e
; 223             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
; 224         }
; 225         //--
; 226         printMyCharA(a = '-');
	ld a, 45
	call printmychara
; 227         //--
; 228         printMyAs00Dec99A(a = *hl);
	ld a, (hl)
	call printmyas00dec99a
; 229         hl++;
	inc hl
; 230         //--
; 231         printMyCharA(a = '-');
	ld a, 45
	call printmychara
; 232         //--
; 233         printMyAs00Dec99A(a = *hl);
	ld a, (hl)
	call printmyas00dec99a
; 234         hl++;
	inc hl
	pop de
	pop bc
	ret
; 235     }
; 236 }
; 237 
; 238 void FtpViewShowPath() {
ftpviewshowpath:
; 239     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 240         a = FtpViewX;
	ld a, (ftpviewx)
; 241         b = a;
	ld b, a
; 242         a = FtpViewDX;
	ld a, (ftpviewdx)
; 243         a += b;
	add b
; 244         a -= 19;
	sub 19
; 245         myCharPosX = a;
	ld (mycharposx), a
; 246         a = FtpViewY;
	ld a, (ftpviewy)
; 247         myCharPosY = a;
	ld (mycharposy), a
; 248         de = FtpViewPath;
	ld de, ftpviewpath
; 249         printMyCharA(a = 0xB5);
	ld a, 181
	call printmychara
; 250         b = 16;
	ld b, 16
; 251         c = 0;
	ld c, 0
; 252         do {
l_617:
; 253             a = *de;
	ld a, (de)
; 254             de++;
	inc de
; 255             if (a == 0) {
	or a
	jp nz, l_620
; 256                 c = 1;
	ld c, 1
l_620:
; 257             }
; 258             h = a;
	ld h, a
; 259             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_622
; 260                 printMyCharA(a = h);
	ld a, h
	call printmychara
	jp l_623
l_622:
; 261             } else {
; 262                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
l_623:
; 263             }
; 264             b--;
	dec b
l_618:
; 265         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_617
; 266         printMyCharA(a = 0xC6);
	ld a, 198
	call printmychara
	pop hl
	pop de
	pop bc
	ret
; 267     }
; 268 }
; 269 
; 270 /// Обновление позиции
; 271 /// вх[A]
; 272 /// 0 - без изменений
; 273 /// 1 - вверх
; 274 /// 0xFF - вниз
; 275 void FtpViewFileCurrentPosUpdateA() {
ftpviewfilecurrentposupdatea:
; 276     push_pop(bc) {
	push bc
; 277         b = a;
	ld b, a
; 278         if (a == 0) {
	or a
	jp nz, l_624
; 279             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
	jp l_625
l_624:
; 280         } else {
; 281             a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 282             c = a;
	ld c, a
; 283             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 284             a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 285             a += b;
	add b
; 286             //
; 287             if (a == 0xFF) {
	cp 255
	jp nz, l_626
; 288                 a = c;
	ld a, c
; 289                 a--;
	dec a
	jp l_627
l_626:
; 290             } else if (a == c) {
	cp c
	jp nz, l_628
; 291                 a = 0;
	ld a, 0
l_628:
l_627:
; 292             }
; 293             FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 294             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
l_625:
	pop bc
	ret
; 295         }
; 296     }
; 297 }
; 298 
; 299 /// Рисование линии прямым или инверсным цветом
; 300 /// 0 - прямой
; 301 /// 1 - инверсный
; 302 void FtpViewShowSelectLineA() {
ftpviewshowselectlinea:
; 303     push_pop(bc) {
	push bc
; 304         c = a;
	ld c, a
; 305         // HL
; 306         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 307         b = a;
	ld b, a
; 308         a = FtpViewY;
	ld a, (ftpviewy)
; 309         a += 2;
	add 2
; 310         a += b;
	add b
; 311         l = a;
	ld l, a
; 312         a = FtpViewX;
	ld a, (ftpviewx)
; 313         a += 1;
	add 1
; 314         h = a;
	ld h, a
; 315         // DE
; 316         a = FtpViewDX;
	ld a, (ftpviewdx)
; 317         a -= 2;
	sub 2
; 318         d = a;
	ld d, a
; 319         a = 1;
	ld a, 1
; 320         e = a;
	ld e, a
; 321         // C
; 322         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_630
; 323             a = FtpViewColor;
	ld a, (ftpviewcolor)
	jp l_631
l_630:
; 324         } else {
; 325             a = FtpViewInvColor;
	ld a, (ftpviewinvcolor)
l_631:
; 326         }
; 327         c = a;
	ld c, a
; 328         // A
; 329         a = vboxUMP;
	ld a, 4
; 330         vboxOpenHLDECA();
	call vboxopenhldeca
	pop bc
	ret
; 331     }
; 332 }
; 333 
; 334 void FtpViewKeyA() {
ftpviewkeya:
; 335     push_pop(hl) {
	push hl
; 336         l = a;
	ld l, a
; 337         if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_632
; 338             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, l_634
; 339                 CurrentViewChangeIdA(a = DiskViewId);
	ld a, 1
	call currentviewchangeida
	jp l_635
l_634:
; 340             } else {
; 341                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_636
; 342                     FtpViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call ftpviewfilecurrentposupdatea
	jp l_637
l_636:
; 343                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_638
; 344                     FtpViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpviewfilecurrentposupdatea
	jp l_639
l_638:
; 345                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, l_640
; 346                     if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
	ld a, (ftpviewfilecurrentpos)
	or a
	jp nz, l_642
; 347                         NetFtpChangeDirUp();
	call netftpchangedirup
; 348                         FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_643
l_642:
; 349                     } else {
; 350                         FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 351                         if (a == 1) { // Enter Dir
	cp 1
	jp nz, l_644
; 352                             FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
	ld a, 0
	call ftpviewshowselectlinea
; 353                             NetFtpChangeDirIndexA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftpchangedirindexa
; 354                             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_645
l_644:
; 355                         } else { // Load file
; 356                             FtpViewLoadFile();
	call ftpviewloadfile
l_645:
l_643:
	jp l_641
l_640:
; 357                         }
; 358                     }
; 359                 } else if ((a = l) == 'R') { // Обновление папки
	ld a, l
	cp 82
	jp nz, l_646
; 360                     FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_647
l_646:
; 361                 } else if ((a = l) == 'C') { // загрузка файла
	ld a, l
	cp 67
	jp nz, l_648
; 362                     FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 363                     if (a == 0) { // Проверим что это файл
	or a
	jp nz, l_650
; 364                         FtpViewLoadFile();
	call ftpviewloadfile
l_650:
	jp l_649
l_648:
; 365                     }
; 366                 } else if ((a = l) == 'H') { // Перейти в домашную папку
	ld a, l
	cp 72
	jp nz, l_652
; 367                     ThreadsNetFtpGoToHomeDir();
	call threadsnetftpgotohomedir
	jp l_653
l_652:
; 368                 } else if ((a = l) == 'E') { // Удалить файл
	ld a, l
	cp 69
	jp nz, l_654
; 369                     if ((a = FtpViewFileCurrentPos) > 0) {
	ld a, (ftpviewfilecurrentpos)
	or a
	jp z, l_656
; 370                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 371                         if (a == 1) {
	cp 1
	jp nz, l_658
; 372                             ThreadsNetFtpDeleteFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call threadsnetftpdeletefilea
l_658:
l_656:
	jp l_655
l_654:
; 373                         }
; 374                     }
; 375                 } else if ((a = l) == 'D') { // Создание новой папки
	ld a, l
	cp 68
	jp nz, l_660
; 376                     FtpMakeDirectoryShow();
	call ftpmakedirectoryshow
; 377                     NetGetAllStatus();
	call netgetallstatus
; 378                     FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
l_660:
l_655:
l_653:
l_649:
l_647:
l_641:
l_639:
l_637:
l_635:
l_632:
	pop hl
	ret
; 379                 }
; 380             }
; 381         }
; 382     }
; 383 }
; 384 
; 385 void FtpViewLoadFile() {
ftpviewloadfile:
; 386     LoadViewShowHL(hl = LoadViewLoadTitle);
	ld hl, loadviewloadtitle
	call loadviewshowhl
; 387     #ifdef _IS_SIMULATOR
; 388         push_pop(bc) {
; 389             b = 0;
; 390             do {
; 391                 LoadViewShowProgressA(a = b);
; 392                 c = 1;
; 393                 do {
; 394                     delay50ms();
; 395                     c--;
; 396                 } while ((a = c) > 0);
; 397                 b++;
; 398             } while ((a = b) < 40);
; 399             LoadViewClose();
; 400             DiskViewUpdateDateAndUI();
; 401         }
; 402     #else
; 403         FtpViewNeedLoad();
	call ftpviewneedload
; 404         LoadViewClose();
	call loadviewclose
; 405         DiskViewUpdateDateAndUI();
	jp diskviewupdatedateandui
; 406     #endif
; 407 }
; 408 
; 409 void FtpViewNeedLoad() {
ftpviewneedload:
; 410     NetFtpLoadFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftploadfilea
; 411     
; 412     // Считываем текущий диск и устанавливаем его
; 413     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 414     ordos_wnd();
	call ordos_wnd
; 415     
; 416     // Получаем адрес куда надо начинать писать данные
; 417     ordos_mxdsk();
	call ordos_mxdsk
; 418     DiskViewStartNewFile = hl;
	ld (diskviewstartnewfile), hl
; 419     
; 420     // Вызываем закачку
; 421     NetFtpLoadFileNext();
	jp netftploadfilenext
; 422 }
; 423 
; 424 void FtpViewNetLoadAndUpdate() {
ftpviewnetloadandupdate:
; 425     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 426     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 427     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_662
; 428         NetFtpUpdateList();
	call netftpupdatelist
; 429         NetFtpListFiles();
	call netftplistfiles
l_662:
; 430     }
; 431     a = 0;
	ld a, 0
; 432     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 433     FtpViewShowFileList();
	call ftpviewshowfilelist
; 434     FtpViewShowPath();
	call ftpviewshowpath
; 435     // Показываем курсор, если выбран FTP
; 436     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_664
; 437         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
l_664:
	ret
; 438     }
; 439 }
; 440 
; 441 void FtpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 442     push_pop(hl, bc) {
	push hl
	push bc
; 443         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 444         //--
; 445         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 446         a &= 0x3F;
	and 63
; 447         b = 0;
	ld b, 0
; 448         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 449         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_666
; 450             b++;
	inc b
l_666:
; 451         }
; 452         c = a;
	ld c, a
; 453         //-- Смещаем на позицию файла
; 454         hl += bc;
	add hl, bc
; 455         //-- Смещаем на признак директории
; 456         bc = 10;
	ld bc, 10
; 457         hl += bc;
	add hl, bc
; 458         //--
; 459         a = *hl;
	ld a, (hl)
; 460         a &= 0x01;
	and 1
	pop bc
	pop hl
	ret
; 461     }
; 462 }
; 463 
; 464 void FtpViewEmptyList() {
ftpviewemptylist:
; 465     push_pop(hl) {
	push hl
; 466         a = 1;
	ld a, 1
; 467         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 468         a = 0;
	ld a, 0
; 469         FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 470         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 471         //--
; 472         *hl = '.';
	ld (hl), 46
; 473         hl++;
	inc hl
; 474         *hl = '.';
	ld (hl), 46
; 475         hl++;
	inc hl
; 476         //--
; 477         *hl = ' ';
	ld (hl), 32
; 478         hl++;
	inc hl
; 479         *hl = ' ';
	ld (hl), 32
; 480         hl++;
	inc hl
; 481         *hl = ' ';
	ld (hl), 32
; 482         hl++;
	inc hl
; 483         *hl = ' ';
	ld (hl), 32
; 484         hl++;
	inc hl
; 485         *hl = ' ';
	ld (hl), 32
; 486         hl++;
	inc hl
; 487         *hl = ' ';
	ld (hl), 32
; 488         hl++;
	inc hl
	pop hl
; 489     }
; 490     //--
; 491     FtpViewListUpdateUI();
; 492 }
; 493 
; 494 void FtpViewListUpdateUI() {
ftpviewlistupdateui:
; 495     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 496     a = 0;
	ld a, 0
; 497     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 498     FtpViewShowPath();
	call ftpviewshowpath
; 499     FtpViewShowFileList();
	call ftpviewshowfilelist
; 500     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_668
; 501         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
l_668:
	ret
; 502     }
; 503 }
; 504 
; 505 uint8_t FtpViewX = 0;
ftpviewx:
	db 0
; 506 uint8_t FtpViewY = 4;
ftpviewy:
	db 4
; 507 uint8_t FtpViewDX = 28;
ftpviewdx:
	db 28
; 508 uint8_t FtpViewDY = 25;
ftpviewdy:
	db 25
; 509 uint8_t FtpViewColor = 0x1F;
ftpviewcolor:
	db 31
; 510 uint8_t FtpViewInvColor = 0xF1;
ftpviewinvcolor:
	db 241
; 512 uint8_t FtpViewTitle[] = {0xB5, 'F', 'T', 'P', 0xC6, '\0'}; //"\x12" + "FTP";
ftpviewtitle:
	db 181
	db 70
	db 84
	db 80
	db 198
	db 0
; 513 uint8_t FtpViewPath[16] = "/";
ftpviewpath:
	db 47
	ds 15
; 515 uint8_t FtpViewFileCurrentPos = 0;
ftpviewfilecurrentpos:
	db 0
; 529 uint8_t FtpViewFilesListCount = 1;
ftpviewfileslistcount:
	db 1
; 530 uint8_t FtpViewFilesList[16 * 23] = {
ftpviewfileslist:
	db 46
	db 46
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	ds 352
; 11 void LoadViewShowHL() {
loadviewshowhl:
; 12     CurrentViewChangeAndPushIdA(a = LoadViewId);
	ld a, 4
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = LoadViewX;
	ld a, (loadviewx)
; 15         h = a;
	ld h, a
; 16         a = LoadViewY;
	ld a, (loadviewy)
; 17         l = a;
	ld l, a
; 18         a = LoadViewDX;
	ld a, (loadviewdx)
; 19         d = a;
	ld d, a
; 20         a = LoadViewDY;
	ld a, (loadviewdy)
; 21         e = a;
	ld e, a
; 22         a = LoadViewColor;
	ld a, (loadviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 30     }
; 31     LoadViewShowTitleHL();
	jp loadviewshowtitlehl
; 32 }
; 33 
; 34 void LoadViewClose() {
loadviewclose:
; 35     vboxClose();
	call vboxclose
; 36     CurrentViewReturn();
	jp currentviewreturn
; 37 }
; 38 
; 39 void LoadViewShowTitleHL() {
loadviewshowtitlehl:
; 40     push_pop(bc) {
	push bc
; 41         push_pop(hl) {
	push hl
; 42             b = 0;
	ld b, 0
; 43             do {
l_670:
; 44                 a = *hl;
	ld a, (hl)
; 45                 c = a;
	ld c, a
; 46                 hl++;
	inc hl
; 47                 b++;
	inc b
; 48                 if ((a = LoadViewDX) < b) {
	ld a, (loadviewdx)
	cp b
	jp nc, l_673
; 49                     a = 0;
	ld a, 0
; 50                     c = a;
	ld c, a
l_673:
l_671:
; 51                 }
; 52             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_670
	pop hl
; 53         }
; 54         a = LoadViewDX;
	ld a, (loadviewdx)
; 55         a -= b;
	sub b
; 56         a &= 0xFE;
	and 254
; 57         cyclic_rotate_right(a, 1);
	rrca
; 58         c = a;
	ld c, a
; 59         // X
; 60         a = LoadViewX;
	ld a, (loadviewx)
; 61         a += c;
	add c
; 62         myCharPosX = a;
	ld (mycharposx), a
; 63         // Y
; 64         a = LoadViewY;
	ld a, (loadviewy)
; 65         a += 1;
	add 1
; 66         myCharPosY = a;
	ld (mycharposy), a
; 67         //
; 68         printMyHLStr();
	call printmyhlstr
	pop bc
	ret
; 69     }
; 70 }
; 71 
; 72 uint8_t LoadViewShowProgressOld = 0xFF;
loadviewshowprogressold:
	db 255
; 73 void LoadViewShowProgressA() {
loadviewshowprogressa:
; 74     push_pop(bc) {
	push bc
; 75         c = a; //Save
	ld c, a
; 76         if ((a = LoadViewShowProgressOld) != c) {
	ld a, (loadviewshowprogressold)
	cp c
	jp z, l_675
; 77             a = c;
	ld a, c
; 78             LoadViewShowProgressOld = a;
	ld (loadviewshowprogressold), a
; 79             // X
; 80             a = LoadViewX;
	ld a, (loadviewx)
; 81             a += 1;
	add 1
; 82             myCharPosX = a;
	ld (mycharposx), a
; 83             // Y
; 84             a = LoadViewY;
	ld a, (loadviewy)
; 85             a += 2;
	add 2
; 86             myCharPosY = a;
	ld (mycharposy), a
; 87             b = 0;
	ld b, 0
; 88             do {
l_677:
; 89                 if ((a = b) < c) {
	ld a, b
	cp c
	jp nc, l_680
; 90                     printMyCharA(a = 0xDB);
	ld a, 219
	call printmychara
	jp l_681
l_680:
; 91                 } else {
; 92                     printMyCharA(a = 0xB0); //0xB0 0xB1 0xB2
	ld a, 176
	call printmychara
l_681:
; 93                 }
; 94                 b++;
	inc b
l_678:
; 95             } while ((a = b) < 40);
	ld a, b
	cp 40
	jp c, l_677
l_675:
	pop bc
	ret
; 96         }
; 97     }
; 98 }
; 99 
; 100 uint8_t LoadViewX = 3;
loadviewx:
	db 3
; 101 uint8_t LoadViewY = 14;
loadviewy:
	db 14
; 102 uint8_t LoadViewDX = 42;
loadviewdx:
	db 42
; 103 uint8_t LoadViewDY = 4;
loadviewdy:
	db 4
; 104 uint8_t LoadViewColor = 0x70; // 0x1F;
loadviewcolor:
	db 112
; 106 uint8_t LoadViewProgress = 0;
loadviewprogress:
	db 0
; 108 uint8_t LoadViewLoadTitle[] = "Load...";
loadviewloadtitle:
	db 76
	db 111
	db 97
	db 100
	db 46
	db 46
	db 46
	ds 1
; 109 uint8_t LoadViewUploadTitle[] = "Upload...";
loadviewuploadtitle:
	db 85
	db 112
	db 108
	db 111
	db 97
	db 100
	db 46
	db 46
	db 46
	ds 1
; 11 void WiFiNetworksViewShow() {
wifinetworksviewshow:
; 12     CurrentViewChangeAndPushIdA(a = WiFiNetworksViewId);
	ld a, 7
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 15         h = a;
	ld h, a
; 16         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 17         l = a;
	ld l, a
; 18         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 19         d = a;
	ld d, a
; 20         a = WiFiNetworksViewDY;
	ld a, (wifinetworksviewdy)
; 21         e = a;
	ld e, a
; 22         a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 30     }
; 31     WiFiNetworksViewShowTitle();
	call wifinetworksviewshowtitle
; 32     WiFiNetworksViewUpdateList();
; 33 }
; 34 
; 35 void WiFiNetworksViewUpdateList() {
wifinetworksviewupdatelist:
; 36     WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 37     #ifdef _IS_SIMULATOR
; 38 
; 39     #else
; 40         WiFiNetworksViewClearData();
	call wifinetworksviewcleardata
; 41         NetWiFiListUpdate();
	call netwifilistupdate
; 42         NetWiFiGetList();
	call netwifigetlist
; 43         WiFiNetworksViewFixData();
	call wifinetworksviewfixdata
; 44     #endif
; 45     WiFiNetworksViewShowList();
	call wifinetworksviewshowlist
; 46     a = 0;
	ld a, 0
; 47     WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
; 48     WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	jp wifinetworksviewselectlinea
; 49 }
; 50 
; 51 void WiFiNetworksViewFixData() {
wifinetworksviewfixdata:
; 52     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 53         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 54         de = 16;
	ld de, 16
; 55         b = 16;
	ld b, 16
; 56         do {
l_682:
; 57             a = *hl;
	ld a, (hl)
; 58             if (a == 0) {
	or a
	jp nz, l_685
; 59                 a = '-';
	ld a, 45
; 60                 *hl = a;
	ld (hl), a
l_685:
; 61             }
; 62             hl += de;
	add hl, de
; 63             b--;
	dec b
l_683:
; 64         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_682
	pop de
	pop bc
	pop hl
	ret
; 65     }
; 66 }
; 67 
; 68 void WiFiNetworksViewShowTitle() {
wifinetworksviewshowtitle:
; 69     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 70         // Title
; 71         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 72         a += 3;
	add 3
; 73         myCharPosX = a;
	ld (mycharposx), a
; 74         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 75         a += 1; //2;
	add 1
; 76         myCharPosY = a;
	ld (mycharposy), a
; 77         printMyHLStr(hl = WiFiNetworksViewTitle);
	ld hl, wifinetworksviewtitle
	call printmyhlstr
; 78         // LINE!!!
; 79         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 80         a += 1;
	add 1
; 81         myCharPosX = a;
	ld (mycharposx), a
; 82         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 83         a += 2;
	add 2
; 84         myCharPosY = a;
	ld (mycharposy), a
; 85         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 86         a -= 2;
	sub 2
; 87         b = a;
	ld b, a
; 88         do {
l_687:
; 89             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 90             b--;
	dec b
l_688:
; 91         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_687
	pop de
	pop bc
	pop hl
	ret
; 92     }
; 93 }
; 94 
; 95 void WiFiNetworksViewClose() {
wifinetworksviewclose:
; 96     vboxClose();
	call vboxclose
; 97     CurrentViewReturn();
	jp currentviewreturn
; 98 }
; 99 
; 100 void WiFiNetworksViewKeyA() {
wifinetworksviewkeya:
; 101     push_pop(hl) {
	push hl
; 102         l = a;
	ld l, a
; 103         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_690
; 104             if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, l_692
; 105                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_694
; 106                     WiFiNetworksViewClose();
	call wifinetworksviewclose
	jp l_695
l_694:
; 107                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_696
; 108                     WiFiNetworksViewClose();
	call wifinetworksviewclose
; 109                     //--
; 110                     #ifdef _IS_SIMULATOR
; 111                         WiFiNetworksViewCopySSIDForSimulator();
; 112                         WifiStateViewShowValue();
; 113                     #else
; 114                         ThreadsNetSsidUpdateA(a = WiFiNetworksViewSelectPos);
	ld a, (wifinetworksviewselectpos)
	call threadsnetssidupdatea
; 115                     #endif
; 116                     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
	jp l_697
l_696:
; 117                     //--
; 118                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_698
; 119                     WiFiNetworksViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifinetworksviewposupdatea
	jp l_699
l_698:
; 120                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_700
; 121                     WiFiNetworksViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifinetworksviewposupdatea
l_700:
l_699:
l_697:
l_695:
l_692:
l_690:
	pop hl
	ret
; 122                 }
; 123             }
; 124         }
; 125     }
; 126 }
; 127 
; 128 void WiFiNetworksViewCopySSIDForSimulator() {
wifinetworksviewcopyssidforsimul:
; 129     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 130         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 131         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 132         a &= 0x0F;
	and 15
; 133         cyclic_rotate_left(a, 4);
	rlca
	rlca
	rlca
	rlca
; 134         e = a;
	ld e, a
; 135         d = 0;
	ld d, 0
; 136         hl += de;
	add hl, de
; 137         de = WiFiSettingsViewSsidValue;
	ld de, wifisettingsviewssidvalue
; 138         //-- Copy
; 139         b = 16;
	ld b, 16
; 140         c = 0; // is 0 exist
	ld c, 0
; 141         do {
l_702:
; 142             a = *hl;
	ld a, (hl)
; 143             *de = a;
	ld (de), a
; 144             if (a == 0) {
	or a
	jp nz, l_705
; 145                 c = 1;
	ld c, 1
l_705:
; 146             }
; 147             hl++;
	inc hl
; 148             de++;
	inc de
; 149             b--;
	dec b
l_703:
; 150         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_702
; 151         //-- if stop byte (0)
; 152         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_707
; 153             de--;
	dec de
; 154             a = 0;
	ld a, 0
; 155             *de = a;
	ld (de), a
l_707:
	pop de
	pop bc
	pop hl
	ret
; 156         }
; 157     }
; 158 }
; 159 
; 160 void WiFiNetworksViewClearData() {
wifinetworksviewcleardata:
; 161     push_pop(hl, bc) {
	push hl
	push bc
; 162         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 163         b = 0xFF;
	ld b, 255
; 164         do {
l_709:
; 165             *hl = 0;
	ld (hl), 0
; 166             hl++;
	inc hl
; 167             b--;
	dec b
l_710:
; 168         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_709
	pop bc
	pop hl
	ret
; 169     }
; 170 }
; 171 
; 172 void WiFiNetworksViewShowList() {
wifinetworksviewshowlist:
; 173     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 174         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 175         c = 0;
	ld c, 0
; 176         //
; 177         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 178         a += 2;
	add 2
; 179         d = a; // X
	ld d, a
; 180         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 181         a += 5;
	add 5
; 182         e = a; // Y
	ld e, a
; 183         //
; 184         do {
l_712:
; 185             //--
; 186             a = e;
	ld a, e
; 187             a += c;
	add c
; 188             myCharPosY = a;
	ld (mycharposy), a
; 189             a = d;
	ld a, d
; 190             myCharPosX = a;
	ld (mycharposx), a
; 191             //--
; 192             b = 16;
	ld b, 16
; 193             do {
l_715:
; 194                 printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 195                 hl++;
	inc hl
; 196                 b--;
	dec b
l_716:
; 197             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_715
; 198             c++;
	inc c
l_713:
; 199         } while ((a = WiFiNetworksViewSSIDCount) >= c);
	ld a, (wifinetworksviewssidcount)
	cp c
	jp nc, l_712
; 200         // Crean
; 201         a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 202         c = a;
	ld c, a
; 203         a = 16; // Максимальное число строк
	ld a, 16
; 204         a -= c;
	sub c
; 205         if (a > 0) { // До добавляем пустые строки
	or a
	jp z, l_718
; 206             b = a;
	ld b, a
; 207             //--
; 208             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 209             a += e;
	add e
; 210             e = a;
	ld e, a
; 211             //--
; 212             h = 0;
	ld h, 0
; 213             do {
l_720:
; 214                 //--
; 215                 a = e;
	ld a, e
; 216                 a += h;
	add h
; 217                 myCharPosY = a;
	ld (mycharposy), a
; 218                 a = d;
	ld a, d
; 219                 myCharPosX = a;
	ld (mycharposx), a
; 220                 //--
; 221                 c = 16;
	ld c, 16
; 222                 do {
l_723:
; 223                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 224                     c--;
	dec c
l_724:
; 225                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_723
; 226                 b--;
	dec b
; 227                 h++;
	inc h
l_721:
; 228             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_720
l_718:
	pop de
	pop bc
	pop hl
	ret
; 229         }
; 230     }
; 231 }
; 232 
; 233 /// Обновление позиции
; 234 /// вх[A]
; 235 /// 0 - без изменений
; 236 /// 1 - вверх
; 237 /// 0xFF - вниз
; 238 void WiFiNetworksViewPosUpdateA() {
wifinetworksviewposupdatea:
; 239     push_pop(bc) {
	push bc
; 240         b = a;
	ld b, a
; 241         if (a == 0) {
	or a
	jp nz, l_726
; 242             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
	jp l_727
l_726:
; 243         } else {
; 244             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 245             c = a;
	ld c, a
; 246             WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 247             if ((a = c) == 0) { // нет ни одной записи
	ld a, c
	or a
	jp nz, l_728
; 248                 a = 0;
	ld a, 0
; 249                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
	jp l_729
l_728:
; 250             } else { // если есть хоть одна запись
; 251                 a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 252                 a += b;
	add b
; 253                 //-- FIX
; 254                 if (a == 0xFF) {
	cp 255
	jp nz, l_730
; 255                     a = c;
	ld a, c
; 256                     a--;
	dec a
	jp l_731
l_730:
; 257                 } else if (a == c) {
	cp c
	jp nz, l_732
; 258                     a = 0;
	ld a, 0
l_732:
l_731:
; 259                 }
; 260                 //--
; 261                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
l_729:
; 262             }
; 263             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
l_727:
	pop bc
	ret
; 264         }
; 265     }
; 266 }
; 267 
; 268 /// Рисование линии прямым или инверсным цветом
; 269 /// 0 - прямой
; 270 /// 1 - инверсный
; 271 void WiFiNetworksViewSelectLineA() {
wifinetworksviewselectlinea:
; 272     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 273         c = a;
	ld c, a
; 274         //--
; 275         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 276         b = a;
	ld b, a
; 277         //--
; 278         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 279         a += 1;
	add 1
; 280         h = a; // X
	ld h, a
; 281         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 282         a += 5;
	add 5
; 283         a += b;
	add b
; 284         l = a; // Y
	ld l, a
; 285         //--
; 286         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 287         a -= 2;
	sub 2
; 288         d = a;
	ld d, a
; 289         e = 1;
	ld e, 1
; 290         //--
; 291         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_734
; 292             a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
	jp l_735
l_734:
; 293         } else {
; 294             a = WiFiNetworksViewInvColor;
	ld a, (wifinetworksviewinvcolor)
l_735:
; 295         }
; 296         c = a;
	ld c, a
; 297         //--
; 298         a = vboxUMP;
	ld a, 4
; 299         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 300     }
; 301 }
; 302 
; 303 uint8_t WiFiNetworksViewX = 14; //21;
wifinetworksviewx:
	db 14
; 304 uint8_t WiFiNetworksViewY = 3;
wifinetworksviewy:
	db 3
; 305 uint8_t WiFiNetworksViewDX = 20;
wifinetworksviewdx:
	db 20
; 306 uint8_t WiFiNetworksViewDY = 23;
wifinetworksviewdy:
	db 23
; 307 uint8_t WiFiNetworksViewColor = 0x70;
wifinetworksviewcolor:
	db 112
; 308 uint8_t WiFiNetworksViewInvColor = 0x07;
wifinetworksviewinvcolor:
	db 7
; 310 uint8_t WiFiNetworksViewSelectPos = 0;
wifinetworksviewselectpos:
	db 0
; 312 uint8_t WiFiNetworksViewTitle[] = "Wi-Fi Networks";
wifinetworksviewtitle:
	db 87
	db 105
	db 45
	db 70
	db 105
	db 32
	db 78
	db 101
	db 116
	db 119
	db 111
	db 114
	db 107
	db 115
	ds 1
; 335 uint8_t WiFiNetworksViewSSIDCount = 0;
wifinetworksviewssidcount:
	db 0
; 336 uint8_t WiFiNetworksViewSSIDList[16*16] = {
wifinetworksviewssidlist:
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 11 void DebugShowIn00HexA() {
debugshowin00hexa:
; 12     push_pop(bc, de) {
	push bc
	push de
; 13         b = a;
	ld b, a
; 14         a = 0;
	ld a, 0
; 15         myCharPosX = a;
	ld (mycharposx), a
; 16         a = 0;
	ld a, 0
; 17         myCharPosY = a;
	ld (mycharposy), a
; 18         printMyHexA(a = b);
	ld a, b
	call printmyhexa
	pop de
	pop bc
	ret
; 11 void AllertYesNoViewShowHL() {
allertyesnoviewshowhl:
; 12     AllertYesNoViewTitlePoint = hl;
	ld (allertyesnoviewtitlepoint), hl
; 13     CurrentViewChangeAndPushIdA(a = AllertYesNoViewId);
	ld a, 9
	call currentviewchangeandpushida
; 14     a = 0;
	ld a, 0
; 15     AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 16     a = 0;
	ld a, 0
; 17     AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
; 18     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 19         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 20         h = a;
	ld h, a
; 21         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 22         l = a;
	ld l, a
; 23         a = AllertYesNoViewDX;
	ld a, (allertyesnoviewdx)
; 24         d = a;
	ld d, a
; 25         a = AllertYesNoViewDY;
	ld a, (allertyesnoviewdy)
; 26         e = a;
	ld e, a
; 27         a = AllertYesNoViewColor;
	ld a, (allertyesnoviewcolor)
; 28         c = a;
	ld c, a
; 29         a = vboxCLW;
	ld a, 64
; 30         a |= vboxFRM;
	or 32
; 31         a |= vboxSDW;
	or 16
; 32         a |= vboxSAV;
	or 8
; 33         a |= vboxUMP;
	or 4
; 34         vboxOpenHLDECA();
	call vboxopenhldeca
; 35         
; 36         // NO Button
; 37         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 38         a += 6; //!
	add 6
; 39         h = a;
	ld h, a
; 40         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 41         a += 4;
	add 4
; 42         l = a;
	ld l, a
; 43         d = 4;
	ld d, 4
; 44         e = 3;
	ld e, 3
; 45         ButtonShadowViewShow(bc = StringLocaleNo);
	ld bc, stringlocaleno
	call buttonshadowviewshow
; 46         // YES Button
; 47         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 48         a += 6 + 7; //!
	add 13
; 49         h = a;
	ld h, a
; 50         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 51         a += 4;
	add 4
; 52         l = a;
	ld l, a
; 53         d = 5;
	ld d, 5
; 54         e = 3;
	ld e, 3
; 55         ButtonShadowView2Show(bc = StringLocaleYes);
	ld bc, stringlocaleyes
	call buttonshadowview2show
	pop de
	pop hl
	pop bc
; 56     }
; 57     AllertYesNoViewShowTitle();
	call allertyesnoviewshowtitle
; 58     AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
; 59     AllertYesNoViewLoopKey();
; 60 }
; 61 
; 62 void AllertYesNoViewLoopKey() {
allertyesnoviewloopkey:
; 63     push_pop(bc) {
	push bc
; 64         b = 0;
	ld b, 0
; 65         do {
l_736:
; 66             getKeyboardCharA();
	call getkeyboardchara
; 67             c = a;
	ld c, a
; 68             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, l_739
; 69                 b = 1;
	ld b, 1
	jp l_740
l_739:
; 70             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, l_741
; 71                 a = AllertYesNoViewPos;
	ld a, (allertyesnoviewpos)
; 72                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 73                 b = 1;
	ld b, 1
	jp l_742
l_741:
; 74             } else if ((a = c) == 0x18) { // Вправл
	ld a, c
	cp 24
	jp nz, l_743
; 75                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 76                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp l_744
l_743:
; 77             } else if ((a = c) == 0x08) { // Влево
	ld a, c
	cp 8
	jp nz, l_745
; 78                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 79                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp l_746
l_745:
; 80             } else if ((a = c) == 'Y') {
	ld a, c
	cp 89
	jp nz, l_747
; 81                 a = 1;
	ld a, 1
; 82                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 83                 b = 1;
	ld b, 1
	jp l_748
l_747:
; 84             } else if ((a = c) == 'N') {
	ld a, c
	cp 78
	jp nz, l_749
; 85                 a = 0;
	ld a, 0
; 86                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 87                 b = 1;
	ld b, 1
l_749:
l_748:
l_746:
l_744:
l_742:
l_740:
l_737:
; 88             }
; 89         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, l_736
	pop bc
; 90     }
; 91     AllertYesNoViewClose();
	jp allertyesnoviewclose
; 92 }
; 93 
; 94 void AllertYesNoViewPosNext() {
allertyesnoviewposnext:
; 95     if ((a = AllertYesNoViewPos) == 0) {
	ld a, (allertyesnoviewpos)
	or a
	jp nz, l_751
; 96         a = 1;
	ld a, 1
; 97         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
	jp l_752
l_751:
; 98     } else {
; 99         a = 0;
	ld a, 0
; 100         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
l_752:
	ret
; 101     }
; 102 }
; 103 
; 104 void AllertYesNoViewPosUpdate() {
allertyesnoviewposupdate:
; 105     if ((a = AllertYesNoViewPos) == 0) {
	ld a, (allertyesnoviewpos)
	or a
	jp nz, l_753
; 106         ButtonShadowViewSelectA(a = 1);
	ld a, 1
	call buttonshadowviewselecta
; 107         ButtonShadowView2SelectA(a = 0);
	ld a, 0
	call buttonshadowview2selecta
	jp l_754
l_753:
; 108     } else {
; 109         ButtonShadowViewSelectA(a = 0);
	ld a, 0
	call buttonshadowviewselecta
; 110         ButtonShadowView2SelectA(a = 1);
	ld a, 1
	call buttonshadowview2selecta
l_754:
	ret
; 111     }
; 112 }
; 113 
; 114 void AllertYesNoViewClose() {
allertyesnoviewclose:
; 115     vboxClose();
	call vboxclose
; 116     CurrentViewReturn();
	call currentviewreturn
; 117     a = AllertYesNoViewReturnValue;
	ld a, (allertyesnoviewreturnvalue)
	ret
; 118 }
; 119 
; 120 void AllertYesNoViewShowTitle() {
allertyesnoviewshowtitle:
; 121     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 122         hl = AllertYesNoViewTitlePoint;
	ld hl, (allertyesnoviewtitlepoint)
; 123         b = 0;
	ld b, 0
; 124         a = AllertYesNoViewDX;
	ld a, (allertyesnoviewdx)
; 125         c = a;
	ld c, a
; 126         do {
l_755:
; 127             a = *hl;
	ld a, (hl)
; 128             d = a;
	ld d, a
; 129             hl++;
	inc hl
; 130             if (a > 0) {
	or a
	jp z, l_758
; 131                 b++;
	inc b
l_758:
; 132             }
; 133             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, l_760
; 134                 d = 0;
	ld d, 0
l_760:
l_756:
; 135             }
; 136         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, l_755
; 137         a = AllertYesNoViewDX;
	ld a, (allertyesnoviewdx)
; 138         a -= b;
	sub b
; 139         a &= 0xFE;
	and 254
; 140         cyclic_rotate_right(a, 1);
	rrca
; 141         b = a;
	ld b, a
; 142         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 143         a += b;
	add b
; 144         myCharPosX = a;
	ld (mycharposx), a
; 145         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 146         a += 2;
	add 2
; 147         myCharPosY = a;
	ld (mycharposy), a
; 148         printMyHLStr(hl = AllertYesNoViewTitlePoint);
	ld hl, (allertyesnoviewtitlepoint)
	call printmyhlstr
	pop bc
	pop de
	pop hl
	ret
; 149     }
; 150 }
; 151 
; 152 uint8_t AllertYesNoViewX = 12;
allertyesnoviewx:
	db 12
; 153 uint8_t AllertYesNoViewY = 12;
allertyesnoviewy:
	db 12
; 154 uint8_t AllertYesNoViewDX = 24;
allertyesnoviewdx:
	db 24
; 155 uint8_t AllertYesNoViewDY = 9;
allertyesnoviewdy:
	db 9
; 156 uint8_t AllertYesNoViewColor = 0x70; // 0x1F;
allertyesnoviewcolor:
	db 112
; 158 uint8_t AllertYesNoViewPos = 0;
allertyesnoviewpos:
	db 0
; 159 uint8_t AllertYesNoViewReturnValue = 0;
allertyesnoviewreturnvalue:
	db 0
; 161 uint16_t AllertYesNoViewTitlePoint = 0;
allertyesnoviewtitlepoint:
	dw 0
; 14 void ButtonShadowView2Show() {
buttonshadowview2show:
; 15     push_pop(hl) {
	push hl
; 16         h = b;
	ld h, b
; 17         l = c;
	ld l, c
; 18         ButtonShadowView2TitlePoint = hl;
	ld (buttonshadowview2titlepoint), hl
	pop hl
; 19     }
; 20     //- SAVE -
; 21     a = h;
	ld a, h
; 22     ButtonShadowView2X = a;
	ld (buttonshadowview2x), a
; 23     //printHexA(a = ButtonShadowViewX);
; 24     a = l;
	ld a, l
; 25     ButtonShadowView2Y = a;
	ld (buttonshadowview2y), a
; 26     //printHexA(a = ButtonShadowViewY);
; 27     a = d;
	ld a, d
; 28     ButtonShadowView2DX = a;
	ld (buttonshadowview2dx), a
; 29     //printHexA(a = ButtonShadowViewDX);
; 30     a = e;
	ld a, e
; 31     ButtonShadowView2DY = a;
	ld (buttonshadowview2dy), a
; 32     //printHexA(a = ButtonShadowViewDY);
; 33     //--
; 34     a = ButtonShadowView2Color;
	ld a, (buttonshadowview2color)
; 35     c = a;
	ld c, a
; 36     a = vboxCLW;
	ld a, 64
; 37     a |= vboxFRM;
	or 32
; 38     a |= vboxSDW;
	or 16
; 39     a |= vboxUMP;
	or 4
; 40     vboxOpenHLDECA();
	call vboxopenhldeca
; 41     //
; 42     ButtonShadowView2ShowTitleBC();
	jp buttonshadowview2showtitlebc
; 43 }
; 44 
; 45 /// Закраска кнопки
; 46 /// 0 - прямой
; 47 /// 1 - инверсный
; 48 void ButtonShadowView2SelectA() {
buttonshadowview2selecta:
; 49     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 50         b = a;
	ld b, a
; 51         a = ButtonShadowView2X;
	ld a, (buttonshadowview2x)
; 52         h = a;
	ld h, a
; 53         a = ButtonShadowView2Y;
	ld a, (buttonshadowview2y)
; 54         l = a;
	ld l, a
; 55         a = ButtonShadowView2DX;
	ld a, (buttonshadowview2dx)
; 56         d = a;
	ld d, a
; 57         a = ButtonShadowView2DY;
	ld a, (buttonshadowview2dy)
; 58         e = a;
	ld e, a
; 59         //--------
; 60         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_762
; 61             a = ButtonShadowView2Color;
	ld a, (buttonshadowview2color)
	jp l_763
l_762:
; 62         } else {
; 63             a = ButtonShadowView2InvColor;
	ld a, (buttonshadowview2invcolor)
l_763:
; 64         }
; 65         c = a;
	ld c, a
; 66         //----
; 67         a = vboxFRM;
	ld a, 32
; 68         a |= vboxUMP;
	or 4
; 69         vboxOpenHLDECA();
	call vboxopenhldeca
	pop hl
	pop de
	pop bc
	ret
; 70     }
; 71 }
; 72 
; 73 void ButtonShadowView2ShowTitleBC() {
buttonshadowview2showtitlebc:
; 74     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 75         hl = ButtonShadowView2TitlePoint;
	ld hl, (buttonshadowview2titlepoint)
; 76         b = 0;
	ld b, 0
; 77         a = ButtonShadowView2DX;
	ld a, (buttonshadowview2dx)
; 78         c = a;
	ld c, a
; 79         do {
l_764:
; 80             a = *hl;
	ld a, (hl)
; 81             d = a;
	ld d, a
; 82             hl++;
	inc hl
; 83             if (a > 0) {
	or a
	jp z, l_767
; 84                 b++;
	inc b
l_767:
; 85             }
; 86             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, l_769
; 87                 d = 0;
	ld d, 0
l_769:
l_765:
; 88             }
; 89         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, l_764
; 90         a = ButtonShadowView2DX;
	ld a, (buttonshadowview2dx)
; 91         a -= b;
	sub b
; 92         a &= 0xFE;
	and 254
; 93         cyclic_rotate_right(a, 1);
	rrca
; 94         b = a;
	ld b, a
; 95         a = ButtonShadowView2X;
	ld a, (buttonshadowview2x)
; 96         a += b;
	add b
; 97         myCharPosX = a;
	ld (mycharposx), a
; 98         a = ButtonShadowView2Y;
	ld a, (buttonshadowview2y)
; 99         a += 1;
	add 1
; 100         myCharPosY = a;
	ld (mycharposy), a
; 101         printMyHLStr(hl = ButtonShadowView2TitlePoint);
	ld hl, (buttonshadowview2titlepoint)
	call printmyhlstr
	pop bc
	pop de
	pop hl
	ret
; 102     }
; 103 }
; 104 
; 105 uint8_t ButtonShadowView2X = 0;
buttonshadowview2x:
	db 0
; 106 uint8_t ButtonShadowView2Y = 0;
buttonshadowview2y:
	db 0
; 107 uint8_t ButtonShadowView2DX = 0;
buttonshadowview2dx:
	db 0
; 108 uint8_t ButtonShadowView2DY = 0;
buttonshadowview2dy:
	db 0
; 110 uint8_t ButtonShadowView2Color = 0xF7;
buttonshadowview2color:
	db 247
; 111 uint8_t ButtonShadowView2InvColor = 0xE2; //0xE6
buttonshadowview2invcolor:
	db 226
; 113 uint16_t ButtonShadowView2TitlePoint = 0x0000;
buttonshadowview2titlepoint:
	dw 0
; 11 void AllertOkViewShowHL() {
allertokviewshowhl:
; 12     AllertOkViewTitlePoint = hl;
	ld (allertokviewtitlepoint), hl
; 13     CurrentViewChangeAndPushIdA(a = AllertOkViewId);
	ld a, 10
	call currentviewchangeandpushida
; 14     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 15         a = AllertOkViewX;
	ld a, (allertokviewx)
; 16         h = a;
	ld h, a
; 17         a = AllertOkViewY;
	ld a, (allertokviewy)
; 18         l = a;
	ld l, a
; 19         a = AllertOkViewDX;
	ld a, (allertokviewdx)
; 20         d = a;
	ld d, a
; 21         a = AllertOkViewDY;
	ld a, (allertokviewdy)
; 22         e = a;
	ld e, a
; 23         a = AllertOkViewColor;
	ld a, (allertokviewcolor)
; 24         c = a;
	ld c, a
; 25         a = vboxCLW;
	ld a, 64
; 26         a |= vboxFRM;
	or 32
; 27         a |= vboxSDW;
	or 16
; 28         a |= vboxSAV;
	or 8
; 29         a |= vboxUMP;
	or 4
; 30         vboxOpenHLDECA();
	call vboxopenhldeca
; 31         
; 32         // Ok Button
; 33         a = AllertOkViewX;
	ld a, (allertokviewx)
; 34         a += 10; //!
	add 10
; 35         h = a;
	ld h, a
; 36         a = AllertOkViewY;
	ld a, (allertokviewy)
; 37         a += 4;
	add 4
; 38         l = a;
	ld l, a
; 39         d = 4;
	ld d, 4
; 40         e = 3;
	ld e, 3
; 41         ButtonShadowViewShow(bc = StringLocaleOK);
	ld bc, stringlocaleok
	call buttonshadowviewshow
; 42         ButtonShadowViewSelectA(a = 1);
	ld a, 1
	call buttonshadowviewselecta
	pop de
	pop hl
	pop bc
; 43     }
; 44     AllertOkViewShowTitle();
	call allertokviewshowtitle
; 45     AllertOkViewLoopKey();
; 46 }
; 47 
; 48 void AllertOkViewLoopKey() {
allertokviewloopkey:
; 49     push_pop(bc) {
	push bc
; 50         b = 0;
	ld b, 0
; 51         do {
l_771:
; 52             getKeyboardCharA();
	call getkeyboardchara
; 53             c = a;
	ld c, a
; 54             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, l_774
; 55                 b = 1;
	ld b, 1
	jp l_775
l_774:
; 56             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, l_776
; 57                 b = 1;
	ld b, 1
l_776:
l_775:
l_772:
; 58             }
; 59         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, l_771
; 60         AllertOkViewClose();
	call allertokviewclose
	pop bc
	ret
; 61     }
; 62 }
; 63 
; 64 void AllertOkViewClose() {
allertokviewclose:
; 65     vboxClose();
	call vboxclose
; 66     CurrentViewReturn();
	jp currentviewreturn
; 67 }
; 68 
; 69 void AllertOkViewShowTitle() {
allertokviewshowtitle:
; 70     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 71         hl = AllertOkViewTitlePoint;
	ld hl, (allertokviewtitlepoint)
; 72         b = 0;
	ld b, 0
; 73         a = AllertOkViewDX;
	ld a, (allertokviewdx)
; 74         c = a;
	ld c, a
; 75         do {
l_778:
; 76             a = *hl;
	ld a, (hl)
; 77             d = a;
	ld d, a
; 78             hl++;
	inc hl
; 79             if (a > 0) {
	or a
	jp z, l_781
; 80                 b++;
	inc b
l_781:
; 81             }
; 82             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, l_783
; 83                 d = 0;
	ld d, 0
l_783:
l_779:
; 84             }
; 85         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, l_778
; 86         a = AllertOkViewDX;
	ld a, (allertokviewdx)
; 87         a -= b;
	sub b
; 88         a &= 0xFE;
	and 254
; 89         cyclic_rotate_right(a, 1);
	rrca
; 90         b = a;
	ld b, a
; 91         a = AllertOkViewX;
	ld a, (allertokviewx)
; 92         a += b;
	add b
; 93         myCharPosX = a;
	ld (mycharposx), a
; 94         a = AllertOkViewY;
	ld a, (allertokviewy)
; 95         a += 2;
	add 2
; 96         myCharPosY = a;
	ld (mycharposy), a
; 97         printMyHLStr(hl = AllertOkViewTitlePoint);
	ld hl, (allertokviewtitlepoint)
	call printmyhlstr
	pop bc
	pop de
	pop hl
	ret
; 98     }
; 99 }
; 100 
; 101 uint8_t AllertOkViewX = 12;
allertokviewx:
	db 12
; 102 uint8_t AllertOkViewY = 12;
allertokviewy:
	db 12
; 103 uint8_t AllertOkViewDX = 24;
allertokviewdx:
	db 24
; 104 uint8_t AllertOkViewDY = 9;
allertokviewdy:
	db 9
; 105 uint8_t AllertOkViewColor = 0x70; // 0x1F;
allertokviewcolor:
	db 112
; 107 uint16_t AllertOkViewTitlePoint = 0;
allertokviewtitlepoint:
	dw 0
; 11 void FtpMakeDirectoryShow() {
ftpmakedirectoryshow:
; 12     CurrentViewChangeAndPushIdA(a = FtpMakeDirectoryId);
	ld a, 11
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 15         h = a;
	ld h, a
; 16         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 17         l = a;
	ld l, a
; 18         a = FtpMakeDirectoryDX;
	ld a, (ftpmakedirectorydx)
; 19         d = a;
	ld d, a
; 20         a = FtpMakeDirectoryDY;
	ld a, (ftpmakedirectorydy)
; 21         e = a;
	ld e, a
; 22         a = FtpMakeDirectoryColor;
	ld a, (ftpmakedirectorycolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 30     }
; 31     FtpMakeDirectoryInitValue();
	call ftpmakedirectoryinitvalue
; 32     FtpMakeDirectoryShowTitle();
	call ftpmakedirectoryshowtitle
; 33     FtpMakeDirectoryShowValue();
	call ftpmakedirectoryshowvalue
; 34     FtpMakeDirectorySelectLineA(a = 1);
	ld a, 1
	jp ftpmakedirectoryselectlinea
; 35 }
; 36 
; 37 void FtpMakeDirectoryInitValue() {
ftpmakedirectoryinitvalue:
; 38     a = 0;
	ld a, 0
; 39     FtpMakeDirectorySelectPos = a;
	ld (ftpmakedirectoryselectpos), a
; 40     // Value
; 41     a = 'N';
	ld a, 78
; 42     FtpMakeDirectoryValue[0] = a;
	ld (ftpmakedirectoryvalue), a
; 43     a = 'e';
	ld a, 101
; 44     FtpMakeDirectoryValue[1] = a;
	ld (0FFFFh & ((ftpmakedirectoryvalue) + (1))), a
; 45     a = 'w';
	ld a, 119
; 46     FtpMakeDirectoryValue[2] = a;
	ld (0FFFFh & ((ftpmakedirectoryvalue) + (2))), a
; 47     a = 0;
	ld a, 0
; 48     FtpMakeDirectoryValue[3] = a;
	ld (0FFFFh & ((ftpmakedirectoryvalue) + (3))), a
	ret
; 49 }
; 50 
; 51 void FtpMakeDirectoryShowTitle() {
ftpmakedirectoryshowtitle:
; 52     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 53         // Title
; 54         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 55         a += 3;
	add 3
; 56         myCharPosX = a;
	ld (mycharposx), a
; 57         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 58         a += 1; //2;
	add 1
; 59         myCharPosY = a;
	ld (mycharposy), a
; 60         printMyHLStr(hl = FtpMakeDirectoryTitle);
	ld hl, ftpmakedirectorytitle
	call printmyhlstr
; 61         // LINE!!!
; 62         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 63         a += 1;
	add 1
; 64         myCharPosX = a;
	ld (mycharposx), a
; 65         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 66         a += 2;
	add 2
; 67         myCharPosY = a;
	ld (mycharposy), a
; 68         a = FtpMakeDirectoryDX;
	ld a, (ftpmakedirectorydx)
; 69         a -= 2;
	sub 2
; 70         b = a;
	ld b, a
; 71         do {
l_785:
; 72             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 73             b--;
	dec b
l_786:
; 74         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_785
; 75         // DIRECTORY
; 76         // Button
; 77         bc = StringLocaleOK;
	ld bc, stringlocaleok
; 78         
; 79         d = 8; //13
	ld d, 8
; 80         e = 3;
	ld e, 3
; 81         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 82         a += 6;
	add 6
; 83         h = a;
	ld h, a
; 84         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 85         a += 7;
	add 7
; 86         l = a;
	ld l, a
; 87         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 88     }
; 89 }
; 90 
; 91 void FtpMakeDirectoryShowValue() {
ftpmakedirectoryshowvalue:
; 92     push_pop(hl, bc) {
	push hl
	push bc
; 93         // Directory
; 94         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 95         a += 2;
	add 2
; 96         myCharPosX = a;
	ld (mycharposx), a
; 97         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 98         a += 4;
	add 4
; 99         c = a; // Y
	ld c, a
; 100         myCharPosY = a;
	ld (mycharposy), a
; 101         a = 16;
	ld a, 16
; 102         printMyHLStrLenA(hl = FtpMakeDirectoryValue);
	ld hl, ftpmakedirectoryvalue
	call printmyhlstrlena
	pop bc
	pop hl
	ret
; 103     }
; 104 }
; 105 
; 106 /// вых [HL] -
; 107 /// вых [DE]-
; 108 void FtpMakeDirectoryByPosBoxValue() {
ftpmakedirectorybyposboxvalue:
; 109     push_pop(bc) {
	push bc
; 110         a = FtpMakeDirectoryX;
	ld a, (ftpmakedirectoryx)
; 111         a += 2;
	add 2
; 112         h = a;
	ld h, a
; 113         a = FtpMakeDirectoryY;
	ld a, (ftpmakedirectoryy)
; 114         a += 4;
	add 4
; 115         l = a;
	ld l, a
; 116         // DE
; 117         a = 16;
	ld a, 16
; 118         d = a;
	ld d, a
; 119         a = 1;
	ld a, 1
; 120         e = a;
	ld e, a
	pop bc
	ret
; 121     }
; 122 }
; 123 
; 124 /// вых [BC] -
; 125 void FtpMakeDirectoryByPosValue() {
ftpmakedirectorybyposvalue:
; 126     bc = FtpMakeDirectoryValue;
	ld bc, ftpmakedirectoryvalue
	ret
; 127 }
; 128 
; 129 /// Рисование линии прямым или инверсным цветом
; 130 /// 0 - прямой
; 131 /// 1 - инверсный
; 132 void FtpMakeDirectorySelectLineA() {
ftpmakedirectoryselectlinea:
; 133     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 134         c = a;
	ld c, a
; 135         // 0 - Button
; 136         if ((a = FtpMakeDirectorySelectPos) == 0) {
	ld a, (ftpmakedirectoryselectpos)
	or a
	jp nz, l_788
; 137             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp l_789
l_788:
; 138         } else {
; 139             FtpMakeDirectoryByPosBoxValue();
	call ftpmakedirectorybyposboxvalue
; 140             // C
; 141             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_790
; 142                 a = FtpMakeDirectoryColor;
	ld a, (ftpmakedirectorycolor)
	jp l_791
l_790:
; 143             } else {
; 144                 a = FtpMakeDirectoryInvColor;
	ld a, (ftpmakedirectoryinvcolor)
l_791:
; 145             }
; 146             c = a;
	ld c, a
; 147             // A
; 148             a = vboxUMP;
	ld a, 4
; 149             vboxOpenHLDECA();
	call vboxopenhldeca
l_789:
	pop de
	pop hl
	pop bc
	ret
; 150         }
; 151     }
; 152 }
; 153 
; 154 /// Обновление позиции
; 155 /// вх[A]
; 156 /// 0 - без изменений
; 157 /// 1 - вверх
; 158 /// 0xFF - вниз
; 159 void FtpMakeDirectoryPosUpdateA() {
ftpmakedirectoryposupdatea:
; 160     push_pop(bc) {
	push bc
; 161         b = a;
	ld b, a
; 162         if (a == 0) {
	or a
	jp nz, l_792
; 163             FtpMakeDirectorySelectLineA(a = 1);
	ld a, 1
	call ftpmakedirectoryselectlinea
	jp l_793
l_792:
; 164         } else {
; 165             a = 2;
	ld a, 2
; 166             c = a;
	ld c, a
; 167             FtpMakeDirectorySelectLineA(a = 0);
	ld a, 0
	call ftpmakedirectoryselectlinea
; 168             a = FtpMakeDirectorySelectPos;
	ld a, (ftpmakedirectoryselectpos)
; 169             a += b;
	add b
; 170             b = a;
	ld b, a
; 171             //-- FIX
; 172             if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, l_794
; 173                 a = c;
	ld a, c
; 174                 a--;
	dec a
	jp l_795
l_794:
; 175             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, l_796
; 176                 a = 0;
	ld a, 0
l_796:
l_795:
; 177             }
; 178             //--
; 179             FtpMakeDirectorySelectPos = a;
	ld (ftpmakedirectoryselectpos), a
; 180             FtpMakeDirectorySelectLineA(a = 1);
	ld a, 1
	call ftpmakedirectoryselectlinea
l_793:
	pop bc
	ret
; 181         }
; 182     }
; 183 }
; 184 
; 185 void FtpMakeDirectoryClose() {
ftpmakedirectoryclose:
; 186     vboxClose();
	call vboxclose
; 187     CurrentViewReturn();
	jp currentviewreturn
; 188 }
; 189 
; 190 void FtpMakeDirectoryKeyA() {
ftpmakedirectorykeya:
; 191     push_pop(hl) {
	push hl
; 192         l = a;
	ld l, a
; 193         if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, l_798
; 194             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_800
; 195                 FtpMakeDirectoryClose();
	call ftpmakedirectoryclose
	jp l_801
l_800:
; 196             } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_802
; 197                 if ((a = FtpMakeDirectorySelectPos) == 0) { // OK
	ld a, (ftpmakedirectoryselectpos)
	or a
	jp nz, l_804
; 198                     FtpMakeDirectoryClose();
	call ftpmakedirectoryclose
; 199                     #ifdef _IS_SIMULATOR
; 200                     #else
; 201                         NetFtpMakeDirectory();
	call netftpmakedirectory
; 202                         ThreadsTickNow();
	call threadsticknow
	jp l_805
l_804:
; 203                     #endif
; 204                 } else { // Переход в редактирование
; 205                     FtpMakeDirectoryByPosBoxValue();
	call ftpmakedirectorybyposboxvalue
; 206                     FtpMakeDirectoryByPosValue();
	call ftpmakedirectorybyposvalue
; 207                     EditFieldViewShow();
	call editfieldviewshow
; 208                     if (a == 1) { // что то изменилось
	cp 1
	jp nz, l_806
; 209                         FtpMakeDirectoryShowValue();
	call ftpmakedirectoryshowvalue
l_806:
l_805:
	jp l_803
l_802:
; 210                     }
; 211                 }
; 212             } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_808
; 213                 FtpMakeDirectoryPosUpdateA(a = 0x01);
	ld a, 1
	call ftpmakedirectoryposupdatea
	jp l_809
l_808:
; 214             } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_810
; 215                 FtpMakeDirectoryPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpmakedirectoryposupdatea
l_810:
l_809:
l_803:
l_801:
l_798:
	pop hl
	ret
; 216             }
; 217         }
; 218     }
; 219 }
; 220 
; 221 uint8_t FtpMakeDirectoryX = 14;
ftpmakedirectoryx:
	db 14
; 222 uint8_t FtpMakeDirectoryY = 11;
ftpmakedirectoryy:
	db 11
; 223 uint8_t FtpMakeDirectoryDX = 20;
ftpmakedirectorydx:
	db 20
; 224 uint8_t FtpMakeDirectoryDY = 12;
ftpmakedirectorydy:
	db 12
; 225 uint8_t FtpMakeDirectoryColor = 0x70;
ftpmakedirectorycolor:
	db 112
; 226 uint8_t FtpMakeDirectoryInvColor = 0x07;
ftpmakedirectoryinvcolor:
	db 7
; 228 uint8_t FtpMakeDirectoryTitle[] = "Make directory";
ftpmakedirectorytitle:
	db 77
	db 97
	db 107
	db 101
	db 32
	db 100
	db 105
	db 114
	db 101
	db 99
	db 116
	db 111
	db 114
	db 121
	ds 1
; 229 uint8_t FtpMakeDirectoryValue[16] = "New";
ftpmakedirectoryvalue:
	db 78
	db 101
	db 119
	ds 13
; 231 uint8_t FtpMakeDirectorySelectPos = 0;
ftpmakedirectoryselectpos:
	db 0
; 11 void ESPErrorParserA() {
esperrorparsera:
; 12     if (a > 0) {
	or a
	jp z, l_812
; 13         push_pop(bc) {
	push bc
; 14             b = a;
	ld b, a
; 15             if ((a = b) == ESPError_FtpDeleteFileError) {
	ld a, b
	cp 1
	jp nz, l_814
; 16                 AllertOkViewShowHL(hl = StringLocaleNetFtpDeleteFileError);
	ld hl, stringlocalenetftpdeletefileerro
	call allertokviewshowhl
	jp l_815
l_814:
; 17             } else if ((a = b) == ESPError_FtpConnectError) {
	ld a, b
	cp 2
	jp nz, l_816
; 18                 AllertOkViewShowHL(hl = StringLocaleNetFtpConnectError);
	ld hl, stringlocalenetftpconnecterror
	call allertokviewshowhl
	jp l_817
l_816:
; 19             } else if ((a = b) == ESPError_WiFiConnectError) {
	ld a, b
	cp 3
	jp nz, l_818
; 20                 AllertOkViewShowHL(hl = StringLocaleNetWiFiConnectError);
	ld hl, stringlocalenetwificonnecterror
	call allertokviewshowhl
l_818:
l_817:
l_815:
	pop bc
; 21             }
; 22         }
; 23         // Сброс ошибки
; 24         NetErrorClear();
	call neterrorclear
l_812:
	ret
; 1 unsigned char FONT_8_8_RUS[] = {
font_8_8_rus:
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 126
	db 129
	db 165
	db 129
	db 189
	db 153
	db 129
	db 126
	db 126
	db 255
	db 219
	db 255
	db 195
	db 231
	db 255
	db 126
	db 108
	db 254
	db 254
	db 254
	db 124
	db 56
	db 16
	db 0
	db 16
	db 56
	db 124
	db 254
	db 124
	db 56
	db 16
	db 0
	db 56
	db 124
	db 56
	db 254
	db 254
	db 214
	db 16
	db 56
	db 16
	db 16
	db 56
	db 124
	db 254
	db 124
	db 16
	db 56
	db 0
	db 0
	db 24
	db 60
	db 60
	db 24
	db 0
	db 0
	db 255
	db 255
	db 231
	db 195
	db 195
	db 231
	db 255
	db 255
	db 0
	db 60
	db 102
	db 66
	db 66
	db 102
	db 60
	db 0
	db 255
	db 195
	db 153
	db 189
	db 189
	db 153
	db 195
	db 255
	db 15
	db 7
	db 15
	db 125
	db 204
	db 204
	db 204
	db 120
	db 60
	db 102
	db 102
	db 102
	db 60
	db 24
	db 126
	db 24
	db 63
	db 51
	db 63
	db 48
	db 48
	db 112
	db 240
	db 224
	db 127
	db 99
	db 127
	db 99
	db 99
	db 103
	db 230
	db 192
	db 24
	db 219
	db 60
	db 231
	db 231
	db 60
	db 219
	db 24
	db 128
	db 224
	db 248
	db 254
	db 248
	db 224
	db 128
	db 0
	db 2
	db 14
	db 62
	db 254
	db 62
	db 14
	db 2
	db 0
	db 24
	db 60
	db 126
	db 24
	db 24
	db 126
	db 60
	db 24
	db 102
	db 102
	db 102
	db 102
	db 102
	db 0
	db 102
	db 0
	db 127
	db 219
	db 219
	db 123
	db 27
	db 27
	db 27
	db 0
	db 60
	db 96
	db 60
	db 102
	db 102
	db 60
	db 6
	db 60
	db 0
	db 0
	db 0
	db 0
	db 126
	db 126
	db 126
	db 0
	db 24
	db 60
	db 126
	db 24
	db 126
	db 60
	db 24
	db 126
	db 24
	db 60
	db 126
	db 24
	db 24
	db 24
	db 24
	db 0
	db 24
	db 24
	db 24
	db 24
	db 126
	db 60
	db 24
	db 0
	db 0
	db 24
	db 12
	db 254
	db 12
	db 24
	db 0
	db 0
	db 0
	db 48
	db 96
	db 254
	db 96
	db 48
	db 0
	db 0
	db 0
	db 0
	db 192
	db 192
	db 192
	db 254
	db 0
	db 0
	db 0
	db 36
	db 102
	db 255
	db 102
	db 36
	db 0
	db 0
	db 0
	db 16
	db 56
	db 124
	db 254
	db 254
	db 0
	db 0
	db 0
	db 254
	db 254
	db 124
	db 56
	db 16
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 48
	db 120
	db 120
	db 48
	db 48
	db 0
	db 48
	db 0
	db 102
	db 102
	db 68
	db 0
	db 0
	db 0
	db 0
	db 0
	db 108
	db 108
	db 254
	db 108
	db 254
	db 108
	db 108
	db 0
	db 24
	db 62
	db 96
	db 60
	db 6
	db 124
	db 24
	db 0
	db 98
	db 102
	db 12
	db 24
	db 48
	db 102
	db 70
	db 0
	db 56
	db 108
	db 56
	db 118
	db 220
	db 204
	db 118
	db 0
	db 48
	db 48
	db 96
	db 0
	db 0
	db 0
	db 0
	db 0
	db 12
	db 24
	db 48
	db 48
	db 48
	db 24
	db 12
	db 0
	db 48
	db 24
	db 12
	db 12
	db 12
	db 24
	db 48
	db 0
	db 0
	db 102
	db 60
	db 255
	db 60
	db 102
	db 0
	db 0
	db 0
	db 24
	db 24
	db 126
	db 24
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 48
	db 48
	db 96
	db 0
	db 0
	db 0
	db 126
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 48
	db 48
	db 0
	db 6
	db 12
	db 24
	db 48
	db 96
	db 192
	db 128
	db 0
	db 124
	db 198
	db 206
	db 222
	db 246
	db 230
	db 124
	db 0
	db 24
	db 56
	db 24
	db 24
	db 24
	db 24
	db 126
	db 0
	db 60
	db 102
	db 6
	db 28
	db 48
	db 102
	db 126
	db 0
	db 60
	db 102
	db 6
	db 28
	db 6
	db 102
	db 60
	db 0
	db 28
	db 60
	db 108
	db 204
	db 254
	db 12
	db 30
	db 0
	db 126
	db 96
	db 124
	db 6
	db 6
	db 102
	db 60
	db 0
	db 28
	db 48
	db 96
	db 124
	db 102
	db 102
	db 60
	db 0
	db 126
	db 102
	db 6
	db 12
	db 24
	db 24
	db 24
	db 0
	db 60
	db 102
	db 102
	db 60
	db 102
	db 102
	db 60
	db 0
	db 60
	db 102
	db 102
	db 62
	db 6
	db 12
	db 56
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 96
	db 12
	db 24
	db 48
	db 96
	db 48
	db 24
	db 12
	db 0
	db 0
	db 0
	db 126
	db 0
	db 0
	db 126
	db 0
	db 0
	db 96
	db 48
	db 24
	db 12
	db 24
	db 48
	db 96
	db 0
	db 60
	db 102
	db 6
	db 12
	db 24
	db 0
	db 24
	db 0
	db 124
	db 198
	db 222
	db 222
	db 222
	db 192
	db 120
	db 0
	db 24
	db 60
	db 102
	db 102
	db 126
	db 102
	db 102
	db 0
	db 252
	db 102
	db 102
	db 124
	db 102
	db 102
	db 252
	db 0
	db 60
	db 102
	db 192
	db 192
	db 192
	db 102
	db 60
	db 0
	db 248
	db 108
	db 102
	db 102
	db 102
	db 108
	db 248
	db 0
	db 254
	db 98
	db 104
	db 120
	db 104
	db 98
	db 254
	db 0
	db 254
	db 98
	db 104
	db 120
	db 104
	db 96
	db 240
	db 0
	db 60
	db 102
	db 192
	db 192
	db 206
	db 102
	db 62
	db 0
	db 102
	db 102
	db 102
	db 126
	db 102
	db 102
	db 102
	db 0
	db 60
	db 24
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 30
	db 12
	db 12
	db 12
	db 204
	db 204
	db 120
	db 0
	db 230
	db 102
	db 108
	db 120
	db 108
	db 102
	db 230
	db 0
	db 240
	db 96
	db 96
	db 96
	db 98
	db 102
	db 254
	db 0
	db 198
	db 238
	db 254
	db 254
	db 214
	db 198
	db 198
	db 0
	db 198
	db 230
	db 246
	db 222
	db 206
	db 198
	db 198
	db 0
	db 56
	db 108
	db 198
	db 198
	db 198
	db 108
	db 56
	db 0
	db 252
	db 102
	db 102
	db 124
	db 96
	db 96
	db 240
	db 0
	db 60
	db 102
	db 102
	db 102
	db 110
	db 60
	db 14
	db 0
	db 252
	db 102
	db 102
	db 124
	db 108
	db 102
	db 230
	db 0
	db 60
	db 102
	db 48
	db 24
	db 12
	db 102
	db 60
	db 0
	db 126
	db 90
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 102
	db 102
	db 102
	db 102
	db 102
	db 102
	db 60
	db 0
	db 102
	db 102
	db 102
	db 102
	db 102
	db 60
	db 24
	db 0
	db 198
	db 198
	db 198
	db 214
	db 254
	db 238
	db 198
	db 0
	db 198
	db 198
	db 108
	db 56
	db 56
	db 108
	db 198
	db 0
	db 102
	db 102
	db 102
	db 60
	db 24
	db 24
	db 60
	db 0
	db 254
	db 198
	db 140
	db 24
	db 50
	db 102
	db 254
	db 0
	db 60
	db 48
	db 48
	db 48
	db 48
	db 48
	db 60
	db 0
	db 192
	db 96
	db 48
	db 24
	db 12
	db 6
	db 2
	db 0
	db 60
	db 12
	db 12
	db 12
	db 12
	db 12
	db 60
	db 0
	db 16
	db 56
	db 108
	db 198
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 48
	db 48
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 120
	db 12
	db 124
	db 204
	db 118
	db 0
	db 224
	db 96
	db 96
	db 124
	db 102
	db 102
	db 220
	db 0
	db 0
	db 0
	db 60
	db 96
	db 96
	db 96
	db 60
	db 0
	db 28
	db 12
	db 12
	db 124
	db 204
	db 204
	db 118
	db 0
	db 0
	db 0
	db 60
	db 102
	db 126
	db 96
	db 60
	db 0
	db 28
	db 54
	db 48
	db 120
	db 48
	db 48
	db 120
	db 0
	db 0
	db 0
	db 118
	db 204
	db 204
	db 124
	db 12
	db 248
	db 224
	db 96
	db 108
	db 118
	db 102
	db 102
	db 230
	db 0
	db 24
	db 0
	db 56
	db 24
	db 24
	db 24
	db 60
	db 0
	db 6
	db 0
	db 6
	db 6
	db 6
	db 102
	db 102
	db 60
	db 224
	db 96
	db 102
	db 108
	db 120
	db 108
	db 230
	db 0
	db 56
	db 24
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 0
	db 0
	db 204
	db 254
	db 254
	db 214
	db 198
	db 0
	db 0
	db 0
	db 220
	db 102
	db 102
	db 102
	db 102
	db 0
	db 0
	db 0
	db 60
	db 102
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 220
	db 102
	db 102
	db 124
	db 96
	db 240
	db 0
	db 0
	db 118
	db 204
	db 204
	db 124
	db 12
	db 30
	db 0
	db 0
	db 220
	db 118
	db 102
	db 96
	db 240
	db 0
	db 0
	db 0
	db 62
	db 96
	db 60
	db 6
	db 124
	db 0
	db 16
	db 48
	db 124
	db 48
	db 48
	db 54
	db 28
	db 0
	db 0
	db 0
	db 204
	db 204
	db 204
	db 204
	db 118
	db 0
	db 0
	db 0
	db 102
	db 102
	db 102
	db 60
	db 24
	db 0
	db 0
	db 0
	db 198
	db 214
	db 254
	db 254
	db 108
	db 0
	db 0
	db 0
	db 198
	db 108
	db 56
	db 108
	db 198
	db 0
	db 0
	db 0
	db 102
	db 102
	db 102
	db 62
	db 6
	db 124
	db 0
	db 0
	db 126
	db 76
	db 24
	db 50
	db 126
	db 0
	db 14
	db 24
	db 24
	db 112
	db 24
	db 24
	db 14
	db 0
	db 24
	db 24
	db 24
	db 0
	db 24
	db 24
	db 24
	db 0
	db 112
	db 24
	db 24
	db 14
	db 24
	db 24
	db 112
	db 0
	db 118
	db 220
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 16
	db 56
	db 108
	db 198
	db 198
	db 254
	db 0
	db 30
	db 54
	db 102
	db 198
	db 254
	db 198
	db 198
	db 0
	db 252
	db 192
	db 192
	db 252
	db 198
	db 198
	db 252
	db 0
	db 248
	db 204
	db 204
	db 252
	db 198
	db 198
	db 252
	db 0
	db 126
	db 96
	db 96
	db 96
	db 96
	db 96
	db 96
	db 0
	db 30
	db 54
	db 102
	db 102
	db 102
	db 102
	db 255
	db 195
	db 252
	db 192
	db 192
	db 248
	db 192
	db 192
	db 254
	db 0
	db 219
	db 219
	db 126
	db 60
	db 126
	db 219
	db 219
	db 0
	db 60
	db 102
	db 6
	db 60
	db 6
	db 198
	db 124
	db 0
	db 198
	db 198
	db 206
	db 222
	db 246
	db 230
	db 198
	db 0
	db 186
	db 198
	db 206
	db 222
	db 246
	db 230
	db 198
	db 0
	db 198
	db 204
	db 216
	db 248
	db 204
	db 198
	db 198
	db 0
	db 30
	db 54
	db 102
	db 102
	db 102
	db 102
	db 230
	db 0
	db 198
	db 238
	db 254
	db 214
	db 198
	db 198
	db 198
	db 0
	db 198
	db 198
	db 198
	db 254
	db 198
	db 198
	db 198
	db 0
	db 124
	db 198
	db 198
	db 198
	db 198
	db 198
	db 124
	db 0
	db 254
	db 198
	db 198
	db 198
	db 198
	db 198
	db 198
	db 0
	db 252
	db 198
	db 198
	db 252
	db 192
	db 192
	db 192
	db 0
	db 124
	db 198
	db 192
	db 192
	db 192
	db 198
	db 124
	db 0
	db 126
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 0
	db 198
	db 198
	db 198
	db 126
	db 6
	db 198
	db 124
	db 0
	db 24
	db 126
	db 219
	db 219
	db 219
	db 126
	db 24
	db 0
	db 198
	db 108
	db 56
	db 56
	db 108
	db 198
	db 198
	db 0
	db 204
	db 204
	db 204
	db 204
	db 204
	db 204
	db 254
	db 6
	db 198
	db 198
	db 198
	db 126
	db 6
	db 6
	db 6
	db 0
	db 214
	db 214
	db 214
	db 214
	db 214
	db 214
	db 254
	db 0
	db 214
	db 214
	db 214
	db 214
	db 214
	db 214
	db 255
	db 3
	db 240
	db 48
	db 48
	db 62
	db 51
	db 51
	db 62
	db 0
	db 198
	db 198
	db 198
	db 246
	db 218
	db 218
	db 246
	db 0
	db 192
	db 192
	db 192
	db 252
	db 198
	db 198
	db 252
	db 0
	db 124
	db 198
	db 6
	db 30
	db 6
	db 198
	db 124
	db 0
	db 204
	db 222
	db 182
	db 246
	db 182
	db 222
	db 204
	db 0
	db 126
	db 198
	db 198
	db 126
	db 54
	db 102
	db 198
	db 0
	db 0
	db 0
	db 120
	db 12
	db 124
	db 204
	db 126
	db 0
	db 6
	db 60
	db 96
	db 124
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 248
	db 204
	db 248
	db 198
	db 252
	db 0
	db 0
	db 0
	db 126
	db 96
	db 96
	db 96
	db 96
	db 0
	db 0
	db 0
	db 30
	db 54
	db 102
	db 102
	db 255
	db 195
	db 0
	db 0
	db 60
	db 102
	db 126
	db 96
	db 62
	db 0
	db 0
	db 0
	db 219
	db 126
	db 60
	db 126
	db 219
	db 0
	db 0
	db 0
	db 60
	db 102
	db 12
	db 102
	db 60
	db 0
	db 0
	db 0
	db 102
	db 110
	db 126
	db 118
	db 102
	db 0
	db 24
	db 0
	db 102
	db 110
	db 126
	db 118
	db 102
	db 0
	db 0
	db 0
	db 102
	db 108
	db 120
	db 108
	db 102
	db 0
	db 0
	db 0
	db 30
	db 54
	db 102
	db 102
	db 230
	db 0
	db 0
	db 0
	db 198
	db 238
	db 254
	db 214
	db 198
	db 0
	db 0
	db 0
	db 102
	db 102
	db 126
	db 102
	db 102
	db 0
	db 0
	db 0
	db 60
	db 102
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 126
	db 102
	db 102
	db 102
	db 102
	db 0
	db 34
	db 136
	db 34
	db 136
	db 34
	db 136
	db 34
	db 136
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 219
	db 119
	db 219
	db 238
	db 219
	db 119
	db 219
	db 238
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 24
	db 248
	db 24
	db 24
	db 24
	db 108
	db 108
	db 108
	db 236
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 0
	db 252
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 248
	db 24
	db 248
	db 24
	db 24
	db 24
	db 108
	db 108
	db 236
	db 12
	db 236
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 252
	db 12
	db 236
	db 108
	db 108
	db 108
	db 108
	db 108
	db 236
	db 12
	db 252
	db 0
	db 0
	db 0
	db 108
	db 108
	db 108
	db 252
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 248
	db 24
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 248
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 24
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 24
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 255
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 24
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 24
	db 31
	db 24
	db 24
	db 24
	db 108
	db 108
	db 108
	db 111
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 111
	db 96
	db 127
	db 0
	db 0
	db 0
	db 0
	db 0
	db 127
	db 96
	db 111
	db 108
	db 108
	db 108
	db 108
	db 108
	db 239
	db 0
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 0
	db 239
	db 108
	db 108
	db 108
	db 108
	db 108
	db 111
	db 96
	db 111
	db 108
	db 108
	db 108
	db 0
	db 0
	db 255
	db 0
	db 255
	db 0
	db 0
	db 0
	db 108
	db 108
	db 239
	db 0
	db 239
	db 108
	db 108
	db 108
	db 24
	db 24
	db 255
	db 0
	db 255
	db 0
	db 0
	db 0
	db 108
	db 108
	db 108
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 0
	db 255
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 255
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 127
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 31
	db 24
	db 31
	db 0
	db 0
	db 0
	db 0
	db 0
	db 31
	db 24
	db 31
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 127
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 255
	db 108
	db 108
	db 108
	db 108
	db 24
	db 24
	db 255
	db 24
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 31
	db 24
	db 24
	db 24
	db 24
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 0
	db 0
	db 0
	db 0
	db 255
	db 255
	db 255
	db 255
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 255
	db 255
	db 255
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 124
	db 102
	db 102
	db 124
	db 96
	db 96
	db 0
	db 0
	db 60
	db 102
	db 96
	db 102
	db 60
	db 0
	db 0
	db 0
	db 126
	db 24
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 102
	db 102
	db 62
	db 6
	db 102
	db 60
	db 0
	db 24
	db 126
	db 219
	db 219
	db 126
	db 24
	db 24
	db 0
	db 0
	db 198
	db 108
	db 56
	db 108
	db 198
	db 0
	db 0
	db 0
	db 204
	db 204
	db 204
	db 204
	db 254
	db 6
	db 0
	db 0
	db 102
	db 102
	db 62
	db 6
	db 6
	db 0
	db 0
	db 0
	db 214
	db 214
	db 214
	db 214
	db 254
	db 0
	db 0
	db 0
	db 214
	db 214
	db 214
	db 214
	db 255
	db 3
	db 0
	db 0
	db 240
	db 48
	db 62
	db 51
	db 62
	db 0
	db 0
	db 0
	db 198
	db 198
	db 246
	db 218
	db 246
	db 0
	db 0
	db 0
	db 96
	db 96
	db 124
	db 102
	db 124
	db 0
	db 0
	db 0
	db 124
	db 198
	db 30
	db 198
	db 124
	db 0
	db 0
	db 0
	db 220
	db 182
	db 246
	db 182
	db 220
	db 0
	db 0
	db 0
	db 62
	db 102
	db 62
	db 54
	db 102
	db 0
	db 0
	db 254
	db 0
	db 254
	db 0
	db 254
	db 0
	db 0
	db 24
	db 24
	db 126
	db 24
	db 24
	db 0
	db 126
	db 0
	db 48
	db 24
	db 12
	db 24
	db 48
	db 0
	db 126
	db 0
	db 12
	db 24
	db 48
	db 24
	db 12
	db 0
	db 126
	db 0
	db 12
	db 30
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 120
	db 48
	db 0
	db 0
	db 0
	db 24
	db 0
	db 126
	db 0
	db 24
	db 0
	db 0
	db 118
	db 220
	db 0
	db 118
	db 220
	db 0
	db 0
	db 120
	db 204
	db 204
	db 120
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 24
	db 0
	db 0
	db 0
	db 31
	db 24
	db 24
	db 24
	db 248
	db 56
	db 24
	db 0
	db 216
	db 108
	db 108
	db 108
	db 0
	db 0
	db 0
	db 0
	db 112
	db 216
	db 48
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 60
	db 60
	db 60
	db 60
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 11 uint8_t vboxOpenHLDEColor = 0;
vboxopenhldecolor:
	db 0
; 12 uint8_t vboxOpenHLDEAccum = 0;
vboxopenhldeaccum:
	db 0
; 18 void vboxOpenHLDECA() {
vboxopenhldeca:
; 19     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 20     //push_pop(hl, de, bc, a) {
; 21         vboxOpenHLDEAccum = a;
	ld (vboxopenhldeaccum), a
; 22         a = c;
	ld a, c
; 23         vboxOpenHLDEColor = a;
	ld (vboxopenhldecolor), a
; 24         //HL Начальный адрес
; 25         a = l;
	ld a, l
; 26         a &= 0x1F;
	and 31
; 27         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 28         l = a;
	ld l, a
; 29         a = h;
	ld a, h
; 30         a += 0xC0;
	add 192
; 31         h = a;
	ld h, a
; 32         //BC Размер
; 33         b = d;
	ld b, d
; 34         a = e;
	ld a, e
; 35         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 36         c = a;
	ld c, a
; 37         //DE цвет
; 38         d = 0x07; //0x00; //Тень
	ld d, 7
; 39         a = vboxOpenHLDEColor;
	ld a, (vboxopenhldecolor)
; 40         e = a;
	ld e, a
; 41         a = vboxOpenHLDEAccum;
	ld a, (vboxopenhldeaccum)
; 42         vboxOpen();
	call vboxopen
	pop hl
	pop de
	pop bc
	ret
; 43     }
; 44 }
; 45 
; 46 void vboxClearCash() {
vboxclearcash:
; 47     push_pop(a) {
	push af
; 48         do {
l_820:
; 49             a = vboxBLW;
	ld a, 16
; 50             a |= vboxERA;
	or 8
; 51             a |= vboxUMP;
	or 4
; 52             vboxCall();
	call vboxcall
l_821:
; 53         } while (a == 0x00);
	or a
	jp z, l_820
	pop af
	ret
; 54     }
; 55 }
; 56 
; 57 /// HL верхний левый угол
; 58 /// DE нижний правый
; 59 void vboxBorderHLDE() {
vboxborderhlde:
; 60     push_pop(bc) {
	push bc
; 61         //Верхняя линия
; 62         push_pop(hl, de) {
	push hl
	push de
; 63             a = h;
	ld a, h
; 64             myCharPosX = a;
	ld (mycharposx), a
; 65             a = l;
	ld a, l
; 66             myCharPosY = a;
	ld (mycharposy), a
; 67             printMyCharA(a = 0xC9);
	ld a, 201
	call printmychara
; 68             b = 2;
	ld b, 2
; 69             do {
l_823:
; 70                 printMyCharA(a = 0xCD);
	ld a, 205
	call printmychara
; 71                 b++;
	inc b
l_824:
; 72             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, l_823
; 73             printMyCharA(a = 0xBB);
	ld a, 187
	call printmychara
	pop de
	pop hl
; 74         }
; 75         // Нижняя линия
; 76         push_pop(hl, de) {
	push hl
	push de
; 77             a = h;
	ld a, h
; 78             myCharPosX = a;
	ld (mycharposx), a
; 79             a = l;
	ld a, l
; 80             a += e;
	add e
; 81             a--;
	dec a
; 82             myCharPosY = a;
	ld (mycharposy), a
; 83             printMyCharA(a = 0xC8);
	ld a, 200
	call printmychara
; 84             b = 2;
	ld b, 2
; 85             do {
l_826:
; 86                 printMyCharA(a = 0xCD);
	ld a, 205
	call printmychara
; 87                 b++;
	inc b
l_827:
; 88             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, l_826
; 89             printMyCharA(a = 0xBC);
	ld a, 188
	call printmychara
	pop de
	pop hl
; 90         }
; 91         // Левая горизонтальная
; 92         push_pop(hl, de) {
	push hl
	push de
; 93             a = h;
	ld a, h
; 94             myCharPosX = a;
	ld (mycharposx), a
; 95             a = l;
	ld a, l
; 96             a++;
	inc a
; 97             myCharPosY = a;
	ld (mycharposy), a
; 98             b = 2;
	ld b, 2
; 99             do {
l_829:
; 100                 printMyCharA(a = 0xBA);
	ld a, 186
	call printmychara
; 101                 a = h;
	ld a, h
; 102                 myCharPosX = a;
	ld (mycharposx), a
; 103                 a = l;
	ld a, l
; 104                 a += b;
	add b
; 105                 myCharPosY = a;
	ld (mycharposy), a
; 106                 b++;
	inc b
l_830:
; 107             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, l_829
	pop de
	pop hl
; 108         }
; 109         // Правая горизонтальная
; 110         push_pop(hl, de) {
	push hl
	push de
; 111             a = h;
	ld a, h
; 112             a += d;
	add d
; 113             a--;
	dec a
; 114             c = a;
	ld c, a
; 115             myCharPosX = a;
	ld (mycharposx), a
; 116             a = l;
	ld a, l
; 117             a++;
	inc a
; 118             myCharPosY = a;
	ld (mycharposy), a
; 119             b = 2;
	ld b, 2
; 120             do {
l_832:
; 121                 printMyCharA(a = 0xBA);
	ld a, 186
	call printmychara
; 122                 a = c;
	ld a, c
; 123                 myCharPosX = a;
	ld (mycharposx), a
; 124                 a = l;
	ld a, l
; 125                 a += b;
	add b
; 126                 myCharPosY = a;
	ld (mycharposy), a
; 127                 b++;
	inc b
l_833:
; 128             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, l_832
	pop de
	pop hl
	pop bc
	ret
; 129         }
; 130     }
; 131 }
; 132 
; 133 void vboxOpenHLDE() {
vboxopenhlde:
; 134     c = a;
	ld c, a
; 135     a = vboxCLW;
	ld a, 64
; 136     a |= vboxUMP;
	or 4
; 137     vboxOpenHLDECA();
	jp vboxopenhldeca
; 138 }
; 139 
; 140 /// Загрузка драйвера VBOX, если не загружен
; 141 void validVBOX() {
validvbox:
; 142     a = vboxAddr; // 0 - если там знакогенератор
	ld a, (vboxaddr)
; 143     a |= a;
	or a
; 144     if (a == 0) {
	or a
	jp nz, l_835
; 145         push_pop(bc, hl) {
	push bc
	push hl
; 146             ordos_sdma(hl = vboxFL);
	ld hl, vboxfl
	call ordos_sdma
; 147             b = 0;
	ld b, 0
; 148             do {
l_837:
; 149                 a = 'A';
	ld a, 65
; 150                 a += b;
	add b
; 151                 ordos_wnd(); // A = Disk
	call ordos_wnd
; 152                 ordos_pscf();
	call ordos_pscf
; 153                 c = a;
	ld c, a
; 154                 b++;
	inc b
; 155                 if ((a = b) == 4) {
	ld a, b
	cp 4
	jp nz, l_840
; 156                     c = 1;
	ld c, 1
l_840:
l_838:
; 157                 }
; 158             } while ((a = c) == 0);
	ld a, c
	or a
	jp z, l_837
; 159             if ((a = c) == 0xFF) {
	ld a, c
	cp 255
	jp nz, l_842
; 160                 loadVBOX();
	call loadvbox
l_842:
	pop hl
	pop bc
l_835:
	ret
; 161             }
; 162         }
; 163     }
; 164 }
; 165 
; 166 /// Загрузка
; 167 void loadVBOX() {
loadvbox:
; 168     ordos_rfile();
	call ordos_rfile
; 169     startVboxAddr = hl;
	ld (startvboxaddr), hl
	ret
; 170 }
; 171 
; 172 void vboxOpen() {
vboxopen:
; 173     a |= vboxOPN;
	or 128
; 174     vboxCall();
	jp vboxcall
; 175 }
; 176 
; 177 void vboxClose() {
vboxclose:
; 178     push_pop(a) {
	push af
; 179         a = vboxERA;
	ld a, 8
; 180         a |= vboxUMP;
	or 4
; 181         vboxCall();
	call vboxcall
	pop af
	ret
; 182     }
; 183 }
; 184 
; 185 void vboxCall() {
vboxcall:
; 186     push_pop(a) {
	push af
; 187         push_pop(bc) {
	push bc
; 188             push_pop(de) {
	push de
; 189                 push_pop(hl) {
	push hl
; 190                     ordos_rnd();
	call ordos_rnd
; 191                     push_pop(a) {
	push af
; 192                         validVBOX();
	call validvbox
	pop af
; 193                     }
; 194                     ordos_wnd();
	call ordos_wnd
	pop hl
	pop de
	pop bc
	pop af
; 195                 }
; 196             }
; 197         }
; 198     }
; 199     a |= 0x03; //0x03; //0x01; //ADD disk
	or 3
; 200     goToVBOX();
	jp gotovbox
; 201 }
; 202 
; 203 uint8_t vboxFL[] = "VBOX "; // Имя файла
vboxfl:
	db 86
	db 66
	db 79
	db 88
	db 32
	ds 1
; 204 uint16_t vboxAddr = 0xF000;
vboxaddr:
	dw 61440
; 43 uint8_t Net_buffer_len = 0;
net_buffer_len:
	db 0
; 44 uint8_t Net_buffer[1];
net_buffer:
	ds 1
 savebin "kFTP2.ORD", 0x00f0, 0x3510
 savebin "test.ORD", 0x00f0, 0x3510
