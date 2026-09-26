    device zxspectrum48 ; There is no ZX Spectrum, it is needed for the sjasmplus assembler.
bios equ 61440
cmdbuffer equ 62256

    org 0x0FF0

; 16 uint8_t appName[] = {'G','E','T','C','M','D','$',' '};
appname:
	db 71
	db 69
	db 84
	db 67
	db 77
	db 68
	db 36
	db 32

    
    DB 0x00, 0x10
    
    DB 0x00, 0x08
    
    DB 0x00, 0x01, 0x01, 0x0B

; 27 void main(){
main:
; 28 //    c = 0x21; //'A';
; 29 //    bios(a = biosPrintByteC);
; 30     
; 31     b = 0;
	ld b, 0
; 32     e = 16;
	ld e, 16
; 33     h = 5;
	ld h, 5
; 34     do {
__l_0:
; 35         d = 16;
	ld d, 16
; 36         l = 0;
	ld l, 0
; 37         bios(a = biosSetPositionCursoreHL, l = 0);
	ld a, 28
	ld l, 0
	call bios
; 38         h++;
	inc h
; 39         do {
__l_3:
; 40             bios(a = biosPrintC, c = b);
	ld a, 0
	ld c, b
	call bios
; 41             b++;
	inc b
; 42             d--;
	dec d
__l_4:
; 43         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_3
; 44         e--;
	dec e
__l_1:
; 45     } while ((a = e) > 0);
	ld a, e
	or a
	jp nz, __l_0
; 46     
; 47     //bios(a = biosSetTempDiskC, c = 'E');
; 48     //bios(a = biosSetExtDRVConfigB, b = 0x02);
; 49     
; 50     FtpHeaderViewStart();
	call ftpheaderviewstart
; 51     WiFiHeaderViewStart();
	call wifiheaderviewstart
; 52     
; 53     for (;;) {
__l_7:
	jp __l_7
; 15 void MyViewShow() {
myviewshow:
; 16     MyViewByte = (a = b);
	ld a, b
	ld (myviewbyte), a
; 17     bios(a = biosSetColorC);
	ld a, 18
	call bios
; 18     push_pop(hl) {
	push hl
; 19         h = d;
	ld h, d
; 20         l = e;
	ld l, e
; 21         MyViewDyDx = hl;
	ld (myviewdydx), hl
	pop hl
; 22     }
; 23     do {
__l_9:
; 24         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 25         push_pop(de) {
	push de
; 26             do {
__l_12:
; 27                 MyViewCalcCharByPosDE();
	call myviewcalccharbyposde
; 28                 bios(a = biosPrintC);
	ld a, 0
	call bios
; 29                 e--;
	dec e
__l_13:
; 30             } while ((a = e) > 0);
	ld a, e
	or a
	jp nz, __l_12
	pop de
; 31         }
; 32         h++;
	inc h
; 33         d--;
	dec d
__l_10:
; 34     } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_9
	ret
; 35 }
; 36 
; 37 void MyViewCalcCharByPosDE() {
myviewcalccharbyposde:
; 38     c = MyViewByteBorder + MyViewByteFrame;
	ld c, 1
; 39     a = MyViewByte;
	ld a, (myviewbyte)
; 40     a &= c;
	and c
; 41     if (a > 0) {
	or a
	jp z, __l_15
; 42         push_pop(hl) {
	push hl
; 43             hl = MyViewDyDx;
	ld hl, (myviewdydx)
; 44             if ((a = d) == 1) { // Нижняя линия
	ld a, d
	cp 1
	jp nz, __l_17
; 45                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_19
; 46                     c = 0x89;
	ld c, 137
	jp __l_20
__l_19:
; 47                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_21
; 48                     c = 0x94;
	ld c, 148
	jp __l_22
__l_21:
; 49                 } else {
; 50                     c = 0x99;
	ld c, 153
__l_22:
__l_20:
	jp __l_18
__l_17:
; 51                 }
; 52             } else if ((a = d) == h) { // Верхняя линия
	ld a, d
	cp h
	jp nz, __l_23
; 53                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_25
; 54                     c = 0x88;
	ld c, 136
	jp __l_26
__l_25:
; 55                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_27
; 56                     c = 0x95;
	ld c, 149
	jp __l_28
__l_27:
; 57                 } else {
; 58                     c = 0x99;
	ld c, 153
__l_28:
__l_26:
	jp __l_24
__l_23:
; 59                 }
; 60             } else { // Между верхней и нижней
; 61                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_29
; 62                     c = 0x87;
	ld c, 135
	jp __l_30
__l_29:
; 63                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_31
; 64                     c = 0x87;
	ld c, 135
	jp __l_32
__l_31:
; 65                 } else {
; 66                     c = ' ';
	ld c, 32
__l_32:
__l_30:
__l_24:
__l_18:
	pop hl
	jp __l_16
__l_15:
; 67                 }
; 68             }
; 69         }
; 70     } else {
; 71         c = ' ';
	ld c, 32
__l_16:
	ret
; 72     }
; 73 }
; 74 
; 75 uint16_t MyViewDyDx = 0;
myviewdydx:
	dw 0
; 76 uint8_t MyViewByte = 0;
myviewbyte:
	db 0
; 11 void FtpHeaderViewStart() {
ftpheaderviewstart:
; 12     FtpHeaderViewShow();
; 13 }
; 14 
; 15 void FtpHeaderViewShow() {
ftpheaderviewshow:
; 16     c = (a = FtpHeaderViewColor);
	ld a, (ftpheaderviewcolor)
	ld c, a
; 17     l = (a = FtpHeaderViewX);
	ld a, (ftpheaderviewx)
	ld l, a
; 18     h = (a = FtpHeaderViewY);
	ld a, (ftpheaderviewy)
	ld h, a
; 19     e = (a = FtpHeaderViewDX);
	ld a, (ftpheaderviewdx)
	ld e, a
; 20     d = (a = FtpHeaderViewDY);
	ld a, (ftpheaderviewdy)
	ld d, a
; 21     b = MyViewByteFrame;
	ld b, 2
; 22     MyViewShow();
	jp myviewshow
; 23 }
; 24 
; 25 uint8_t FtpHeaderViewX = 0;
ftpheaderviewx:
	db 0
; 26 uint8_t FtpHeaderViewY = 0;
ftpheaderviewy:
	db 0
; 27 uint8_t FtpHeaderViewDX = 24;
ftpheaderviewdx:
	db 24
; 28 uint8_t FtpHeaderViewDY = 4;
ftpheaderviewdy:
	db 4
; 29 uint8_t FtpHeaderViewColor = 0x52;
ftpheaderviewcolor:
	db 82
; 30 uint8_t FtpHeaderViewInvColor = 0x25;
ftpheaderviewinvcolor:
	db 37
; 11 void WiFiHeaderViewStart() {
wifiheaderviewstart:
; 12     WiFiHeaderViewShow();
; 13 }
; 14 
; 15 void WiFiHeaderViewShow() {
wifiheaderviewshow:
; 16     c = (a = WiFiHeaderViewColor);
	ld a, (wifiheaderviewcolor)
	ld c, a
; 17     l = (a = WiFiHeaderViewX);
	ld a, (wifiheaderviewx)
	ld l, a
; 18     h = (a = WiFiHeaderViewY);
	ld a, (wifiheaderviewy)
	ld h, a
; 19     e = (a = WiFiHeaderViewDX);
	ld a, (wifiheaderviewdx)
	ld e, a
; 20     d = (a = WiFiHeaderViewDY);
	ld a, (wifiheaderviewdy)
	ld d, a
; 21     b = MyViewByteFrame;
	ld b, 2
; 22     MyViewShow();
	call myviewshow
; 23     //bios(a = biosWindowOpen);
; 24     
; 25     WiFiHeaderViewShowTitle();
	call wifiheaderviewshowtitle
; 26     WiFiHeaderViewShowValue();
	jp wifiheaderviewshowvalue
; 27 }
; 28 
; 29 void WiFiHeaderViewShowTitle() {
wifiheaderviewshowtitle:
; 30     push_pop(hl, bc) {
	push hl
	push bc
; 31         //Title
; 32         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 33         b = a;
	ld b, a
; 34         a = WiFiHeaderViewDX;
	ld a, (wifiheaderviewdx)
; 35         a += b;
	add b
; 36         a -= 8; //len Title
	sub 8
; 37         l = a;
	ld l, a
; 38         h = (a = WiFiHeaderViewY);
	ld a, (wifiheaderviewy)
	ld h, a
; 39         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 40         bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitle);
	ld a, 2
	ld hl, wifiheaderviewtitle
	call bios
; 41         //SSID
; 42         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 43         a++;
	inc a
; 44         l = a;
	ld l, a
; 45         a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 46         a++;
	inc a
; 47         h = a;
	ld h, a
; 48         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 49         bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleSSID);
	ld a, 2
	ld hl, wifisettingsviewtitlessid
	call bios
; 50         //IP
; 51         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 52         a += 1;
	add 1
; 53         l = a;
	ld l, a
; 54         a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 55         a += 2;
	add 2
; 56         h = a;
	ld h, a
; 57         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 58         bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitleIP);
	ld a, 2
	ld hl, wifiheaderviewtitleip
	call bios
	pop bc
	pop hl
	ret
; 59     }
; 60 }
; 61 
; 62 
; 63 
; 64 void WiFiHeaderViewShowValue() {
wifiheaderviewshowvalue:
; 65     // SSID
; 66     a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 67     a += 7;
	add 7
; 68     l = a;
	ld l, a
; 69     a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 70     a += 1;
	add 1
; 71     h = a;
	ld h, a
; 72     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 73     a = 16;
	ld a, 16
; 74     MyFuncPrintHLStrLenA(hl = WiFiSettingsViewSsidValue);
	ld hl, wifisettingsviewssidvalue
	call myfuncprinthlstrlena
; 75     // IP
; 76     a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 77     a += 7;
	add 7
; 78     l = a;
	ld l, a
; 79     a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 80     a += 2;
	add 2
; 81     h = a;
	ld h, a
; 82     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 83     a = 16;
	ld a, 16
; 84     MyFuncPrintHLStrLenA(hl = WiFiSettingsViewIpValue);
	ld hl, wifisettingsviewipvalue
	jp myfuncprinthlstrlena
; 85 }
; 86 
; 87 uint8_t WiFiHeaderViewX = 24;
wifiheaderviewx:
	db 24
; 88 uint8_t WiFiHeaderViewY = 0;
wifiheaderviewy:
	db 0
; 89 uint8_t WiFiHeaderViewDX = 24;
wifiheaderviewdx:
	db 24
; 90 uint8_t WiFiHeaderViewDY = 4;
wifiheaderviewdy:
	db 4
; 91 uint8_t WiFiHeaderViewColor = 0x07;
wifiheaderviewcolor:
	db 7
; 93 uint8_t WiFiHeaderViewTitleIP[] =   "IP  : ";
wifiheaderviewtitleip:
	db 73
	db 80
	db 32
	db 32
	db 58
	db 32
	ds 1
; 94 uint8_t WiFiHeaderViewTitle[] = {0x82, 'W', 'i', '-', 'F', 'i', 0x92, '\0'};
wifiheaderviewtitle:
	db 130
	db 87
	db 105
	db 45
	db 70
	db 105
	db 146
	db 0
; 11 uint8_t WiFiSettingsViewX = 11;
wifisettingsviewx:
	db 11
; 12 uint8_t WiFiSettingsViewY = 10;
wifisettingsviewy:
	db 10
; 13 uint8_t WiFiSettingsViewDX = 27;
wifisettingsviewdx:
	db 27
; 14 uint8_t WiFiSettingsViewDY = 13;
wifisettingsviewdy:
	db 13
; 15 uint8_t WiFiSettingsViewColor = 0x70;
wifisettingsviewcolor:
	db 112
; 16 uint8_t WiFiSettingsViewInvColor = 0x07;
wifisettingsviewinvcolor:
	db 7
; 18 uint8_t WiFiSettingsViewSelectPos = 0;
wifisettingsviewselectpos:
	db 0
; 20 uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
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
; 21 uint8_t WiFiSettingsViewTitleSSID[] = "SSID: ";
wifisettingsviewtitlessid:
	db 83
	db 83
	db 73
	db 68
	db 58
	db 32
	ds 1
; 22 uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
wifisettingsviewtitlepass:
	db 80
	db 97
	db 115
	db 115
	db 58
	ds 1
; 23 uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
wifisettingsviewtitlemac:
	db 32
	db 77
	db 65
	db 67
	db 58
	ds 1
; 24 uint8_t WiFiSettingsViewButtonTitle[] = "Connect";
wifisettingsviewbuttontitle:
	db 67
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	ds 1
; 25 uint8_t WiFiSettingsViewSSIDIsConnected = 0;
wifisettingsviewssidisconnected:
	db 0
; 27 uint8_t WiFiSettingsViewSsidValue[16] = "-";
wifisettingsviewssidvalue:
	db 45
	ds 15
; 28 uint8_t WiFiSettingsViewPassValue[16] = "-";
wifisettingsviewpassvalue:
	db 45
	ds 15
; 29 uint8_t WiFiSettingsViewMacValue[18] = "00:00:00:00:00:00";
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
; 30 uint8_t WiFiSettingsViewIpValue[16] = "0.0.0.0";
wifisettingsviewipvalue:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 13 void MyFuncPrintHLStrLenA() {
myfuncprinthlstrlena:
; 14     push_pop(bc, de) {
	push bc
	push de
; 15         b = a;
	ld b, a
; 16         d = 0;
	ld d, 0
; 17         do {
__l_33:
; 18             a = *hl;
	ld a, (hl)
; 19             if (a > 0) {
	or a
	jp z, __l_36
; 20                 d++;
	inc d
; 21                 c = a;
	ld c, a
; 22                 bios(a = biosPrintC);
	ld a, 0
	call bios
__l_36:
; 23             }
; 24             a = *hl;
	ld a, (hl)
; 25             hl++;
	inc hl
__l_34:
; 26         } while (a > 0);
	or a
	jp nz, __l_33
; 27         if ((a = d) < b) {
	ld a, d
	cp b
	jp nc, __l_38
; 28             a = b;
	ld a, b
; 29             a -= d;
	sub d
; 30             b = a;
	ld b, a
; 31             do {
__l_40:
; 32                 bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 33                 b--;
	dec b
__l_41:
; 34             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_40
__l_38:
	pop de
	pop bc
	ret
 savebin "getcmd.ord", 0x0ff0, 0x0810
