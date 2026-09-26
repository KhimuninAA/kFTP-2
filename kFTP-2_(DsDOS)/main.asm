    device zxspectrum48 ; There is no ZX Spectrum, it is needed for the sjasmplus assembler.
setposcursor equ 63548
exit equ 62304
bios equ 61440
cmdbuffer equ 62256
fontaddress equ 62417
inverceaddress equ 62419
keyrusaddress equ 62437
printhexa equ 63509
printchata equ 63503
printchatc equ 63497
readbyteinothermem equ 63542
writebyteinothermem equ 63545
getposcursor equ 63518
printhlstr equ 63512
getkeyboardchara equ 63491
getkeyboardstatea equ 63506
getkeyboardcodea equ 63515
unpackcharcode equ 63533
i8255_setup equ 62979
i8255_port_c equ 62978
i8255_port_a equ 62976

    org 0x0FF0

; 18 uint8_t appName[] = {'K','F','T','P','-','D','S','$'};
appname:
	db 75
	db 70
	db 84
	db 80
	db 45
	db 68
	db 83
	db 36

    
    DB 0x00, 0x10
    
    DB 0x00, 0x32
    
    
    DB 0x00, 0x00, 0x01, 0x0B

; 31 void main(){
main:
; 32     
; 33     DetectHardwareVersion();
	call detecthardwareversion
; 34     if (a == 0) {
	or a
	jp nz, __l_0
; 35         bios(a = biosPrintMessageHL, hl = StringLocaleHardwareFail);
	ld a, 2
	ld hl, stringlocalehardwarefail
	call bios
; 36         getKeyboardCharA();
	call getkeyboardchara
; 37         return exit();
	jp exit
__l_0:
; 38     }
; 39     
; 40     bios(a = biosSetTempDiskC, c = 'B');
	ld a, 81
	ld c, 66
	call bios
; 41     MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 42     bios(a = biosSetColorModeC, c = 0);
	ld a, 16
	ld c, 0
	call bios
; 43     //bios(a = biosCursorShowC, c = 0);
; 44     h = 0;
	ld h, 0
; 45     l = 0;
	ld l, 0
; 46     setPosCursor();
	call setposcursor
; 47     //sp = 0x6FFF;
; 48     
; 49     //MyFuncLoadEXTDRV();
; 50     //MyFuncCheckExtDrv();
; 51     
; 52     FtpHeaderViewStart();
	call ftpheaderviewstart
; 53     WiFiHeaderViewStart();
	call wifiheaderviewstart
; 54     HelpFooterViewShow();
	call helpfooterviewshow
; 55     DiskViewStart();
	call diskviewstart
; 56     FtpViewShow();
	call ftpviewshow
; 57     
; 58     CurrentViewChangeIdA(a = DiskViewId); //FtpViewId
	ld a, 1
	call currentviewchangeida
; 59     
; 60     #ifdef _IS_SIMULATOR
; 61         //DiskViewReload();
; 62     #else
; 63         NetUpdateData();
	call netupdatedata
; 64         ThreadsTickNow();
	call threadsticknow
; 65     #endif
; 66     
; 67     for (;;) {
__l_3:
; 68         bios(a = biosCheckKeyA, c = 1);
	ld a, 9
	ld c, 1
	call bios
; 69         if (flag_z) {
	jp nz, __l_5
; 70             ThreadsTick();
	call threadstick
	jp __l_6
__l_5:
; 71         } else {
; 72             KeyCurDelay();
	call keycurdelay
; 73             KeyboardEventA();
	call keyboardeventa
__l_6:
	jp __l_3
; 74         }
; 75     }
; 76 }
; 77 
; 78 void Key256Delay() {
key256delay:
; 79     push_pop(bc, a) {
	push bc
	push af
; 80         b = 0x40; //0xFF;
	ld b, 64
; 81         do {
__l_7:
; 82             c = 0xFF;
	ld c, 255
; 83             do {
__l_10:
; 84                 c--;
	dec c
__l_11:
; 85             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_10
; 86             b--;
	dec b
__l_8:
; 87         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_7
	pop af
	pop bc
	ret
; 88     }
; 89 }
; 90 
; 91 void KeyCurDelay() {
keycurdelay:
; 92     push_pop(bc, a) {
	push bc
	push af
; 93         b = a; //Save
	ld b, a
; 94         if ((a = b) == 0x08) {
	ld a, b
	cp 8
	jp nz, __l_13
; 95             Key256Delay();
	call key256delay
	jp __l_14
__l_13:
; 96         } else if ((a = b) == 0x18) {
	ld a, b
	cp 24
	jp nz, __l_15
; 97             Key256Delay();
	call key256delay
	jp __l_16
__l_15:
; 98         } else if ((a = b) == 0x19) {
	ld a, b
	cp 25
	jp nz, __l_17
; 99             Key256Delay();
	call key256delay
	jp __l_18
__l_17:
; 100         } else if ((a = b) == 0x1A) {
	ld a, b
	cp 26
	jp nz, __l_19
; 101             Key256Delay();
	call key256delay
__l_19:
__l_18:
__l_16:
__l_14:
	pop af
	pop bc
	ret
; 102         }
; 103     }
; 104 }
; 105 
; 106 void KeyboardEventA() {
keyboardeventa:
; 107     push_pop(bc) {
	push bc
; 108         b = a; //Save
	ld b, a
; 109         if ((a = b) == 0x03) { //F4
	ld a, b
	cp 3
	jp nz, __l_21
; 110             
; 111             return exit();
	jp exit
	jp __l_22
__l_21:
; 112         } else if ((a = b) == 0x02) { //F3 Open FTP settings
	ld a, b
	cp 2
	jp nz, __l_23
; 113             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 114             if (a == 1) {
	cp 1
	jp nz, __l_25
; 115                 FtpSettingsViewShow();
	call ftpsettingsviewshow
__l_25:
	jp __l_24
__l_23:
; 116             }
; 117         } else if ((a = b) == 0x01) { //F2 Open WiFi settings
	ld a, b
	cp 1
	jp nz, __l_27
; 118             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 119             if (a == 1) {
	cp 1
	jp nz, __l_29
; 120                 WiFiSettingsViewShow();
	call wifisettingsviewshow
__l_29:
__l_27:
__l_24:
__l_22:
; 121             }
; 122         }
; 123         
; 124         c = 0;
	ld c, 0
; 125         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_31
; 126             DiskViewKeyA(a = b);
	ld a, b
	call diskviewkeya
; 127             c = 1;
	ld c, 1
	jp __l_32
__l_31:
; 128         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_33
; 129             FtpViewKeyA(a = b);
	ld a, b
	call ftpviewkeya
; 130             c = 1;
	ld c, 1
	jp __l_34
__l_33:
; 131         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_35
; 132             WiFiSettingsViewKeyA(a = b);
	ld a, b
	call wifisettingsviewkeya
; 133             c = 1;
	ld c, 1
	jp __l_36
__l_35:
; 134         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, __l_37
; 135             SelectDiskViewKeyA(a = b);
	ld a, b
	call selectdiskviewkeya
; 136             c = 1;
	ld c, 1
	jp __l_38
__l_37:
; 137         } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, __l_39
; 138             WiFiNetworksViewKeyA(a = b);
	ld a, b
	call wifinetworksviewkeya
; 139             c = 1;
	ld c, 1
	jp __l_40
__l_39:
; 140         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_41
; 141             FtpSettingsViewKeyA(a = b);
	ld a, b
	call ftpsettingsviewkeya
; 142             c = 1;
	ld c, 1
__l_41:
__l_40:
__l_38:
__l_36:
__l_34:
__l_32:
	pop bc
	ret
; 14 void MyViewChangeBoxColor() {
myviewchangeboxcolor:
; 15     push_pop(bc) {
	push bc
; 16         push_pop(de) {
	push de
; 17             b = l;
	ld b, l
; 18             a = h;
	ld a, h
; 19             carry_rotate_left(a, 3);
	rla
	rla
	rla
; 20             l = a;
	ld l, a
; 21             h = 0;
	ld h, 0
; 22             de = 0xC000;
	ld de, 49152
; 23             hl += de;
	add hl, de
; 24             e = 0;
	ld e, 0
; 25             d = b;
	ld d, b
; 26             hl += de;
	add hl, de
	pop de
; 27         }
; 28         a = d;
	ld a, d
; 29         carry_rotate_left(a, 3);
	rla
	rla
	rla
; 30         d = a;
	ld d, a
; 31         // X
; 32         b = 0;
	ld b, 0
; 33         do {
__l_43:
; 34             push_pop(bc, hl) {
	push bc
	push hl
; 35                 //-- Y
; 36                 b = d;
	ld b, d
; 37                 do {
__l_46:
; 38                     writeByteInOtherMem(a = 1);
	ld a, 1
	call writebyteinothermem
; 39                     b--;
	dec b
; 40                     hl++;
	inc hl
__l_47:
; 41                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_46
	pop hl
	pop bc
; 42                 
; 43                 
; 44             }
; 45             //-- Inc
; 46             b++;
	inc b
; 47             push_pop(de) {
	push de
; 48                 de = 0x0100;
	ld de, 256
; 49                 hl += de;
	add hl, de
	pop de
__l_44:
; 50             }
; 51         } while ((a = b) < e);
	ld a, b
	cp e
	jp c, __l_43
	pop bc
	ret
; 52     }
; 53 }
; 54 
; 55 // [L]-X, [H]-Y
; 56 // [E]-dX, [D]-dY
; 57 void MyViewClearBox() {
myviewclearbox:
; 58     push_pop(bc) {
	push bc
; 59         push_pop(de) {
	push de
; 60             b = l;
	ld b, l
; 61             a = h;
	ld a, h
; 62             carry_rotate_left(a, 3);
	rla
	rla
	rla
; 63             l = a;
	ld l, a
; 64             h = 0;
	ld h, 0
; 65             de = 0xC000;
	ld de, 49152
; 66             hl += de;
	add hl, de
; 67             e = 0;
	ld e, 0
; 68             d = b;
	ld d, b
; 69             hl += de;
	add hl, de
	pop de
; 70         }
; 71         a = d;
	ld a, d
; 72         carry_rotate_left(a, 3);
	rla
	rla
	rla
; 73         d = a;
	ld d, a
; 74         // X
; 75         b = 0;
	ld b, 0
; 76         do {
__l_49:
; 77             push_pop(bc, hl) {
	push bc
	push hl
; 78                 //-- Y
; 79                 b = d;
	ld b, d
; 80                 do {
__l_52:
; 81                     *hl = 0;
	ld (hl), 0
; 82                     b--;
	dec b
; 83                     hl++;
	inc hl
__l_53:
; 84                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_52
	pop hl
	pop bc
; 85                 
; 86                 
; 87             }
; 88             //-- Inc
; 89             b++;
	inc b
; 90             push_pop(de) {
	push de
; 91                 de = 0x0100;
	ld de, 256
; 92                 hl += de;
	add hl, de
	pop de
__l_50:
; 93             }
; 94         } while ((a = b) < e);
	ld a, b
	cp e
	jp c, __l_49
	pop bc
	ret
; 95     }
; 96 }
; 97 
; 98 // [L]-X, [H]-Y
; 99 // [E]-dX, [D]-dY
; 100 // [C] - color
; 101 // [B]
; 102 void MyViewShow() {
myviewshow:
; 103     MyViewByte = (a = b);
	ld a, b
	ld (myviewbyte), a
; 104     bios(a = biosSetColorC);
	ld a, 18
	call bios
; 105     push_pop(hl) {
	push hl
; 106         h = d;
	ld h, d
; 107         l = e;
	ld l, e
; 108         MyViewDyDx = hl;
	ld (myviewdydx), hl
	pop hl
; 109     }
; 110     do {
__l_55:
; 111         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 112         push_pop(de) {
	push de
; 113             do {
__l_58:
; 114                 MyViewCalcCharByPosDE();
	call myviewcalccharbyposde
; 115                 bios(a = biosPrintC);
	ld a, 0
	call bios
; 116                 e--;
	dec e
__l_59:
; 117             } while ((a = e) > 0);
	ld a, e
	or a
	jp nz, __l_58
	pop de
; 118         }
; 119         h++;
	inc h
; 120         d--;
	dec d
__l_56:
; 121     } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_55
	ret
; 122 }
; 123 
; 124 void MyViewCalcCharByPosDE() {
myviewcalccharbyposde:
; 125     //c = MyViewByteBorder + MyViewByteFrame;
; 126     a = MyViewByteBorder;
	ld a, 1
; 127     a += MyViewByteFrame;
	add 2
; 128     c = a;
	ld c, a
; 129     a = MyViewByte;
	ld a, (myviewbyte)
; 130     a &= c;
	and c
; 131     if (a > 0) {
	or a
	jp z, __l_61
; 132         push_pop(hl) {
	push hl
; 133             hl = MyViewDyDx;
	ld hl, (myviewdydx)
; 134             if ((a = d) == 1) { // Нижняя линия
	ld a, d
	cp 1
	jp nz, __l_63
; 135                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_65
; 136                     c = 0x89;
	ld c, 137
	jp __l_66
__l_65:
; 137                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_67
; 138                     c = 0x94;
	ld c, 148
	jp __l_68
__l_67:
; 139                 } else {
; 140                     c = 0x99;
	ld c, 153
__l_68:
__l_66:
	jp __l_64
__l_63:
; 141                 }
; 142             } else if ((a = d) == h) { // Верхняя линия
	ld a, d
	cp h
	jp nz, __l_69
; 143                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_71
; 144                     c = 0x88;
	ld c, 136
	jp __l_72
__l_71:
; 145                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_73
; 146                     c = 0x95;
	ld c, 149
	jp __l_74
__l_73:
; 147                 } else {
; 148                     c = 0x99;
	ld c, 153
__l_74:
__l_72:
	jp __l_70
__l_69:
; 149                 }
; 150             } else { // Между верхней и нижней
; 151                 if ((a = e) == 1) {
	ld a, e
	cp 1
	jp nz, __l_75
; 152                     c = 0x87;
	ld c, 135
	jp __l_76
__l_75:
; 153                 } else if ((a = e) == l) {
	ld a, e
	cp l
	jp nz, __l_77
; 154                     c = 0x87;
	ld c, 135
	jp __l_78
__l_77:
; 155                 } else {
; 156                     c = ' ';
	ld c, 32
__l_78:
__l_76:
__l_70:
__l_64:
	pop hl
	jp __l_62
__l_61:
; 157                 }
; 158             }
; 159         }
; 160     } else {
; 161         c = ' ';
	ld c, 32
__l_62:
	ret
; 162     }
; 163 }
; 164 
; 165 uint16_t MyViewDyDx = 0;
myviewdydx:
	dw 0
; 166 uint8_t MyViewByte = 0;
myviewbyte:
	db 0
; 11 void FtpHeaderViewStart() {
ftpheaderviewstart:
; 12     FtpHeaderViewShow();
; 13 }
; 14 
; 15 void FtpHeaderViewShow() {
ftpheaderviewshow:
; 16     bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 17     c = (a = FtpHeaderViewColor);
	ld a, (ftpheaderviewcolor)
	ld c, a
; 18     l = (a = FtpHeaderViewX);
	ld a, (ftpheaderviewx)
	ld l, a
; 19     h = (a = FtpHeaderViewY);
	ld a, (ftpheaderviewy)
	ld h, a
; 20     e = (a = FtpHeaderViewDX);
	ld a, (ftpheaderviewdx)
	ld e, a
; 21     d = (a = FtpHeaderViewDY);
	ld a, (ftpheaderviewdy)
	ld d, a
; 22     bios(a = biosWindowOpen);
	ld a, 85
	call bios
; 23     MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 24     FtpHeaderViewShowTitle();
	call ftpheaderviewshowtitle
; 25     FtpHeaderViewShowValue();
	jp ftpheaderviewshowvalue
; 26 }
; 27 
; 28 void FtpHeaderViewShowTitle() {
ftpheaderviewshowtitle:
; 29     push_pop(hl, bc) {
	push hl
	push bc
; 30         // TITLE
; 31         a = FtpHeaderViewX;
	ld a, (ftpheaderviewx)
; 32         b = a;
	ld b, a
; 33         a = FtpHeaderViewDX;
	ld a, (ftpheaderviewdx)
; 34         a += b;
	add b
; 35         a -= 6; //len Title
	sub 6
; 36         l = a;
	ld l, a
; 37         h = (a = FtpHeaderViewY);
	ld a, (ftpheaderviewy)
	ld h, a
; 38         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 39         bios(a = biosPrintMessageHL, hl = FtpViewTitle);
	ld a, 2
	ld hl, ftpviewtitle
	call bios
; 40         // IP
; 41         a = FtpHeaderViewX;
	ld a, (ftpheaderviewx)
; 42         a += 1;
	add 1
; 43         l = a;
	ld l, a
; 44         a = FtpHeaderViewY;
	ld a, (ftpheaderviewy)
; 45         a += 1;
	add 1
; 46         h = a;
	ld h, a
; 47         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 48         bios(a = biosPrintMessageHL, hl = FtpHeaderViewIpTitle);
	ld a, 2
	ld hl, ftpheaderviewiptitle
	call bios
; 49         // STATUS
; 50         a = FtpHeaderViewX;
	ld a, (ftpheaderviewx)
; 51         a += 1;
	add 1
; 52         l = a;
	ld l, a
; 53         a = FtpHeaderViewY;
	ld a, (ftpheaderviewy)
; 54         a += 2;
	add 2
; 55         h = a;
	ld h, a
; 56         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 57         bios(a = biosPrintMessageHL, hl = FtpHeaderViewStateTitle);
	ld a, 2
	ld hl, ftpheaderviewstatetitle
	call bios
	pop bc
	pop hl
	ret
; 58     }
; 59 }
; 60 
; 61 void FtpHeaderViewShowValue() {
ftpheaderviewshowvalue:
; 62     push_pop(hl, bc) {
	push hl
	push bc
; 63         bios(c = (a = FtpHeaderViewColor), a = biosSetColorC);
	ld a, (ftpheaderviewcolor)
	ld c, a
	ld a, 18
	call bios
; 64         //IP
; 65         a = FtpHeaderViewX;
	ld a, (ftpheaderviewx)
; 66         a += 5;
	add 5
; 67         l = a;
	ld l, a
; 68         a = FtpHeaderViewY;
	ld a, (ftpheaderviewy)
; 69         a += 1;
	add 1
; 70         h = a;
	ld h, a
; 71         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 72         MyFuncPrintHLStrLenA(hl = FtpHeaderViewIpValue, a = 16);
	ld hl, ftpheaderviewipvalue
	ld a, 16
	call myfuncprinthlstrlena
; 73         // STATUS
; 74         FtpHeaderViewShowStatus();
	call ftpheaderviewshowstatus
	pop bc
	pop hl
	ret
; 75     }
; 76 }
; 77 
; 78 void FtpHeaderViewShowStatus() {
ftpheaderviewshowstatus:
; 79     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 80         a = FtpHeaderViewX;
	ld a, (ftpheaderviewx)
; 81         a += 9;
	add 9
; 82         d = a; // X
	ld d, a
; 83         l = a;
	ld l, a
; 84         a = FtpHeaderViewY;
	ld a, (ftpheaderviewy)
; 85         a += 2;
	add 2
; 86         e = a; // Y
	ld e, a
; 87         h = a;
	ld h, a
; 88         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 89         //--
; 90         if ((a = FtpHeaderViewStatus) == 0) {
	ld a, (ftpheaderviewstatus)
	or a
	jp nz, __l_79
; 91             hl = FtpHeaderViewStatus0;
	ld hl, ftpheaderviewstatus0
; 92             a = FtpHeaderViewColor;
	ld a, (ftpheaderviewcolor)
; 93             c = a;
	ld c, a
	jp __l_80
__l_79:
; 94         } else {
; 95             hl = FtpHeaderViewStatus1;
	ld hl, ftpheaderviewstatus1
; 96             a = FtpHeaderViewConnectColor;
	ld a, (ftpheaderviewconnectcolor)
; 97             c = a;
	ld c, a
__l_80:
; 98         }
; 99         bios(a = biosSetColorC);
	ld a, 18
	call bios
; 100         MyFuncPrintHLStrLenA(a = 14);
	ld a, 14
	call myfuncprinthlstrlena
	pop de
	pop bc
	pop hl
	ret
; 101     }
; 102 }
; 103 
; 104 uint8_t FtpHeaderViewX = 0;
ftpheaderviewx:
	db 0
; 105 uint8_t FtpHeaderViewY = 0;
ftpheaderviewy:
	db 0
; 106 uint8_t FtpHeaderViewDX = 24;
ftpheaderviewdx:
	db 24
; 107 uint8_t FtpHeaderViewDY = 4;
ftpheaderviewdy:
	db 4
; 112 uint8_t FtpHeaderViewColor = 0x5f; //0x67;
ftpheaderviewcolor:
	db 95
; 113 uint8_t FtpHeaderViewConnectColor = 0x52;
ftpheaderviewconnectcolor:
	db 82
; 116 uint8_t FtpHeaderViewIpTitle[] =    "IP:";
ftpheaderviewiptitle:
	db 73
	db 80
	db 58
	ds 1
; 117 uint8_t FtpHeaderViewStateTitle[] = "Status:";
ftpheaderviewstatetitle:
	db 83
	db 116
	db 97
	db 116
	db 117
	db 115
	db 58
	ds 1
; 118 uint8_t FtpHeaderViewIpValue[16] = "0.0.0.0";
ftpheaderviewipvalue:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 120 uint8_t FtpHeaderViewStatus = 0;
ftpheaderviewstatus:
	db 0
; 121 uint8_t FtpHeaderViewStatus0[] = "DISCONNECT";
ftpheaderviewstatus0:
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
; 122 uint8_t FtpHeaderViewStatus1[] = "CONNECT";
ftpheaderviewstatus1:
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	ds 1
; 11 void WiFiHeaderViewStart() {
wifiheaderviewstart:
; 12     WiFiHeaderViewShow();
; 13 }
; 14 
; 15 void WiFiHeaderViewShow() {
wifiheaderviewshow:
; 16     bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 17     c = (a = WiFiHeaderViewColor);
	ld a, (wifiheaderviewcolor)
	ld c, a
; 18     l = (a = WiFiHeaderViewX);
	ld a, (wifiheaderviewx)
	ld l, a
; 19     h = (a = WiFiHeaderViewY);
	ld a, (wifiheaderviewy)
	ld h, a
; 20     e = (a = WiFiHeaderViewDX);
	ld a, (wifiheaderviewdx)
	ld e, a
; 21     d = (a = WiFiHeaderViewDY);
	ld a, (wifiheaderviewdy)
	ld d, a
; 22     bios(a = biosWindowOpen);
	ld a, 85
	call bios
; 23     MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 24     WiFiHeaderViewShowTitle();
	call wifiheaderviewshowtitle
; 25     WiFiHeaderViewShowValue();
	jp wifiheaderviewshowvalue
; 26 }
; 27 
; 28 void WiFiHeaderViewShowTitle() {
wifiheaderviewshowtitle:
; 29     push_pop(hl, bc) {
	push hl
	push bc
; 30         //Title
; 31         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 32         b = a;
	ld b, a
; 33         a = WiFiHeaderViewDX;
	ld a, (wifiheaderviewdx)
; 34         a += b;
	add b
; 35         a -= 8; //len Title
	sub 8
; 36         l = a;
	ld l, a
; 37         h = (a = WiFiHeaderViewY);
	ld a, (wifiheaderviewy)
	ld h, a
; 38         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 39         bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitle);
	ld a, 2
	ld hl, wifiheaderviewtitle
	call bios
; 40         //SSID
; 41         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 42         a++;
	inc a
; 43         l = a;
	ld l, a
; 44         a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 45         a++;
	inc a
; 46         h = a;
	ld h, a
; 47         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 48         bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleSSID);
	ld a, 2
	ld hl, wifisettingsviewtitlessid
	call bios
; 49         //IP
; 50         a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 51         a += 1;
	add 1
; 52         l = a;
	ld l, a
; 53         a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 54         a += 2;
	add 2
; 55         h = a;
	ld h, a
; 56         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 57         bios(a = biosPrintMessageHL, hl = WiFiHeaderViewTitleIP);
	ld a, 2
	ld hl, wifiheaderviewtitleip
	call bios
	pop bc
	pop hl
	ret
; 58     }
; 59 }
; 60 
; 61 
; 62 
; 63 void WiFiHeaderViewShowValue() {
wifiheaderviewshowvalue:
; 64     // set color
; 65     bios(c = (a = WiFiHeaderViewColor), a = biosSetColorC);
	ld a, (wifiheaderviewcolor)
	ld c, a
	ld a, 18
	call bios
; 66     // SSID
; 67     a = WiFiHeaderViewX;
	ld a, (wifiheaderviewx)
; 68     a += 7;
	add 7
; 69     l = a;
	ld l, a
; 70     a = WiFiHeaderViewY;
	ld a, (wifiheaderviewy)
; 71     a += 1;
	add 1
; 72     h = a;
	ld h, a
; 73     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 74     MyFuncPrintHLStrLenA(hl = WiFiSettingsViewSsidValue, a = 16);
	ld hl, wifisettingsviewssidvalue
	ld a, 16
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
; 83     MyFuncPrintHLStrLenA(hl = WiFiSettingsViewIpValue, a = 16);
	ld hl, wifisettingsviewipvalue
	ld a, 16
	jp myfuncprinthlstrlena
; 84 }
; 85 
; 86 uint8_t WiFiHeaderViewX = 24;
wifiheaderviewx:
	db 24
; 87 uint8_t WiFiHeaderViewY = 0;
wifiheaderviewy:
	db 0
; 88 uint8_t WiFiHeaderViewDX = 24;
wifiheaderviewdx:
	db 24
; 89 uint8_t WiFiHeaderViewDY = 4;
wifiheaderviewdy:
	db 4
; 93 uint8_t WiFiHeaderViewColor = 0x5f; //0x67;
wifiheaderviewcolor:
	db 95
; 96 uint8_t WiFiHeaderViewTitleIP[] =   "IP  : ";
wifiheaderviewtitleip:
	db 73
	db 80
	db 32
	db 32
	db 58
	db 32
	ds 1
; 97 uint8_t WiFiHeaderViewTitle[] = {0x82, 'W', 'i', '-', 'F', 'i', 0x92, '\0'};
wifiheaderviewtitle:
	db 130
	db 87
	db 105
	db 45
	db 70
	db 105
	db 146
	db 0
; 99 uint8_t WiFiHeaderViewMNum = 0;
wifiheaderviewmnum:
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
; 15         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 16         c = (a = WiFiSettingsViewColor);
	ld a, (wifisettingsviewcolor)
	ld c, a
; 17         l = (a = WiFiSettingsViewX);
	ld a, (wifisettingsviewx)
	ld l, a
; 18         h = (a = WiFiSettingsViewY);
	ld a, (wifisettingsviewy)
	ld h, a
; 19         e = (a = WiFiSettingsViewDX);
	ld a, (wifisettingsviewdx)
	ld e, a
; 20         d = (a = WiFiSettingsViewDY);
	ld a, (wifisettingsviewdy)
	ld d, a
; 21         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 22         MyFuncSetFullScreen();
	call myfuncsetfullscreen
	pop de
	pop hl
	pop bc
; 23     }
; 24     a = 0;
	ld a, 0
; 25     WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 26     WiFiSettingsViewShowTitle();
	call wifisettingsviewshowtitle
; 27     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 28     WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp wifisettingsviewselectlinea
; 29 }
; 30 
; 31 void WiFiSettingsViewShowTitle() {
wifisettingsviewshowtitle:
; 32     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 33         // Title
; 34         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 35         a += 7;
	add 7
; 36         l = a;
	ld l, a
; 37         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 38         a += 1; //2;
	add 1
; 39         h = a;
	ld h, a
; 40         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 41         bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitle);
	ld a, 2
	ld hl, wifisettingsviewtitle
	call bios
; 42         // LINE!!!
; 43         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 44         a += 1;
	add 1
; 45         h = a;
	ld h, a
; 46         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 47         a += 2;
	add 2
; 48         l = a;
	ld l, a
; 49         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 50         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 51         a -= 2;
	sub 2
; 52         b = a;
	ld b, a
; 53         c = 0x90;
	ld c, 144
; 54         do {
__l_81:
; 55             bios(a = biosPrintC);
	ld a, 0
	call bios
; 56             b--;
	dec b
__l_82:
; 57         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_81
; 58         // SSID
; 59         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 60         a += 2;
	add 2
; 61         l = a;
	ld l, a
; 62         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 63         a += 4;
	add 4
; 64         h = a;
	ld h, a
; 65         push_pop(hl) {
	push hl
; 66             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 67             bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleSSID);
	ld a, 2
	ld hl, wifisettingsviewtitlessid
	call bios
	pop hl
; 68         }
; 69         // PASS
; 70         h++;
	inc h
; 71         push_pop(hl) {
	push hl
; 72             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 73             bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitlePass);
	ld a, 2
	ld hl, wifisettingsviewtitlepass
	call bios
	pop hl
; 74         }
; 75         // MAC
; 76         h++;
	inc h
; 77         c = h;
	ld c, h
; 78         push_pop(hl) {
	push hl
; 79             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 80             bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitleMac);
	ld a, 2
	ld hl, wifisettingsviewtitlemac
	call bios
	pop hl
; 81         }
; 82         // OK
; 83         d = 13;
	ld d, 13
; 84         e = 3;
	ld e, 3
; 85         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 86         a += 7;
	add 7
; 87         h = a;
	ld h, a
; 88         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 89         a += 8;
	add 8
; 90         l = a;
	ld l, a
; 91         if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
	ld a, (wifisettingsviewssidisconnected)
	or a
	jp nz, __l_84
; 92             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp __l_85
__l_84:
; 93         } else {
; 94             bc = StringLocaleOK;
	ld bc, stringlocaleok
__l_85:
; 95         }
; 96         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 97     }
; 98 }
; 99 
; 100 void WiFiSettingsViewShowValue() {
wifisettingsviewshowvalue:
; 101     push_pop(hl, bc) {
	push hl
	push bc
; 102         // set color
; 103         bios(c = (a = WiFiSettingsViewColor), a = biosSetColorC);
	ld a, (wifisettingsviewcolor)
	ld c, a
	ld a, 18
	call bios
; 104         // SSID
; 105         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 106         a += 8;
	add 8
; 107         b = a; // X
	ld b, a
; 108         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 109         a += 4;
	add 4
; 110         c = a; // Y
	ld c, a
; 111         bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
	ld a, 28
	ld h, c
	ld l, b
	call bios
; 112         MyFuncPrintHLStrLenA(hl = WiFiSettingsViewSsidValue, a = 18);
	ld hl, wifisettingsviewssidvalue
	ld a, 18
	call myfuncprinthlstrlena
; 113         // PASS
; 114         c++;
	inc c
; 115         bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
	ld a, 28
	ld h, c
	ld l, b
	call bios
; 116         MyFuncPrintHLPassLenA(hl = WiFiSettingsViewPassValue, a = 18);
	ld hl, wifisettingsviewpassvalue
	ld a, 18
	call myfuncprinthlpasslena
; 117         // MAC
; 118         c++;
	inc c
; 119         bios(a = biosSetPositionCursoreHL, h = c, l = b); //h=y l=x
	ld a, 28
	ld h, c
	ld l, b
	call bios
; 120         MyFuncPrintHLStrLenA(hl = WiFiSettingsViewMacValue, a = 18);
	ld hl, wifisettingsviewmacvalue
	ld a, 18
	call myfuncprinthlstrlena
	pop bc
	pop hl
	ret
; 121     }
; 122 }
; 123 
; 124 /// Рисование линии прямым или инверсным цветом
; 125 /// 0 - прямой
; 126 /// 1 - инверсный
; 127 void WiFiSettingsViewSelectLineA() {
wifisettingsviewselectlinea:
; 128     push_pop(bc, hl) {
	push bc
	push hl
; 129         c = a;
	ld c, a
; 130         // 0 - Button
; 131         if ((a = WiFiSettingsViewSelectPos) == 0) {
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, __l_86
; 132             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp __l_87
__l_86:
; 133         } else {
; 134             WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 135             // C
; 136             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_88
; 137                 a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
	jp __l_89
__l_88:
; 138             } else {
; 139                 a = WiFiSettingsViewInvColor;
	ld a, (wifisettingsviewinvcolor)
__l_89:
; 140             }
; 141             c = a;
	ld c, a
; 142             // A
; 143             MyViewChangeBoxColor();
	call myviewchangeboxcolor
__l_87:
	pop hl
	pop bc
	ret
; 144         }
; 145     }
; 146 }
; 147 
; 148 /// вых [HL] -
; 149 /// вых [DE]-
; 150 void WiFiSettingsViewByPosBoxValue() {
wifisettingsviewbyposboxvalue:
; 151     push_pop(bc) {
	push bc
; 152         // HL
; 153         a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 154         b = a;
	ld b, a
; 155         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 156         a += 3;
	add 3
; 157         a += b;
	add b
; 158         h = a;
	ld h, a
; 159         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 160         a += 7;
	add 7
; 161         l = a;
	ld l, a
; 162         // DE
; 163         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 164         a -= 8;
	sub 8
; 165         e = a;
	ld e, a
; 166         a = 1;
	ld a, 1
; 167         d = a;
	ld d, a
	pop bc
	ret
; 168     }
; 169 }
; 170 
; 171 /// Обновление позиции
; 172 /// вх[A]
; 173 /// 0 - без изменений
; 174 /// 1 - вверх
; 175 /// 0xFF - вниз
; 176 void WiFiSettingsViewPosUpdateA() {
wifisettingsviewposupdatea:
; 177     push_pop(bc) {
	push bc
; 178         b = a;
	ld b, a
; 179         if (a == 0) {
	or a
	jp nz, __l_90
; 180             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
	jp __l_91
__l_90:
; 181         } else {
; 182             a = 3;
	ld a, 3
; 183             c = a;
	ld c, a
; 184             WiFiSettingsViewSelectLineA(a = 0);
	ld a, 0
	call wifisettingsviewselectlinea
; 185             a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 186             a += b;
	add b
; 187             //-- FIX
; 188             if (a == 0xFF) {
	cp 255
	jp nz, __l_92
; 189                 a = c;
	ld a, c
; 190                 a--;
	dec a
	jp __l_93
__l_92:
; 191             } else if (a == c) {
	cp c
	jp nz, __l_94
; 192                 a = 0;
	ld a, 0
__l_94:
__l_93:
; 193             }
; 194             //--
; 195             WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 196             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
__l_91:
	pop bc
	ret
; 197         }
; 198     }
; 199 }
; 200 
; 201 /// вых [BC] -
; 202 void WiFiSettingsViewByPosValue() {
wifisettingsviewbyposvalue:
; 203     push_pop(hl) {
	push hl
; 204         if ((a = WiFiSettingsViewSelectPos) == 2) {
	ld a, (wifisettingsviewselectpos)
	cp 2
	jp nz, __l_96
; 205             bc = WiFiSettingsViewPassValue;
	ld bc, wifisettingsviewpassvalue
	jp __l_97
__l_96:
; 206         } else {
; 207             bc = 0;
	ld bc, 0
__l_97:
	pop hl
	ret
; 208         }
; 209     }
; 210 }
; 211 
; 212 void WiFiSettingsViewClose() {
wifisettingsviewclose:
; 213     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 214     CurrentViewReturn();
	jp currentviewreturn
; 215 }
; 216 
; 217 void WiFiSettingsViewKeyA() {
wifisettingsviewkeya:
; 218     push_pop(hl) {
	push hl
; 219         l = a;
	ld l, a
; 220         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_98
; 221             if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_100
; 222                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_102
; 223                     WiFiSettingsViewClose();
	call wifisettingsviewclose
	jp __l_103
__l_102:
; 224                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_104
; 225                     if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, __l_106
; 226                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 227                         if ((a = WiFiSettingsViewSSIDIsConnected) == 0) {
	ld a, (wifisettingsviewssidisconnected)
	or a
	jp nz, __l_108
; 228                             #ifdef _IS_SIMULATOR
; 229 
; 230                             #else
; 231                                 NetWiFiConnect(); // Подключиться
	call netwificonnect
; 232                                 ThreadsTickNow(); // Обновить
	call threadsticknow
; 233                                 ThreadsNetDetectError();
	call threadsnetdetecterror
__l_108:
	jp __l_107
__l_106:
; 234                             #endif
; 235                         }
; 236                     } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
	ld a, (wifisettingsviewselectpos)
	cp 1
	jp nz, __l_110
; 237                         WiFiNetworksViewShow();
	call wifinetworksviewshow
	jp __l_111
__l_110:
; 238                     } else { // Переход в редактирование
; 239                         WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 240                         WiFiSettingsViewByPosValue();
	call wifisettingsviewbyposvalue
; 241                         EditFieldViewShow();
	call editfieldviewshow
; 242                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, __l_112
; 243                             #ifdef _IS_SIMULATOR
; 244 
; 245                             #else
; 246                                 ThreadsNetPasswordUpdate();
	call threadsnetpasswordupdate
; 247                             #endif
; 248                             WiFiHeaderViewShowValue();
	call wifiheaderviewshowvalue
__l_112:
; 249                         }
; 250                         WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 251                         WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
__l_111:
__l_107:
	jp __l_105
__l_104:
; 252                     }
; 253                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_114
; 254                     WiFiSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifisettingsviewposupdatea
	jp __l_115
__l_114:
; 255                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_116
; 256                     WiFiSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifisettingsviewposupdatea
__l_116:
__l_115:
__l_105:
__l_103:
__l_100:
__l_98:
	pop hl
	ret
; 257                 }
; 258             }
; 259         }
; 260     }
; 261 }
; 262 
; 263 uint8_t WiFiSettingsViewX = 11;
wifisettingsviewx:
	db 11
; 264 uint8_t WiFiSettingsViewY = 10;
wifisettingsviewy:
	db 10
; 265 uint8_t WiFiSettingsViewDX = 27;
wifisettingsviewdx:
	db 27
; 266 uint8_t WiFiSettingsViewDY = 13;
wifisettingsviewdy:
	db 13
; 267 uint8_t WiFiSettingsViewColor = 0x70;
wifisettingsviewcolor:
	db 112
; 268 uint8_t WiFiSettingsViewInvColor = 0x07;
wifisettingsviewinvcolor:
	db 7
; 270 uint8_t WiFiSettingsViewSelectPos = 0;
wifisettingsviewselectpos:
	db 0
; 272 uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
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
; 273 uint8_t WiFiSettingsViewTitleSSID[] = "SSID: ";
wifisettingsviewtitlessid:
	db 83
	db 83
	db 73
	db 68
	db 58
	db 32
	ds 1
; 274 uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
wifisettingsviewtitlepass:
	db 80
	db 97
	db 115
	db 115
	db 58
	ds 1
; 275 uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
wifisettingsviewtitlemac:
	db 32
	db 77
	db 65
	db 67
	db 58
	ds 1
; 276 uint8_t WiFiSettingsViewButtonTitle[] = "Connect";
wifisettingsviewbuttontitle:
	db 67
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	ds 1
; 277 uint8_t WiFiSettingsViewSSIDIsConnected = 0;
wifisettingsviewssidisconnected:
	db 0
; 279 uint8_t WiFiSettingsViewSsidValue[16] = "-";
wifisettingsviewssidvalue:
	db 45
	ds 15
; 280 uint8_t WiFiSettingsViewPassValue[16] = "-";
wifisettingsviewpassvalue:
	db 45
	ds 15
; 281 uint8_t WiFiSettingsViewMacValue[18] = "00:00:00:00:00:00";
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
; 282 uint8_t WiFiSettingsViewIpValue[16] = "0.0.0.0";
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
__l_118:
; 18             a = *hl;
	ld a, (hl)
; 19             if (a > 0) {
	or a
	jp z, __l_121
; 20                 d++;
	inc d
; 21                 c = a;
	ld c, a
; 22                 bios(a = biosPrintC);
	ld a, 0
	call bios
__l_121:
; 23             }
; 24             a = *hl;
	ld a, (hl)
; 25             hl++;
	inc hl
__l_119:
; 26         } while (a > 0);
	or a
	jp nz, __l_118
; 27         if ((a = d) < b) {
	ld a, d
	cp b
	jp nc, __l_123
; 28             a = b;
	ld a, b
; 29             a -= d;
	sub d
; 30             b = a;
	ld b, a
; 31             do {
__l_125:
; 32                 bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 33                 b--;
	dec b
__l_126:
; 34             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_125
__l_123:
	pop de
	pop bc
	ret
; 35         }
; 36     }
; 37 }
; 38 
; 39 /// Выводит строку из HL с текущего положения заменяя все символы *
; 40 /// Длиной A. Если текст короче , то добиват до A пробелами
; 41 void MyFuncPrintHLPassLenA() {
myfuncprinthlpasslena:
; 42     push_pop(bc, de) {
	push bc
	push de
; 43         b = a;
	ld b, a
; 44         d = 0;
	ld d, 0
; 45         do {
__l_128:
; 46             a = *hl;
	ld a, (hl)
; 47             if (a > 0) {
	or a
	jp z, __l_131
; 48                 d++;
	inc d
; 49                 bios(a = biosPrintC, c = '*');
	ld a, 0
	ld c, 42
	call bios
__l_131:
; 50             }
; 51             a = *hl;
	ld a, (hl)
; 52             hl++;
	inc hl
__l_129:
; 53         } while (a > 0);
	or a
	jp nz, __l_128
; 54         if ((a = d) < b) {
	ld a, d
	cp b
	jp nc, __l_133
; 55             a = b;
	ld a, b
; 56             a -= d;
	sub d
; 57             b = a;
	ld b, a
; 58             do {
__l_135:
; 59                 bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 60                 b--;
	dec b
__l_136:
; 61             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_135
__l_133:
	pop de
	pop bc
	ret
; 62         }
; 63     }
; 64 }
; 65 
; 66 void MyFuncPosXAddA() {
myfuncposxadda:
; 67     push_pop(hl, bc) {
	push hl
	push bc
; 68         b = a;
	ld b, a
; 69         bios(a = biosGetPositionCursoreHL);
	ld a, 29
	call bios
; 70         a = b;
	ld a, b
; 71         a += l;
	add l
; 72         l = a;
	ld l, a
; 73         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop bc
	pop hl
	ret
; 74     }
; 75 }
; 76 
; 77 /// Спавнение HL и DE
; 78 /// CF=1 when DE < HL
; 79 /// CF=0 DE >= HL
; 80 void MyFuncCompareHlDe() {
myfunccomparehlde:
; 81     a = d;
	ld a, d
; 82     a ^= h;
	xor h
; 83     if (flag_p) {
	jp m, __l_138
	jp __l_139
__l_138:
; 84     } else {
; 85         a ^= d;
	xor d
; 86         if (flag_m) {
	jp p, __l_140
; 87             return;
	ret
__l_140:
; 88         }
; 89         set_flag_c();
	scf
; 90         return;
	ret
__l_139:
; 91     }
; 92     a = e;
	ld a, e
; 93     a -= l;
	sub l
; 94     a = d;
	ld a, d
; 95     carry_sub(a, h);
	sbc h
; 96     return;
	ret
; 97 }
; 98 
; 99 /// Вывести на экран значение A как десятичное число с ведущем 0
; 100 /// A не больше 99 или 0x63
; 101 /// Если больше - ничего не выводит
; 102 void MyFuncDec099A() {
myfuncdec099a:
; 103     if (a < 0x64) {
	cp 100
	jp nc, __l_142
; 104         push_pop(bc, de) {
	push bc
	push de
; 105             b = a;
	ld b, a
; 106             c = a;
	ld c, a
; 107             d = 0;
	ld d, 0
; 108             e = 10;
	ld e, 10
; 109             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, __l_144
; 110                 *hl = (a = '0');
	ld a, 48
	ld (hl), a
; 111                 hl++;
	inc hl
; 112                 a = b;
	ld a, b
; 113                 a += '0';
	add 48
; 114                 *hl = a;
	ld (hl), a
; 115                 hl++;
	inc hl
	jp __l_145
__l_144:
; 116             } else {
; 117                 do {
__l_146:
; 118                     a = b;
	ld a, b
; 119                     a -= e;
	sub e
; 120                     b = a;
	ld b, a
; 121                     d++;
	inc d
__l_147:
; 122                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, __l_146
; 123                 a = d;
	ld a, d
; 124                 a += '0';
	add 48
; 125                 *hl = a;
	ld (hl), a
; 126                 hl++;
	inc hl
; 127                 a = b;
	ld a, b
; 128                 a += '0';
	add 48
; 129                 *hl = a;
	ld (hl), a
; 130                 hl++;
	inc hl
__l_145:
	pop de
	pop bc
__l_142:
	ret
; 131             }
; 132         }
; 133     }
; 134 }
; 135 
; 136 /// Вывести на экран значение A как десятичное число
; 137 /// A не больше 99 или 0x63
; 138 /// Если больше - ничего не выводит
; 139 void MyFuncDec99A() {
myfuncdec99a:
; 140     if (a < 0x64) {
	cp 100
	jp nc, __l_149
; 141         push_pop(bc, de) {
	push bc
	push de
; 142             b = a;
	ld b, a
; 143             c = a;
	ld c, a
; 144             d = 0;
	ld d, 0
; 145             e = 10;
	ld e, 10
; 146             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, __l_151
; 147                 *hl = (a = ' ');
	ld a, 32
	ld (hl), a
; 148                 hl++;
	inc hl
; 149                 a = b;
	ld a, b
; 150                 a += '0';
	add 48
; 151                 *hl = a;
	ld (hl), a
; 152                 hl++;
	inc hl
	jp __l_152
__l_151:
; 153             } else {
; 154                 do {
__l_153:
; 155                     a = b;
	ld a, b
; 156                     a -= e;
	sub e
; 157                     b = a;
	ld b, a
; 158                     d++;
	inc d
__l_154:
; 159                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, __l_153
; 160                 a = d;
	ld a, d
; 161                 a += '0';
	add 48
; 162                 *hl = a;
	ld (hl), a
; 163                 hl++;
	inc hl
; 164                 a = b;
	ld a, b
; 165                 a += '0';
	add 48
; 166                 *hl = a;
	ld (hl), a
; 167                 hl++;
	inc hl
__l_152:
	pop de
	pop bc
__l_149:
	ret
; 168             }
; 169         }
; 170     }
; 171 }
; 172 
; 173 uint16_t MyFuncDec4095HL = 0;
myfuncdec4095hl:
	dw 0
; 174 void MyFuncDec4095SaveA(){
myfuncdec4095savea:
; 175     push_pop(hl) {
	push hl
; 176         hl = MyFuncDec4095HL;
	ld hl, (myfuncdec4095hl)
; 177         *hl = a;
	ld (hl), a
; 178         hl++;
	inc hl
; 179         MyFuncDec4095HL = hl;
	ld (myfuncdec4095hl), hl
	pop hl
	ret
; 180     }
; 181 }
; 182 void MyFuncDec4095DeByHl() {
myfuncdec4095debyhl:
; 183     MyFuncDec4095HL = hl;
	ld (myfuncdec4095hl), hl
; 184     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 185         swap(hl, de);
	ex hl, de
; 186         de = 0x0FFF;
	ld de, 4095
; 187         MyFuncCompareHlDe();
	call myfunccomparehlde
; 188         if (flag_nc) {
	jp c, __l_156
; 189             c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
	ld c, 0
; 190             //1000
; 191             de = 0x03E8;
	ld de, 1000
; 192             MyFuncCompareHlDe();
	call myfunccomparehlde
; 193             if (flag_c) {
	jp nc, __l_158
; 194                 b = 0;
	ld b, 0
; 195                 do {
__l_160:
; 196                     de = 0xFC18;
	ld de, 64536
; 197                     hl += de;
	add hl, de
; 198                     b++;
	inc b
; 199                     de = 0x03E8;
	ld de, 1000
; 200                     MyFuncCompareHlDe();
	call myfunccomparehlde
__l_161:
	jp c, __l_160
; 201                 } while (flag_c);
; 202                 a = b;
	ld a, b
; 203                 a += '0';
	add 48
; 204                 MyFuncDec4095SaveA();
	call myfuncdec4095savea
; 205                 c = 1;
	ld c, 1
	jp __l_159
__l_158:
; 206             } else {
; 207                 MyFuncDec4095SaveA(a = ' ');
	ld a, 32
	call myfuncdec4095savea
__l_159:
; 208             }
; 209             //0100
; 210             de = 0x0064;
	ld de, 100
; 211             MyFuncCompareHlDe();
	call myfunccomparehlde
; 212             if (flag_c) {
	jp nc, __l_163
; 213                 b = 0;
	ld b, 0
; 214                 do {
__l_165:
; 215                     de = 0xFF9C;
	ld de, 65436
; 216                     hl += de;
	add hl, de
; 217                     b++;
	inc b
; 218                     de = 0x0064;
	ld de, 100
; 219                     MyFuncCompareHlDe();
	call myfunccomparehlde
__l_166:
	jp c, __l_165
; 220                 } while (flag_c);
; 221                 a = b;
	ld a, b
; 222                 a += '0';
	add 48
; 223                 MyFuncDec4095SaveA();
	call myfuncdec4095savea
; 224                 c = 1;
	ld c, 1
	jp __l_164
__l_163:
; 225             } else {
; 226                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_168
; 227                     MyFuncDec4095SaveA(a = ' ');
	ld a, 32
	call myfuncdec4095savea
	jp __l_169
__l_168:
; 228                 } else {
; 229                     MyFuncDec4095SaveA(a = '0');
	ld a, 48
	call myfuncdec4095savea
__l_169:
__l_164:
; 230                 }
; 231             }
; 232             a = l;
	ld a, l
; 233             if ((a = l) >= 10) {
	ld a, l
	cp 10
	jp c, __l_170
; 234                 b = 0;
	ld b, 0
; 235                 do {
__l_172:
; 236                     a = l;
	ld a, l
; 237                     a -= 10;
	sub 10
; 238                     l = a;
	ld l, a
; 239                     b++;
	inc b
__l_173:
; 240                 } while ((a = l) >= 10);
	ld a, l
	cp 10
	jp nc, __l_172
; 241                 a = b;
	ld a, b
; 242                 a += '0';
	add 48
; 243                 MyFuncDec4095SaveA();
	call myfuncdec4095savea
; 244                 c = 1;
	ld c, 1
	jp __l_171
__l_170:
; 245             } else {
; 246                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_175
; 247                     MyFuncDec4095SaveA(a = ' ');
	ld a, 32
	call myfuncdec4095savea
	jp __l_176
__l_175:
; 248                 } else {
; 249                     MyFuncDec4095SaveA(a = '0');
	ld a, 48
	call myfuncdec4095savea
__l_176:
__l_171:
; 250                 }
; 251             }
; 252             //0001
; 253             a = l;
	ld a, l
; 254             a += '0';
	add 48
; 255             MyFuncDec4095SaveA();
	call myfuncdec4095savea
__l_156:
	pop hl
	pop de
	pop bc
	ret
; 256         }
; 257     }
; 258 }
; 259 
; 260 void MyFunc4CharSizeDE() {
myfunc4charsizede:
; 261     push_pop(hl, de) {
	push hl
	push de
; 262         hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 263         if ((a = d) < 4) { // < 1024 в байтах //flag_c
	ld a, d
	cp 4
	jp nc, __l_177
; 264             MyFuncDec4095DeByHl();
	call myfuncdec4095debyhl
	jp __l_178
__l_177:
; 265         } else { // В Кб
; 266             a = d;
	ld a, d
; 267             a &= 0xFC;
	and 252
; 268             cyclic_rotate_right(a, 2);
	rrca
	rrca
; 269             MyFuncDec99A();
	call myfuncdec99a
; 270             *hl = (a = 'K');
	ld a, 75
	ld (hl), a
; 271             hl++;
	inc hl
; 272             *hl = (a = 'b');
	ld a, 98
	ld (hl), a
__l_178:
	pop de
	pop hl
	ret
; 273         }
; 274     }
; 275 }
; 276 
; 277 uint8_t MyFunc4Chars[4] = {0x00, 0x00, 0x00, 0x00};
myfunc4chars:
	db 0
	db 0
	db 0
	db 0
; 279 void MyFuncLoadEXTDRV() {
myfuncloadextdrv:
; 280     // проверка наличия драйвера
; 281     bios(a = biosGetExtDRVVersion);
	ld a, 80
	call bios
; 282     if (flag_c) {
	jp nc, __l_179
; 283         // Загрузка драйвера в (WP)
; 284         bios(a = biosSetNameBufferHL, hl = MyFuncEXTDRV_FileName);
	ld a, 133
	ld hl, myfuncextdrv_filename
	call bios
; 285         bios(a = biosLoadFileBC, b = 0x01, c = 0x00);
	ld a, 139
	ld b, 1
	ld c, 0
	call bios
; 286         if (flag_c) {
	jp nc, __l_181
	jp __l_182
__l_181:
; 287             // ошибка
; 288         } else {
; 289             // Установка драйвера в CONIO
; 290             bios(a = biosSetDriverExtensionHL);
	ld a, 44
	call bios
__l_182:
	jp __l_180
__l_179:
; 291         }
; 292     } else {
__l_180:
	ret
; 293         // есть
; 294     }
; 295 }
; 296 uint8_t MyFuncEXTDRV_FileName[] = "EXTDRV";
myfuncextdrv_filename:
	db 69
	db 88
	db 84
	db 68
	db 82
	db 86
	ds 1
; 298 void MyFuncCheckExtDrv() {
myfunccheckextdrv:
; 299     bios(a = biosGetExtDRVVersion);
	ld a, 80
	call bios
; 300     if (flag_c) {
	jp nc, __l_183
	jp __l_184
__l_183:
; 301     } else {
; 302         compare(a, 0x27);
	cp 39
; 303         if (flag_nc) {
	jp c, __l_185
; 304             a = 0xBB;
	ld a, 187
; 305             a -= b;
	sub b
; 306             if (flag_z) return;
	ret z
__l_185:
__l_184:
	ret
; 307         }
; 308     }
; 309 }
; 310 uint8_t MyFunc_DefExtDrv_Version = 0x27;
myfunc_defextdrv_version:
	db 39
; 312 void MyFuncSetFullScreen() {
myfuncsetfullscreen:
; 313     push_pop(hl) {
	push hl
; 314         bios(a = biosSetScreenBeginHL, hl = 0x0000);
	ld a, 24
	ld hl, 0
	call bios
; 315         bios(a = biosSetScreenSizeHL, h = 32, l = 48);
	ld a, 26
	ld h, 32
	ld l, 48
	call bios
	pop hl
	ret
; 11 void HelpFooterViewShow() {
helpfooterviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         c = (a = HelpFooterViewColor);
	ld a, (helpfooterviewcolor)
	ld c, a
; 14         l = (a = HelpFooterViewX);
	ld a, (helpfooterviewx)
	ld l, a
; 15         h = (a = HelpFooterViewY);
	ld a, (helpfooterviewy)
	ld h, a
; 16         e = (a = HelpFooterViewDX);
	ld a, (helpfooterviewdx)
	ld e, a
; 17         d = (a = HelpFooterViewDY);
	ld a, (helpfooterviewdy)
	ld d, a
; 18         push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 19             MyViewClearBox();
	call myviewclearbox
	pop de
	pop hl
	pop bc
; 20         }
; 21         MyViewChangeBoxColor();
	call myviewchangeboxcolor
; 22         MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 23         HelpFooterViewShowStr();
	call helpfooterviewshowstr
	pop de
	pop hl
	pop bc
	ret
; 24     }
; 25 }
; 26 
; 27 void HelpFooterViewShowStr() {
helpfooterviewshowstr:
; 28     l = (a = HelpFooterViewX);
	ld a, (helpfooterviewx)
	ld l, a
; 29     l++;
	inc l
; 30     h = (a = HelpFooterViewY);
	ld a, (helpfooterviewy)
	ld h, a
; 31     h++;
	inc h
; 32     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 33     
; 34     bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF1);
	ld a, 2
	ld hl, helpfooterviewtitlef1
	call bios
; 35     
; 36     MyFuncPosXAddA(a = 5);
	ld a, 5
	call myfuncposxadda
; 37     bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF2);
	ld a, 2
	ld hl, helpfooterviewtitlef2
	call bios
; 38     
; 39     MyFuncPosXAddA(a = 5);
	ld a, 5
	call myfuncposxadda
; 40     bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF3);
	ld a, 2
	ld hl, helpfooterviewtitlef3
	call bios
; 41     
; 42     MyFuncPosXAddA(a = 5);
	ld a, 5
	call myfuncposxadda
; 43     bios(a = biosPrintMessageHL, hl = HelpFooterViewTitleF4);
	ld a, 2
	ld hl, helpfooterviewtitlef4
	jp bios
; 44 }
; 45 
; 46 uint8_t HelpFooterViewX = 0;
helpfooterviewx:
	db 0
; 47 uint8_t HelpFooterViewY = 29;
helpfooterviewy:
	db 29
; 48 uint8_t HelpFooterViewDX = 48;
helpfooterviewdx:
	db 48
; 49 uint8_t HelpFooterViewDY = 3;
helpfooterviewdy:
	db 3
; 53 uint8_t HelpFooterViewColor = 0x5f; //0x67;
helpfooterviewcolor:
	db 95
; 56 uint8_t HelpFooterViewTitleF1[] = "F1: ..";
helpfooterviewtitlef1:
	db 70
	db 49
	db 58
	db 32
	db 46
	db 46
	ds 1
; 57 uint8_t HelpFooterViewTitleF2[] = "F2: Wi-Fi";
helpfooterviewtitlef2:
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
; 58 uint8_t HelpFooterViewTitleF3[] = "F3: FTP ";
helpfooterviewtitlef3:
	db 70
	db 51
	db 58
	db 32
	db 70
	db 84
	db 80
	db 32
	ds 1
; 59 uint8_t HelpFooterViewTitleF4[] = "F4: Quit";
helpfooterviewtitlef4:
	db 70
	db 52
	db 58
	db 32
	db 81
	db 117
	db 105
	db 116
	ds 1
; 11 void FtpViewShow() {
ftpviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 14         c = (a = FtpViewColor);
	ld a, (ftpviewcolor)
	ld c, a
; 15         l = (a = FtpViewX);
	ld a, (ftpviewx)
	ld l, a
; 16         h = (a = FtpViewY);
	ld a, (ftpviewy)
	ld h, a
; 17         e = (a = FtpViewDX);
	ld a, (ftpviewdx)
	ld e, a
; 18         d = (a = FtpViewDY);
	ld a, (ftpviewdy)
	ld d, a
; 19         bios(a = biosWindowOpen);
	ld a, 85
	call bios
; 20         MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 21         FtpViewShowTitle();
	call ftpviewshowtitle
; 22         
; 23         #ifdef _IS_SIMULATOR
; 24             FtpViewShowFileList();
; 25             FtpViewShowPath();
; 26             FtpViewFileCurrentPos = (a = 0);
; 27             FtpViewShowSelectLineA(a = 1);
; 28         #else
; 29             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	pop de
	pop hl
	pop bc
	ret
; 30         #endif
; 31     }
; 32 }
; 33 
; 34 void FtpViewShowTitle() {
ftpviewshowtitle:
; 35     a = FtpViewX;
	ld a, (ftpviewx)
; 36     a++;
	inc a
; 37     l = a;
	ld l, a
; 38     h = (a = FtpViewY);
	ld a, (ftpviewy)
	ld h, a
; 39     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 40     bios(a = biosPrintMessageHL, hl = FtpViewTitle);
	ld a, 2
	ld hl, ftpviewtitle
	jp bios
; 41 }
; 42 
; 43 /// Рисование линии прямым или инверсным цветом
; 44 /// 0 - прямой
; 45 /// 1 - инверсный
; 46 void FtpViewShowSelectLineA() {
ftpviewshowselectlinea:
; 47     push_pop(bc) {
	push bc
; 48         c = a;
	ld c, a
; 49         // HL
; 50         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 51         b = a;
	ld b, a
; 52         a = FtpViewY;
	ld a, (ftpviewy)
; 53         a += 2;
	add 2
; 54         a += b;
	add b
; 55         h = a;
	ld h, a
; 56         a = FtpViewX;
	ld a, (ftpviewx)
; 57         a += 1;
	add 1
; 58         l = a;
	ld l, a
; 59         // DE
; 60         a = FtpViewDX;
	ld a, (ftpviewdx)
; 61         a -= 2;
	sub 2
; 62         e = a;
	ld e, a
; 63         a = 1;
	ld a, 1
; 64         d = a;
	ld d, a
; 65         // C
; 66         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_187
; 67             a = FtpViewColor;
	ld a, (ftpviewcolor)
	jp __l_188
__l_187:
; 68         } else {
; 69             a = FtpViewInvColor;
	ld a, (ftpviewinvcolor)
__l_188:
; 70         }
; 71         c = a;
	ld c, a
; 72         // A
; 73         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop bc
	ret
; 74     }
; 75 }
; 76 
; 77 void FtpViewShowPath() {
ftpviewshowpath:
; 78     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 79         bios(c = (a = FtpViewColor), a = biosSetColorC);
	ld a, (ftpviewcolor)
	ld c, a
	ld a, 18
	call bios
; 80         //--
; 81         a = FtpViewX;
	ld a, (ftpviewx)
; 82         b = a;
	ld b, a
; 83         a = FtpViewDX;
	ld a, (ftpviewdx)
; 84         a += b;
	add b
; 85         a -= 19;
	sub 19
; 86         l = a;
	ld l, a
; 87         h = (a = FtpViewY);
	ld a, (ftpviewy)
	ld h, a
; 88         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 89         de = FtpViewPath;
	ld de, ftpviewpath
; 90         bios(a = biosPrintC, c = 0x82);
	ld a, 0
	ld c, 130
	call bios
; 91         b = 16;
	ld b, 16
; 92         c = 0;
	ld c, 0
; 93         do {
__l_189:
; 94             a = *de;
	ld a, (de)
; 95             de++;
	inc de
; 96             if (a == 0) {
	or a
	jp nz, __l_192
; 97                 c = 1;
	ld c, 1
__l_192:
; 98             }
; 99             h = a;
	ld h, a
; 100             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_194
; 101                 push_pop(bc) {
	push bc
; 102                     bios(a = biosPrintC, c = h);
	ld a, 0
	ld c, h
	call bios
	pop bc
	jp __l_195
__l_194:
; 103                 }
; 104             } else {
; 105                 push_pop(bc) {
	push bc
; 106                     bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
	pop bc
__l_195:
; 107                 }
; 108             }
; 109             b--;
	dec b
__l_190:
; 110         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_189
; 111         bios(a = biosPrintC, c = 0x92);
	ld a, 0
	ld c, 146
	call bios
	pop hl
	pop de
	pop bc
	ret
; 112     }
; 113 }
; 114 
; 115 void FtpViewShowFileList() {
ftpviewshowfilelist:
; 116     //-- нельзя обновлять, если есть хоть какое то открытое окно
; 117     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 118     if (a == 0) {
	or a
	jp nz, __l_196
; 119         return;
	ret
__l_196:
; 120     }
; 121     //--
; 122     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 123         bios(c = (a = FtpViewColor), a = biosSetColorC);
	ld a, (ftpviewcolor)
	ld c, a
	ld a, 18
	call bios
; 124         // Заполнить пустыми строками
; 125         a = FtpViewX;
	ld a, (ftpviewx)
; 126         a += 1;
	add 1
; 127         d = a; // X
	ld d, a
; 128         a = FtpViewY;
	ld a, (ftpviewy)
; 129         a += 2;
	add 2
; 130         e = a; // Y
	ld e, a
; 131         //
; 132         a = FtpViewDY;
	ld a, (ftpviewdy)
; 133         a -= 4;
	sub 4
; 134         b = a;
	ld b, a
; 135         c = 0;
	ld c, 0
; 136         do {
__l_198:
; 137             a = e;
	ld a, e
; 138             a += c;
	add c
; 139             push_pop(hl) {
	push hl
; 140                 bios(l = d, h = a, a = biosSetPositionCursoreHL);
	ld l, d
	ld h, a
	ld a, 28
	call bios
	pop hl
; 141             }
; 142             //
; 143             a = FtpViewDX;
	ld a, (ftpviewdx)
; 144             a -= 2;
	sub 2
; 145             h = a;
	ld h, a
; 146             do {
__l_201:
; 147                 push_pop(bc) {
	push bc
; 148                     bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
	pop bc
; 149                 }
; 150                 h--;
	dec h
__l_202:
; 151             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, __l_201
; 152             b--;
	dec b
; 153             c++;
	inc c
__l_199:
; 154         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_198
; 155         //--
; 156         b = 0;
	ld b, 0
; 157         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 158         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 159         c = a;
	ld c, a
; 160         do {
__l_204:
; 161             push_pop(hl) {
	push hl
; 162                 a = FtpViewY;
	ld a, (ftpviewy)
; 163                 a += 2;
	add 2
; 164                 a += b;
	add b
; 165                 h = a;
	ld h, a
; 166                 a = FtpViewX;
	ld a, (ftpviewx)
; 167                 a += 2;
	add 2
; 168                 l = a;
	ld l, a
; 169                 bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 170             }
; 171             FtpViewShowFileHL();
	call ftpviewshowfilehl
; 172             // HL + 16 next file
; 173             a ^= a;
	xor a
; 174             a = 16;
	ld a, 16
; 175             a += l;
	add l
; 176             l = a;
	ld l, a
; 177             if (flag_c) {
	jp nc, __l_207
; 178                 h++;
	inc h
__l_207:
; 179             }
; 180             b++;
	inc b
__l_205:
; 181         } while ((a = b) < c);
	ld a, b
	cp c
	jp c, __l_204
	pop hl
	pop de
	pop bc
	ret
; 182     }
; 183 }
; 184 
; 185 void FtpViewShowFileHL() {
ftpviewshowfilehl:
; 186     push_pop(bc, hl) {
	push bc
	push hl
; 187         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_209
; 188             FtpViewShowFileName();
	call ftpviewshowfilename
	jp __l_210
__l_209:
; 189         } else {
; 190             FtpViewShowFileName();
	call ftpviewshowfilename
; 191             FtpViewShowFileSize();
	call ftpviewshowfilesize
; 192             FtpViewShowFileDate();
	call ftpviewshowfiledate
__l_210:
	pop hl
	pop bc
	ret
; 193         }
; 194     }
; 195 }
; 196 
; 197 void FtpViewShowFileName() {
ftpviewshowfilename:
; 198     push_pop(bc) {
	push bc
; 199         // X pos
; 200         //    a = FtpViewX;
; 201         //    a += 2;
; 202         //    myCharPosX = a;
; 203         //
; 204         b = 8;
	ld b, 8
; 205         do {
__l_211:
; 206             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 207             hl++;
	inc hl
; 208             b--;
	dec b
__l_212:
; 209         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_211
	pop bc
	ret
; 210     }
; 211 }
; 212 
; 213 void FtpViewShowFileSize() {
ftpviewshowfilesize:
; 214     push_pop(bc, de) {
	push bc
	push de
; 215         // X pos
; 216         push_pop(hl) {
	push hl
; 217             bios(a = biosGetPositionCursoreHL);
	ld a, 29
	call bios
; 218             a = FtpViewX;
	ld a, (ftpviewx)
; 219             a += 11;
	add 11
; 220             l = a;
	ld l, a
; 221             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 222         }
; 223         //
; 224         a = *hl;
	ld a, (hl)
; 225         d = a;
	ld d, a
; 226         hl++;
	inc hl
; 227         a = *hl;
	ld a, (hl)
; 228         e = a;
	ld e, a
; 229         hl++;
	inc hl
; 230         a = *hl;
	ld a, (hl)
; 231         hl++;
	inc hl
; 232         a &= 0x01;
	and 1
; 233         if (a == 0x00) {
	or a
	jp nz, __l_214
; 234             push_pop(hl) {
	push hl
; 235                 h = 0; // файл для Орион
	ld h, 0
; 236                 if ((a = d) == 0xFF) {
	ld a, d
	cp 255
	jp nz, __l_216
; 237                     if ((a = e) == 0xFF) {
	ld a, e
	cp 255
	jp nz, __l_218
; 238                         h = 1; // Файл слишком большой для Орион
	ld h, 1
__l_218:
__l_216:
; 239                     }
; 240                 }
; 241                 if ((a = h) == 0) { // Показываем размер
	ld a, h
	or a
	jp nz, __l_220
; 242                     FtpViewShow4CharSizeDE();
	call ftpviewshow4charsizede
	jp __l_221
__l_220:
; 243                 } else { // Файл слишком большой
; 244                     bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 245                     bios(a = biosPrintC, c = 'B');
	ld a, 0
	ld c, 66
	call bios
; 246                     bios(a = biosPrintC, c = 'I');
	ld a, 0
	ld c, 73
	call bios
; 247                     bios(a = biosPrintC, c = 'G');
	ld a, 0
	ld c, 71
	call bios
__l_221:
	pop hl
; 248                 }
; 249             }
; 250             FtpViewShowIsDirA(a = 0);
	ld a, 0
	call ftpviewshowisdira
	jp __l_215
__l_214:
; 251         } else {
; 252             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 253             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 254             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 255             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 256             FtpViewShowIsDirA(a = 1);
	ld a, 1
	call ftpviewshowisdira
__l_215:
	pop de
	pop bc
	ret
; 257         }
; 258     }
; 259 }
; 260 
; 261 void FtpViewShow4CharSizeDE() {
ftpviewshow4charsizede:
; 262     push_pop(hl, bc) {
	push hl
	push bc
; 263         MyFunc4CharSizeDE();
	call myfunc4charsizede
; 264         hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 265         b = 4;
	ld b, 4
; 266         do {
__l_222:
; 267             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 268             hl++;
	inc hl
; 269             b--;
	dec b
__l_223:
; 270         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_222
	pop bc
	pop hl
	ret
; 271     }
; 272 }
; 273 
; 274 // A = 1 - Dir
; 275 void FtpViewShowIsDirA() {
ftpviewshowisdira:
; 276     push_pop(bc) {
	push bc
; 277         a &= 0x01;
	and 1
; 278         b = a;
	ld b, a
; 279         push_pop(hl) {
	push hl
; 280             bios(a = biosGetPositionCursoreHL);
	ld a, 29
	call bios
; 281             a = FtpViewX;
	ld a, (ftpviewx)
; 282             a += 1;
	add 1
; 283             l = a;
	ld l, a
; 284             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 285         }
; 286         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_225
; 287             bios(a = biosPrintC, c = 0xB3);
	ld a, 0
	ld c, 179
	call bios
	jp __l_226
__l_225:
; 288         } else {
; 289             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
__l_226:
	pop bc
	ret
; 290         }
; 291     }
; 292 }
; 293 
; 294 void FtpViewShowFileDate() {
ftpviewshowfiledate:
; 295     push_pop(bc, de) {
	push bc
	push de
; 296         // X pos
; 297         push_pop(hl) {
	push hl
; 298             bios(a = biosGetPositionCursoreHL);
	ld a, 29
	call bios
; 299             a = FtpViewX;
	ld a, (ftpviewx)
; 300             a += 16;
	add 16
; 301             l = a;
	ld l, a
; 302             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 303         }
; 304         //-- GGGG
; 305         d = *hl;
	ld d, (hl)
; 306         hl++;
	inc hl
; 307         e = *hl;
	ld e, (hl)
; 308         hl++;
	inc hl
; 309         push_pop(hl) {
	push hl
; 310             h = d;
	ld h, d
; 311             l = e;
	ld l, e
; 312             bios(a = biosPrintWordHL, b = 0x01);
	ld a, 5
	ld b, 1
	call bios
	pop hl
; 313         }
; 314         //--
; 315         bios(a = biosPrintC, c = '-');
	ld a, 0
	ld c, 45
	call bios
; 316         //--
; 317         push_pop(hl, bc) {
	push hl
	push bc
; 318             a = *hl;
	ld a, (hl)
; 319             hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 320             MyFuncDec099A();
	call myfuncdec099a
; 321             hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 322             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 323             hl++;
	inc hl
; 324             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
	pop bc
	pop hl
; 325         }
; 326         hl++;
	inc hl
; 327         //--
; 328         bios(a = biosPrintC, c = '-');
	ld a, 0
	ld c, 45
	call bios
; 329         //--
; 330         push_pop(hl, bc) {
	push hl
	push bc
; 331             a = *hl;
	ld a, (hl)
; 332             hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 333             MyFuncDec099A();
	call myfuncdec099a
; 334             hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 335             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 336             hl++;
	inc hl
; 337             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
	pop bc
	pop hl
; 338         }
; 339         hl++;
	inc hl
	pop de
	pop bc
	ret
; 340     }
; 341 }
; 342 
; 343 /// Обновление позиции
; 344 /// вх[A]
; 345 /// 0 - без изменений
; 346 /// 1 - вверх
; 347 /// 0xFF - вниз
; 348 void FtpViewFileCurrentPosUpdateA() {
ftpviewfilecurrentposupdatea:
; 349     push_pop(bc) {
	push bc
; 350         b = a;
	ld b, a
; 351         if (a == 0) {
	or a
	jp nz, __l_227
; 352             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
	jp __l_228
__l_227:
; 353         } else {
; 354             a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 355             c = a;
	ld c, a
; 356             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 357             a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 358             a += b;
	add b
; 359             //
; 360             if (a == 0xFF) {
	cp 255
	jp nz, __l_229
; 361                 a = c;
	ld a, c
; 362                 a--;
	dec a
	jp __l_230
__l_229:
; 363             } else if (a == c) {
	cp c
	jp nz, __l_231
; 364                 a = 0;
	ld a, 0
__l_231:
__l_230:
; 365             }
; 366             FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 367             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_228:
	pop bc
	ret
; 368         }
; 369     }
; 370 }
; 371 
; 372 void FtpViewNetLoadAndUpdate() {
ftpviewnetloadandupdate:
; 373     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 374     NetSetIsDsDos();
	call netsetisdsdos
; 375     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 376     if ((a = FtpHeaderViewStatus) == 1) {
	ld a, (ftpheaderviewstatus)
	cp 1
	jp nz, __l_233
; 377         NetSetIsDsDos();
	call netsetisdsdos
; 378         NetFtpUpdateList();
	call netftpupdatelist
; 379         NetFtpListFiles();
	call netftplistfiles
__l_233:
; 380     }
; 381     a = 0;
	ld a, 0
; 382     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 383     FtpViewShowFileList();
	call ftpviewshowfilelist
; 384     FtpViewShowPath();
	call ftpviewshowpath
; 385     // Показываем курсор, если выбран FTP
; 386     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_235
; 387         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_235:
	ret
; 388     }
; 389 }
; 390 
; 391 void FtpViewGetFileNamePointByPosToHL() {
ftpviewgetfilenamepointbypostohl:
; 392     push_pop(bc) {
	push bc
; 393         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 394         //--
; 395         a ^= a;
	xor a
; 396         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 397         a &= 0x3F;
	and 63
; 398         b = 0;
	ld b, 0
; 399         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 400         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_237
; 401             b++;
	inc b
__l_237:
; 402         }
; 403         c = a;
	ld c, a
; 404         //-- Смещаем на позицию файла
; 405         hl += bc;
	add hl, bc
	pop bc
	ret
; 406     }
; 407 }
; 408 
; 409 void FtpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 410     push_pop(hl, bc) {
	push hl
	push bc
; 411         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 412         //--
; 413         a ^= a;
	xor a
; 414         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 415         a &= 0x3F;
	and 63
; 416         b = 0;
	ld b, 0
; 417         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 418         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_239
; 419             b++;
	inc b
__l_239:
; 420         }
; 421         c = a;
	ld c, a
; 422         //-- Смещаем на позицию файла
; 423         hl += bc;
	add hl, bc
; 424         //-- Смещаем на признак директории
; 425         bc = 10;
	ld bc, 10
; 426         hl += bc;
	add hl, bc
; 427         //--
; 428         a = *hl;
	ld a, (hl)
; 429         a &= 0x01;
	and 1
	pop bc
	pop hl
	ret
; 430     }
; 431 }
; 432 
; 433 void FtpViewEmptyList() {
ftpviewemptylist:
; 434     push_pop(hl) {
	push hl
; 435         a = 1;
	ld a, 1
; 436         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 437         a = 0;
	ld a, 0
; 438         FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 439         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 440         //--
; 441         *hl = '.';
	ld (hl), 46
; 442         hl++;
	inc hl
; 443         *hl = '.';
	ld (hl), 46
; 444         hl++;
	inc hl
; 445         //--
; 446         *hl = ' ';
	ld (hl), 32
; 447         hl++;
	inc hl
; 448         *hl = ' ';
	ld (hl), 32
; 449         hl++;
	inc hl
; 450         *hl = ' ';
	ld (hl), 32
; 451         hl++;
	inc hl
; 452         *hl = ' ';
	ld (hl), 32
; 453         hl++;
	inc hl
; 454         *hl = ' ';
	ld (hl), 32
; 455         hl++;
	inc hl
; 456         *hl = ' ';
	ld (hl), 32
; 457         hl++;
	inc hl
	pop hl
; 458     }
; 459     //--
; 460     FtpViewListUpdateUI();
; 461 }
; 462 
; 463 void FtpViewListUpdateUI() {
ftpviewlistupdateui:
; 464     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 465     a = 0;
	ld a, 0
; 466     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 467     FtpViewShowPath();
	call ftpviewshowpath
; 468     FtpViewShowFileList();
	call ftpviewshowfilelist
; 469     if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_241
; 470         FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
__l_241:
	ret
; 471     }
; 472 }
; 473 
; 474 void FtpViewAccessDiskSpace() {
ftpviewaccessdiskspace:
; 475     push_pop(de, hl) {
	push de
	push hl
; 476         // Находим указатель на файл
; 477         d = 0;
	ld d, 0
; 478         a ^= a;
	xor a
; 479         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 480         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 481         e = a;
	ld e, a
; 482         if (flag_c) {
	jp nc, __l_243
; 483             d = 1;
	ld d, 1
__l_243:
; 484         }
; 485         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 486         hl += de;
	add hl, de
; 487         // Сдвигаем к размеру файла и читаем размер
; 488         de = 8;
	ld de, 8
; 489         hl += de;
	add hl, de
; 490         //
; 491         a = *hl;
	ld a, (hl)
; 492         d = a;
	ld d, a
; 493         hl++;
	inc hl
; 494         a = *hl;
	ld a, (hl)
; 495         e = a;
	ld e, a
; 496         //
; 497         DiskViewIsDiskSpaceDE();
	call diskviewisdiskspacede
; 498         if (a == 1) {
	cp 1
	jp nz, __l_245
; 499             FtpViewLoadFile();
	call ftpviewloadfile
	jp __l_246
__l_245:
; 500         } else {
; 501             AllertOkViewShowHL(hl = StringLocaleDiskFull);
	ld hl, stringlocalediskfull
	call allertokviewshowhl
__l_246:
	pop hl
	pop de
	ret
; 502         }
; 503     }
; 504 }
; 505 
; 506 void FtpViewLoadFile() {
ftpviewloadfile:
; 507     StringLocaleCreateLoadTitleA();
	call stringlocalecreateloadtitlea
; 508     //--
; 509     LoadViewShowHL(hl = LoadViewLoadTitle);
	ld hl, loadviewloadtitle
	call loadviewshowhl
; 510     #ifdef _IS_SIMULATOR
; 511         push_pop(bc) {
; 512             b = 0;
; 513             do {
; 514                 LoadViewShowProgressA(a = b);
; 515                 c = 1;
; 516                 do {
; 517                     delay50ms();
; 518                     c--;
; 519                 } while ((a = c) > 0);
; 520                 b++;
; 521             } while ((a = b) < 40);
; 522             //--
; 523             push_pop(bc, de, hl) {
; 524                 hl = MockFileData;
; 525                 de = Net_buffer;
; 526                 b = 77;
; 527                 do {
; 528                     *de = (a = *hl);
; 529                     de++;
; 530                     hl++;
; 531                     b--;
; 532                 } while ((a = b) > 0);
; 533                 Net_buffer_len = (a = 77);
; 534                 l = 77;
; 535                 FileParserFtpLoadFileNextParse();
; 536             }
; 537             //--
; 538             LoadViewClose();
; 539             DiskViewUpdateDateAndUI();
; 540         }
; 541     #else
; 542         FtpViewNeedLoad();
	call ftpviewneedload
; 543         LoadViewClose();
	call loadviewclose
; 544         DiskViewUpdateDateAndUI();
	jp diskviewupdatedateandui
; 545     #endif
; 546 }
; 547 
; 548 void FtpViewNeedLoad() {
ftpviewneedload:
; 549     NetFtpLoadFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftploadfilea
; 550     NetFtpLoadFileNext();
	jp netftploadfilenext
; 551 }
; 552 
; 553 void FtpViewKeyA() {
ftpviewkeya:
; 554     push_pop(hl) {
	push hl
; 555         l = a;
	ld l, a
; 556         if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_247
; 557             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, __l_249
; 558                 CurrentViewChangeIdA(a = DiskViewId);
	ld a, 1
	call currentviewchangeida
	jp __l_250
__l_249:
; 559             } else if ((a = l) == 0x18) { //0x18 Вправо
	ld a, l
	cp 24
	jp nz, __l_251
; 560                 CurrentViewChangeIdA(a = DiskViewId);
	ld a, 1
	call currentviewchangeida
	jp __l_252
__l_251:
; 561             } else {
; 562                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_253
; 563                     FtpViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call ftpviewfilecurrentposupdatea
	jp __l_254
__l_253:
; 564                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_255
; 565                     FtpViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpviewfilecurrentposupdatea
	jp __l_256
__l_255:
; 566                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, __l_257
; 567                     if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
	ld a, (ftpviewfilecurrentpos)
	or a
	jp nz, __l_259
; 568                         #ifdef _IS_SIMULATOR
; 569 
; 570                         #else
; 571                             NetFtpChangeDirUp();
	call netftpchangedirup
; 572                             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_260
__l_259:
; 573                         #endif
; 574                     } else {
; 575                         FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 576                         if (a == 1) { // Enter Dir
	cp 1
	jp nz, __l_261
; 577                             #ifdef _IS_SIMULATOR
; 578 
; 579                             #else
; 580                                 FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
	ld a, 0
	call ftpviewshowselectlinea
; 581                                 NetFtpChangeDirIndexA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call netftpchangedirindexa
; 582                                 FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_262
__l_261:
; 583                             #endif
; 584                         } else { // Load file
; 585                             FtpViewAccessDiskSpace();
	call ftpviewaccessdiskspace
__l_262:
__l_260:
	jp __l_258
__l_257:
; 586                         }
; 587                     }
; 588                 } else if ((a = l) == 'R') { // Обновление папки
	ld a, l
	cp 82
	jp nz, __l_263
; 589                     FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp __l_264
__l_263:
; 590                 } else if ((a = l) == 'C') { // загрузка файла
	ld a, l
	cp 67
	jp nz, __l_265
; 591                     FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 592                     if (a == 0) { // Проверим что это файл
	or a
	jp nz, __l_267
; 593                         FtpViewAccessDiskSpace();
	call ftpviewaccessdiskspace
__l_267:
	jp __l_266
__l_265:
; 594                     }
; 595                 } else if ((a = l) == 'H') { // Перейти в домашную папку
	ld a, l
	cp 72
	jp nz, __l_269
; 596                     ThreadsNetFtpGoToHomeDir();
	call threadsnetftpgotohomedir
	jp __l_270
__l_269:
; 597                 } else if ((a = l) == 'E') { // Удалить файл
	ld a, l
	cp 69
	jp nz, __l_271
; 598                     if ((a = FtpViewFileCurrentPos) > 0) {
	ld a, (ftpviewfilecurrentpos)
	or a
	jp z, __l_273
; 599                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 600                         if (a == 1) {
	cp 1
	jp nz, __l_275
; 601                             #ifdef _IS_SIMULATOR
; 602 
; 603                             #else
; 604                                 ThreadsNetFtpDeleteFileA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call threadsnetftpdeletefilea
__l_275:
__l_273:
	jp __l_272
__l_271:
; 605                             #endif
; 606                         }
; 607                     }
; 608                 } else if ((a = l) == 'D') { // Создание новой папки
	ld a, l
	cp 68
	jp nz, __l_277
__l_277:
__l_272:
__l_270:
__l_266:
__l_264:
__l_258:
__l_256:
__l_254:
__l_252:
__l_250:
__l_247:
	pop hl
	ret
; 609                     #ifdef _IS_SIMULATOR
; 610 
; 611                     #else
; 612                         //FtpMakeDirectoryShow()
; 613                     #endif
; 614                 }
; 615             }
; 616         }
; 617     }
; 618 }
; 619 
; 620 
; 621 uint8_t FtpViewX = 0;
ftpviewx:
	db 0
; 622 uint8_t FtpViewY = 4;
ftpviewy:
	db 4
; 623 uint8_t FtpViewDX = 28;
ftpviewdx:
	db 28
; 624 uint8_t FtpViewDY = 25;
ftpviewdy:
	db 25
; 625 uint8_t FtpViewColor = 0x1F;
ftpviewcolor:
	db 31
; 626 uint8_t FtpViewInvColor = 0xF1;
ftpviewinvcolor:
	db 241
; 628 uint8_t FtpViewTitle[] = {0x82, 'F', 'T', 'P', 0x92, '\0'};
ftpviewtitle:
	db 130
	db 70
	db 84
	db 80
	db 146
	db 0
; 629 uint8_t FtpViewPath[16] = "/";
ftpviewpath:
	db 47
	ds 15
; 631 uint8_t FtpViewFileCurrentPos = 0;
ftpviewfilecurrentpos:
	db 0
; 645 uint8_t FtpViewFilesListCount = 1;
ftpviewfileslistcount:
	db 1
; 646 uint8_t FtpViewFilesList[16 * 23] = {
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
; 11 void DiskViewStart() {
diskviewstart:
; 12     DiskViewSetDiskNumA(a = 'A');
	ld a, 65
	call diskviewsetdisknuma
; 13     //DiskViewReload();
; 14     DiskViewShow();
; 15 }
; 16 
; 17 void DiskViewShow() {
diskviewshow:
; 18     c = (a = DiskViewColor);
	ld a, (diskviewcolor)
	ld c, a
; 19     l = (a = DiskViewX);
	ld a, (diskviewx)
	ld l, a
; 20     h = (a = DiskViewY);
	ld a, (diskviewy)
	ld h, a
; 21     e = (a = DiskViewDX);
	ld a, (diskviewdx)
	ld e, a
; 22     d = (a = DiskViewDY);
	ld a, (diskviewdy)
	ld d, a
; 23     b = MyViewByteFrame;
	ld b, 2
; 24     MyViewShow();
	call myviewshow
; 25     DiskViewShowTitle();
	call diskviewshowtitle
; 26     DiskViewUpdateDiskTitle();
	call diskviewupdatedisktitle
; 27     DiskViewReload();
	jp diskviewreload
; 28 }
; 29 
; 30 void DiskViewShowTitle() {
diskviewshowtitle:
; 31     a = DiskViewX;
	ld a, (diskviewx)
; 32     a++;
	inc a
; 33     l = a;
	ld l, a
; 34     h = (a = DiskViewY);
	ld a, (diskviewy)
	ld h, a
; 35     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 36     bios(a = biosPrintMessageHL, hl = DiskViewTitle);
	ld a, 2
	ld hl, diskviewtitle
	jp bios
; 37 }
; 38 
; 39 void DiskViewSetDiskNumA() {
diskviewsetdisknuma:
; 40     push_pop(bc, de) {
	push bc
	push de
; 41         b = a;
	ld b, a
; 42         bios(a = biosGetDiskC);
	ld a, 132
	call bios
; 43         if ((a = b) != c) {
	ld a, b
	cp c
	jp z, __l_279
; 44             d = c;
	ld d, c
; 45             bios(a = biosSetDiskC, c = b);
	ld a, 131
	ld c, b
	call bios
; 46             if (flag_c) {
	jp nc, __l_281
	jp __l_282
__l_281:
; 47 
; 48             } else {
; 49                 #ifdef _IS_SIMULATOR
; 50                     
; 51                 #else
; 52                     NetDiskSetNum();
	call netdisksetnum
; 53                 #endif
; 54                 DiskViewReload();
	call diskviewreload
__l_282:
__l_279:
	pop de
	pop bc
	ret
; 55             }
; 56         }
; 57     }
; 58 }
; 59 
; 60 void DiskViewReload() {
diskviewreload:
; 61     DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 62     a = 0;
	ld a, 0
; 63     DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
; 64     DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 65     DiskViewUpdateDiskTitle();
	call diskviewupdatedisktitle
; 66     DiskViewUpdateDateAndUI();
	jp diskviewupdatedateandui
; 67 }
; 68 
; 69 void DiskViewUpdateDiskTitle() {
diskviewupdatedisktitle:
; 70     push_pop(hl, bc) {
	push hl
	push bc
; 71         bios(c = (a = DiskViewColor), a = biosSetColorC);
	ld a, (diskviewcolor)
	ld c, a
	ld a, 18
	call bios
; 72         a = DiskViewX;
	ld a, (diskviewx)
; 73         a += 7;
	add 7
; 74         l = a;
	ld l, a
; 75         h = (a = DiskViewY);
	ld a, (diskviewy)
	ld h, a
; 76         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 77         bios(a = biosGetDiskC);
	ld a, 132
	call bios
; 78         bios(a = biosPrintC);
	ld a, 0
	call bios
	pop bc
	pop hl
	ret
; 79     }
; 80 }
; 81 
; 82 void DiskViewUpdateDateAndUI() {
diskviewupdatedateandui:
; 83     DiskViewUpdateDir();
	call diskviewupdatedir
; 84     DiskViewShowDir();
	call diskviewshowdir
; 85     if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_283
; 86         DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
__l_283:
; 87     }
; 88     DiskViewShowFreeSpace();
; 89 }
; 90 
; 91 void DiskViewShowFreeSpace() {
diskviewshowfreespace:
; 92     push_pop(de, hl, bc) {
	push de
	push hl
	push bc
; 93         a = DiskViewX;
	ld a, (diskviewx)
; 94         e = a;
	ld e, a
; 95         a = DiskViewDX;
	ld a, (diskviewdx)
; 96         a += e;
	add e
; 97         a -= 7;
	sub 7
; 98         l = a;
	ld l, a
; 99         a = DiskViewY;
	ld a, (diskviewy)
; 100         e = a;
	ld e, a
; 101         a = DiskViewDY;
	ld a, (diskviewdy)
; 102         a += e;
	add e
; 103         a--;
	dec a
; 104         h = a;
	ld h, a
; 105         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 106         //-- 0x82
; 107         bios(a = biosPrintC, c = 0x82);
	ld a, 0
	ld c, 130
	call bios
; 108         //--
; 109         bios(a = biosUpdateInfoDisk);
	ld a, 144
	call bios
; 110         bios(a = biosGetInfoDisk, c = 0x01);
	ld a, 147
	ld c, 1
	call bios
; 111         d = h;
	ld d, h
; 112         e = l;
	ld e, l
; 113         MyFunc4CharSizeDE();
	call myfunc4charsizede
; 114         //--
; 115         hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 116         b = 4;
	ld b, 4
; 117         do {
__l_285:
; 118             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 119             hl++;
	inc hl
; 120             b--;
	dec b
__l_286:
; 121         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_285
; 122         //-- 0x92
; 123         bios(a = biosPrintC, c = 0x92);
	ld a, 0
	ld c, 146
	call bios
	pop bc
	pop hl
	pop de
	ret
; 124     }
; 125 }
; 126 
; 127 void DiskViewUpdateDir() {
diskviewupdatedir:
; 128     push_pop(hl, bc) {
	push hl
	push bc
; 129         //[C] – номер первого
; 130         c = (a = DiskViewDirStartIndex);
	ld a, (diskviewdirstartindex)
	ld c, a
; 131         c++;
	inc c
; 132         //[B] – max кол-во
; 133         b = (a = DiskViewDirPageCoint);
	ld a, (diskviewdirpagecoint)
	ld b, a
; 134         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 135         bios(a = biosUpdateDirHL);
	ld a, 141
	call bios
; 136         if (flag_c) {
	jp nc, __l_288
; 137             a = 0;
	ld a, 0
; 138             DiskViewDirCount = a;
	ld (diskviewdircount), a
	jp __l_289
__l_288:
; 139         } else {
; 140             DiskViewDirCount = a;
	ld (diskviewdircount), a
__l_289:
	pop bc
	pop hl
	ret
; 141         }
; 142     }
; 143 }
; 144 
; 145 void DiskViewShowFileSizeHL() {
diskviewshowfilesizehl:
; 146     e = (a = *hl);
	ld a, (hl)
	ld e, a
; 147     hl++;
	inc hl
; 148     d = (a = *hl);
	ld a, (hl)
	ld d, a
; 149     hl++;
	inc hl
; 150     MyFunc4CharSizeDE();
	call myfunc4charsizede
; 151     //--
; 152     push_pop(bc, hl) {
	push bc
	push hl
; 153         // Отступ
; 154         b = 4;
	ld b, 4
; 155         do {
__l_290:
; 156             bios(c = ' ', a = biosPrintC);
	ld c, 32
	ld a, 0
	call bios
; 157             b--;
	dec b
__l_291:
; 158         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_290
; 159         //--
; 160         hl = MyFunc4Chars;
	ld hl, myfunc4chars
; 161         b = 4;
	ld b, 4
; 162         do {
__l_293:
; 163             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 164             hl++;
	inc hl
; 165             b--;
	dec b
__l_294:
; 166         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_293
	pop hl
	pop bc
	ret
; 167     }
; 168 }
; 169 
; 170 void DiskViewShowFileNameHL() {
diskviewshowfilenamehl:
; 171     push_pop(bc) {
	push bc
; 172         b = 8;
	ld b, 8
; 173         do {
__l_296:
; 174             bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
; 175             //--
; 176             hl++;
	inc hl
; 177             b--;
	dec b
__l_297:
; 178         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_296
	pop bc
	ret
; 179     }
; 180 }
; 181 
; 182 void DiskViewShowFilePosB() {
diskviewshowfileposb:
; 183     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 184         h = 0;
	ld h, 0
; 185         l = b;
	ld l, b
; 186         hl <<= 4;
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
; 187         d = h;
	ld d, h
; 188         e = l;
	ld e, l
; 189         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 190         hl += de;
	add hl, de
; 191         //--
; 192         DiskViewShowFileNameHL();
	call diskviewshowfilenamehl
; 193         hl++;
	inc hl
; 194         hl++;
	inc hl
; 195         DiskViewShowFileSizeHL();
	call diskviewshowfilesizehl
	pop bc
	pop de
	pop hl
	ret
; 196     }
; 197 }
; 198 
; 199 void DiskViewShowEmptyFile() {
diskviewshowemptyfile:
; 200     push_pop(bc) {
	push bc
; 201         a = DiskViewDX;
	ld a, (diskviewdx)
; 202         a -= 4;
	sub 4
; 203         b = a;
	ld b, a
; 204         do {
__l_299:
; 205             bios(a = biosPrintC, c = ' ');
	ld a, 0
	ld c, 32
	call bios
; 206             b--;
	dec b
__l_300:
; 207         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_299
	pop bc
	ret
; 208     }
; 209 }
; 210 
; 211 void DiskViewShowDir() {
diskviewshowdir:
; 212     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 213         bios(c = (a = DiskViewColor), a = biosSetColorC);
	ld a, (diskviewcolor)
	ld c, a
	ld a, 18
	call bios
; 214         a = DiskViewX;
	ld a, (diskviewx)
; 215         a += 2;
	add 2
; 216         l = a;
	ld l, a
; 217         a = DiskViewY;
	ld a, (diskviewy)
; 218         a += 2;
	add 2
; 219         h = a;
	ld h, a
; 220         //-- HL позиция
; 221         a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 222         if (a > 0) {
	or a
	jp z, __l_302
; 223             b = 0;
	ld b, 0
; 224             do {
__l_304:
; 225                 bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 226                 h++;
	inc h
; 227                 //--
; 228                 a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 229                 a--;
	dec a
; 230                 if (a >= b) {
	cp b
	jp c, __l_307
; 231                     DiskViewShowFilePosB();
	call diskviewshowfileposb
	jp __l_308
__l_307:
; 232                 } else {
; 233                     DiskViewShowEmptyFile();
	call diskviewshowemptyfile
__l_308:
; 234                 }
; 235                 //--
; 236                 b++;
	inc b
; 237                 a = DiskViewDirPageCoint;
	ld a, (diskviewdirpagecoint)
; 238                 a--;
	dec a
__l_305:
; 239             } while (a >= b);
	cp b
	jp nc, __l_304
	jp __l_303
__l_302:
; 240         } else {
; 241             b = (a = DiskViewDirPageCoint);
	ld a, (diskviewdirpagecoint)
	ld b, a
; 242             do {
__l_309:
; 243                 bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 244                 h++;
	inc h
; 245                 DiskViewShowEmptyFile();
	call diskviewshowemptyfile
; 246                 b--;
	dec b
__l_310:
; 247             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_309
__l_303:
	pop de
	pop bc
	pop hl
	ret
; 248         }
; 249     }
; 250     
; 251     //DiskViewDirProgress();
; 252 //    push_pop(hl, bc, de) {
; 253 //        a = DiskViewX;
; 254 //        a += 2;
; 255 //        l = a;
; 256 //        a = DiskViewY;
; 257 //        a += 2;
; 258 //        h = a;
; 259 //        // В HL храним курсор
; 260 //        //-- RootTitle
; 261 //        bios(a = biosSetPositionCursoreHL);
; 262 //        push_pop(hl) {
; 263 //            bios(a = biosPrintMessageHL, hl = DiskViewDirRootTitle);
; 264 //        }
; 265 //        //-- List DiskViewDirPageCoint
; 266 //        b = 0;
; 267 //        c = (a = DiskViewDirCount);
; 268 //        c--;
; 269 //        do {
; 270 //            h++;
; 271 //            bios(a = biosSetPositionCursoreHL);
; 272 //            push_pop(hl) {
; 273 //                if ((a = c) >= b) {
; 274 //                    DiskViewDirBuferBIndexToHL();
; 275 //                    DiskViewDirBuferFileName();
; 276 //                } else {
; 277 //                    MyFuncPrintHLStrLenA(hl = DiskViewDirNameEmpty, a = 16);
; 278 //                }
; 279 //            }
; 280 //            b++;
; 281 //            a = DiskViewDirPageCoint;
; 282 //            a--;
; 283 //        } while (a >= b);
; 284 //    }
; 285 }
; 286 
; 287 void DiskViewDirBuferFileName() {
diskviewdirbuferfilename:
; 288     push_pop(bc) {
	push bc
; 289         b = 8;
	ld b, 8
; 290         do {
__l_312:
; 291             bios(a = biosPrintC, c = (a = *hl));
	ld a, 0
	ld a, (hl)
	ld c, a
	call bios
; 292             hl++;
	inc hl
; 293             b--;
	dec b
__l_313:
; 294         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_312
	pop bc
	ret
; 295     }
; 296 }
; 297 
; 298 void DiskViewDirBuferBIndexToHL() {
diskviewdirbuferbindextohl:
; 299     push_pop(de) {
	push de
; 300         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 301         d = 0;
	ld d, 0
; 302         a ^= a;
	xor a
; 303         a = b;
	ld a, b
; 304         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 305         e = a;
	ld e, a
; 306         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_315
; 307             d++;
	inc d
__l_315:
; 308         }
; 309         hl += de;
	add hl, de
	pop de
	ret
; 310     }
; 311 }
; 312 
; 313 /// Рисование линии прямым или инверсным цветом
; 314 /// 0 - прямой
; 315 /// 1 - инверсный
; 316 void DiskViewShowSelectLineA() {
diskviewshowselectlinea:
; 317     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 318         c = a;
	ld c, a
; 319         // HL
; 320         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 321         b = a;
	ld b, a
; 322         a = DiskViewY;
	ld a, (diskviewy)
; 323         a += 2;
	add 2
; 324         a += b;
	add b
; 325         h = a;
	ld h, a
; 326         a = DiskViewX;
	ld a, (diskviewx)
; 327         a += 1;
	add 1
; 328         l = a;
	ld l, a
; 329         // DE
; 330         a = DiskViewDX;
	ld a, (diskviewdx)
; 331         a -= 2;
	sub 2
; 332         e = a;
	ld e, a
; 333         a = 1;
	ld a, 1
; 334         d = a;
	ld d, a
; 335         // C
; 336         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_317
; 337             a = DiskViewColor;
	ld a, (diskviewcolor)
	jp __l_318
__l_317:
; 338         } else {
; 339             a = DiskViewInvColor;
	ld a, (diskviewinvcolor)
__l_318:
; 340         }
; 341         c = a;
	ld c, a
; 342         // A
; 343         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop de
	pop hl
	pop bc
	ret
; 344     }
; 345 }
; 346 
; 347 void DiskViewDirEndIndexCalc() {
diskviewdirendindexcalc:
; 348     push_pop(bc) {
	push bc
; 349         //--
; 350         a = DiskViewDirPageCoint;
	ld a, (diskviewdirpagecoint)
; 351         c = a;
	ld c, a
; 352         //--
; 353         a = DiskViewDirStartIndex;
	ld a, (diskviewdirstartindex)
; 354         b = a;
	ld b, a
; 355         a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 356         a -= b;
	sub b
; 357         if (a >= c) {
	cp c
	jp c, __l_319
; 358             a = c;
	ld a, c
__l_319:
; 359         }
; 360         DiskViewDirEndIndex = a;
	ld (diskviewdirendindex), a
	pop bc
	ret
; 361     }
; 362 }
; 363 
; 364 /// Обновление позиции
; 365 /// вх[A]
; 366 /// 0 - без изменений
; 367 /// 1 - вверх
; 368 /// 0xFF - вниз
; 369 void DiskViewFileCurrentPosUpdateA() {
diskviewfilecurrentposupdatea:
; 370     push_pop(bc, de) {
	push bc
	push de
; 371         b = a;
	ld b, a
; 372         DiskViewDirEndIndexCalc();
	call diskviewdirendindexcalc
; 373         if (a == 0) {
	or a
	jp nz, __l_321
; 374             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp __l_322
__l_321:
; 375         } else {
; 376             a = DiskViewDirEndIndex; //DiskViewDirCount;
	ld a, (diskviewdirendindex)
; 377             a += 1;
	add 1
; 378             c = a;
	ld c, a
; 379             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 380             a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 381             a += b;
	add b
; 382             d = a;
	ld d, a
; 383             //
; 384             if (a == 0xFF) {
	cp 255
	jp nz, __l_323
; 385                 // Можно ли скролить вверх
; 386                 a = DiskViewDirStartIndex;
	ld a, (diskviewdirstartindex)
; 387                 if (a > 0) {
	or a
	jp z, __l_325
; 388                     a--;
	dec a
; 389                     DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
; 390                     DiskViewShowDir();
	call diskviewshowdir
; 391                     a = 0;
	ld a, 0
	jp __l_326
__l_325:
; 392                 } else {
; 393                     #ifdef _IS_CYCLIC_MOVEMENT_THROUGH_THE_LIST_OF_FILES
; 394                         a = 0;
; 395                     #else
; 396                         push_pop(bc) {
	push bc
; 397                             a = DiskViewDirPageCoint;
	ld a, (diskviewdirpagecoint)
; 398                             b = a;
	ld b, a
; 399                             a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 400                             if (a >= b) {
	cp b
	jp c, __l_327
; 401                                 a -= b;
	sub b
; 402                                 DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
	jp __l_328
__l_327:
; 403                             } else {
; 404                                 a = 0;
	ld a, 0
; 405                                 DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
__l_328:
	pop bc
; 406                             }
; 407                         }
; 408                         DiskViewShowDir();
	call diskviewshowdir
; 409                         a = c;
	ld a, c
; 410                         a--;
	dec a
__l_326:
	jp __l_324
__l_323:
; 411                     #endif
; 412                 }
; 413             } else if (a == c) {
	cp c
	jp nz, __l_329
; 414                 // Можно ли еще скролить вниз
; 415                 push_pop(bc) {
	push bc
; 416                     b = a;
	ld b, a
; 417                     a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 418                     a++;
	inc a
; 419                     c = a;
	ld c, a
; 420                     a = DiskViewDirStartIndex;
	ld a, (diskviewdirstartindex)
; 421                     a += b;
	add b
; 422                     if (a < c) {
	cp c
	jp nc, __l_331
; 423                         a = DiskViewDirStartIndex;
	ld a, (diskviewdirstartindex)
; 424                         a++;
	inc a
; 425                         DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
; 426                         DiskViewShowDir();
	call diskviewshowdir
; 427                         a = b;
	ld a, b
; 428                         a--;
	dec a
	jp __l_332
__l_331:
; 429                     } else {
; 430                         #ifdef _IS_CYCLIC_MOVEMENT_THROUGH_THE_LIST_OF_FILES
; 431                             a = d;
; 432                             a--;
; 433                         #else
; 434                             a = 0;
	ld a, 0
; 435                             DiskViewDirStartIndex = a;
	ld (diskviewdirstartindex), a
; 436                             DiskViewShowDir();
	call diskviewshowdir
; 437                             a = 0;
	ld a, 0
__l_332:
	pop bc
__l_329:
__l_324:
; 438                         #endif
; 439                     }
; 440                 }
; 441             }
; 442             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 443             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
__l_322:
	pop de
	pop bc
	ret
; 444         }
; 445     }
; 446 }
; 447 
; 448 /// Проверка, хватит ли места на текущем диске для файла
; 449 /// вх[DE] - размер предпологаемого файла. Еще надо прибавить 16 - для заголовка
; 450 /// вых[A] - 0 - места нет, 1 - место есть
; 451 void DiskViewIsDiskSpaceDE() {
diskviewisdiskspacede:
; 452     push_pop(hl, de) {
	push hl
	push de
; 453         //-- Add 16
; 454         hl = 16;
	ld hl, 16
; 455         hl += de;
	add hl, de
; 456         //-- byte -> kByte
; 457         a = h;
	ld a, h
; 458         a &= 0xFC;
	and 252
; 459         cyclic_rotate_right(a, 2);
	rrca
	rrca
; 460         if (a == 0) {
	or a
	jp nz, __l_333
; 461             a++;
	inc a
__l_333:
; 462         }
; 463         d = 0;
	ld d, 0
; 464         e = a;
	ld e, a
; 465         //--
; 466         DiskViewDiskFreeSpaceHL();
	call diskviewdiskfreespacehl
; 467         //--
; 468         DiskViewHLSubDE();
	call diskviewhlsubde
	pop de
	pop hl
	ret
; 469     }
; 470 }
; 471 
; 472 /// Возвращает свободное место на диске
; 473 /// вых[HL] - результат
; 474 void DiskViewDiskFreeSpaceHL() {
diskviewdiskfreespacehl:
; 475     push_pop(bc, de) {
	push bc
	push de
; 476         bios(a = biosUpdateInfoDisk);
	ld a, 144
	call bios
; 477         bios(a = biosGetInfoDisk, c = 0x01);
	ld a, 147
	ld c, 1
	call bios
	pop de
	pop bc
	ret
; 478 //        d = h;
; 479 //        e = l;
; 480     }
; 481 }
; 482 
; 483 /// HL = HL + (-DE)
; 484 /// вх[DE,HL]
; 485 /// вых[HL, A] - HL - результат вычитания , A = 1 HL > DE
; 486 void DiskViewHLSubDE() {
diskviewhlsubde:
; 487     push_pop(de) {
	push de
; 488         a = d; // Инвертируем старший байт D
	ld a, d
; 489         invert(a);
	cpl
; 490         d = a;
	ld d, a
; 491         a = e; // Инвертируем младший байт E
	ld a, e
; 492         invert(a);
	cpl
; 493         e = a;
	ld e, a
; 494         de++; // Получаем точный дополнительный код DE (-DE)
	inc de
; 495         a ^= a;
	xor a
; 496         hl += de; // HL = HL + (-DE), что эквивалентно HL - DE
	add hl, de
; 497         if (flag_c) { // Если HL > DE: перенос будет C = 1.
	jp nc, __l_335
; 498             a = 1;
	ld a, 1
	jp __l_336
__l_335:
; 499         } else {
; 500             a = 0;
	ld a, 0
__l_336:
	pop de
	ret
; 501         }
; 502     }
; 503 }
; 504 
; 505 void DiskViewCopyFileNameByHL() {
diskviewcopyfilenamebyhl:
; 506     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 507         de = DiskViewFileName;
	ld de, diskviewfilename
; 508         b = 8;
	ld b, 8
; 509         do {
__l_337:
; 510             *de = (a = *hl);
	ld a, (hl)
	ld (de), a
; 511             hl++;
	inc hl
; 512             de++;
	inc de
; 513             b--;
	dec b
__l_338:
; 514         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_337
; 515         *de = (a = 0);
	ld a, 0
	ld (de), a
	pop bc
	pop de
	pop hl
	ret
; 516     }
; 517 }
; 518 
; 519 void DiskViewKeyA() {
diskviewkeya:
; 520     push_pop(hl) {
	push hl
; 521         l = a;
	ld l, a
; 522         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_340
; 523             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, __l_342
; 524                 CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
	jp __l_343
__l_342:
; 525             } else if ((a = l) == 0x08) { // 0x08 Влево
	ld a, l
	cp 8
	jp nz, __l_344
; 526                 CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
	jp __l_345
__l_344:
; 527             } else {
; 528                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_346
; 529                     DiskViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call diskviewfilecurrentposupdatea
	jp __l_347
__l_346:
; 530                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_348
; 531                     DiskViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call diskviewfilecurrentposupdatea
	jp __l_349
__l_348:
; 532                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, __l_350
; 533                     if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
	ld a, (diskviewfilecurrentpos)
	or a
	jp nz, __l_352
	jp __l_353
__l_352:
; 534                         //DiskViewNextDiskNum();
; 535                     } else { // Запуск приложения
__l_353:
	jp __l_351
__l_350:
; 536                         //DiskViewSelectFileExec();
; 537                     }
; 538                 } else if ((a = l) == 'E') {
	ld a, l
	cp 69
	jp nz, __l_354
; 539                     if ((a = DiskViewFileCurrentPos) > 0) {
	ld a, (diskviewfilecurrentpos)
	or a
	jp z, __l_356
; 540                         AllertYesNoViewShowHL(hl = StringLocaleEraseFile);
	ld hl, stringlocaleerasefile
	call allertyesnoviewshowhl
; 541                         if (a == 1) {
	cp 1
	jp nz, __l_358
__l_358:
__l_356:
	jp __l_355
__l_354:
; 542                             //DiskViewDeleteSelectedFile();
; 543                         }
; 544                     }
; 545                 } else if ((a = l) == 'D') { //  Показать выбор диска
	ld a, l
	cp 68
	jp nz, __l_360
; 546                     SelectDiskViewShow();
	call selectdiskviewshow
	jp __l_361
__l_360:
; 547                 } else if ((a = l) == 'C') { // Загрузка файла на FTP
	ld a, l
	cp 67
	jp nz, __l_362
; 548                     if ((a = DiskViewFileCurrentPos) != 0) {
	ld a, (diskviewfilecurrentpos)
	or a
	jp z, __l_364
; 549                         //DiskViewUploadSelectedFile();
; 550                         FtpViewNetLoadAndUpdate(); // обновляем список файлов FTP
	call ftpviewnetloadandupdate
__l_364:
	jp __l_363
__l_362:
; 551                     }
; 552                 } else if ((a = l) == 'F') { //  Отформатировать диск
	ld a, l
	cp 70
	jp nz, __l_366
__l_366:
__l_363:
__l_361:
__l_355:
__l_351:
__l_349:
__l_347:
__l_345:
__l_343:
__l_340:
	pop hl
	ret
; 553                     //DiskViewFormat();
; 554                 }
; 555             }
; 556         }
; 557     }
; 558 }
; 559 
; 560 uint8_t DiskViewX = 28;
diskviewx:
	db 28
; 561 uint8_t DiskViewY = 4;
diskviewy:
	db 4
; 562 uint8_t DiskViewDX = 20;
diskviewdx:
	db 20
; 563 uint8_t DiskViewDY = 25;
diskviewdy:
	db 25
; 564 uint8_t DiskViewColor = 0x1F;
diskviewcolor:
	db 31
; 565 uint8_t DiskViewInvColor = 0xF1;
diskviewinvcolor:
	db 241
; 567 uint8_t DiskViewDirCount = 0;
diskviewdircount:
	db 0
; 568 uint16_t DiskViewDirBufer = 0x0000;
diskviewdirbufer:
	dw 0
; 569 uint8_t DiskViewFileCurrentPos = 0;
diskviewfilecurrentpos:
	db 0
; 571 uint8_t DiskViewDirStartIndex = 0;
diskviewdirstartindex:
	db 0
; 572 uint8_t DiskViewDirEndIndex = 0;
diskviewdirendindex:
	db 0
; 573 uint8_t DiskViewDirPageCoint = 20;
diskviewdirpagecoint:
	db 20
; 575 uint8_t DiskViewDirProgressLen = 0;
diskviewdirprogresslen:
	db 0
; 577 uint8_t DiskViewDirRootTitle[] = "..";
diskviewdirroottitle:
	db 46
	db 46
	ds 1
; 578 uint8_t DiskViewDirNameEmpty[] = "";
diskviewdirnameempty:
	ds 1
; 579 uint8_t DiskViewTitle[] = {0x82, 'D', 'i', 's', 'k', ':', 'A', 0x92, '\0'};
diskviewtitle:
	db 130
	db 68
	db 105
	db 115
	db 107
	db 58
	db 65
	db 146
	db 0
; 581 uint8_t DiskViewFileName[9];
diskviewfilename:
	ds 9
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
	jp nz, __l_368
; 35         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, __l_370
; 36             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 37             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp __l_371
__l_370:
; 38         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, __l_372
; 39             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
; 40             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_373
__l_372:
; 41         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, __l_374
; 42             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 43             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_375
__l_374:
; 44         } else if ((a = CurrentViewId) == LoadViewId) {
	ld a, (currentviewid)
	cp 4
	jp nz, __l_376
; 45             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 46             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_377
__l_376:
; 47         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, __l_378
; 48             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 49             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_379
__l_378:
; 50         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_380
; 51             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 52             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_381
__l_380:
; 53         } else if ((a = CurrentViewId) == FtpMakeDirectoryId) {
	ld a, (currentviewid)
	cp 11
	jp nz, __l_382
; 54             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 55             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp __l_383
__l_382:
; 56         } else if ((a = CurrentViewId) == HelpInfoViewId) {
	ld a, (currentviewid)
	cp 12
	jp nz, __l_384
; 57             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 58             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
__l_384:
__l_383:
__l_381:
__l_379:
__l_377:
__l_375:
__l_373:
__l_371:
__l_368:
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
	jp z, __l_386
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
	jp __l_387
__l_386:
; 92     } else {
; 93         a = CurrentViewId;
	ld a, (currentviewid)
__l_387:
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
	jp nz, __l_388
; 108             a = 1;
	ld a, 1
; 109             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp __l_389
__l_388:
; 110         } else if ((a = b) == FtpViewId) {
	ld a, b
	cp 2
	jp nz, __l_390
; 111             a = 1;
	ld a, 1
; 112             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp __l_391
__l_390:
; 113         } else {
; 114             a = 0;
	ld a, 0
; 115             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
__l_391:
__l_389:
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
; 11 void Debug00Start() {
debug00start:
; 12     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 13         Debug00X = (a = 0);
	ld a, 0
	ld (debug00x), a
; 14         Debug00Y = (a = 0);
	ld a, 0
	ld (debug00y), a
; 15 
; 16         Debug00CharPrintA(a = 'D');
	ld a, 68
	call debug00charprinta
; 17         Debug00CharPrintA(a = 'e');
	ld a, 101
	call debug00charprinta
; 18         Debug00CharPrintA(a = 'b');
	ld a, 98
	call debug00charprinta
; 19         Debug00CharPrintA(a = 'u');
	ld a, 117
	call debug00charprinta
; 20         Debug00CharPrintA(a = 'g');
	ld a, 103
	call debug00charprinta
; 21         Debug00CharPrintA(a = '-');
	ld a, 45
	call debug00charprinta
; 22         Debug00CharPrintA(a = '>');
	ld a, 62
	call debug00charprinta
	pop de
	pop bc
	pop hl
	ret
; 23     }
; 24 }
; 25 
; 26 void Debug00CharPrintA() {
debug00charprinta:
; 27     push_pop(bc, hl) {
	push bc
	push hl
; 28         c = a;
	ld c, a
; 29         h = (a = Debug00Y);
	ld a, (debug00y)
	ld h, a
; 30         l = (a = Debug00X);
	ld a, (debug00x)
	ld l, a
; 31         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 32         bios(a = biosPrintC);
	ld a, 0
	call bios
; 33         Debug00PosIncrement();
	call debug00posincrement
	pop hl
	pop bc
	ret
; 34     }
; 35 }
; 36 
; 37 void Debug00HexPrintA() {
debug00hexprinta:
; 38     push_pop(bc, hl) {
	push bc
	push hl
; 39         c = a;
	ld c, a
; 40         h = (a = Debug00Y);
	ld a, (debug00y)
	ld h, a
; 41         l = (a = Debug00X);
	ld a, (debug00x)
	ld l, a
; 42         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 43         bios(a = biosPrintByteC);
	ld a, 4
	call bios
; 44         Debug00PosIncrement();
	call debug00posincrement
; 45         Debug00PosIncrement();
	call debug00posincrement
	pop hl
	pop bc
	ret
; 46     }
; 47 }
; 48 
; 49 void Debug00PosIncrement() {
debug00posincrement:
; 50     a = Debug00X; // 48 32
	ld a, (debug00x)
; 51     a++;
	inc a
; 52     if (a >= 49) {
	cp 49
	jp c, __l_392
; 53         Debug00X = (a = 0);
	ld a, 0
	ld (debug00x), a
; 54         a = Debug00Y;
	ld a, (debug00y)
; 55         a++;
	inc a
; 56         if (a >= 33) {
	cp 33
	jp c, __l_394
; 57             Debug00Y = (a = 0);
	ld a, 0
	ld (debug00y), a
	jp __l_395
__l_394:
; 58         } else {
; 59             Debug00Y = a;
	ld (debug00y), a
__l_395:
	jp __l_393
__l_392:
; 60         }
; 61     } else {
; 62         Debug00X = a;
	ld (debug00x), a
__l_393:
	ret
; 63     }
; 64     
; 65 }
; 66 
; 67 uint8_t Debug00X = 0;
debug00x:
	db 0
; 68 uint8_t Debug00Y = 0;
debug00y:
	db 0
; 70 uint8_t DebugRegA = 0;
debugrega:
	db 0
; 71 uint8_t DebugRegB = 0;
debugregb:
	db 0
; 72 uint8_t DebugRegC = 0;
debugregc:
	db 0
; 73 uint8_t DebugRegD = 0;
debugregd:
	db 0
; 74 uint8_t DebugRegE = 0;
debugrege:
	db 0
; 75 uint8_t DebugRegH = 0;
debugregh:
	db 0
; 76 uint8_t DebugRegL = 0;
debugregl:
	db 0
; 78 uint8_t DebugError[] = "Error!";
debugerror:
	db 69
	db 114
	db 114
	db 111
	db 114
	db 33
	ds 1
; 79 uint8_t DebugOk[] = "Ok!";
debugok:
	db 79
	db 107
	db 33
	ds 1
; 11 void SelectDiskViewShow() {
selectdiskviewshow:
; 12     CurrentViewChangeAndPushIdA(a = SelectDiskViewId);
	ld a, 3
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         SelectDiskViewUpdateDiskList();
	call selectdiskviewupdatedisklist
; 15         SelectDiskViewUpdateSize();
	call selectdiskviewupdatesize
; 16         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 17         c = (a = SelectDiskViewColor);
	ld a, (selectdiskviewcolor)
	ld c, a
; 18         l = (a = SelectDiskViewX);
	ld a, (selectdiskviewx)
	ld l, a
; 19         h = (a = SelectDiskViewY);
	ld a, (selectdiskviewy)
	ld h, a
; 20         e = (a = SelectDiskViewDX);
	ld a, (selectdiskviewdx)
	ld e, a
; 21         d = (a = SelectDiskViewDY);
	ld a, (selectdiskviewdy)
	ld d, a
; 22         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 23         MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 24         //--
; 25         SelectDiskViewShowTitle();
	call selectdiskviewshowtitle
; 26         SelectDiskViewShowList();
	call selectdiskviewshowlist
; 27         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop de
	pop hl
	pop bc
	ret
; 28     }
; 29 }
; 30 
; 31 void SelectDiskViewShowTitle() {
selectdiskviewshowtitle:
; 32     push_pop(bc, hl) {
	push bc
	push hl
; 33         c = (a = SelectDiskViewY);
	ld a, (selectdiskviewy)
	ld c, a
; 34         c++;
	inc c
; 35         // Title 1 = 7
; 36         b = 7;
	ld b, 7
; 37         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 38         a -= b;
	sub b
; 39         cyclic_rotate_right(a, 1);
	rrca
; 40         a &= 0x7F;
	and 127
; 41         a++;
	inc a
; 42         b = a;
	ld b, a
; 43         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 44         a += b;
	add b
; 45         l = a;
	ld l, a
; 46         h = c;
	ld h, c
; 47         c++;
	inc c
; 48         push_pop(bc) {
	push bc
; 49             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 50             bios(a = biosPrintMessageHL, hl = SelectDiskViewSelectTitle);
	ld a, 2
	ld hl, selectdiskviewselecttitle
	call bios
	pop bc
; 51         }
; 52         // Title 2 = 7
; 53         b = 7;
	ld b, 7
; 54         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 55         a -= b;
	sub b
; 56         cyclic_rotate_right(a, 1);
	rrca
; 57         a &= 0x7F;
	and 127
; 58         a++;
	inc a
; 59         b = a;
	ld b, a
; 60         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 61         a += b;
	add b
; 62         l = a;
	ld l, a
; 63         h = c;
	ld h, c
; 64         push_pop(bc) {
	push bc
; 65             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 66             bios(a = biosPrintMessageHL, hl = SelectDiskViewSelectSubTitle);
	ld a, 2
	ld hl, selectdiskviewselectsubtitle
	call bios
	pop bc
; 67         }
; 68         c++;
	inc c
; 69         c++;
	inc c
; 70         //-- Line
; 71         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 72         a += 1;
	add 1
; 73         l = a;
	ld l, a
; 74         h = c;
	ld h, c
; 75         push_pop(bc) {
	push bc
; 76             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 77             a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 78             a -= 2;
	sub 2
; 79             b = a;
	ld b, a
; 80             c = 0x90;
	ld c, 144
; 81             do {
__l_396:
; 82                 bios(a = biosPrintC);
	ld a, 0
	call bios
; 83                 b--;
	dec b
__l_397:
; 84             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_396
	pop bc
	pop hl
	pop bc
	ret
; 85         }
; 86     }
; 87 }
; 88 
; 89 void SelectDiskViewShowList() {
selectdiskviewshowlist:
; 90     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 91         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 92         a += 2;
	add 2
; 93         l = a;
	ld l, a
; 94         e = a;
	ld e, a
; 95         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 96         a += 6;
	add 6
; 97         h = a;
	ld h, a
; 98         d = a;
	ld d, a
; 99         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 100         //--
; 101         b = (a = SelectDiskViewListCount);
	ld a, (selectdiskviewlistcount)
	ld b, a
; 102         hl = SelectDiskViewListDisk;
	ld hl, selectdiskviewlistdisk
; 103         do {
__l_399:
; 104             bios(a = biosPrintC, c = *hl);
	ld a, 0
	ld c, (hl)
	call bios
; 105             //--
; 106             push_pop(hl) {
	push hl
; 107                 h = d;
	ld h, d
; 108                 e++;
	inc e
; 109                 e++;
	inc e
; 110                 e++;
	inc e
; 111                 l = e;
	ld l, e
; 112                 bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 113             }
; 114             hl++;
	inc hl
; 115             b--;
	dec b
__l_400:
; 116         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_399
	pop de
	pop hl
	pop bc
	ret
; 117     }
; 118 }
; 119 
; 120 void SelectDiskViewSetCurrentPosA() {
selectdiskviewsetcurrentposa:
; 121     push_pop(bc) {
	push bc
; 122         b = a;
	ld b, a
; 123         SelectDiskViewUpdateSelectA(a = 0);
	ld a, 0
	call selectdiskviewupdateselecta
; 124         a = b;
	ld a, b
; 125         SelectDiskViewCurrentPos = a;
	ld (selectdiskviewcurrentpos), a
; 126         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop bc
	ret
; 127     }
; 128 }
; 129 
; 130 /// 0 - прямой
; 131 /// 1 - инверсный
; 132 void SelectDiskViewUpdateSelectA() {
selectdiskviewupdateselecta:
; 133     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 134         if (a == 0) {
	or a
	jp nz, __l_402
; 135             a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
	jp __l_403
__l_402:
; 136         } else {
; 137             a = SelectDiskViewInvColor;
	ld a, (selectdiskviewinvcolor)
__l_403:
; 138         }
; 139         c = a;
	ld c, a
; 140         //--
; 141         a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 142         b = a;
	ld b, a
; 143         a += b;
	add b
; 144         a += b;
	add b
; 145         b = a;
	ld b, a
; 146         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 147         a += b;
	add b
; 148         a += 1;
	add 1
; 149         l = a;
	ld l, a
; 150         //--
; 151         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 152         a += 5;
	add 5
; 153         h = a;
	ld h, a
; 154         //--
; 155         d = 3;
	ld d, 3
; 156         e = 3;
	ld e, 3
; 157         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop de
	pop hl
	pop bc
	ret
; 158     }
; 159 }
; 160 
; 161 void SelectDiskViewClose() {
selectdiskviewclose:
; 162     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 163     CurrentViewReturn();
	jp currentviewreturn
; 164 }
; 165 
; 166 void SelectDiskViewKeyA() {
selectdiskviewkeya:
; 167     push_pop(hl) {
	push hl
; 168         l = a;
	ld l, a
; 169         if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, __l_404
; 170             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_406
; 171                 SelectDiskViewClose();
	call selectdiskviewclose
	jp __l_407
__l_406:
; 172             } else if ((a = l) == 0x0D) { // Выбор диска
	ld a, l
	cp 13
	jp nz, __l_408
; 173                 SelectDiskViewClose();
	call selectdiskviewclose
; 174                 push_pop(hl, de) {
	push hl
	push de
; 175                     e = (a = SelectDiskViewCurrentPos);
	ld a, (selectdiskviewcurrentpos)
	ld e, a
; 176                     d = 0;
	ld d, 0
; 177                     hl = SelectDiskViewListDisk;
	ld hl, selectdiskviewlistdisk
; 178                     hl += de;
	add hl, de
; 179                     a = *hl;
	ld a, (hl)
	pop de
	pop hl
; 180                 }
; 181                 DiskViewSetDiskNumA();
	call diskviewsetdisknuma
	jp __l_409
__l_408:
; 182             } else if ((a = l) == 0x18) { // Вправо
	ld a, l
	cp 24
	jp nz, __l_410
; 183                 h = (a = SelectDiskViewListCount);
	ld a, (selectdiskviewlistcount)
	ld h, a
; 184                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 185                 a++;
	inc a
; 186                 if (a == h) {
	cp h
	jp nz, __l_412
; 187                     a = 0;
	ld a, 0
__l_412:
; 188                 }
; 189                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
	jp __l_411
__l_410:
; 190             } else if ((a = l) == 0x08) { // Влево
	ld a, l
	cp 8
	jp nz, __l_414
; 191                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 192                 if (a == 0) {
	or a
	jp nz, __l_416
; 193                     a = SelectDiskViewListCount;
	ld a, (selectdiskviewlistcount)
; 194                     a--;
	dec a
	jp __l_417
__l_416:
; 195                 } else {
; 196                     a--;
	dec a
__l_417:
; 197                 }
; 198                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
__l_414:
__l_411:
__l_409:
__l_407:
__l_404:
	pop hl
	ret
; 199             }
; 200         }
; 201     }
; 202 }
; 203 
; 204 void SelectDiskViewUpdateSize() {
selectdiskviewupdatesize:
; 205     //x = 48
; 206     push_pop(bc) {
	push bc
; 207         a = SelectDiskViewListCount;
	ld a, (selectdiskviewlistcount)
; 208         b = a;
	ld b, a
; 209         a += b;
	add b
; 210         a += b;
	add b
; 211         a += 2;
	add 2
; 212         SelectDiskViewDX = a;
	ld (selectdiskviewdx), a
; 213         b = a;
	ld b, a
; 214         a = 48;
	ld a, 48
; 215         a -= b;
	sub b
; 216         cyclic_rotate_right(a, 1);
	rrca
; 217         SelectDiskViewX = a;
	ld (selectdiskviewx), a
	pop bc
	ret
; 218     }
; 219 }
; 220 
; 221 void SelectDiskViewUpdateDiskList() {
selectdiskviewupdatedisklist:
; 222     push_pop(bc, hl) {
	push bc
	push hl
; 223         hl = SelectDiskViewListDisk;
	ld hl, selectdiskviewlistdisk
; 224         *hl = (a = 'A');
	ld a, 65
	ld (hl), a
; 225         hl++;
	inc hl
; 226         *hl = (a = 'B');
	ld a, 66
	ld (hl), a
; 227         hl++;
	inc hl
; 228         *hl = 0;
	ld (hl), 0
; 229         SelectDiskViewListCount = (a = 2);
	ld a, 2
	ld (selectdiskviewlistcount), a
	pop hl
	pop bc
	ret
; 230 //        SelectDiskViewListCount = (a = 0);
; 231 //        //--
; 232 //        b = 8;
; 233 //        c = 'A';
; 234 //        hl = SelectDiskViewListDisk;
; 235 //        do {
; 236 //            bios(a = biosGetAccessDiskC);
; 237 //            if (flag_c) {
; 238 //                *hl = (a = c);
; 239 //                hl++;
; 240 //                a = SelectDiskViewListCount;
; 241 //                a++;
; 242 //                SelectDiskViewListCount = a;
; 243 //            }
; 244 //            c++;
; 245 //            b--;
; 246 //        } while ((a = b) > 0);
; 247 //        *hl = 0;
; 248     }
; 249 }
; 250 
; 251 uint8_t SelectDiskViewX = 17;
selectdiskviewx:
	db 17
; 252 uint8_t SelectDiskViewY = 12;
selectdiskviewy:
	db 12
; 253 uint8_t SelectDiskViewDX = 14;
selectdiskviewdx:
	db 14
; 254 uint8_t SelectDiskViewDY = 9;
selectdiskviewdy:
	db 9
; 255 uint8_t SelectDiskViewColor = 0x70; //0x1F;
selectdiskviewcolor:
	db 112
; 256 uint8_t SelectDiskViewInvColor = 0x20; //0x2E;
selectdiskviewinvcolor:
	db 32
; 258 uint8_t SelectDiskViewCurrentPos = 0;
selectdiskviewcurrentpos:
	db 0
; 260 uint8_t SelectDiskViewSelectTitle[7] = "Choose";
selectdiskviewselecttitle:
	db 67
	db 104
	db 111
	db 111
	db 115
	db 101
	ds 1
; 261 uint8_t SelectDiskViewSelectSubTitle[7] = "drive:";
selectdiskviewselectsubtitle:
	db 100
	db 114
	db 105
	db 118
	db 101
	db 58
	ds 1
; 263 uint8_t SelectDiskViewListDisk[9] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
selectdiskviewlistdisk:
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 264 uint8_t SelectDiskViewListCount = 0;
selectdiskviewlistcount:
	db 0
; 11 void StringLocaleCreateLoadTitleA() {
stringlocalecreateloadtitlea:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         hl = LoadViewInfoString;
	ld hl, loadviewinfostring
; 14         // From
; 15         de = LoadViewStrFrom;
	ld de, loadviewstrfrom
; 16         StringLocaleAddDEInHL();
	call stringlocaleadddeinhl
; 17         StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
; 18         // ftp path
; 19         de = FtpViewPath;
	ld de, ftpviewpath
; 20         b = 27 - 7;
	ld b, 20
; 21         c = 0;
	ld c, 0
; 22         do {
__l_418:
; 23             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_421
; 24                 a = *de;
	ld a, (de)
; 25                 if (a > 0) {
	or a
	jp z, __l_423
; 26                     *hl = a;
	ld (hl), a
; 27                     de++;
	inc de
; 28                     hl++;
	inc hl
	jp __l_424
__l_423:
; 29                 } else {
; 30                     c = 1;
	ld c, 1
; 31                     StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
__l_424:
	jp __l_422
__l_421:
; 32                 }
; 33             } else {
; 34                 StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
__l_422:
; 35             }
; 36             b--;
	dec b
__l_419:
; 37         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_418
; 38         // Name
; 39         de = LoadViewStrName;
	ld de, loadviewstrname
; 40         StringLocaleAddDEInHL();
	call stringlocaleadddeinhl
; 41         StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
; 42         // FileName
; 43         de = FtpViewFilesList;
	ld de, ftpviewfileslist
; 44         push_pop(hl) {
	push hl
; 45             a ^= a;
	xor a
; 46             d = 0;
	ld d, 0
; 47             a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 48             carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 49             e = a;
	ld e, a
; 50             if (flag_c) {
	jp nc, __l_425
; 51                 d++;
	inc d
__l_425:
; 52             }
; 53             hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 54             hl += de;
	add hl, de
; 55             d = h;
	ld d, h
; 56             e = l;
	ld e, l
; 57             // get address
; 58             push_pop(de) {
	push de
; 59                 de = 8;
	ld de, 8
; 60                 hl += de;
	add hl, de
; 61                 d = h;
	ld d, h
; 62                 e = l;
	ld e, l
; 63                 a = *de;
	ld a, (de)
; 64                 h = a;
	ld h, a
; 65                 de++;
	inc de
; 66                 a = *de;
	ld a, (de)
; 67                 l = a;
	ld l, a
; 68                 StringLocaleAddress = hl;
	ld (stringlocaleaddress), hl
	pop de
	pop hl
; 69             }
; 70         }
; 71         b = 8;
	ld b, 8
; 72         do {
__l_427:
; 73             a = *de;
	ld a, (de)
; 74             *hl = a;
	ld (hl), a
; 75             de++;
	inc de
; 76             hl++;
	inc hl
; 77             b--;
	dec b
__l_428:
; 78         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_427
; 79         // Stop
; 80         *hl = 0;
	ld (hl), 0
; 81         
; 82         hl = LoadViewInfoSubString;
	ld hl, loadviewinfosubstring
; 83         // to
; 84         de = LoadViewStrTo;
	ld de, loadviewstrto
; 85         StringLocaleAddDEInHL();
	call stringlocaleadddeinhl
; 86         StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
; 87         // Disk
; 88         bios(a = biosGetDiskC);
	ld a, 132
	call bios
; 89         *hl = (a = c);
	ld a, c
	ld (hl), a
; 90         hl++;
	inc hl
; 91         *hl = ':';
	ld (hl), 58
; 92         hl++;
	inc hl
; 93         // Space 27
; 94         b = 27 - 7;
	ld b, 20
; 95         do {
__l_430:
; 96             StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
; 97             b--;
	dec b
__l_431:
; 98         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_430
; 99         // Size
; 100         de = LoadViewStrSize;
	ld de, loadviewstrsize
; 101         StringLocaleAddDEInHL();
	call stringlocaleadddeinhl
; 102         StringLocaleAddSpaceInHL();
	call stringlocaleaddspaceinhl
; 103         // Size value
; 104         push_pop(hl) {
	push hl
; 105             hl = StringLocaleAddress;
	ld hl, (stringlocaleaddress)
; 106             d = h;
	ld d, h
; 107             e = l;
	ld e, l
	pop hl
; 108         }
; 109         MyFunc4CharSizeDE();
	call myfunc4charsizede
; 110         b = 4;
	ld b, 4
; 111         de = MyFunc4Chars;
	ld de, myfunc4chars
; 112         do {
__l_433:
; 113             *hl = (a = *de);
	ld a, (de)
	ld (hl), a
; 114             hl++;
	inc hl
; 115             de++;
	inc de
; 116             b--;
	dec b
__l_434:
; 117         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_433
; 118         
; 119         // Stop
; 120         *hl = 0;
	ld (hl), 0
	pop de
	pop hl
	pop bc
	ret
; 121     }
; 122 }
; 123 
; 124 void StringLocaleAddDEInHL() {
stringlocaleadddeinhl:
; 125     do {
__l_436:
; 126         a = *de;
	ld a, (de)
; 127         if (a > 0) {
	or a
	jp z, __l_439
; 128             *hl = a;
	ld (hl), a
; 129             de++;
	inc de
; 130             hl++;
	inc hl
__l_439:
__l_437:
; 131         }
; 132     } while (a > 0);
	or a
	jp nz, __l_436
	ret
; 133 }
; 134 
; 135 void StringLocaleAddSpaceInHL() {
stringlocaleaddspaceinhl:
; 136     a = ' ';
	ld a, 32
; 137     StringLocaleCharAToHL();
; 138 }
; 139 
; 140 void StringLocaleCharAToHL() {
stringlocalecharatohl:
; 141     *hl = a;
	ld (hl), a
; 142     hl++;
	inc hl
	ret
; 143 }
; 144 
; 145 uint8_t StringLocaleOK[] = "Ok";
stringlocaleok:
	db 79
	db 107
	ds 1
; 146 uint8_t StringLocaleYes[] = "Yes";
stringlocaleyes:
	db 89
	db 101
	db 115
	ds 1
; 147 uint8_t StringLocaleNo[] = "No";
stringlocaleno:
	db 78
	db 111
	ds 1
; 148 uint8_t StringLocaleEraseFile[] = "Erase file";
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
; 149 uint8_t StringLocaleFileNotFound[] = "File not found";
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
; 150 uint8_t StringLocaleFileReadOnly[] = "File read-only";
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
; 151 uint8_t StringLocaleNetTimeOut[] = "Net timeout";
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
; 153 uint8_t StringLocaleNetFtpDeleteFileError[] = "FTP file not delete";
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
; 154 uint8_t StringLocaleNetFtpConnectError[] = "FTP connect error";
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
; 155 uint8_t StringLocaleNetWiFiConnectError[] = "WiFi connect error";
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
; 156 uint8_t StringLocaleDiskFull[] = "Disk full";
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
; 157 uint8_t StringLocaleDiskFormat[] = "Format the disk?";
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
; 159 uint8_t StringLocaleHardwareFail[] = "Not detect NetCard!";
stringlocalehardwarefail:
	db 78
	db 111
	db 116
	db 32
	db 100
	db 101
	db 116
	db 101
	db 99
	db 116
	db 32
	db 78
	db 101
	db 116
	db 67
	db 97
	db 114
	db 100
	db 33
	ds 1
; 161 uint16_t StringLocaleAddress = 0;
stringlocaleaddress:
	dw 0
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
; 23     a = l;
	ld a, l
; 24     ButtonShadowViewY = a;
	ld (buttonshadowviewy), a
; 25     a = d;
	ld a, d
; 26     ButtonShadowViewDX = a;
	ld (buttonshadowviewdx), a
; 27     a = e;
	ld a, e
; 28     ButtonShadowViewDY = a;
	ld (buttonshadowviewdy), a
; 29 
; 30     ButtonShadowViewShowTitleBC();
	call buttonshadowviewshowtitlebc
; 31     
; 32     c = (a = ButtonShadowViewColor);
	ld a, (buttonshadowviewcolor)
	ld c, a
; 33     l = (a = ButtonShadowViewX);
	ld a, (buttonshadowviewx)
	ld l, a
; 34     h = (a = ButtonShadowViewY);
	ld a, (buttonshadowviewy)
	ld h, a
; 35     e = (a = ButtonShadowViewDX);
	ld a, (buttonshadowviewdx)
	ld e, a
; 36     d = (a = ButtonShadowViewDY);
	ld a, (buttonshadowviewdy)
	ld d, a
; 37     MyViewChangeBoxColor();
	jp myviewchangeboxcolor
; 38 }
; 39 
; 40 /// Закраска кнопки
; 41 /// 0 - прямой
; 42 /// 1 - инверсный
; 43 void ButtonShadowViewSelectA() {
buttonshadowviewselecta:
; 44     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 45         b = a;
	ld b, a
; 46         l = (a = ButtonShadowViewX);
	ld a, (buttonshadowviewx)
	ld l, a
; 47         h = (a = ButtonShadowViewY);
	ld a, (buttonshadowviewy)
	ld h, a
; 48         e = (a = ButtonShadowViewDX);
	ld a, (buttonshadowviewdx)
	ld e, a
; 49         d = (a = ButtonShadowViewDY);
	ld a, (buttonshadowviewdy)
	ld d, a
; 50         //--------
; 51         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_441
; 52             a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
	jp __l_442
__l_441:
; 53         } else {
; 54             a = ButtonShadowViewInvColor;
	ld a, (buttonshadowviewinvcolor)
__l_442:
; 55         }
; 56         c = a;
	ld c, a
; 57         //----
; 58         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop hl
	pop de
	pop bc
	ret
; 59     }
; 60 }
; 61 
; 62 void ButtonShadowViewShowTitleBC() {
buttonshadowviewshowtitlebc:
; 63     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 64         hl = ButtonShadowViewTitlePoint;
	ld hl, (buttonshadowviewtitlepoint)
; 65         b = 0;
	ld b, 0
; 66         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 67         c = a;
	ld c, a
; 68         do {
__l_443:
; 69             a = *hl;
	ld a, (hl)
; 70             d = a;
	ld d, a
; 71             hl++;
	inc hl
; 72             if (a > 0) {
	or a
	jp z, __l_446
; 73                 b++;
	inc b
__l_446:
; 74             }
; 75             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_448
; 76                 d = 0;
	ld d, 0
__l_448:
__l_444:
; 77             }
; 78         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_443
; 79         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 80         a -= b;
	sub b
; 81         a &= 0xFE;
	and 254
; 82         cyclic_rotate_right(a, 1);
	rrca
; 83         b = a;
	ld b, a
; 84         a = ButtonShadowViewX;
	ld a, (buttonshadowviewx)
; 85         a += b;
	add b
; 86         l = a;
	ld l, a
; 87         a = ButtonShadowViewY;
	ld a, (buttonshadowviewy)
; 88         a += 1;
	add 1
; 89         h = a;
	ld h, a
; 90         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 91         bios(a = biosPrintMessageHL, hl = ButtonShadowViewTitlePoint);
	ld a, 2
	ld hl, (buttonshadowviewtitlepoint)
	call bios
	pop bc
	pop de
	pop hl
	ret
; 92     }
; 93 }
; 94 
; 95 uint8_t ButtonShadowViewX = 0;
buttonshadowviewx:
	db 0
; 96 uint8_t ButtonShadowViewY = 0;
buttonshadowviewy:
	db 0
; 97 uint8_t ButtonShadowViewDX = 0;
buttonshadowviewdx:
	db 0
; 98 uint8_t ButtonShadowViewDY = 0;
buttonshadowviewdy:
	db 0
; 100 uint8_t ButtonShadowViewColor = 0xF7;
buttonshadowviewcolor:
	db 247
; 101 uint8_t ButtonShadowViewInvColor = 0xE2; //0xE6
buttonshadowviewinvcolor:
	db 226
; 102 uint16_t ButtonShadowViewTitlePoint = 0x0000;
buttonshadowviewtitlepoint:
	dw 0
; 18 void EditFieldViewShow() {
editfieldviewshow:
; 19     CurrentViewChangeAndPushIdA(a = EditFieldViewId);
	ld a, 6
	call currentviewchangeandpushida
; 20     //-- clear
; 21     a = 0;
	ld a, 0
; 22     EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 23     //-- Save
; 24     EditFieldViewX = (a = l);
	ld a, l
	ld (editfieldviewx), a
; 25     EditFieldViewY = (a = h);
	ld a, h
	ld (editfieldviewy), a
; 26     EditFieldViewDX = (a = e);
	ld a, e
	ld (editfieldviewdx), a
; 27     EditFieldViewDY = (a = d);
	ld a, d
	ld (editfieldviewdy), a
; 28     //--
; 29     push_pop(bc) {
	push bc
; 30         a = EditFieldViewColor;
	ld a, (editfieldviewcolor)
; 31         c = a;
	ld c, a
; 32         // A
; 33         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop bc
; 34     }
; 35     // Save text point
; 36     h = b;
	ld h, b
; 37     l = c;
	ld l, c
; 38     EditFieldViewTextPoint = hl;
	ld (editfieldviewtextpoint), hl
; 39     //-- Copy text to edit
; 40     EditFieldViewTextCopy();
	call editfieldviewtextcopy
; 41     //--
; 42     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
; 43     //--
; 44     EditFieldViewLoopKey();
	jp editfieldviewloopkey
; 45 }
; 46 
; 47 void EditFieldViewClose() {
editfieldviewclose:
; 48     //vboxClose();
; 49     CurrentViewReturn();
	call currentviewreturn
; 50     a = EditFieldViewTextIsChanged;
	ld a, (editfieldviewtextischanged)
	ret
; 51 }
; 52 
; 53 void EditFieldViewLoopKey() {
editfieldviewloopkey:
; 54     push_pop(bc, de) {
	push bc
	push de
; 55         b = 0;
	ld b, 0
; 56         do {
__l_450:
; 57             getKeyboardCharA();
	call getkeyboardchara
; 58             c = a;
	ld c, a
; 59             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_453
; 60                 b = 1;
	ld b, 1
	jp __l_454
__l_453:
; 61             } else if ((a = c) == 0x7F) { //Забой... (удаление символа)
	ld a, c
	cp 127
	jp nz, __l_455
; 62                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 63                 if (a > 0) {
	or a
	jp z, __l_457
; 64                     a--;
	dec a
; 65                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
__l_457:
; 66                 }
; 67                 EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
	jp __l_456
__l_455:
; 68             } else if ((a = c) == 0x0D) { // Сохранить и выйти из редактирования
	ld a, c
	cp 13
	jp nz, __l_459
; 69                 a = 1;
	ld a, 1
; 70                 EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 71                 EditFieldViewTextSave();
	call editfieldviewtextsave
; 72                 b = 1;
	ld b, 1
	jp __l_460
__l_459:
; 73             } else if ((a = c) < 0x20) { // ничего не делаем
	ld a, c
	cp 32
	jp nc, __l_461
	jp __l_462
__l_461:
; 74                 
; 75             } else {
; 76                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 77                 if (a < 15) {
	cp 15
	jp nc, __l_463
; 78                     d = 0;
	ld d, 0
; 79                     e = a;
	ld e, a
; 80                     hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 81                     hl += de;
	add hl, de
; 82                     a = c;
	ld a, c
; 83                     //convertKeyToMyFontA(); // перевести данные
; 84                     *hl = a;
	ld (hl), a
; 85                     //--
; 86                     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 87                     a++;
	inc a
; 88                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 89                     //--
; 90                     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
__l_463:
__l_462:
__l_460:
__l_456:
__l_454:
__l_451:
; 91                 }
; 92             }
; 93         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_450
	pop de
	pop bc
; 94     }
; 95     EditFieldViewClose();
	jp editfieldviewclose
; 96 }
; 97 
; 98 void EditFieldViewShowTextValue() {
editfieldviewshowtextvalue:
; 99     //EditFieldViewSetCursore();
; 100     push_pop(bc, hl) {
	push bc
	push hl
; 101         //-- Set color
; 102         bios(c = (a = EditFieldViewColor), a = biosSetColorC);
	ld a, (editfieldviewcolor)
	ld c, a
	ld a, 18
	call bios
; 103         //-- POS
; 104         a = EditFieldViewX;
	ld a, (editfieldviewx)
; 105         a += 1;
	add 1
; 106         l = a;
	ld l, a
; 107         a = EditFieldViewY;
	ld a, (editfieldviewy)
; 108         h = a;
	ld h, a
; 109         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 110         //--
; 111         a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 112         b = a;
	ld b, a
; 113         c = a;
	ld c, a
; 114         hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 115         if ((a = b) > 0) {
	ld a, b
	or a
	jp z, __l_465
; 116             do {
__l_467:
; 117                 push_pop(bc) {
	push bc
; 118                     bios(c = (a = *hl) ,a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
	pop bc
; 119                 }
; 120                 hl++;
	inc hl
; 121                 c--;
	dec c
__l_468:
; 122             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_467
__l_465:
; 123         }
; 124         // Clear
; 125         a = 16; // Max char array
	ld a, 16
; 126         a -= b;
	sub b
; 127         c = a;
	ld c, a
; 128         do {
__l_470:
; 129             push_pop(bc) {
	push bc
; 130                 bios(c = ' ' ,a = biosPrintC);
	ld c, 32
	ld a, 0
	call bios
	pop bc
; 131             }
; 132             c--;
	dec c
__l_471:
; 133         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_470
	pop hl
	pop bc
	ret
; 134         
; 135     }
; 136 }
; 137 
; 138 void EditFieldViewTextCopy() {
editfieldviewtextcopy:
; 139     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 140         hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 141         de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 142         c = 1;
	ld c, 1
; 143         b = 0;
	ld b, 0
; 144         do {
__l_473:
; 145             a = *hl;
	ld a, (hl)
; 146             if (a > 0) {
	or a
	jp z, __l_476
; 147                 b++;
	inc b
; 148                 *de = a;
	ld (de), a
; 149                 hl++;
	inc hl
; 150                 de++;
	inc de
	jp __l_477
__l_476:
; 151             } else {
; 152                 a = b;
	ld a, b
; 153                 EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 154                 c = 0;
	ld c, 0
__l_477:
__l_474:
; 155             }
; 156         } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, __l_473
	pop hl
	pop de
	pop bc
	ret
; 157     }
; 158 }
; 159 
; 160 void EditFieldViewTextSave() {
editfieldviewtextsave:
; 161     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 162     if (a == 0) {
	or a
	jp nz, __l_478
; 163         push_pop(hl) {
	push hl
; 164             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 165             *hl = 0;
	ld (hl), 0
	pop hl
	jp __l_479
__l_478:
; 166         }
; 167     } else {
; 168         push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 169             b = a;
	ld b, a
; 170             de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 171             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 172             do {
__l_480:
; 173                 a = *de;
	ld a, (de)
; 174                 *hl = a;
	ld (hl), a
; 175                 hl++;
	inc hl
; 176                 de++;
	inc de
; 177                 b--;
	dec b
__l_481:
; 178             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_480
; 179             *hl = 0;
	ld (hl), 0
	pop hl
	pop de
	pop bc
__l_479:
	ret
; 180         }
; 181     }
; 182 }
; 183 
; 184 void EditFieldViewSetCursore() {
editfieldviewsetcursore:
; 185     push_pop(hl, a, bc) {
	push hl
	push af
	push bc
; 186         h = (a = EditFieldViewY);
	ld a, (editfieldviewy)
	ld h, a
; 187         l = (a = EditFieldViewEditTextPos);
	ld a, (editfieldviewedittextpos)
	ld l, a
; 188         a = EditFieldViewX;
	ld a, (editfieldviewx)
; 189         a += l;
	add l
; 190         l = a;
	ld l, a
; 191         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 192         bios(a = biosCursorShowC, c = '_');
	ld a, 10
	ld c, 95
	call bios
	pop bc
	pop af
	pop hl
	ret
; 193     }
; 194 }
; 195 
; 196 uint8_t EditFieldViewX = 0;
editfieldviewx:
	db 0
; 197 uint8_t EditFieldViewY = 0;
editfieldviewy:
	db 0
; 198 uint8_t EditFieldViewDX = 0;
editfieldviewdx:
	db 0
; 199 uint8_t EditFieldViewDY = 0;
editfieldviewdy:
	db 0
; 200 uint8_t EditFieldViewColor = 0xA0; //0xF0;
editfieldviewcolor:
	db 160
; 202 uint16_t EditFieldViewTextPoint = 0;
editfieldviewtextpoint:
	dw 0
; 203 uint8_t EditFieldViewEditText[16];
editfieldviewedittext:
	ds 16
; 204 uint8_t EditFieldViewEditTextPos = 0;
editfieldviewedittextpos:
	db 0
; 206 uint8_t EditFieldViewTextIsChanged = 0;
editfieldviewtextischanged:
	db 0
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
__l_483:
; 24             a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 25             a &= ESP_Reg_Ready;
	and 2
; 26             c = a;
	ld c, a
__l_484:
; 27             #ifdef _IS_ESP_DELAY
; 28                 if ((a = c) == 0) {
; 29                     i8255_DelayA(a = 10); //5 200
; 30 //                    b++;
; 31 //                    if ((a = b) >= 100) { //253
; 32 //                        c = ESP_Reg_Ready;
; 33 //                        a = ESPError_TimeOut;
; 34 //                        ESPError = a;
; 35 //                    }
; 36                 }
; 37             #endif
; 38         } while ((a = c) == 0);
	ld a, c
	or a
	jp z, __l_483
	pop bc
	ret
; 39     }
; 40 }
; 41 
; 42 /// Проверка что ESP занят
; 43 void i8255_WaitingForBusy() {
i8255_waitingforbusy:
; 44     do {
__l_486:
; 45         a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 46         a &= ESP_Reg_Busy;
	and 1
__l_487:
; 47     } while (a > 0);
	or a
	jp nz, __l_486
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
; 62         i8255_DelayA(a = 10); //20 40
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
; 70         i8255_DelayA(a = 10); //20 40
; 71     #endif
; 72 }
; 73 
; 74 void i8255_DelayA() {
i8255_delaya:
; 75     do {
__l_489:
; 76         nop();
	nop
; 77         a--;
	dec a
__l_490:
; 78     } while (a > 0);
	or a
	jp nz, __l_489
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
	jp nz, __l_492
; 65             a = c;
	ld a, c
; 66             a |= ESP_Reg_IsEnd;
	or 128
; 67             c = a;
	ld c, a
__l_492:
; 68         }
; 69         ESPSendByteAC(a = h);
	ld a, h
	call espsendbyteac
; 70         if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
	ld a, (esperror)
	or a
	jp nz, __l_494
; 71             //-- Send Data
; 72             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_496
; 73                 b = l;
	ld b, l
; 74                 hl = Net_buffer;
	ld hl, net_buffer
; 75                 do {
__l_498:
; 76                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_501
; 77                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp __l_502
__l_501:
; 78                     } else {
; 79                         c = 0;
	ld c, 0
__l_502:
; 80                     }
; 81                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 82                     if ((a = ESPError) > 0) { // Есть ошибки - выходим
	ld a, (esperror)
	or a
	jp z, __l_503
; 83                         b = 1;
	ld b, 1
__l_503:
; 84                     }
; 85                     hl++;
	inc hl
; 86                     b--;
	dec b
__l_499:
; 87                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_498
__l_496:
__l_494:
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
	jp nz, __l_505
; 103             //-- Send Data
; 104             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_507
; 105                 b = l;
	ld b, l
; 106                 hl = Net_buffer;
	ld hl, net_buffer
; 107                 do {
__l_509:
; 108                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_512
; 109                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp __l_513
__l_512:
; 110                     } else {
; 111                         c = 0;
	ld c, 0
__l_513:
; 112                     }
; 113                     ESPSendByteAC(a = *hl);
	ld a, (hl)
	call espsendbyteac
; 114                     hl++;
	inc hl
; 115                     b--;
	dec b
__l_510:
; 116                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_509
__l_507:
; 117             }
; 118             //-- Get Data
; 119             b = 0;
	ld b, 0
; 120             hl = Net_buffer;
	ld hl, net_buffer
; 121             c = 1;
	ld c, 1
; 122             do {
__l_514:
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
	jp nz, __l_517
; 130                     a = ESP_Reg_In_IsEnd;
	ld a, 8
; 131                     a &= d;
	and d
; 132                     if (a > 0) {
	or a
	jp z, __l_519
; 133                         c = 0;
	ld c, 0
__l_519:
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
	jp nz, __l_521
; 140                         c = 0;
	ld c, 0
__l_521:
	jp __l_518
__l_517:
; 141                     }
; 142                 } else {
; 143                     c = 0;
	ld c, 0
__l_518:
__l_515:
; 144                 }
; 145             } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, __l_514
; 146             l = b;
	ld l, b
__l_505:
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
; 11 void ESPErrorParserA() {
esperrorparsera:
; 12     if (a > 0) {
	or a
	jp z, __l_523
; 13         push_pop(bc) {
	push bc
; 14             b = a;
	ld b, a
; 15             if ((a = b) == ESPError_FtpDeleteFileError) {
	ld a, b
	cp 1
	jp nz, __l_525
; 16                 AllertOkViewShowHL(hl = StringLocaleNetFtpDeleteFileError);
	ld hl, stringlocalenetftpdeletefileerro
	call allertokviewshowhl
	jp __l_526
__l_525:
; 17             } else if ((a = b) == ESPError_FtpConnectError) {
	ld a, b
	cp 2
	jp nz, __l_527
; 18                 AllertOkViewShowHL(hl = StringLocaleNetFtpConnectError);
	ld hl, stringlocalenetftpconnecterror
	call allertokviewshowhl
	jp __l_528
__l_527:
; 19             } else if ((a = b) == ESPError_WiFiConnectError) {
	ld a, b
	cp 3
	jp nz, __l_529
; 20                 AllertOkViewShowHL(hl = StringLocaleNetWiFiConnectError);
	ld hl, stringlocalenetwificonnecterror
	call allertokviewshowhl
__l_529:
__l_528:
__l_526:
	pop bc
; 21             }
; 22         }
; 23         // Сброс ошибки
; 24         NetErrorClear();
	call neterrorclear
__l_523:
	ret
; 11 void NetSetIsDsDos() {
netsetisdsdos:
; 12     push_pop(hl) {
	push hl
; 13         hl = Net_buffer;
	ld hl, net_buffer
; 14         *hl = (a = 1);
	ld a, 1
	ld (hl), a
; 15         h = 38; // SET_IS_DSDOS, // 38
	ld h, 38
; 16         l = 1; // Len NedBuffer
	ld l, 1
; 17         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 18     }
; 19 }
; 20 
; 21 void NetErrorClear() {
neterrorclear:
; 22     push_pop(hl) {
	push hl
; 23         h = 30; // ESP_ERROR_CLEAR, // 30
	ld h, 30
; 24         l = 0; // Len NedBuffer
	ld l, 0
; 25         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 26     }
; 27 }
; 28 
; 29 void NetGetAllStatus() {
netgetallstatus:
; 30     push_pop(hl) {
	push hl
; 31         h = 20; //  GET_STATUS, // 20
	ld h, 20
; 32         l = 0; // Len NedBuffer
	ld l, 0
; 33         ESPSendAndGetHL();
	call espsendandgethl
; 34         //--
; 35         NetGetAllStatusParse();
	call netgetallstatusparse
	pop hl
	ret
; 36     }
; 37 }
; 38 
; 39 // Вых [A] - 1 - Успешно. 0 - Ошибка
; 40 void NetDiskGetNum() {
netdiskgetnum:
; 41     push_pop(hl, bc) {
	push hl
	push bc
; 42         h = 35; // GET_DISK, // 35
	ld h, 35
; 43         l = 0; // Len NedBuffer
	ld l, 0
; 44         ESPSendAndGetHL();
	call espsendandgethl
; 45         ParserDiskResponse();
	call parserdiskresponse
	pop bc
	pop hl
	ret
; 46     }
; 47 }
; 48 
; 49 void NetDiskSetNum() {
netdisksetnum:
; 50     push_pop(hl, bc) {
	push hl
	push bc
; 51         ParserDiskRequest();
	call parserdiskrequest
; 52         h = 36; // SET_DISK, // 36
	ld h, 36
; 53         l = 3; // Len NedBuffer
	ld l, 3
; 54         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 55     }
; 56 }
; 57 
; 58 void NetWiFiGetSsidIp() {
netwifigetssidip:
; 59     push_pop(hl, bc) {
	push hl
	push bc
; 60         h = 3; // GET_SSID_IP, // 3
	ld h, 3
; 61         l = 0; // Len NedBuffer
	ld l, 0
; 62         ESPSendAndGetHL();
	call espsendandgethl
; 63         b = 16;
	ld b, 16
; 64         c = l;
	ld c, l
; 65         hl = WiFiSettingsViewIpValue;
	ld hl, wifisettingsviewipvalue
; 66         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 67     }
; 68 }
; 69 
; 70 void NetWiFiGetSsidPassword() {
netwifigetssidpassword:
; 71     push_pop(hl, bc) {
	push hl
	push bc
; 72         h = 1; // GET_SSID_PASSWORD, // 1
	ld h, 1
; 73         l = 0; // Len NedBuffer
	ld l, 0
; 74         ESPSendAndGetHL();
	call espsendandgethl
; 75         b = 16;
	ld b, 16
; 76         c = l;
	ld c, l
; 77         hl = WiFiSettingsViewPassValue;
	ld hl, wifisettingsviewpassvalue
; 78         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 79     }
; 80 }
; 81 
; 82 void NetWiFiSetSsidPassword() {
netwifisetssidpassword:
; 83     push_pop(hl, bc) {
	push hl
	push bc
; 84         hl = WiFiSettingsViewPassValue;
	ld hl, wifisettingsviewpassvalue
; 85         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 86         h = 2; // SET_SSID_PASSWORD, // 2
	ld h, 2
; 87         l = 16; // Len NedBuffer
	ld l, 16
; 88         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 89     }
; 90 }
; 91 
; 92 void NetWiFiGetSsidMac() {
netwifigetssidmac:
; 93     push_pop(hl, bc) {
	push hl
	push bc
; 94         h = 4; // GET_SSID_MAC, // 4
	ld h, 4
; 95         l = 0; // Len NedBuffer
	ld l, 0
; 96         ESPSendAndGetHL();
	call espsendandgethl
; 97         b = 18;
	ld b, 18
; 98         c = l;
	ld c, l
; 99         hl = WiFiSettingsViewMacValue;
	ld hl, wifisettingsviewmacvalue
; 100         ParserBufferSumToHL();
	call parserbuffersumtohl
	pop bc
	pop hl
	ret
; 101     }
; 102 }
; 103 
; 104 void NetWiFiGetSsid() {
netwifigetssid:
; 105     push_pop(hl, bc) {
	push hl
	push bc
; 106         h = 5; // GET_SSID, // 5
	ld h, 5
; 107         l = 0; // Len NedBuffer
	ld l, 0
; 108         ESPSendAndGetHL();
	call espsendandgethl
; 109         b = 16;
	ld b, 16
; 110         c = l;
	ld c, l
; 111         hl = WiFiSettingsViewSsidValue;
	ld hl, wifisettingsviewssidvalue
; 112         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 113     }
; 114 }
; 115 
; 116 void NetWiFiSetListA() {
netwifisetlista:
; 117     push_pop(hl) {
	push hl
; 118         hl = Net_buffer;
	ld hl, net_buffer
; 119         *hl = a;
	ld (hl), a
; 120         h = 18; // SSID_SET_LIST_ID, // 18
	ld h, 18
; 121         l = 1; // Len NedBuffer
	ld l, 1
; 122         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 123     }
; 124 }
; 125 
; 126 void NetWiFiConnect() {
netwificonnect:
; 127     push_pop(hl) {
	push hl
; 128         h = 19; // SSID_CONNECT, // 19
	ld h, 19
; 129         l = 0; // Len NedBuffer
	ld l, 0
; 130         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 131     }
; 132 }
; 133 
; 134 void NetWiFiListUpdate() {
netwifilistupdate:
; 135     push_pop(hl) {
	push hl
; 136         h = 16; // SSID_LIST_UPDATE, // 16
	ld h, 16
; 137         l = 0; // Len NedBuffer
	ld l, 0
; 138         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 139     }
; 140 }
; 141 
; 142 void NetWiFiGetList() {
netwifigetlist:
; 143     a = 0;
	ld a, 0
; 144     WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
; 145     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 146         c = 0;
	ld c, 0
; 147         do {
__l_531:
; 148             h = 17; // SSID_LIST_NEXT, // 17
	ld h, 17
; 149             l = 0; // Len NedBuffer
	ld l, 0
; 150             ESPSendAndGetHL();
	call espsendandgethl
; 151             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_534
; 152                 b = l;
	ld b, l
; 153                 //--
; 154                 hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 155                 d = 0;
	ld d, 0
; 156                 a ^= a;
	xor a
; 157                 a = c;
	ld a, c
; 158                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 159                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_536
; 160                     d++;
	inc d
__l_536:
; 161                 }
; 162                 e = a;
	ld e, a
; 163                 hl += de;
	add hl, de
; 164                 push_pop(bc) {
	push bc
; 165                     c = b;
	ld c, b
; 166                     b = 16;
	ld b, 16
; 167                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 168                 }
; 169                 //--
; 170                 c++;
	inc c
__l_534:
__l_532:
; 171             }
; 172         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_531
; 173         a = c;
	ld a, c
; 174         WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
	pop de
	pop bc
	pop hl
	ret
; 175     }
; 176 }
; 177 
; 178 /// --- FTP ---
; 179 void NetFtpConnect() {
netftpconnect:
; 180     push_pop(hl) {
	push hl
; 181         h = 23; // FTP_CONNECT, // 23
	ld h, 23
; 182         l = 0; // Len NedBuffer
	ld l, 0
; 183         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 184     }
; 185 }
; 186 
; 187 void NetFtpGetHomeDir() {
netftpgethomedir:
; 188     push_pop(hl, bc) {
	push hl
	push bc
; 189         h = 12; // GET_FTP_HOME_DIR, // 12
	ld h, 12
; 190         l = 0; // Len NedBuffer
	ld l, 0
; 191         ESPSendAndGetHL();
	call espsendandgethl
; 192         b = 16;
	ld b, 16
; 193         c = l;
	ld c, l
; 194         hl = FtpSettingsViewValueHomeDir;
	ld hl, ftpsettingsviewvaluehomedir
; 195         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 196     }
; 197 }
; 198 
; 199 void NetFtpSetHomeDir() {
netftpsethomedir:
; 200     push_pop(hl, bc) {
	push hl
	push bc
; 201         hl = FtpSettingsViewValueHomeDir;
	ld hl, ftpsettingsviewvaluehomedir
; 202         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 203         h = 13; // SET_FTP_HOME_DIR, // 13
	ld h, 13
; 204         l = 16; // Len NedBuffer
	ld l, 16
; 205         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 206     }
; 207 }
; 208 
; 209 void NetFtpGetUser() {
netftpgetuser:
; 210     push_pop(hl, bc) {
	push hl
	push bc
; 211         h = 8; // GET_FTP_USER, // 8
	ld h, 8
; 212         l = 0; // Len NedBuffer
	ld l, 0
; 213         ESPSendAndGetHL();
	call espsendandgethl
; 214         b = 16;
	ld b, 16
; 215         c = l;
	ld c, l
; 216         hl = FtpSettingsViewValueUser;
	ld hl, ftpsettingsviewvalueuser
; 217         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 218     }
; 219 }
; 220 
; 221 void NetFtpSetUser() {
netftpsetuser:
; 222     push_pop(hl, bc) {
	push hl
	push bc
; 223         hl = FtpSettingsViewValueUser;
	ld hl, ftpsettingsviewvalueuser
; 224         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 225         h = 9; // SET_FTP_USER, // 9
	ld h, 9
; 226         l = 16; // Len NedBuffer
	ld l, 16
; 227         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 228     }
; 229 }
; 230 
; 231 void NetFtpGetPassword() {
netftpgetpassword:
; 232     push_pop(hl, bc) {
	push hl
	push bc
; 233         h = 10; // GET_FTP_PASS, // 10
	ld h, 10
; 234         l = 0; // Len NedBuffer
	ld l, 0
; 235         ESPSendAndGetHL();
	call espsendandgethl
; 236         b = 16;
	ld b, 16
; 237         c = l;
	ld c, l
; 238         hl = FtpSettingsViewValuePass;
	ld hl, ftpsettingsviewvaluepass
; 239         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 240     }
; 241 }
; 242 
; 243 void NetFtpSetPassword() {
netftpsetpassword:
; 244     push_pop(hl, bc) {
	push hl
	push bc
; 245         hl = FtpSettingsViewValuePass;
	ld hl, ftpsettingsviewvaluepass
; 246         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 247         h = 11; // SET_FTP_PASS, // 11
	ld h, 11
; 248         l = 16; // Len NedBuffer
	ld l, 16
; 249         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 250     }
; 251 }
; 252 
; 253 void NetFtpGetUrl() {
netftpgeturl:
; 254     push_pop(hl, bc) {
	push hl
	push bc
; 255         h = 6; // GET_FTP_URL, // 6
	ld h, 6
; 256         l = 0; // Len NedBuffer
	ld l, 0
; 257         ESPSendAndGetHL();
	call espsendandgethl
; 258         b = 16;
	ld b, 16
; 259         c = l;
	ld c, l
; 260         hl = FtpHeaderViewIpValue;
	ld hl, ftpheaderviewipvalue
; 261         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 262     }
; 263 }
; 264 
; 265 void NetFtpSetUrl() {
netftpseturl:
; 266     push_pop(hl, bc) {
	push hl
	push bc
; 267         hl = FtpHeaderViewIpValue;
	ld hl, ftpheaderviewipvalue
; 268         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 269         h = 7; // SET_FTP_URL, // 7
	ld h, 7
; 270         l = 16; // Len NedBuffer
	ld l, 16
; 271         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 272     }
; 273 }
; 274 
; 275 void NetFtpGetPort() {
netftpgetport:
; 276     push_pop(hl, bc) {
	push hl
	push bc
; 277         h = 14; // GET_FTP_PORT, // 14
	ld h, 14
; 278         l = 0; // Len NedBuffer
	ld l, 0
; 279         ESPSendAndGetHL();
	call espsendandgethl
; 280         b = 6;
	ld b, 6
; 281         c = l;
	ld c, l
; 282         hl = FtpSettingsViewValuePort;
	ld hl, ftpsettingsviewvalueport
; 283         ParserBufferToHL();
	call parserbuffertohl
	pop bc
	pop hl
	ret
; 284     }
; 285 }
; 286 
; 287 void NetFtpSetPort() {
netftpsetport:
; 288     push_pop(hl, bc) {
	push hl
	push bc
; 289         hl = FtpSettingsViewValuePort;
	ld hl, ftpsettingsviewvalueport
; 290         ParserHLToBuffer(b = 16);
	ld b, 16
	call parserhltobuffer
; 291         h = 15; // SET_FTP_PORT, // 15
	ld h, 15
; 292         l = 6; // Len NedBuffer
	ld l, 6
; 293         ESPSendHL();
	call espsendhl
	pop bc
	pop hl
	ret
; 294     }
; 295 }
; 296 
; 297 void NetFtpGetCurrentPath() {
netftpgetcurrentpath:
; 298     push_pop(hl) {
	push hl
; 299         h = 22; //  GET_FTP_CURRENT_FOLDER, // 22
	ld h, 22
; 300         l = 0; // Len NedBuffer
	ld l, 0
; 301         ESPSendAndGetHL();
	call espsendandgethl
; 302         b = 16;
	ld b, 16
; 303         c = l;
	ld c, l
; 304         hl = FtpViewPath;
	ld hl, ftpviewpath
; 305         ParserBufferToHL();
	call parserbuffertohl
	pop hl
	ret
; 306     }
; 307 }
; 308 
; 309 void NetFtpUpdateList() {
netftpupdatelist:
; 310     push_pop(hl) {
	push hl
; 311         hl = Net_buffer;
	ld hl, net_buffer
; 312         a = 20; // Получить 20 файлов
	ld a, 20
; 313         *hl = a;
	ld (hl), a
; 314         h = 26; // FTP_UPDATE_LIST, // 26
	ld h, 26
; 315         l = 1; // Len NedBuffer
	ld l, 1
; 316         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 317     }
; 318 }
; 319 
; 320 void NetFtpListFiles() {
netftplistfiles:
; 321     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 322         a = 0;
	ld a, 0
; 323         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
; 324         c = 0;
	ld c, 0
; 325         do {
__l_538:
; 326             //--
; 327             hl = Net_buffer;
	ld hl, net_buffer
; 328             a = NetFtpListFilesParseSumState;
	ld a, (netftplistfilesparsesumstate)
; 329             *hl = a;
	ld (hl), a
; 330             //--
; 331             h = 27; // FTP_LIST_FILE_NEXT, // 27
	ld h, 27
; 332             l = 1; // Len NedBuffer
	ld l, 1
; 333             ESPSendAndGetHL();
	call espsendandgethl
; 334             //--
; 335             NetFtpListFilesParse(); // пока l > 0 (ответ от ESP что то содержит)
	call netftplistfilesparse
__l_539:
; 336         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_538
; 337         a = c;
	ld a, c
; 338         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
	pop de
	pop bc
	pop hl
	ret
; 339     }
; 340 }
; 341 
; 342 void NetFtpChangeDirUp() {
netftpchangedirup:
; 343     push_pop(hl) {
	push hl
; 344         h = 24; // SET_FTP_CHANGE_DIR_UP, // 24
	ld h, 24
; 345         l = 0; // Len NedBuffer
	ld l, 0
; 346         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 347     }
; 348 }
; 349 
; 350 void NetFtpChangeDirIndexA() {
netftpchangedirindexa:
; 351     push_pop(hl) {
	push hl
; 352         hl = Net_buffer;
	ld hl, net_buffer
; 353         *hl = a;
	ld (hl), a
; 354         h = 25; // SET_FTP_CHANGE_DIR_INDEX, // 25
	ld h, 25
; 355         l = 1; // Len NedBuffer
	ld l, 1
; 356         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 357     }
; 358 }
; 359 
; 360 void NetFtpGoToHomeDir() {
netftpgotohomedir:
; 361     push_pop(hl) {
	push hl
; 362         h = 21; // SET_FTP_TO_HOME_DIR, // 21
	ld h, 21
; 363         l = 0; // Len NedBuffer
	ld l, 0
; 364         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 365     }
; 366 }
; 367 
; 368 void NetFtpDeleteFileIndexA() {
netftpdeletefileindexa:
; 369     push_pop(hl) {
	push hl
; 370         hl = Net_buffer;
	ld hl, net_buffer
; 371         *hl = a;
	ld (hl), a
; 372         h = 31; // FTP_FILE_DELETE_INDEX, // 31
	ld h, 31
; 373         l = 1; // Len NedBuffer
	ld l, 1
; 374         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 375     }
; 376 }
; 377 
; 378 void NetFtpLoadFileA() {
netftploadfilea:
; 379     push_pop(hl) {
	push hl
; 380         hl = Net_buffer;
	ld hl, net_buffer
; 381         *hl = a;
	ld (hl), a
; 382         h = 28; // FTP_FILE_DOWNLOAD, // 28
	ld h, 28
; 383         l = 1; // Len NedBuffer
	ld l, 1
; 384         ESPSendHL();
	call espsendhl
	pop hl
	ret
; 385     }
; 386 }
; 387 
; 388 void NetFtpLoadFileNext() {
netftploadfilenext:
; 389     push_pop(hl, bc) {
	push hl
	push bc
; 390         b = 0;
	ld b, 0
; 391         a = 1;
	ld a, 1
; 392         FileParserSumStateNext = a;
	ld (fileparsersumstatenext), a
; 393         do {
__l_541:
; 394             //--
; 395             hl = Net_buffer;
	ld hl, net_buffer
; 396             a = FileParserSumStateNext;
	ld a, (fileparsersumstatenext)
; 397             *hl = a;
	ld (hl), a
; 398             //--
; 399             h = 29; // FTP_FILE_DOWNLOAD_NEXT, // 29
	ld h, 29
; 400             l = 1; // Len NedBuffer
	ld l, 1
; 401             ESPSendAndGetHL();
	call espsendandgethl
; 402             //--
; 403             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_544
; 404                 FileParserFtpLoadFileNextParse();
	call fileparserftploadfilenextparse
; 405                 if ((a = FileParserSumStateNext) == 0x01) {
	ld a, (fileparsersumstatenext)
	cp 1
	jp nz, __l_546
; 406                     if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_548
; 407                         b = l;
	ld b, l
	jp __l_549
__l_548:
; 408                     } else {
; 409                         if ((a = l) < b) {
	ld a, l
	cp b
	jp nc, __l_550
; 410                             l = 0; // Новый пакет короче старого - скорее всего больше нет данных
	ld l, 0
	jp __l_551
__l_550:
; 411                         } else {
; 412                             b = l;
	ld b, l
__l_551:
__l_549:
__l_546:
__l_544:
__l_542:
; 413                         }
; 414                     }
; 415                 }
; 416             }
; 417         } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, __l_541
	pop bc
	pop hl
	ret
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
	jp c, __l_552
; 21         a = 0;
	ld a, 0
; 22         ThreadsTickCount = a;
	ld (threadstickcount), a
; 23         //--
; 24         ThreadsNetUpdateState();
	call threadsnetupdatestate
	jp __l_553
__l_552:
; 25     } else {
; 26         ThreadsTickCountNext();
	call threadstickcountnext
__l_553:
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
	jp nz, __l_554
; 34         NetGetAllStatus();
	call netgetallstatus
; 35         ThreadsNetNeedStateChange();
	call threadsnetneedstatechange
__l_554:
	ret
; 36     }
; 37 }
; 38 
; 39 void ThreadsNetNeedStateChange() {
threadsnetneedstatechange:
; 40     if ((a = WiFiNetStateChange) == 1) {
	ld a, (wifinetstatechange)
	cp 1
	jp nz, __l_556
; 41         ThreadsNetNeedUpdateWiFiData();
	call threadsnetneedupdatewifidata
; 42         a = 0;
	ld a, 0
; 43         WiFiNetStateChange = a;
	ld (wifinetstatechange), a
__l_556:
; 44     }
; 45     if ((a = FtpNetStateChange) == 1) {
	ld a, (ftpnetstatechange)
	cp 1
	jp nz, __l_558
; 46         ThreadsNetNeedUpdateFtpData();
	call threadsnetneedupdateftpdata
; 47         a = 0;
	ld a, 0
; 48         FtpNetStateChange = a;
	ld (ftpnetstatechange), a
__l_558:
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
	jp nz, __l_560
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
	jp __l_561
__l_560:
; 65         } else {
; 66             hl--;
	dec hl
__l_561:
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
__l_562:
; 76             bc--;
	dec bc
; 77             a = b;
	ld a, b
; 78             a |= c;
	or c
__l_563:
	jp nz, __l_562
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
	jp nz, __l_565
; 86         DiskViewReload();
	call diskviewreload
__l_565:
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
; 98     WiFiHeaderViewShowValue();
	jp wifiheaderviewshowvalue
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
; 114     WiFiHeaderViewShowValue();
	jp wifiheaderviewshowvalue
; 115 }
; 116 
; 117 void ThreadsNetSsidUpdateA() {
threadsnetssidupdatea:
; 118     NetWiFiSetListA();
	call netwifisetlista
; 119     NetWiFiGetSsid();
	call netwifigetssid
; 120     WiFiHeaderViewShowValue();
	jp wifiheaderviewshowvalue
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
	jp z, __l_567
; 134             a = 0x01;
	ld a, 1
; 135             WiFiNetStateChange = a;
	ld (wifinetstatechange), a
__l_567:
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
; 144     FtpHeaderViewShowValue();
	call ftpheaderviewshowvalue
; 145     // Update ftp dir
; 146     NetSetIsDsDos();
	call netsetisdsdos
; 147     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 148     FtpViewShowPath();
	call ftpviewshowpath
; 149     
; 150     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 151     if (a == 1) {
	cp 1
	jp nz, __l_569
; 152         if ((a = FtpHeaderViewStatus) == 1) {
	ld a, (ftpheaderviewstatus)
	cp 1
	jp nz, __l_571
; 153             NetSetIsDsDos();
	call netsetisdsdos
; 154             NetFtpUpdateList();
	call netftpupdatelist
; 155             NetFtpListFiles();
	call netftplistfiles
	jp __l_572
__l_571:
; 156         } else {
; 157             FtpViewEmptyList();
	call ftpviewemptylist
__l_572:
; 158         }
; 159         FtpViewListUpdateUI();
	call ftpviewlistupdateui
__l_569:
	ret
; 160     }
; 161 }
; 162 
; 163 void ThreadsNetNeedUpdateFtpValue() {
threadsnetneedupdateftpvalue:
; 164     NetFtpGetUrl();
	call netftpgeturl
; 165     NetFtpGetHomeDir();
	call netftpgethomedir
; 166     NetFtpGetPort();
	call netftpgetport
; 167     NetFtpGetUser();
	call netftpgetuser
; 168     NetFtpGetPassword();
	call netftpgetpassword
; 169     // UI
; 170     FtpHeaderViewShowValue();
	jp ftpheaderviewshowvalue
; 171 }
; 172 
; 173 void ThreadsNetFtpHomeDirUpdate() {
threadsnetftphomedirupdate:
; 174     NetFtpSetHomeDir();
	call netftpsethomedir
; 175     NetFtpGetHomeDir();
	jp netftpgethomedir
; 176 }
; 177 
; 178 void ThreadsNetFtpUserUpdate() {
threadsnetftpuserupdate:
; 179     NetFtpSetUser();
	call netftpsetuser
; 180     NetFtpGetUser();
	jp netftpgetuser
; 181 }
; 182 
; 183 void ThreadsNetFtpPasswordUpdate() {
threadsnetftppasswordupdate:
; 184     NetFtpSetPassword();
	call netftpsetpassword
; 185     NetFtpGetPassword();
	jp netftpgetpassword
; 186 }
; 187 
; 188 void ThreadsNetFtpServerUrlUpdate() {
threadsnetftpserverurlupdate:
; 189     NetFtpSetUrl();
	call netftpseturl
; 190     NetFtpGetUrl();
	jp netftpgeturl
; 191 }
; 192 
; 193 void ThreadsNetFtpPortUpdate() {
threadsnetftpportupdate:
; 194     NetFtpSetPort();
	call netftpsetport
; 195     NetFtpGetPort();
	jp netftpgetport
; 196 }
; 197 
; 198 void ThreadsNetFtpGoToHomeDir() {
threadsnetftpgotohomedir:
; 199     NetFtpGoToHomeDir();
	call netftpgotohomedir
; 200     NetSetIsDsDos();
	call netsetisdsdos
; 201     NetFtpGetCurrentPath();
	call netftpgetcurrentpath
; 202     FtpViewShowPath();
	call ftpviewshowpath
; 203     if ((a = FtpHeaderViewStatus) == 1) {
	ld a, (ftpheaderviewstatus)
	cp 1
	jp nz, __l_573
; 204         NetFtpUpdateList();
	call netftpupdatelist
; 205         NetFtpListFiles();
	call netftplistfiles
	jp __l_574
__l_573:
; 206     } else {
; 207         FtpViewEmptyList();
	call ftpviewemptylist
__l_574:
; 208     }
; 209     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 210 }
; 211 
; 212 void ThreadsNetFtpDeleteFileA() {
threadsnetftpdeletefilea:
; 213     NetFtpDeleteFileIndexA();
	call netftpdeletefileindexa
; 214     NetSetIsDsDos();
	call netsetisdsdos
; 215     NetFtpUpdateList();
	call netftpupdatelist
; 216     NetFtpListFiles();
	call netftplistfiles
; 217     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 218 }
; 219 
; 220 void ThreadsNetSetFtpStateA() {
threadsnetsetftpstatea:
; 221     push_pop(bc) {
	push bc
; 222         a &= 0x01;
	and 1
; 223         b = a;
	ld b, a
; 224         // Old Value
; 225         a = FtpHeaderViewStatus;
	ld a, (ftpheaderviewstatus)
; 226         c = a;
	ld c, a
; 227         // --
; 228         a = b;
	ld a, b
; 229         FtpHeaderViewStatus = a;
	ld (ftpheaderviewstatus), a
; 230         if(a != c){
	cp c
	jp z, __l_575
; 231             a = 0x01;
	ld a, 1
; 232             FtpNetStateChange = a;
	ld (ftpnetstatechange), a
__l_575:
	pop bc
	ret
; 233         }
; 234     }
; 235 }
; 236 
; 237 void ThreadsNetDetectError() {
threadsnetdetecterror:
; 238     push_pop(bc, hl) {
	push bc
	push hl
; 239         if ((a = ESPError) > 0) {
	ld a, (esperror)
	or a
	jp z, __l_577
; 240             b = a;
	ld b, a
; 241             // Clear error
; 242             a = 0;
	ld a, 0
; 243             ESPError = a;
	ld (esperror), a
; 244             //-- ENUM
; 245             if ((a = b) == ESPError_TimeOut) {
	ld a, b
	cp 1
	jp nz, __l_579
; 246                 AllertOkViewShowHL(hl = StringLocaleNetTimeOut);
	ld hl, stringlocalenettimeout
	call allertokviewshowhl
__l_579:
__l_577:
	pop hl
	pop bc
	ret
; 247             }
; 248         }
; 249     }
; 250 }
; 251 
; 252 uint16_t ThreadsTickSubCount = 0x0000;
threadsticksubcount:
	dw 0
; 253 uint8_t ThreadsTickCount = 0;
threadstickcount:
	db 0
; 11 void NetGetAllStatusParse() {
netgetallstatusparse:
; 12     if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_581
; 13         NetGetAllStatusParseSum();
	call netgetallstatusparsesum
; 14         if ((a = NetGetAllStatusParseSumState) == 1) {
	ld a, (netgetallstatusparsesumstate)
	cp 1
	jp nz, __l_583
; 15             hl = Net_buffer;
	ld hl, net_buffer
; 16             //-- 0x3C
; 17             hl++;
	inc hl
; 18             //-- WIFIflag
; 19             ThreadsNetSetWiFiStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetwifistatea
; 20             hl++;
	inc hl
; 21             //-- FtpConnected
; 22             ThreadsNetSetFtpStateA(a = *hl);
	ld a, (hl)
	call threadsnetsetftpstatea
; 23             hl++;
	inc hl
; 24             //-- espError
; 25             ESPErrorParserA(a = *hl);
	ld a, (hl)
	call esperrorparsera
; 26             hl++;
	inc hl
__l_583:
__l_581:
	ret
; 27         }
; 28     }
; 29 }
; 30 
; 31 void NetGetAllStatusParseSum() {
netgetallstatusparsesum:
; 32     push_pop(hl, bc) {
	push hl
	push bc
; 33         b = l;
	ld b, l
; 34         b--;
	dec b
; 35         hl = Net_buffer;
	ld hl, net_buffer
; 36         c = 0;
	ld c, 0
; 37         a = *hl;
	ld a, (hl)
; 38         if (a == 0x3C) {
	cp 60
	jp nz, __l_585
; 39             do {
__l_587:
; 40                 a = *hl;
	ld a, (hl)
; 41                 a += c;
	add c
; 42                 c = a;
	ld c, a
; 43                 hl++;
	inc hl
; 44                 b--;
	dec b
__l_588:
; 45             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_587
; 46             a = *hl;
	ld a, (hl)
; 47             if (a == c) {
	cp c
	jp nz, __l_590
; 48                 a = 0x01;
	ld a, 1
; 49                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
	jp __l_591
__l_590:
; 50             } else {
; 51                 a = 0x00;
	ld a, 0
; 52                 NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
__l_591:
	jp __l_586
__l_585:
; 53             }
; 54         } else {
; 55             a = 0x00;
	ld a, 0
; 56             NetGetAllStatusParseSumState = a;
	ld (netgetallstatusparsesumstate), a
__l_586:
	pop bc
	pop hl
	ret
; 57         }
; 58     }
; 59 }
; 60 
; 61 void ParserDiskRequest() {
parserdiskrequest:
; 62     push_pop(de, bc) {
	push de
	push bc
; 63         // SUMM
; 64         c = 0;
	ld c, 0
; 65         //-- Buffer
; 66         de = Net_buffer;
	ld de, net_buffer
; 67         // - init
; 68         a = 0x3C;
	ld a, 60
; 69         *de = a;
	ld (de), a
; 70         de++;
	inc de
; 71         a += c;
	add c
; 72         c = a;
	ld c, a
; 73         // - disk
; 74         push_pop(bc) {
	push bc
; 75             bios(a = biosGetDiskC);
	ld a, 132
	call bios
; 76             a = c;
	ld a, c
	pop bc
; 77         }
; 78         *de = a;
	ld (de), a
; 79         de++;
	inc de
; 80         a += c;
	add c
; 81         c = a;
	ld c, a
; 82         // - summ
; 83         a = c;
	ld a, c
; 84         *de = a;
	ld (de), a
	pop bc
	pop de
	ret
; 85     }
; 86 }
; 87 
; 88 // Вых [A] - 1 - Успешно. 0 - Ошибка
; 89 void ParserDiskResponse() {
parserdiskresponse:
; 90     ParserDiskResponseSum();
	call parserdiskresponsesum
; 91     if (a == 1) {
	cp 1
	jp nz, __l_592
; 92         push_pop(de, bc) {
	push de
	push bc
; 93             de = Net_buffer;
	ld de, net_buffer
; 94             // init == 0x3C
; 95             a = *de;
	ld a, (de)
; 96             de++;
	inc de
; 97             if (a == 0x3C) {
	cp 60
	jp nz, __l_594
; 98                 a = *de;
	ld a, (de)
; 99                 bios(c = a , a = biosSetDiskC);
	ld c, a
	ld a, 131
	call bios
; 100                 a = 1;
	ld a, 1
	jp __l_595
__l_594:
; 101             } else {
; 102                 a = 0;
	ld a, 0
__l_595:
	pop bc
	pop de
	jp __l_593
__l_592:
; 103             }
; 104         }
; 105     } else {
; 106         a = 0;
	ld a, 0
__l_593:
	ret
; 107     }
; 108 }
; 109 
; 110 void ParserDiskResponseSum() {
parserdiskresponsesum:
; 111     push_pop(de, bc) {
	push de
	push bc
; 112         de = Net_buffer;
	ld de, net_buffer
; 113         b = 2;
	ld b, 2
; 114         c = 0;
	ld c, 0
; 115         do {
__l_596:
; 116             a = *de;
	ld a, (de)
; 117             a += c;
	add c
; 118             c = a;
	ld c, a
; 119             de++;
	inc de
; 120             b--;
	dec b
__l_597:
; 121         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_596
; 122         a = *de;
	ld a, (de)
; 123         if (a == c) {
	cp c
	jp nz, __l_599
; 124             a = 1;
	ld a, 1
	jp __l_600
__l_599:
; 125         } else {
; 126             a = 0;
	ld a, 0
__l_600:
	pop bc
	pop de
	ret
; 127         }
; 128     }
; 129 }
; 130 
; 131 /// HL - point Str
; 132 /// B - Len Str
; 133 /// C - Len buffer
; 134 void ParserBufferToHL() {
parserbuffertohl:
; 135     push_pop(de) {
	push de
; 136         de = Net_buffer;
	ld de, net_buffer
; 137         do {
__l_601:
; 138             if ((a = c) > 0) {
	ld a, c
	or a
	jp z, __l_604
; 139                 a = *de;
	ld a, (de)
; 140                 *hl = a;
	ld (hl), a
; 141                 c--;
	dec c
; 142                 de++;
	inc de
	jp __l_605
__l_604:
; 143             } else {
; 144                 a = 0;
	ld a, 0
; 145                 *hl = a;
	ld (hl), a
__l_605:
; 146             }
; 147             hl++;
	inc hl
; 148             b--;
	dec b
__l_602:
; 149         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_601
	pop de
	ret
; 150     }
; 151 }
; 152 
; 153 void ParserHLToBuffer() {
parserhltobuffer:
; 154     push_pop(bc, de) {
	push bc
	push de
; 155         de = Net_buffer;
	ld de, net_buffer
; 156         do {
__l_606:
; 157             a = *hl;
	ld a, (hl)
; 158             *de = a;
	ld (de), a
; 159             hl++;
	inc hl
; 160             de++;
	inc de
; 161             b--;
	dec b
__l_607:
; 162         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_606
	pop de
	pop bc
	ret
; 163     }
; 164 }
; 165 
; 166 /// HL - point Str
; 167 /// B - Len Str
; 168 /// C - Len buffer
; 169 void ParserBufferSumToHL() {
parserbuffersumtohl:
; 170     ParserBufferSumToHLSum();
	call parserbuffersumtohlsum
; 171     if ((a = ParserBufferSumToHLSumState) == 1) {
	ld a, (parserbuffersumtohlsumstate)
	cp 1
	jp nz, __l_609
; 172         push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 173             de = Net_buffer;
	ld de, net_buffer
; 174             c--;
	dec c
; 175             c--;
	dec c
; 176             do {
__l_611:
; 177                 if ((a = c) > 0) {
	ld a, c
	or a
	jp z, __l_614
; 178                     a = *de;
	ld a, (de)
; 179                     *hl = a;
	ld (hl), a
; 180                     de++;
	inc de
; 181                     c--;
	dec c
	jp __l_615
__l_614:
; 182                 } else {
; 183                     *hl = 0;
	ld (hl), 0
__l_615:
; 184                 }
; 185                 hl++;
	inc hl
; 186                 b--;
	dec b
__l_612:
; 187             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_611
	pop de
	pop bc
	pop hl
	jp __l_610
__l_609:
; 188         }
; 189     } else {
__l_610:
	ret
; 190         //ParserBufferErrorSumShow();
; 191     }
; 192 }
; 193 
; 194 void ParserBufferSumToHLSum() {
parserbuffersumtohlsum:
; 195     push_pop(hl, bc) {
	push hl
	push bc
; 196         if ((a = c) >= 3) {
	ld a, c
	cp 3
	jp c, __l_616
; 197             b = c;
	ld b, c
; 198             b--;
	dec b
; 199             c = 0;
	ld c, 0
; 200             hl = Net_buffer;
	ld hl, net_buffer
; 201             do {
__l_618:
; 202                 a = *hl;
	ld a, (hl)
; 203                 a += c;
	add c
; 204                 c = a;
	ld c, a
; 205                 hl++;
	inc hl
; 206                 b--;
	dec b
__l_619:
; 207             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_618
; 208             // 3C
; 209             hl--;
	dec hl
; 210             a = *hl;
	ld a, (hl)
; 211             if (a == 0x3C) {
	cp 60
	jp nz, __l_621
; 212                 hl++;
	inc hl
; 213                 // SUM
; 214                 a = *hl;
	ld a, (hl)
; 215                 if (a == c) {
	cp c
	jp nz, __l_623
; 216                     a = 1;
	ld a, 1
; 217                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
	jp __l_624
__l_623:
; 218                 } else {
; 219                     a = 0;
	ld a, 0
; 220                     ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_624:
	jp __l_622
__l_621:
; 221                 }
; 222             } else {
; 223                 a = 0;
	ld a, 0
; 224                 ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_622:
	jp __l_617
__l_616:
; 225             }
; 226         } else {
; 227             a = 0;
	ld a, 0
; 228             ParserBufferSumToHLSumState = a;
	ld (parserbuffersumtohlsumstate), a
__l_617:
	pop bc
	pop hl
	ret
; 229         }
; 230     }
; 231 }
; 232 
; 233 /// C - count (не трогаем)
; 234 /// l - Len NedBuffer
; 235 void NetFtpListFilesParse() {
netftplistfilesparse:
; 236     if ((a = l) == 16) {
	ld a, l
	cp 16
	jp nz, __l_625
; 237         NetFtpListFilesParseSum();
	call netftplistfilesparsesum
; 238         if ((a = NetFtpListFilesParseSumState) == 0x01) {
	ld a, (netftplistfilesparsesumstate)
	cp 1
	jp nz, __l_627
; 239             push_pop(hl, de) {
	push hl
	push de
; 240                 b = l;
	ld b, l
; 241                 //--
; 242                 hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 243                 d = 0;
	ld d, 0
; 244                 a ^= a;
	xor a
; 245                 a = c;
	ld a, c
; 246                 carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 247                 if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, __l_629
; 248                     d++;
	inc d
__l_629:
; 249                 }
; 250                 e = a;
	ld e, a
; 251                 hl += de;
	add hl, de
; 252                 push_pop(bc) {
	push bc
; 253                     c = b;
	ld c, b
; 254                     b = 16;
	ld b, 16
; 255                     ParserBufferToHL();
	call parserbuffertohl
	pop bc
; 256                 }
; 257                 //--
; 258                 c++;
	inc c
	pop de
	pop hl
__l_627:
	jp __l_626
__l_625:
; 259             }
; 260         }
; 261     } else {
; 262         a = 0x00;
	ld a, 0
; 263         NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_626:
	ret
; 264     }
; 265 }
; 266 
; 267 void NetFtpListFilesParseSum() {
netftplistfilesparsesum:
; 268     push_pop(hl, bc) {
	push hl
	push bc
; 269         b = 15;
	ld b, 15
; 270         c = 0;
	ld c, 0
; 271         hl = Net_buffer;
	ld hl, net_buffer
; 272         do {
__l_631:
; 273             a = *hl;
	ld a, (hl)
; 274             a += c;
	add c
; 275             c = a;
	ld c, a
; 276             hl++;
	inc hl
; 277             b--;
	dec b
__l_632:
; 278         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_631
; 279         a = *hl;
	ld a, (hl)
; 280         if (a == c) {
	cp c
	jp nz, __l_634
; 281             a = 0x01;
	ld a, 1
; 282             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
	jp __l_635
__l_634:
; 283         } else {
; 284             a = 0x00;
	ld a, 0
; 285             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_635:
; 286         }
; 287         // 10 byte = 0x3C
; 288         hl = Net_buffer;
	ld hl, net_buffer
; 289         bc = 10;
	ld bc, 10
; 290         hl += bc;
	add hl, bc
; 291         a = *hl;
	ld a, (hl)
; 292         a &= 0xFE;
	and 254
; 293         if (a != 0x3C) {
	cp 60
	jp z, __l_636
; 294             a = 0x00;
	ld a, 0
; 295             NetFtpListFilesParseSumState = a;
	ld (netftplistfilesparsesumstate), a
__l_636:
	pop bc
	pop hl
	ret
; 296         }
; 297     }
; 298 }
; 299 
; 300 uint8_t ParserBufferSumToHLSumState = 0;
parserbuffersumtohlsumstate:
	db 0
; 301 uint8_t NetGetAllStatusParseSumState = 0;
netgetallstatusparsesumstate:
	db 0
; 302 uint8_t NetFtpListFilesParseSumState = 0;
netftplistfilesparsesumstate:
	db 0
; 11 void WiFiNetworksViewShow() {
wifinetworksviewshow:
; 12     CurrentViewChangeAndPushIdA(a = WiFiNetworksViewId);
	ld a, 7
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 15         c = (a = WiFiNetworksViewColor);
	ld a, (wifinetworksviewcolor)
	ld c, a
; 16         l = (a = WiFiNetworksViewX);
	ld a, (wifinetworksviewx)
	ld l, a
; 17         h = (a = WiFiNetworksViewY);
	ld a, (wifinetworksviewy)
	ld h, a
; 18         e = (a = WiFiNetworksViewDX);
	ld a, (wifinetworksviewdx)
	ld e, a
; 19         d = (a = WiFiNetworksViewDY);
	ld a, (wifinetworksviewdy)
	ld d, a
; 20         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 21         MyFuncSetFullScreen();
	call myfuncsetfullscreen
	pop de
	pop hl
	pop bc
; 22     }
; 23     WiFiNetworksViewShowTitle();
	call wifinetworksviewshowtitle
; 24     WiFiNetworksViewUpdateList();
; 25 }
; 26 
; 27 void WiFiNetworksViewUpdateList() {
wifinetworksviewupdatelist:
; 28     WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 29     #ifdef _IS_SIMULATOR
; 30 
; 31     #else
; 32         WiFiNetworksViewClearData();
	call wifinetworksviewcleardata
; 33         NetSetIsDsDos();
	call netsetisdsdos
; 34         NetWiFiListUpdate();
	call netwifilistupdate
; 35         NetWiFiGetList();
	call netwifigetlist
; 36         WiFiNetworksViewFixData();
	call wifinetworksviewfixdata
; 37     #endif
; 38     WiFiNetworksViewShowList();
	call wifinetworksviewshowlist
; 39     a = 0;
	ld a, 0
; 40     WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
; 41     WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	jp wifinetworksviewselectlinea
; 42 }
; 43 
; 44 void WiFiNetworksViewFixData() {
wifinetworksviewfixdata:
; 45     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 46         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 47         de = 16;
	ld de, 16
; 48         b = 16;
	ld b, 16
; 49         do {
__l_638:
; 50             a = *hl;
	ld a, (hl)
; 51             if (a == 0) {
	or a
	jp nz, __l_641
; 52                 a = '-';
	ld a, 45
; 53                 *hl = a;
	ld (hl), a
__l_641:
; 54             }
; 55             hl += de;
	add hl, de
; 56             b--;
	dec b
__l_639:
; 57         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_638
	pop de
	pop bc
	pop hl
	ret
; 58     }
; 59 }
; 60 
; 61 void WiFiNetworksViewShowTitle() {
wifinetworksviewshowtitle:
; 62     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 63         // Title
; 64         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 65         a += 3;
	add 3
; 66         l = a;
	ld l, a
; 67         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 68         a += 1; //2;
	add 1
; 69         h = a;
	ld h, a
; 70         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 71         bios(a = biosPrintMessageHL, hl = WiFiNetworksViewTitle);
	ld a, 2
	ld hl, wifinetworksviewtitle
	call bios
; 72         // LINE!!!
; 73         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 74         a += 1;
	add 1
; 75         l = a;
	ld l, a
; 76         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 77         a += 2;
	add 2
; 78         h = a;
	ld h, a
; 79         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 80         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 81         a -= 2;
	sub 2
; 82         b = a;
	ld b, a
; 83         do {
__l_643:
; 84             bios(a = biosPrintC, c = 0x5F);
	ld a, 0
	ld c, 95
	call bios
; 85             b--;
	dec b
__l_644:
; 86         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_643
	pop de
	pop bc
	pop hl
	ret
; 87     }
; 88 }
; 89 
; 90 void WiFiNetworksViewClose() {
wifinetworksviewclose:
; 91     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 92     CurrentViewReturn();
	jp currentviewreturn
; 93 }
; 94 
; 95 void WiFiNetworksViewKeyA() {
wifinetworksviewkeya:
; 96     push_pop(hl) {
	push hl
; 97         l = a;
	ld l, a
; 98         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_646
; 99             if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, __l_648
; 100                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_650
; 101                     WiFiNetworksViewClose();
	call wifinetworksviewclose
	jp __l_651
__l_650:
; 102                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_652
; 103                     WiFiNetworksViewClose();
	call wifinetworksviewclose
; 104                     //--
; 105                     #ifdef _IS_SIMULATOR
; 106                         WiFiNetworksViewCopySSIDForSimulator();
; 107                         WiFiHeaderViewShowValue();
; 108                     #else
; 109                         ThreadsNetSsidUpdateA(a = WiFiNetworksViewSelectPos);
	ld a, (wifinetworksviewselectpos)
	call threadsnetssidupdatea
; 110                     #endif
; 111                     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 112                     WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
	jp __l_653
__l_652:
; 113                     //--
; 114                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_654
; 115                     WiFiNetworksViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifinetworksviewposupdatea
	jp __l_655
__l_654:
; 116                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_656
; 117                     WiFiNetworksViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifinetworksviewposupdatea
__l_656:
__l_655:
__l_653:
__l_651:
__l_648:
__l_646:
	pop hl
	ret
; 118                 }
; 119             }
; 120         }
; 121     }
; 122 }
; 123 
; 124 void WiFiNetworksViewCopySSIDForSimulator() {
wifinetworksviewcopyssidforsimul:
; 125     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 126         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 127         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 128         a &= 0x0F;
	and 15
; 129         cyclic_rotate_left(a, 4);
	rlca
	rlca
	rlca
	rlca
; 130         e = a;
	ld e, a
; 131         d = 0;
	ld d, 0
; 132         hl += de;
	add hl, de
; 133         de = WiFiSettingsViewSsidValue;
	ld de, wifisettingsviewssidvalue
; 134         //-- Copy
; 135         b = 16;
	ld b, 16
; 136         c = 0; // is 0 exist
	ld c, 0
; 137         do {
__l_658:
; 138             a = *hl;
	ld a, (hl)
; 139             *de = a;
	ld (de), a
; 140             if (a == 0) {
	or a
	jp nz, __l_661
; 141                 c = 1;
	ld c, 1
__l_661:
; 142             }
; 143             hl++;
	inc hl
; 144             de++;
	inc de
; 145             b--;
	dec b
__l_659:
; 146         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_658
; 147         //-- if stop byte (0)
; 148         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_663
; 149             de--;
	dec de
; 150             a = 0;
	ld a, 0
; 151             *de = a;
	ld (de), a
__l_663:
	pop de
	pop bc
	pop hl
	ret
; 152         }
; 153     }
; 154 }
; 155 
; 156 void WiFiNetworksViewClearData() {
wifinetworksviewcleardata:
; 157     push_pop(hl, bc) {
	push hl
	push bc
; 158         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 159         b = 0xFF;
	ld b, 255
; 160         do {
__l_665:
; 161             *hl = 0;
	ld (hl), 0
; 162             hl++;
	inc hl
; 163             b--;
	dec b
__l_666:
; 164         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_665
	pop bc
	pop hl
	ret
; 165     }
; 166 }
; 167 
; 168 void WiFiNetworksViewShowList() {
wifinetworksviewshowlist:
; 169     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 170         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 171         c = 0;
	ld c, 0
; 172         //
; 173         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 174         a += 2;
	add 2
; 175         d = a; // X
	ld d, a
; 176         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 177         a += 5;
	add 5
; 178         e = a; // Y
	ld e, a
; 179         //
; 180         do {
__l_668:
; 181             //--
; 182             push_pop(hl) {
	push hl
; 183                 a = e;
	ld a, e
; 184                 a += c;
	add c
; 185                 h = a;
	ld h, a
; 186                 a = d;
	ld a, d
; 187                 l = a;
	ld l, a
; 188                 bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 189             }
; 190             //--
; 191             b = 16;
	ld b, 16
; 192             do {
__l_671:
; 193                 push_pop(bc) {
	push bc
; 194                     bios(c = (a = *hl), a = biosPrintC);
	ld a, (hl)
	ld c, a
	ld a, 0
	call bios
	pop bc
; 195                 }
; 196                 hl++;
	inc hl
; 197                 b--;
	dec b
__l_672:
; 198             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_671
; 199             c++;
	inc c
__l_669:
; 200         } while ((a = WiFiNetworksViewSSIDCount) >= c);
	ld a, (wifinetworksviewssidcount)
	cp c
	jp nc, __l_668
; 201         // Crean
; 202         a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 203         c = a;
	ld c, a
; 204         a = 16; // Максимальное число строк
	ld a, 16
; 205         a -= c;
	sub c
; 206         if (a > 0) { // До добавляем пустые строки
	or a
	jp z, __l_674
; 207             b = a;
	ld b, a
; 208             //--
; 209             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 210             a += e;
	add e
; 211             e = a;
	ld e, a
; 212             //--
; 213             h = 0;
	ld h, 0
; 214             do {
__l_676:
; 215                 //--
; 216                 a = e;
	ld a, e
; 217                 a += h;
	add h
; 218                 push_pop(hl) {
	push hl
; 219                     h = a;
	ld h, a
; 220                     l = d;
	ld l, d
; 221                     bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 222                 }
; 223                 //--
; 224                 c = 16;
	ld c, 16
; 225                 do {
__l_679:
; 226                     push_pop(bc) {
	push bc
; 227                         bios(c = ' ', a = biosPrintC);
	ld c, 32
	ld a, 0
	call bios
	pop bc
; 228                     }
; 229                     c--;
	dec c
__l_680:
; 230                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_679
; 231                 b--;
	dec b
; 232                 h++;
	inc h
__l_677:
; 233             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_676
__l_674:
	pop de
	pop bc
	pop hl
	ret
; 234         }
; 235     }
; 236 }
; 237 
; 238 /// Обновление позиции
; 239 /// вх[A]
; 240 /// 0 - без изменений
; 241 /// 1 - вверх
; 242 /// 0xFF - вниз
; 243 void WiFiNetworksViewPosUpdateA() {
wifinetworksviewposupdatea:
; 244     push_pop(bc) {
	push bc
; 245         b = a;
	ld b, a
; 246         if (a == 0) {
	or a
	jp nz, __l_682
; 247             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
	jp __l_683
__l_682:
; 248         } else {
; 249             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 250             c = a;
	ld c, a
; 251             WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 252             if ((a = c) == 0) { // нет ни одной записи
	ld a, c
	or a
	jp nz, __l_684
; 253                 a = 0;
	ld a, 0
; 254                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
	jp __l_685
__l_684:
; 255             } else { // если есть хоть одна запись
; 256                 a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 257                 a += b;
	add b
; 258                 //-- FIX
; 259                 if (a == 0xFF) {
	cp 255
	jp nz, __l_686
; 260                     a = c;
	ld a, c
; 261                     a--;
	dec a
	jp __l_687
__l_686:
; 262                 } else if (a == c) {
	cp c
	jp nz, __l_688
; 263                     a = 0;
	ld a, 0
__l_688:
__l_687:
; 264                 }
; 265                 //--
; 266                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
__l_685:
; 267             }
; 268             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
__l_683:
	pop bc
	ret
; 269         }
; 270     }
; 271 }
; 272 
; 273 /// Рисование линии прямым или инверсным цветом
; 274 /// 0 - прямой
; 275 /// 1 - инверсный
; 276 void WiFiNetworksViewSelectLineA() {
wifinetworksviewselectlinea:
; 277     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 278         c = a;
	ld c, a
; 279         //--
; 280         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 281         b = a;
	ld b, a
; 282         //--
; 283         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 284         a += 1;
	add 1
; 285         l = a; // X
	ld l, a
; 286         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 287         a += 5;
	add 5
; 288         a += b;
	add b
; 289         h = a; // Y
	ld h, a
; 290         //--
; 291         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 292         a -= 2;
	sub 2
; 293         e = a;
	ld e, a
; 294         d = 1;
	ld d, 1
; 295         //--
; 296         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_690
; 297             a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
	jp __l_691
__l_690:
; 298         } else {
; 299             a = WiFiNetworksViewInvColor;
	ld a, (wifinetworksviewinvcolor)
__l_691:
; 300         }
; 301         c = a;
	ld c, a
; 302         //--
; 303         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop de
	pop hl
	pop bc
	ret
; 304     }
; 305 }
; 306 
; 307 uint8_t WiFiNetworksViewX = 14; //21;
wifinetworksviewx:
	db 14
; 308 uint8_t WiFiNetworksViewY = 3;
wifinetworksviewy:
	db 3
; 309 uint8_t WiFiNetworksViewDX = 20;
wifinetworksviewdx:
	db 20
; 310 uint8_t WiFiNetworksViewDY = 23;
wifinetworksviewdy:
	db 23
; 311 uint8_t WiFiNetworksViewColor = 0x70;
wifinetworksviewcolor:
	db 112
; 312 uint8_t WiFiNetworksViewInvColor = 0x07;
wifinetworksviewinvcolor:
	db 7
; 314 uint8_t WiFiNetworksViewSelectPos = 0;
wifinetworksviewselectpos:
	db 0
; 316 uint8_t WiFiNetworksViewTitle[] = "Wi-Fi Networks";
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
; 339 uint8_t WiFiNetworksViewSSIDCount = 0;
wifinetworksviewssidcount:
	db 0
; 340 uint8_t WiFiNetworksViewSSIDList[16*16] = {
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
; 15         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 16         c = (a = FtpSettingsViewColor);
	ld a, (ftpsettingsviewcolor)
	ld c, a
; 17         l = (a = FtpSettingsViewX);
	ld a, (ftpsettingsviewx)
	ld l, a
; 18         h = (a = FtpSettingsViewY);
	ld a, (ftpsettingsviewy)
	ld h, a
; 19         e = (a = FtpSettingsViewDX);
	ld a, (ftpsettingsviewdx)
	ld e, a
; 20         d = (a = FtpSettingsViewDY);
	ld a, (ftpsettingsviewdy)
	ld d, a
; 21         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 22         MyFuncSetFullScreen();
	call myfuncsetfullscreen
	pop de
	pop hl
	pop bc
; 23     }
; 24     a = 0;
	ld a, 0
; 25     FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 26     FtpSettingsViewShowTitle();
	call ftpsettingsviewshowtitle
; 27     FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
; 28     FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp ftpsettingsviewselectlinea
; 29 }
; 30 
; 31 void FtpSettingsViewClose() {
ftpsettingsviewclose:
; 32     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 33     CurrentViewReturn();
	jp currentviewreturn
; 34 }
; 35 
; 36 void FtpSettingsViewShowTitle() {
ftpsettingsviewshowtitle:
; 37     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 38         bios(c = (a = FtpSettingsViewColor), a = biosSetColorC);
	ld a, (ftpsettingsviewcolor)
	ld c, a
	ld a, 18
	call bios
; 39         // LINE!!!
; 40         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 41         a += 1;
	add 1
; 42         l = a;
	ld l, a
; 43         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 44         a += 2;
	add 2
; 45         h = a;
	ld h, a
; 46         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 47         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 48         a -= 2;
	sub 2
; 49         b = a;
	ld b, a
; 50         do {
__l_692:
; 51             bios(a = biosPrintC, c = 0x90);
	ld a, 0
	ld c, 144
	call bios
; 52             b--;
	dec b
__l_693:
; 53         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_692
; 54         // Title
; 55         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 56         a += 7;
	add 7
; 57         l = a;
	ld l, a
; 58         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 59         a += 1; //2;
	add 1
; 60         h = a;
	ld h, a
; 61         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 62         push_pop(hl) {
	push hl
; 63             bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitle);
	ld a, 2
	ld hl, ftpsettingsviewtitle
	call bios
	pop hl
; 64         }
; 65         // IP
; 66         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 67         a += 2;
	add 2
; 68         l = a; // X
	ld l, a
; 69         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 70         a += 4;
	add 4
; 71         h = a; // Y
	ld h, a
; 72         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 73         push_pop(hl) {
	push hl
; 74             bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleIP);
	ld a, 2
	ld hl, ftpsettingsviewtitleip
	call bios
	pop hl
; 75         }
; 76         // PORT
; 77         h++;
	inc h
; 78         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 79         push_pop(hl) {
	push hl
; 80             bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitlePort);
	ld a, 2
	ld hl, ftpsettingsviewtitleport
	call bios
	pop hl
; 81         }
; 82         // USER
; 83         h++;
	inc h
; 84         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 85         push_pop(hl) {
	push hl
; 86             bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleUser);
	ld a, 2
	ld hl, ftpsettingsviewtitleuser
	call bios
	pop hl
; 87         }
; 88         // PASS
; 89         h++;
	inc h
; 90         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 91         push_pop(hl) {
	push hl
; 92             bios(a = biosPrintMessageHL, hl = WiFiSettingsViewTitlePass);
	ld a, 2
	ld hl, wifisettingsviewtitlepass
	call bios
	pop hl
; 93         }
; 94         // HOME dir
; 95         h++;
	inc h
; 96         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 97         push_pop(hl) {
	push hl
; 98             bios(a = biosPrintMessageHL, hl = FtpSettingsViewTitleHomeDir);
	ld a, 2
	ld hl, ftpsettingsviewtitlehomedir
	call bios
	pop hl
; 99         }
; 100         // Button
; 101         if ((a = FtpHeaderViewStatus) == 0) {
	ld a, (ftpheaderviewstatus)
	or a
	jp nz, __l_695
; 102             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp __l_696
__l_695:
; 103         } else {
; 104             bc = StringLocaleOK;
	ld bc, stringlocaleok
__l_696:
; 105         }
; 106         
; 107         // Button
; 108         d = 13;
	ld d, 13
; 109         e = 3;
	ld e, 3
; 110         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 111         a += 7;
	add 7
; 112         h = a;
	ld h, a
; 113         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 114         a += 10;
	add 10
; 115         l = a;
	ld l, a
; 116         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 117     }
; 118 }
; 119 
; 120 void FtpSettingsViewShowValue() {
ftpsettingsviewshowvalue:
; 121     push_pop(hl, bc) {
	push hl
	push bc
; 122         bios(c = (a = FtpSettingsViewColor), a = biosSetColorC);
	ld a, (ftpsettingsviewcolor)
	ld c, a
	ld a, 18
	call bios
; 123         // IP
; 124         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 125         a += 8;
	add 8
; 126         l = a; // X
	ld l, a
; 127         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 128         a += 4;
	add 4
; 129         h = a; // Y
	ld h, a
; 130         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 131         push_pop(hl) {
	push hl
; 132             MyFuncPrintHLStrLenA(hl = FtpHeaderViewIpValue, a = 18);
	ld hl, ftpheaderviewipvalue
	ld a, 18
	call myfuncprinthlstrlena
	pop hl
; 133         }
; 134         // PORT
; 135         h++;
	inc h
; 136         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 137         push_pop(hl) {
	push hl
; 138             MyFuncPrintHLStrLenA(hl = FtpSettingsViewValuePort, a = 18);
	ld hl, ftpsettingsviewvalueport
	ld a, 18
	call myfuncprinthlstrlena
	pop hl
; 139         }
; 140         // USER
; 141         h++;
	inc h
; 142         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 143         push_pop(hl) {
	push hl
; 144             MyFuncPrintHLStrLenA(hl = FtpSettingsViewValueUser, a = 18);
	ld hl, ftpsettingsviewvalueuser
	ld a, 18
	call myfuncprinthlstrlena
	pop hl
; 145         }
; 146         // PASS
; 147         h++;
	inc h
; 148         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 149         push_pop(hl) {
	push hl
; 150             MyFuncPrintHLPassLenA(hl = FtpSettingsViewValuePass, a = 18);
	ld hl, ftpsettingsviewvaluepass
	ld a, 18
	call myfuncprinthlpasslena
	pop hl
; 151         }
; 152         // HOME DIR
; 153         h++;
	inc h
; 154         bios(a = biosSetPositionCursoreHL); //h=y l=x
	ld a, 28
	call bios
; 155         push_pop(hl) {
	push hl
; 156             MyFuncPrintHLStrLenA(hl = FtpSettingsViewValueHomeDir, a = 18);
	ld hl, ftpsettingsviewvaluehomedir
	ld a, 18
	call myfuncprinthlstrlena
	pop hl
	pop bc
	pop hl
	ret
; 157         }
; 158     }
; 159 }
; 160 
; 161 /// вых [BC] -
; 162 void FtpSettingsViewByPosValue() {
ftpsettingsviewbyposvalue:
; 163     if ((a = FtpSettingsViewSelectPos) == 1) {
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, __l_697
; 164         bc = FtpHeaderViewIpValue;
	ld bc, ftpheaderviewipvalue
	jp __l_698
__l_697:
; 165     } else if ((a = FtpSettingsViewSelectPos) == 2) {
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, __l_699
; 166         bc = FtpSettingsViewValuePort;
	ld bc, ftpsettingsviewvalueport
	jp __l_700
__l_699:
; 167     } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, __l_701
; 168         bc = FtpSettingsViewValueUser;
	ld bc, ftpsettingsviewvalueuser
	jp __l_702
__l_701:
; 169     } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, __l_703
; 170         bc = FtpSettingsViewValuePass;
	ld bc, ftpsettingsviewvaluepass
	jp __l_704
__l_703:
; 171     } else if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, __l_705
; 172         bc = FtpSettingsViewValueHomeDir;
	ld bc, ftpsettingsviewvaluehomedir
	jp __l_706
__l_705:
; 173     } else {
; 174         bc = 0;
	ld bc, 0
__l_706:
__l_704:
__l_702:
__l_700:
__l_698:
	ret
; 175     }
; 176 }
; 177 
; 178 /// вых [HL] -
; 179 /// вых [DE]-
; 180 void FtpSettingsViewByPosBoxValue() {
ftpsettingsviewbyposboxvalue:
; 181     push_pop(bc) {
	push bc
; 182         // HL
; 183         a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 184         b = a;
	ld b, a
; 185         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 186         a += 3;
	add 3
; 187         a += b;
	add b
; 188         h = a;
	ld h, a
; 189         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 190         a += 7;
	add 7
; 191         l = a;
	ld l, a
; 192         // DE
; 193         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 194         a -= 8;
	sub 8
; 195         e = a;
	ld e, a
; 196         a = 1;
	ld a, 1
; 197         d = a;
	ld d, a
	pop bc
	ret
; 198     }
; 199 }
; 200 
; 201 /// Обновление позиции
; 202 /// вх[A]
; 203 /// 0 - без изменений
; 204 /// 1 - вверх
; 205 /// 0xFF - вниз
; 206 void FtpSettingsViewPosUpdateA() {
ftpsettingsviewposupdatea:
; 207     push_pop(bc) {
	push bc
; 208         b = a;
	ld b, a
; 209         if (a == 0) {
	or a
	jp nz, __l_707
; 210             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
	jp __l_708
__l_707:
; 211         } else {
; 212             a = 6;
	ld a, 6
; 213             c = a;
	ld c, a
; 214             FtpSettingsViewSelectLineA(a = 0);
	ld a, 0
	call ftpsettingsviewselectlinea
; 215             a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 216             a += b;
	add b
; 217             b = a;
	ld b, a
; 218             //-- FIX
; 219             if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, __l_709
; 220                 a = c;
	ld a, c
; 221                 a--;
	dec a
	jp __l_710
__l_709:
; 222             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, __l_711
; 223                 a = 0;
	ld a, 0
__l_711:
__l_710:
; 224             }
; 225             //--
; 226             FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 227             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
__l_708:
	pop bc
	ret
; 228         }
; 229     }
; 230 }
; 231 
; 232 /// Рисование линии прямым или инверсным цветом
; 233 /// 0 - прямой
; 234 /// 1 - инверсный
; 235 void FtpSettingsViewSelectLineA() {
ftpsettingsviewselectlinea:
; 236     push_pop(bc, hl) {
	push bc
	push hl
; 237         c = a;
	ld c, a
; 238         // 0 - Button
; 239         if ((a = FtpSettingsViewSelectPos) == 0) {
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, __l_713
; 240             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp __l_714
__l_713:
; 241         } else {
; 242             FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 243             // C
; 244             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_715
; 245                 a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
	jp __l_716
__l_715:
; 246             } else {
; 247                 a = FtpSettingsViewInvColor;
	ld a, (ftpsettingsviewinvcolor)
__l_716:
; 248             }
; 249             c = a;
	ld c, a
; 250             // A
; 251             MyViewChangeBoxColor();
	call myviewchangeboxcolor
__l_714:
	pop hl
	pop bc
	ret
; 252         }
; 253     }
; 254 }
; 255 
; 256 void FtpSettingsViewKeyA() {
ftpsettingsviewkeya:
; 257     push_pop(hl) {
	push hl
; 258         l = a;
	ld l, a
; 259         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_717
; 260             if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, __l_719
; 261                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, __l_721
; 262                     FtpSettingsViewClose();
	call ftpsettingsviewclose
	jp __l_722
__l_721:
; 263                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, __l_723
; 264                     if ((a = FtpSettingsViewSelectPos) == 0) { // OK
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, __l_725
; 265                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 266                         if ((a = FtpHeaderViewStatus) == 0) {
	ld a, (ftpheaderviewstatus)
	or a
	jp nz, __l_727
; 267                             #ifdef _IS_SIMULATOR
; 268 
; 269                             #else
; 270                                 NetFtpConnect();
	call netftpconnect
; 271                                 ThreadsTickNow();
	call threadsticknow
__l_727:
	jp __l_726
__l_725:
; 272                             #endif
; 273                         }
; 274                     } else { // Переход в редактирование
; 275                         FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 276                         FtpSettingsViewByPosValue();
	call ftpsettingsviewbyposvalue
; 277                         EditFieldViewShow();
	call editfieldviewshow
; 278                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, __l_729
; 279                             if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, __l_731
; 280                                 #ifdef _IS_SIMULATOR
; 281 
; 282                                 #else
; 283                                     ThreadsNetFtpHomeDirUpdate();
	call threadsnetftphomedirupdate
	jp __l_732
__l_731:
; 284                                 #endif
; 285                             } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, __l_733
; 286                                 #ifdef _IS_SIMULATOR
; 287 
; 288                                 #else
; 289                                     ThreadsNetFtpUserUpdate();
	call threadsnetftpuserupdate
	jp __l_734
__l_733:
; 290                                 #endif
; 291                             } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, __l_735
; 292                                 #ifdef _IS_SIMULATOR
; 293 
; 294                                 #else
; 295                                     ThreadsNetFtpPasswordUpdate();
	call threadsnetftppasswordupdate
	jp __l_736
__l_735:
; 296                                 #endif
; 297                             } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, __l_737
; 298                                 #ifdef _IS_SIMULATOR
; 299 
; 300                                 #else
; 301                                     ThreadsNetFtpServerUrlUpdate();
	call threadsnetftpserverurlupdate
; 302                                 #endif
; 303                                 FtpHeaderViewShowValue();
	call ftpheaderviewshowvalue
	jp __l_738
__l_737:
; 304                             } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, __l_739
; 305                                 #ifdef _IS_SIMULATOR
; 306 
; 307                                 #else
; 308                                     ThreadsNetFtpPortUpdate();
	call threadsnetftpportupdate
__l_739:
__l_738:
__l_736:
__l_734:
__l_732:
__l_729:
; 309                                 #endif
; 310                             }
; 311                             //FtpSettingsViewShowValue();
; 312                         }
; 313                         FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
; 314                         FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
__l_726:
	jp __l_724
__l_723:
; 315                     }
; 316                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, __l_741
; 317                     FtpSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call ftpsettingsviewposupdatea
	jp __l_742
__l_741:
; 318                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, __l_743
; 319                     FtpSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpsettingsviewposupdatea
__l_743:
__l_742:
__l_724:
__l_722:
__l_719:
__l_717:
	pop hl
	ret
; 320                 }
; 321             }
; 322         }
; 323     }
; 324 }
; 325 
; 326 uint8_t FtpSettingsViewX = 11;
ftpsettingsviewx:
	db 11
; 327 uint8_t FtpSettingsViewY = 9;
ftpsettingsviewy:
	db 9
; 328 uint8_t FtpSettingsViewDX = 27;
ftpsettingsviewdx:
	db 27
; 329 uint8_t FtpSettingsViewDY = 15;
ftpsettingsviewdy:
	db 15
; 330 uint8_t FtpSettingsViewColor = 0x70;
ftpsettingsviewcolor:
	db 112
; 331 uint8_t FtpSettingsViewInvColor = 0x07;
ftpsettingsviewinvcolor:
	db 7
; 333 uint8_t FtpSettingsViewSelectPos = 1; //0
ftpsettingsviewselectpos:
	db 1
; 335 uint8_t FtpSettingsViewTitle[] = "FTP settings";
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
; 336 uint8_t FtpSettingsViewTitleIP[] =      "  IP:";
ftpsettingsviewtitleip:
	db 32
	db 32
	db 73
	db 80
	db 58
	ds 1
; 337 uint8_t FtpSettingsViewTitlePort[] =    "Port:";
ftpsettingsviewtitleport:
	db 80
	db 111
	db 114
	db 116
	db 58
	ds 1
; 338 uint8_t FtpSettingsViewTitleHomeDir[] = "Home:";
ftpsettingsviewtitlehomedir:
	db 72
	db 111
	db 109
	db 101
	db 58
	ds 1
; 339 uint8_t FtpSettingsViewTitleUser[] = "User:";
ftpsettingsviewtitleuser:
	db 85
	db 115
	db 101
	db 114
	db 58
	ds 1
; 341 uint8_t FtpSettingsViewValuePort[16] = "21";
ftpsettingsviewvalueport:
	db 50
	db 49
	ds 14
; 342 uint8_t FtpSettingsViewValueUser[16] = "-";
ftpsettingsviewvalueuser:
	db 45
	ds 15
; 343 uint8_t FtpSettingsViewValuePass[16] = "-";
ftpsettingsviewvaluepass:
	db 45
	ds 15
; 344 uint8_t FtpSettingsViewValueHomeDir[16] = "/";
ftpsettingsviewvaluehomedir:
	db 47
	ds 15
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
; 21     ButtonShadowView2X = (a = h);
	ld a, h
	ld (buttonshadowview2x), a
; 22     ButtonShadowView2Y = (a = l);
	ld a, l
	ld (buttonshadowview2y), a
; 23     ButtonShadowView2DX = (a = d);
	ld a, d
	ld (buttonshadowview2dx), a
; 24     ButtonShadowView2DY = (a = e);
	ld a, e
	ld (buttonshadowview2dy), a
; 25     //--
; 26     ButtonShadowView2ShowTitleBC();
	call buttonshadowview2showtitlebc
; 27     //--
; 28     c = (a = ButtonShadowView2Color);
	ld a, (buttonshadowview2color)
	ld c, a
; 29     l = (a = ButtonShadowView2X);
	ld a, (buttonshadowview2x)
	ld l, a
; 30     h = (a = ButtonShadowView2Y);
	ld a, (buttonshadowview2y)
	ld h, a
; 31     e = (a = ButtonShadowView2DX);
	ld a, (buttonshadowview2dx)
	ld e, a
; 32     d = (a = ButtonShadowView2DY);
	ld a, (buttonshadowview2dy)
	ld d, a
; 33     MyViewChangeBoxColor();
	jp myviewchangeboxcolor
; 34 }
; 35 
; 36 /// Закраска кнопки
; 37 /// 0 - прямой
; 38 /// 1 - инверсный
; 39 void ButtonShadowView2SelectA() {
buttonshadowview2selecta:
; 40     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 41         b = a;
	ld b, a
; 42         l = (a = ButtonShadowView2X);
	ld a, (buttonshadowview2x)
	ld l, a
; 43         h = (a = ButtonShadowView2Y);
	ld a, (buttonshadowview2y)
	ld h, a
; 44         e = (a = ButtonShadowView2DX);
	ld a, (buttonshadowview2dx)
	ld e, a
; 45         d = (a = ButtonShadowView2DY);
	ld a, (buttonshadowview2dy)
	ld d, a
; 46         //--------
; 47         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, __l_745
; 48             a = ButtonShadowView2Color;
	ld a, (buttonshadowview2color)
	jp __l_746
__l_745:
; 49         } else {
; 50             a = ButtonShadowView2InvColor;
	ld a, (buttonshadowview2invcolor)
__l_746:
; 51         }
; 52         c = a;
	ld c, a
; 53         //----
; 54         MyViewChangeBoxColor();
	call myviewchangeboxcolor
	pop hl
	pop de
	pop bc
	ret
; 55     }
; 56 }
; 57 
; 58 void ButtonShadowView2ShowTitleBC() {
buttonshadowview2showtitlebc:
; 59     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 60         hl = ButtonShadowView2TitlePoint;
	ld hl, (buttonshadowview2titlepoint)
; 61         b = 0;
	ld b, 0
; 62         a = ButtonShadowView2DX;
	ld a, (buttonshadowview2dx)
; 63         c = a;
	ld c, a
; 64         do {
__l_747:
; 65             a = *hl;
	ld a, (hl)
; 66             d = a;
	ld d, a
; 67             hl++;
	inc hl
; 68             if (a > 0) {
	or a
	jp z, __l_750
; 69                 b++;
	inc b
__l_750:
; 70             }
; 71             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_752
; 72                 d = 0;
	ld d, 0
__l_752:
__l_748:
; 73             }
; 74         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_747
; 75         a = ButtonShadowView2DX;
	ld a, (buttonshadowview2dx)
; 76         a -= b;
	sub b
; 77         a &= 0xFE;
	and 254
; 78         cyclic_rotate_right(a, 1);
	rrca
; 79         b = a;
	ld b, a
; 80         a = ButtonShadowView2X;
	ld a, (buttonshadowview2x)
; 81         a += b;
	add b
; 82         l = a;
	ld l, a
; 83         a = ButtonShadowView2Y;
	ld a, (buttonshadowview2y)
; 84         a += 1;
	add 1
; 85         h = a;
	ld h, a
; 86         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 87         bios(a = biosPrintMessageHL, hl = ButtonShadowView2TitlePoint);
	ld a, 2
	ld hl, (buttonshadowview2titlepoint)
	call bios
	pop bc
	pop de
	pop hl
	ret
; 88     }
; 89 }
; 90 
; 91 uint8_t ButtonShadowView2X = 0;
buttonshadowview2x:
	db 0
; 92 uint8_t ButtonShadowView2Y = 0;
buttonshadowview2y:
	db 0
; 93 uint8_t ButtonShadowView2DX = 0;
buttonshadowview2dx:
	db 0
; 94 uint8_t ButtonShadowView2DY = 0;
buttonshadowview2dy:
	db 0
; 96 uint8_t ButtonShadowView2Color = 0xF7;
buttonshadowview2color:
	db 247
; 97 uint8_t ButtonShadowView2InvColor = 0xE2; //0xE6
buttonshadowview2invcolor:
	db 226
; 99 uint16_t ButtonShadowView2TitlePoint = 0x0000;
buttonshadowview2titlepoint:
	dw 0
; 11 void AllertYesNoViewShowHL() {
allertyesnoviewshowhl:
; 12     AllertYesNoViewTitlePoint = hl;
	ld (allertyesnoviewtitlepoint), hl
; 13     CurrentViewChangeAndPushIdA(a = AllertYesNoViewId);
	ld a, 9
	call currentviewchangeandpushida
; 14     AllertYesNoViewReturnValue = (a = 0);
	ld a, 0
	ld (allertyesnoviewreturnvalue), a
; 15     AllertYesNoViewPos = (a = 0);
	ld a, 0
	ld (allertyesnoviewpos), a
; 16     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 17         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 18         c = (a = AllertYesNoViewColor);
	ld a, (allertyesnoviewcolor)
	ld c, a
; 19         l = (a = AllertYesNoViewX);
	ld a, (allertyesnoviewx)
	ld l, a
; 20         h = (a = AllertYesNoViewY);
	ld a, (allertyesnoviewy)
	ld h, a
; 21         e = (a = AllertYesNoViewDX);
	ld a, (allertyesnoviewdx)
	ld e, a
; 22         d = (a = AllertYesNoViewDY);
	ld a, (allertyesnoviewdy)
	ld d, a
; 23         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 24         MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 25         
; 26         // NO Button
; 27         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 28         a += 6; //!
	add 6
; 29         h = a;
	ld h, a
; 30         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 31         a += 4;
	add 4
; 32         l = a;
	ld l, a
; 33         d = 4;
	ld d, 4
; 34         e = 3;
	ld e, 3
; 35         ButtonShadowViewShow(bc = StringLocaleNo);
	ld bc, stringlocaleno
	call buttonshadowviewshow
; 36         // YES Button
; 37         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 38         a += 6 + 7; //!
	add 13
; 39         h = a;
	ld h, a
; 40         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 41         a += 4;
	add 4
; 42         l = a;
	ld l, a
; 43         d = 5;
	ld d, 5
; 44         e = 3;
	ld e, 3
; 45         ButtonShadowView2Show(bc = StringLocaleYes);
	ld bc, stringlocaleyes
	call buttonshadowview2show
	pop de
	pop hl
	pop bc
; 46     }
; 47     AllertYesNoViewShowTitle();
	call allertyesnoviewshowtitle
; 48     AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
; 49     AllertYesNoViewLoopKey();
; 50 }
; 51 
; 52 void AllertYesNoViewLoopKey() {
allertyesnoviewloopkey:
; 53     push_pop(bc) {
	push bc
; 54         b = 0;
	ld b, 0
; 55         do {
__l_754:
; 56             getKeyboardCharA();
	call getkeyboardchara
; 57             c = a;
	ld c, a
; 58             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_757
; 59                 b = 1;
	ld b, 1
	jp __l_758
__l_757:
; 60             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, __l_759
; 61                 a = AllertYesNoViewPos;
	ld a, (allertyesnoviewpos)
; 62                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 63                 b = 1;
	ld b, 1
	jp __l_760
__l_759:
; 64             } else if ((a = c) == 0x18) { // Вправо
	ld a, c
	cp 24
	jp nz, __l_761
; 65                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 66                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp __l_762
__l_761:
; 67             } else if ((a = c) == 0x08) { // Влево
	ld a, c
	cp 8
	jp nz, __l_763
; 68                 AllertYesNoViewPosNext();
	call allertyesnoviewposnext
; 69                 AllertYesNoViewPosUpdate();
	call allertyesnoviewposupdate
	jp __l_764
__l_763:
; 70             } else if ((a = c) == 'Y') {
	ld a, c
	cp 89
	jp nz, __l_765
; 71                 a = 1;
	ld a, 1
; 72                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 73                 b = 1;
	ld b, 1
	jp __l_766
__l_765:
; 74             } else if ((a = c) == 'N') {
	ld a, c
	cp 78
	jp nz, __l_767
; 75                 a = 0;
	ld a, 0
; 76                 AllertYesNoViewReturnValue = a;
	ld (allertyesnoviewreturnvalue), a
; 77                 b = 1;
	ld b, 1
__l_767:
__l_766:
__l_764:
__l_762:
__l_760:
__l_758:
__l_755:
; 78             }
; 79         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_754
	pop bc
; 80     }
; 81     AllertYesNoViewClose();
	jp allertyesnoviewclose
; 82 }
; 83 
; 84 void AllertYesNoViewPosNext() {
allertyesnoviewposnext:
; 85     if ((a = AllertYesNoViewPos) == 0) {
	ld a, (allertyesnoviewpos)
	or a
	jp nz, __l_769
; 86         a = 1;
	ld a, 1
; 87         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
	jp __l_770
__l_769:
; 88     } else {
; 89         a = 0;
	ld a, 0
; 90         AllertYesNoViewPos = a;
	ld (allertyesnoviewpos), a
__l_770:
	ret
; 91     }
; 92 }
; 93 
; 94 void AllertYesNoViewPosUpdate() {
allertyesnoviewposupdate:
; 95     if ((a = AllertYesNoViewPos) == 0) {
	ld a, (allertyesnoviewpos)
	or a
	jp nz, __l_771
; 96         ButtonShadowViewSelectA(a = 1);
	ld a, 1
	call buttonshadowviewselecta
; 97         ButtonShadowView2SelectA(a = 0);
	ld a, 0
	call buttonshadowview2selecta
	jp __l_772
__l_771:
; 98     } else {
; 99         ButtonShadowViewSelectA(a = 0);
	ld a, 0
	call buttonshadowviewselecta
; 100         ButtonShadowView2SelectA(a = 1);
	ld a, 1
	call buttonshadowview2selecta
__l_772:
	ret
; 101     }
; 102 }
; 103 
; 104 void AllertYesNoViewClose() {
allertyesnoviewclose:
; 105     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 106     CurrentViewReturn();
	call currentviewreturn
; 107     a = AllertYesNoViewReturnValue;
	ld a, (allertyesnoviewreturnvalue)
	ret
; 108 }
; 109 
; 110 void AllertYesNoViewShowTitle() {
allertyesnoviewshowtitle:
; 111     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 112         hl = AllertYesNoViewTitlePoint;
	ld hl, (allertyesnoviewtitlepoint)
; 113         b = 0;
	ld b, 0
; 114         a = AllertYesNoViewDX;
	ld a, (allertyesnoviewdx)
; 115         c = a;
	ld c, a
; 116         do {
__l_773:
; 117             a = *hl;
	ld a, (hl)
; 118             d = a;
	ld d, a
; 119             hl++;
	inc hl
; 120             if (a > 0) {
	or a
	jp z, __l_776
; 121                 b++;
	inc b
__l_776:
; 122             }
; 123             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_778
; 124                 d = 0;
	ld d, 0
__l_778:
__l_774:
; 125             }
; 126         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_773
; 127         a = AllertYesNoViewDX;
	ld a, (allertyesnoviewdx)
; 128         a -= b;
	sub b
; 129         a &= 0xFE;
	and 254
; 130         cyclic_rotate_right(a, 1);
	rrca
; 131         b = a;
	ld b, a
; 132         a = AllertYesNoViewX;
	ld a, (allertyesnoviewx)
; 133         a += b;
	add b
; 134         l = a;
	ld l, a
; 135         a = AllertYesNoViewY;
	ld a, (allertyesnoviewy)
; 136         a += 2;
	add 2
; 137         h = a;
	ld h, a
; 138         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 139         bios(a = biosPrintMessageHL, hl = AllertYesNoViewTitlePoint);
	ld a, 2
	ld hl, (allertyesnoviewtitlepoint)
	call bios
	pop bc
	pop de
	pop hl
	ret
; 140     }
; 141 }
; 142 
; 143 uint8_t AllertYesNoViewX = 12;
allertyesnoviewx:
	db 12
; 144 uint8_t AllertYesNoViewY = 12;
allertyesnoviewy:
	db 12
; 145 uint8_t AllertYesNoViewDX = 24;
allertyesnoviewdx:
	db 24
; 146 uint8_t AllertYesNoViewDY = 9;
allertyesnoviewdy:
	db 9
; 147 uint8_t AllertYesNoViewColor = 0x70; // 0x1F;
allertyesnoviewcolor:
	db 112
; 149 uint8_t AllertYesNoViewPos = 0;
allertyesnoviewpos:
	db 0
; 150 uint8_t AllertYesNoViewReturnValue = 0;
allertyesnoviewreturnvalue:
	db 0
; 152 uint16_t AllertYesNoViewTitlePoint = 0;
allertyesnoviewtitlepoint:
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
; 15         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 16         c = (a = AllertOkViewColor);
	ld a, (allertokviewcolor)
	ld c, a
; 17         l = (a = AllertOkViewX);
	ld a, (allertokviewx)
	ld l, a
; 18         h = (a = AllertOkViewY);
	ld a, (allertokviewy)
	ld h, a
; 19         e = (a = AllertOkViewDX);
	ld a, (allertokviewdx)
	ld e, a
; 20         d = (a = AllertOkViewDY);
	ld a, (allertokviewdy)
	ld d, a
; 21         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 22         MyFuncSetFullScreen();
	call myfuncsetfullscreen
; 23         
; 24         // Ok Button
; 25         a = AllertOkViewX;
	ld a, (allertokviewx)
; 26         a += 10; //!
	add 10
; 27         h = a;
	ld h, a
; 28         a = AllertOkViewY;
	ld a, (allertokviewy)
; 29         a += 4;
	add 4
; 30         l = a;
	ld l, a
; 31         d = 4;
	ld d, 4
; 32         e = 3;
	ld e, 3
; 33         ButtonShadowViewShow(bc = StringLocaleOK);
	ld bc, stringlocaleok
	call buttonshadowviewshow
; 34         ButtonShadowViewSelectA(a = 1);
	ld a, 1
	call buttonshadowviewselecta
	pop de
	pop hl
	pop bc
; 35     }
; 36     AllertOkViewShowTitle();
	call allertokviewshowtitle
; 37     AllertOkViewLoopKey();
; 38 }
; 39 
; 40 void AllertOkViewLoopKey() {
allertokviewloopkey:
; 41     push_pop(bc) {
	push bc
; 42         b = 0;
	ld b, 0
; 43         do {
__l_780:
; 44             getKeyboardCharA();
	call getkeyboardchara
; 45             c = a;
	ld c, a
; 46             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, __l_783
; 47                 b = 1;
	ld b, 1
	jp __l_784
__l_783:
; 48             } else if ((a = c) == 0x0D) { //Enter
	ld a, c
	cp 13
	jp nz, __l_785
; 49                 b = 1;
	ld b, 1
__l_785:
__l_784:
__l_781:
; 50             }
; 51         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, __l_780
; 52         AllertOkViewClose();
	call allertokviewclose
	pop bc
	ret
; 53     }
; 54 }
; 55 
; 56 void AllertOkViewClose() {
allertokviewclose:
; 57     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 58     CurrentViewReturn();
	jp currentviewreturn
; 59 }
; 60 
; 61 void AllertOkViewShowTitle() {
allertokviewshowtitle:
; 62     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 63         hl = AllertOkViewTitlePoint;
	ld hl, (allertokviewtitlepoint)
; 64         b = 0;
	ld b, 0
; 65         a = AllertOkViewDX;
	ld a, (allertokviewdx)
; 66         c = a;
	ld c, a
; 67         do {
__l_787:
; 68             a = *hl;
	ld a, (hl)
; 69             d = a;
	ld d, a
; 70             hl++;
	inc hl
; 71             if (a > 0) {
	or a
	jp z, __l_790
; 72                 b++;
	inc b
__l_790:
; 73             }
; 74             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, __l_792
; 75                 d = 0;
	ld d, 0
__l_792:
__l_788:
; 76             }
; 77         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, __l_787
; 78         a = AllertOkViewDX;
	ld a, (allertokviewdx)
; 79         a -= b;
	sub b
; 80         a &= 0xFE;
	and 254
; 81         cyclic_rotate_right(a, 1);
	rrca
; 82         b = a;
	ld b, a
; 83         a = AllertOkViewX;
	ld a, (allertokviewx)
; 84         a += b;
	add b
; 85         l = a;
	ld l, a
; 86         a = AllertOkViewY;
	ld a, (allertokviewy)
; 87         a += 2;
	add 2
; 88         h = a;
	ld h, a
; 89         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 90         bios(a = biosPrintMessageHL, hl = AllertOkViewTitlePoint);
	ld a, 2
	ld hl, (allertokviewtitlepoint)
	call bios
	pop bc
	pop de
	pop hl
	ret
; 91     }
; 92 }
; 93 
; 94 uint8_t AllertOkViewX = 12;
allertokviewx:
	db 12
; 95 uint8_t AllertOkViewY = 12;
allertokviewy:
	db 12
; 96 uint8_t AllertOkViewDX = 24;
allertokviewdx:
	db 24
; 97 uint8_t AllertOkViewDY = 9;
allertokviewdy:
	db 9
; 98 uint8_t AllertOkViewColor = 0x70; // 0x1F;
allertokviewcolor:
	db 112
; 100 uint16_t AllertOkViewTitlePoint = 0;
allertokviewtitlepoint:
	dw 0
; 11 void LoadViewShowHL() {
loadviewshowhl:
; 12     CurrentViewChangeAndPushIdA(a = LoadViewId);
	ld a, 4
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         bios(a = biosSetExtDRVConfigB, b = 0x02);
	ld a, 83
	ld b, 2
	call bios
; 15         c = (a = LoadViewColor);
	ld a, (loadviewcolor)
	ld c, a
; 16         l = (a = LoadViewX);
	ld a, (loadviewx)
	ld l, a
; 17         h = (a = LoadViewY);
	ld a, (loadviewy)
	ld h, a
; 18         e = (a = LoadViewDX);
	ld a, (loadviewdx)
	ld e, a
; 19         d = (a = LoadViewDY);
	ld a, (loadviewdy)
	ld d, a
; 20         bios(a = biosWindowSafeOpen);
	ld a, 87
	call bios
; 21         MyFuncSetFullScreen();
	call myfuncsetfullscreen
	pop de
	pop hl
	pop bc
; 22     }
; 23     LoadViewShowTitleHL();
	call loadviewshowtitlehl
; 24     LoadViewShowInfoString();
	call loadviewshowinfostring
; 25     LoadViewShowInfoSubString();
	jp loadviewshowinfosubstring
; 26 }
; 27 
; 28 void LoadViewClose() {
loadviewclose:
; 29     bios(a = biosWindowSafeClose);
	ld a, 88
	call bios
; 30     CurrentViewReturn();
	jp currentviewreturn
; 31 }
; 32 
; 33 void LoadViewShowTitleHL() {
loadviewshowtitlehl:
; 34     push_pop(bc) {
	push bc
; 35         push_pop(hl) {
	push hl
; 36             b = 0;
	ld b, 0
; 37             do {
__l_794:
; 38                 a = *hl;
	ld a, (hl)
; 39                 c = a;
	ld c, a
; 40                 hl++;
	inc hl
; 41                 b++;
	inc b
; 42                 if ((a = LoadViewDX) < b) {
	ld a, (loadviewdx)
	cp b
	jp nc, __l_797
; 43                     a = 0;
	ld a, 0
; 44                     c = a;
	ld c, a
__l_797:
__l_795:
; 45                 }
; 46             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_794
	pop hl
; 47         }
; 48         a = LoadViewDX;
	ld a, (loadviewdx)
; 49         a -= b;
	sub b
; 50         a &= 0xFE;
	and 254
; 51         cyclic_rotate_right(a, 1);
	rrca
; 52         c = a;
	ld c, a
; 53         push_pop(hl) {
	push hl
; 54             // X
; 55             a = LoadViewX;
	ld a, (loadviewx)
; 56             a += c;
	add c
; 57             l = a;
	ld l, a
; 58             // Y
; 59             a = LoadViewY;
	ld a, (loadviewy)
; 60             a += 1;
	add 1
; 61             h = a;
	ld h, a
; 62             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
	pop hl
; 63         }
; 64         bios(a = biosPrintMessageHL);
	ld a, 2
	call bios
	pop bc
	ret
; 65     }
; 66 }
; 67 
; 68 void LoadViewShowInfoString() {
loadviewshowinfostring:
; 69     push_pop(hl) {
	push hl
; 70         // X
; 71         a = LoadViewX;
	ld a, (loadviewx)
; 72         a += 1;
	add 1
; 73         l = a;
	ld l, a
; 74         // Y
; 75         a = LoadViewY;
	ld a, (loadviewy)
; 76         a += 3;
	add 3
; 77         h = a;
	ld h, a
; 78         //
; 79         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 80         bios(a = biosPrintMessageHL, hl = LoadViewInfoString);
	ld a, 2
	ld hl, loadviewinfostring
	call bios
	pop hl
	ret
; 81     }
; 82 }
; 83 
; 84 void LoadViewShowInfoSubString() {
loadviewshowinfosubstring:
; 85     push_pop(hl) {
	push hl
; 86         // X
; 87         a = LoadViewX;
	ld a, (loadviewx)
; 88         a += 1;
	add 1
; 89         l = a;
	ld l, a
; 90         // Y
; 91         a = LoadViewY;
	ld a, (loadviewy)
; 92         a += 7;
	add 7
; 93         h = a;
	ld h, a
; 94         //
; 95         bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 96         bios(a = biosPrintMessageHL, hl = LoadViewInfoSubString);
	ld a, 2
	ld hl, loadviewinfosubstring
	call bios
	pop hl
	ret
; 97     }
; 98 }
; 99 
; 100 uint8_t LoadViewShowProgressOld = 0xFF;
loadviewshowprogressold:
	db 255
; 101 void LoadViewShowProgressA() {
loadviewshowprogressa:
; 102     push_pop(bc, hl) {
	push bc
	push hl
; 103         b = a; //Save
	ld b, a
; 104         if ((a = LoadViewShowProgressOld) != b) {
	ld a, (loadviewshowprogressold)
	cp b
	jp z, __l_799
; 105             a = b;
	ld a, b
; 106             LoadViewShowProgressOld = a;
	ld (loadviewshowprogressold), a
; 107             // X
; 108             a = LoadViewX;
	ld a, (loadviewx)
; 109             a += 1;
	add 1
; 110             l = a;
	ld l, a
; 111             // Y
; 112             a = LoadViewY;
	ld a, (loadviewy)
; 113             a += 5; //2;
	add 5
; 114             h = a;
	ld h, a
; 115             bios(a = biosSetPositionCursoreHL);
	ld a, 28
	call bios
; 116             h = 0;
	ld h, 0
; 117             do {
__l_801:
; 118                 if ((a = h) < b) {
	ld a, h
	cp b
	jp nc, __l_804
; 119                     bios(a = biosPrintC, c = 0xBF);
	ld a, 0
	ld c, 191
	call bios
	jp __l_805
__l_804:
; 120                 } else {
; 121                     bios(a = biosPrintC, c = 0xBC);
	ld a, 0
	ld c, 188
	call bios
__l_805:
; 122                 }
; 123                 h++;
	inc h
__l_802:
; 124             } while ((a = h) < 40);
	ld a, h
	cp 40
	jp c, __l_801
__l_799:
	pop hl
	pop bc
	ret
; 125         }
; 126     }
; 127 }
; 128 
; 129 uint8_t LoadViewX = 3;
loadviewx:
	db 3
; 130 uint8_t LoadViewY = 11; //14;
loadviewy:
	db 11
; 131 uint8_t LoadViewDX = 42;
loadviewdx:
	db 42
; 132 uint8_t LoadViewDY = 9; //4;
loadviewdy:
	db 9
; 133 uint8_t LoadViewColor = 0x70; // 0x1F;
loadviewcolor:
	db 112
; 135 uint8_t LoadViewProgress = 0;
loadviewprogress:
	db 0
; 137 uint8_t LoadViewLoadTitle[] = "Load...";
loadviewloadtitle:
	db 76
	db 111
	db 97
	db 100
	db 46
	db 46
	db 46
	ds 1
; 138 uint8_t LoadViewUploadTitle[] = "Upload...";
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
; 140 uint8_t LoadViewFTPPrefix[] = "ftp:";
loadviewftpprefix:
	db 102
	db 116
	db 112
	db 58
	ds 1
; 141 uint8_t LoadViewInfoString[41] = "";
loadviewinfostring:
	ds 41
; 142 uint8_t LoadViewInfoSubString[41] = "";
loadviewinfosubstring:
	ds 41
; 144 uint8_t LoadViewStrFrom[] = "From:";
loadviewstrfrom:
	db 70
	db 114
	db 111
	db 109
	db 58
	ds 1
; 145 uint8_t LoadViewStrTo[] = "To:";
loadviewstrto:
	db 84
	db 111
	db 58
	ds 1
; 146 uint8_t LoadViewStrName[] = "Name:";
loadviewstrname:
	db 78
	db 97
	db 109
	db 101
	db 58
	ds 1
; 147 uint8_t LoadViewStrSize[] = "Size:";
loadviewstrsize:
	db 83
	db 105
	db 122
	db 101
	db 58
	ds 1
; 11 void FileParserFtpLoadFileNextParse() {
fileparserftploadfilenextparse:
; 12     push_pop(hl, bc) {
	push hl
	push bc
; 13         if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_806
; 14             FileParserFtpLoadFileNextParseSum();
	call fileparserftploadfilenextparsesu
; 15             if ((a = FileParserSumStateNext) == 0x01) {
	ld a, (fileparsersumstatenext)
	cp 1
	jp nz, __l_808
; 16                 push_pop(bc, de) {
	push bc
	push de
; 17                     // FileParserDataCount = len Data
; 18                     a = l;
	ld a, l
; 19                     a -= 5;
	sub 5
; 20                     FileParserDataCount = a;
	ld (fileparserdatacount), a
; 21                     // Load Buffer
; 22                     de = Net_buffer;
	ld de, net_buffer
; 23                     //-- Address
; 24                     a = *de;
	ld a, (de)
; 25                     l = a;
	ld l, a
; 26                     de++;
	inc de
; 27                     a = *de;
	ld a, (de)
; 28                     h = a;
	ld h, a
; 29                     FileParserLoadFileAddress = hl;
	ld (fileparserloadfileaddress), hl
; 30                     de++;
	inc de
; 31                     //-- Progress
; 32                     LoadViewShowProgressA(a = *de);
	ld a, (de)
	call loadviewshowprogressa
; 33                     de++;
	inc de
; 34                     //-- 0x3C
; 35                     de++;
	inc de
; 36                     //-- Если адрес = 0х0000 нужно создать файл
; 37                     FileParserFtpLoadFileNeedFileCreate();
	call fileparserftploadfileneedfilecre
; 38                     FileParserFtpLoadSaveBufferInFile();
	call fileparserftploadsavebufferinfil
	pop de
	pop bc
__l_808:
	jp __l_807
__l_806:
; 39                     
; 40                 }
; 41             }
; 42         } else {
__l_807:
	pop bc
	pop hl
	ret
; 43             //hl = FileParserLoadFileStopAddress;
; 44             //ordos_stop();
; 45             // TODO Error!!!
; 46         }
; 47     }
; 48 }
; 49 
; 50 ///  Если address == 0, То пишем файл и сдвигаем буфер + 0x10 на данные
; 51 void FileParserFtpLoadFileNeedFileCreate() {
fileparserftploadfileneedfilecre:
; 52     push_pop(hl, bc) {
	push hl
	push bc
; 53         hl = FileParserLoadFileAddress;
	ld hl, (fileparserloadfileaddress)
; 54         a = h;
	ld a, h
; 55         a |= l;
	or l
; 56         if (flag_z) {
	jp nz, __l_810
; 57             h = d;
	ld h, d
; 58             l = e;
	ld l, e
; 59             // Обрезаем имя файла
; 60             DiskViewCopyFileNameByHL();
	call diskviewcopyfilenamebyhl
; 61             // Устанавливаем Имя файла в DsDos
; 62             push_pop(hl) {
	push hl
; 63                 bios(a = biosSetNameBufferHL, hl = DiskViewFileName);
	ld a, 133
	ld hl, diskviewfilename
	call bios
	pop hl
; 64             }
; 65             push_pop(de) {
	push de
; 66                 // Получаем атрибуты файла
; 67                 bc = 8;
	ld bc, 8
; 68                 hl += bc;
	add hl, bc
; 69                 // адрес посадки
; 70                 e = (a = *hl);
	ld a, (hl)
	ld e, a
; 71                 hl++;
	inc hl
; 72                 d = (a = *hl);
	ld a, (hl)
	ld d, a
; 73                 hl++;
	inc hl
; 74                 push_pop(hl) {
	push hl
; 75                     h = d;
	ld h, d
; 76                     l = e;
	ld l, e
; 77                     FileParserTempAddress = hl;
	ld (fileparsertempaddress), hl
	pop hl
; 78                 }
; 79                 // длина
; 80                 e = (a = *hl);
	ld a, (hl)
	ld e, a
; 81                 hl++;
	inc hl
; 82                 d = (a = *hl);
	ld a, (hl)
	ld d, a
; 83                 hl++;
	inc hl
; 84                 // атрибуты
; 85                 c = (a = *hl);
	ld a, (hl)
	ld c, a
; 86                 hl++;
	inc hl
; 87                 // рабочая страница ОЗУ
; 88                 b = (a = *hl);
	ld a, (hl)
	ld b, a
; 89                 push_pop(hl) {
	push hl
; 90                     hl = FileParserTempAddress;
	ld hl, (fileparsertempaddress)
; 91                     // Записываем атрибуты файла
; 92                     bios(a = biosSetFileAttributes);
	ld a, 135
	call bios
; 93                     // Записываем файл с данными из озу
; 94                     bios(a = biosSaveFile);
	ld a, 138
	call bios
; 95                     if (flag_c) {
	jp nc, __l_812
; 96                         // Записать 0 в номер файла - ошибка
; 97                         FileParserFileNum = (a = 0); // TODO надо прервать операцию
	ld a, 0
	ld (fileparserfilenum), a
	jp __l_813
__l_812:
; 98                     } else {
; 99                         // Получить номер файла в ОС
; 100                         FileParserSeekFileNum();
	call fileparserseekfilenum
; 101                         a = FileParserDataCount;
	ld a, (fileparserdatacount)
; 102                         a -= 0x10;
	sub 16
; 103                         FileParserDataCount = a;
	ld (fileparserdatacount), a
__l_813:
	pop hl
	pop de
; 104                     }
; 105                 }
; 106             }
; 107             // Смещаем указатель за заголовок файла
; 108             b = 16;
	ld b, 16
; 109             do {
__l_814:
; 110                 de++;
	inc de
; 111                 b--;
	dec b
__l_815:
; 112             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_814
	jp __l_811
__l_810:
; 113         } else {
; 114             push_pop(de, hl) {
	push de
	push hl
; 115                 // Если это не первая пачка - уменьшаем значение адреса на заголовок (0x10)
; 116                 de = 0xFFF0;
	ld de, 65520
; 117                 hl = FileParserLoadFileAddress;
	ld hl, (fileparserloadfileaddress)
; 118                 hl += de;
	add hl, de
; 119                 FileParserLoadFileAddress = hl;
	ld (fileparserloadfileaddress), hl
	pop hl
	pop de
__l_811:
	pop bc
	pop hl
	ret
; 120             }
; 121         }
; 122     }
; 123 }
; 124 
; 125 void FileParserSeekFileNum() {
fileparserseekfilenum:
; 126     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 127         de = DiskViewFileName;
	ld de, diskviewfilename
; 128         hl = 0x2000;
	ld hl, 8192
; 129         bc = 0x0010;
	ld bc, 16
; 130         do {
__l_817:
; 131             push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 132                 FileParserFileNameCompareHLDEToA();
	call fileparserfilenamecomparehldetoa
	pop de
	pop bc
	pop hl
; 133             }
; 134             if (a == 1) {
	cp 1
	jp nz, __l_820
; 135                 push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 136                     de = 0x0FF0;
	ld de, 4080
; 137                     hl &= de;
	add hl, de
; 138                     hl <<= 4; //8;
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
; 139                     // Индекс файла начинаеться с 1, а не с 0
; 140                     a = h;
	ld a, h
; 141                     a += 2; //1; ??? TODO почему 2?
	add 2
; 142                     FileParserFileNum = a;
	ld (fileparserfilenum), a
	pop de
	pop bc
	pop hl
__l_820:
; 143                 }
; 144             }
; 145             hl += bc;
	add hl, bc
; 146             push_pop(bc, hl) {
	push bc
	push hl
; 147                 ///hl - адрес, a - номер доп. страницы (1-3). выход: c - считанный байт
; 148                 readByteInOtherMem(a = 1);
	ld a, 1
	call readbyteinothermem
; 149                 if ((a = h) >= 0x3F) {
	ld a, h
	cp 63
	jp c, __l_822
; 150                     a = 0;
	ld a, 0
	jp __l_823
__l_822:
; 151                 } else {
; 152                     a = c;
	ld a, c
__l_823:
	pop hl
	pop bc
__l_818:
; 153                 }
; 154             }
; 155         } while (a > 0);
	or a
	jp nz, __l_817
	pop de
	pop bc
	pop hl
	ret
; 156     }
; 157 }
; 158 
; 159 void FileParserFileNameCompareHLDEToA() {
fileparserfilenamecomparehldetoa:
; 160     b = 8;
	ld b, 8
; 161     do {
__l_824:
; 162         push_pop(bc) {
	push bc
; 163             readByteInOtherMem(a = 1);
	ld a, 1
	call readbyteinothermem
; 164             a = c;
	ld a, c
	pop bc
; 165         }
; 166         c = a;
	ld c, a
; 167         if ((a = *de) != c) {
	ld a, (de)
	cp c
	jp z, __l_827
; 168             return a = 0;
	ld a, 0
	ret
__l_827:
; 169         }
; 170         b--;
	dec b
; 171         hl++;
	inc hl
; 172         de++;
	inc de
__l_825:
; 173     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_824
; 174     return a = 1;
	ld a, 1
	ret
; 175 }
; 176 
; 177 void FileParserFtpLoadFileNextParseSum() {
fileparserftploadfilenextparsesu:
; 178     push_pop(hl, bc) {
	push hl
	push bc
; 179         b = l;
	ld b, l
; 180         b--;
	dec b
; 181         hl = Net_buffer;
	ld hl, net_buffer
; 182         c = 0;
	ld c, 0
; 183         do {
__l_829:
; 184             a = *hl;
	ld a, (hl)
; 185             a += c;
	add c
; 186             c = a;
	ld c, a
; 187             hl++;
	inc hl
; 188             b--;
	dec b
__l_830:
; 189         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_829
; 190         a = *hl;
	ld a, (hl)
; 191         if (a == c) {
	cp c
	jp nz, __l_832
; 192             a = 0x01;
	ld a, 1
; 193             FileParserSumStateNext = a;
	ld (fileparsersumstatenext), a
	jp __l_833
__l_832:
; 194         } else {
; 195             a = 0x00;
	ld a, 0
; 196             FileParserSumStateNext = a;
	ld (fileparsersumstatenext), a
__l_833:
; 197         }
; 198         //-- 3 byte = byte 0x3C
; 199         hl = Net_buffer;
	ld hl, net_buffer
; 200         hl++;
	inc hl
; 201         hl++;
	inc hl
; 202         hl++;
	inc hl
; 203         a = *hl;
	ld a, (hl)
; 204         if (a != 0x3C) {
	cp 60
	jp z, __l_834
; 205             a = 0x00;
	ld a, 0
; 206             FileParserSumStateNext = a;
	ld (fileparsersumstatenext), a
__l_834:
	pop bc
	pop hl
	ret
; 207         }
; 208     }
; 209 }
; 210 
; 211 // DE = буфер
; 212 void FileParserFtpLoadSaveBufferInFile() {
fileparserftploadsavebufferinfil:
; 213     push_pop(hl, bc) {
	push hl
	push bc
; 214         // Адрес с которого начинаем писатьв файл
; 215         hl = FileParserLoadFileAddress;
	ld hl, (fileparserloadfileaddress)
; 216         // Кол-во байт для записи
; 217         c = (a = FileParserDataCount);
	ld a, (fileparserdatacount)
	ld c, a
; 218         FileParserFtpUpdatePosSectorByHL();
	call fileparserftpupdatepossectorbyhl
; 219         do {
__l_836:
; 220             //--
; 221             push_pop(hl, bc) {
	push hl
	push bc
; 222                 c = (a = *de);
	ld a, (de)
	ld c, a
; 223                 h = (a = FileParserSectorNum);
	ld a, (fileparsersectornum)
	ld h, a
; 224                 /// hl = addr a = page c = byte
; 225                 writeByteInOtherMem(a = FileParserSectorPage);
	ld a, (fileparsersectorpage)
	call writebyteinothermem
	pop bc
	pop hl
; 226             }
; 227             //--
; 228             c--;
	dec c
; 229             hl++;
	inc hl
; 230             de++;
	inc de
; 231             if ((a = l) == 0) {
	ld a, l
	or a
	jp nz, __l_839
; 232                 FileParserFtpUpdatePosSectorByHL();
	call fileparserftpupdatepossectorbyhl
__l_839:
__l_837:
; 233             }
; 234         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, __l_836
	pop bc
	pop hl
	ret
; 235     }
; 236 }
; 237 
; 238 void FileParserFtpUpdatePosSectorByHL() {
fileparserftpupdatepossectorbyhl:
; 239     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 240         // Обнуляем сектор начала поиска
; 241         FileParserSectorDeltaPage = (a = 0);
	ld a, 0
	ld (fileparsersectordeltapage), a
; 242         // Ищем h раз по номеру FileParserFileNum
; 243         l = (a = FileParserFileNum);
	ld a, (fileparserfilenum)
	ld l, a
; 244         de = 0x3000;
	ld de, 12288
; 245         b = 0; // Page 2/3 4/5 5/7
	ld b, 0
; 246         c = 0; // Sector
	ld c, 0
; 247         do {
__l_841:
; 248             push_pop(bc, hl) {
	push bc
	push hl
; 249                 ///hl - адрес, a - номер доп. страницы (1-3). выход: c - считанный байт
; 250                 h = d;
	ld h, d
; 251                 l = e;
	ld l, e
; 252                 readByteInOtherMem(a = 1);
	ld a, 1
	call readbyteinothermem
; 253                 a = c;
	ld a, c
	pop hl
	pop bc
; 254             }
; 255             //a = *de;
; 256             if (a == l) {
	cp l
	jp nz, __l_844
; 257                 if ((a = h) == 0) {
	ld a, h
	or a
	jp nz, __l_846
; 258                     a = b;
	ld a, b
; 259                     a += 2;
	add 2
; 260                     b = a;
	ld b, a
; 261                     a = FileParserSectorDeltaPage;
	ld a, (fileparsersectordeltapage)
; 262                     a += b;
	add b
; 263                     FileParserSectorPage = a;
	ld (fileparsersectorpage), a
; 264                     FileParserSectorNum = (a = c);
	ld a, c
	ld (fileparsersectornum), a
; 265                     a = 1;
	ld a, 1
	jp __l_847
__l_846:
; 266                 } else {
; 267                     h--;
	dec h
; 268                     FileParserNextSectorCPageB();
	call fileparsernextsectorcpageb
; 269                     a = 0;
	ld a, 0
__l_847:
	jp __l_845
__l_844:
; 270                 }
; 271             } else {
; 272                 FileParserNextSectorCPageB();
	call fileparsernextsectorcpageb
; 273                 a = 0;
	ld a, 0
__l_845:
; 274             }
; 275             de++;
	inc de
__l_842:
; 276         } while (a == 0);
	or a
	jp z, __l_841
	pop de
	pop bc
	pop hl
	ret
; 277     }
; 278 }
; 279 
; 280 void FileParserNextSectorCPageB() {
fileparsernextsectorcpageb:
; 281     push_pop(a) {
	push af
; 282         b++;
	inc b
; 283         if ((a = b) >= 0x02) {
	ld a, b
	cp 2
	jp c, __l_848
; 284             b = 0;
	ld b, 0
; 285             c++;
	inc c
; 286             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, __l_850
; 287                 a = FileParserSectorDeltaPage;
	ld a, (fileparsersectordeltapage)
; 288                 a += 2;
	add 2
; 289                 FileParserSectorDeltaPage = a;
	ld (fileparsersectordeltapage), a
__l_850:
__l_848:
	pop af
	ret
; 290             }
; 291         }
; 292     }
; 293 }
; 294 
; 295 uint8_t FileParserSectorDeltaPage = 0;
fileparsersectordeltapage:
	db 0
; 296 uint8_t FileParserSectorPage = 0;
fileparsersectorpage:
	db 0
; 297 uint8_t FileParserSectorNum = 0;
fileparsersectornum:
	db 0
; 299 uint8_t FileParserDataCount = 0;
fileparserdatacount:
	db 0
; 300 uint8_t FileParserFileNum = 0;
fileparserfilenum:
	db 0
; 301 uint8_t FileParserSumStateNext = 0;
fileparsersumstatenext:
	db 0
; 302 uint16_t FileParserLoadFileAddress = 0;
fileparserloadfileaddress:
	dw 0
; 303 uint16_t FileParserLoadFileStopAddress = 0;
fileparserloadfilestopaddress:
	dw 0
; 304 uint16_t FileParserTempAddress = 0;
fileparsertempaddress:
	dw 0
; 11 void DetectHardwareESPSendAndGetHL() {
detecthardwareespsendandgethl:
; 12     ESPErrorClear();
	call esperrorclear
; 13     push_pop(bc, de) {
	push bc
	push de
; 14         //-- Send Key
; 15         c = ESP_Reg_IsBegin;
	ld c, 64
; 16         DetectHardwareESPSendByteAC(a = h);
	ld a, h
	call detecthardwareespsendbyteac
; 17         if ((a = ESPError) == 0) { // Нет ошибок - продолжаем
	ld a, (esperror)
	or a
	jp nz, __l_852
; 18             //-- Send Data
; 19             if ((a = l) > 0) {
	ld a, l
	or a
	jp z, __l_854
; 20                 b = l;
	ld b, l
; 21                 hl = Net_buffer;
	ld hl, net_buffer
; 22                 do {
__l_856:
; 23                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, __l_859
; 24                         c = ESP_Reg_IsEnd;
	ld c, 128
	jp __l_860
__l_859:
; 25                     } else {
; 26                         c = 0;
	ld c, 0
__l_860:
; 27                     }
; 28                     DetectHardwareESPSendByteAC(a = *hl);
	ld a, (hl)
	call detecthardwareespsendbyteac
; 29                     hl++;
	inc hl
; 30                     b--;
	dec b
__l_857:
; 31                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_856
__l_854:
; 32             }
; 33             //-- Get Data
; 34             b = 0;
	ld b, 0
; 35             hl = Net_buffer;
	ld hl, net_buffer
; 36             c = 1;
	ld c, 1
; 37             do {
__l_861:
; 38                 DetectHardwareESPGetByteAD(); // a - data d - reg
	call detecthardwareespgetbytead
; 39                 e = a;
	ld e, a
; 40                 //ESP_Reg_In_IsEnd
; 41                 //a = ESP_Reg_In_NoData + ESP_Reg_In_IsEnd;
; 42                 a = ESP_Reg_In_NoData;
	ld a, 4
; 43                 a &= d;
	and d
; 44                 if (a == 0) {
	or a
	jp nz, __l_864
; 45                     a = ESP_Reg_In_IsEnd;
	ld a, 8
; 46                     a &= d;
	and d
; 47                     if (a > 0) {
	or a
	jp z, __l_866
; 48                         c = 0;
	ld c, 0
__l_866:
; 49                     }
; 50                     *hl = (a = e);
	ld a, e
	ld (hl), a
; 51                     hl++;
	inc hl
; 52                     b++;
	inc b
; 53                     if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, __l_868
; 54                         c = 0;
	ld c, 0
__l_868:
	jp __l_865
__l_864:
; 55                     }
; 56                 } else {
; 57                     c = 0;
	ld c, 0
__l_865:
__l_862:
; 58                 }
; 59             } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, __l_861
; 60             l = b;
	ld l, b
__l_852:
	pop de
	pop bc
	ret
; 61         }
; 62     }
; 63 }
; 64 
; 65 void DetectHardwareESPGetByteAD() {
detecthardwareespgetbytead:
; 66     push_pop(hl, bc) {
	push hl
	push bc
; 67         // Проверим - не занят ли ESP
; 68         DetectHardwareESPWaitingForBusy();
	call detecthardwareespwaitingforbusy
; 69         // A на вход
; 70         i8255PortAIn();
	call i8255portain
; 71         // Послать сигнал что готовы к данным
; 72         i8255_SckIsWriteA(a = 0);
	ld a, 0
	call i8255_sckiswritea
; 73         // Ждем данные
; 74         DetectHardwareESPWaitingForReady();
	call detecthardwareespwaitingforready
; 75         // Читаем данные
; 76         i8255_ReadData();
	call i8255_readdata
; 77         b = a;
	ld b, a
; 78         // Читаем регистр
; 79         i8255_ReadReg();
	call i8255_readreg
; 80         d = a;
	ld d, a
; 81         //
; 82         i8255_Sck0();
	call i8255_sck0
; 83         //
; 84         a = b;
	ld a, b
	pop bc
	pop hl
	ret
; 85     }
; 86 }
; 87 
; 88 void DetectHardwareESPSendByteAC() {
detecthardwareespsendbyteac:
; 89     push_pop(bc) {
	push bc
; 90         b = a;
	ld b, a
; 91         // Проверим - не занят ли ESP
; 92         DetectHardwareESPWaitingForBusy();
	call detecthardwareespwaitingforbusy
; 93         // A на выход
; 94         i8255PortAOut();
	call i8255portaout
; 95         // Установить A в порт A
; 96         i8255_WriteData(a = b);
	ld a, b
	call i8255_writedata
; 97         // Послать сигнал что данные готовы
; 98         a = ESP_Reg_IsWrite;
	ld a, 32
; 99         a |= c;
	or c
; 100         i8255_SckIsWriteA();
	call i8255_sckiswritea
; 101         // Ждем подтверждения
; 102         DetectHardwareESPWaitingForReady();
	call detecthardwareespwaitingforready
; 103         //
; 104         i8255_Sck0();
	call i8255_sck0
	pop bc
	ret
; 105     }
; 106 }
; 107 
; 108 /// Проверка что ESP занят
; 109 void DetectHardwareESPWaitingForBusy() {
detecthardwareespwaitingforbusy:
; 110     DetectHardwareESPErrorInitHL(hl = 30000);
	ld hl, 30000
	call detecthardwareesperrorinithl
; 111     push_pop(bc) {
	push bc
; 112         do {
__l_870:
; 113             a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 114             a &= ESP_Reg_Busy;
	and 1
; 115             if (a > 0) {
	or a
	jp z, __l_873
; 116                 c = 0;
	ld c, 0
	jp __l_874
__l_873:
; 117             } else {
; 118                 c = 1;
	ld c, 1
__l_874:
; 119             }
; 120             DetectHardwareESPErrorStep();
	call detecthardwareesperrorstep
__l_871:
; 121         } while ((a = c) == 0);
	ld a, c
	or a
	jp z, __l_870
	pop bc
	ret
; 122     }
; 123 }
; 124 
; 125 void DetectHardwareESPWaitingForReady() {
detecthardwareespwaitingforready:
; 126     DetectHardwareESPErrorInitHL(hl = 30000);
	ld hl, 30000
	call detecthardwareesperrorinithl
; 127     push_pop(bc) {
	push bc
; 128         b = 0;
	ld b, 0
; 129         do {
__l_875:
; 130             a = i8255_PORT_C;
	ld a, (i8255_port_c)
; 131             a &= ESP_Reg_Ready;
	and 2
; 132             c = a;
	ld c, a
; 133             DetectHardwareESPErrorStep();
	call detecthardwareesperrorstep
__l_876:
; 134         } while ((a = c) == 0);
	ld a, c
	or a
	jp z, __l_875
	pop bc
	ret
; 135     }
; 136 }
; 137 
; 138 void DetectHardwareESPErrorInitHL() {
detecthardwareesperrorinithl:
; 139     DetectHardwareESPErrorStepCount = hl;
	ld (detecthardwareesperrorstepcount), hl
	ret
; 140 }
; 141 
; 142 void DetectHardwareESPErrorStep() {
detecthardwareesperrorstep:
; 143     push_pop(hl) {
	push hl
; 144         hl = DetectHardwareESPErrorStepCount;
	ld hl, (detecthardwareesperrorstepcount)
; 145         // Compare hl == 0
; 146         a = h;
	ld a, h
; 147         a |= l;
	or l
; 148         if (a == 0) {
	or a
	jp nz, __l_878
; 149             //-- Error!!! --
; 150             ESPError = (a = ESPError_TimeOut);
	ld a, 1
	ld (esperror), a
; 151             c = 1;
	ld c, 1
	jp __l_879
__l_878:
; 152         } else {
; 153             hl--;
	dec hl
__l_879:
; 154         }
; 155         DetectHardwareESPErrorStepCount = hl;
	ld (detecthardwareesperrorstepcount), hl
	pop hl
	ret
; 156     }
; 157 }
; 158 
; 159 uint16_t DetectHardwareESPErrorStepCount = 0;
detecthardwareesperrorstepcount:
	dw 0
; 15 void DetectHardwareVersion() {
detecthardwareversion:
; 16     DetectHardwareGetBoardID();
	call detecthardwaregetboardid
; 17     if ((a = ESPError) == 0) {
	ld a, (esperror)
	or a
	jp nz, __l_880
; 18         a = 1;
	ld a, 1
	jp __l_881
__l_880:
; 19     } else {
; 20         a = 0;
	ld a, 0
__l_881:
	ret
; 21     }
; 22 }
; 23 
; 24 void DetectHardwareGetBoardID() {
detecthardwaregetboardid:
; 25     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 26         h = 0; // GET_BoardID = 0,
	ld h, 0
; 27         l = 0; // Len NedBuffer
	ld l, 0
; 28         DetectHardwareESPSendAndGetHL();
	call detecthardwareespsendandgethl
; 29         //--
; 30         // l - длина Net_buffer - буфер
; 31         b = l;
	ld b, l
; 32         b--;
	dec b
; 33         c = 0; // Сумма
	ld c, 0
; 34         d = 0; // Последний байт
	ld d, 0
; 35         hl = Net_buffer;
	ld hl, net_buffer
; 36         do {
__l_882:
; 37             a = *hl;
	ld a, (hl)
; 38             //a = *hl;
; 39             d = a;
	ld d, a
; 40             a = *hl;
	ld a, (hl)
; 41             a += c;
	add c
; 42             c = a;
	ld c, a
; 43             hl++;
	inc hl
; 44             b--;
	dec b
__l_883:
; 45         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, __l_882
; 46         // Если контроьная сумма не совпала
; 47         if ((a = *hl) != c) {
	ld a, (hl)
	cp c
	jp z, __l_885
; 48             ESPError = (a = ESPError_Response);
	ld a, 2
	ld (esperror), a
__l_885:
; 49         }
; 50         // Если последный байт не 0x3C
; 51         if ((a = d) != 0x3C) {
	ld a, d
	cp 60
	jp z, __l_887
; 52             ESPError = (a = ESPError_Response);
	ld a, 2
	ld (esperror), a
__l_887:
	pop de
	pop bc
	pop hl
	ret
; 47 uint8_t Net_buffer_len = 0;
net_buffer_len:
	db 0
; 48 uint8_t Net_buffer[1];
net_buffer:
	ds 1
 savebin "KFTP-2D.ord", 0x0ff0, 0x3210
