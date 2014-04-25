				CSEG	AT	0

XRAM_257		equ 0x257
XRAM_258		equ 0x258

XRAM_533		equ 0x533
XRAM_534		equ 0x534
XRAM_535		equ 0x535
XRAM_536		equ 0x536
XRAM_537		equ 0x537
XRAM_538		equ 0x538
XRAM_539		equ 0x539
XRAM_53A		equ 0x53A
XRAM_53B		equ 0x53B
XRAM_53D		equ 0x53D
	
XRAM_547		equ	0x547
XRAM_54B		equ 0x54B
XRAM_54C		equ 0x54C

XRAM_550		equ	0x550
XRAM_552		equ	0x552

XRAM_563		equ 0x563
XRAM_564		equ 0x564
XRAM_565		equ 0x565

XRAM_574		EQU	0x574
XRAM_575		EQU	0x575

C2_FPDAT_57A	equ 0x57A
XRAM_57C		equ 0x57C
XRAM_5A2		equ 0x5A2
XRAM_5A3		equ 0x5A3
XRAM_5A8		equ 0x5A8
XRAM_5A9		equ 0x5A9
XRAM_5AC		equ 0x5AC
XRAM_5AD		equ 0x5AD
XRAM_5AE		equ 0x5AE
XRAM_5AF		equ 0x5AF

XRAM_5B0		equ 0x5B0

; enum USBREG_e	(width 1 byte)
USBREG_82		equ 0x82
USBREG_84		equ 0x84
USBREG_86		equ 0x86
USBREG_91		equ 0x91

; enum HostResponse_e (width 1 byte)
RESP_00			equ 0
NOT_CONNECT		equ 1
RESP_01			equ 1
RESP_02			equ 2
RESP_03			equ 3
RESP_OK			equ 0xD


; enum PCA0MD_e	(width 1 byte)
CPS2			equ 8

; enum EIE1_e (width 1 byte)
ESMB0			equ 1
EUSB0			equ 2
EWADC0			equ 4
EADC0			equ 8
EPCA0			equ 0x10
ECP0			equ 0x20
ECP1			equ 0x40
ET3				equ 0x80


; enum ADC0CN_e	(width 1 byte)
AD0CM0			equ 1
AD0CM1			equ 2
AD0CM2			equ 4
AD0WINT			equ 8
AD0BUSY			equ 0x10
AD0INT			equ 0x20
AD0TM			equ 0x40
AD0EN			equ 0x80

; enum ADC0CF_e	(width 1 byte)
AD0LJST			equ 4
AD0SC0			equ 8
AD0SC1			equ 0x10
AD0SC2			equ 0x20
AD0SC3			equ 0x40
AD0SC4			equ 0x80

; ===========================================================================

RAM_0		equ 0
RAM_1		equ 1
RAM_2		equ 2
RAM_3		equ 3
RAM_4		equ 4
RAM_5		equ 5
RAM_6		equ 6
RAM_7		equ 7
RAM_8_GetIndexHi	equ 8
RAM_9_GetIndexLo	equ 9
RAM_A		equ 0xA
RAM_B		equ 0xB
RAM_C		equ 0xC
RAM_D		equ 0xD
RAM_E		equ 0xE
RAM_F		equ 0xF
RAM_1C		equ 0x1C
RAM_1D		equ 0x1D
RAM_1E		equ 0x1E
RAM_1F		equ 0x1F
RAM_20		equ 0x20
RAM_21		equ 0x21
RAM_22		equ 0x22
RAM_23		equ 0x23
RAM_24		equ 0x24
RAM_25		equ 0x25
RAM_26		equ 0x26
RAM_27		equ 0x27
RAM_28		equ 0x28
RAM_29		equ 0x29
RAM_2A		equ 0x2A
RAM_2B		equ 0x2B
RAM_2C		equ 0x2C
RAM_2D		equ 0x2D
RAM_2E		equ 0x2E
RAM_2F		equ 0x2F
RAM_30		equ 0x30
RAM_31		equ 0x31
RAM_32		equ 0x32
RAM_33		equ 0x33
RAM_34		equ 0x34
RAM_35		equ 0x35
RAM_36		equ 0x36
RAM_37		equ 0x37
RAM_38		equ 0x38
RAM_39		equ 0x39
RAM_3A		equ 0x3A
RAM_3B		equ 0x3B
RAM_3C		equ 0x3C
RAM_3D		equ 0x3D
RAM_3E		equ 0x3E
RAM_3F		equ 0x3F
RAM_40		equ 0x40
RAM_41		equ 0x41
RAM_42		equ 0x42
RAM_43		equ 0x43
RAM_44		equ 0x44
RAM_45		equ 0x45
RAM_46		equ 0x46
RAM_47		equ 0x47
RAM_48		equ 0x48
RAM_49		equ 0x49
RAM_4A		equ 0x4A
RAM_4B		equ 0x4B
RAM_4C		equ 0x4C
RAM_4D		equ 0x4D
RAM_4E		equ 0x4E
RAM_4F		equ 0x4F
RAM_50		equ 0x50
RAM_51		equ 0x51
RAM_52		equ 0x52
RAM_53_Cmd_0	equ 0x53
RAM_54_Cmd_1	equ 0x54
RAM_55_Cmd_2	equ 0x55
RAM_56				equ 0x56
RAM_57_AppEntry_H	equ 0x57
RAM_58_AppEntry_L	equ 0x58
RAM_59		equ 0x59
RAM_5A		equ 0x5A
RAM_5B		equ 0x5B
RAM_5C		equ 0x5C
RAM_5D		equ 0x5D
RAM_5E		equ 0x5E
RAM_5F		equ 0x5F
RAM_60		equ 0x60
RAM_61		equ 0x61
RAM_62		equ 0x62
RAM_63		equ 0x63
RAM_64		equ 0x64
RAM_65		equ 0x65
RAM_66		equ 0x66
RAM_67		equ 0x67
RAM_68		equ 0x68
RAM_69		equ 0x69
RAM_6A		equ 0x6A
RAM_6B		equ 0x6B
RAM_6C		equ 0x6C
RAM_6D		equ 0x6D

RAM_6F		equ 0x6F
RAM_70		equ 0x70
RAM_71		equ 0x71

RAM_73		equ 0x73
RAM_74		equ 0x74
RAM_75		equ 0x75
RAM_76		equ 0x76
RAM_87		equ 0x87
RAM_89		equ 0x89
RAM_8D		equ 0x8D
RAM_8E		equ 0x8E
RAM_8F		equ 0x8F
RAM_90		equ 0x90
RAM_91		equ 0x91
RAM_93		equ 0x93
RAM_94		equ 0x94
RAM_95		equ 0x95
RAM_96		equ 0x96
RAM_97		equ 0x97
RAM_98		equ 0x98
RAM_99		equ 0x99
RAM_9C		equ 0x9C
RAM_9D		equ 0x9D
RAM_A0		equ 0xA0
RAM_A1_LEDS	equ 0xA1
RAM_A2		equ 0xA2
RAM_A3		equ 0xA3
RAM_A4		equ 0xA4
RAM_A5		equ 0xA5
RAM_A6		equ 0xA6
RAM_A7		equ 0xA7
RAM_A8		equ 0xA8

; Segment type:	Internal processor memory & SFR

FSR_86		equ 0x86
CKCON		equ 0x8E
PSCTL		equ 0x8F
TMR3CN		equ 0x91
TMR3RLL		equ 0x92
TMR3RLH		equ 0x93
TMR3L		equ 0x94
TMR3H		equ 0x95
USB0ADR		equ 0x96

USB0DAT		equ 0x97
SCON0		equ 0x98
SBUF0		equ 0x99
CPT1CN		equ 0x9A
CPT0CN		equ 0x9B
CPT1MD		equ 0x9C
CPT0MD		equ 0x9D
CPT1MX		equ 0x9E
CPT0MX		equ 0x9F
SPI0CFG		equ 0xA1
SPI0CKR		equ 0xA2
SPI0DAT		equ 0xA3
P0MDOUT		equ 0xA4
P1MDOUT		equ 0xA5
P2MDOUT		equ 0xA6
P3MDOUT		equ 0xA7
CLKSEL		equ 0xA9
EMI0CN		equ 0xAA

OSCXCN		equ 0xB1
OSCICN		equ 0xB2
OSCICL		equ	0xB3


FLSCL		equ 0xB6
FLKEY		equ 0xB7
CLKMUL		EQU	0xB9

AMX0N		equ 0xBA
AMX0P		equ 0xBB
ADC0CF		equ 0xBC
ADC0L		equ 0xBD
ADC0H		equ 0xBE

SMB0CN		equ 0xC0
SMB0CF		equ 0xC1
SMB0DAT		equ 0xC2
ADC0GTL		equ 0xC3
ADC0GTH		equ 0xC4
ADC0LTL		equ 0xC5
ADC0LTH		equ 0xC6

TMR2CN		equ 0xC8
REG0CN		equ 0xC9
TMR2RLL		equ 0xCA
TMR2RLH		equ 0xCB
TMR2L		equ 0xCC
TMR2H		equ 0xCD


REF0CN		equ 0xD1

P0SKIP		equ 0xD4
P1SKIP		equ 0xD5
P2SKIP		equ 0xD6
USB0XCN		equ 0xD7
PCA0CN		equ 0xD8

PCA0MD		equ 0xD9

PCA0CPM0	equ 0xDA
PCA0CPM1	equ 0xDB
PCA0CPM2	equ 0xDC
PCA0CPM3	equ 0xDD
PCA0CPM4	equ 0xDE

XBR0		equ 0xE1
XBR1		equ 0xE2

IT01CF		equ 0xE4

EIE1		equ 0xE6
EIE2		equ 0xE7
ADC0CN		equ 0xE8
PCA0CPL1	equ 0xE9
PCA0CPH1	equ 0xEA
PCA0CPL2	equ 0xEB
PCA0CPH2	equ 0xEC
PCA0CPL3	equ 0xED
PCA0CPH3	equ 0xEE
RSTSRC		equ 0xEF
P0MDIN		equ 0xF1
P1MDIN		equ 0xF2
P2MDIN		equ 0xF3
P3MDIN		equ 0xF4

EIP1		equ 0xF6
EIP2		equ 0xF7
SPI0CN		equ 0xF8
PCA0L		equ 0xF9
PCA0H		equ 0xFA
PCA0CPL0	equ 0xFB
PCA0CPH0	equ 0xFC
PCA0CPL4	equ 0xFD
PCA0CPH4	equ 0xFE
VDM0CN		equ 0xFF
