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
diskviewresidentprogram equ 43008
gotovbox equ 262

    org 0x00F0

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

    DB 0x00, 0x3A

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
; 60         DiskViewReload();
; 61     #else
; 62         NetUpdateData();
	call netupdatedata
; 63         ThreadsTickNow();
	call threadsticknow
; 64     #endif
; 65     
; 66     for(;;){
__l_1:
; 67         #ifdef _IS_SIMULATOR
; 68             getKeyboardCharA();
; 69             KeyboardEventA();
; 70         #else
; 71             getKeyboardStateA();
	call getkeyboardstatea
; 72             if (a == 0xFF) {
	cp 255
	jp nz, __l_3
; 73                 getKeyboardCodeA();
	call getkeyboardcodea
; 74                 KeyboardEventA();
	call keyboardeventa
	jp __l_4
__l_3:
; 75             } else {
; 76                 ThreadsTick();
	call threadstick
__l_4:
	jp __l_1
; 77             }
; 78         #endif
; 79     }
; 80 }
; 81 
; 82 void KeyboardEventA() {
keyboardeventa:
; 83     push_pop(bc) {
	push bc
; 84         b = a; //Save
	ld b, a
; 85         if ((a = b) == 0x03) { //F4
	ld a, b
	cp 3
	jp nz, __l_5
; 86             vboxClearCash();
	call vboxclearcash
; 87             ordos_start();
	call ordos_start
	jp __l_6
__l_5:
; 88         } else if ((a = b) == 0x02) { //F3 Open FTP settings
	ld a, b
	cp 2
	jp nz, __l_7
; 89             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 90             if (a == 1) {
	cp 1
	jp nz, __l_9
; 91                 FtpSettingsViewShow();
	call ftpsettingsviewshow
__l_9:
	jp __l_8
__l_7:
; 92             }
; 93         } else if ((a = b) == 0x01) { //F2 Open WiFi settings
	ld a, b
	cp 1
	jp nz, __l_11
; 94             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 95             if (a == 1) {
	cp 1
	jp nz, __l_13
; 96                 WiFiSettingsViewShow();
	call wifisettingsviewshow
__l_13:
	jp __l_12
__l_11:
; 97             }
; 98         } else if ((a = b) == 0x00) { //F1 Open help
	ld a, b
	or a
	jp nz, __l_15
; 99             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 100             if (a == 1) {
	cp 1
	jp nz, __l_17
; 101                 HelpInfoViewShow();
	call helpinfoviewshow
__l_17:
__l_15:
__l_12:
__l_8:
__l_6:
; 102             }
; 103         }
; 104         
; 105         c = 0;
	ld c, 0
; 106         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_19
; 107             DiskViewKeyA(a = b);
	ld a, b
	call diskviewkeya
; 108             c = 1;
	ld c, 1
	jp __l_20
__l_19:
; 109         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_21
; 110             FtpViewKeyA(a = b);
	ld a, b
	call ftpviewkeya
; 111             c = 1;
	ld c, 1
	jp __l_22
__l_21:
; 112         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, __l_23
; 113             SelectDiskViewKeyA(a = b);
	ld a, b
	call selectdiskviewkeya
; 114             c = 1;
	ld c, 1
	jp __l_24
__l_23:
; 115         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_25
; 116             WiFiSettingsViewKeyA(a = b);
	ld a, b
	call wifisettingsviewkeya
; 117             c = 1;
	ld c, 1
	jp __l_26
__l_25:
; 118         } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, __l_27
; 119             WiFiNetworksViewKeyA(a = b);
	ld a, b
	call wifinetworksviewkeya
; 120             c = 1;
	ld c, 1
	jp __l_28
__l_27:
; 121         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_29
; 122             FtpSettingsViewKeyA(a = b);
	ld a, b
	call ftpsettingsviewkeya
; 123             c = 1;
	ld c, 1
	jp __l_30
__l_29:
; 124         } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, __l_31
; 125             FtpMakeDirectoryKeyA(a = b);
	ld a, b
	call ftpmakedirectorykeya
; 126             c = 1;
	ld c, 1
	jp __l_32
__l_31:
; 127         } else if ((a = CurrentViewId) == HelpInfoViewId) {
	ld a, (currentviewid)
	cp 12
	jp nz, __l_33
; 128             HelpInfoViewKeyA(a = b);
	ld a, b
	call helpinfoviewkeya
; 129             c = 1;
	ld c, 1
__l_33:
__l_32:
__l_30:
__l_28:
__l_26:
__l_24:
__l_22:
__l_20:
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
__l_35:
; 24             a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 25             a &= ESP_Reg_Ready;
	and 2
; 26             c = a;
	ld c, a
__l_36:
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
	jp z, __l_35
	pop bc
	ret
; 39     }
; 40 }
; 41 
; 42 /// Проверка что ESP занят
; 43 void i8255_WaitingForBusy() {
i8255_waitingforbusy:
; 44     do {
__l_38:
; 45         a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 46         a &= ESP_Reg_Busy;
	and 1
__l_39:
; 47     } while (a > 0);
	or a
	jp nz, __l_38
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
__l_41:
; 76         nop();
	nop
; 77         a--;
	dec a
__l_42:
; 78     } while (a > 0);
	or a
	jp nz, __l_41
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
	jp nz, __l_44
; 65             a = c;
	ld a, c
; 66             a |= ESP_Reg_IsEnd;
	or 128
; 67             c = a;
	ld c, a
__l_44:
; 68         }
; 69         ESPSendByteAC(a = h);
	ld a, h
	call espsendbyteac
; 70         if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
	ld a, (esperror)
	or a
	jp nz, __l_46
; 71             //-- Send Data
; 72             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_48
; 73                 b = l;
	ld b, l
; 74                 hl = Net_buffer;
	ld hl, net_buffer
; 75                 do {
__l_50:
; 76                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_53
; 77                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp __l_54
__l_53:
; 78                     } else {
; 79                         c = 0;
	ld c, 0
__l_54:
; 80                     }
; 81                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 82                     if ((a = ESPError) > 0) { // Есть ошибки - выходим
	ld a, (esperror)
	or a
	jp z, __l_55
; 83                         b = 1;
	ld b, 1
__l_55:
; 84                     }
; 85                     hl++;
	inc hl
; 86                     b--;
	dec b
__l_51:
; 87                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_50
__l_48:
__l_46:
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
	jp nz, __l_57
; 103             //-- Send Data
; 104             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_59
; 105                 b = l;
	ld b, l
; 106                 hl = Net_buffer;
	ld hl, net_buffer
; 107                 do {
__l_61:
; 108                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_64
; 109                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp __l_65
__l_64:
; 110                     } else {
; 111                         c = 0;
	ld c, 0
__l_65:
; 112                     }
; 113                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 114                     hl++;
	inc hl
; 115                     b--;
	dec b
__l_62:
; 116                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_61
__l_59:
; 117             }
; 118             //-- Get Data
; 119             b = 0;
	ld b, 0
; 120             hl = Net_buffer;
	ld hl, net_buffer
; 121             c = 1;
	ld c, 1
; 122             do {
__l_66:
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
	jp nz, __l_69
; 130                     a = ESP_Reg_In_IsEnd;
	ld a, 8
; 131                     a &= d;
	and d
; 132                     if (a > 0) {
	or a
	jp z, __l_71
; 133                         c = 0;
	ld c, 0
__l_71:
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
	jp nz, __l_73
; 140                         c = 0;
	ld c, 0
__l_73:
	jp __l_70
__l_69:
; 141                     }
; 142                 } else {
; 143                     c = 0;
	ld c, 0
__l_70:
__l_67:
; 144                 }
; 145             } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, __l_66
; 146             l = b;
	ld l, b
__l_57:
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
__l_75:
; 193             h = 17; // SSID_LIST_NEXT, // 17
	ld h, 17
; 194             l = 0; // Len NedBuffer
	ld l, 0
; 195             ESPSendAndGetHL();
	call espsendandgethl
; 196             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_78
; 197                 b = l;
	ld b, l
; 198                 //--
; 199                 hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 200                 d = 0;
	ld d, 0
; 201                 a ^= a;
	xor a
; 202                 a = c;
	ld a, c
; 203                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 204                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_80
; 205                     d++;
	inc d
__l_80:
; 206                 }
; 207                 e = a;
	ld e, a
; 208                 hl += de;
	add hl, de
; 209                 push_pop(bc) {
	push bc
; 210                     c = b;
	ld c, b
; 211                     b = 16;
	ld b, 16
; 212                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 213                 }
; 214                 //--
; 215                 c++;
	inc c
__l_78:
__l_76:
; 216             }
; 217         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_75
; 218         a = c;
	ld a, c
; 219         WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
	pop de
	pop bc
	pop hl
	ret
; 220     }
; 221 }
; 222 
; 223 void NetWiFiSetListA() {
netwifisetlista:
; 224     push_pop(hl) {
	push hl
; 225         hl = Net_buffer;
	ld hl, net_buffer
; 226         *hl = a;
	ld (hl), a
; 227         h = 18; // SSID_SET_LIST_ID, // 18
	ld h, 18
; 228         l = 1; // Len NedBuffer
	ld l, 1
; 229         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 230     }
; 231 }
; 232 
; 233 void NetWiFiConnect() {
netwificonnect:
; 234     push_pop(hl) {
	push hl
; 235         h = 19; // SSID_CONNECT, // 19
	ld h, 19
; 236         l = 0; // Len NedBuffer
	ld l, 0
; 237         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 238     }
; 239 }
; 240 
; 241 void NetGetAllStatus() {
netgetallstatus:
; 242     push_pop(hl) {
	push hl
; 243         h = 20; //  GET_STATUS, // 20
	ld h, 20
; 244         l = 0; // Len NedBuffer
	ld l, 0
; 245         ESPSendAndGetHL();
	call espsendandgethl
; 246         //--
; 247         NetGetAllStatusParse();
	call netgetallstatusparse
	pop hl
	ret
; 248     }
; 249 }
; 250 
; 251 void NetFtpGoToHomeDir() {
netftpgotohomedir:
; 252     push_pop(hl) {
	push hl
; 253         h = 21; // SET_FTP_TO_HOME_DIR, // 21
	ld h, 21
; 254         l = 0; // Len NedBuffer
	ld l, 0
; 255         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 256     }
; 257 }
; 258 
; 259 void NetFtpGetCurrentPath() {
netftpgetcurrentpath:
; 260     push_pop(hl) {
	push hl
; 261         h = 22; //  GET_FTP_CURRENT_FOLDER, // 22
	ld h, 22
; 262         l = 0; // Len NedBuffer
	ld l, 0
; 263         ESPSendAndGetHL();
	call espsendandgethl
; 264         b = 16;
	ld b, 16
; 265         c = l;
	ld c, l
; 266         hl = FtpViewPath;
	ld hl, ftpviewpath
; 267         ParserBufferToHL();
	call parserbuffertohl
	pop hl
	ret
; 268     }
; 269 }
; 270 
; 271 void NetFtpConnect() {
netftpconnect:
; 272     push_pop(hl) {
	push hl
; 273         h = 23; // FTP_CONNECT, // 23
	ld h, 23
; 274         l = 0; // Len NedBuffer
	ld l, 0
; 275         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 276     }
; 277 }
; 278 
; 279 void NetFtpChangeDirUp() {
netftpchangedirup:
; 280     push_pop(hl) {
	push hl
; 281         h = 24; // SET_FTP_CHANGE_DIR_UP, // 24
	ld h, 24
; 282         l = 0; // Len NedBuffer
	ld l, 0
; 283         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 284     }
; 285 }
; 286 
; 287 void NetFtpChangeDirIndexA() {
netftpchangedirindexa:
; 288     push_pop(hl) {
	push hl
; 289         hl = Net_buffer;
	ld hl, net_buffer
; 290         *hl = a;
	ld (hl), a
; 291         h = 25; // SET_FTP_CHANGE_DIR_INDEX, // 25
	ld h, 25
; 292         l = 1; // Len NedBuffer
	ld l, 1
; 293         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 294     }
; 295 }
; 296 
; 297 void NetFtpUpdateList() {
netftpupdatelist:
; 298     push_pop(hl) {
	push hl
; 299         hl = Net_buffer;
	ld hl, net_buffer
; 300         a = 20; // Получить 20 файлов
	ld a, 20
; 301         *hl = a;
	ld (hl), a
; 302         h = 26; // FTP_UPDATE_LIST, // 26
	ld h, 26
; 303         l = 1; // Len NedBuffer
	ld l, 1
; 304         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 305     }
; 306 }
; 307 
; 308 void NetFtpListFiles() {
netftplistfiles:
; 309     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 310         a = 0;
	ld a, 0
; 311         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
; 312         c = 0;
	ld c, 0
; 313         do {
__l_82:
; 314             //--
; 315             hl = Net_buffer;
	ld hl, net_buffer
; 316             a = NetFtpListFilesParseSumState;
	ld a, (netftplistfilesparsesumstate)
; 317             *hl = a;
	ld (hl), a
; 318             //--
; 319             h = 27; // FTP_LIST_FILE_NEXT, // 27
	ld h, 27
; 320             l = 1; // Len NedBuffer
	ld l, 1
; 321             ESPSendAndGetHL();
	call espsendandgethl
; 322             //--
; 323             NetFtpListFilesParse(); // пока l > 0 (ответ от ESP что то содержит)
	call netftplistfilesparse
__l_83:
; 324         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_82
; 325         a = c;
	ld a, c
; 326         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
	pop de
	pop bc
	pop hl
	ret
; 327     }
; 328 }
; 329 
; 330 void NetFtpLoadFileA() {
netftploadfilea:
; 331     push_pop(hl) {
	push hl
; 332         hl = Net_buffer;
	ld hl, net_buffer
; 333         *hl = a;
	ld (hl), a
; 334         h = 28; // FTP_FILE_DOWNLOAD, // 28
	ld h, 28
; 335         l = 1; // Len NedBuffer
	ld l, 1
; 336         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 337     }
; 338 }
; 339 
; 340 void NetFtpLoadFileNext() {
netftploadfilenext:
; 341     push_pop(hl) {
	push hl
; 342         a = 1;
	ld a, 1
; 343         NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
; 344         do {
__l_85:
; 345             //--
; 346             hl = Net_buffer;
	ld hl, net_buffer
; 347             a = NetFtpLoadFileNextParseSumState;
	ld a, (netftploadfilenextparsesumstate)
; 348             *hl = a;
	ld (hl), a
; 349             //--
; 350             h = 29; // FTP_FILE_DOWNLOAD_NEXT, // 29
	ld h, 29
; 351             l = 1; // Len NedBuffer
	ld l, 1
; 352             ESPSendAndGetHL();
	call espsendandgethl
; 353             //--
; 354             NetFtpLoadFileNextParse();
	call netftploadfilenextparse
__l_86:
; 355         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_85
	pop hl
	ret
; 356     }
; 357 }
; 358 
; 359 void NetErrorClear() {
neterrorclear:
; 360     push_pop(hl) {
	push hl
; 361         h = 30; // ESP_ERROR_CLEAR, // 30
	ld h, 30
; 362         l = 0; // Len NedBuffer
	ld l, 0
; 363         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 364     }
; 365 }
; 366 
; 367 void NetFtpDeleteFileIndexA() {
netftpdeletefileindexa:
; 368     push_pop(hl) {
	push hl
; 369         hl = Net_buffer;
	ld hl, net_buffer
; 370         *hl = a;
	ld (hl), a
; 371         h = 31; // FTP_FILE_DELETE_INDEX, // 31
	ld h, 31
; 372         l = 1; // Len NedBuffer
	ld l, 1
; 373         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 374     }
; 375 }
; 376 
; 377 void NetFtpMakeDirectory() {
netftpmakedirectory:
; 378     push_pop(hl) {
	push hl
; 379         hl = FtpMakeDirectoryValue;
	ld hl, ftpmakedirectoryvalue
; 380         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 381         h = 33; // FTP_MAKE_DIRECTORY, // 33
	ld h, 33
; 382         l = 16; // Len NedBuffer
	ld l, 16
; 383         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 384     }
; 385 }
; 386 
; 387 void NetFtpUploadFileInitHL() {
netftpuploadfileinithl:
; 388     ParserFileUploadInit();
	call parserfileuploadinit
; 389     // Отправляем данные о файле
; 390     push_pop(hl, bc) {
	push hl
	push bc
; 391         ParserFileUploadInit();
	call parserfileuploadinit
; 392         
; 393         ParserHLToBuffer(b = 8);
	ld b, 8
	call parserhltobuffer
; 394         h = 32; // FTP_FILE_UPLOAD_INIT, // 32
	ld h, 32
; 395         l = 8; // Len NedBuffer
	ld l, 8
; 396         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
; 397     }
; 398     // Начинаем передавать содержимое файла
; 399     do {
__l_88:
; 400         ParserFileUploadCreateBuffer();
	call parserfileuploadcreatebuffer
; 401         h = 34; // FTP_FILE_UPLOAD_NEXT, // 34
	ld h, 34
; 402         l = 20; // Len NedBuffer 16 + 1 + 2 + 1 = 20
	ld l, 20
; 403         ESPSendAndGetHL();
	call espsendandgethl
; 404         // Parse 
; 405         // b = 0x3C, b = isCorrect, b = progress, b = sum
; 406         ParserFileUploadParse();
	call parserfileuploadparse
__l_89:
; 407     } while (a > 0);
	or a
	jp nz, __l_88
	ret
; 408 }
; 409 
; 410 // Вых [A] - 1 - Успешно. 0 - Ошибка
; 411 void NetDiskGetNum() {
netdiskgetnum:
; 412     push_pop(hl, bc) {
	push hl
	push bc
; 413         h = 35; // GET_DISK, // 35
	ld h, 35
; 414         l = 0; // Len NedBuffer
	ld l, 0
; 415         ESPSendAndGetHL();
	call espsendandgethl
; 416         ParserFileDiskResponse();
	call parserfilediskresponse
	pop bc
	pop hl
	ret
; 417     }
; 418 }
; 419 
; 420 void NetDiskSetNum() {
netdisksetnum:
; 421     push_pop(hl, bc) {
	push hl
	push bc
; 422         ParserFileDiskRequest();
	call parserfilediskrequest
; 423         h = 36; // SET_DISK, // 36
	ld h, 36
; 424         l = 3; // Len NedBuffer
	ld l, 3
; 425         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 426     }
; 427 }
; 428 
; 429 void NetGetHardwareAndSoftware() {
netgethardwareandsoftware:
; 430     h = 37; // GET_HARDWARE_AND_SOFTWARE, // 37
	ld h, 37
; 431     l = 0; // Len NedBuffer
	ld l, 0
; 432     ESPSendAndGetHL();
	jp espsendandgethl
; 14 void ParserBufferToHL() {
parserbuffertohl:
; 15     push_pop(de) {
	push de
; 16         de = Net_buffer;
	ld de, net_buffer
; 17         do {
__l_91:
; 18             if ((a = c) > 0) {
	ld a, c
	or a
	jp z, __l_94
; 19                 a = *de;
	ld a, (de)
; 20                 *hl = a;
	ld (hl), a
; 21                 c--;
	dec c
; 22                 de++;
	inc de
	jp __l_95
__l_94:
; 23             } else {
; 24                 a = 0;
	ld a, 0
; 25                 *hl = a;
	ld (hl), a
__l_95:
; 26             }
; 27             hl++;
	inc hl
; 28             b--;
	dec b
__l_92:
; 29         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_91
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
__l_96:
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
__l_97:
; 42         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_96
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
	jp nz, __l_99
; 50         NetFtpListFilesParseSum();
	call netftplistfilesparsesum
; 51         if ((a = NetFtpListFilesParseSumState) == 0x01) {
	ld a, (netftplistfilesparsesumstate)
	cp 1
	jp nz, __l_101
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
; 57                 a ^= a;
	xor a
; 58                 a = c;
	ld a, c
; 59                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 60                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_103
; 61                     d++;
	inc d
__l_103:
; 62                 }
; 63                 e = a;
	ld e, a
; 64                 hl += de;
	add hl, de
; 65                 push_pop(bc) {
	push bc
; 66                     c = b;
	ld c, b
; 67                     b = 16;
	ld b, 16
; 68                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 69                 }
; 70                 //--
; 71                 c++;
	inc c
	pop de
	pop hl
__l_101:
	jp __l_100
__l_99:
; 72             }
; 73         }
; 74     } else {
; 75         a = 0x00;
	ld a, 0
; 76         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_100:
	ret
; 77     }
; 78 }
; 79 
; 80 void NetFtpListFilesParseSum() {
netftplistfilesparsesum:
; 81     push_pop(hl, bc) {
	push hl
	push bc
; 82         b = 15;
	ld b, 15
; 83         c = 0;
	ld c, 0
; 84         hl = Net_buffer;
	ld hl, net_buffer
; 85         do {
__l_105:
; 86             a = *hl;
	ld a, (hl)
; 87             a += c;
	add c
; 88             c = a;
	ld c, a
; 89             hl++;
	inc hl
; 90             b--;
	dec b
__l_106:
; 91         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_105
; 92         a = *hl;
	ld a, (hl)
; 93         if (a == c) {
	cp c
	jp nz, __l_108
; 94             a = 0x01;
	ld a, 1
; 95             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
	jp __l_109
__l_108:
; 96         } else {
; 97             a = 0x00;
	ld a, 0
; 98             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_109:
; 99         }
; 100         // 10 byte = 0x3C
; 101         hl = Net_buffer;
	ld hl, net_buffer
; 102         bc = 10;
	ld bc, 10
; 103         hl += bc;
	add hl, bc
; 104         a = *hl;
	ld a, (hl)
; 105         a &= 0xFE;
	and 254
; 106         if (a != 0x3C) {
	cp 60
	jp z, __l_110
; 107             a = 0x00;
	ld a, 0
; 108             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_110:
	pop bc
	pop hl
	ret
; 109         }
; 110     }
; 111 }
; 112 
; 113 void NetFtpLoadFileNextParse() {
netftploadfilenextparse:
; 114     push_pop(hl) {
	push hl
; 115         if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_112
; 116             NetFtpLoadFileNextParseSum();
	call netftploadfilenextparsesum
; 117             if ((a = NetFtpLoadFileNextParseSumState) == 0x01) {
	ld a, (netftploadfilenextparsesumstate)
	cp 1
	jp nz, __l_114
; 118                 push_pop(bc, de) {
	push bc
	push de
; 119                     b = l;
	ld b, l
; 120                     de = Net_buffer;
	ld de, net_buffer
; 121                     //-- Address
; 122                     a = *de;
	ld a, (de)
; 123                     l = a;
	ld l, a
; 124                     de++;
	inc de
; 125                     a = *de;
	ld a, (de)
; 126                     h = a;
	ld h, a
; 127                     NetFtpLoadFileNextParseAddress = hl;
	ld (netftploadfilenextparseaddress), hl
; 128                     de++;
	inc de
; 129                     //-- Progress
; 130                     LoadViewShowProgressA(a = *de);
	ld a, (de)
	call loadviewshowprogressa
; 131                     de++;
	inc de
; 132                     //-- 0x3C
; 133                     de++;
	inc de
; 134                     //--
; 135                     b--;
	dec b
; 136                     b--;
	dec b
; 137                     b--;
	dec b
; 138                     b--;
	dec b
; 139                     b--;
	dec b
; 140                     NetFtpLoadFileNextParseCalkDiskPosToHL();
	call netftploadfilenextparsecalkdiskp
; 141                     do {
__l_116:
; 142                         a = *de;
	ld a, (de)
; 143                         ordos_wdisk();
	call ordos_wdisk
; 144                         hl++;
	inc hl
; 145                         de++;
	inc de
; 146                         b--;
	dec b
__l_117:
; 147                     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_116
; 148                     NetFtpLoadFileNextParseAddressEnd = hl;
	ld (netftploadfilenextparseaddressen), hl
	pop de
	pop bc
__l_114:
	jp __l_113
__l_112:
; 149                 }
; 150             }
; 151         } else {
; 152             hl = NetFtpLoadFileNextParseAddressEnd;
	ld hl, (netftploadfilenextparseaddressen)
; 153             ordos_stop();
	call ordos_stop
__l_113:
	pop hl
	ret
; 154         }
; 155     }
; 156 }
; 157 
; 158 /// Считаем адрес куда писать данные на диск
; 159 void NetFtpLoadFileNextParseCalkDiskPosToHL() {
netftploadfilenextparsecalkdiskp:
; 160     push_pop(de) {
	push de
; 161         // получаем адрес пакета
; 162         hl = NetFtpLoadFileNextParseAddress;
	ld hl, (netftploadfilenextparseaddress)
; 163         // прибавляем к точке начала файла на диске
; 164         d = h;
	ld d, h
; 165         e = l;
	ld e, l
; 166         hl = DiskViewStartNewFile;
	ld hl, (diskviewstartnewfile)
; 167         a ^= a;
	xor a
; 168         a = l;
	ld a, l
; 169         a += e;
	add e
; 170         if (flag_c) {
	jp nc, __l_119
; 171             h++;
	inc h
__l_119:
; 172         }
; 173         l = a;
	ld l, a
; 174         a = h;
	ld a, h
; 175         a += d;
	add d
; 176         h = a;
	ld h, a
; 177         push_pop(hl) {
	push hl
; 178             a = l;
	ld a, l
; 179             a &= 0x01;
	and 1
; 180             if (a > 0) {
	or a
	jp z, __l_121
; 181                 a = 0;
	ld a, 0
; 182                 myCharPosX = a;
	ld (mycharposx), a
; 183                 a = 0;
	ld a, 0
; 184                 myCharPosY = a;
	ld (mycharposy), a
; 185                 printMyHexA(a = h);
	ld a, h
	call printmyhexa
; 186                 printMyHexA(a = l);
	ld a, l
	call printmyhexa
__l_121:
	pop hl
	pop de
	ret
; 187             }
; 188         }
; 189         // В HL адрес записи, полученных данных, на диск
; 190     }
; 191 }
; 192 
; 193 void NetFtpLoadFileNextParseSum() {
netftploadfilenextparsesum:
; 194     push_pop(hl, bc) {
	push hl
	push bc
; 195         b = l;
	ld b, l
; 196         b--;
	dec b
; 197         hl = Net_buffer;
	ld hl, net_buffer
; 198         c = 0;
	ld c, 0
; 199         do {
__l_123:
; 200             a = *hl;
	ld a, (hl)
; 201             a += c;
	add c
; 202             c = a;
	ld c, a
; 203             hl++;
	inc hl
; 204             b--;
	dec b
__l_124:
; 205         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_123
; 206         a = *hl;
	ld a, (hl)
; 207         if (a == c) {
	cp c
	jp nz, __l_126
; 208             a = 0x01;
	ld a, 1
; 209             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
	jp __l_127
__l_126:
; 210         } else {
; 211             a = 0x00;
	ld a, 0
; 212             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
__l_127:
; 213         }
; 214         //-- 3 byte = byte 0x3C
; 215         hl = Net_buffer;
	ld hl, net_buffer
; 216         hl++;
	inc hl
; 217         hl++;
	inc hl
; 218         hl++;
	inc hl
; 219         a = *hl;
	ld a, (hl)
; 220         if (a != 0x3C) {
	cp 60
	jp z, __l_128
; 221             a = 0x00;
	ld a, 0
; 222             NetFtpLoadFileNextParseSumState = a;
	ld (netftploadfilenextparsesumstate), a
__l_128:
	pop bc
	pop hl
	ret
; 223         }
; 224     }
; 225 }
; 226 
; 227 void NetGetAllStatusParse() {
netgetallstatusparse:
; 228     if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_130
; 229         NetGetAllStatusParseSum();
	call netgetallstatusparsesum
; 230         if ((a = NetGetAllStatusParseSumState) == 1) {
	ld a, (netgetallstatusparsesumstate)
	cp 1
	jp nz, __l_132
; 231             hl = Net_buffer;
	ld hl, net_buffer
; 232             //-- 0x3C
; 233             hl++;
	inc hl
; 234             //-- WIFIflag
; 235             ThreadsNetSetWiFiStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetwifistatea
; 236             hl++;
	inc hl
; 237             //-- FtpConnected
; 238             ThreadsNetSetFtpStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetftpstatea
; 239             hl++;
	inc hl
; 240             //-- espError
; 241             ESPErrorParserA(a = *hl);
	ld a, (hl)
	call esperrorparsera
; 242             hl++;
	inc hl
__l_132:
__l_130:
	ret
; 243         }
; 244     }
; 245 }
; 246 
; 247 void NetGetAllStatusParseSum() {
netgetallstatusparsesum:
; 248     push_pop(hl, bc) {
	push hl
	push bc
; 249         b = l;
	ld b, l
; 250         b--;
	dec b
; 251         hl = Net_buffer;
	ld hl, net_buffer
; 252         c = 0;
	ld c, 0
; 253         a = *hl;
	ld a, (hl)
; 254         if (a == 0x3C) {
	cp 60
	jp nz, __l_134
; 255             do {
__l_136:
; 256                 a = *hl;
	ld a, (hl)
; 257                 a += c;
	add c
; 258                 c = a;
	ld c, a
; 259                 hl++;
	inc hl
; 260                 b--;
	dec b
__l_137:
; 261             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_136
; 262             a = *hl;
	ld a, (hl)
; 263             if (a == c) {
	cp c
	jp nz, __l_139
; 264                 a = 0x01;
	ld a, 1
; 265                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
	jp __l_140
__l_139:
; 266             } else {
; 267                 a = 0x00;
	ld a, 0
; 268                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
__l_140:
	jp __l_135
__l_134:
; 269             }
; 270         } else {
; 271             a = 0x00;
	ld a, 0
; 272             NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
__l_135:
	pop bc
	pop hl
	ret
; 273         }
; 274     }
; 275 }
; 276 
; 277 /// HL - point Str
; 278 /// B - Len Str
; 279 /// C - Len buffer
; 280 void ParserBufferSumToHL() {
parserbuffersumtohl:
; 281     ParserBufferSumToHLSum();
	call parserbuffersumtohlsum
; 282     if ((a = ParserBufferSumToHLSumState) == 1) {
	ld a, (parserbuffersumtohlsumstate)
	cp 1
	jp nz, __l_141
; 283         push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 284             de = Net_buffer;
	ld de, net_buffer
; 285             c--;
	dec c
; 286             c--;
	dec c
; 287             do {
__l_143:
; 288                 if ((a = c) > 0) {
	ld a, c
	or a
	jp z, __l_146
; 289                     a = *de;
	ld a, (de)
; 290                     *hl = a;
	ld (hl), a
; 291                     de++;
	inc de
; 292                     c--;
	dec c
	jp __l_147
__l_146:
; 293                 } else {
; 294                     *hl = 0;
	ld (hl), 0
__l_147:
; 295                 }
; 296                 hl++;
	inc hl
; 297                 b--;
	dec b
__l_144:
; 298             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_143
	pop de
	pop bc
	pop hl
	jp __l_142
__l_141:
; 299         }
; 300     } else {
__l_142:
	ret
; 301         //ParserBufferErrorSumShow();
; 302     }
; 303 }
; 304 
; 305 void ParserBufferErrorSumShow() {
parserbuffererrorsumshow:
; 306     push_pop(hl, bc) {
	push hl
	push bc
; 307         //Show Len Buffer
; 308         a = 0;
	ld a, 0
; 309         myCharPosX = a;
	ld (mycharposx), a
; 310         a = 0;
	ld a, 0
; 311         myCharPosY = a;
	ld (mycharposy), a
; 312         printMyHexA(a = c);
	ld a, c
	call printmyhexa
; 313         //-- Buffer
; 314         a = 0;
	ld a, 0
; 315         myCharPosX = a;
	ld (mycharposx), a
; 316         a = 1;
	ld a, 1
; 317         myCharPosY = a;
	ld (mycharposy), a
; 318         hl = Net_buffer;
	ld hl, net_buffer
; 319         c--; //
	dec c
; 320         b = 0;
	ld b, 0
; 321         do {
__l_148:
; 322             a = *hl;
	ld a, (hl)
; 323             a += b;
	add b
; 324             b = a;
	ld b, a
; 325             //-- Show
; 326             printMyHexA(a = *hl);
	ld a, (hl)
	call printmyhexa
; 327             printMyCharA(a = 0x20);
	ld a, 32
	call printmychara
; 328             //--
; 329             hl++;
	inc hl
; 330             c--;
	dec c
__l_149:
; 331         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_148
; 332         printMyHexA(a = *hl);
	ld a, (hl)
	call printmyhexa
; 333         printMyCharA(a = 0x20);
	ld a, 32
	call printmychara
; 334         //-- SUM
; 335         a = 0;
	ld a, 0
; 336         myCharPosX = a;
	ld (mycharposx), a
; 337         a = 3;
	ld a, 3
; 338         myCharPosY = a;
	ld (mycharposy), a
; 339         printMyHexA(a = b);
	ld a, b
	call printmyhexa
; 340         //--
; 341         for(;;){}
__l_152:
	jp __l_152
	pop bc
	pop hl
	ret
; 342     }
; 343 }
; 344 
; 345 void ParserBufferSumToHLSum() {
parserbuffersumtohlsum:
; 346     push_pop(hl, bc) {
	push hl
	push bc
; 347         if ((a = c) >= 3) {
	ld a, c
	cp 3
	jp c, __l_154
; 348             b = c;
	ld b, c
; 349             b--;
	dec b
; 350             c = 0;
	ld c, 0
; 351             hl = Net_buffer;
	ld hl, net_buffer
; 352             do {
__l_156:
; 353                 a = *hl;
	ld a, (hl)
; 354                 a += c;
	add c
; 355                 c = a;
	ld c, a
; 356                 hl++;
	inc hl
; 357                 b--;
	dec b
__l_157:
; 358             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_156
; 359             // 3C
; 360             hl--;
	dec hl
; 361             a = *hl;
	ld a, (hl)
; 362             if (a == 0x3C) {
	cp 60
	jp nz, __l_159
; 363                 hl++;
	inc hl
; 364                 // SUM
; 365                 a = *hl;
	ld a, (hl)
; 366                 if (a == c) {
	cp c
	jp nz, __l_161
; 367                     a = 1;
	ld a, 1
; 368                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
	jp __l_162
__l_161:
; 369                 } else {
; 370                     a = 0;
	ld a, 0
; 371                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_162:
	jp __l_160
__l_159:
; 372                 }
; 373             } else {
; 374                 a = 0;
	ld a, 0
; 375                 ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_160:
	jp __l_155
__l_154:
; 376             }
; 377         } else {
; 378             a = 0;
	ld a, 0
; 379             ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_155:
	pop bc
	pop hl
	ret
; 380         }
; 381     }
; 382 }
; 383 
; 384 uint8_t ParserBufferSumToHLSumState = 0;
parserbuffersumtohlsumstate:
	db 0
; 385 uint8_t NetGetAllStatusParseSumState = 0;
netgetallstatusparsesumstate:
	db 0
; 386 uint16_t NetFtpLoadFileNextParseAddress = 0;
netftploadfilenextparseaddress:
	dw 0
; 387 uint16_t NetFtpLoadFileNextParseAddressEnd = 0;
netftploadfilenextparseaddressen:
	dw 0
; 388 uint8_t NetFtpLoadFileNextParseSumState = 0;
netftploadfilenextparsesumstate:
	db 0
; 389 uint8_t NetFtpListFilesParseSumState = 0;
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
	jp nz, __l_163
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
	jp __l_164
__l_163:
; 30         } else {
; 31             hl = 0;
	ld hl, 0
; 32             ParserFileUploadStartAddress = hl;
	ld (parserfileuploadstartaddress), hl
; 33             ParserFileUploadLen = hl;
	ld (parserfileuploadlen), hl
; 34             ParserFileUploadCount = hl;
	ld (parserfileuploadcount), hl
__l_164:
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
__l_165:
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
__l_166:
; 57         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_165
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
	jp nz, __l_168
; 74             if ( (a = l) < 17 ) {
	ld a, l
	cp 17
	jp nc, __l_170
; 75                 c = 1;
	ld c, 1
__l_170:
__l_168:
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
	jp nz, __l_172
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
	jp nz, __l_174
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
	jp z, __l_176
; 99                     ParserFileUploadProgress = a;
	ld (parserfileuploadprogress), a
; 100                     LoadViewShowProgressA(); //a = *de;
	call loadviewshowprogressa
__l_176:
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
	jp nz, __l_178
; 116                     if ((a = l) == 0) {
	ld a, l
	or a
	jp nz, __l_180
; 117                         c = 0; // СТОП!
	ld c, 0
__l_180:
__l_178:
; 118                     }
; 119                 }
; 120                 a = c;
	ld a, c
	jp __l_175
__l_174:
; 121             } else {
; 122                 a = 1; // Данные не корректны - отправляем еще раз!
	ld a, 1
__l_175:
	pop bc
	pop de
	pop hl
	jp __l_173
__l_172:
; 123             }
; 124         }
; 125     } else {
; 126         a = 0;
	ld a, 0
__l_173:
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
__l_182:
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
__l_183:
; 141         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_182
; 142         a = *de;
	ld a, (de)
; 143         if (a == c) {
	cp c
	jp nz, __l_185
; 144             a = 1;
	ld a, 1
	jp __l_186
__l_185:
; 145         } else {
; 146             a = 0;
	ld a, 0
__l_186:
	pop bc
	pop de
	pop hl
	ret
; 147         }
; 148     }
; 149 }
; 150 
; 151 void ParserFileDiskRequest() {
parserfilediskrequest:
; 152     push_pop(de, bc) {
	push de
	push bc
; 153         // SUMM
; 154         c = 0;
	ld c, 0
; 155         //-- Buffer
; 156         de = Net_buffer;
	ld de, net_buffer
; 157         // - init
; 158         a = 0x3C;
	ld a, 60
; 159         *de = a;
	ld (de), a
; 160         de++;
	inc de
; 161         a += c;
	add c
; 162         c = a;
	ld c, a
; 163         // - disk
; 164         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 165         *de = a;
	ld (de), a
; 166         de++;
	inc de
; 167         a += c;
	add c
; 168         c = a;
	ld c, a
; 169         // - summ
; 170         a = c;
	ld a, c
; 171         *de = a;
	ld (de), a
	pop bc
	pop de
	ret
; 172     }
; 173 }
; 174 
; 175 // Вых [A] - 1 - Успешно. 0 - Ошибка
; 176 void ParserFileDiskResponse() {
parserfilediskresponse:
; 177     ParserFileDiskResponseSum();
	call parserfilediskresponsesum
; 178     if (a == 1) {
	cp 1
	jp nz, __l_187
; 179         push_pop(de, bc) {
	push de
	push bc
; 180             de = Net_buffer;
	ld de, net_buffer
; 181             // init == 0x3C
; 182             a = *de;
	ld a, (de)
; 183             de++;
	inc de
; 184             if (a == 0x3C) {
	cp 60
	jp nz, __l_189
; 185                 a = *de;
	ld a, (de)
; 186                 DiskViewDiskNum = a;
	ld (diskviewdisknum), a
; 187                 a = 1;
	ld a, 1
	jp __l_190
__l_189:
; 188             } else {
; 189                 a = 0;
	ld a, 0
__l_190:
	pop bc
	pop de
	jp __l_188
__l_187:
; 190             }
; 191         }
; 192     } else {
; 193         a = 0;
	ld a, 0
__l_188:
	ret
; 194     }
; 195 }
; 196 
; 197 void ParserFileDiskResponseSum() {
parserfilediskresponsesum:
; 198     push_pop(de, bc) {
	push de
	push bc
; 199         de = Net_buffer;
	ld de, net_buffer
; 200         b = 2;
	ld b, 2
; 201         c = 0;
	ld c, 0
; 202         do {
__l_191:
; 203             a = *de;
	ld a, (de)
; 204             a += c;
	add c
; 205             c = a;
	ld c, a
; 206             de++;
	inc de
; 207             b--;
	dec b
__l_192:
; 208         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_191
; 209         a = *de;
	ld a, (de)
; 210         if (a == c) {
	cp c
	jp nz, __l_194
; 211             a = 1;
	ld a, 1
	jp __l_195
__l_194:
; 212         } else {
; 213             a = 0;
	ld a, 0
__l_195:
	pop bc
	pop de
	ret
; 214         }
; 215     }
; 216 }
; 217 
; 218 // DE = DE - HL
; 219 void ParserFileDESubHL() {
parserfiledesubhl:
; 220     a = e;  // Load low byte of E into accumulator
	ld a, e
; 221     a -= l; // Subtract low byte of L (A = E - L)
	sub l
; 222     e = a;  // Store result back in E
	ld e, a
; 223     
; 224     a = d;  // Load high byte of D into accumulator
	ld a, d
; 225     carry_sub(a, h);    // Subtract high byte of DE with borrow (A = D - H - Carry)
	sbc h
; 226     d = a;  // Store result back in D
	ld d, a
	ret
; 227 }
; 228 
; 229 uint16_t ParserFileUploadStartAddress = 0;
parserfileuploadstartaddress:
	dw 0
; 230 uint16_t ParserFileUploadLen = 0;
parserfileuploadlen:
	dw 0
; 231 uint16_t ParserFileUploadCount = 0;
parserfileuploadcount:
	dw 0
; 232 uint8_t ParserFileUploadProgress = 0;
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
__l_196:
; 60             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 61             b--;
	dec b
__l_197:
; 62         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_196
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
	jp nz, __l_199
; 97             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp __l_200
__l_199:
; 98         } else {
; 99             bc = StringLocaleOK;
	ld bc, stringlocaleok
__l_200:
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
	jp nz, __l_201
; 146             if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_203
; 147                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_205
; 148                     WiFiSettingsViewClose();
	call wifisettingsviewclose
	jp __l_206
__l_205:
; 149                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_207
; 150                     if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, __l_209
; 151                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 152                         if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
	ld a, (wifisettingsviewssidisconnected)
	or a
	jp nz, __l_211
; 153                             NetWiFiConnect(); // Подключиться
	call netwificonnect
; 154                             ThreadsTickNow(); // Обновить
	call threadsticknow
; 155                             ThreadsNetDetectError();
	call threadsnetdetecterror
__l_211:
	jp __l_210
__l_209:
; 156                         }
; 157                     } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
	ld a, (wifisettingsviewselectpos)
	cp 1
	jp nz, __l_213
; 158                         WiFiNetworksViewShow();
	call wifinetworksviewshow
	jp __l_214
__l_213:
; 159                     } else { // Переход в редактирование
; 160                         WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 161                         WiFiSettingsViewByPosValue();
	call wifisettingsviewbyposvalue
; 162                         EditFieldViewShow();
	call editfieldviewshow
; 163                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, __l_215
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
__l_215:
__l_214:
__l_210:
	jp __l_208
__l_207:
; 171                         }
; 172                     }
; 173                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_217
; 174                     WiFiSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifisettingsviewposupdatea
	jp __l_218
__l_217:
; 175                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_219
; 176                     WiFiSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifisettingsviewposupdatea
__l_219:
__l_218:
__l_208:
__l_206:
__l_203:
__l_201:
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
	jp nz, __l_221
; 187             bc = WiFiSettingsViewPassValue;
	ld bc, wifisettingsviewpassvalue
	jp __l_222
__l_221:
; 188         } else {
; 189             bc = 0;
	ld bc, 0
__l_222:
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
	jp nz, __l_223
; 225             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp __l_224
__l_223:
; 226         } else {
; 227             WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 228             // C
; 229             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_225
; 230                 a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
	jp __l_226
__l_225:
; 231             } else {
; 232                 a = WiFiSettingsViewInvColor;
	ld a, (wifisettingsviewinvcolor)
__l_226:
; 233             }
; 234             c = a;
	ld c, a
; 235             // A
; 236             a = vboxUMP;
	ld a, 4
; 237             vboxOpenHLDECA();
	call vboxopenhldeca
__l_224:
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
	jp nz, __l_227
; 251             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
	jp __l_228
__l_227:
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
	jp nz, __l_229
; 260                 a = c;
	ld a, c
; 261                 a--;
	dec a
	jp __l_230
__l_229:
; 262             } else if (a == c) {
	cp c
	jp nz, __l_231
; 263                 a = 0;
	ld a, 0
__l_231:
__l_230:
; 264             }
; 265             //--
; 266             WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 267             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
__l_228:
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
	jp nc, __l_233
; 17             a += 0x30;
	add 48
	jp __l_234
__l_233:
; 18         } else {
; 19             a += 0x37;
	add 55
__l_234:
; 20         }
; 21         printMyCharA();
	call printmychara
; 22         a = b;
	ld a, b
; 23         a &= 0x0F;
	and 15
; 24         if (a < 10) {
	cp 10
	jp nc, __l_235
; 25             a += 0x30;
	add 48
	jp __l_236
__l_235:
; 26         } else {
; 27             a += 0x37;
	add 55
__l_236:
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
__l_237:
; 35         a = *hl;
	ld a, (hl)
; 36         if (a == 0xD0) {
	cp 208
	jp nz, __l_240
; 37             hl++;
	inc hl
; 38             a = *hl;
	ld a, (hl)
; 39             a += 0xF0;
	add 240
	jp __l_241
__l_240:
; 40         } else if (a == 0xD1) {
	cp 209
	jp nz, __l_242
; 41             hl++;
	inc hl
; 42             a = *hl;
	ld a, (hl)
; 43             a += 0x60;
	add 96
__l_242:
__l_241:
; 44         }
; 45         if (a > 0 ) {
	or a
	jp z, __l_244
; 46             printMyCharA();
	call printmychara
__l_244:
; 47         }
; 48         //
; 49         a = *hl;
	ld a, (hl)
; 50         hl++;
	inc hl
__l_238:
; 51     } while (a > 0);
	or a
	jp nz, __l_237
	ret
; 52 }
; 53 
; 54 void printMyHLStr() {
printmyhlstr:
; 55     do {
__l_246:
; 56         a = *hl;
	ld a, (hl)
; 57         if (a > 0) {
	or a
	jp z, __l_249
; 58             printMyCharA();
	call printmychara
__l_249:
; 59         }
; 60         a = *hl;
	ld a, (hl)
; 61         hl++;
	inc hl
__l_247:
; 62     } while (a > 0);
	or a
	jp nz, __l_246
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
__l_251:
; 72             a = *hl;
	ld a, (hl)
; 73             if (a > 0) {
	or a
	jp z, __l_254
; 74                 c++;
	inc c
; 75                 printMyCharA();
	call printmychara
__l_254:
; 76             }
; 77             a = *hl;
	ld a, (hl)
; 78             hl++;
	inc hl
__l_252:
; 79         } while (a > 0);
	or a
	jp nz, __l_251
; 80         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, __l_256
; 81             a = b;
	ld a, b
; 82             a -= c;
	sub c
; 83             b = a;
	ld b, a
; 84             do {
__l_258:
; 85                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 86                 b--;
	dec b
__l_259:
; 87             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_258
__l_256:
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
__l_261:
; 99             a = *hl;
	ld a, (hl)
; 100             if (a > 0) {
	or a
	jp z, __l_264
; 101                 c++;
	inc c
; 102                 printMyCharA(a = '*');
	ld a, 42
	call printmychara
__l_264:
; 103             }
; 104             a = *hl;
	ld a, (hl)
; 105             hl++;
	inc hl
__l_262:
; 106         } while (a > 0);
	or a
	jp nz, __l_261
; 107         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, __l_266
; 108             a = b;
	ld a, b
; 109             a -= c;
	sub c
; 110             b = a;
	ld b, a
; 111             do {
__l_268:
; 112                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 113                 b--;
	dec b
__l_269:
; 114             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_268
__l_266:
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
; 128         a ^= a;
	xor a
; 129         a = b;
	ld a, b
; 130         a &= 0xF8;
	and 248
; 131         a += l;
	add l
; 132         if (flag_c) {
	jp nc, __l_271
; 133             h++;
	inc h
__l_271:
; 134         }
; 135         l = a;
	ld l, a
; 136         // Video POS
; 137         //de = 0xC000;
; 138         a = myCharPosY;
	ld a, (mycharposy)
; 139         a &= 0x1F;
	and 31
; 140         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 141         e = a;
	ld e, a
; 142         a = myCharPosX;
	ld a, (mycharposx)
; 143         a += 0xC0;
	add 192
; 144         d = a;
	ld d, a
; 145         //
; 146         b = 8;
	ld b, 8
; 147         do {
__l_273:
; 148             a = *hl;
	ld a, (hl)
; 149             *de = a;
	ld (de), a
; 150             hl++;
	inc hl
; 151             de++;
	inc de
; 152             b--;
	dec b
__l_274:
; 153         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_273
; 154         // Inc POS
; 155         a = myCharPosX;
	ld a, (mycharposx)
; 156         a++;
	inc a
; 157         if (a >= 0x30) { //0x2F
	cp 48
	jp c, __l_276
; 158             a = 0;
	ld a, 0
; 159             b = a;
	ld b, a
; 160             // Inc Y
; 161             a = myCharPosY;
	ld a, (mycharposy)
; 162             a++;
	inc a
; 163             if (a >= 0x20) { //0x1F
	cp 32
	jp c, __l_278
; 164                 a = 0;
	ld a, 0
__l_278:
; 165             }
; 166             myCharPosY = a;
	ld (mycharposy), a
; 167             //
; 168             a = b;
	ld a, b
__l_276:
; 169         }
; 170         myCharPosX = a;
	ld (mycharposx), a
	pop de
	pop bc
	pop hl
	ret
; 171     }
; 172 }
; 173 
; 174 void myCharPosXSpaceA(){
mycharposxspacea:
; 175     push_pop(bc) {
	push bc
; 176         b = a;
	ld b, a
; 177         a = myCharPosX;
	ld a, (mycharposx)
; 178         a += b;
	add b
; 179         myCharPosX = a;
	ld (mycharposx), a
	pop bc
	ret
; 180     }
; 181 }
; 182 
; 183 void myCharPosYSpaceA(){
mycharposyspacea:
; 184     push_pop(bc) {
	push bc
; 185         b = a;
	ld b, a
; 186         a = myCharPosY;
	ld a, (mycharposy)
; 187         a += b;
	add b
; 188         myCharPosY = a;
	ld (mycharposy), a
	pop bc
	ret
; 189     }
; 190 }
; 191 
; 192 /// Вывести на экран значение A как десятичное число
; 193 /// A не больше 99 или 0x63
; 194 /// Если больше - ничего не выводит
; 195 void printMyAsDec99A() {
printmyasdec99a:
; 196     if (a < 0x64) {
	cp 100
	jp nc, __l_280
; 197         push_pop(bc, de) {
	push bc
	push de
; 198             b = a;
	ld b, a
; 199             c = a;
	ld c, a
; 200             d = 0;
	ld d, 0
; 201             e = 10;
	ld e, 10
; 202             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, __l_282
; 203                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 204                 a = b;
	ld a, b
; 205                 a += '0';
	add 48
; 206                 printMyCharA();
	call printmychara
	jp __l_283
__l_282:
; 207             } else {
; 208                 do {
__l_284:
; 209                     a = b;
	ld a, b
; 210                     a -= e;
	sub e
; 211                     b = a;
	ld b, a
; 212                     d++;
	inc d
__l_285:
; 213                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, __l_284
; 214                 a = d;
	ld a, d
; 215                 a += '0';
	add 48
; 216                 printMyCharA();
	call printmychara
; 217                 a = b;
	ld a, b
; 218                 a += '0';
	add 48
; 219                 printMyCharA();
	call printmychara
__l_283:
	pop de
	pop bc
__l_280:
	ret
; 220             }
; 221         }
; 222     }
; 223 }
; 224 
; 225 /// Вывести на экран значение A как десятичное число с ведущими нулями
; 226 /// A не больше 99 или 0x63
; 227 /// Если больше - ничего не выводит
; 228 void printMyAs00Dec99A() {
printmyas00dec99a:
; 229     if (a < 0x64) {
	cp 100
	jp nc, __l_287
; 230         push_pop(bc, de) {
	push bc
	push de
; 231             b = a;
	ld b, a
; 232             c = a;
	ld c, a
; 233             d = 0;
	ld d, 0
; 234             e = 10;
	ld e, 10
; 235             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, __l_289
; 236                 printMyCharA(a = '0');
	ld a, 48
	call printmychara
; 237                 a = b;
	ld a, b
; 238                 a += '0';
	add 48
; 239                 printMyCharA();
	call printmychara
	jp __l_290
__l_289:
; 240             } else {
; 241                 do {
__l_291:
; 242                     a = b;
	ld a, b
; 243                     a -= e;
	sub e
; 244                     b = a;
	ld b, a
; 245                     d++;
	inc d
__l_292:
; 246                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, __l_291
; 247                 a = d;
	ld a, d
; 248                 a += '0';
	add 48
; 249                 printMyCharA();
	call printmychara
; 250                 a = b;
	ld a, b
; 251                 a += '0';
	add 48
; 252                 printMyCharA();
	call printmychara
__l_290:
	pop de
	pop bc
__l_287:
	ret
; 253             }
; 254         }
; 255     }
; 256 }
; 257 
; 258 /// Вывести на экран значение HL как десятичное число
; 259 /// A не больше 4095 или 0x0FFF
; 260 /// Если больше - ничего не выводит
; 261 void printMyAsDec4095HL() {
printmyasdec4095hl:
; 262     push_pop(bc, de) {
	push bc
	push de
; 263         de = 0x0FFF;
	ld de, 4095
; 264         compareHlDe();
	call comparehlde
; 265         if (flag_nc) {
	jp c, __l_294
; 266             c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
	ld c, 0
; 267             //1000
; 268             de = 0x03E8;
	ld de, 1000
; 269             compareHlDe();
	call comparehlde
; 270             if (flag_c) {
	jp nc, __l_296
; 271                 b = 0;
	ld b, 0
; 272                 do {
__l_298:
; 273                     de = 0xFC18;
	ld de, 64536
; 274                     hl += de;
	add hl, de
; 275                     b++;
	inc b
; 276                     de = 0x03E8;
	ld de, 1000
; 277                     compareHlDe();
	call comparehlde
__l_299:
	jp c, __l_298
; 278                 } while (flag_c);
; 279                 a = b;
	ld a, b
; 280                 a += '0';
	add 48
; 281                 printMyCharA();
	call printmychara
; 282                 c = 1;
	ld c, 1
	jp __l_297
__l_296:
; 283             } else {
; 284                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
__l_297:
; 285             }
; 286             //0100
; 287             de = 0x0064;
	ld de, 100
; 288             compareHlDe();
	call comparehlde
; 289             if (flag_c) {
	jp nc, __l_301
; 290                 b = 0;
	ld b, 0
; 291                 do {
__l_303:
; 292                     de = 0xFF9C;
	ld de, 65436
; 293                     hl += de;
	add hl, de
; 294                     b++;
	inc b
; 295                     de = 0x0064;
	ld de, 100
; 296                     compareHlDe();
	call comparehlde
__l_304:
	jp c, __l_303
; 297                 } while (flag_c);
; 298                 a = b;
	ld a, b
; 299                 a += '0';
	add 48
; 300                 printMyCharA();
	call printmychara
; 301                 c = 1;
	ld c, 1
	jp __l_302
__l_301:
; 302             } else {
; 303                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_306
; 304                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
	jp __l_307
__l_306:
; 305                 } else {
; 306                     printMyCharA(a = '0');
	ld a, 48
	call printmychara
__l_307:
__l_302:
; 307                 }
; 308             }
; 309             //0010
; 310 //            de = 0x000A;
; 311 //            compareHlDe();
; 312 //            if (flag_c) {
; 313 //                b = 0;
; 314 //                do {
; 315 //                    de = 0xFFF6;
; 316 //                    hl += de;
; 317 //                    b++;
; 318 //                    de = 0x000A;
; 319 //                    compareHlDe();
; 320 //                } while (flag_c);
; 321 //                a = b;
; 322 //                a += '0';
; 323 //                printMyCharA();
; 324 //            } else {
; 325 //                printMyCharA(a = '0');
; 326 //            }
; 327             a = l;
	ld a, l
; 328             if ((a = l) >= 10) {
	ld a, l
	cp 10
	jp c, __l_308
; 329                 b = 0;
	ld b, 0
; 330                 do {
__l_310:
; 331                     a = l;
	ld a, l
; 332                     a -= 10;
	sub 10
; 333                     l = a;
	ld l, a
; 334                     b++;
	inc b
__l_311:
; 335                 } while ((a = l) >= 10);
	ld a, l
	cp 10
	jp nc, __l_310
; 336                 a = b;
	ld a, b
; 337                 a += '0';
	add 48
; 338                 printMyCharA();
	call printmychara
; 339                 c = 1;
	ld c, 1
	jp __l_309
__l_308:
; 340             } else {
; 341                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_313
; 342                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
	jp __l_314
__l_313:
; 343                 } else {
; 344                     printMyCharA(a = '0');
	ld a, 48
	call printmychara
__l_314:
__l_309:
; 345                 }
; 346             }
; 347             //0001
; 348             a = l;
	ld a, l
; 349             a += '0';
	add 48
; 350             printMyCharA();
	call printmychara
__l_294:
	pop de
	pop bc
	ret
; 351         }
; 352     }
; 353 }
; 354 
; 355 /// Спавнение HL и DE
; 356 /// CF=1 when DE < HL
; 357 /// CF=0 DE >= HL
; 358 void compareHlDe() {
comparehlde:
; 359     a = d;
	ld a, d
; 360     a ^= h;
	xor h
; 361     if (flag_p) {
	jp m, __l_315
	jp __l_316
__l_315:
; 362     } else {
; 363         a ^= d;
	xor d
; 364         if (flag_m) {
	jp p, __l_317
; 365             return;
	ret
__l_317:
; 366         }
; 367         set_flag_c();
	scf
; 368         return;
	ret
__l_316:
; 369     }
; 370     a = e;
	ld a, e
; 371     a -= l; //0x95
	sub l
; 372     a = d;
	ld a, d
; 373     //a -= h; //0x9C
; 374     //asm{ SBB h };
; 375     carry_sub(a, h);
	sbc h
; 376     return;
	ret
; 377 }
; 378 
; 379 uint8_t myCharPosX = 0;
mycharposx:
	db 0
; 380 uint8_t myCharPosY = 0;
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
; 49 uint8_t HelpViewColor = 0x07;
helpviewcolor:
	db 7
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
	jp nz, __l_319
; 35         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_321
; 36             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 37             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp __l_322
__l_321:
; 38         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_323
; 39             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
; 40             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_324
__l_323:
; 41         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, __l_325
; 42             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 43             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_326
__l_325:
; 44         } else if ((a = CurrentViewId) == LoadViewId) {
	ld a, (currentviewid)
	cp 4
	jp nz, __l_327
; 45             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 46             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_328
__l_327:
; 47         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_329
; 48             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 49             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_330
__l_329:
; 50         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_331
; 51             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 52             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_332
__l_331:
; 53         } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, __l_333
; 54             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 55             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_334
__l_333:
; 56         } else if ((a = CurrentViewId) == HelpInfoViewId) {
	ld a, (currentviewid)
	cp 12
	jp nz, __l_335
; 57             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 58             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
__l_335:
__l_334:
__l_332:
__l_330:
__l_328:
__l_326:
__l_324:
__l_322:
__l_319:
	ret
; 59         }
; 60     }
; 61 }
; 62 
; 63 void CurrentViewPushCurrentId() {
currentviewpushcurrentid:
; 64     push_pop(de, hl) {
	push de
	push hl
; 65         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 66         // Add delta
; 67         d = 0;
	ld d, 0
; 68         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 69         e = a;
	ld e, a
; 70         a++;
	inc a
; 71         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 72         hl += de;
	add hl, de
; 73         // Save current ID
; 74         a = CurrentViewId;
	ld a, (currentviewid)
; 75         *hl = a;
	ld (hl), a
	pop hl
	pop de
	ret
; 76     }
; 77 }
; 78 
; 79 // Return A - ID
; 80 void CurrentViewPopId() {
currentviewpopid:
; 81     if ((a = CurrentViewReturnIdPos) > 0) {
	ld a, (currentviewreturnidpos)
	or a
	jp z, __l_337
; 82         // Decriment
; 83         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 84         a--;
	dec a
; 85         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 86         //--
; 87         e = a;
	ld e, a
; 88         d = 0;
	ld d, 0
; 89         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 90         hl += de;
	add hl, de
; 91         a = *hl;
	ld a, (hl)
	jp __l_338
__l_337:
; 92     } else {
; 93         a = CurrentViewId;
	ld a, (currentviewid)
__l_338:
	ret
; 94     }
; 95 }
; 96 
; 97 void CurrentViewReturn() {
currentviewreturn:
; 98     CurrentViewPopId();
	call currentviewpopid
; 99     CurrentViewChangeIdA();
	jp currentviewchangeida
; 100 }
; 101 
; 102 /// вых [A] 1 - если активное окно DiskView или FtpView
; 103 /// 0 - если любое другое
; 104 void CurrentViewDiskOrFtpViewByIdA() {
currentviewdiskorftpviewbyida:
; 105     push_pop(bc) {
	push bc
; 106         b = a;
	ld b, a
; 107         if ((a = b) == DiskViewId) {
	ld a, b
	cp 1
	jp nz, __l_339
; 108             a = 1;
	ld a, 1
; 109             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp __l_340
__l_339:
; 110         } else if ((a = b) == FtpViewId) {
	ld a, b
	cp 2
	jp nz, __l_341
; 111             a = 1;
	ld a, 1
; 112             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp __l_342
__l_341:
; 113         } else {
; 114             a = 0;
	ld a, 0
; 115             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
__l_342:
__l_340:
	pop bc
; 116         }
; 117     }
; 118     a =  CurrentViewDiskOrFtpViewFocus;
	ld a, (currentviewdiskorftpviewfocus)
	ret
; 119 }
; 120 
; 121 uint8_t CurrentViewDiskOrFtpViewFocus = 0;
currentviewdiskorftpviewfocus:
	db 0
; 123 uint8_t CurrentViewReturnIds[16];
currentviewreturnids:
	ds 16
; 124 uint8_t CurrentViewReturnIdPos = 0;
currentviewreturnidpos:
	db 0
; 125 uint8_t CurrentViewId = FtpViewId;
currentviewid:
	db 2
; 126 uint8_t FtpNetStateChange = 0;
ftpnetstatechange:
	db 0
; 127 uint8_t WiFiNetStateChange = 0;
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
; 22 uint8_t StringLocaleDiskFull[] = "Disk full";
stringlocalediskfull:
	db 68
	db 105
	db 115
	db 107
	db 32
	db 102
	db 117
	db 108
	db 108
	ds 1
; 23 uint8_t StringLocaleDiskFormat[] = "Format the disk?";
stringlocalediskformat:
	db 70
	db 111
	db 114
	db 109
	db 97
	db 116
	db 32
	db 116
	db 104
	db 101
	db 32
	db 100
	db 105
	db 115
	db 107
	db 63
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
	jp nz, __l_343
; 61             a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
	jp __l_344
__l_343:
; 62         } else {
; 63             a = ButtonShadowViewInvColor;
	ld a, (buttonshadowviewinvcolor)
__l_344:
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
__l_345:
; 80             a = *hl;
	ld a, (hl)
; 81             d = a;
	ld d, a
; 82             hl++;
	inc hl
; 83             if (a > 0) {
	or a
	jp z, __l_348
; 84                 b++;
	inc b
__l_348:
; 85             }
; 86             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_350
; 87                 d = 0;
	ld d, 0
__l_350:
__l_346:
; 88             }
; 89         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_345
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
__l_352:
; 60             getKeyboardCharA();
	call getkeyboardchara
; 61             c = a;
	ld c, a
; 62             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_355
; 63                 b = 1;
	ld b, 1
	jp __l_356
__l_355:
; 64             } else if ((a = c) == 0x7F) { //Забой... (удаление символа)
	ld a, c
	cp 127
	jp nz, __l_357
; 65                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 66                 if (a > 0) {
	or a
	jp z, __l_359
; 67                     a--;
	dec a
; 68                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
__l_359:
; 69                 }
; 70                 EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
	jp __l_358
__l_357:
; 71             } else if ((a = c) == 0x0D) { // Сохранить и выйти из редактирования
	ld a, c
	cp 13
	jp nz, __l_361
; 72                 a = 1;
	ld a, 1
; 73                 EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 74                 EditFieldViewTextSave();
	call editfieldviewtextsave
; 75                 b = 1;
	ld b, 1
	jp __l_362
__l_361:
; 76             } else if ((a = c) < 0x20) { // ничего не делаем
	ld a, c
	cp 32
	jp nc, __l_363
	jp __l_364
__l_363:
; 77                 
; 78             } else {
; 79                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 80                 if (a < 15) {
	cp 15
	jp nc, __l_365
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
__l_365:
__l_364:
__l_362:
__l_358:
__l_356:
__l_353:
; 94                 }
; 95             }
; 96         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_352
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
	jp z, __l_367
; 115             do {
__l_369:
; 116                 printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 117                 hl++;
	inc hl
; 118                 c--;
	dec c
__l_370:
; 119             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_369
__l_367:
; 120         }
; 121         // Clear
; 122         a = 16; // Max char array
	ld a, 16
; 123         a -= b;
	sub b
; 124         c = a;
	ld c, a
; 125         do {
__l_372:
; 126             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 127             c--;
	dec c
__l_373:
; 128         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_372
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
__l_375:
; 140             a = *hl;
	ld a, (hl)
; 141             if (a > 0) {
	or a
	jp z, __l_378
; 142                 b++;
	inc b
; 143                 *de = a;
	ld (de), a
; 144                 hl++;
	inc hl
; 145                 de++;
	inc de
	jp __l_379
__l_378:
; 146             } else {
; 147                 a = b;
	ld a, b
; 148                 EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 149                 c = 0;
	ld c, 0
__l_379:
__l_376:
; 150             }
; 151         } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, __l_375
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
	jp nz, __l_380
; 158         push_pop(hl) {
	push hl
; 159             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 160             *hl = 0;
	ld (hl), 0
	pop hl
	jp __l_381
__l_380:
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
__l_382:
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
__l_383:
; 173             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_382
; 174             *hl = 0;
	ld (hl), 0
	pop hl
	pop de
	pop bc
__l_381:
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
	jp nz, __l_385
; 16             // Меняем заглавные на маленькие
; 17             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, __l_387
; 18                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, __l_389
; 19                     a = b;
	ld a, b
; 20                     a += 0x20;
	add 32
; 21                     c = a;
	ld c, a
__l_389:
__l_387:
; 22                 }
; 23             }
; 24             // Меняем маленькие на заглавные
; 25             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, __l_391
; 26                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, __l_393
; 27                     a = b;
	ld a, b
; 28                     a -= 0x20;
	sub 32
; 29                     c = a;
	ld c, a
__l_393:
__l_391:
	jp __l_386
__l_385:
; 30                 }
; 31             }
; 32         } else if ((a = keyRusAddress) == 0xFF) { // rus
	ld a, (keyrusaddress)
	cp 255
	jp nz, __l_395
; 33             // Меняем заглавные английские на заглавные русские
; 34             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, __l_397
; 35                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, __l_399
; 36                     a = b;
	ld a, b
; 37                     a += 0x3F;
	add 63
; 38                     c = a;
	ld c, a
; 39                     KeyboardConverRusCharC(a = 1);
	ld a, 1
	call keyboardconverruscharc
__l_399:
__l_397:
; 40                 }
; 41             }
; 42             // Меняем маленькие английские на маленькие русские
; 43             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, __l_401
; 44                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, __l_403
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
	jp c, __l_405
; 52                         a = c;
	ld a, c
; 53                         a += 0x30;
	add 48
; 54                         c = a;
	ld c, a
__l_405:
__l_403:
__l_401:
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
	jp nz, __l_407
; 63                 a = b;
	ld a, b
; 64                 a += 0x5E;
	add 94
; 65                 c = a;
	ld c, a
__l_407:
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
	jp nz, __l_409
; 72                 a = b;
	ld a, b
; 73                 a += 0x41;
	add 65
; 74                 c = a;
	ld c, a
__l_409:
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
	jp nz, __l_411
; 81                 a = b;
	ld a, b
; 82                 a += 0x39;
	add 57
; 83                 c = a;
	ld c, a
__l_411:
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
	jp nz, __l_413
; 90                 a = b;
	ld a, b
; 91                 a += 0x3D;
	add 61
; 92                 c = a;
	ld c, a
__l_413:
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
	jp nz, __l_415
; 99                 a = b;
	ld a, b
; 100                 a += 0x3C;
	add 60
; 101                 c = a;
	ld c, a
__l_415:
; 102             }
; 103             if ((a = c) >= 0xB0) {
	ld a, c
	cp 176
	jp c, __l_417
; 104                 if ((a = c) < 0xC0) {
	ld a, c
	cp 192
	jp nc, __l_419
; 105                     a = c;
	ld a, c
; 106                     a += 0x30;
	add 48
; 107                     c = a;
	ld c, a
__l_419:
__l_417:
	jp __l_396
__l_395:
; 108                 }
; 109             }
; 110         } else {
__l_396:
__l_386:
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
	jp nz, __l_421
; 120             h = 1;
	ld h, 1
	jp __l_422
__l_421:
; 121         } else if ((a = b) == e) {
	ld a, b
	cp e
	jp nz, __l_423
; 122             h = 1;
	ld h, 1
	jp __l_424
__l_423:
; 123         } else {
; 124             h = 0;
	ld h, 0
__l_424:
__l_422:
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
	jp nz, __l_425
; 135             a = c;
	ld a, c
; 136             a -= 0xA0;
	sub 160
; 137             e = a;
	ld e, a
	jp __l_426
__l_425:
; 138         } else {
; 139             a = c;
	ld a, c
; 140             a -= 0x80;
	sub 128
; 141             e = a;
	ld e, a
__l_426:
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
	jp c, __l_427
; 21         a = 0;
	ld a, 0
; 22         ThreadsTickCount = a;
	ld (threadstickcount), a
; 23         //--
; 24         ThreadsNetUpdateState();
	call threadsnetupdatestate
	jp __l_428
__l_427:
; 25     } else {
; 26         ThreadsTickCountNext();
	call threadstickcountnext
__l_428:
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
	jp nz, __l_429
; 34         NetGetAllStatus();
	call netgetallstatus
; 35         ThreadsNetNeedStateChange();
	call threadsnetneedstatechange
__l_429:
	ret
; 36     }
; 37 }
; 38 
; 39 void ThreadsNetNeedStateChange() {
threadsnetneedstatechange:
; 40     if ((a = WiFiNetStateChange) == 1) {
	ld a, (wifinetstatechange)
	cp 1
	jp nz, __l_431
; 41         ThreadsNetNeedUpdateWiFiData();
	call threadsnetneedupdatewifidata
; 42         a = 0;
	ld a, 0
; 43         WiFiNetStateChange = a;
	ld (wifinetstatechange), a
__l_431:
; 44     }
; 45     if ((a = FtpNetStateChange) == 1) {
	ld a, (ftpnetstatechange)
	cp 1
	jp nz, __l_433
; 46         ThreadsNetNeedUpdateFtpData();
	call threadsnetneedupdateftpdata
; 47         a = 0;
	ld a, 0
; 48         FtpNetStateChange = a;
	ld (ftpnetstatechange), a
__l_433:
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
	jp nz, __l_435
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
	jp __l_436
__l_435:
; 65         } else {
; 66             hl--;
	dec hl
__l_436:
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
__l_437:
; 76             bc--;
	dec bc
; 77             a = b;
	ld a, b
; 78             a |= c;
	or c
__l_438:
	jp nz, __l_437
	pop bc
	ret
; 79         } while (flag_nz);
; 80     }
; 81 }
; 82 
; 83 void NetUpdateData() {
netupdatedata:
; 84     NetDiskGetNum();
	call netdiskgetnum
; 85     if (a == 1) { // Обновляем локальный диск
	cp 1
	jp nz, __l_440
; 86         DiskViewReload();
	call diskviewreload
__l_440:
; 87     }
; 88     // NEXT
; 89     ThreadsNetNeedUpdateFtpValue();
	call threadsnetneedupdateftpvalue
; 90     ThreadsNetNeedUpdateWiFiValue();
	jp threadsnetneedupdatewifivalue
; 91 }
; 92 
; 93 // ----------------------------------
; 94 // ------------ WiFi ----------------
; 95 // ----------------------------------
; 96 void ThreadsNetNeedUpdateWiFiData() {
threadsnetneedupdatewifidata:
; 97     NetWiFiGetSsidIp();
	call netwifigetssidip
; 98     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 99 }
; 100 
; 101 void ThreadsNetPasswordUpdate() {
threadsnetpasswordupdate:
; 102     NetWiFiSetSsidPassword();
	call netwifisetssidpassword
; 103     nop();
	nop
; 104     NetWiFiGetSsidPassword();
	call netwifigetssidpassword
; 105     nop();
	nop
	ret
; 106 }
; 107 
; 108 void ThreadsNetNeedUpdateWiFiValue() {
threadsnetneedupdatewifivalue:
; 109     NetWiFiGetSsidIp();
	call netwifigetssidip
; 110     NetWiFiGetSsidMac();
	call netwifigetssidmac
; 111     NetWiFiGetSsid();
	call netwifigetssid
; 112     NetWiFiGetSsidPassword();
	call netwifigetssidpassword
; 113     // UI
; 114     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 115 }
; 116 
; 117 void ThreadsNetSsidUpdateA() {
threadsnetssidupdatea:
; 118     NetWiFiSetListA();
	call netwifisetlista
; 119     NetWiFiGetSsid();
	call netwifigetssid
; 120     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 121 }
; 122 
; 123 void ThreadsNetSetWiFiStateA() {
threadsnetsetwifistatea:
; 124     push_pop(bc) {
	push bc
; 125         a &= 0x01;
	and 1
; 126         b = a;
	ld b, a
; 127         // Old Value
; 128         a = WiFiSettingsViewSSIDIsConnected;
	ld a, (wifisettingsviewssidisconnected)
; 129         c = a;
	ld c, a
; 130         // --
; 131         a = b;
	ld a, b
; 132         WiFiSettingsViewSSIDIsConnected = a;
	ld (wifisettingsviewssidisconnected), a
; 133         if(a != c){
	cp c
	jp z, __l_442
; 134             a = 0x01;
	ld a, 1
; 135             WiFiNetStateChange = a;
	ld (wifinetstatechange), a
__l_442:
	pop bc
	ret
; 136         }
; 137     }
; 138 }
; 139 
; 140 // ----------------------------------
; 141 // ------------ Ftp  ----------------
; 142 // ----------------------------------
; 143 void ThreadsNetNeedUpdateFtpData() {
threadsnetneedupdateftpdata:
; 144     FtpStateViewShowValue();
	call ftpstateviewshowvalue
; 145     // Update ftp dir
; 146     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 147     FtpViewShowPath();
	call ftpviewshowpath
; 148     //
; 149     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 150     if (a == 1) {
	cp 1
	jp nz, __l_444
; 151         if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, __l_446
; 152             NetFtpUpdateList();
	call netftpupdatelist
; 153             NetFtpListFiles();
	call netftplistfiles
	jp __l_447
__l_446:
; 154         } else {
; 155             FtpViewEmptyList();
	call ftpviewemptylist
__l_447:
; 156         }
; 157         FtpViewListUpdateUI();
	call ftpviewlistupdateui
__l_444:
	ret
; 158     }
; 159 }
; 160 
; 161 void ThreadsNetNeedUpdateFtpValue() {
threadsnetneedupdateftpvalue:
; 162     NetFtpGetUrl();
	call netftpgeturl
; 163     NetFtpGetHomeDir();
	call netftpgethomedir
; 164     NetFtpGetPort();
	call netftpgetport
; 165     NetFtpGetUser();
	call netftpgetuser
; 166     NetFtpGetPassword();
	call netftpgetpassword
; 167     // UI
; 168     FtpStateViewShowValue();
	jp ftpstateviewshowvalue
; 169 }
; 170 
; 171 void ThreadsNetFtpHomeDirUpdate() {
threadsnetftphomedirupdate:
; 172     NetFtpSetHomeDir();
	call netftpsethomedir
; 173     NetFtpGetHomeDir();
	jp netftpgethomedir
; 174 }
; 175 
; 176 void ThreadsNetFtpUserUpdate() {
threadsnetftpuserupdate:
; 177     NetFtpSetUser();
	call netftpsetuser
; 178     NetFtpGetUser();
	jp netftpgetuser
; 179 }
; 180 
; 181 void ThreadsNetFtpPasswordUpdate() {
threadsnetftppasswordupdate:
; 182     NetFtpSetPassword();
	call netftpsetpassword
; 183     NetFtpGetPassword();
	jp netftpgetpassword
; 184 }
; 185 
; 186 void ThreadsNetFtpServerUrlUpdate() {
threadsnetftpserverurlupdate:
; 187     NetFtpSetUrl();
	call netftpseturl
; 188     NetFtpGetUrl();
	jp netftpgeturl
; 189 }
; 190 
; 191 void ThreadsNetFtpPortUpdate() {
threadsnetftpportupdate:
; 192     NetFtpSetPort();
	call netftpsetport
; 193     NetFtpGetPort();
	jp netftpgetport
; 194 }
; 195 
; 196 void ThreadsNetFtpGoToHomeDir() {
threadsnetftpgotohomedir:
; 197     NetFtpGoToHomeDir();
	call netftpgotohomedir
; 198     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 199     FtpViewShowPath();
	call ftpviewshowpath
; 200     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, __l_448
; 201         NetFtpUpdateList();
	call netftpupdatelist
; 202         NetFtpListFiles();
	call netftplistfiles
	jp __l_449
__l_448:
; 203     } else {
; 204         FtpViewEmptyList();
	call ftpviewemptylist
__l_449:
; 205     }
; 206     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 207 }
; 208 
; 209 void ThreadsNetFtpDeleteFileA() {
threadsnetftpdeletefilea:
; 210     NetFtpDeleteFileIndexA();
	call netftpdeletefileindexa
; 211     NetFtpUpdateList();
	call netftpupdatelist
; 212     NetFtpListFiles();
	call netftplistfiles
; 213     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 214 }
; 215 
; 216 void ThreadsNetSetFtpStateA() {
threadsnetsetftpstatea:
; 217     push_pop(bc) {
	push bc
; 218         a &= 0x01;
	and 1
; 219         b = a;
	ld b, a
; 220         // Old Value
; 221         a = FtpStateViewStatus;
	ld a, (ftpstateviewstatus)
; 222         c = a;
	ld c, a
; 223         // --
; 224         a = b;
	ld a, b
; 225         FtpStateViewStatus = a;
	ld (ftpstateviewstatus), a
; 226         if(a != c){
	cp c
	jp z, __l_450
; 227             a = 0x01;
	ld a, 1
; 228             FtpNetStateChange = a;
	ld (ftpnetstatechange), a
__l_450:
	pop bc
	ret
; 229         }
; 230     }
; 231 }
; 232 
; 233 void ThreadsNetDetectError() {
threadsnetdetecterror:
; 234     push_pop(bc, hl) {
	push bc
	push hl
; 235         if ((a = ESPError) > 0) {
	ld a, (esperror)
	or a
	jp z, __l_452
; 236             b = a;
	ld b, a
; 237             // Clear error
; 238             a = 0;
	ld a, 0
; 239             ESPError = a;
	ld (esperror), a
; 240             //-- ENUM
; 241             if ((a = b) == ESPError_TimeOut) {
	ld a, b
	cp 1
	jp nz, __l_454
; 242                 AllertOkViewShowHL(hl = StringLocaleNetTimeOut);
	ld hl, stringlocalenettimeout
	call allertokviewshowhl
__l_454:
__l_452:
	pop hl
	pop bc
	ret
; 243             }
; 244         }
; 245     }
; 246 }
; 247 
; 248 uint16_t ThreadsTickSubCount = 0x0000;
threadsticksubcount:
	dw 0
; 249 uint8_t ThreadsTickCount = 0;
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
; 89 uint8_t WifiStateViewColor = 0x07;
wifistateviewcolor:
	db 7
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
	jp z, __l_456
; 66             hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 67             b = 0;
	ld b, 0
; 68             do {
__l_458:
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
__l_461:
; 76                     printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 77                     hl++;
	inc hl
; 78                     c--;
	dec c
__l_462:
; 79                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_461
; 80                 hl++;
	inc hl
; 81                 hl++;
	inc hl
; 82                 push_pop(de) {
	push de
; 83                     a = *hl;
	ld a, (hl)
; 84                     e = a;
	ld e, a
; 85                     hl++;
	inc hl
; 86                     a = *hl;
	ld a, (hl)
; 87                     d = a;
	ld d, a
; 88                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 89                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 90                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 91                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 92                     FtpViewShow4CharSizeDE();
	call ftpviewshow4charsizede
; 93                     hl++;
	inc hl
	pop de
; 94                 }
; 95                 hl++;
	inc hl
; 96                 hl++;
	inc hl
; 97                 hl++;
	inc hl
; 98                 hl++;
	inc hl
; 99                 b++;
	inc b
; 100                 a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 101                 a--;
	dec a
__l_459:
; 102             } while (a >= b);
	cp b
	jp nc, __l_458
__l_456:
; 103         }
; 104         // show empty rows
; 105         a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 106         b = a;
	ld b, a
; 107         // PosY
; 108         a = e;
	ld a, e
; 109         a += b;
	add b
; 110         e = a;
	ld e, a
; 111         //
; 112         a = DiskViewDY;
	ld a, (diskviewdy)
; 113         a -= 4;
	sub 4
; 114         a -= b;
	sub b
; 115         b = a;
	ld b, a
; 116         c = 0;
	ld c, 0
; 117         do {
__l_464:
; 118             a = d;
	ld a, d
; 119             myCharPosX = a;
	ld (mycharposx), a
; 120             a = e;
	ld a, e
; 121             a += c;
	add c
; 122             myCharPosY = a;
	ld (mycharposy), a
; 123             //
; 124             a = DiskViewDX;
	ld a, (diskviewdx)
; 125             a -= 3;
	sub 3
; 126             h = a;
	ld h, a
; 127             do {
__l_467:
; 128                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 129                 h--;
	dec h
__l_468:
; 130             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, __l_467
; 131             b--;
	dec b
; 132             c++;
	inc c
__l_465:
; 133         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_464
	pop de
	pop bc
	pop hl
	ret
; 134     }
; 135 }
; 136 
; 137 void DiskViewCurrentFileNameHL() {
diskviewcurrentfilenamehl:
; 138     push_pop(bc) {
	push bc
; 139         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 140         a ^= a;
	xor a
; 141         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 142         a -= 1; // Удалить корневой переход на другой диск
	sub 1
; 143         b = 0;
	ld b, 0
; 144         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 145         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_470
; 146             b++;
	inc b
__l_470:
; 147         }
; 148         c = a;
	ld c, a
; 149         hl += bc;
	add hl, bc
; 150         push_pop(hl) { // Проставляем 0 в конце строки
	push hl
; 151             bc = 7;
	ld bc, 7
; 152             hl += bc;
	add hl, bc
; 153             b = 7;
	ld b, 7
; 154             do {
__l_472:
; 155                 a = *hl;
	ld a, (hl)
; 156                 if (a == 0x20) {
	cp 32
	jp nz, __l_475
; 157                     a = 0;
	ld a, 0
; 158                     *hl = a;
	ld (hl), a
	jp __l_476
__l_475:
; 159                 } else {
; 160                     b = 1;
	ld b, 1
__l_476:
; 161                 }
; 162                 hl--;
	dec hl
; 163                 b--;
	dec b
__l_473:
; 164             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_472
	pop hl
	pop bc
	ret
; 165         }
; 166     }
; 167 }
; 168 
; 169 void DiskViewDeleteSelectedFile() {
diskviewdeleteselectedfile:
; 170     push_pop(hl, bc) {
	push hl
	push bc
; 171         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 172         ordos_wnd();
	call ordos_wnd
; 173         DiskViewCurrentFileNameHL();
	call diskviewcurrentfilenamehl
; 174         ordos_sdma();
	call ordos_sdma
; 175         ordos_eras();
	call ordos_eras
; 176         //а = 1 - нет файла
; 177         //а = 4 - файл 'r/o'
; 178         b = a;
	ld b, a
; 179         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_477
; 180             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 181             a = 0;
	ld a, 0
; 182             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 183             DiskViewUpdateDateAndUI();
	call diskviewupdatedateandui
; 184             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp __l_478
__l_477:
; 185         } else if ((a = b) == 1) { // нет файла
	ld a, b
	cp 1
	jp nz, __l_479
; 186             AllertOkViewShowHL(hl = StringLocaleFileNotFound);
	ld hl, stringlocalefilenotfound
	call allertokviewshowhl
	jp __l_480
__l_479:
; 187         } else if ((a = b) == 4) { // файл 'r/o'
	ld a, b
	cp 4
	jp nz, __l_481
; 188             AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
	ld hl, stringlocalefilereadonly
	call allertokviewshowhl
	jp __l_482
__l_481:
; 189         } else if ((a = b) == 0x41) { // Диск A
	ld a, b
	cp 65
	jp nz, __l_483
; 190             AllertOkViewShowHL(hl = StringLocaleFileReadOnly);
	ld hl, stringlocalefilereadonly
	call allertokviewshowhl
	jp __l_484
__l_483:
; 191         } else {
__l_484:
__l_482:
__l_480:
__l_478:
	pop bc
	pop hl
	ret
; 192             //printMyHexA(a = b);
; 193         }
; 194     }
; 195 }
; 196 
; 197 void DiskViewUploadSelectedFile() {
diskviewuploadselectedfile:
; 198     push_pop(hl, bc) {
	push hl
	push bc
; 199         // Open progress view
; 200         LoadViewShowHL(hl = LoadViewUploadTitle);
	ld hl, loadviewuploadtitle
	call loadviewshowhl
; 201         LoadViewShowProgressA(a = 0);
	ld a, 0
	call loadviewshowprogressa
; 202         //-- create point File
; 203         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 204         a ^= a;
	xor a
; 205         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 206         a -= 1; // Удалить корневой переход на другой диск
	sub 1
; 207         b = 0;
	ld b, 0
; 208         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 209         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_485
; 210             b++;
	inc b
__l_485:
; 211         }
; 212         c = a;
	ld c, a
; 213         hl += bc;
	add hl, bc
; 214         push_pop(hl) { // Проставляем 0 в конце строки
	push hl
; 215             bc = 7;
	ld bc, 7
; 216             hl += bc;
	add hl, bc
; 217             b = 7;
	ld b, 7
; 218             do {
__l_487:
; 219                 a = *hl;
	ld a, (hl)
; 220                 if (a == 0x20) {
	cp 32
	jp nz, __l_490
; 221                     a = 0;
	ld a, 0
; 222                     *hl = a;
	ld (hl), a
	jp __l_491
__l_490:
; 223                 } else {
; 224                     b = 1;
	ld b, 1
__l_491:
; 225                 }
; 226                 hl--;
	dec hl
; 227                 b--;
	dec b
__l_488:
; 228             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_487
	pop hl
; 229         }
; 230         // NET
; 231         NetFtpUploadFileInitHL();
	call netftpuploadfileinithl
; 232         // Close progress
; 233         LoadViewClose();
	call loadviewclose
	pop bc
	pop hl
	ret
; 234     }
; 235 }
; 236 
; 237 void DiskViewKeyA() {
diskviewkeya:
; 238     push_pop(hl) {
	push hl
; 239         l = a;
	ld l, a
; 240         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_492
; 241             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, __l_494
; 242                 CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
	jp __l_495
__l_494:
; 243             } else {
; 244                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_496
; 245                     DiskViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call diskviewfilecurrentposupdatea
	jp __l_497
__l_496:
; 246                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_498
; 247                     DiskViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call diskviewfilecurrentposupdatea
	jp __l_499
__l_498:
; 248                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, __l_500
; 249                     if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
	ld a, (diskviewfilecurrentpos)
	or a
	jp nz, __l_502
; 250                         DiskViewNextDiskNum();
	call diskviewnextdisknum
	jp __l_503
__l_502:
; 251                     } else { // Запуск приложения
; 252                         DiskViewSelectFileExec();
	call diskviewselectfileexec
__l_503:
	jp __l_501
__l_500:
; 253                     }
; 254                 } else if ((a = l) == 'E') {
	ld a, l
	cp 69
	jp nz, __l_504
; 255                     if ((a = DiskViewFileCurrentPos) > 0) {
	ld a, (diskviewfilecurrentpos)
	or a
	jp z, __l_506
; 256                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 257                         if (a == 1) {
	cp 1
	jp nz, __l_508
; 258                             DiskViewDeleteSelectedFile();
	call diskviewdeleteselectedfile
__l_508:
__l_506:
	jp __l_505
__l_504:
; 259                         }
; 260                     }
; 261                 } else if ((a = l) == 'D') { //  Показать выбор диска
	ld a, l
	cp 68
	jp nz, __l_510
; 262                     SelectDiskViewShow();
	call selectdiskviewshow
	jp __l_511
__l_510:
; 263                 } else if ((a = l) == 'C') { // Загрузка файла на FTP
	ld a, l
	cp 67
	jp nz, __l_512
; 264                     if ((a = DiskViewFileCurrentPos) != 0) {
	ld a, (diskviewfilecurrentpos)
	or a
	jp z, __l_514
; 265                         DiskViewUploadSelectedFile();
	call diskviewuploadselectedfile
; 266                         FtpViewNetLoadAndUpdate(); // обновляем список файлов FTP
	call ftpviewnetloadandupdate
__l_514:
	jp __l_513
__l_512:
; 267                     }
; 268                 } else if ((a = l) == 'F') { //  Отформатировать диск
	ld a, l
	cp 70
	jp nz, __l_516
; 269                     DiskViewFormat();
	call diskviewformat
__l_516:
__l_513:
__l_511:
__l_505:
__l_501:
__l_499:
__l_497:
__l_495:
__l_492:
	pop hl
	ret
; 270                 }
; 271             }
; 272         }
; 273     }
; 274 }
; 275 
; 276 void DiskViewFormat() {
diskviewformat:
; 277     push_pop(hl) {
	push hl
; 278         AllertYesNoViewShowHL(hl = StringLocaleDiskFormat);
	ld hl, stringlocalediskformat
	call allertyesnoviewshowhl
; 279         if (a == 1) {
	cp 1
	jp nz, __l_518
; 280             a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 281             ordos_wnd();
	call ordos_wnd
; 282             hl = 0;
	ld hl, 0
; 283             ordos_wdisk(a = 0xFF);
	ld a, 255
	call ordos_wdisk
; 284             DiskViewReload();
	call diskviewreload
__l_518:
	pop hl
	ret
; 285         }
; 286     }
; 287 }
; 288 
; 289 void DiskViewSelectFileExec() {
diskviewselectfileexec:
; 290     push_pop(hl,de,bc) {
	push hl
	push de
	push bc
; 291         //
; 292         unpackCharCode();
	call unpackcharcode
; 293         //-- ResidentProgram Copy
; 294         push_pop(de,bc) {
	push de
	push bc
; 295             de = DiskViewExecData;
	ld de, diskviewexecdata
; 296             hl = 0xA800; //0xF000;
	ld hl, 43008
; 297             b = 8;
	ld b, 8
; 298             do {
__l_520:
; 299                 a = *de;
	ld a, (de)
; 300                 *hl = a;
	ld (hl), a
; 301                 de++;
	inc de
; 302                 hl++;
	inc hl
; 303                 b--;
	dec b
__l_521:
; 304             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_520
	pop bc
	pop de
; 305         }
; 306         //--
; 307         //unpackCharCode();
; 308         //--
; 309         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 310         ordos_wnd();
	call ordos_wnd
; 311         DiskViewCurrentFileNameHL();
	call diskviewcurrentfilenamehl
; 312         DiskViewResidentProgram();
	call diskviewresidentprogram
	pop bc
	pop de
	pop hl
	ret
; 313         //-- Go to height
; 314 //        ordos_sdma();
; 315 //        ordos_rfile();
; 316 //        
; 317 //        return hl();
; 318     }
; 319 }
; 320 
; 321 /// Проверка, хватит ли места на текущем диске для файла
; 322 /// вх[DE] - размер предпологаемого файла. Еще надо прибавить 16 - для заголовка
; 323 /// вых[A] - 0 - места нет, 1 - место есть
; 324 void DiskViewIsDiskSpaceDE() {
diskviewisdiskspacede:
; 325     push_pop(hl, de) {
	push hl
	push de
; 326         //-- Add 16
; 327         hl = 16;
	ld hl, 16
; 328         hl += de;
	add hl, de
; 329         d = h;
	ld d, h
; 330         e = l;
	ld e, l
; 331         //--
; 332         DiskViewDiskFreeSpaceHL();
	call diskviewdiskfreespacehl
; 333         DiskViewHLSubDE();
	call diskviewhlsubde
	pop de
	pop hl
	ret
; 334     }
; 335 }
; 336 
; 337 /// HL = HL + (-DE)
; 338 /// вх[DE,HL]
; 339 /// вых[HL, A] - HL - результат вычитания , A = 1 HL > DE
; 340 void DiskViewHLSubDE() {
diskviewhlsubde:
; 341     push_pop(de) {
	push de
; 342         a = d; // Инвертируем старший байт D
	ld a, d
; 343         invert(a);
	cpl
; 344         d = a;
	ld d, a
; 345         a = e; // Инвертируем младший байт E
	ld a, e
; 346         invert(a);
	cpl
; 347         e = a;
	ld e, a
; 348         de++; // Получаем точный дополнительный код DE (-DE)
	inc de
; 349         a ^= a;
	xor a
; 350         hl += de; // HL = HL + (-DE), что эквивалентно HL - DE
	add hl, de
; 351         if (flag_c) { // Если HL > DE: перенос будет C = 1.
	jp nc, __l_523
; 352             a = 1;
	ld a, 1
	jp __l_524
__l_523:
; 353         } else {
; 354             a = 0;
	ld a, 0
__l_524:
	pop de
	ret
; 355         }
; 356     }
; 357 }
; 358 
; 359 /// Возвращает свободное место на диске
; 360 /// вых[HL] - результат
; 361 void DiskViewDiskFreeSpaceHL() {
diskviewdiskfreespacehl:
; 362     push_pop(de) {
	push de
; 363         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 364         ordos_wnd();
	call ordos_wnd
; 365         ordos_mxdsk();
	call ordos_mxdsk
; 366         d = h;
	ld d, h
; 367         e = l;
	ld e, l
; 368         //--
; 369         ordos_rmax();
	call ordos_rmax
; 370         //--
; 371         DiskViewHLSubDE();
	call diskviewhlsubde
	pop de
	ret
; 372     }
; 373 }
; 374 
; 375 void DiskViewShowFreeSpace() {
diskviewshowfreespace:
; 376     push_pop(de, hl) {
	push de
	push hl
; 377         a = DiskViewX;
	ld a, (diskviewx)
; 378         e = a;
	ld e, a
; 379         a = DiskViewDX;
	ld a, (diskviewdx)
; 380         a += e;
	add e
; 381         a -= 7;
	sub 7
; 382         myCharPosX = a;
	ld (mycharposx), a
; 383         a = DiskViewY;
	ld a, (diskviewy)
; 384         e = a;
	ld e, a
; 385         a = DiskViewDY;
	ld a, (diskviewdy)
; 386         a += e;
	add e
; 387         a--;
	dec a
; 388         myCharPosY = a;
	ld (mycharposy), a
; 389         //-- 0xB5
; 390         printMyCharA(a = 0xB5);
	ld a, 181
	call printmychara
; 391         //--
; 392         DiskViewDiskFreeSpaceHL();
	call diskviewdiskfreespacehl
; 393         d = h;
	ld d, h
; 394         e = l;
	ld e, l
; 395         FtpViewShow4CharSizeDE();
	call ftpviewshow4charsizede
; 396         //-- 0xC6
; 397         printMyCharA(a = 0xC6);
	ld a, 198
	call printmychara
	pop hl
	pop de
	ret
; 398     }
; 399 }
; 400 
; 401 void DiskViewNextDiskNum() {
diskviewnextdisknum:
; 402     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 403     a++;
	inc a
; 404     if (a == 'E') {
	cp 69
	jp nz, __l_525
; 405         a = 'A';
	ld a, 65
__l_525:
; 406     }
; 407     DiskViewSetDiskNumA();
; 408 }
; 409 
; 410 void DiskViewSetDiskNumA() {
diskviewsetdisknuma:
; 411     push_pop(bc) {
	push bc
; 412         c = a;
	ld c, a
; 413         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 414         if (a != c) {
	cp c
	jp z, __l_527
; 415             a = c;
	ld a, c
; 416             DiskViewDiskNum = a;
	ld (diskviewdisknum), a
; 417             #ifdef _IS_SIMULATOR
; 418             #else
; 419                 NetDiskSetNum();
	call netdisksetnum
; 420             #endif
; 421             DiskViewReload();
	call diskviewreload
__l_527:
	pop bc
	ret
; 422         }
; 423     }
; 424 }
; 425 
; 426 void DiskViewReload() {
diskviewreload:
; 427     DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 428     a = 0;
	ld a, 0
; 429     DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 430     DiskViewUpdateDiskTitle();
	call diskviewupdatedisktitle
; 431     DiskViewUpdateDateAndUI();
; 432 }
; 433 
; 434 void DiskViewUpdateDateAndUI() {
diskviewupdatedateandui:
; 435     DiskViewUpdateDir();
	call diskviewupdatedir
; 436     DiskViewShowDir();
	call diskviewshowdir
; 437     if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_529
; 438         DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
__l_529:
; 439     }
; 440     DiskViewShowFreeSpace();
	jp diskviewshowfreespace
; 441 }
; 442 
; 443 void DiskViewUpdateDiskTitle() {
diskviewupdatedisktitle:
; 444     a = DiskViewX;
	ld a, (diskviewx)
; 445     a += 7;
	add 7
; 446     myCharPosX = a;
	ld (mycharposx), a
; 447     a = DiskViewY;
	ld a, (diskviewy)
; 448     myCharPosY = a;
	ld (mycharposy), a
; 449     printMyCharA(a = DiskViewDiskNum);
	ld a, (diskviewdisknum)
	jp printmychara
; 450 }
; 451 
; 452 /// Обновление позиции
; 453 /// вх[A]
; 454 /// 0 - без изменений
; 455 /// 1 - вверх
; 456 /// 0xFF - вниз
; 457 void DiskViewFileCurrentPosUpdateA() {
diskviewfilecurrentposupdatea:
; 458     push_pop(bc) {
	push bc
; 459         b = a;
	ld b, a
; 460         if (a == 0) {
	or a
	jp nz, __l_531
; 461             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp __l_532
__l_531:
; 462         } else {
; 463             a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 464             a += 1;
	add 1
; 465             c = a;
	ld c, a
; 466             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 467             a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 468             a += b;
	add b
; 469             //
; 470             if (a == 0xFF) {
	cp 255
	jp nz, __l_533
; 471                 a = c;
	ld a, c
; 472                 a--;
	dec a
	jp __l_534
__l_533:
; 473             } else if (a == c) {
	cp c
	jp nz, __l_535
; 474                 a = 0;
	ld a, 0
__l_535:
__l_534:
; 475             }
; 476             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 477             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
__l_532:
	pop bc
	ret
; 478         }
; 479     }
; 480 }
; 481 
; 482 /// Рисование линии прямым или инверсным цветом
; 483 /// 0 - прямой
; 484 /// 1 - инверсный
; 485 void DiskViewShowSelectLineA() {
diskviewshowselectlinea:
; 486     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 487         c = a;
	ld c, a
; 488         // HL
; 489         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 490         b = a;
	ld b, a
; 491         a = DiskViewY;
	ld a, (diskviewy)
; 492         a += 2;
	add 2
; 493         a += b;
	add b
; 494         l = a;
	ld l, a
; 495         a = DiskViewX;
	ld a, (diskviewx)
; 496         a += 1;
	add 1
; 497         h = a;
	ld h, a
; 498         // DE
; 499         a = DiskViewDX;
	ld a, (diskviewdx)
; 500         a -= 2;
	sub 2
; 501         d = a;
	ld d, a
; 502         a = 1;
	ld a, 1
; 503         e = a;
	ld e, a
; 504         // C
; 505         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_537
; 506             a = DiskViewColor;
	ld a, (diskviewcolor)
	jp __l_538
__l_537:
; 507         } else {
; 508             a = DiskViewInvColor;
	ld a, (diskviewinvcolor)
__l_538:
; 509         }
; 510         c = a;
	ld c, a
; 511         // A
; 512         a = vboxUMP;
	ld a, 4
; 513         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 514     }
; 515 }
; 516 
; 517 uint8_t DiskViewX = 28;
diskviewx:
	db 28
; 518 uint8_t DiskViewY = 4;
diskviewy:
	db 4
; 519 uint8_t DiskViewDX = 20;
diskviewdx:
	db 20
; 520 uint8_t DiskViewDY = 25;
diskviewdy:
	db 25
; 521 uint8_t DiskViewColor = 0x1F;
diskviewcolor:
	db 31
; 522 uint8_t DiskViewInvColor = 0xF1;
diskviewinvcolor:
	db 241
; 524 uint8_t DiskViewDiskNum = 'B';
diskviewdisknum:
	db 66
; 525 uint8_t DiskViewDirCount = 0;
diskviewdircount:
	db 0
; 526 uint16_t DiskViewDirBufer = 0x0000;
diskviewdirbufer:
	dw 0
; 527 uint8_t DiskViewFileCurrentPos = 0;
diskviewfilecurrentpos:
	db 0
; 529 uint16_t DiskViewStartNewFile = 0x0000;
diskviewstartnewfile:
	dw 0
; 531 uint8_t DiskViewDirRootTitle[] = "..";
diskviewdirroottitle:
	db 46
	db 46
	ds 1
; 532 uint8_t DiskViewTitle[] = {0xB5, 'D', 'i', 's', 'k', ':', 'A', 0xC6, '\0'};
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
; 535 uint8_t DiskViewExecData[] = {0xCD , 0xD0 , 0xBF , 0xCD , 0xFA , 0xBF , 0xE9 , 0x00};
diskviewexecdata:
	db 205
	db 208
	db 191
	db 205
	db 250
	db 191
	db 233
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
__l_539:
; 69             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 70             b--;
	dec b
__l_540:
; 71         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_539
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
__l_542:
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
__l_543:
; 86         } while ((a = b) < 4);
	ld a, b
	cp 4
	jp c, __l_542
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
	jp z, __l_545
; 102             do {
__l_547:
; 103                 a = h;
	ld a, h
; 104                 a += 3;
	add 3
; 105                 h = a;
	ld h, a
; 106                 b--;
	dec b
__l_548:
; 107             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_547
__l_545:
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
	jp nz, __l_550
; 119             a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
	jp __l_551
__l_550:
; 120         } else {
; 121             a = SelectDiskViewInvColor;
	ld a, (selectdiskviewinvcolor)
__l_551:
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
	jp nz, __l_552
; 144             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_554
; 145                 vboxClose();
	call vboxclose
; 146                 CurrentViewReturn();
	call currentviewreturn
	jp __l_555
__l_554:
; 147             } else if ((a = l) == 0x0D) { // Выбор диска
	ld a, l
	cp 13
	jp nz, __l_556
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
	jp __l_557
__l_556:
; 153             } else if ((a = l) == 0x18) { // Вправл
	ld a, l
	cp 24
	jp nz, __l_558
; 154                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 155                 a++;
	inc a
; 156                 if (a == 4) {
	cp 4
	jp nz, __l_560
; 157                     a = 0;
	ld a, 0
__l_560:
; 158                 }
; 159                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
	jp __l_559
__l_558:
; 160             } else if ((a = l) == 0x08) { // Влево
	ld a, l
	cp 8
	jp nz, __l_562
; 161                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 162                 if (a == 0) {
	or a
	jp nz, __l_564
; 163                     a = 3;
	ld a, 3
	jp __l_565
__l_564:
; 164                 } else {
; 165                     a--;
	dec a
__l_565:
; 166                 }
; 167                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
__l_562:
__l_559:
__l_557:
__l_555:
__l_552:
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
	jp nz, __l_566
; 79             hl = FtpStateViewStatus0;
	ld hl, ftpstateviewstatus0
; 80             a = FtpStateViewColor;
	ld a, (ftpstateviewcolor)
; 81             c = a;
	ld c, a
	jp __l_567
__l_566:
; 82         } else {
; 83             hl = FtpStateViewStatus1;
	ld hl, ftpstateviewstatus1
; 84             a = FtpStateViewConnectColor;
	ld a, (ftpstateviewconnectcolor)
; 85             c = a;
	ld c, a
__l_567:
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
; 111 uint8_t FtpStateViewColor = 0x07; //0x5f; //0x67; 07
ftpstateviewcolor:
	db 7
; 112 uint8_t FtpStateViewConnectColor = 0x02; //0x52;
ftpstateviewconnectcolor:
	db 2
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
__l_568:
; 65             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 66             b--;
	dec b
__l_569:
; 67         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_568
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
	jp nz, __l_571
; 108             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp __l_572
__l_571:
; 109         } else {
; 110             bc = StringLocaleOK;
	ld bc, stringlocaleok
__l_572:
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
	jp nz, __l_573
; 176         bc = FtpStateViewIpValue;
	ld bc, ftpstateviewipvalue
	jp __l_574
__l_573:
; 177     } else if ((a = FtpSettingsViewSelectPos) == 2) {
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, __l_575
; 178         bc = FtpSettingsViewValuePort;
	ld bc, ftpsettingsviewvalueport
	jp __l_576
__l_575:
; 179     } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, __l_577
; 180         bc = FtpSettingsViewValueUser;
	ld bc, ftpsettingsviewvalueuser
	jp __l_578
__l_577:
; 181     } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, __l_579
; 182         bc = FtpSettingsViewValuePass;
	ld bc, ftpsettingsviewvaluepass
	jp __l_580
__l_579:
; 183     } else if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, __l_581
; 184         bc = FtpSettingsViewValueHomeDir;
	ld bc, ftpsettingsviewvaluehomedir
	jp __l_582
__l_581:
; 185     } else {
; 186         bc = 0;
	ld bc, 0
__l_582:
__l_580:
__l_578:
__l_576:
__l_574:
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
	jp nz, __l_583
; 222             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
	jp __l_584
__l_583:
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
	jp nz, __l_585
; 232                 a = c;
	ld a, c
; 233                 a--;
	dec a
	jp __l_586
__l_585:
; 234             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, __l_587
; 235                 a = 0;
	ld a, 0
__l_587:
__l_586:
; 236             }
; 237             //--
; 238             FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 239             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
__l_584:
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
	jp nz, __l_589
; 252             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp __l_590
__l_589:
; 253         } else {
; 254             FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 255             // C
; 256             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_591
; 257                 a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
	jp __l_592
__l_591:
; 258             } else {
; 259                 a = FtpSettingsViewInvColor;
	ld a, (ftpsettingsviewinvcolor)
__l_592:
; 260             }
; 261             c = a;
	ld c, a
; 262             // A
; 263             a = vboxUMP;
	ld a, 4
; 264             vboxOpenHLDECA();
	call vboxopenhldeca
__l_590:
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
	jp nz, __l_593
; 273             if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_595
; 274                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_597
; 275                     FtpSettingsViewClose();
	call ftpsettingsviewclose
	jp __l_598
__l_597:
; 276                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_599
; 277                     if ((a = FtpSettingsViewSelectPos) == 0) { // OK
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, __l_601
; 278                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 279                         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, __l_603
; 280                             NetFtpConnect();
	call netftpconnect
; 281                             ThreadsTickNow();
	call threadsticknow
__l_603:
	jp __l_602
__l_601:
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
	jp nz, __l_605
; 288                             if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, __l_607
; 289                                 ThreadsNetFtpHomeDirUpdate();
	call threadsnetftphomedirupdate
	jp __l_608
__l_607:
; 290                             } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, __l_609
; 291                                 ThreadsNetFtpUserUpdate();
	call threadsnetftpuserupdate
	jp __l_610
__l_609:
; 292                             } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, __l_611
; 293                                 ThreadsNetFtpPasswordUpdate();
	call threadsnetftppasswordupdate
	jp __l_612
__l_611:
; 294                             } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, __l_613
; 295                                 ThreadsNetFtpServerUrlUpdate();
	call threadsnetftpserverurlupdate
; 296                                 FtpStateViewShowValue();
	call ftpstateviewshowvalue
	jp __l_614
__l_613:
; 297                             } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, __l_615
; 298                                 ThreadsNetFtpPortUpdate();
	call threadsnetftpportupdate
__l_615:
__l_614:
__l_612:
__l_610:
__l_608:
; 299                             }
; 300                             FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
__l_605:
__l_602:
	jp __l_600
__l_599:
; 301                         }
; 302                     }
; 303                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_617
; 304                     FtpSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call ftpsettingsviewposupdatea
	jp __l_618
__l_617:
; 305                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_619
; 306                     FtpSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpsettingsviewposupdatea
__l_619:
__l_618:
__l_600:
__l_598:
__l_595:
__l_593:
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
; 48     //-- нельзя обновлять, если есть хоть какое то открытое окно
; 49     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 50     if (a == 0) {
	or a
	jp nz, __l_621
; 51         return;
	ret
__l_621:
; 52     }
; 53     //--
; 54     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 55         b = 0;
	ld b, 0
; 56         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 57         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 58         c = a;
	ld c, a
; 59         do {
__l_623:
; 60             a = FtpViewY;
	ld a, (ftpviewy)
; 61             a += 2;
	add 2
; 62             a += b;
	add b
; 63             myCharPosY = a;
	ld (mycharposy), a
; 64             FtpViewShowFileHL();
	call ftpviewshowfilehl
; 65             // HL + 16 next file
; 66             a ^= a;
	xor a
; 67             a = 16;
	ld a, 16
; 68             a += l;
	add l
; 69             l = a;
	ld l, a
; 70             if (flag_c) {
	jp nc, __l_626
; 71                 h++;
	inc h
__l_626:
; 72             }
; 73             b++;
	inc b
__l_624:
; 74         } while ((a = b) < c);
	ld a, b
	cp c
	jp c, __l_623
; 75         // Заполнить пустыми строками
; 76         a = FtpViewX;
	ld a, (ftpviewx)
; 77         a += 1;
	add 1
; 78         d = a; // X
	ld d, a
; 79         a = FtpViewY;
	ld a, (ftpviewy)
; 80         a += 2;
	add 2
; 81         e = a; // Y
	ld e, a
; 82         //--
; 83         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 84         b = a;
	ld b, a
; 85         // PosY
; 86         a = e;
	ld a, e
; 87         a += b;
	add b
; 88         e = a;
	ld e, a
; 89         //
; 90         a = FtpViewDY;
	ld a, (ftpviewdy)
; 91         a -= 4;
	sub 4
; 92         a -= b;
	sub b
; 93         b = a;
	ld b, a
; 94         c = 0;
	ld c, 0
; 95         do {
__l_628:
; 96             a = d;
	ld a, d
; 97             myCharPosX = a;
	ld (mycharposx), a
; 98             a = e;
	ld a, e
; 99             a += c;
	add c
; 100             myCharPosY = a;
	ld (mycharposy), a
; 101             //
; 102             a = FtpViewDX;
	ld a, (ftpviewdx)
; 103             a -= 3;
	sub 3
; 104             h = a;
	ld h, a
; 105             do {
__l_631:
; 106                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 107                 h--;
	dec h
__l_632:
; 108             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, __l_631
; 109             b--;
	dec b
; 110             c++;
	inc c
__l_629:
; 111         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_628
	pop hl
	pop de
	pop bc
	ret
; 112     }
; 113 }
; 114 
; 115 void FtpViewShowFileHL() {
ftpviewshowfilehl:
; 116     push_pop(bc, hl) {
	push bc
	push hl
; 117         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_634
; 118             FtpViewShowFileName();
	call ftpviewshowfilename
	jp __l_635
__l_634:
; 119         } else {
; 120             FtpViewShowFileName();
	call ftpviewshowfilename
; 121             FtpViewShowFileSize();
	call ftpviewshowfilesize
; 122             FtpViewShowFileDate();
	call ftpviewshowfiledate
__l_635:
	pop hl
	pop bc
	ret
; 123         }
; 124     }
; 125 }
; 126 
; 127 // A = 1 - Dir
; 128 void FtpViewShowIsDirA() {
ftpviewshowisdira:
; 129     push_pop(bc) {
	push bc
; 130         a &= 0x01;
	and 1
; 131         b = a;
	ld b, a
; 132         a = FtpViewX;
	ld a, (ftpviewx)
; 133         a += 1;
	add 1
; 134         myCharPosX = a;
	ld (mycharposx), a
; 135         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_636
; 136             printMyCharA(a = 0x1F); //0x10
	ld a, 31
	call printmychara
	jp __l_637
__l_636:
; 137         } else {
; 138             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
__l_637:
	pop bc
	ret
; 139         }
; 140     }
; 141 }
; 142 
; 143 void FtpViewShowFileName() {
ftpviewshowfilename:
; 144     // X pos
; 145     a = FtpViewX;
	ld a, (ftpviewx)
; 146     a += 2;
	add 2
; 147     myCharPosX = a;
	ld (mycharposx), a
; 148     //
; 149     b = 8;
	ld b, 8
; 150     do {
__l_638:
; 151         printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 152         hl++;
	inc hl
; 153         b--;
	dec b
__l_639:
; 154     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_638
	ret
; 155 }
; 156 
; 157 void FtpViewShowFileSize() {
ftpviewshowfilesize:
; 158     push_pop(bc, de) {
	push bc
	push de
; 159         // X pos
; 160         a = FtpViewX;
	ld a, (ftpviewx)
; 161         a += 11;
	add 11
; 162         myCharPosX = a;
	ld (mycharposx), a
; 163         //
; 164         a = *hl;
	ld a, (hl)
; 165         d = a;
	ld d, a
; 166         hl++;
	inc hl
; 167         a = *hl;
	ld a, (hl)
; 168         e = a;
	ld e, a
; 169         hl++;
	inc hl
; 170         a = *hl;
	ld a, (hl)
; 171         hl++;
	inc hl
; 172         a &= 0x01;
	and 1
; 173         if (a == 0x00) {
	or a
	jp nz, __l_641
; 174             push_pop(hl) {
	push hl
; 175                 h = 0; // файл для Орион
	ld h, 0
; 176                 if ((a = d) == 0xFF) {
	ld a, d
	cp 255
	jp nz, __l_643
; 177                     if ((a = e) == 0xFF) {
	ld a, e
	cp 255
	jp nz, __l_645
; 178                         h = 1; // Файл слишком большой для Орион
	ld h, 1
__l_645:
__l_643:
; 179                     }
; 180                 }
; 181                 if ((a = h) == 0) { // Показываем размер
	ld a, h
	or a
	jp nz, __l_647
; 182                     FtpViewShow4CharSizeDE();
	call ftpviewshow4charsizede
	jp __l_648
__l_647:
; 183                 } else { // Файл слишком большой
; 184                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 185                     printMyCharA(a = 'B');
	ld a, 66
	call printmychara
; 186                     printMyCharA(a = 'I');
	ld a, 73
	call printmychara
; 187                     printMyCharA(a = 'G');
	ld a, 71
	call printmychara
__l_648:
	pop hl
; 188                 }
; 189             }
; 190             FtpViewShowIsDirA(a = 0);
	ld a, 0
	call ftpviewshowisdira
	jp __l_642
__l_641:
; 191         } else {
; 192             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 193             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 194             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 195             printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 196             FtpViewShowIsDirA(a = 1);
	ld a, 1
	call ftpviewshowisdira
__l_642:
	pop de
	pop bc
	ret
; 197         }
; 198     }
; 199 }
; 200 
; 201 void FtpViewShow4CharSizeDE() {
ftpviewshow4charsizede:
; 202     if ((a = d) < 4) { // < 1024 в байтах //flag_c
	ld a, d
	cp 4
	jp nc, __l_649
; 203         push_pop(hl) {
	push hl
; 204             h = d;
	ld h, d
; 205             l = e;
	ld l, e
; 206             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
	jp __l_650
__l_649:
; 207         }
; 208     } else { // В Кб
; 209         a = d;
	ld a, d
; 210         a &= 0xFC;
	and 252
; 211         cyclic_rotate_right(a, 2);
	rrca
	rrca
; 212         printMyAsDec99A();
	call printmyasdec99a
; 213         printMyCharA(a = 'K');
	ld a, 75
	call printmychara
; 214         printMyCharA(a = 'b');
	ld a, 98
	call printmychara
__l_650:
	ret
; 215     }
; 216 }
; 217 
; 218 void FtpViewShowFileDate() {
ftpviewshowfiledate:
; 219     push_pop(bc, de) {
	push bc
	push de
; 220         // X pos
; 221         a = FtpViewX;
	ld a, (ftpviewx)
; 222         a += 16;
	add 16
; 223         myCharPosX = a;
	ld (mycharposx), a
; 224         //-- GGGG
; 225         d = *hl;
	ld d, (hl)
; 226         hl++;
	inc hl
; 227         e = *hl;
	ld e, (hl)
; 228         hl++;
	inc hl
; 229         push_pop(hl) {
	push hl
; 230             h = d;
	ld h, d
; 231             l = e;
	ld l, e
; 232             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
; 233         }
; 234         //--
; 235         printMyCharA(a = '-');
	ld a, 45
	call printmychara
; 236         //--
; 237         printMyAs00Dec99A(a = *hl);
	ld a, (hl)
	call printmyas00dec99a
; 238         hl++;
	inc hl
; 239         //--
; 240         printMyCharA(a = '-');
	ld a, 45
	call printmychara
; 241         //--
; 242         printMyAs00Dec99A(a = *hl);
	ld a, (hl)
	call printmyas00dec99a
; 243         hl++;
	inc hl
	pop de
	pop bc
	ret
; 244     }
; 245 }
; 246 
; 247 void FtpViewShowPath() {
ftpviewshowpath:
; 248     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 249         a = FtpViewX;
	ld a, (ftpviewx)
; 250         b = a;
	ld b, a
; 251         a = FtpViewDX;
	ld a, (ftpviewdx)
; 252         a += b;
	add b
; 253         a -= 19;
	sub 19
; 254         myCharPosX = a;
	ld (mycharposx), a
; 255         a = FtpViewY;
	ld a, (ftpviewy)
; 256         myCharPosY = a;
	ld (mycharposy), a
; 257         de = FtpViewPath;
	ld de, ftpviewpath
; 258         printMyCharA(a = 0xB5);
	ld a, 181
	call printmychara
; 259         b = 16;
	ld b, 16
; 260         c = 0;
	ld c, 0
; 261         do {
__l_651:
; 262             a = *de;
	ld a, (de)
; 263             de++;
	inc de
; 264             if (a == 0) {
	or a
	jp nz, __l_654
; 265                 c = 1;
	ld c, 1
__l_654:
; 266             }
; 267             h = a;
	ld h, a
; 268             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_656
; 269                 printMyCharA(a = h);
	ld a, h
	call printmychara
	jp __l_657
__l_656:
; 270             } else {
; 271                 printMyCharA(a = ' ');
	ld a, 32
	call printmychara
__l_657:
; 272             }
; 273             b--;
	dec b
__l_652:
; 274         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_651
; 275         printMyCharA(a = 0xC6);
	ld a, 198
	call printmychara
	pop hl
	pop de
	pop bc
	ret
; 276     }
; 277 }
; 278 
; 279 /// Обновление позиции
; 280 /// вх[A]
; 281 /// 0 - без изменений
; 282 /// 1 - вверх
; 283 /// 0xFF - вниз
; 284 void FtpViewFileCurrentPosUpdateA() {
ftpviewfilecurrentposupdatea:
; 285     push_pop(bc) {
	push bc
; 286         b = a;
	ld b, a
; 287         if (a == 0) {
	or a
	jp nz, __l_658
; 288             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
	jp __l_659
__l_658:
; 289         } else {
; 290             a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 291             c = a;
	ld c, a
; 292             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 293             a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 294             a += b;
	add b
; 295             //
; 296             if (a == 0xFF) {
	cp 255
	jp nz, __l_660
; 297                 a = c;
	ld a, c
; 298                 a--;
	dec a
	jp __l_661
__l_660:
; 299             } else if (a == c) {
	cp c
	jp nz, __l_662
; 300                 a = 0;
	ld a, 0
__l_662:
__l_661:
; 301             }
; 302             FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 303             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_659:
	pop bc
	ret
; 304         }
; 305     }
; 306 }
; 307 
; 308 /// Рисование линии прямым или инверсным цветом
; 309 /// 0 - прямой
; 310 /// 1 - инверсный
; 311 void FtpViewShowSelectLineA() {
ftpviewshowselectlinea:
; 312     push_pop(bc) {
	push bc
; 313         c = a;
	ld c, a
; 314         // HL
; 315         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 316         b = a;
	ld b, a
; 317         a = FtpViewY;
	ld a, (ftpviewy)
; 318         a += 2;
	add 2
; 319         a += b;
	add b
; 320         l = a;
	ld l, a
; 321         a = FtpViewX;
	ld a, (ftpviewx)
; 322         a += 1;
	add 1
; 323         h = a;
	ld h, a
; 324         // DE
; 325         a = FtpViewDX;
	ld a, (ftpviewdx)
; 326         a -= 2;
	sub 2
; 327         d = a;
	ld d, a
; 328         a = 1;
	ld a, 1
; 329         e = a;
	ld e, a
; 330         // C
; 331         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_664
; 332             a = FtpViewColor;
	ld a, (ftpviewcolor)
	jp __l_665
__l_664:
; 333         } else {
; 334             a = FtpViewInvColor;
	ld a, (ftpviewinvcolor)
__l_665:
; 335         }
; 336         c = a;
	ld c, a
; 337         // A
; 338         a = vboxUMP;
	ld a, 4
; 339         vboxOpenHLDECA();
	call vboxopenhldeca
	pop bc
	ret
; 340     }
; 341 }
; 342 
; 343 void FtpViewKeyA() {
ftpviewkeya:
; 344     push_pop(hl) {
	push hl
; 345         l = a;
	ld l, a
; 346         if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_666
; 347             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, __l_668
; 348                 CurrentViewChangeIdA(a = DiskViewId);
	ld a, 1
	call currentviewchangeida
	jp __l_669
__l_668:
; 349             } else {
; 350                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_670
; 351                     FtpViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call ftpviewfilecurrentposupdatea
	jp __l_671
__l_670:
; 352                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_672
; 353                     FtpViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpviewfilecurrentposupdatea
	jp __l_673
__l_672:
; 354                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, __l_674
; 355                     if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
	ld a, (ftpviewfilecurrentpos)
	or a
	jp nz, __l_676
; 356                         NetFtpChangeDirUp();
	call netftpchangedirup
; 357                         FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_677
__l_676:
; 358                     } else {
; 359                         FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 360                         if (a == 1) { // Enter Dir
	cp 1
	jp nz, __l_678
; 361                             FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
	ld a, 0
	call ftpviewshowselectlinea
; 362                             NetFtpChangeDirIndexA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftpchangedirindexa
; 363                             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_679
__l_678:
; 364                         } else { // Load file
; 365                             FtpViewAccessDiskSpace();
	call ftpviewaccessdiskspace
__l_679:
__l_677:
	jp __l_675
__l_674:
; 366                         }
; 367                     }
; 368                 } else if ((a = l) == 'R') { // Обновление папки
	ld a, l
	cp 82
	jp nz, __l_680
; 369                     FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_681
__l_680:
; 370                 } else if ((a = l) == 'C') { // загрузка файла
	ld a, l
	cp 67
	jp nz, __l_682
; 371                     FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 372                     if (a == 0) { // Проверим что это файл
	or a
	jp nz, __l_684
; 373                         FtpViewAccessDiskSpace();
	call ftpviewaccessdiskspace
__l_684:
	jp __l_683
__l_682:
; 374                     }
; 375                 } else if ((a = l) == 'H') { // Перейти в домашную папку
	ld a, l
	cp 72
	jp nz, __l_686
; 376                     ThreadsNetFtpGoToHomeDir();
	call threadsnetftpgotohomedir
	jp __l_687
__l_686:
; 377                 } else if ((a = l) == 'E') { // Удалить файл
	ld a, l
	cp 69
	jp nz, __l_688
; 378                     if ((a = FtpViewFileCurrentPos) > 0) {
	ld a, (ftpviewfilecurrentpos)
	or a
	jp z, __l_690
; 379                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 380                         if (a == 1) {
	cp 1
	jp nz, __l_692
; 381                             ThreadsNetFtpDeleteFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call threadsnetftpdeletefilea
__l_692:
__l_690:
	jp __l_689
__l_688:
; 382                         }
; 383                     }
; 384                 } else if ((a = l) == 'D') { // Создание новой папки
	ld a, l
	cp 68
	jp nz, __l_694
; 385                     FtpMakeDirectoryShow();
	call ftpmakedirectoryshow
__l_694:
__l_689:
__l_687:
__l_683:
__l_681:
__l_675:
__l_673:
__l_671:
__l_669:
__l_666:
	pop hl
	ret
; 386                 }
; 387             }
; 388         }
; 389     }
; 390 }
; 391 
; 392 void FtpViewAccessDiskSpace() {
ftpviewaccessdiskspace:
; 393     push_pop(de, hl) {
	push de
	push hl
; 394 //        a = 0;
; 395 //        myCharPosX = a;
; 396 //        a = 0;
; 397 //        myCharPosY = a;
; 398         // Находим указатель на файл
; 399         d = 0;
	ld d, 0
; 400         a ^= a;
	xor a
; 401         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 402         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 403         e = a;
	ld e, a
; 404         if (flag_c) {
	jp nc, __l_696
; 405             d = 1;
	ld d, 1
__l_696:
; 406         }
; 407         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 408         hl += de;
	add hl, de
; 409         // Сдвигаем к размеру файла и читаем размер
; 410         de = 8;
	ld de, 8
; 411         hl += de;
	add hl, de
; 412         //
; 413         a = *hl;
	ld a, (hl)
; 414         d = a;
	ld d, a
; 415         hl++;
	inc hl
; 416         a = *hl;
	ld a, (hl)
; 417         e = a;
	ld e, a
; 418         //
; 419 //        printMyHexA(a = d);
; 420 //        printMyHexA(a = e);
; 421         //
; 422         DiskViewIsDiskSpaceDE();
	call diskviewisdiskspacede
; 423         if (a == 1) {
	cp 1
	jp nz, __l_698
; 424             FtpViewLoadFile();
	call ftpviewloadfile
	jp __l_699
__l_698:
; 425         } else {
; 426             AllertOkViewShowHL(hl = StringLocaleDiskFull);
	ld hl, stringlocalediskfull
	call allertokviewshowhl
__l_699:
	pop hl
	pop de
	ret
; 427         }
; 428     }
; 429 }
; 430 
; 431 void FtpViewLoadFile() {
ftpviewloadfile:
; 432     //--
; 433     a ^= a;
	xor a
; 434     d = 0;
	ld d, 0
; 435     a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 436     carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 437     e = a;
	ld e, a
; 438     if (flag_c) {
	jp nc, __l_700
; 439         d++;
	inc d
__l_700:
; 440     }
; 441     hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 442     hl += de;
	add hl, de
; 443     //--
; 444     LoadViewShowHL(hl = LoadViewLoadTitle);
	ld hl, loadviewloadtitle
	call loadviewshowhl
; 445     #ifdef _IS_SIMULATOR
; 446         push_pop(bc) {
; 447             b = 0;
; 448             do {
; 449                 LoadViewShowProgressA(a = b);
; 450                 c = 1;
; 451                 do {
; 452                     delay50ms();
; 453                     c--;
; 454                 } while ((a = c) > 0);
; 455                 b++;
; 456             } while ((a = b) < 40);
; 457             LoadViewClose();
; 458             DiskViewUpdateDateAndUI();
; 459         }
; 460     #else
; 461         FtpViewNeedLoad();
	call ftpviewneedload
; 462         LoadViewClose();
	call loadviewclose
; 463         DiskViewUpdateDateAndUI();
	jp diskviewupdatedateandui
; 464     #endif
; 465 }
; 466 
; 467 void FtpViewNeedLoad() {
ftpviewneedload:
; 468     NetFtpLoadFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftploadfilea
; 469     
; 470     // Считываем текущий диск и устанавливаем его
; 471     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 472     ordos_wnd();
	call ordos_wnd
; 473     
; 474     // Получаем адрес куда надо начинать писать данные
; 475     ordos_mxdsk();
	call ordos_mxdsk
; 476     DiskViewStartNewFile = hl;
	ld (diskviewstartnewfile), hl
; 477     
; 478     // Вызываем закачку
; 479     NetFtpLoadFileNext();
	jp netftploadfilenext
; 480 }
; 481 
; 482 void FtpViewNetLoadAndUpdate() {
ftpviewnetloadandupdate:
; 483     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 484     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 485     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, __l_702
; 486         NetFtpUpdateList();
	call netftpupdatelist
; 487         NetFtpListFiles();
	call netftplistfiles
__l_702:
; 488     }
; 489     a = 0;
	ld a, 0
; 490     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 491     FtpViewShowFileList();
	call ftpviewshowfilelist
; 492     FtpViewShowPath();
	call ftpviewshowpath
; 493     // Показываем курсор, если выбран FTP
; 494     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_704
; 495         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_704:
	ret
; 496     }
; 497 }
; 498 
; 499 void FtpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 500     push_pop(hl, bc) {
	push hl
	push bc
; 501         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 502         //--
; 503         a ^= a;
	xor a
; 504         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 505         a &= 0x3F;
	and 63
; 506         b = 0;
	ld b, 0
; 507         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 508         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_706
; 509             b++;
	inc b
__l_706:
; 510         }
; 511         c = a;
	ld c, a
; 512         //-- Смещаем на позицию файла
; 513         hl += bc;
	add hl, bc
; 514         //-- Смещаем на признак директории
; 515         bc = 10;
	ld bc, 10
; 516         hl += bc;
	add hl, bc
; 517         //--
; 518         a = *hl;
	ld a, (hl)
; 519         a &= 0x01;
	and 1
	pop bc
	pop hl
	ret
; 520     }
; 521 }
; 522 
; 523 void FtpViewEmptyList() {
ftpviewemptylist:
; 524     push_pop(hl) {
	push hl
; 525         a = 1;
	ld a, 1
; 526         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 527         a = 0;
	ld a, 0
; 528         FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 529         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 530         //--
; 531         *hl = '.';
	ld (hl), 46
; 532         hl++;
	inc hl
; 533         *hl = '.';
	ld (hl), 46
; 534         hl++;
	inc hl
; 535         //--
; 536         *hl = ' ';
	ld (hl), 32
; 537         hl++;
	inc hl
; 538         *hl = ' ';
	ld (hl), 32
; 539         hl++;
	inc hl
; 540         *hl = ' ';
	ld (hl), 32
; 541         hl++;
	inc hl
; 542         *hl = ' ';
	ld (hl), 32
; 543         hl++;
	inc hl
; 544         *hl = ' ';
	ld (hl), 32
; 545         hl++;
	inc hl
; 546         *hl = ' ';
	ld (hl), 32
; 547         hl++;
	inc hl
	pop hl
; 548     }
; 549     //--
; 550     FtpViewListUpdateUI();
; 551 }
; 552 
; 553 void FtpViewListUpdateUI() {
ftpviewlistupdateui:
; 554     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 555     a = 0;
	ld a, 0
; 556     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 557     FtpViewShowPath();
	call ftpviewshowpath
; 558     FtpViewShowFileList();
	call ftpviewshowfilelist
; 559     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_708
; 560         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_708:
	ret
; 561     }
; 562 }
; 563 
; 564 uint8_t FtpViewX = 0;
ftpviewx:
	db 0
; 565 uint8_t FtpViewY = 4;
ftpviewy:
	db 4
; 566 uint8_t FtpViewDX = 28;
ftpviewdx:
	db 28
; 567 uint8_t FtpViewDY = 25;
ftpviewdy:
	db 25
; 568 uint8_t FtpViewColor = 0x1F;
ftpviewcolor:
	db 31
; 569 uint8_t FtpViewInvColor = 0xF1;
ftpviewinvcolor:
	db 241
; 571 uint8_t FtpViewTitle[] = {0xB5, 'F', 'T', 'P', 0xC6, '\0'}; //"\x12" + "FTP";
ftpviewtitle:
	db 181
	db 70
	db 84
	db 80
	db 198
	db 0
; 572 uint8_t FtpViewPath[16] = "/";
ftpviewpath:
	db 47
	ds 15
; 574 uint8_t FtpViewFileCurrentPos = 0;
ftpviewfilecurrentpos:
	db 0
; 588 uint8_t FtpViewFilesListCount = 1;
ftpviewfileslistcount:
	db 1
; 589 uint8_t FtpViewFilesList[16 * 23] = {
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
__l_710:
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
	jp nc, __l_713
; 49                     a = 0;
	ld a, 0
; 50                     c = a;
	ld c, a
__l_713:
__l_711:
; 51                 }
; 52             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_710
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
	jp z, __l_715
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
__l_717:
; 89                 if ((a = b) < c) {
	ld a, b
	cp c
	jp nc, __l_720
; 90                     printMyCharA(a = 0xDB);
	ld a, 219
	call printmychara
	jp __l_721
__l_720:
; 91                 } else {
; 92                     printMyCharA(a = 0xB0); //0xB0 0xB1 0xB2
	ld a, 176
	call printmychara
__l_721:
; 93                 }
; 94                 b++;
	inc b
__l_718:
; 95             } while ((a = b) < 40);
	ld a, b
	cp 40
	jp c, __l_717
__l_715:
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
__l_722:
; 57             a = *hl;
	ld a, (hl)
; 58             if (a == 0) {
	or a
	jp nz, __l_725
; 59                 a = '-';
	ld a, 45
; 60                 *hl = a;
	ld (hl), a
__l_725:
; 61             }
; 62             hl += de;
	add hl, de
; 63             b--;
	dec b
__l_723:
; 64         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_722
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
__l_727:
; 89             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 90             b--;
	dec b
__l_728:
; 91         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_727
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
	jp nz, __l_730
; 104             if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, __l_732
; 105                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_734
; 106                     WiFiNetworksViewClose();
	call wifinetworksviewclose
	jp __l_735
__l_734:
; 107                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_736
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
	jp __l_737
__l_736:
; 117                     //--
; 118                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_738
; 119                     WiFiNetworksViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifinetworksviewposupdatea
	jp __l_739
__l_738:
; 120                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_740
; 121                     WiFiNetworksViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifinetworksviewposupdatea
__l_740:
__l_739:
__l_737:
__l_735:
__l_732:
__l_730:
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
__l_742:
; 142             a = *hl;
	ld a, (hl)
; 143             *de = a;
	ld (de), a
; 144             if (a == 0) {
	or a
	jp nz, __l_745
; 145                 c = 1;
	ld c, 1
__l_745:
; 146             }
; 147             hl++;
	inc hl
; 148             de++;
	inc de
; 149             b--;
	dec b
__l_743:
; 150         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_742
; 151         //-- if stop byte (0)
; 152         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_747
; 153             de--;
	dec de
; 154             a = 0;
	ld a, 0
; 155             *de = a;
	ld (de), a
__l_747:
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
__l_749:
; 165             *hl = 0;
	ld (hl), 0
; 166             hl++;
	inc hl
; 167             b--;
	dec b
__l_750:
; 168         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_749
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
__l_752:
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
__l_755:
; 194                 printMyCharA(a = *hl);
	ld a, (hl)
	call printmychara
; 195                 hl++;
	inc hl
; 196                 b--;
	dec b
__l_756:
; 197             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_755
; 198             c++;
	inc c
__l_753:
; 199         } while ((a = WiFiNetworksViewSSIDCount) >= c);
	ld a, (wifinetworksviewssidcount)
	cp c
	jp nc, __l_752
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
	jp z, __l_758
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
__l_760:
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
__l_763:
; 223                     printMyCharA(a = ' ');
	ld a, 32
	call printmychara
; 224                     c--;
	dec c
__l_764:
; 225                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_763
; 226                 b--;
	dec b
; 227                 h++;
	inc h
__l_761:
; 228             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_760
__l_758:
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
	jp nz, __l_766
; 242             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
	jp __l_767
__l_766:
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
	jp nz, __l_768
; 248                 a = 0;
	ld a, 0
; 249                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
	jp __l_769
__l_768:
; 250             } else { // если есть хоть одна запись
; 251                 a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 252                 a += b;
	add b
; 253                 //-- FIX
; 254                 if (a == 0xFF) {
	cp 255
	jp nz, __l_770
; 255                     a = c;
	ld a, c
; 256                     a--;
	dec a
	jp __l_771
__l_770:
; 257                 } else if (a == c) {
	cp c
	jp nz, __l_772
; 258                     a = 0;
	ld a, 0
__l_772:
__l_771:
; 259                 }
; 260                 //--
; 261                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
__l_769:
; 262             }
; 263             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
__l_767:
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
	jp nz, __l_774
; 292             a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
	jp __l_775
__l_774:
; 293         } else {
; 294             a = WiFiNetworksViewInvColor;
	ld a, (wifinetworksviewinvcolor)
__l_775:
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
__l_776:
; 66             getKeyboardCharA();
	call getkeyboardchara
; 67             c = a;
	ld c, a
; 68             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_779
; 69                 b = 1;
	ld b, 1
	jp __l_780
__l_779:
; 70             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, __l_781
; 71                 a = AllertYesNoViewPos;
	ld a, (allertyesnoviewpos)
; 72                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 73                 b = 1;
	ld b, 1
	jp __l_782
__l_781:
; 74             } else if ((a = c) == 0x18) { // Вправл
	ld a, c
	cp 24
	jp nz, __l_783
; 75                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 76                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp __l_784
__l_783:
; 77             } else if ((a = c) == 0x08) { // Влево
	ld a, c
	cp 8
	jp nz, __l_785
; 78                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 79                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp __l_786
__l_785:
; 80             } else if ((a = c) == 'Y') {
	ld a, c
	cp 89
	jp nz, __l_787
; 81                 a = 1;
	ld a, 1
; 82                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 83                 b = 1;
	ld b, 1
	jp __l_788
__l_787:
; 84             } else if ((a = c) == 'N') {
	ld a, c
	cp 78
	jp nz, __l_789
; 85                 a = 0;
	ld a, 0
; 86                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 87                 b = 1;
	ld b, 1
__l_789:
__l_788:
__l_786:
__l_784:
__l_782:
__l_780:
__l_777:
; 88             }
; 89         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_776
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
	jp nz, __l_791
; 96         a = 1;
	ld a, 1
; 97         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
	jp __l_792
__l_791:
; 98     } else {
; 99         a = 0;
	ld a, 0
; 100         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
__l_792:
	ret
; 101     }
; 102 }
; 103 
; 104 void AllertYesNoViewPosUpdate() {
allertyesnoviewposupdate:
; 105     if ((a = AllertYesNoViewPos) == 0) {
	ld a, (allertyesnoviewpos)
	or a
	jp nz, __l_793
; 106         ButtonShadowViewSelectA(a = 1);
	ld a, 1
	call buttonshadowviewselecta
; 107         ButtonShadowView2SelectA(a = 0);
	ld a, 0
	call buttonshadowview2selecta
	jp __l_794
__l_793:
; 108     } else {
; 109         ButtonShadowViewSelectA(a = 0);
	ld a, 0
	call buttonshadowviewselecta
; 110         ButtonShadowView2SelectA(a = 1);
	ld a, 1
	call buttonshadowview2selecta
__l_794:
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
__l_795:
; 127             a = *hl;
	ld a, (hl)
; 128             d = a;
	ld d, a
; 129             hl++;
	inc hl
; 130             if (a > 0) {
	or a
	jp z, __l_798
; 131                 b++;
	inc b
__l_798:
; 132             }
; 133             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_800
; 134                 d = 0;
	ld d, 0
__l_800:
__l_796:
; 135             }
; 136         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_795
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
	jp nz, __l_802
; 61             a = ButtonShadowView2Color;
	ld a, (buttonshadowview2color)
	jp __l_803
__l_802:
; 62         } else {
; 63             a = ButtonShadowView2InvColor;
	ld a, (buttonshadowview2invcolor)
__l_803:
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
__l_804:
; 80             a = *hl;
	ld a, (hl)
; 81             d = a;
	ld d, a
; 82             hl++;
	inc hl
; 83             if (a > 0) {
	or a
	jp z, __l_807
; 84                 b++;
	inc b
__l_807:
; 85             }
; 86             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_809
; 87                 d = 0;
	ld d, 0
__l_809:
__l_805:
; 88             }
; 89         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_804
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
__l_811:
; 52             getKeyboardCharA();
	call getkeyboardchara
; 53             c = a;
	ld c, a
; 54             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_814
; 55                 b = 1;
	ld b, 1
	jp __l_815
__l_814:
; 56             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, __l_816
; 57                 b = 1;
	ld b, 1
__l_816:
__l_815:
__l_812:
; 58             }
; 59         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_811
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
__l_818:
; 76             a = *hl;
	ld a, (hl)
; 77             d = a;
	ld d, a
; 78             hl++;
	inc hl
; 79             if (a > 0) {
	or a
	jp z, __l_821
; 80                 b++;
	inc b
__l_821:
; 81             }
; 82             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_823
; 83                 d = 0;
	ld d, 0
__l_823:
__l_819:
; 84             }
; 85         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_818
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
__l_825:
; 72             printMyCharA(a = 0x5F);
	ld a, 95
	call printmychara
; 73             b--;
	dec b
__l_826:
; 74         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_825
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
	jp nz, __l_828
; 137             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp __l_829
__l_828:
; 138         } else {
; 139             FtpMakeDirectoryByPosBoxValue();
	call ftpmakedirectorybyposboxvalue
; 140             // C
; 141             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_830
; 142                 a = FtpMakeDirectoryColor;
	ld a, (ftpmakedirectorycolor)
	jp __l_831
__l_830:
; 143             } else {
; 144                 a = FtpMakeDirectoryInvColor;
	ld a, (ftpmakedirectoryinvcolor)
__l_831:
; 145             }
; 146             c = a;
	ld c, a
; 147             // A
; 148             a = vboxUMP;
	ld a, 4
; 149             vboxOpenHLDECA();
	call vboxopenhldeca
__l_829:
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
	jp nz, __l_832
; 163             FtpMakeDirectorySelectLineA(a = 1);
	ld a, 1
	call ftpmakedirectoryselectlinea
	jp __l_833
__l_832:
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
	jp nz, __l_834
; 173                 a = c;
	ld a, c
; 174                 a--;
	dec a
	jp __l_835
__l_834:
; 175             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, __l_836
; 176                 a = 0;
	ld a, 0
__l_836:
__l_835:
; 177             }
; 178             //--
; 179             FtpMakeDirectorySelectPos = a;
	ld (ftpmakedirectoryselectpos), a
; 180             FtpMakeDirectorySelectLineA(a = 1);
	ld a, 1
	call ftpmakedirectoryselectlinea
__l_833:
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
	call currentviewreturn
; 188     FtpViewNetLoadAndUpdate();
	jp ftpviewnetloadandupdate
; 189 }
; 190 
; 191 void FtpMakeDirectoryKeyA() {
ftpmakedirectorykeya:
; 192     push_pop(hl) {
	push hl
; 193         l = a;
	ld l, a
; 194         if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, __l_838
; 195             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_840
; 196                 FtpMakeDirectoryClose();
	call ftpmakedirectoryclose
	jp __l_841
__l_840:
; 197             } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_842
; 198                 if ((a = FtpMakeDirectorySelectPos) == 0) { // OK
	ld a, (ftpmakedirectoryselectpos)
	or a
	jp nz, __l_844
; 199                     #ifdef _IS_SIMULATOR
; 200                     #else
; 201                         NetFtpMakeDirectory();
	call netftpmakedirectory
; 202                         ThreadsTickNow();
	call threadsticknow
; 203                     #endif
; 204                     FtpMakeDirectoryClose();
	call ftpmakedirectoryclose
	jp __l_845
__l_844:
; 205                 } else { // Переход в редактирование
; 206                     FtpMakeDirectoryByPosBoxValue();
	call ftpmakedirectorybyposboxvalue
; 207                     FtpMakeDirectoryByPosValue();
	call ftpmakedirectorybyposvalue
; 208                     EditFieldViewShow();
	call editfieldviewshow
; 209                     if (a == 1) { // что то изменилось
	cp 1
	jp nz, __l_846
; 210                         FtpMakeDirectoryShowValue();
	call ftpmakedirectoryshowvalue
__l_846:
__l_845:
	jp __l_843
__l_842:
; 211                     }
; 212                 }
; 213             } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_848
; 214                 FtpMakeDirectoryPosUpdateA(a = 0x01);
	ld a, 1
	call ftpmakedirectoryposupdatea
	jp __l_849
__l_848:
; 215             } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_850
; 216                 FtpMakeDirectoryPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpmakedirectoryposupdatea
__l_850:
__l_849:
__l_843:
__l_841:
__l_838:
	pop hl
	ret
; 217             }
; 218         }
; 219     }
; 220 }
; 221 
; 222 uint8_t FtpMakeDirectoryX = 14;
ftpmakedirectoryx:
	db 14
; 223 uint8_t FtpMakeDirectoryY = 11;
ftpmakedirectoryy:
	db 11
; 224 uint8_t FtpMakeDirectoryDX = 20;
ftpmakedirectorydx:
	db 20
; 225 uint8_t FtpMakeDirectoryDY = 12;
ftpmakedirectorydy:
	db 12
; 226 uint8_t FtpMakeDirectoryColor = 0x70;
ftpmakedirectorycolor:
	db 112
; 227 uint8_t FtpMakeDirectoryInvColor = 0x07;
ftpmakedirectoryinvcolor:
	db 7
; 229 uint8_t FtpMakeDirectoryTitle[] = "Make directory";
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
; 230 uint8_t FtpMakeDirectoryValue[16] = "New";
ftpmakedirectoryvalue:
	db 78
	db 101
	db 119
	ds 13
; 232 uint8_t FtpMakeDirectorySelectPos = 0;
ftpmakedirectoryselectpos:
	db 0
; 11 void HelpInfoViewShow() {
helpinfoviewshow:
; 12     CurrentViewChangeAndPushIdA(a = HelpInfoViewId);
	ld a, 12
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = HelpInfoViewX;
	ld a, (helpinfoviewx)
; 15         h = a;
	ld h, a
; 16         a = HelpInfoViewY;
	ld a, (helpinfoviewy)
; 17         l = a;
	ld l, a
; 18         a = HelpInfoViewDX;
	ld a, (helpinfoviewdx)
; 19         d = a;
	ld d, a
; 20         a = HelpInfoViewDY;
	ld a, (helpinfoviewdy)
; 21         e = a;
	ld e, a
; 22         a = HelpInfoViewColor;
	ld a, (helpinfoviewcolor)
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
; 31     // Update HelpInfoViewStringY
; 32     a = HelpInfoViewY;
	ld a, (helpinfoviewy)
; 33     a += 3;
	add 3
; 34     HelpInfoViewStringY = a;
	ld (helpinfoviewstringy), a
; 35     // Show
; 36     HelpInfoViewShowTitle();
	call helpinfoviewshowtitle
; 37     HelpInfoViewShowStringHL(hl = HelpInfoViewStrAll);
	ld hl, helpinfoviewstrall
	call helpinfoviewshowstringhl
; 38     HelpInfoViewShowStringHL(hl = HelpInfoViewStrAll2);
	ld hl, helpinfoviewstrall2
	call helpinfoviewshowstringhl
; 39     HelpInfoViewShowNewLine();
	call helpinfoviewshownewline
; 40     HelpInfoViewShowStringHL(hl = HelpInfoViewDiskHelp1);
	ld hl, helpinfoviewdiskhelp1
	call helpinfoviewshowstringhl
; 41     HelpInfoViewShowStringHL(hl = HelpInfoViewDiskHelp2);
	ld hl, helpinfoviewdiskhelp2
	call helpinfoviewshowstringhl
; 42     HelpInfoViewShowNewLine();
	call helpinfoviewshownewline
; 43     HelpInfoViewShowStringHL(hl = HelpInfoViewFTPHelp1);
	ld hl, helpinfoviewftphelp1
	call helpinfoviewshowstringhl
; 44     HelpInfoViewShowStringHL(hl = HelpInfoViewFTPHelp2);
	ld hl, helpinfoviewftphelp2
	call helpinfoviewshowstringhl
; 45     HelpInfoViewShowStringHL(hl = HelpInfoViewFTPHelp3);
	ld hl, helpinfoviewftphelp3
	call helpinfoviewshowstringhl
; 46     HelpInfoViewShowStringHL(hl = HelpInfoViewFTPHelp4);
	ld hl, helpinfoviewftphelp4
	call helpinfoviewshowstringhl
; 47     HelpInfoViewShowNewLine();
	call helpinfoviewshownewline
; 48     HelpInfoViewShowStringHL(hl = HelpInfoViewFooterHelp1);
	ld hl, helpinfoviewfooterhelp1
	call helpinfoviewshowstringhl
; 49     HelpInfoViewShowNewLine();
	call helpinfoviewshownewline
; 50     HelpInfoViewShowStringHL(hl = HelpInfoViewFooterHelp2);
	ld hl, helpinfoviewfooterhelp2
	call helpinfoviewshowstringhl
; 51     HelpInfoViewShowStringHL(hl = HelpInfoViewFooterHelp3);
	ld hl, helpinfoviewfooterhelp3
	call helpinfoviewshowstringhl
; 52     HelpInfoViewShowStringHL(hl = HelpInfoViewFooterHelp4);
	ld hl, helpinfoviewfooterhelp4
	call helpinfoviewshowstringhl
; 53     HelpInfoViewShowStringHL(hl = HelpInfoViewFooterHelp5);
	ld hl, helpinfoviewfooterhelp5
	call helpinfoviewshowstringhl
; 54     HelpInfoViewShowNewLine();
	call helpinfoviewshownewline
; 55     HelpInfoViewShowStringHL(hl = HelpInfoViewGitHubHelp1);
	ld hl, helpinfoviewgithubhelp1
	jp helpinfoviewshowstringhl
; 56 }
; 57 
; 58 void HelpInfoViewShowTitle() {
helpinfoviewshowtitle:
; 59     a = HelpInfoViewY;
	ld a, (helpinfoviewy)
; 60     a += 1;
	add 1
; 61     myCharPosY = a;
	ld (mycharposy), a
; 62     a = HelpInfoViewX;
	ld a, (helpinfoviewx)
; 63     a += 10;
	add 10
; 64     myCharPosX = a;
	ld (mycharposx), a
; 65     printMyHLStr(hl = HelpInfoViewTitle);
	ld hl, helpinfoviewtitle
	jp printmyhlstr
; 66 }
; 67 
; 68 void HelpInfoViewShowNewLine() {
helpinfoviewshownewline:
; 69     a = HelpInfoViewStringY;
	ld a, (helpinfoviewstringy)
; 70     a += 1;
	add 1
; 71     HelpInfoViewStringY = a;
	ld (helpinfoviewstringy), a
	ret
; 72 }
; 73 
; 74 void HelpInfoViewShowStringHL() {
helpinfoviewshowstringhl:
; 75     //Set Y
; 76     a = HelpInfoViewStringY;
	ld a, (helpinfoviewstringy)
; 77     myCharPosY = a;
	ld (mycharposy), a
; 78     a += 1;
	add 1
; 79     HelpInfoViewStringY = a;
	ld (helpinfoviewstringy), a
; 80     //Set X
; 81     a = HelpInfoViewX;
	ld a, (helpinfoviewx)
; 82     a += 1;
	add 1
; 83     myCharPosX = a;
	ld (mycharposx), a
; 84     // Str
; 85     printMyHLStr();
	jp printmyhlstr
; 86 }
; 87 
; 88 void HelpInfoViewKeyA() {
helpinfoviewkeya:
; 89     push_pop(hl) {
	push hl
; 90         l = a;
	ld l, a
; 91         if ((a = CurrentViewId) == HelpInfoViewId) {
	ld a, (currentviewid)
	cp 12
	jp nz, __l_852
; 92             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_854
; 93                 vboxClose();
	call vboxclose
; 94                 CurrentViewReturn();
	call currentviewreturn
	jp __l_855
__l_854:
; 95             } else if ((a = l) == 0x0D) { // Выбор диска
	ld a, l
	cp 13
	jp nz, __l_856
; 96                 vboxClose();
	call vboxclose
; 97                 CurrentViewReturn();
	call currentviewreturn
__l_856:
__l_855:
__l_852:
	pop hl
	ret
; 98             }
; 99         }
; 100     }
; 101 }
; 102 
; 103 uint8_t HelpInfoViewX = 5;
helpinfoviewx:
	db 5
; 104 uint8_t HelpInfoViewY = 5;
helpinfoviewy:
	db 5
; 105 uint8_t HelpInfoViewDX = 38;
helpinfoviewdx:
	db 38
; 106 uint8_t HelpInfoViewDY = 23;
helpinfoviewdy:
	db 23
; 107 uint8_t HelpInfoViewColor = 0x70;
helpinfoviewcolor:
	db 112
; 109 uint8_t HelpInfoViewStringY = 0;
helpinfoviewstringy:
	db 0
; 111 uint8_t HelpInfoViewTitle[] = "kFTP-2 Ver: 0.0.4";
helpinfoviewtitle:
	db 107
	db 70
	db 84
	db 80
	db 45
	db 50
	db 32
	db 86
	db 101
	db 114
	db 58
	db 32
	db 48
	db 46
	db 48
	db 46
	db 52
	ds 1
; 114 uint8_t HelpInfoViewStrAll[] = {0x8E,0xA1,0xE9,0xA5,0xA5,0x3A,0x20,0x8E,0xE2,0xAC,0xA5,0xAD,0xA0,0x20,0xA4,0xA5,0xA9,0xE1,0xE2,0xA8,0xEF,0x2D,0x20,0x45,0x53,0x43,0x2C,0x20,0xE3,0xA4,0xA0,0xAB,0xA5,0xAD,0xA8,0xA5,0x00};
helpinfoviewstrall:
	db 142
	db 161
	db 233
	db 165
	db 165
	db 58
	db 32
	db 142
	db 226
	db 172
	db 165
	db 173
	db 160
	db 32
	db 164
	db 165
	db 169
	db 225
	db 226
	db 168
	db 239
	db 45
	db 32
	db 69
	db 83
	db 67
	db 44
	db 32
	db 227
	db 164
	db 160
	db 171
	db 165
	db 173
	db 168
	db 165
	db 0
; 116 uint8_t HelpInfoViewStrAll2[] = {0xE4,0xA0,0xA9,0xAB,0xA0,0x20,0x2D,0x20,0x45,0x00};
helpinfoviewstrall2:
	db 228
	db 160
	db 169
	db 171
	db 160
	db 32
	db 45
	db 32
	db 69
	db 0
; 119 uint8_t HelpInfoViewDiskHelp1[] = {0x84,0xA8,0xE1,0xAA,0x3A,0x20,0x91,0xAC,0xA5,0xAD,0xA0,0x20,0xA4,0xA8,0xE1,0xAA,0xA0,0x20,0x82,0x82,0x8E,0x84,0x20,0xAD,0xA0,0x20,0x2E,0x2E,0x20,0xA8,0xAB,0xA8,0x20,0x44,0x2C,0x00};
helpinfoviewdiskhelp1:
	db 132
	db 168
	db 225
	db 170
	db 58
	db 32
	db 145
	db 172
	db 165
	db 173
	db 160
	db 32
	db 164
	db 168
	db 225
	db 170
	db 160
	db 32
	db 130
	db 130
	db 142
	db 132
	db 32
	db 173
	db 160
	db 32
	db 46
	db 46
	db 32
	db 168
	db 171
	db 168
	db 32
	db 68
	db 44
	db 0
; 122 uint8_t HelpInfoViewDiskHelp2[] = {0xA7,0xA0,0xA3,0xE0,0xE3,0xA7,0xAA,0xA0,0x20,0xE4,0xA0,0xA9,0xAB,0xA0,0x20,0xAD,0xA0,0x20,0x46,0x54,0x50,0x20,0x2D,0x20,0x43,0x00};
helpinfoviewdiskhelp2:
	db 167
	db 160
	db 163
	db 224
	db 227
	db 167
	db 170
	db 160
	db 32
	db 228
	db 160
	db 169
	db 171
	db 160
	db 32
	db 173
	db 160
	db 32
	db 70
	db 84
	db 80
	db 32
	db 45
	db 32
	db 67
	db 0
; 125 uint8_t HelpInfoViewFTPHelp1[] = {0x46,0x54,0x50,0x3A,0x20,0x91,0xAA,0xA0,0xE7,0xA0,0xE2,0xEC,0x20,0xE4,0xA0,0xA9,0xAB,0x20,0x43,0x20,0xA8,0xAB,0xA8,0x20,0x82,0x82,0x8E,0x84,0x2C,0x00};
helpinfoviewftphelp1:
	db 70
	db 84
	db 80
	db 58
	db 32
	db 145
	db 170
	db 160
	db 231
	db 160
	db 226
	db 236
	db 32
	db 228
	db 160
	db 169
	db 171
	db 32
	db 67
	db 32
	db 168
	db 171
	db 168
	db 32
	db 130
	db 130
	db 142
	db 132
	db 44
	db 0
; 128 uint8_t HelpInfoViewFTPHelp2[] = {0xAE,0xA1,0xAD,0xAE,0xA2,0xAB,0xA5,0xAD,0xA8,0xA5,0x20,0xE2,0xA5,0xAA,0xE3,0xE9,0xA5,0xA9,0x20,0xA4,0xA8,0xE0,0xA5,0xAA,0xE2,0xAE,0xE0,0xA8,0xA8,0x20,0x2D,0x20,0x52,0x2C,0x00};
helpinfoviewftphelp2:
	db 174
	db 161
	db 173
	db 174
	db 162
	db 171
	db 165
	db 173
	db 168
	db 165
	db 32
	db 226
	db 165
	db 170
	db 227
	db 233
	db 165
	db 169
	db 32
	db 164
	db 168
	db 224
	db 165
	db 170
	db 226
	db 174
	db 224
	db 168
	db 168
	db 32
	db 45
	db 32
	db 82
	db 44
	db 0
; 131 uint8_t HelpInfoViewFTPHelp3[] = {0xAF,0xA5,0xE0,0xA5,0xA9,0xE2,0xA8,0x20,0xAD,0xA0,0x20,0xA4,0xAE,0xAC,0xA0,0xE8,0xAD,0xE3,0xEE,0x20,0xA4,0xA8,0xE0,0xA5,0xAA,0xE2,0xAE,0xE0,0xA8,0xEE,0x20,0x2D,0x20,0x48,0x2C,0x00};
helpinfoviewftphelp3:
	db 175
	db 165
	db 224
	db 165
	db 169
	db 226
	db 168
	db 32
	db 173
	db 160
	db 32
	db 164
	db 174
	db 172
	db 160
	db 232
	db 173
	db 227
	db 238
	db 32
	db 164
	db 168
	db 224
	db 165
	db 170
	db 226
	db 174
	db 224
	db 168
	db 238
	db 32
	db 45
	db 32
	db 72
	db 44
	db 0
; 134 uint8_t HelpInfoViewFTPHelp4[] = {0xE1,0xAE,0xA7,0xA4,0xA0,0xAD,0xA8,0xA5,0x20,0xAD,0xAE,0xA2,0xAE,0xA9,0x20,0xA4,0xA8,0xE0,0xA5,0xAA,0xE2,0xAE,0xE0,0xA8,0xA8,0x20,0x2D,0x20,0x44,0x2C,0x00};
helpinfoviewftphelp4:
	db 225
	db 174
	db 167
	db 164
	db 160
	db 173
	db 168
	db 165
	db 32
	db 173
	db 174
	db 162
	db 174
	db 169
	db 32
	db 164
	db 168
	db 224
	db 165
	db 170
	db 226
	db 174
	db 224
	db 168
	db 168
	db 32
	db 45
	db 32
	db 68
	db 44
	db 0
; 137 uint8_t HelpInfoViewFooterHelp1[] = {0x82,0x8D,0x88,0x8C,0x80,0x8D,0x88,0x85,0x21,0x20,0x90,0xE3,0xE1,0xE1,0xAA,0xA8,0xA5,0x20,0xA1,0xE3,0xAA,0xA2,0xEB,0x20,0xAD,0xA5,0x20,0xA2,0xA2,0xAE,0xA4,0xA8,0xE2,0xEC,0x21,0x00};
helpinfoviewfooterhelp1:
	db 130
	db 141
	db 136
	db 140
	db 128
	db 141
	db 136
	db 133
	db 33
	db 32
	db 144
	db 227
	db 225
	db 225
	db 170
	db 168
	db 165
	db 32
	db 161
	db 227
	db 170
	db 162
	db 235
	db 32
	db 173
	db 165
	db 32
	db 162
	db 162
	db 174
	db 164
	db 168
	db 226
	db 236
	db 33
	db 0
; 140 uint8_t HelpInfoViewFooterHelp2[] = {0x28,0x8F,0xAE,0xA4,0xA4,0xA5,0xE0,0xA6,0xAA,0xA0,0x20,0xE0,0xE3,0xE1,0xE1,0xAA,0xA8,0xE5,0x20,0xA1,0xE3,0xAA,0xA2,0x20,0xE2,0xAE,0xAB,0xEC,0xAA,0xAE,0x20,0xA4,0xAB,0xEF,0x00};
helpinfoviewfooterhelp2:
	db 40
	db 143
	db 174
	db 164
	db 164
	db 165
	db 224
	db 166
	db 170
	db 160
	db 32
	db 224
	db 227
	db 225
	db 225
	db 170
	db 168
	db 229
	db 32
	db 161
	db 227
	db 170
	db 162
	db 32
	db 226
	db 174
	db 171
	db 236
	db 170
	db 174
	db 32
	db 164
	db 171
	db 239
	db 0
; 143 uint8_t HelpInfoViewFooterHelp3[] = {0xAE,0xE2,0xAE,0xA1,0xE0,0xA0,0xA6,0xA5,0xAD,0xA8,0xEF,0x20,0xA4,0xA8,0xE0,0xA5,0xAA,0xE2,0xAE,0xE0,0xA8,0xA9,0x20,0xA8,0x20,0xE4,0xA0,0xA9,0xAB,0xAE,0xA2,0x00};
helpinfoviewfooterhelp3:
	db 174
	db 226
	db 174
	db 161
	db 224
	db 160
	db 166
	db 165
	db 173
	db 168
	db 239
	db 32
	db 164
	db 168
	db 224
	db 165
	db 170
	db 226
	db 174
	db 224
	db 168
	db 169
	db 32
	db 168
	db 32
	db 228
	db 160
	db 169
	db 171
	db 174
	db 162
	db 0
; 146 uint8_t HelpInfoViewFooterHelp4[] = {0xAD,0xA0,0xE5,0xAE,0xA4,0xEF,0xE9,0xA8,0xE5,0xE1,0xEF,0x20,0xAD,0xA0,0x20,0x46,0x54,0x50,0x2C,0x20,0xAF,0xE0,0xA8,0x20,0xE0,0xA0,0xA1,0xAE,0xE2,0xA5,0x00};
helpinfoviewfooterhelp4:
	db 173
	db 160
	db 229
	db 174
	db 164
	db 239
	db 233
	db 168
	db 229
	db 225
	db 239
	db 32
	db 173
	db 160
	db 32
	db 70
	db 84
	db 80
	db 44
	db 32
	db 175
	db 224
	db 168
	db 32
	db 224
	db 160
	db 161
	db 174
	db 226
	db 165
	db 0
; 149 uint8_t HelpInfoViewFooterHelp5[] = {0xE1,0xA5,0xE0,0xA2,0xA5,0xE0,0xA0,0x20,0xA2,0x20,0x55,0x54,0x46,0x38,0x29,0x00};
helpinfoviewfooterhelp5:
	db 225
	db 165
	db 224
	db 162
	db 165
	db 224
	db 160
	db 32
	db 162
	db 32
	db 85
	db 84
	db 70
	db 56
	db 41
	db 0
; 151 uint8_t HelpInfoViewGitHubHelp1[] = "https://github.com/KhimuninAA/kFTP-2";
helpinfoviewgithubhelp1:
	db 104
	db 116
	db 116
	db 112
	db 115
	db 58
	db 47
	db 47
	db 103
	db 105
	db 116
	db 104
	db 117
	db 98
	db 46
	db 99
	db 111
	db 109
	db 47
	db 75
	db 104
	db 105
	db 109
	db 117
	db 110
	db 105
	db 110
	db 65
	db 65
	db 47
	db 107
	db 70
	db 84
	db 80
	db 45
	db 50
	ds 1
; 11 void ESPErrorParserA() {
esperrorparsera:
; 12     if (a > 0) {
	or a
	jp z, __l_858
; 13         push_pop(bc) {
	push bc
; 14             b = a;
	ld b, a
; 15             if ((a = b) == ESPError_FtpDeleteFileError) {
	ld a, b
	cp 1
	jp nz, __l_860
; 16                 AllertOkViewShowHL(hl = StringLocaleNetFtpDeleteFileError);
	ld hl, stringlocalenetftpdeletefileerro
	call allertokviewshowhl
	jp __l_861
__l_860:
; 17             } else if ((a = b) == ESPError_FtpConnectError) {
	ld a, b
	cp 2
	jp nz, __l_862
; 18                 AllertOkViewShowHL(hl = StringLocaleNetFtpConnectError);
	ld hl, stringlocalenetftpconnecterror
	call allertokviewshowhl
	jp __l_863
__l_862:
; 19             } else if ((a = b) == ESPError_WiFiConnectError) {
	ld a, b
	cp 3
	jp nz, __l_864
; 20                 AllertOkViewShowHL(hl = StringLocaleNetWiFiConnectError);
	ld hl, stringlocalenetwificonnecterror
	call allertokviewshowhl
__l_864:
__l_863:
__l_861:
	pop bc
; 21             }
; 22         }
; 23         // Сброс ошибки
; 24         NetErrorClear();
	call neterrorclear
__l_858:
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
__l_866:
; 49             a = vboxBLW;
	ld a, 16
; 50             a |= vboxERA;
	or 8
; 51             a |= vboxUMP;
	or 4
; 52             vboxCall();
	call vboxcall
__l_867:
; 53         } while (a == 0x00);
	or a
	jp z, __l_866
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
__l_869:
; 70                 printMyCharA(a = 0xCD);
	ld a, 205
	call printmychara
; 71                 b++;
	inc b
__l_870:
; 72             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, __l_869
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
__l_872:
; 86                 printMyCharA(a = 0xCD);
	ld a, 205
	call printmychara
; 87                 b++;
	inc b
__l_873:
; 88             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, __l_872
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
__l_875:
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
__l_876:
; 107             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, __l_875
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
__l_878:
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
__l_879:
; 128             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, __l_878
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
	jp nz, __l_881
; 145         push_pop(bc, hl) {
	push bc
	push hl
; 146             ordos_sdma(hl = vboxFL);
	ld hl, vboxfl
	call ordos_sdma
; 147             b = 0;
	ld b, 0
; 148             do {
__l_883:
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
	jp nz, __l_886
; 156                     c = 1;
	ld c, 1
__l_886:
__l_884:
; 157                 }
; 158             } while ((a = c) == 0);
	ld a, c
	or a
	jp z, __l_883
; 159             if ((a = c) == 0xFF) {
	ld a, c
	cp 255
	jp nz, __l_888
; 160                 loadVBOX();
	call loadvbox
__l_888:
	pop hl
	pop bc
__l_881:
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
; 44 uint8_t Net_buffer_len = 0;
net_buffer_len:
	db 0
; 45 uint8_t Net_buffer[1];
net_buffer:
	ds 1
 savebin "kFTP2.ORD", 0x00f0, 0x3A10
 savebin "test.ORD", 0x00f0, 0x3A10
