$INCLUDE (define.inc)

APP_START		EQU	0x1600
INT0_IRQ_APP	EQU	(APP_START + 0x00)
T0OVF_IRQ_APP	EQU	(APP_START + 0x03)
INT1_IRQ_APP	EQU	(APP_START + 0x06)
T1OVF_IRQ_APP	EQU	(APP_START + 0x09)
UART0_IRQ_APP	EQU	(APP_START + 0x0C)
T2OVF_IRQ_APP	EQU	(APP_START + 0x0F)
SPI0_IRQ_APP	EQU	(APP_START + 0x12)
SMB0_IRQ_APP	EQU	(APP_START + 0x15)
ADC0WIN_IRQ_APP	EQU	(APP_START + 0x1B)
ADC0CNV_IRQ_APP	EQU	(APP_START + 0x1E)
PCA_IRQ_APP		EQU	(APP_START + 0x21)
CMP0_IRQ_APP	EQU	(APP_START + 0x24)
CMP1_IRQ_APP	EQU	(APP_START + 0x27)
T3OVF_IRQ_APP	EQU	(APP_START + 0x2A)
VBUS_IRQ_APP	EQU	(APP_START + 0x2D)

RESET_IRQ:	ljmp	RESET_Handler

			cseg at 0x03
			ljmp	INT0_IRQ_APP

			db	 1,   0,   0,	0,   0

			cseg at 0x0B
			ljmp	T0OVF_IRQ_APP

ROM_E:		ljmp	ROM_140E

			cseg at 0x13
			ljmp	INT1_IRQ_APP

ROM_16:		ljmp	ROM_140E


			cseg at 0x1B
			ljmp	T1OVF_IRQ_APP

			cseg at 0x23
			ljmp	UART0_IRQ_APP

			cseg at 0x2B
			ljmp	T2OVF_IRQ_APP

			cseg at 0x33	; SPI0_IRQ
			ljmp	Load_x54C_R4567

			cseg at 0x3B	; SMB0_IRQ
			ljmp	Load_R4567_iDPTR

			cseg at 0x43	; USB0_IRQ
			ljmp	USB_IRQ_Handler

			cseg at 0x4B	; ADC0WIN_IRQ
			ljmp	ADC0WIN_IRQ_APP

			cseg at 0x53	; ADC0CNV_IRQ
			ljmp	ADC0CNV_IRQ_APP

			cseg at 0x5B	; PCA_IRQ
			ljmp	PCA_IRQ_APP
			
			cseg at 0x63	; CMP0_IRQ
			ljmp	CMP0_IRQ_APP

			cseg at 0x6B	; CMP1_IRQ
			ljmp	CMP1_IRQ_APP
			
			cseg at 0x73	; T3OVF_IRQ
			ljmp	T3OVF_IRQ_APP
			
			cseg at 0x7B	; VBUS_IRQ
			ljmp	VBUS_IRQ_APP

			cseg at 0x84
UsbDevice_0084:
			db 0x12
			DB 1				; Device
			DB 0x10			; USB 1.1
			DB	 1
			DB	 0			; Device Class
			DB	 0			; Device SubClass
			DB	 0			; Interface Association	Descriptor
			DB 0x40			; MaxPacketSize
			DB 0xC4			; VID =	10C4
			DB 0x10
			DB 0x44			; PID =	8044
			DB 0x80
			DB	 0			; bcdDevice
			DB	 1
			DB	 1
			DB	 2
			DB	 3
			DB	 1
UsbConfig_0096:
			DB	 9			; ROM_74F+5Fo ROM_74F+62o ...
			DB	 2			; Descriptor Type = Configuration
UsbTotalLow_0098:
			DB 0x29			; ROM_74F+6Bo
						; Total	Length
UsbTotalHigh_0099:
			DB	   0			; ROM_74F:ROM_7B4o
			DB	 1			; bNumInterfacefaces
			DB	 1			; bConfigurationValue
			DB	 0			; iConfiguration
			DB 0x80			; No Remote Wakeup
							; Bus Powered
			DB 0x64			; bMaxPower = 100
UsbInreface_009F:
			DB	  9			; ROM_74F+9Fo ROM_74F+A2o
			DB	 4
			DB	 0
			DB	 0
			DB	 2
			DB	 3
			DB	 0
			DB	 0
			DB	 0
data_00A8:	DB	 9			; ROM_74F+DEo ROM_74F+E1o
			DB 0x21 ; !
			DB 0x11
			DB	 1
			DB	 0
			DB	 1
			DB 0x22 ; "
			DB 0x17
			DB	 3
data_00B1:	DB	 7			; ROM_74F+C0o ROM_74F+C3o
			DB	 5
			DB 0x81 ; Å
			DB	 3
			DB 0x40 ; @
			DB	 0
			DB	 1
data_00B8:	DB	 7			; ROM_74F+CEo ROM_74F+D1o
			DB	 5
			DB	 2
			DB	 3
			DB 0x40 ; @
			DB	 0
			DB	 1
data_00BF:	DB	 6			; ROM_B53+Do
			DB	 0
			DB 0xFF
			DB	 9
			DB	 1
			DB 0xA1 ; °
data_00C5:	DB	 1
			DB	 9
			DB	 1
			DB 0x75 ; u
			DB	 8
			DB 0x95 ; ï
			DB 0x40 ; @
			DB 0x26 ; &
			DB 0xFF
			DB	 0
			DB 0x15
			DB	 0
			DB 0x85 ; Ö
			DB	 1
			DB 0x95 ; ï
			DB	 1
			DB	 9
			DB	 1
			DB 0x81 ; Å
			DB	 2
			DB	 9
			DB	 1
			DB 0x91 ; ë
			DB	 2
data_00DD:	DB 0x85 ; Ö
			DB 0x40 ; @
			DB 0x95 ; ï
			DB	 3
			DB	 9
			DB	 1
			DB 0x81 ; Å
			DB	 2
			DB	 9
			DB	 1
			DB 0x91 ; ë
			DB	 2
			DB	 9
			DB	 1
			DB 0xB1 ; ±
			DB	 2
			DB 0xC0 ; ¿

		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
		DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0

data_03D6:	DB 4
			DB 3
			DB 9
			DB 4
			DB 0x2A
			DB 3
			DB 0x53 ; S
			DB	 0
			DB 0x69 ; i
			DB	 0
			DB 0x6C ; l
			DB	 0
			DB 0x69 ; i
			DB	 0
			DB 0x63 ; c
			DB	 0
			DB 0x6F ; o
			DB	 0
			DB 0x6E ; n
			DB	 0
			DB 0x20
			DB	 0
			DB 0x4C ; L
			DB	 0
			DB 0x61 ; a
			DB	 0
			DB 0x62 ; b
			DB	 0
			DB 0x6F ; o
			DB	 0
			DB 0x72 ; r
			DB	 0
			DB 0x61 ; a
			DB	 0
			DB 0x74 ; t
			DB	 0
			DB 0x6F ; o
			DB	 0
			DB 0x72 ; r
			DB	 0
			DB 0x69 ; i
			DB	 0
			DB 0x65 ; e
			DB	 0
			DB 0x73 ; s
			DB	 0
			DB 0x24 ; $
			DB	 3
			DB 0x55 ; U
			DB	 0
			DB 0x53 ; S
			DB	 0
			DB 0x42 ; B
			DB	 0
			DB 0x20
			DB	 0
			DB 0x44 ; D
			DB	 0
			DB 0x65 ; e
			DB	 0
			DB 0x62 ; b
			DB	 0
			DB 0x75 ; u
			DB	 0
			DB 0x67 ; g
			DB	 0
			DB 0x20
			DB	 0
			DB 0x41 ; A
			DB	 0
			DB 0x64 ; d
			DB	 0
			DB 0x61 ; a
			DB	 0
			DB 0x70 ; p
			DB	 0
			DB 0x74 ; t
			DB	 0
			DB 0x65 ; e
			DB	 0
			DB 0x72 ; r
			DB	 0
			DB 0x18
			DB	 3
			DB 0x45 ; E
			DB	 0
			DB 0x43 ; C
			DB	 0
			DB 0x33 ; 3
			DB	 0
			DB 0x30 ; 0
			DB	 0
			DB 0x30 ; 0
			DB	 0
			DB 0x30 ; 0
			DB	 0
			DB 0x30 ; 0
			DB	 0
			DB 0x42 ; B
			DB	 0
			DB 0x37 ; 7
			DB	 0
			DB 0x31 ; 1
			DB	 0
			DB 0x39 ; 9
			DB	 0
data_0440:	DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
			DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
			DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
			DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0
			DB	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0,	0,   0,	  0,   0,   0,	 0,   0


ROM_4AA:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4AA
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A

ROM_4B5:					; ROM_4AA+Dj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4B5
		mov		USB0ADR, #0x91		; USB0 Indirect	Address	Register

ROM_4BD:					; ROM_4AA+15j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4BD
		mov		RAM_38,	USB0DAT
		mov		A, RAM_4C
		cjne	A, #5, ROM_4D7

ROM_4CA:					; ROM_4AA+22j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4CA
		clr		A
		mov		USB0ADR, A		; USB0 Indirect	Address	Register
		mov		USB0DAT, RAM_47
		mov		RAM_4C,	A

ROM_4D7:					; ROM_4AA+1Dj
		mov		A, RAM_38
		jnb		ACC.2, ROM_4EA

ROM_4DC:					; ROM_4AA+34j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4DC
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A
		mov		RAM_4C,	A
		ret

ROM_4EA:					; ROM_4AA+2Fj
		mov		A, RAM_38
		jnb		ACC.4, ROM_508

ROM_4EF:					; ROM_4AA+47j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4EF
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #8

ROM_4FA:					; ROM_4AA+52j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_4FA
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x80
		clr		A
		mov		RAM_4C,	A

ROM_508:					; ROM_4AA+42j
		mov		A, RAM_4C
		xrl		A, #2
		jnz		ROM_57F
		mov		A, RAM_38
		jnb		ACC.0, ROM_57F
		mov		R2, #0
		mov		R1, #0x32
		mov		R5, #4
		lcall	ROM_745

ROM_51C:					; ROM_4AA+74j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_51C
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x48
		clr		A
		mov		RAM_4C,	A
		mov		A, RAM_32
		xrl		A, #0x40
		jnz		ROM_57F
		mov		A, RAM_33
		cjne	A, #1, ROM_54F
		clr		A
		mov		RAM_36,	A
		mov		RAM_37,	A

ROM_53A:					; ROM_4AA:ROM_542j ROM_4AA+9Dj
		inc		RAM_37
		mov		A, RAM_37
		jnz		ROM_542
		inc		RAM_36

ROM_542:					; ROM_4AA+94j
		cjne	A, #0xFF, ROM_53A
		mov		A, RAM_36
		cjne	A, #0xFF, ROM_53A
		orl		RSTSRC,	#0x10
		sjmp	ROM_57F

ROM_54F:					; ROM_4AA+88j
		mov		A, RAM_33
		cjne	A, #2, ROM_559
		lcall	iROM_39D6_148B
		sjmp	ROM_57F

ROM_559:					; ROM_4AA+A7j
		mov		A, RAM_33
		cjne	A, #3, ROM_57F
		mov		RAM_36,	#0
		mov		RAM_37,	RAM_34
		mov		A, RAM_37
		mov		RAM_37,	#0
		mov		RAM_36,	A
		mov		A, RAM_35
		orl		RAM_37,	A
		clr		A
		mov		R2, RAM_36
		mov		R1, RAM_37
		mov		R3, #0xFF
		mov		RAM_3A,	R3
		mov		RAM_3B,	R2
		mov		RAM_3C,	R1
		lcall	Jmp_iR21_F6F		; Jump to @(R2,R1)

ROM_57F:					; ROM_4AA+62j ROM_4AA+66j ...
		mov		A, RAM_4C
		jz		ROM_586
		ljmp	ROM_65F

ROM_586:					; ROM_4AA+D7j
		mov		A, RAM_38
		jb		ACC.0, ROM_58E
		ljmp	ROM_65F

ROM_58E:					; ROM_4AA+DEj
		mov		R2, #0
		mov		R1, #0x44
		mov		R5, #8
		lcall	ROM_745
		mov		A, RAM_47
		mov		R6, A
		mov		R4, #0
		clr		A
		add		A, RAM_46
		mov		RAM_47,	A
		mov		A, R4
		addc	A, R6
		mov		RAM_46,	A
		mov		A, RAM_49
		mov		R6, A
		clr		A
		add		A, RAM_48
		mov		RAM_49,	A
		mov		A, R4
		addc	A, R6
		mov		RAM_48,	A
		mov		A, RAM_4B
		mov		R6, A
		clr		A
		add		A, RAM_4A
		mov		RAM_4B,	A
		mov		A, R4
		addc	A, R6
		mov		RAM_4A,	A
		mov		A, RAM_44
		anl		A, #0x7F
		mov		R7, A
		cjne	R7, #0x21, ROM_5F3
		mov		A, RAM_45
		dec	A
		jnz		ROM_5CD
		ljmp	ROM_65F

ROM_5CD:
		dec	A
		jz		ROM_5E9
		dec	A
		jnz		ROM_5D6
		ljmp	ROM_65F

ROM_5D6:
		add		A, #0xF9
		jz		ROM_5EE
		dec	A
		jnz		ROM_5E0
		ljmp	ROM_65F

ROM_5E0:
		add		A, #2
		jnz		ROM_65C
		lcall	ROM_146A
		sjmp	ROM_65F

ROM_5E9:
		lcall	ROM_E
		sjmp	ROM_65F

ROM_5EE:
		lcall	ROM_16
		sjmp	ROM_65F

ROM_5F3:
		mov		A, RAM_44
		anl		A, #0x7F
		mov		R7, A
		cjne	R7, #0x40, ROM_5FD
		sjmp	ROM_65C

ROM_5FD:
		mov		A, RAM_45
		cjne	A, #0xC, ROM_602

ROM_602:
		jnc		ROM_65C
		mov		DPTR, #ROM_60B
		mov		R0, A
		add		A, R0
		add		A, R0
		jmp		@A+DPTR

ROM_60B:
		ljmp	ROM_62F
		ljmp	ROM_634
		ljmp	ROM_65C
		ljmp	ROM_639
		ljmp	ROM_65C
		ljmp	ROM_63E
		ljmp	ROM_643
		ljmp	ROM_65C
		ljmp	ROM_648
		ljmp	ROM_64D
		ljmp	ROM_652
		ljmp	ROM_657

ROM_62F:
		lcall	ROM_C84
		sjmp	ROM_65F

ROM_634:
		lcall	ROM_E7D
		sjmp	ROM_65F

ROM_639:
		lcall	ROM_DFA
		sjmp	ROM_65F

ROM_63E:
		lcall	ROM_12B5
		sjmp	ROM_65F

ROM_643:
		lcall	ROM_74F
		sjmp	ROM_65F

ROM_648:
		lcall	ROM_122D
		sjmp	ROM_65F

ROM_64D:
		lcall	ROM_F75
		sjmp	ROM_65F

ROM_652:
		lcall	ROM_1276
		sjmp	ROM_65F

ROM_657:
		lcall	ROM_A67
		sjmp	ROM_65F

ROM_65C:
		lcall	ROM_140E

ROM_65F:
		mov		A, RAM_4C
		xrl		A, #1
		jz		ROM_668
		ljmp	ROM_738

ROM_668:
		mov		A, RAM_38
		jnb		ACC.1, ROM_670
		ljmp	ROM_738

ROM_670:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_670
		mov		USB0ADR, #0x91	; USB0 Indirect Address Register

ROM_678:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_678
		mov		RAM_38,	USB0DAT
		mov		A, RAM_38
		jnb		ACC.4, ROM_68B
		jnb		ACC.0, ROM_68B
		ljmp	ROM_738

ROM_68B:
		mov		RAM_39,	#2
		clr		C
		mov		A, RAM_1D
		subb	A, #0x40 ; '@'
		mov		A, RAM_1C
		subb	A, #0
		jc		ROM_6EF
		mov		A, RAM_46
		xrl		A, #0x22
		jz		ROM_6AE
		mov		A, RAM_46
		cjne	A, #2, ROM_6C4
		lcall	ROM_144C
		jc		ROM_6C4
		mov		A, R7
		subb	A, #0xFB ; '˚'
		jnc		ROM_6C4

ROM_6AE:
		mov		R5, #0x40 ; '@'
		mov		R4, #0
		lcall	ROM_1440
		lcall	ROM_1368
		mov		DPTR, #0x531
		clr		A
		mov		B, #0x40 ; '@'
		lcall	ROM_F28
		sjmp	ROM_6D6

ROM_6C4:
		mov		R5, #0x40 ; '@'
		mov		R4, #0
		lcall	ROM_739
		mov		A, #0x40 ; '@'
		add		A, RAM_51
		mov		RAM_51,	A
		clr		A
		addc	A, RAM_50
		mov		RAM_50,	A

ROM_6D6:
		mov		A, #0xC0 ; '¿'
		add		A, RAM_1D
		mov		RAM_1D,	A
		mov		A, #0xFF
		addc	A, RAM_1C
		mov		RAM_1C,	A
		mov		A, #0x40 ; '@'
		add		A, RAM_1F
		mov		RAM_1F,	A
		clr		A
		addc	A, RAM_1E
		mov		RAM_1E,	A
		sjmp	ROM_71D

ROM_6EF:
		mov		A, RAM_46
		xrl		A, #0x22
		jz		ROM_704
		mov		A, RAM_46
		cjne	A, #2, ROM_710
		lcall	ROM_144C
		jc		ROM_710
		mov		A, R7
		subb	A, #0xFB ; '˚'
		jnc		ROM_710

ROM_704:
		mov		R5, RAM_1D
		mov		R4, RAM_1C
		lcall	ROM_1440
		lcall	ROM_1368
		sjmp	ROM_717

ROM_710:
		mov		R5, RAM_1D
		mov		R4, RAM_1C
		lcall	ROM_739

ROM_717:
		orl		RAM_39,	#8
		clr		A
		mov		RAM_4C,	A

ROM_71D:
		mov		A, RAM_1F
		cjne	A, RAM_4B, ROM_72D
		mov		A, RAM_1E
		cjne	A, RAM_4A, ROM_72D
		orl		RAM_39,	#8
		clr		A
		mov		RAM_4C,	A

ROM_72D:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_72D
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, RAM_39

ROM_738:
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_739:
		mov		R3, RAM_4F
		mov		R2, RAM_50
		mov		R1, RAM_51
		mov		R7, #0x20 ; ' '
		lcall	ROM_D11
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_745:
		mov		R3, #0
		mov		R4, #0
		mov		R7, #0x20
		lcall	Fill_USB_FIFO_10B4
		ret

; =============== S U B	R O U T	I N E =======================================


ROM_74F:
		mov		A, RAM_46
		add		A, #-0x21
		jnz		ROM_758
		ljmp	RAM_46_EQ_21_0827

ROM_758:
		dec	A
		jnz		ROM_75E
		ljmp	RAM_46_EQ_22_0827

ROM_75E:					; ROM_74F+Aj
		add		A, #0x21
		cjne	A, #5, ROM_763

ROM_763:
		jc		ROM_768
		ljmp	ROM_84A

ROM_768:
		mov		DPTR, #ROM_776
		mov		B, #3
		mul	AB
		xch		A, DPH			; Data Pointer,	High Byte
		add		A, B
		xch		A, DPH			; Data Pointer,	High Byte
		jmp		@A+DPTR

ROM_776:
		ljmp	RAM_46_EQ_01_0785
		ljmp	RAM_46_EQ_02_0793
		ljmp	RAM_46_EQ_03_07CC
		ljmp	RAM_46_EQ_04_07E8
		ljmp	RAM_46_EQ_05_07F8

RAM_46_EQ_01_0785:
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#high(UsbDevice_0084)
		mov		RAM_51,	#low(UsbDevice_0084)
		mov		DPTR, #UsbDevice_0084
		sjmp	ROM_7F4

RAM_46_EQ_02_0793:
		mov		DPTR, #ROM_17FF
		clr		A
		movc	A, @A+DPTR
		mov		R7, A
		setb	C
		subb	A, #0x18
		jc		ROM_7AB
		mov		A, R7
		subb	A, #0xFB
		jnc		ROM_7AB
		lcall	ROM_13A1
		lcall	Clr_i530_0_0_0_103D	; Clear	@530 @531 @532
		sjmp	ROM_7B4

ROM_7AB:
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#high(UsbConfig_0096)
		mov		RAM_51,	#low(UsbConfig_0096)

ROM_7B4:
		mov		DPTR, #UsbTotalHigh_0099
		clr		A
		movc	A, @A+DPTR
		mov		R6, A
		mov		DPTR, #UsbTotalLow_0098
		clr		A
		movc	A, @A+DPTR
		mov		R4, #0
		add		A, #0
		mov		RAM_1D,	A
		mov		A, R4
		addc	A, R6
		mov		RAM_1C,	A
		ljmp	ROM_84D

RAM_46_EQ_03_07CC:
		mov		A, RAM_47
		mov		B, #3
		mul	AB
		add		A, #0x10
		mov		R0, A
		mov		RAM_3, @R0
		inc		R0
		mov		A, @R0
		mov		R2, A
		inc		R0
		mov		A, @R0
		mov		R1, A
		mov		RAM_4F,	R3
		mov		RAM_50,	R2
		mov		RAM_51,	A
		lcall	ROM_EFD
		sjmp	ROM_835

RAM_46_EQ_04_07E8:
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#UsbInreface_009F
		mov		DPTR, #UsbInreface_009F

ROM_7F4:
		clr		A
		movc	A, @A+DPTR
		sjmp	ROM_835

RAM_46_EQ_05_07F8:
		mov		A, RAM_47
		xrl		A, #0x81
		jz		ROM_804
		mov		A, RAM_47
		xrl		A, #2
		jnz		ROM_84A

ROM_804:
		mov		A, RAM_47
		cjne	A, #0x81, ROM_817
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#data_00B1
		mov		DPTR, #data_00B1
		sjmp	ROM_823

ROM_817:
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#data_00B8
		mov		DPTR, #data_00B8

ROM_823:
		clr		A
		movc	A, @A+DPTR
		sjmp	ROM_835

RAM_46_EQ_21_0827:
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#data_00A8
		mov		DPTR, #data_00A8
		clr		A
		movc	A, @A+DPTR

ROM_835:
		mov		RAM_1C,	#0
		mov		RAM_1D,	A
		sjmp	ROM_84D

RAM_46_EQ_22_0827:
		lcall	ROM_B53
		lcall	Clr_i530_0_0_0_103D	; Clear	@530 @531 @532
		mov		RAM_1C,	#3
		mov		RAM_1D,	#0x17
		sjmp	ROM_84D

ROM_84A:
		lcall	ROM_140E

ROM_84D:
		mov		A, RAM_46
		xrl		A, #1
		jz		ROM_86A
		mov		A, RAM_46
		xrl		A, #2
		jz		ROM_86A
		mov		A, RAM_46
		xrl		A, #3
		jz		ROM_86A
		mov		A, RAM_46
		xrl		A, #4
		jz		ROM_86A
		mov		A, RAM_46
		cjne	A, #5, ROM_87E

ROM_86A:
		clr		C
		mov		A, RAM_4B
		subb	A, RAM_1D
		clr		A
		subb	A, RAM_1C
		jnc		ROM_87E
		mov		A, RAM_4A
		jnz		ROM_87E
		mov		RAM_1C,	RAM_4A
		mov		RAM_1D,	RAM_4B

ROM_87E:
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_88C

ROM_884:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_884
		lcall	ROM_FE6

ROM_88C:
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_88D:
		clr		A
		mov		R7, A

ROM_88F:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_88F
		mov		USB0ADR, #0xE	; USB0 Indirect	Address	Register
		mov		USB0DAT, #2

ROM_89A:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_89A
		mov		USB0ADR, #0x94 ; 'î'    ; USB0 Indirect Address Register

ROM_8A2:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_8A2
		mov		R6, USB0DAT
		mov		A, RAM_4E
		cjne	A, #3, ROM_8BA

ROM_8AE:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_8AE
		mov		USB0ADR, #0x14		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x20 ; ' '
		ret

ROM_8BA:
		mov		A, R6
		jnb		ACC.6, ROM_8C9

ROM_8BE:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_8BE
		mov		USB0ADR, #0x14		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x80 ; 'Ä'

ROM_8C9:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_8C9
		mov		USB0ADR, #0x96 ; 'ñ'    ; USB0 Indirect Address Register

ROM_8D1:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_8D1
		mov		R7, USB0DAT
		setb	C
		mov		A, RAM_9_GetIndexLo
		subb	A, RAM_B
		mov		A, RAM_8_GetIndexHi
		subb	A, RAM_A
		jnc		ROM_8F6
		clr		C
		mov		A, #0x58 ; 'X'
		subb	A, RAM_B
		xch		A, R5
		mov		A, #2
		subb	A, RAM_A
		xch		A, R5
		add		A, RAM_9_GetIndexLo
		xch		A, R5
		addc	A, RAM_8_GetIndexHi
		mov		R4, A
		sjmp	ROM_901

ROM_8F6:
		clr		C
		mov		A, RAM_9_GetIndexLo
		subb	A, RAM_B
		mov		R5, A
		mov		A, RAM_8_GetIndexHi
		subb	A, RAM_A
		mov		R4, A

ROM_901:
		mov		A, R7
		add		A, #0xFF
		mov		R3, A
		clr		A
		addc	A, #0xFF
		mov		R2, A
		setb	C
		mov		A, R5
		subb	A, R3
		mov		A, R4
		subb	A, R2
		jnc		ROM_91C

ROM_910:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_910
		mov		USB0ADR, #0xB		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0xF
		ret

ROM_91C:
		mov		USB0ADR, #0x22 ; '"'    ; USB0 Indirect Address Register
		orl		USB0ADR, #0xC0		; USB0 Indirect	Address	Register

ROM_922:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_922
		mov		R6, USB0DAT
		clr		A
		mov		R5, A

ROM_92B:
		mov		A, R5
		clr		C
		subb	A, R6
		jnc		ROM_962

ROM_930:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_930
		mov		A, RAM_B
		cjne	A, #low(XRAM_257), ROM_945
		mov		A, RAM_A
		cjne	A, #high(XRAM_257), ROM_945
		mov		R2, #0
		mov		R3, #0
		sjmp	ROM_94E

ROM_945:
		mov		A, RAM_B
		add		A, #1
		mov		R3, A
		clr		A
		addc	A, RAM_A
		mov		R2, A

ROM_94E:
		mov		RAM_A, R2
		mov		RAM_B, R3
		mov		A, #0x58 ; 'X'
		add		A, R3
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #2
		addc	A, R2
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, USB0DAT
		movx	@DPTR, A
		inc		R5
		sjmp	ROM_92B

ROM_962:
		clr		A
		mov		R5, A

ROM_964:
		clr		C
		mov		A, R7
		subb	A, R6
		dec	A
		mov		R4, A
		mov		A, R5
		clr		C
		subb	A, R4
		jnc		ROM_979

ROM_96E:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_96E
		mov		RAM_32,	USB0DAT
		inc		R5
		sjmp	ROM_964

ROM_979:
		clr		A
		mov		USB0ADR, A		; USB0 Indirect	Address	Register

ROM_97C:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_97C
		mov		USB0ADR, #0x14		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A

ROM_987:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_987
		mov		USB0ADR, #0xB		; USB0 Indirect	Address	Register
		mov		USB0DAT, #7
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_993:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_993
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		mov		USB0DAT, #1

ROM_99E:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_99E
		mov		USB0ADR, #0x91 ; 'ë'    ; USB0 Indirect Address Register

ROM_9A6:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_9A6
		mov		R7, USB0DAT
		mov		A, RAM_4D
		cjne	A, #3, ROM_9BE

ROM_9B2:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_9B2
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x10
		ret

ROM_9BE:
		mov		A, R7
		jnb		ACC.5, ROM_9CD

ROM_9C2:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_9C2
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x40 ; '@'

ROM_9CD:
		mov		A, R7
		jnb		ACC.2, ROM_9DC

ROM_9D1:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_9D1
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A

ROM_9DC:
		setb	C
		mov		A, RAM_D
		subb	A, RAM_F
		mov		A, RAM_C
		subb	A, RAM_E
		jc		ROM_9F9
		mov		A, #0x58 ; 'X'
		subb	A, RAM_D
		xch		A, R7
		mov		A, #2
		subb	A, RAM_C
		xch		A, R7
		add		A, RAM_F
		xch		A, R7
		addc	A, RAM_E
		mov		R6, A
		sjmp	ROM_A04

ROM_9F9:
		clr		C
		mov		A, RAM_F
		subb	A, RAM_D
		mov		R7, A
		mov		A, RAM_E
		subb	A, RAM_C
		mov		R6, A

ROM_A04:
		mov		RAM_2D,	R6
		mov		RAM_2E,	R7
		setb	C
		mov		A, RAM_2E
		subb	A, #0x3F ; '?'
		mov		A, RAM_2D
		subb	A, #0
		jc		ROM_A19
		mov		RAM_2D,	#0
		mov		RAM_2E,	#0x3F ;	'?'

ROM_A19:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_A19
		mov		USB0ADR, #0x21 ; '!'    ; USB0 Indirect Address Register
		mov		USB0DAT, RAM_2E

ROM_A24:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_A24

ROM_A29:
		mov		R6, RAM_E
		mov		R7, RAM_F
		mov		A, RAM_D
		cjne	A, RAM_7, ROM_A3A
		mov		A, RAM_C
		cjne	A, RAM_6, ROM_A3A
		setb	C
		sjmp	ROM_A3B

ROM_A3A:
		clr		C

ROM_A3B:
		jc		ROM_A5B
		mov		A, RAM_2E
		dec	RAM_2E
		mov		R6, RAM_2D
		jnz		ROM_A47
		dec	RAM_2D

ROM_A47:
		setb	C
		subb	A, #0
		mov		A, R6
		subb	A, #0
		jc		ROM_A5B
		lcall	ROM_12F3
		mov		USB0DAT, R7

ROM_A54:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jnb		ACC.7, ROM_A29
		sjmp	ROM_A54

ROM_A5B:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_A5B
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #1
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_A67:
		mov		A, RAM_44
		cjne	A, #1, ROM_A84
		mov		A, RAM_4A
		jnz		ROM_A84
		mov		A, RAM_4B
		jnz		ROM_A84
		mov		A, RAM_46
		jnz		ROM_A84
		mov		A, RAM_47
		jnz		ROM_A84
		mov		A, RAM_48
		jnz		ROM_A84
		mov		A, RAM_49
		jz		ROM_A87

ROM_A84:
		lcall	ROM_140E

ROM_A87:
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_A95

ROM_A8D:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_A8D
		lcall	ROM_FFF

ROM_A95:
		ret

		DB 0xFF
		DB 0xFF

; =============== S U B	R O U T	I N E =======================================

UsbStart_A98:
		mov		RAM_56,	#high(APP_START / 2)	; AppEntry = 1600
		lcall	SetAppEntry_1223	; Set AppEntry = (RAM(56) * 2 << 8)

UsbLoop_A9E:
		lcall	GetHostByte_132E
		mov		RAM_53_Cmd_0, R7
		lcall	GetHostByte_132E
		mov		RAM_54_Cmd_1, R7
		lcall	GetHostByte_132E
		mov		RAM_55_Cmd_2, R7
		mov		A, RAM_53_Cmd_0
		inc		A
		jz		Usb_Fn_FF_B12
		dec	A
		cjne	A, #7, $+3
		jnc		ROM_B34

		mov		DPTR, #usb_Fn_Handlers
		mov		R0, A
		add		A, R0
		add		A, R0
		jmp		@A+DPTR

usb_Fn_Handlers:
		ljmp	usb_fn_00_AD4
		ljmp	usb_fn_01_AF2
		ljmp	usb_fn_02_AF7
		ljmp	usb_fn_03_AFC
		ljmp	usb_fn_04_B01
		ljmp	usb_fn_05_B06
		ljmp	usb_fn_06_B0C

usb_fn_00_AD4:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_AE4
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_AE4
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_AE7

ROM_AE4:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_AE7:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #RESP_02
		movx	@DPTR, A
		lcall	UsbFlush_D54
		sjmp	UsbLoop_A9E

usb_fn_01_AF2:
		lcall	Usb_Fn_01_3CE0
		sjmp	UsbLoop_A9E

usb_fn_02_AF7:
		lcall	Usb_Fn_02_117C
		sjmp	UsbLoop_A9E

usb_fn_03_AFC:
		lcall	Usb_Fn_03_3C02
		sjmp	UsbLoop_A9E

usb_fn_04_B01:
		lcall	Usb_Fn_04_D74
		sjmp	UsbLoop_A9E

usb_fn_05_B06:
		lcall	Usb_Fn_05_13CC
		ljmp	UsbLoop_A9E

usb_fn_06_B0C:
		lcall	Usb_Fn_06_3DEB
		ljmp	UsbLoop_A9E

Usb_Fn_FF_B12:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_B22
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_B22
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_B25

ROM_B22:
		lcall	inc_RAM_EF_R67_11E5

ROM_B25:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #0xFF
		movx	@DPTR, A
		lcall	UsbFlush_D54
		lcall	InitPointers_1200
		ljmp	UsbLoop_A9E

ROM_B34:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_B44
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_B44
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_B47

ROM_B44:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_B47:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #RESP_01
		movx	@DPTR, A
		lcall	UsbFlush_D54
		ljmp	UsbLoop_A9E

; =============== S U B	R O U T	I N E =======================================

ROM_B53:
		clr		A
		mov		RAM_43,	#0x12
		mov		RAM_42,	A
		mov		RAM_41,	A
		mov		RAM_40,	A
		mov		RAM_3D,	#0
		mov		RAM_3E,	#data_00BF
		mov		RAM_3F,	A

ROM_B65:
		lcall	Movc_iRAM_3D_3E_3F_1006	; Load @(RAM(3D), RAM(3E)+RAM(3F)) to A
		mov		R7, A
		mov		A, #0
		add		A, RAM_3F
		mov		DPL, A			; Data Pointer,	Low Byte
		clr		A
		addc	A, #0
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R7
		movx	@DPTR, A
		inc		RAM_3F
		mov		A, RAM_3F
		cjne	A, #0x1E, ROM_B65
		mov		R3, #1

ROM_B7F:
		mov		RAM_3F,	#0x12

ROM_B82:
		mov		A, RAM_3F
		xrl		A, #0x13
		jz		ROM_B8D
		mov		A, RAM_3F
		cjne	A, #0x15, ROM_B94

ROM_B8D:
		lcall	Mov_DPTR_RAM_42_43_101E	; Mov RAM(43,42) to DPTR
		mov		A, R3
		movx	@DPTR, A
		sjmp	ROM_B9D

ROM_B94:
		lcall	Movc_iRAM_3D_3E_3F_1006	; Load @(RAM(3D), RAM(3E)+RAM(3F)) to A
		mov		R7, A
		lcall	Mov_DPTR_RAM_42_43_101E	; Mov RAM(43,42) to DPTR
		mov		A, R7
		movx	@DPTR, A

ROM_B9D:
		mov		A, RAM_43
		add		A, #1
		mov		RAM_43,	A
		clr		A
		addc	A, RAM_42
		mov		RAM_42,	A
		clr		A
		addc	A, RAM_41
		mov		RAM_41,	A
		clr		A
		addc	A, RAM_40
		mov		RAM_40,	A
		inc		RAM_3F
		mov		A, RAM_3F
		cjne	A, #0x1E, ROM_B82
		inc		R3
		cjne	R3, #0x40, ROM_B7F
		mov		RAM_3F,	#0x1E

ROM_BC0:
		clr		A
		mov		R7, #0x17
		mov		R6, #3
		mov		R5, A
		mov		R4, A
		mov		R3, RAM_43
		mov		R2, RAM_42
		mov		R1, RAM_41
		mov		R0, RAM_40
		clr		C
		lcall	ROM_F3E
		jnc		ROM_BF3
		mov		R7, RAM_3F
		inc		RAM_3F
		mov		A, RAM_3E
		add		A, R7
		lcall	Movc_iRAM_3D_A_100A	; Load @(RAM(3D),A) to A
		mov		R3, A
		mov		R0, #0x40
		lcall	ROM_F4F
		mov		A, #0
		add		A, R7
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R3
		movx	@DPTR, A
		sjmp	ROM_BC0

ROM_BF3:
		ret

; =============== S U B	R O U T	I N E =======================================

USB_IRQ_Handler:
		push	ACC
		push	B
		push	DPH			; Data Pointer,	High Byte
		push	DPL			; Data Pointer,	Low Byte
		push	PSW
		mov		PSW, #0
		push	RAM_0
		push	RAM_1
		push	RAM_2
		push	RAM_3
		push	RAM_4
		push	RAM_5
		push	RAM_6
		push	RAM_7

ROM_C11:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C11
		mov		USB0ADR, #USBREG_86	; USB0 Indirect	Address	Register

ROM_C19:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C19
		mov		RAM_2F,	USB0DAT

ROM_C21:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C21
		mov		USB0ADR, #USBREG_82	; USB0 Indirect	Address	Register

ROM_C29:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C29
		mov		RAM_30,	USB0DAT

ROM_C31:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C31
		mov		USB0ADR, #USBREG_84	; USB0 Indirect	Address	Register

ROM_C39:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_C39
		mov		RAM_31,	USB0DAT
		mov		A, RAM_2F
		jnb		ACC.2, ROM_C49
		lcall	ROM_1428

ROM_C49:
		mov		A, RAM_2F
		jnb		ACC.3, ROM_C51
		lcall	ROM_88D

ROM_C51:
		mov		A, RAM_30
		jnb		ACC.0, ROM_C59
		lcall	ROM_4AA

ROM_C59:
		mov		A, RAM_31
		jnb		ACC.2, ROM_C61
		lcall	ROM_88D

ROM_C61:
		mov		A, RAM_2F
		jnb		ACC.0, ROM_C69
		lcall	PrepareUsbClock_13F3

ROM_C69:
		pop	RAM_7
		pop	RAM_6
		pop	RAM_5
		pop	RAM_4
		pop	RAM_3
		pop	RAM_2
		pop	RAM_1
		pop	RAM_0
		pop	PSW
		pop	DPL			; Data Pointer,	Low Byte
		pop	DPH			; Data Pointer,	High Byte
		pop	B
		pop	ACC
		reti

; =============== S U B	R O U T	I N E =======================================


ROM_C84:
		mov		A, RAM_46
		jnz		ROM_C96
		mov		A, RAM_47
		jnz		ROM_C96
		mov		A, RAM_4A
		jnz		ROM_C96
		mov		A, RAM_4B
		xrl		A, #2
		jz		ROM_C99

ROM_C96:					; ROM_C84+2j ROM_C84+6j ...
		lcall	ROM_140E

ROM_C99:					; ROM_C84+10j
		mov		A, RAM_44
		add		A, #0x7F
		jz		ROM_CB0
		dec	A
		jz		ROM_CC4
		add		A, #2
		jnz		ROM_CFF
		mov		A, RAM_48
		jnz		ROM_CFF
		mov		A, RAM_49
		jz		ROM_CBF
		sjmp	ROM_CFF

ROM_CB0:					; ROM_C84+19j
		mov		A, RAM_52
		cjne	A, #4, ROM_CBD
		mov		A, RAM_48
		jnz		ROM_CBD
		mov		A, RAM_49
		jz		ROM_CBF

ROM_CBD:					; ROM_C84+2Ej ROM_C84+33j
		sjmp	ROM_CFF

ROM_CBF:					; ROM_C84+28j ROM_C84+37j
		lcall	ROM_FF5
		sjmp	ROM_CF5

ROM_CC4:					; ROM_C84+1Cj
		mov		A, RAM_52
		cjne	A, #4, ROM_CCD
		mov		A, RAM_48
		jz		ROM_CCF

ROM_CCD:					; ROM_C84+42j
		sjmp	ROM_CFF

ROM_CCF:					; ROM_C84+47j
		mov		A, RAM_49
		cjne	A, #0x81, ROM_CE3
		mov		A, RAM_4D
		cjne	A, #3, ROM_CDE
		lcall	ROM_1014
		sjmp	ROM_CE1

ROM_CDE:					; ROM_C84+52j
		lcall	ROM_FF5

ROM_CE1:					; ROM_C84+58j
		sjmp	ROM_CF5

ROM_CE3:					; ROM_C84+4Dj
		mov		A, RAM_49
		cjne	A, #2, ROM_CFD
		mov		A, RAM_4E
		cjne	A, #3, ROM_CF2
		lcall	ROM_1014
		sjmp	ROM_CF5

ROM_CF2:					; ROM_C84+66j
		lcall	ROM_FF5

ROM_CF5:					; ROM_C84+3Ej ROM_C84:ROM_CE1j ...
		mov		RAM_1C,	#0
		mov		RAM_1D,	#2
		sjmp	ROM_D02

ROM_CFD:					; ROM_C84+61j
		sjmp	ROM_CFF

ROM_CFF:					; ROM_C84+20j ROM_C84+24j ...
		lcall	ROM_140E

ROM_D02:					; ROM_C84+77j
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_D10

ROM_D08:					; ROM_C84+86j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_D08
		lcall	ROM_FE6

ROM_D10:					; ROM_C84+82j
		ret
; End of function ROM_C84


; =============== S U B	R O U T	I N E =======================================


ROM_D11:					; ROM_739+8p
		mov		RAM_3D,	R4
		mov		RAM_3E,	R5
		mov		RAM_3F,	R3
		mov		RAM_40,	R2
		mov		RAM_41,	R1
		mov		A, RAM_3E
		orl		A, RAM_3D
		jz		ROM_D53

ROM_D21:					; ROM_D11+12j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_D21
		mov		USB0ADR, R7		; USB0 Indirect	Address	Register
		clr		A
		mov		R7, A
		mov		R6, A

ROM_D2B:					; ROM_D11:ROM_D51j
		clr		C
		mov		A, R7
		subb	A, RAM_3E
		mov		A, R6
		subb	A, RAM_3D
		jnc		ROM_D53
		mov		R3, RAM_3F
		inc		RAM_41
		mov		A, RAM_41
		mov		R2, RAM_40
		jnz		ROM_D40
		inc		RAM_40

ROM_D40:					; ROM_D11+2Bj
		dec	A
		mov		R1, A
		lcall	ROM_EFD
		mov		USB0DAT, A

ROM_D47:					; ROM_D11+38j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_D47
		inc		R7
		cjne	R7, #0,	ROM_D51
		inc		R6

ROM_D51:					; ROM_D11+3Cj
		sjmp	ROM_D2B

ROM_D53:					; ROM_D11+Ej ROM_D11+21j
		ret
; End of function ROM_D11


; =============== S U B	R O U T	I N E =======================================


UsbFlush_D54:
		anl		EIE1, #0xFD

ROM_D57:					; UsbFlush_D54+1Aj
		mov		R6, RAM_E
		mov		R7, RAM_F
		mov		A, RAM_D
		cjne	A, RAM_7, ROM_D68
		mov		A, RAM_C
		cjne	A, RAM_6, ROM_D68
		setb	C
		sjmp	ROM_D69

ROM_D68:					; UsbFlush_D54+9j UsbFlush_D54+Ej
		clr		C

ROM_D69:					; UsbFlush_D54+12j
		jc		ROM_D70
		lcall	ROM_993
		sjmp	ROM_D57

ROM_D70:					; UsbFlush_D54:ROM_D69j
		orl		EIE1, #2
		ret
; End of function UsbFlush_D54


; =============== S U B	R O U T	I N E =======================================


Usb_Fn_04_D74:					; usb_fn_04_B01p
		mov		RAM_29,	RAM_57_AppEntry_H
		mov		RAM_2A,	RAM_58_AppEntry_L
		clr		A
		mov		RAM_27,	A
		mov		RAM_28,	A
		mov		R5, A
		mov		R4, A

ROM_D81:					; Usb_Fn_04_D74+4Aj Usb_Fn_04_D74+4Ej
		inc		RAM_2A
		mov		A, RAM_2A
		mov		R6, RAM_29
		jnz		ROM_D8B
		inc		RAM_29

ROM_D8B:					; Usb_Fn_04_D74+13j
		dec	A
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		DPH, R6			; Data Pointer,	High Byte
		clr		A
		movc	A, @A+DPTR
		mov		R6, A
		mov		A, R6
		xrl		RAM_27,	A
		clr		A
		mov		R3, A
		mov		R2, A

ROM_D99:					; Usb_Fn_04_D74+42j
		mov		A, RAM_28
		add		A, ACC
		mov		RAM_28,	A
		mov		A, RAM_27
		rlc	A
		mov		RAM_27,	A
		jnb		ACC.7, ROM_DAD
		xrl		RAM_28,	#0x21
		xrl		RAM_27,	#0x10

ROM_DAD:					; Usb_Fn_04_D74+30j
		inc		R3
		cjne	R3, #0,	ROM_DB2
		inc		R2

ROM_DB2:					; Usb_Fn_04_D74+3Aj
		mov		A, R3
		xrl		A, #8
		orl		A, R2
		jnz		ROM_D99
		inc		R5
		cjne	R5, #0,	ROM_DBD
		inc		R4

ROM_DBD:					; Usb_Fn_04_D74+45j
		clr		A
		cjne	A, RAM_5, ROM_D81
		mov		A, R4
		cjne	A, #2, ROM_D81
		mov		A, RAM_27
		mov		R7, A
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_DD8
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_DD8
		mov		R4, #0
		mov		R5, #0
		sjmp	ROM_DDB

ROM_DD8:					; Usb_Fn_04_D74+56j Usb_Fn_04_D74+5Bj
		lcall	inc_RAM_EF_R45_1219

ROM_DDB:					; Usb_Fn_04_D74+62j
		lcall	mov_RAM_EF_R45_11EF	; Save R4,5 to RAM(E,F)	and DPTR
		mov		R7, RAM_28
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_DF0
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_DF0
		mov		R4, #0
		mov		R5, #0
		sjmp	ROM_DF3

ROM_DF0:					; Usb_Fn_04_D74+6Ej Usb_Fn_04_D74+73j
		lcall	inc_RAM_EF_R45_1219

ROM_DF3:					; Usb_Fn_04_D74+7Aj
		lcall	mov_RAM_EF_R45_11EF	; Save R4,5 to RAM(E,F)	and DPTR
		lcall	UsbFlush_D54
		ret
; End of function Usb_Fn_04_D74


; =============== S U B	R O U T	I N E =======================================


ROM_DFA:					; ROM_4AA:ROM_639p
		mov		A, RAM_52
		cjne	A, #4, ROM_E17
		mov		A, RAM_44
		jz		ROM_E67
		xrl		A, #1
		jz		ROM_E67
		mov		A, RAM_46
		jnz		ROM_E67
		mov		A, RAM_48
		jnz		ROM_E67
		mov		A, RAM_4A
		jnz		ROM_E67
		mov		A, RAM_4B
		jz		ROM_E19

ROM_E17:					; ROM_DFA+2j
		sjmp	ROM_E67

ROM_E19:					; ROM_DFA+1Bj
		mov		A, RAM_44
		xrl		A, #2
		jnz		ROM_E67
		mov		A, RAM_47
		jnz		ROM_E67
		mov		A, RAM_49
		xrl		A, #0x81
		jz		ROM_E2F
		mov		A, RAM_49
		xrl		A, #2
		jnz		ROM_E67

ROM_E2F:					; ROM_DFA+2Dj
		mov		A, RAM_49
		cjne	A, #0x81, ROM_E4C ; 'Å'

ROM_E34:					; ROM_DFA+3Cj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E34
		lcall	Mov_USB_0E_1_1036	; Mov 1	to USB(0E)

ROM_E3C:					; ROM_DFA+44j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E3C
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x10
		mov		RAM_4D,	#3
		sjmp	ROM_E6A

ROM_E4C:					; ROM_DFA+37j ROM_DFA+54j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E4C
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		mov		USB0DAT, #2

ROM_E57:					; ROM_DFA+5Fj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E57
		mov		USB0ADR, #0x14		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x20 ; ' '
		mov		RAM_4E,	#3
		sjmp	ROM_E6A

ROM_E67:					; ROM_DFA+7j ROM_DFA+Bj ...
		lcall	ROM_140E

ROM_E6A:					; ROM_DFA+50j ROM_DFA+6Bj ...
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E6A
		lcall	Clr_USB_0E_Cmp_i4C_4_102B ; Clear USB(0E) and compare RAM(4C) with 4
		jz		ROM_E7C

ROM_E74:					; ROM_DFA+7Cj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_E74
		lcall	ROM_FFF

ROM_E7C:					; ROM_DFA+78j
		ret
; End of function ROM_DFA


; =============== S U B	R O U T	I N E =======================================


ROM_E7D:					; ROM_4AA:ROM_634p
		mov		A, RAM_52
		cjne	A, #4, ROM_E9A
		mov		A, RAM_44
		jz		ROM_EE7
		xrl		A, #1
		jz		ROM_EE7
		mov		A, RAM_46
		jnz		ROM_EE7
		mov		A, RAM_48
		jnz		ROM_EE7
		mov		A, RAM_4A
		jnz		ROM_EE7
		mov		A, RAM_4B
		jz		ROM_E9C

ROM_E9A:					; ROM_E7D+2j
		sjmp	ROM_EE7

ROM_E9C:					; ROM_E7D+1Bj
		mov		A, RAM_44
		xrl		A, #2
		jnz		ROM_EE7
		mov		A, RAM_47
		jnz		ROM_EE7
		mov		A, RAM_49
		xrl		A, #0x81
		jz		ROM_EB2
		mov		A, RAM_49
		xrl		A, #2
		jnz		ROM_EE7

ROM_EB2:					; ROM_E7D+2Dj
		mov		A, RAM_49
		cjne	A, #0x81, ROM_ECC ; 'Å'

ROM_EB7:					; ROM_E7D+3Cj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_EB7
		lcall	Mov_USB_0E_1_1036	; Mov 1	to USB(0E)

ROM_EBF:					; ROM_E7D+44j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_EBF
		lcall	ROM_FFF
		clr		A
		mov		RAM_4D,	A
		sjmp	ROM_EEA

ROM_ECC:					; ROM_E7D+37j ROM_E7D+51j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_ECC
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		mov		USB0DAT, #2

ROM_ED7:					; ROM_E7D+5Cj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_ED7
		mov		USB0ADR, #0x14		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x80 ; 'Ä'
		clr		A
		mov		RAM_4E,	A
		sjmp	ROM_EEA

ROM_EE7:					; ROM_E7D+7j ROM_E7D+Bj ...
		lcall	ROM_140E

ROM_EEA:					; ROM_E7D+4Dj ROM_E7D+68j ...
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_EEA
		lcall	Clr_USB_0E_Cmp_i4C_4_102B ; Clear USB(0E) and compare RAM(4C) with 4
		jz		ROM_EFC

ROM_EF4:					; ROM_E7D+79j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_EF4
		lcall	ROM_FFF

ROM_EFC:					; ROM_E7D+75j
		ret
; End of function ROM_E7D


; =============== S U B	R O U T	I N E =======================================


ROM_EFD:					; ROM_74F+94p ROM_D11+31p
		cjne	R3, #1,	ROM_F06
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte
		movx	A, @DPTR
		ret

ROM_F06:					; ROM_EFDj
		jnc		ROM_F0A
		mov		A, @R1
		ret

ROM_F0A:					; ROM_EFD:ROM_F06j
		cjne	R3, #0xFE, ROM_F0F ; '˛'
		movx	A, @R1
		ret

ROM_F0F:					; ROM_EFD:ROM_F0Aj
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte
		clr		A
		movc	A, @A+DPTR
		ret
; End of function ROM_EFD


; =============== S U B	R O U T	I N E =======================================


ROM_F16:					; Fill_USB_FIFO_10B4+3Ep Fill_USB_FIFO_10B4+60p
		cjne	R3, #1,	ROM_F1F
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte
		movx	@DPTR, A
		ret

ROM_F1F:					; ROM_F16j
		jnc		ROM_F23
		mov		@R1, A
		ret

ROM_F23:					; ROM_F16:ROM_F1Fj
		cjne	R3, #0xFE, ROM_F27 ; '˛'
		movx	@R1, A

ROM_F27:					; ROM_F16:ROM_F23j
		ret
; End of function ROM_F16


; =============== S U B	R O U T	I N E =======================================


ROM_F28:					; ROM_4AA+215p
		xch		A, B
		mov		R0, A
		inc		DPTR
		movx	A, @DPTR
		add		A, R0
		movx	@DPTR, A
		xch		A, B
		mov		R0, A
		mov		A, DPL			; Data Pointer,	Low Byte
		dec	DPL			; Data Pointer,	Low Byte
		jnz		ROM_F3A
		dec	DPH			; Data Pointer,	High Byte

ROM_F3A:					; ROM_F28+Ej
		movx	A, @DPTR
		addc	A, R0
		movx	@DPTR, A
		ret
; End of function ROM_F28


; =============== S U B	R O U T	I N E =======================================


ROM_F3E:					; ROM_B53+7Dp
		mov		A, R3
		subb	A, R7
		mov		B, A
		mov		A, R2
		subb	A, R6
		orl		B, A
		mov		A, R1
		subb	A, R5
		orl		B, A
		mov		A, R0
		subb	A, R4
		orl		A, B
		ret
; End of function ROM_F3E


; =============== S U B	R O U T	I N E =======================================


ROM_F4F:					; ROM_B53+8Fp
		mov		A, #1
		mov		R7, A
		rlc	A
		subb	A, ACC
		mov		R6, A
		mov		R5, A
		mov		R4, A
		inc		R0
		inc		R0
		inc		R0
		mov		A, @R0
		xch		A, R7
		add		A, R7
		mov		@R0, A
		dec	R0
		mov		A, @R0
		xch		A, R6
		addc	A, R6
		mov		@R0, A
		dec	R0
		mov		A, @R0
		xch		A, R5
		addc	A, R5
		mov		@R0, A
		dec	R0
		mov		A, @R0
		xch		A, R4
		addc	A, R4
		mov		@R0, A
		ret
; End of function ROM_F4F


; =============== S U B	R O U T	I N E =======================================

; Jump to @(R2,R1)

Jmp_iR21_F6F:					; ROM_4AA+D2p Usb_Fn_06_3DEB+4j
		mov		DPH, R2			; Data Pointer,	High Byte
		mov		DPL, R1			; Data Pointer,	Low Byte
		clr		A
		jmp		@A+DPTR
; End of function Jmp_iR21_F6F


; =============== S U B	R O U T	I N E =======================================


ROM_F75:					; ROM_4AA:ROM_64Dp
		mov		A, RAM_52
		xrl		A, #2
		jz		ROM_F9A
		mov		A, RAM_44
		jnz		ROM_F9A
		mov		A, RAM_48
		jnz		ROM_F9A
		mov		A, RAM_49
		jnz		ROM_F9A
		mov		A, RAM_4A
		jnz		ROM_F9A
		mov		A, RAM_4B
		jnz		ROM_F9A
		mov		A, RAM_46
		jnz		ROM_F9A
		mov		A, RAM_47
		setb	C
		subb	A, #1
		jc		ROM_F9F

ROM_F9A:					; ROM_F75+4j ROM_F75+8j ...
		lcall	ROM_140E
		sjmp	ROM_FD7

ROM_F9F:					; ROM_F75+23j
		mov		A, RAM_47
		setb	C
		subb	A, #0
		jc		ROM_FCE
		mov		RAM_52,	#4
		clr		A
		mov		RAM_4D,	A
		mov		RAM_4E,	A

ROM_FAE:					; ROM_F75+3Bj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_FAE
		lcall	Mov_USB_0E_1_1036	; Mov 1	to USB(0E)

ROM_FB6:					; ROM_F75+43j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_FB6
		mov		USB0ADR, #0x12		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x20 ; ' '

ROM_FC1:					; ROM_F75+4Ej
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_FC1
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A
		sjmp	ROM_FD7

ROM_FCE:					; ROM_F75+2Fj
		mov		RAM_52,	#3
		mov		RAM_4D,	#3
		mov		RAM_4E,	#3

ROM_FD7:					; ROM_F75+28j ROM_F75+57j
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_FE5

ROM_FDD:					; ROM_F75+6Aj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_FDD
		lcall	ROM_FFF

ROM_FE5:					; ROM_F75+66j
		ret
; End of function ROM_F75


; =============== S U B	R O U T	I N E =======================================


ROM_FE6:					; ROM_74F+13Ap	ROM_C84+89p ...
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x40 ; '@'
		mov		RAM_4C,	#1
		clr		A
		mov		RAM_1E,	A
		mov		RAM_1F,	A
		ret
; End of function ROM_FE6


; =============== S U B	R O U T	I N E =======================================


ROM_FF5:					; ROM_C84:ROM_CBFp ROM_C84:ROM_CDEp ...
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#8
		ret
; End of function ROM_FF5


; =============== S U B	R O U T	I N E =======================================


ROM_FFF:					; ROM_A67+2Bp ROM_DFA+7Fp ...
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x40 ; '@'
		ret
; End of function ROM_FFF


; =============== S U B	R O U T	I N E =======================================

; Load @(RAM(3D), RAM(3E)+RAM(3F)) to A

Movc_iRAM_3D_3E_3F_1006:			; ROM_B53:ROM_B65p ROM_B53:ROM_B94p
		mov		A, RAM_3E
		add		A, RAM_3F
; End of function Movc_iRAM_3D_3E_3F_1006


; =============== S U B	R O U T	I N E =======================================

; Load @(RAM(3D),A) to A

Movc_iRAM_3D_A_100A:				; ROM_B53+89p
		mov		DPL, A			; Data Pointer,	Low Byte
		clr		A
		addc	A, RAM_3D
		mov		DPH, A			; Data Pointer,	High Byte
		clr		A
		movc	A, @A+DPTR
		ret
; End of function Movc_iRAM_3D_A_100A


; =============== S U B	R O U T	I N E =======================================


ROM_1014:					; ROM_C84+55p ROM_C84+69p ...
		mov		RAM_4F,	#0xFF
		mov		RAM_50,	#0
		mov		RAM_51,	#6
		ret
; End of function ROM_1014


; =============== S U B	R O U T	I N E =======================================

; Mov RAM(43,42) to DPTR

Mov_DPTR_RAM_42_43_101E:			; ROM_B53:ROM_B8Dp ROM_B53+45p
		mov		A, #0
		add		A, RAM_43
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, RAM_42
		mov		DPH, A			; Data Pointer,	High Byte
		ret
; End of function Mov_DPTR_RAM_42_43_101E


; =============== S U B	R O U T	I N E =======================================

; Clear	USB(0E)	and compare RAM(4C) with 4

Clr_USB_0E_Cmp_i4C_4_102B:			; ROM_DFA+75p ROM_E7D+72p
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A
		mov		A, RAM_4C
		xrl		A, #4
		ret
; End of function Clr_USB_0E_Cmp_i4C_4_102B


; =============== S U B	R O U T	I N E =======================================

; Mov 1	to USB(0E)

Mov_USB_0E_1_1036:				; ROM_DFA+3Fp ROM_E7D+3Fp ...
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		mov		USB0DAT, #1
		ret
; End of function Mov_USB_0E_1_1036


; =============== S U B	R O U T	I N E =======================================

; Clear	@530 @531 @532

Clr_i530_0_0_0_103D:				; ROM_74F+57p ROM_74F+F0p
		mov		DPTR, #0x530
		clr		A
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		ret
; End of function Clr_i530_0_0_0_103D


; =============== S U B	R O U T	I N E =======================================


ROM_1047:					; ROM_122D+2Cp	ROM_122D+37p ...
		mov		RAM_1C,	#0
		mov		RAM_1D,	#1
		ret
; End of function ROM_1047


; =============== S U B	R O U T	I N E =======================================


InitUSB_Clock_104E:				; PrepareUsbClock_13F3+Ep
		anl		USB0XCN, #0xBC
		orl		REG0CN,	#0x10
		orl		CLKSEL,	#0x10
		anl		CLKSEL,	#0xFD
		clr		A
		mov		CLKMUL,	A
		orl		OSCICN,	#0x20
		nop
		mov		CLKMUL,	A
		orl		CLKMUL,	#0x80
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		orl		CLKMUL,	#0xC0

wait_10A0:					; InitUSB_Clock_104E+54j
		mov		A, CLKMUL
		jnb		ACC.5, wait_10A0
		mov		CLKSEL,	#2
		anl		REG0CN,	#0xEF
		mov		A, USB0XCN
		anl		A, #0xFC
		orl		A, #0x40
		mov		USB0XCN, A
		ret
; End of function InitUSB_Clock_104E


; =============== S U B	R O U T	I N E =======================================


Fill_USB_FIFO_10B4:				; ROM_745+6p
		mov		RAM_3D,	R4
		mov		RAM_3E,	R5
		mov		RAM_3F,	R3
		mov		RAM_40,	R2
		mov		RAM_41,	R1
		mov		A, RAM_3E
		orl		A, RAM_3D
		jz		exit_1117
		mov		USB0ADR, R7		; USB0 Indirect	Address	Register
		orl		USB0ADR, #0xC0		; USB0 Indirect	Address	Register
		clr		A
		mov		R7, A
		mov		R6, A

loop_10CC:					; Fill_USB_FIFO_10B4:ROM_10FAj
		mov		A, RAM_3E
		add		A, #0xFF
		mov		R5, A
		mov		A, RAM_3D
		addc	A, #0xFF
		mov		R4, A
		clr		C
		mov		A, R7
		subb	A, R5
		mov		A, R6
		subb	A, R4
		jnc		ROM_10FC

wait_10DD:					; Fill_USB_FIFO_10B4+2Bj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_10DD
		mov		R3, RAM_3F
		inc		RAM_41
		mov		A, RAM_41
		mov		R2, RAM_40
		jnz		ROM_10EE
		inc		RAM_40

ROM_10EE:					; Fill_USB_FIFO_10B4+36j
		dec	A
		mov		R1, A
		mov		A, USB0DAT
		lcall	ROM_F16
		inc		R7
		cjne	R7, #0,	ROM_10FA
		inc		R6

ROM_10FA:					; Fill_USB_FIFO_10B4+42j
		sjmp	loop_10CC

ROM_10FC:					; Fill_USB_FIFO_10B4+27j
		clr		A
		mov		USB0ADR, A		; USB0 Indirect	Address	Register

wait_10FF:					; Fill_USB_FIFO_10B4+4Dj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_10FF
		mov		R3, RAM_3F
		inc		RAM_41
		mov		A, RAM_41
		mov		R2, RAM_40
		jnz		done_1110
		inc		RAM_40

done_1110:					; Fill_USB_FIFO_10B4+58j
		dec	A
		mov		R1, A
		mov		A, USB0DAT
		lcall	ROM_F16

exit_1117:					; Fill_USB_FIFO_10B4+Ej
		ret
; End of function Fill_USB_FIFO_10B4


; =============== S U B	R O U T	I N E =======================================


InitUSB_1118:
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, InitUSB_1118
		mov		USB0ADR, #1		; USB0 Indirect	Address	Register
		mov		USB0DAT, #8

wait_1123:					; InitUSB_1118+Dj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_1123
		mov		USB0ADR, #7		; USB0 Indirect	Address	Register
		mov		USB0DAT, #7

wait_112E:					; InitUSB_1118+18j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_112E
		mov		USB0ADR, #9		; USB0 Indirect	Address	Register
		mov		USB0DAT, #7

wait_1139:					; InitUSB_1118+23j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_1139
		mov		USB0ADR, #0xB		; USB0 Indirect	Address	Register
		mov		USB0DAT, #7

wait_1144:					; InitUSB_1118+2Ej
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_1144
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		mov		USB0DAT, #2

wait_114F:					; InitUSB_1118+39j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_114F
		mov		USB0ADR, #0x15		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x80 ; 'Ä'
		mov		USB0XCN, #0xE0 ; '‡'

wait_115D:					; InitUSB_1118+47j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_115D
		mov		USB0ADR, #0xF		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x80 ; 'Ä'
		orl		EIE1, #2
		orl		EIP1, #2
		setb	IE.7

wait_1170:					; InitUSB_1118+5Aj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, wait_1170
		mov		USB0ADR, #1		; USB0 Indirect	Address	Register
		mov		USB0DAT, #1
		ret
; End of function InitUSB_1118


; =============== S U B	R O U T	I N E =======================================


Usb_Fn_02_117C:					; usb_fn_02_AF7p
		clr		C
		mov		A, RAM_57_AppEntry_H
		subb	A, #0x16
		jnc		ROM_119D
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_1193
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_1193
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_1196

ROM_1193:					; Usb_Fn_02_117C+9j Usb_Fn_02_117C+Ej
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_1196:					; Usb_Fn_02_117C+15j
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #1
		sjmp	exit_11D1

ROM_119D:					; Usb_Fn_02_117C+5j
		clr		IE.7
		mov		DPL, RAM_58_AppEntry_L	; Data Pointer,	Low Byte
		mov		DPH, RAM_57_AppEntry_H	; Data Pointer,	High Byte
		mov		PSCTL, #3
		mov		FLKEY, #0xA5
		mov		FLKEY, #0xF1
		mov		VDM0CN,	#0x80
		mov		RSTSRC,	#6
		clr		A
		movx	@DPTR, A
		mov		PSCTL, A
		setb	IE.7
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_11CA
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_11CA
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_11CD

ROM_11CA:					; Usb_Fn_02_117C+40j Usb_Fn_02_117C+45j
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_11CD:					; Usb_Fn_02_117C+4Cj
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		clr		A

exit_11D1:					; Usb_Fn_02_117C+1Fj
		movx	@DPTR, A
		lcall	UsbFlush_D54
		ret
; End of function Usb_Fn_02_117C


; =============== S U B	R O U T	I N E =======================================

; Save R6,7 to RAM(E,F)	and DPTR

Mov_RAM_EF_R67_11D6:
		mov		RAM_E, R6
		mov		RAM_F, R7
; End of function Mov_RAM_EF_R67_11D6


; =============== S U B	R O U T	I N E =======================================

; Save R6,7 to DPTR

mov_DPTR_R67_11DA:				; ROM_12F3+35p
		mov		A, #0
		add		A, R7
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		ret
; End of function mov_DPTR_R67_11DA


; =============== S U B	R O U T	I N E =======================================

; Get RAM(E,F)+1 to R6,7

inc_RAM_EF_R67_11E5:
		mov		A, RAM_F
		add		A, #1
		mov		R7, A
		clr		A
		addc	A, RAM_E
		mov		R6, A
		ret
; End of function inc_RAM_EF_R67_11E5


; =============== S U B	R O U T	I N E =======================================

; Save R4,5 to RAM(E,F)	and DPTR

mov_RAM_EF_R45_11EF:				; Usb_Fn_04_D74:ROM_DDBp Usb_Fn_04_D74:ROM_DF3p ...
		mov		RAM_E, R4
		mov		RAM_F, R5
		mov		A, #0
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, R4
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R7
		movx	@DPTR, A
		ret
; End of function mov_RAM_EF_R45_11EF


; =============== S U B	R O U T	I N E =======================================


InitPointers_1200:
		mov		RAM_A, #high(XRAM_257)
		mov		RAM_B, #low(XRAM_257)
		mov		RAM_8_GetIndexHi, #high(XRAM_257)
		mov		RAM_9_GetIndexLo, #low(XRAM_257)
		mov		RAM_E, #high(XRAM_257)
		mov		RAM_F, #low(XRAM_257)
		mov		RAM_C, #high(XRAM_257)
		mov		RAM_D, #low(XRAM_257)
		ret
; End of function InitPointers_1200


; =============== S U B	R O U T	I N E =======================================


inc_RAM_EF_R45_1219:				; Usb_Fn_04_D74:ROM_DD8p Usb_Fn_04_D74:ROM_DF0p ...
		mov		A, RAM_F
		add		A, #1
		mov		R5, A
		clr		A
		addc	A, RAM_E
		mov		R4, A
		ret
; End of function inc_RAM_EF_R45_1219


; =============== S U B	R O U T	I N E =======================================

; Set AppEntry = (RAM(56) * 2 << 8)

SetAppEntry_1223:
		mov		A, RAM_56
		mov		RAM_58_AppEntry_L, #0
		add		A, ACC
		mov		RAM_57_AppEntry_H, A
		ret

; =============== S U B	R O U T	I N E =======================================


ROM_122D:					; ROM_4AA:ROM_648p
		mov		A, RAM_44
		cjne	A, #0x80, ROM_124C
		mov		A, RAM_46
		jnz		ROM_124C
		mov		A, RAM_47
		jnz		ROM_124C
		mov		A, RAM_48
		jnz		ROM_124C
		mov		A, RAM_49
		jnz		ROM_124C
		mov		A, RAM_4A
		jnz		ROM_124C
		mov		A, RAM_4B
		xrl		A, #1
		jz		ROM_1251

ROM_124C:					; ROM_122D+2j ROM_122D+7j ...
		lcall	ROM_140E
		sjmp	ROM_1267

ROM_1251:					; ROM_122D+1Dj
		mov		A, RAM_52
		cjne	A, #4, ROM_125C
		lcall	ROM_1014
		lcall	ROM_1047

ROM_125C:					; ROM_122D+26j
		mov		A, RAM_52
		cjne	A, #3, ROM_1267
		lcall	ROM_FF5
		lcall	ROM_1047

ROM_1267:					; ROM_122D+22j	ROM_122D+31j
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_1275

ROM_126D:					; ROM_122D+42j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_126D
		lcall	ROM_FE6

ROM_1275:					; ROM_122D+3Ej
		ret
; End of function ROM_122D


; =============== S U B	R O U T	I N E =======================================


ROM_1276:					; ROM_4AA:ROM_652p
		mov		A, RAM_52
		xrl		A, #4
		jnz		ROM_129B
		mov		A, RAM_44
		cjne	A, #0x81, ROM_129B ; 'Å'
		mov		A, RAM_46
		jnz		ROM_129B
		mov		A, RAM_47
		jnz		ROM_129B
		mov		A, RAM_48
		jnz		ROM_129B
		mov		A, RAM_49
		jnz		ROM_129B
		mov		A, RAM_4A
		jnz		ROM_129B
		mov		A, RAM_4B
		xrl		A, #1
		jz		ROM_12A0

ROM_129B:					; ROM_1276+4j ROM_1276+8j ...
		lcall	ROM_140E
		sjmp	ROM_12A6

ROM_12A0:					; ROM_1276+23j
		lcall	ROM_FF5
		lcall	ROM_1047

ROM_12A6:					; ROM_1276+28j
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_12B4

ROM_12AC:					; ROM_1276+38j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_12AC
		lcall	ROM_FE6

ROM_12B4:					; ROM_1276+34j
		ret
; End of function ROM_1276


; =============== S U B	R O U T	I N E =======================================


ROM_12B5:					; ROM_4AA:ROM_63Ep
		mov		A, RAM_44
		jnz		ROM_12D2
		mov		A, RAM_48
		jnz		ROM_12D2
		mov		A, RAM_49
		jnz		ROM_12D2
		mov		A, RAM_4A
		jnz		ROM_12D2
		mov		A, RAM_4B
		jnz		ROM_12D2
		mov		A, RAM_46
		jnz		ROM_12D2
		mov		A, RAM_47
		jnb		ACC.7, ROM_12D5

ROM_12D2:					; ROM_12B5+2j ROM_12B5+6j ...
		lcall	ROM_140E

ROM_12D5:					; ROM_12B5+1Aj
		mov		RAM_4C,	#5
		mov		A, RAM_47
		jz		ROM_12E1
		mov		RAM_52,	#3
		sjmp	ROM_12E4

ROM_12E1:					; ROM_12B5+25j
		mov		RAM_52,	#2

ROM_12E4:					; ROM_12B5+2Aj
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_12F2

ROM_12EA:					; ROM_12B5+37j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_12EA
		lcall	ROM_FFF

ROM_12F2:					; ROM_12B5+33j
		ret
; End of function ROM_12B5


; =============== S U B	R O U T	I N E =======================================


ROM_12F3:					; ROM_993+BCp
		mov		R6, RAM_E
		mov		R7, RAM_F
		mov		A, RAM_D
		cjne	A, RAM_7, ROM_1304
		mov		A, RAM_C
		cjne	A, RAM_6, ROM_1304
		setb	C
		sjmp	ROM_1305

ROM_1304:					; ROM_12F3+6j ROM_12F3+Bj
		clr		C

ROM_1305:					; ROM_12F3+Fj
		jc		ROM_132D
		mov		A, RAM_D
		cjne	A, #low(XRAM_257), ROM_1317
		mov		A, RAM_C
		cjne	A, #2, ROM_1317
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_1320

ROM_1317:					; ROM_12F3+16j	ROM_12F3+1Bj
		mov		A, RAM_D
		add		A, #1
		mov		R7, A
		clr		A
		addc	A, RAM_C
		mov		R6, A

ROM_1320:					; ROM_12F3+22j
		mov		RAM_C, R6
		mov		RAM_D, R7
		mov		R6, RAM_C
		mov		R7, RAM_D
		lcall	mov_DPTR_R67_11DA	; Save R6,7 to DPTR
		movx	A, @DPTR
		mov		R7, A

ROM_132D:					; ROM_12F3:ROM_1305j
		ret
; End of function ROM_12F3


; =============== S U B	R O U T	I N E =======================================


GetHostByte_132E:
		mov		A, RAM_9_GetIndexLo
		xrl		A, RAM_B
		jnz		ROM_1338
		mov		A, RAM_8_GetIndexHi
		xrl		A, RAM_A

ROM_1338:					; GetHostByte_132E+4j
		jz		GetHostByte_132E
		mov		A, RAM_9_GetIndexLo
		cjne	A, #low(XRAM_257), ROM_134A
		mov		A, RAM_8_GetIndexHi
		cjne	A, #high(XRAM_257), ROM_134A
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_1353

ROM_134A:					; GetHostByte_132E+Ej GetHostByte_132E+13j
		mov		A, RAM_9_GetIndexLo
		add		A, #1
		mov		R7, A
		clr		A
		addc	A, RAM_8_GetIndexHi
		mov		R6, A

ROM_1353:					; GetHostByte_132E+1Aj
		mov		RAM_8_GetIndexHi, R6
		mov		RAM_9_GetIndexLo, R7
		mov		R6, RAM_8_GetIndexHi
		mov		R7, RAM_9_GetIndexLo
		mov		A, #(XRAM_258 & 0xFF)
		add		A, R7
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #high(XRAM_258)
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function GetHostByte_132E


; =============== S U B	R O U T	I N E =======================================


ROM_1368:					; ROM_4AA+20Bp	ROM_4AA+261p
		mov		RAM_3D,	R4
		mov		RAM_3E,	R5
		mov		A, RAM_3E
		orl		A, RAM_3D
		jz		ROM_13A0

ROM_1372:					; ROM_1368+Cj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_1372
		mov		USB0ADR, R7		; USB0 Indirect	Address	Register
		clr		A
		mov		R7, A
		mov		R6, A

ROM_137C:					; ROM_1368:ROM_139Ej
		clr		C
		mov		A, R7
		subb	A, RAM_3E
		mov		A, R6
		subb	A, RAM_3D
		jnc		ROM_13A0
		inc		R3
		mov		A, R3
		mov		R4, RAM_2
		jnz		ROM_138C
		inc		R2

ROM_138C:					; ROM_1368+21j
		dec	A
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		DPH, R4			; Data Pointer,	High Byte
		movx	A, @DPTR
		mov		USB0DAT, A

ROM_1394:					; ROM_1368+2Ej
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_1394
		inc		R7
		cjne	R7, #0,	ROM_139E
		inc		R6

ROM_139E:					; ROM_1368+32j
		sjmp	ROM_137C

ROM_13A0:					; ROM_1368+8j ROM_1368+1Bj
		ret
; End of function ROM_1368


; =============== S U B	R O U T	I N E =======================================


ROM_13A1:					; ROM_74F+54p
		mov		R6, #0
		mov		R7, #UsbConfig_0096
		clr		A
		mov		R5, A

ROM_13A7:					; ROM_13A1+1Ej
		mov		A, R7
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		clr		A
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		clr		A
		movc	A, @A+DPTR
		mov		R4, A
		mov		A, #0
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		clr		A
		addc	A, #0
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R4
		movx	@DPTR, A
		inc		R5
		cjne	R5, #0x29, ROM_13A7
		mov		DPTR, #ROM_17FF
		clr		A
		movc	A, @A+DPTR
		mov		DPTR, #8
		movx	@DPTR, A
		ret
; End of function ROM_13A1


; =============== S U B	R O U T	I N E =======================================


Usb_Fn_05_13CC:					; usb_fn_05_B06p
		mov		R7, RAM_54_Cmd_1
		mov		A, R7
		mov		R6, A
		mov		A, RAM_55_Cmd_2
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		DPH, R6			; Data Pointer,	High Byte
		clr		A
		movc	A, @A+DPTR
		mov		R7, A
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_13E9
		mov		A, RAM_E
		cjne	A, #2, ROM_13E9
		mov		R4, #0
		mov		R5, #0
		sjmp	ROM_13EC

ROM_13E9:					; Usb_Fn_05_13CC+Fj Usb_Fn_05_13CC+14j
		lcall	inc_RAM_EF_R45_1219

ROM_13EC:					; Usb_Fn_05_13CC+1Bj
		lcall	mov_RAM_EF_R45_11EF	; Save R4,5 to RAM(E,F)	and DPTR
		lcall	UsbFlush_D54
		ret
; End of function Usb_Fn_05_13CC


; =============== S U B	R O U T	I N E =======================================


PrepareUsbClock_13F3:				; SPI0Handler+72p
		mov		R7, ADC0CN
		mov		R6, REF0CN
		clr		A
		mov		ADC0CN,	A
		clr		IE.7
		mov		REF0CN,	A
		anl		XBR1, #0xBF
		lcall	InitUSB_Clock_104E
		orl		XBR1, #0x40
		mov		ADC0CN,	R7
		mov		REF0CN,	R6
		setb	IE.7
		ret
; End of function PrepareUsbClock_13F3


; =============== S U B	R O U T	I N E =======================================


ROM_140E:					; ROM_Ej ROM_16j ...
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_140E
		mov		USB0ADR, #0xE		; USB0 Indirect	Address	Register
		clr		A
		mov		USB0DAT, A

ROM_1419:					; ROM_140E+Dj
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_1419
		mov		USB0ADR, #0x11		; USB0 Indirect	Address	Register
		mov		USB0DAT, #0x20 ; ' '
		mov		RAM_4C,	#4
		ret
; End of function ROM_140E


; =============== S U B	R O U T	I N E =======================================


ROM_1428:					; SPI0Handler+52p
		mov		RAM_52,	#2

ROM_142B:					; ROM_1428+5j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_142B
		mov		USB0ADR, #1		; USB0 Indirect	Address	Register
		mov		USB0DAT, #1
		clr		A
		mov		RAM_4C,	A
		mov		RAM_4D,	#3
		mov		RAM_4E,	#3
		ret
; End of function ROM_1428


; =============== S U B	R O U T	I N E =======================================


ROM_1440:					; ROM_4AA+208p	ROM_4AA+25Ep
		mov		DPTR, #0x530
		inc		DPTR
		movx	A, @DPTR
		mov		R2, A
		inc		DPTR
		movx	A, @DPTR
		mov		R3, A
		mov		R7, #0x20 ; ' '
		ret
; End of function ROM_1440


; =============== S U B	R O U T	I N E =======================================


ROM_144C:					; ROM_4AA+1FAp	ROM_4AA+250p
		mov		DPTR, #ROM_17FF
		clr		A
		movc	A, @A+DPTR
		mov		R7, A
		setb	C
		subb	A, #0x18
		ret
; End of function ROM_144C

data_XRAM_1456:	DB  0xC
		DB 0x10
		DB 0xFF
		DB	 3
		DB 0xD6 ; ÷
		DB 0xFF
		DB	 3
		DB 0xDA ; ⁄
		DB 0xFF
		DB	 4
		DB	 4
		DB 0xFF
		DB	 4
		DB 0x28 ; (
		DB	 3
		DB 0x4C ; L
		DB	 0
		DB	 0
		DB	 0
		DB	 0

; =============== S U B	R O U T	I N E =======================================


ROM_146A:					; ROM_4AA+13Ap
		mov		A, RAM_4C
		xrl		A, #4
		jz		ROM_147B

ROM_1470:					; ROM_146A+8j
		mov		A, USB0ADR		; USB0 Indirect	Address	Register
		jb		ACC.7, ROM_1470
		lcall	ROM_FFF
		mov		RAM_4C,	#2

ROM_147B:
		ret


; =============== S U B	R O U T	I N E =======================================

main_147C:
		anl		PCA0MD,	#0xBF		; PCA Mode Register
		lcall	InitPointers_1200
		lcall	InitOsc_3DD3
		lcall	InitUSB_1118
		ljmp	UsbStart_A98

; =============== S U B	R O U T	I N E =======================================

iROM_39D6_148B:
		mov		R1, SP			; Stack	Pointer
		mov		@R1, #high(RestartDevice_39D6)
		dec	R1
		mov		@R1, #low(RestartDevice_39D6)
		reti
		ret

; =============== S U B	R O U T	I N E =======================================

		cseg at	APP_START

		cseg at	INT0_IRQ_APP
		ljmp	INT0_0_0

		cseg at	T0OVF_IRQ_APP
		ljmp	T0OVF_0_0

		cseg at	INT1_IRQ_APP
		DB 0xFF, 0xFF, 0xFF

		cseg at	T1OVF_IRQ_APP
		DB 0xFF, 0xFF, 0xFF

		cseg at	UART0_IRQ_APP
		DB 0xFF, 0xFF, 0xFF

		cseg at	T2OVF_IRQ_APP
		ljmp	T2OVF_0_0

Load_x54C_R4567:
		mov		DPTR, #XRAM_54C

Load_R4567_iDPTR:
		movx	A, @DPTR
		mov		R4, A
		inc		DPTR
		movx	A, @DPTR
		mov		R5, A
		inc		DPTR

ROM_161B:
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR

ROM_161E:
		movx	A, @DPTR
		mov		R7, A
		ret

; =============== S U B	R O U T	I N E =======================================

PCA_Handler:
		mov		DPTR, #XRAM_547

CMP0_Handler:
		movx	A, @DPTR
		mov		R4, A
		inc		DPTR

CMP1_Handler:
		movx	A, @DPTR
		mov		R5, A
		inc		DPTR

ROM_162A:
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR

ROM_162D:
		movx	A, @DPTR
		mov		RAM_24,	A
		mov		RAM_23,	R6
		mov		RAM_22,	R5
		mov		RAM_21,	R4
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_1_1637:
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_24.1
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

Clr_i54B_R7654:
		mov		DPTR, #XRAM_54B

Clr_iDPTR_R7654:
		movx	@DPTR, A
		mov		R7, #0
		mov		R6, #0
		mov		R5, #0
		mov		R4, #0
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_2_164E:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.2
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_3_1658:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.3
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_4_1662:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.4
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_5_166C:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.5
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_6_1676:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.6
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_24_7_1680:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_24.7
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_23_0_168A:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_23.0
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_23_1_1694:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_23.1
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_23_2_169E:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_23.2
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_25_1_16A8:
		lcall	PulseHigh_P16_399D
		mov		C, RAM_25.1
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_16B2:
		clr		A
		mov		R0, #RAM_A0
		mov		@R0, A

ROM_16B6:
		mov		DPTR, #XRAM_534
		movx	A, @DPTR
		anl		A, #0xF
		movx	@DPTR, A
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_16BE:
		mov		RAM_25,	R7
ROM_16C0:
		mov		C, RAM_25.0
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_16C7:
		mov		C, RAM_24.0
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_16CE:
		mov		A, R7
		movx	@DPTR, A

ROM_16D0:
		mov		DPTR, #XRAM_534
		movx	A, @DPTR
		mov		R7, A
		mov		R5, #0x83 ; 'É'
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_23_3_16D8:
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_23.3
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

JTAG_25_2_16E2:
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.2
		mov		P1.4, C
		mov		C, P1.1
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_16EC:
		mov		R7, RAM_24
		mov		R6, RAM_23
		mov		R5, RAM_22
		mov		R4, RAM_21
		ljmp	ROM_212A

; =============== S U B	R O U T	I N E =======================================

ROM_16F7:
		clr		A
ROM_16F8:
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_1700:
		mov		P1.4, C
ROM_1702:
		mov		C, P1.1
		mov		RAM_21.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_170A:
		mov		DPTR, #XRAM_550
		movx	A, @DPTR
		mov		R7, A
		mov		DPTR, #XRAM_552
		movx	A, @DPTR
		clr		C
		subb	A, R7
		ret

; =============== S U B	R O U T	I N E =======================================

ShiftRightWord_1716:
		mov		A, @R0
		clr		C
		rrc		A
		mov		R1, #RAM_94
		mov		@R1, A
		inc		R0
		mov		A, @R0
		rrc		A
		inc		R1
		mov		@R1, A
		ret

; =============== S U B	R O U T	I N E =======================================


ROM_1722:					; ROM_2F7E+8p Fn_13_35D2+3p ...
		mov		DPTR, #XRAM_534
		movx	A, @DPTR
		mov		R7, A
		mov		R5, #0x80 ; 'Ä'
		ret
; End of function ROM_1722


; =============== S U B	R O U T	I N E =======================================


ROM_172A:					; Fn_0D_1785+29p Fn_16_287D+20p
		movx	A, @DPTR
		mov		R5, A
		clr		C
		mov		A, #3
		subb	A, R5
		mov		R5, A
		clr		A
		subb	A, #0
		mov		R4, A
		ret
; End of function ROM_172A


; =============== S U B	R O U T	I N E =======================================


ROM_1736:					; ROM_2489+1Ep	ROM_2489+A8p
		mov		A, @R0
		mov		R4, A
		inc		R0
		mov		A, @R0
		mov		R5, A
		clr		C
		mov		A, R7
		subb	A, R5
		mov		A, R6
		subb	A, R4
		ret
; End of function ROM_1736


; =============== S U B	R O U T	I N E =======================================


ROM_1741:					; ROM_213C+9p ROM_29E1+3p ...
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		clr		P1.4
		clr		A
		ret
; End of function ROM_1741


; =============== S U B	R O U T	I N E =======================================


ROM_1748:					; Fn_06_23B1+7Ap Fn_07_2B39+66p ...
		movx	@DPTR, A
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function ROM_1748


; =============== S U B	R O U T	I N E =======================================


ROM_174F:					; Fn_16_287D+15p Fn_02_2931+71p ...
		movx	A, @DPTR
		mov		R7, A
		inc		DPTR
		movx	A, @DPTR
		clr		C
		subb	A, R7
		ret
; End of function ROM_174F


; =============== S U B	R O U T	I N E =======================================


ROM_1756:					; ROM_2EBD+3Fp	ROM_2F7E+1Ap ...
		mov		A, R7
		movx	@DPTR, A
		lcall	ROM_3401
		movx	A, @DPTR
		ret
; End of function ROM_1756


; =============== S U B	R O U T	I N E =======================================


JTAG_23_4_175D:					; ROM_213C+110p ROM_2489+69p
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_23.4
		mov		P1.4, C
		mov		C, P1.1
		ret
; End of function JTAG_23_4_175D


; =============== S U B	R O U T	I N E =======================================


JTAG_25_3_1767:					; ROM_213C+127p ROM_213C+1B9p
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.3
		mov		P1.4, C
		mov		C, P1.1
		ret
; End of function JTAG_25_3_1767


; =============== S U B	R O U T	I N E =======================================


JTAG_25_4_1771:					; ROM_213C+12Cp ROM_213C+1BEp
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.4
		mov		P1.4, C
		mov		C, P1.1
		ret
; End of function JTAG_25_4_1771


; =============== S U B	R O U T	I N E =======================================


ROM_177B:					; ROM_2DDDp ROM_3612+2p
		mov		R6, RAM_7
		mov		DPTR, #XRAM_534
		movx	A, @DPTR
		mov		R7, A
		mov		R5, RAM_6
		ret
; End of function ROM_177B


; =============== S U B	R O U T	I N E =======================================


Fn_0D_1785:					; CmdExecute_1850:fn_0D_19AAp
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_564
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_563
		mov		A, R7
		movx	@DPTR, A
		jz		ROM_17A0
		movx	A, @DPTR
		setb	C
		subb	A, #0x18
		jc		ROM_17A3

ROM_17A0:					; Fn_0D_1785+13j
		mov		R7, #RESP_00
		ret

ROM_17A3:					; Fn_0D_1785+19j
		clr		A
		mov		DPTR, #XRAM_565
		movx	@DPTR, A

ROM_17A8:					; Fn_0D_1785+42j
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_565
		lcall	ROM_172A
		mov		A, #0x5F ; '_'
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #5
		addc	A, R4
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #XRAM_565
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		movx	A, @DPTR
		clr		C
		subb	A, #3
		jc		ROM_17A8
		mov		R0, #0x6D ; 'm'
		mov		R4, #5
		mov		R5, #1
		mov		R3, #1
		mov		R2, #5
		mov		R1, #0x5F ; '_'
		mov		R6, #0
		mov		R7, #4
		lcall	ROM_20B8
		mov		DPTR, #XRAM_563
		movx	A, @DPTR
		mov		DPTR, #0x571
		movx	@DPTR, A
		mov		DPTR, #XRAM_564
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2DDD
		mov		R7, #RESP_OK
		ret
; End of function Fn_0D_1785


; =============== S U B	R O U T	I N E =======================================

; Write	R7 to Address @57C

DataWrite_i57C_17EF:				; Fn_33_27C1+69p Fn_33_27C1+B6p ...
		mov		R6, RAM_7
		mov		DPTR, #XRAM_57C
		movx	A, @DPTR
		mov		R7, A
		lcall	C2_WriteAR_38F7
		mov		R7, RAM_6
		ljmp	DataWrite_3897
; End of function DataWrite_i57C_17EF

		DB 0xFF
ROM_17FF:	DB 0xFF			; ROM_74F:RAM_46_EQ_02_0793o ROM_13A1+21o ...

; =============== S U B	R O U T	I N E =======================================

; Attributes: thunk

j_CmdInit_39D0:
		ljmp	CmdInit_39D0
; End of function j_CmdInit_39D0

; START	OF FUNCTION CHUNK FOR CmdInit_39D0

CmdInit_1803:					; CmdInit_39D0+3j
		lcall	MeasureADC_1B0A
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_1816
		mov		A, RAM_E
		cjne	A, #2, ROM_1816
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_1819

ROM_1816:					; CmdInit_39D0-21C8j CmdInit_39D0-21C3j
		lcall	Inc_RAM_EF_R67_33A8

ROM_1819:					; CmdInit_39D0-21BCj
		mov		RAM_E, R6
		mov		RAM_F, R7
		mov		A, #0
		add		A, R7
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, #0xC
		movx	@DPTR, A
		lcall	UsbFlush_1BED

CmdLoop_182D:					; CmdInit_39D0-2182j
		mov		R6, RAM_A
		mov		R7, RAM_B
		mov		A, RAM_9_GetIndexLo
		cjne	A, RAM_7, ROM_183E
		mov		A, RAM_8_GetIndexHi
		cjne	A, RAM_6, ROM_183E
		setb	C
		sjmp	ROM_183F

ROM_183E:					; CmdInit_39D0-219Dj CmdInit_39D0-2198j
		clr		C

ROM_183F:					; CmdInit_39D0-2194j
		jc		set_leds_1847
		lcall	CmdExecute_1850
		lcall	UsbFlush_1BED

set_leds_1847:					; CmdInit_39D0:ROM_183Fj
		mov		R0, #RAM_A1_LEDS
		mov		A, @R0
		mov		R7, A
		lcall	SetLeds_1C6B		; R7 = 2  LED2 ON
						; R7 = 1  LED1 ON
						; R7 = X  off
		sjmp	CmdLoop_182D
; END OF FUNCTION CHUNK	FOR CmdInit_39D0

; =============== S U B	R O U T	I N E =======================================


CmdExecute_1850:				; CmdInit_39D0-218Fp
		clr		IE.5
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_A2
		mov		A, R7
		mov		@R0, A
		clr		C
		subb	A, #0x20
		jc		ROM_1888
		mov		A, @R0
		subb	A, #0xFE
		jnc		ROM_1888
		setb	P0.3			; CPIN_OE = 1
		anl		P1MDOUT, #0xBF		; CPIN_OUT Open	drain
		orl		P1, #0x40		; CPIN_OUT open
		mov		C, P1.5			; CPIN_IN
		mov		P1.2, C			; BPIN_OUT
		clr		P0.2			; BPIN_OE = 0
		orl		P1MDOUT, #4		; BPIN_OUT push	output
		clr		P0.3			; CPIN_OE = 0
		orl		P1MDOUT, #0x40		; CPIN_OUT push	output
		setb	P2.1			; APIN_OE = 1
		anl		P1MDOUT, #0xEF		; APIN_OUT open	drain
		orl		P1, #0x10		; APIN_OUT high
		mov		C, P0.0			; APIN_IN
		mov		P2.0, C			; DPIN_OE
		lcall	ROM_339D

ROM_1888:					; CmdExecute_1850+Cj CmdExecute_1850+11j
		mov		R0, #RAM_A2
		mov		A, @R0
		add		A, #2
		jnz		ROM_1892
		ljmp	Fn_FE_1ABC

ROM_1892:					; CmdExecute_1850+3Dj
		dec	A
		jnz		ROM_1898
		ljmp	Fn_FF_1AC5

ROM_1898:					; CmdExecute_1850+43j
		dec	A
		cjne	A, #0x40, ROM_189C

ROM_189C:
		jc		ROM_18A1
		ljmp	fn_01_1ACA

ROM_18A1:					; CmdExecute_1850:ROM_189Cj
		mov		DPTR, #ROM_18A8
		mov		R0, A
		add		A, R0
		add		A, R0
		jmp		@A+DPTR

ROM_18A8:					; CmdExecute_1850:ROM_18A1o
		ljmp	fn_00_1968
		ljmp	fn_01_1ACA
		ljmp	fn_02_196E
		ljmp	fn_03_1974
		ljmp	fn_04_197A
		ljmp	fn_01_1ACA
		ljmp	fn_06_1980
		ljmp	fn_07_1986
		ljmp	fn_08_198C
		ljmp	fn_09_1992
		ljmp	fn_0A_1998
		ljmp	fn_0B_199E
		ljmp	fn_0C_19A4
		ljmp	fn_0D_19AA
		ljmp	fn_0E_19B0
		ljmp	fn_0F_19B6
		ljmp	fn_10_19BC
		ljmp	fn_11_19C2
		ljmp	fn_12_19C8
		ljmp	fn_13_19CE
		ljmp	fn_14_19D4
		ljmp	fn_15_19DF
		ljmp	fn_16_19EB
		ljmp	fn_01_1ACA
		ljmp	fn_18_19F1
		ljmp	fn_19_19F7
		ljmp	fn_1A_19FD
		ljmp	fn_01_1ACA
		ljmp	fn_01_1ACA
		ljmp	fn_01_1ACA
		ljmp	fn_01_1ACA
		ljmp	fn_01_1ACA
		ljmp	fn_20_1A03
		ljmp	fn_21_1A09
		ljmp	fn_22_1A0F
		ljmp	fn_23_1A15
		ljmp	fn_24_1A1B
		ljmp	fn_25_1A21
		ljmp	fn_26_1A27
		ljmp	fn_27_1A2D
		ljmp	fn_28_1A33
		ljmp	fn_29_1A3B
		ljmp	fn_2A_1A42
		ljmp	fn_2B_1A49
		ljmp	fn_2C_1A50
		ljmp	fn_2D_1A55
		ljmp	fn_2E_1A5A
		ljmp	fn_2F_1A61
		ljmp	fn_30_1A68
		ljmp	fn_31_1A6D
		ljmp	fn_32_1A72
		ljmp	fn_33_1A77
		ljmp	fn_34_1A7C
		ljmp	fn_35_1A81
		ljmp	fn_36_1A86
		ljmp	fn_37_1A8B
		ljmp	fn_38_1A90
		ljmp	fn_39_1A95
		ljmp	fn_3A_1A9A
		ljmp	fn_3B_1A9F
		ljmp	fn_3C_1AA4
		ljmp	fn_3D_1AA9
		ljmp	fn_3E_1AAE
		ljmp	fn_3F_1AB5

fn_00_1968:					; CmdExecute_1850:ROM_18A8j
		lcall	Fn_00_38B9
		ljmp	ROM_1ABF

fn_02_196E:					; CmdExecute_1850+5Ej
		lcall	Fn_02_2931
		ljmp	ROM_1ABF

fn_03_1974:					; CmdExecute_1850+61j
		lcall	Fn_03_3590
		ljmp	ROM_1ABF

fn_04_197A:					; CmdExecute_1850+64j
		lcall	Fn_04_384E
		ljmp	ROM_1ABF

fn_06_1980:					; CmdExecute_1850+6Aj
		lcall	Fn_06_23B1
		ljmp	ROM_1ABF

fn_07_1986:					; CmdExecute_1850+6Dj
		lcall	Fn_07_2B39
		ljmp	ROM_1ABF

fn_08_198C:					; CmdExecute_1850+70j
		lcall	Fn_08_31E2
		ljmp	ROM_1ABF

fn_09_1992:					; CmdExecute_1850+73j
		lcall	Fn_09_3951
		ljmp	ROM_1ABF

fn_0A_1998:					; CmdExecute_1850+76j
		lcall	Fn_0A_303B
		ljmp	ROM_1ABF

fn_0B_199E:					; CmdExecute_1850+79j
		lcall	Fn_0B_331E
		ljmp	ROM_1ABF

fn_0C_19A4:					; CmdExecute_1850+7Cj
		lcall	Fn_0C_3232
		ljmp	ROM_1ABF

fn_0D_19AA:					; CmdExecute_1850+7Fj
		lcall	Fn_0D_1785
		ljmp	ROM_1ABF

fn_0E_19B0:					; CmdExecute_1850+82j
		lcall	Fn_0E_3757
		ljmp	ROM_1ABF

fn_0F_19B6:					; CmdExecute_1850+85j
		lcall	Fn_0F_390B
		ljmp	ROM_1ABF

fn_10_19BC:					; CmdExecute_1850+88j
		lcall	Fn_10_36F7
		ljmp	ROM_1ABF

fn_11_19C2:					; CmdExecute_1850+8Bj
		lcall	Fn_11_2BD8
		ljmp	ROM_1ABF

fn_12_19C8:					; CmdExecute_1850+8Ej
		lcall	Fn_12_2FDD
		ljmp	ROM_1ABF

fn_13_19CE:					; CmdExecute_1850+91j
		lcall	Fn_13_35D2
		ljmp	ROM_1ABF

fn_14_19D4:					; CmdExecute_1850+94j
		clr		A
		mov		DPTR, #XRAM_538
		movx	@DPTR, A
		lcall	ROM_3873
		ljmp	ROM_1ABF

fn_15_19DF:					; CmdExecute_1850+97j
		mov		DPTR, #XRAM_538
		mov		A, #1
		movx	@DPTR, A
		lcall	ROM_3873
		ljmp	ROM_1ABF

fn_16_19EB:					; CmdExecute_1850+9Aj
		lcall	Fn_16_287D
		ljmp	ROM_1ABF

fn_18_19F1:					; CmdExecute_1850+A0j
		lcall	Fn_18_34C9
		ljmp	ROM_1ABF

fn_19_19F7:					; CmdExecute_1850+A3j
		lcall	Fn_19_2E5B
		ljmp	ROM_1ABF

fn_1A_19FD:					; CmdExecute_1850+A6j
		lcall	Fn_1A_3727
		ljmp	ROM_1ABF

fn_20_1A03:					; CmdExecute_1850+B8j
		lcall	Fn_20_32D1		; Connect Target
		ljmp	ROM_1ABF

fn_21_1A09:					; CmdExecute_1850+BBj
		lcall	Fn_21_38D7		; Disconnect Target
		ljmp	ROM_1ABF

fn_22_1A0F:					; CmdExecute_1850+BEj
		lcall	Fn_22_3923		; Response DeviceID (Addr:0) and Revision (Addr:1)
		ljmp	ROM_1ABF

fn_23_1A15:					; CmdExecute_1850+C1j
		lcall	Fn_23_3282		; Device Unique	ID
		ljmp	ROM_1ABF

fn_24_1A1B:					; CmdExecute_1850+C4j
		lcall	Fn_24_37D9
		ljmp	ROM_1ABF

fn_25_1A21:					; CmdExecute_1850+C7j
		lcall	Fn_25_350C
		ljmp	ROM_1ABF

fn_26_1A27:					; CmdExecute_1850+CAj
		lcall	Fn_26_3829
		ljmp	ROM_1ABF

fn_27_1A2D:					; CmdExecute_1850+CDj
		lcall	Fn_27_3964
		ljmp	ROM_1ABF

fn_28_1A33:					; CmdExecute_1850+D0j
		mov		R7, #9
		lcall	Fn_28_2A_2E_3E_262F	; Read:	[cmd] add_lo [addr_hi] count
						; R7 = 09 SFR, = 2B RAM, = 06 FLASH, = 0E EMIF
						;
						;
		ljmp	ROM_1ABF

fn_29_1A3B:					; CmdExecute_1850+D3j
		mov		R7, #0xA
		lcall	Fn_29_2B_2F_3F_26FA
		sjmp	ROM_1ABF

fn_2A_1A42:					; CmdExecute_1850+D6j
		mov		R7, #0xB
		lcall	Fn_28_2A_2E_3E_262F	; Read:	[cmd] add_lo [addr_hi] count
						; R7 = 09 SFR, = 2B RAM, = 06 FLASH, = 0E EMIF
						;
						;
		sjmp	ROM_1ABF

fn_2B_1A49:					; CmdExecute_1850+D9j
		mov		R7, #0xC
		lcall	Fn_29_2B_2F_3F_26FA
		sjmp	ROM_1ABF

fn_2C_1A50:					; CmdExecute_1850+DCj
		lcall	Fn_2C_2C5D
		sjmp	ROM_1ABF

fn_2D_1A55:					; CmdExecute_1850+DFj
		lcall	Fn_2D_2D5F		; Write	XDATA F35x
						; 2D 84	00 len [data]
		sjmp	ROM_1ABF

fn_2E_1A5A:					; CmdExecute_1850+E2j
		mov		R7, #6
		lcall	Fn_28_2A_2E_3E_262F	; Read:	[cmd] add_lo [addr_hi] count
						; R7 = 09 SFR, = 2B RAM, = 06 FLASH, = 0E EMIF
						;
						;
		sjmp	ROM_1ABF

fn_2F_1A61:					; CmdExecute_1850+E5j
		mov		R7, #7
		lcall	Fn_29_2B_2F_3F_26FA
		sjmp	ROM_1ABF

fn_30_1A68:					; CmdExecute_1850+E8j
		lcall	Fn_30_3651		; Erase	flash sector
		sjmp	ROM_1ABF

fn_31_1A6D:					; CmdExecute_1850+EBj
		lcall	Fn_31_33B2
		sjmp	ROM_1ABF

fn_32_1A72:					; CmdExecute_1850+EEj
		lcall	Fn_32_2A8F
		sjmp	ROM_1ABF

fn_33_1A77:					; CmdExecute_1850+F1j
		lcall	Fn_33_27C1
		sjmp	ROM_1ABF

fn_34_1A7C:					; CmdExecute_1850+F4j
		lcall	Fn_34_2CDF
		sjmp	ROM_1ABF

fn_35_1A81:					; CmdExecute_1850+F7j
		lcall	Fn_35_3097
		sjmp	ROM_1ABF

fn_36_1A86:					; CmdExecute_1850+FAj
		lcall	Fn_36_354E		; Special Read:	36 sfr count (1)
		sjmp	ROM_1ABF

fn_37_1A8B:					; CmdExecute_1850+FDj
		lcall	Fn_37_3485		; Special Write	to SFR:	37 sfr count [values] sfr_value
		sjmp	ROM_1ABF

fn_38_1A90:					; CmdExecute_1850+100j
		lcall	Fn_38_39A4		; Address Write
		sjmp	ROM_1ABF

fn_39_1A95:					; CmdExecute_1850+103j
		lcall	Fn_39_39BE		; Address Read
		sjmp	ROM_1ABF

fn_3A_1A9A:					; CmdExecute_1850+106j
		lcall	Fn_3A_39B1		; Data Write
		sjmp	ROM_1ABF

fn_3B_1A9F:					; CmdExecute_1850+109j
		lcall	Fn_3B_39C7		; Data Read
		sjmp	ROM_1ABF

fn_3C_1AA4:					; CmdExecute_1850+10Cj
		lcall	Fn_3C_3783		; Erase	flash
		sjmp	ROM_1ABF

fn_3D_1AA9:					; CmdExecute_1850+10Fj
		lcall	Fn_3D_37AE
		sjmp	ROM_1ABF

fn_3E_1AAE:					; CmdExecute_1850+112j
		mov		R7, #0xE
		lcall	Fn_28_2A_2E_3E_262F	; Read:	[cmd] add_lo [addr_hi] count
						; R7 = 09 SFR, = 2B RAM, = 06 FLASH, = 0E EMIF
						;
						;
		sjmp	ROM_1ABF

fn_3F_1AB5:					; CmdExecute_1850+115j
		mov		R7, #0xF
		lcall	Fn_29_2B_2F_3F_26FA
		sjmp	ROM_1ABF

Fn_FE_1ABC:					; CmdExecute_1850+3Fj
		lcall	Fn_FE_1C46

ROM_1ABF:					; CmdExecute_1850+11Bj	CmdExecute_1850+121j ...
		mov		R0, #RAM_A3
		mov		@R0, RAM_7
		sjmp	ROM_1ACE

Fn_FF_1AC5:					; CmdExecute_1850+45j
		lcall	RestartDevice_39D6
		sjmp	ROM_1ACE

fn_01_1ACA:					; CmdExecute_1850+4Ej CmdExecute_1850+5Bj ...
		clr		A
		mov		R0, #RAM_A3
		mov		@R0, A

ROM_1ACE:					; CmdExecute_1850+273j	CmdExecute_1850+278j
		mov		R0, #RAM_A2
		mov		A, @R0
		mov		R7, A
		clr		C
		subb	A, #0x20
		jc		ROM_1AFC
		mov		A, R7
		subb	A, #0xFE
		jnc		ROM_1AFC
		setb	P0.2			; Port 0
		anl		P1MDOUT, #0xFB
		orl		P1, #4
		setb	P0.3			; Port 0
		anl		P1MDOUT, #0xBF
		orl		P1, #0x40
		setb	P0.4			; Port 0
		anl		P2MDOUT, #0xFE
		orl		P2, #1
		setb	P2.1
		anl		P1MDOUT, #0xEF
		orl		P1, #0x10

ROM_1AFC:					; CmdExecute_1850+285j	CmdExecute_1850+28Aj
		setb	IE.5
		mov		A, R7
		cpl	A
		jz		ROM_1B09
		mov		R0, #RAM_A3
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4

ROM_1B09:					; CmdExecute_1850+2B0j
		ret
; End of function CmdExecute_1850


; =============== S U B	R O U T	I N E =======================================


MeasureADC_1B0A:				; CmdInit_39D0:CmdInit_1803p
		anl		EIP1, #0xFD
		lcall	InitPorts_1B59
		anl		P2, #0xF7			; OE_VPROG = 0
		lcall	ROM_1C88
		lcall	ResetADC_1B43
		setb	ADC0CN.7
		clr		A
		mov		R7, A
		mov		R6, A

delay_1B1E:					; MeasureADC_1B0A:delay_1B23j MeasureADC_1B0A+1Cj
		inc		R7
		cjne	R7, #0,	delay_1B23
		inc		R6

delay_1B23:					; MeasureADC_1B0A+15j
		cjne	R6, #0x3F, delay_1B1E
		cjne	R7, #0xFF, delay_1B1E
		lcall	StartGetADC_1C5A
		lcall	ROM_3368
		lcall	ROM_1B90
		clr		A
		mov		R7, A
		mov		R6, A
		lcall	ROM_1C8F
		lcall	ROM_339D
		clr		A
		mov		R0, #RAM_A1_LEDS
		mov		@R0, A
		mov		R7, A
		ljmp	SetLeds_1C6B		; R7 = 2  LED2 ON
; End of function MeasureADC_1B0A		; R7 = 1  LED1 ON
						; R7 = X  off

; =============== S U B	R O U T	I N E =======================================


ResetADC_1B43:					; MeasureADC_1B0A+Cp
		mov		ADC0CN,	#AD0TM
		mov		AMX0P, #0x10
		mov		AMX0N, #0x1F
		mov		ADC0CF,	#AD0SC3
		anl		ADC0CF,	#0xFB
		mov		REF0CN,	#3
		anl		EIE1, #0xF7
		ret
; End of function ResetADC_1B43


; =============== S U B	R O U T	I N E =======================================


InitPorts_1B59:
		anl		XBR1, #0xBF
		mov		P0, #0xBF		; APIN_IN = 1
						; PWM_OUT = 1
						; BPIN_OE = 1
						; CPIN_OE = 1
						; DPIN_OUT = 1
						; EPIN_IN = 1
						; LED_2	= 0
						; P0.7 = 1
		mov		P0MDOUT, #0x42		; PWM_OUT, LED_2 Push output, other Open Drain
		mov		P0MDIN,	#0x7F		; P0.7 Analog
		mov		P1, #0xF6		; BPIN_IN = 1
						; BPIN_OUT = 1
						; LED_1	= 0
						; APIN_OUT = 1
						; CPIN_IN = 1
						; CPIN_OUT = 1
						; OE_VBUF = 1
		mov		P1MDOUT, #0x58		; CPIN_OUT, APIN_OUT, LED_1 Push output
		mov		P1MDIN,	#0xFF
		mov		DPTR, #XRAM_535
		movx	A, @DPTR
		orl		A, #0xF3
		mov		P2, A			; DPIN_OE = 1
						; APIN_OE = 1
		clr		A
		mov		P2MDOUT, A		; P2 OpenDrain
		mov		P2MDIN,	#0xFF
		mov		P3, #0xFE			; TDI_AI = 0
		mov		P3MDOUT, A		; TDI_AI OpenDrain
		mov		P3MDIN,	A		; TDI_AI Analog
		mov		P0SKIP,	#0x81
		mov		P1SKIP,	A
		mov		P2SKIP,	A
		mov		XBR0, A
		mov		XBR1, #0x41
		ret
; End of function InitPorts_1B59


; =============== S U B	R O U T	I N E =======================================


ROM_1B90:					; MeasureADC_1B0A+25p
		mov		PCA0MD,	#CPS2		; PCA Mode Register
		mov		DPTR, #0x53D
		movx	A, @DPTR
		mov		R7, A
		mov		PCA0CPL0, A
		mov		PCA0CPH0, R7
		mov		PCA0CPM0, #0x42
		mov		PCA0CN,	#0x40		; PCA Control Register
		mov		R7, #0xC
		mov		R6, #0xFE
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		anl		P0, #0xDF		; Port 0
		anl		P2MDIN,	#0xFB
		mov		AMX0P, #0xA
		ret
; End of function ROM_1B90


; =============== S U B	R O U T	I N E =======================================


GetHostByte_1BB3:				; Fn_0D_1785p Fn_0D_1785+3p ...
		mov		A, RAM_9_GetIndexLo
		xrl		A, RAM_B
		jnz		ready_1BBD
		mov		A, RAM_8_GetIndexHi
		xrl		A, RAM_A

ready_1BBD:					; GetHostByte_1BB3+4j
		jz		GetHostByte_1BB3
		mov		A, RAM_9_GetIndexLo
		cjne	A, #low(XRAM_257), inc_1BCF
		mov		A, RAM_8_GetIndexHi
		cjne	A, #2, inc_1BCF
		mov		R6, #0
		mov		R7, #0
		sjmp	save_1BD8

inc_1BCF:					; GetHostByte_1BB3+Ej GetHostByte_1BB3+13j
		mov		A, RAM_9_GetIndexLo
		add		A, #1
		mov		R7, A
		clr		A
		addc	A, RAM_8_GetIndexHi
		mov		R6, A

save_1BD8:					; GetHostByte_1BB3+1Aj
		mov		RAM_8_GetIndexHi, R6
		mov		RAM_9_GetIndexLo, R7
		mov		R6, RAM_8_GetIndexHi
		mov		R7, RAM_9_GetIndexLo
		mov		A, #0x58
		add		A, R7
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #2
		addc	A, R6
		mov		DPH, A			; Data Pointer,	High Byte
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function GetHostByte_1BB3


; =============== S U B	R O U T	I N E =======================================


UsbFlush_1BED:					; CmdInit_39D0-21A6p CmdInit_39D0-218Cp ...

; FUNCTION CHUNK AT 2136 SIZE 00000006 BYTES

		mov		R2, #high(UsbFlush_D54)
		mov		R1, #low(UsbFlush_D54)
		ljmp	Call_iR2R1_2136
; End of function UsbFlush_1BED


; =============== S U B	R O U T	I N E =======================================


AddToResponse_1BF4:				; CmdExecute_1850+2B6p	Fn_06_23B1+99p	...
		mov		DPTR, #XRAM_5AF
		mov		A, R7
		movx	@DPTR, A
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_1C09
		mov		A, RAM_E
		cjne	A, #2, ROM_1C09
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_1C0C

ROM_1C09:					; AddToResponse_1BF4+7j AddToResponse_1BF4+Cj
		lcall	Inc_RAM_EF_R67_33A8

ROM_1C0C:					; AddToResponse_1BF4+13j
		mov		A, R7
		cjne	A, RAM_D, ROM_1C17
		mov		A, R6
		cjne	A, RAM_C, ROM_1C17
		lcall	UsbFlush_1BED

ROM_1C17:					; AddToResponse_1BF4+19j AddToResponse_1BF4+1Dj
		mov		DPTR, #XRAM_5AF
		movx	A, @DPTR
		mov		R7, A
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_1C2C
		mov		A, RAM_E
		cjne	A, #2, ROM_1C2C
		mov		R4, #0
		mov		R5, #0
		sjmp	ROM_1C35

ROM_1C2C:					; AddToResponse_1BF4+2Aj AddToResponse_1BF4+2Fj
		mov		A, RAM_F
		add		A, #1
		mov		R5, A
		clr		A
		addc	A, RAM_E
		mov		R4, A

ROM_1C35:					; AddToResponse_1BF4+36j
		mov		RAM_E, R4
		mov		RAM_F, R5
		mov		A, #0
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #0
		addc	A, R4
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R7
		movx	@DPTR, A
		ret
; End of function AddToResponse_1BF4


; =============== S U B	R O U T	I N E =======================================


Fn_FE_1C46:					; CmdExecute_1850:Fn_FE_1ABCp
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_535
		mov		A, R7
		movx	@DPTR, A
		jz		ROM_1C54
		movx	A, @DPTR
		cjne	A, #8, ROM_1C57

ROM_1C54:					; Fn_FE_1C46+8j
		mov		R7, #RESP_OK
		ret

ROM_1C57:					; Fn_FE_1C46+Bj
		mov		R7, #RESP_02
		ret
; End of function Fn_FE_1C46


; =============== S U B	R O U T	I N E =======================================


StartGetADC_1C5A:				; MeasureADC_1B0A+1Fp 1CEBp ...
		clr		ADC0CN.5
		setb	ADC0CN.4

wait_1C5E:					; StartGetADC_1C5A:wait_1C5Ej
		jnb		ADC0CN.5, wait_1C5E
		clr		ADC0CN.5
		mov		A, ADC0H
		anl		A, #3
		mov		R6, A
		mov		R7, ADC0L
		ret
; End of function StartGetADC_1C5A


; =============== S U B	R O U T	I N E =======================================

; R7 = 2  LED2 ON
; R7 = 1  LED1 ON
; R7 = X  off

SetLeds_1C6B:
		mov		A, R7
		add		A, #0xFE
		jz		ROM_1C7A
		inc		A
		jnz		ROM_1C81
		anl		P0, #0xBF		; LED_2	= 0
		orl		P1, #8			; LED_1	= 1
		ret

ROM_1C7A:
		anl		P1, #0xF7		; LED_1	= 0
		orl		P0, #0x40		; LED_2	= 1
		ret

ROM_1C81:
		anl		P0, #0xBF		; LED_2	= 0
		anl		P1, #0xF7		; LED_1	= 0
		ret
; End of function SetLeds_1C6B


; =============== S U B	R O U T	I N E =======================================


ROM_1C88:
		mov		TMOD, #1
		orl		CKCON, #2
		ret

; =============== S U B	R O U T	I N E =======================================

ROM_1C8F:
		clr		A
		mov		TMR2CN,	A
		anl		CKCON, #0x9F
		clr		C
		subb	A, R7
		mov		R7, A
		clr		A
		subb	A, R6
		mov		TMR2RLH, A
		mov		TMR2RLL, R7
		mov		A, #0xFF
		mov		TMR2H, A
		mov		TMR2L, A
		setb	IE.5
		setb	TMR2CN.2
		ret

; =============== S U B	R O U T	I N E =======================================

T2OVF_0_0:
		push	ACC
		push	B
		push	DPH			; Data Pointer,	High Byte
		push	DPL			; Data Pointer,	Low Byte
		push	FSR_86
		mov		FSR_86,	#0
		push	PSW
		mov		PSW, #0
		push	RAM_0
		push	RAM_1
		push	RAM_2
		push	RAM_3
		push	RAM_4
		push	RAM_5
		push	RAM_6
		push	RAM_7
		clr		TMR2CN.7
		mov		DPTR, #XRAM_533
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		movx	A, @DPTR
		xrl		A, #0x1F
		jnz		ROM_1D14

		mov		C, P2.1
		rlc	A
		mov		DPTR, #XRAM_5B0
		movx	@DPTR, A
		setb	P2.1
		mov		AMX0P, #0x10
		mov		R7, #0xDB
		mov		R6, #0xFF
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value

		lcall	StartGetADC_1C5A
		mov		DPTR, #XRAM_53B
		movx	A, @DPTR
		xrl		A, R6
		jnz		ROM_1CF8

		inc		DPTR
		movx	A, @DPTR
		xrl		A, R7

ROM_1CF8:
		jz		ROM_1CFD
		lcall	ROM_3368

ROM_1CFD:
		mov		DPTR, #XRAM_53D
		movx	A, @DPTR
		mov		PCA0CPH0, A
		mov		AMX0P, #0xA
		mov		DPTR, #XRAM_5B0
		movx	A, @DPTR
		rrc		A
		mov		P2.1, C
		mov		DPTR, #XRAM_533
		clr		A
		movx	@DPTR, A
		sjmp	ROM_1D57

ROM_1D14:
		lcall	StartGetADC_1C5A
		mov		DPTR, #XRAM_536
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #XRAM_53B
		movx	A, @DPTR
		mov		R4, A
		inc		DPTR
		movx	A, @DPTR
		mov		R5, A
		clr		C
		subb	A, R7
		mov		A, R4
		subb	A, R6
		jnc		ROM_1D39
		inc		DPTR
		movx	A, @DPTR
		clr		C
		subb	A, #0xFF
		jnc		ROM_1D39
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_1D51

ROM_1D39:
		clr		C
		mov		DPTR, #XRAM_537
		movx	A, @DPTR
		subb	A, R5
		mov		DPTR, #XRAM_536
		movx	A, @DPTR
		subb	A, R4
		jnc		ROM_1D51
		mov		DPTR, #XRAM_53D
		movx	A, @DPTR
		subb	A, #0
		jc		ROM_1D51
		movx	A, @DPTR
		dec	A
		movx	@DPTR, A

ROM_1D51:
		mov		DPTR, #XRAM_53D
		movx	A, @DPTR
		mov		PCA0CPH0, A

ROM_1D57:
		pop	RAM_7
		pop	RAM_6
		pop	RAM_5
		pop	RAM_4
		pop	RAM_3
		pop	RAM_2
		pop	RAM_1
		pop	RAM_0
		pop	PSW
		pop	FSR_86
		pop	DPL			; Data Pointer,	Low Byte
		pop	DPH			; Data Pointer,	High Byte
		pop	B
		pop	ACC
		reti

; =============== S U B	R O U T	I N E =======================================

; Delay	via Timer 0 with R6(high), R7(low) value

Delay_T0_R67_1D74:				; ROM_1B90+16p	1CE8p ...
		anl		TCON, #0xCF
		mov		TL0, R7
		mov		A, R6
		mov		TH0, A
		setb	TCON.4

ROM_1D7E:					; Delay_T0_R67_1D74:ROM_1D7Ej
		jnb		TCON.5,	ROM_1D7E
		clr		TCON.4
		clr		TCON.5
		ret
; End of function Delay_T0_R67_1D74


; =============== S U B	R O U T	I N E =======================================


ROM_1D86:					; Fn_33_27C1+81p Fn_33_27C1+8Ep ...
		anl		TCON, #0xCF
		clr		A
		mov		TL0, A
		mov		TH0, A
		setb	TCON.4
		ret
; End of function ROM_1D86

; START	OF FUNCTION CHUNK FOR ROM_1D94

ROM_1D91:					; ROM_1D94+Bj ROM_1D94+1Dj ...
		ljmp	ROM_1FD3
; END OF FUNCTION CHUNK	FOR ROM_1D94

; =============== S U B	R O U T	I N E =======================================


ROM_1D94:					; ROM_3368+29p

; FUNCTION CHUNK AT 1D91 SIZE 00000003 BYTES
; FUNCTION CHUNK AT 1FB5 SIZE 00000033 BYTES

		mov		A, R0
		xrl		A, #0x80
		mov		R0, A
		mov		A, R1
		rlc	A
		mov		A, R0
		rlc	A
		jz		ROM_1DAF
		inc		A
		jz		ROM_1D91
		mov		A, R5
		rlc	A
		mov		A, R4
		rlc	A
		jnz		ROM_1DB0
		mov		A, R0
		mov		R4, A
		mov		A, R1
		mov		R5, A
		mov		A, R2
		mov		R6, A
		mov		A, R3
		mov		R7, A

ROM_1DAF:					; ROM_1D94+8j
		ret

ROM_1DB0:					; ROM_1D94+11j
		inc		A
		jz		ROM_1D91
		setb	C
		mov		A, R3
		subb	A, R7
		mov		A, R2
		subb	A, R6
		mov		A, R1
		subb	A, R5
		mov		A, R0
		clr		ACC.7
		mov		B, R4
		clr		B.7
		subb	A, B
		jc		ROM_1DD1
		mov		A, R0
		xch		A, R4
		mov		R0, A
		mov		A, R1
		xch		A, R5
		mov		R1, A
		mov		A, R2
		xch		A, R6
		mov		R2, A
		mov		A, R3
		xch		A, R7
		mov		R3, A

ROM_1DD1:					; ROM_1D94+2Fj
		lcall	ROM_1F9E
		mov		B, PSW
		anl		A, R0
		inc		A
		jnz		ROM_1DDE
		jb		PSW.5, ROM_1D91

ROM_1DDE:					; ROM_1D94+45j
		mov		A, R0
		inc		A
		jnz		ROM_1DE9
		jnc		ROM_1DE6
		cpl	PSW.5

ROM_1DE6:					; ROM_1D94+4Ej	ROM_1D94+59j
		ljmp	ROM_1FDD

ROM_1DE9:					; ROM_1D94+4Cj
		mov		PSW.5, C
		mov		A, R4
		inc		A
		jz		ROM_1DE6
		clr		A
		xch		A, R4
		push	ACC
		clr		C
		subb	A, R0
		mov		R0, A
		jz		ROM_1E33
		subb	A, #0x18
		jz		ROM_1E04
		jc		ROM_1E0B
		pop	ACC
		mov		R3, A
		ljmp	ROM_1FB5

ROM_1E04:					; ROM_1D94+66j
		clr		A
		mov		R3, A
		mov		R2, A
		xch		A, R1
		mov		R4, A
		sjmp	ROM_1E33

ROM_1E0B:					; ROM_1D94+68j
		mov		A, R0
		jnb		ACC.4, ROM_1E15
		clr		A
		xch		A, R1
		mov		R3, A
		clr		A
		xch		A, R2
		mov		R4, A

ROM_1E15:					; ROM_1D94+78j
		mov		A, R0
		jnb		ACC.3, ROM_1E1E
		clr		A
		xch		A, R1
		xch		A, R2
		xch		A, R3
		mov		R4, A

ROM_1E1E:					; ROM_1D94+82j
		mov		A, R0
		anl		A, #7
		jz		ROM_1E33
		mov		R0, A

ROM_1E24:					; ROM_1D94+9Dj
		clr		C
		mov		A, R1
		rrc		A
		mov		R1, A
		mov		A, R2
		rrc		A
		mov		R2, A
		mov		A, R3
		rrc		A
		mov		R3, A
		mov		A, R4
		rrc		A
		mov		R4, A
		djnz	R0, ROM_1E24

ROM_1E33:					; ROM_1D94+62j	ROM_1D94+75j ...
		jnb		B.5, ROM_1E65
		clr		C
		clr		A
		subb	A, R4
		mov		R4, A
		mov		A, R7
		subb	A, R3
		mov		R7, A
		mov		A, R6
		subb	A, R2
		mov		R6, A
		mov		A, R5
		subb	A, R1
		mov		R5, A
		pop	ACC
		mov		R3, A
		mov		A, R7
		orl		A, R6
		orl		A, R5
		orl		A, R4
		jnz		ROM_1E5E
		ret

ROM_1E4D:					; ROM_1D94+CBj
		djnz	R3, ROM_1E52
		ljmp	ROM_1FDA

ROM_1E52:					; ROM_1D94:ROM_1E4Dj
		mov		A, R4
		add		A, R4
		mov		R4, A
		mov		A, R7
		rlc	A
		mov		R7, A
		mov		A, R6
		rlc	A
		mov		R6, A
		mov		A, R5
		rlc	A
		mov		R5, A

ROM_1E5E:					; ROM_1D94+B6j
		mov		A, R5
		jnb		ACC.7, ROM_1E4D
		ljmp	ROM_1FB5

ROM_1E65:					; ROM_1D94:ROM_1E33j
		mov		A, R7
		add		A, R3
		mov		R7, A
		mov		A, R6
		addc	A, R2
		mov		R6, A
		mov		A, R5
		addc	A, R1
		mov		R5, A
		pop	ACC
		mov		R3, A
		jnc		ROM_1E86
		inc		R3
		cjne	R3, #0,	ROM_1E7A
		ljmp	ROM_1FDD

ROM_1E7A:					; ROM_1D94+E0j
		mov		A, R5
		rrc		A
		mov		R5, A
		mov		A, R6
		rrc		A
		mov		R6, A
		mov		A, R7
		rrc		A
		mov		R7, A
		mov		A, R4
		rrc		A
		mov		R4, A

ROM_1E86:					; ROM_1D94+DDj
		ljmp	ROM_1FB5
; End of function ROM_1D94

; START	OF FUNCTION CHUNK FOR ROM_1E8C

ROM_1E89:					; ROM_1E8C+20j	ROM_1E8C+31j
		ljmp	ROM_1FDD
; END OF FUNCTION CHUNK	FOR ROM_1E8C

; =============== S U B	R O U T	I N E =======================================


ROM_1E8C:					; ROM_3368+17p

; FUNCTION CHUNK AT 1E89 SIZE 00000003 BYTES

		mov		A, R4
		anl		A, R5
		inc		A
		jz		ROM_1E96
		mov		A, R0
		anl		A, R1
		inc		A
		jnz		ROM_1E99

ROM_1E96:					; ROM_1E8C+3j ROM_1E8C+12j ...
		ljmp	ROM_1FD3

ROM_1E99:					; ROM_1E8C+8j
		lcall	ROM_1F9E
		anl		A, R0
		inc		A
		jz		ROM_1E96
		mov		A, R4
		orl		A, R0
		jz		ROM_1E96
		mov		A, R4
		jnz		ROM_1EAB
		mov		R5, A
		mov		R6, A
		mov		R7, A
		ret

ROM_1EAB:					; ROM_1E8C+19j
		xch		A, R0
		jz		ROM_1E89
		add		A, #0x81 ; 'Å'
		xch		A, R0
		jnc		ROM_1EBC
		clr		C
		subb	A, R0
		jz		ROM_1EB9
		jnc		ROM_1EBF

ROM_1EB9:					; ROM_1E8C+29j	ROM_1E8C+71j
		ljmp	ROM_1FDA

ROM_1EBC:					; ROM_1E8C+25j
		subb	A, R0
		jnc		ROM_1E89

ROM_1EBF:					; ROM_1E8C+2Bj
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, R1
		add		A, R1
		orl		A, R3
		orl		A, R2
		jnz		ROM_1ECC
		mov		R3, DPL			; Data Pointer,	Low Byte
		ljmp	ROM_1FC9

ROM_1ECC:					; ROM_1E8C+39j
		mov		B, #0
		mov		R4, #0x1A
		mov		R0, #0x80 ; 'Ä'

ROM_1ED3:					; ROM_1E8C+9Bj
		clr		C
		mov		A, R7
		subb	A, R3
		mov		A, R6
		subb	A, R2
		mov		A, R5
		subb	A, R1
		jc		ROM_1EE9

ROM_1EDC:					; ROM_1E8C+96j
		clr		C
		mov		A, R7
		subb	A, R3
		mov		R7, A
		mov		A, R6
		subb	A, R2
		mov		R6, A
		mov		A, R5
		subb	A, R1
		mov		R5, A
		mov		A, R0
		orl		B, A

ROM_1EE9:					; ROM_1E8C+4Ej	ROM_1E8C+98j
		djnz	R4, ROM_1F0E
		mov		R4, B
		pop	ACC
		mov		R7, A
		pop	ACC
		mov		R6, A
		pop	ACC
		mov		R5, A
		mov		R3, DPL			; Data Pointer,	Low Byte
		jb		ACC.7, ROM_1F0B
		dec	R3
		mov		A, R3
		jz		ROM_1EB9
		mov		A, R4
		add		A, R4
		mov		R4, A
		mov		A, R7
		rlc	A
		mov		R7, A
		mov		A, R6
		rlc	A
		mov		R6, A
		mov		A, R5
		rlc	A
		mov		R5, A

ROM_1F0B:					; ROM_1E8C+6Cj
		ljmp	ROM_1FB5

ROM_1F0E:					; ROM_1E8C:ROM_1EE9j
		mov		A, R0
		rr	A
		mov		R0, A
		jnb		ACC.7, ROM_1F19
		push	B
		mov		B, #0

ROM_1F19:					; ROM_1E8C+85j
		mov		A, R7
		add		A, R7
		mov		R7, A
		mov		A, R6
		rlc	A
		mov		R6, A
		mov		A, R5
		rlc	A
		mov		R5, A
		jc		ROM_1EDC
		jnb		ACC.7, ROM_1EE9
		sjmp	ROM_1ED3
; End of function ROM_1E8C

		DB 0x75 ; u
		DB 0xF0 ; 
		DB 0x20
		DB 0x80 ; Ä
		DB  0xE

; =============== S U B	R O U T	I N E =======================================


ROM_1F2E:					; ROM_3368+Cp
		mov		B, #0x10
		sjmp	ROM_1F38
		mov		B, #8
		mov		R5, #0

ROM_1F38:					; ROM_1F2E+3j
		mov		R6, #0
		mov		R7, #0
		rlc	A
		mov		PSW.5, C
		jnb		PSW.5, ROM_1F45
		lcall	ROM_20DE

ROM_1F45:					; ROM_1F2E+11j	ROM_1F2E+27j
		mov		A, R4
		rlc	A
		jc		ROM_1F59
		mov		A, R7
		rlc	A
		mov		R7, A
		mov		A, R6
		rlc	A
		mov		R6, A
		mov		A, R5
		rlc	A
		mov		R5, A
		mov		A, R4
		rlc	A
		mov		R4, A
		djnz	B, ROM_1F45
		ret

ROM_1F59:					; ROM_1F2E+19j
		mov		A, B
		add		A, #0x7E ; '~'
		mov		C, PSW.5
		rrc		A
		xch		A, R4
		mov		ACC.7, C
		xch		A, R5
		xch		A, R6
		mov		R7, A
		ret
; End of function ROM_1F2E


; =============== S U B	R O U T	I N E =======================================


ROM_1F67:					; ROM_3368+2Cp
		mov		A, R5
		setb	ACC.7
		xch		A, R5
		rlc	A
		mov		A, R4
		rlc	A
		mov		PSW.5, C
		add		A, #0x81 ; 'Å'
		jc		ROM_1F7A
		clr		A

ROM_1F75:					; ROM_1F67+1Fj
		mov		R7, A
		mov		R6, A
		mov		R5, A
		mov		R4, A

ROM_1F79:					; ROM_1F67+31j
		ret

ROM_1F7A:					; ROM_1F67+Bj
		mov		R4, A
		clr		A
		xch		A, R7
		xch		A, R6
		xch		A, R5
		xch		A, R4
		add		A, #0xE0 ; '‡'
		jnc		ROM_1F95
		mov		A, #0xFF
		sjmp	ROM_1F75

ROM_1F88:					; ROM_1F67+2Fj
		clr		C
		xch		A, R4
		rrc		A
		xch		A, R4
		xch		A, R5
		rrc		A
		xch		A, R5
		xch		A, R6
		rrc		A
		xch		A, R6
		xch		A, R7
		rrc		A
		xch		A, R7

ROM_1F95:					; ROM_1F67+1Bj
		inc		A
		jnz		ROM_1F88
		jnb		PSW.5, ROM_1F79
		ljmp	ROM_20DE
; End of function ROM_1F67


; =============== S U B	R O U T	I N E =======================================


ROM_1F9E:					; ROM_1D94:ROM_1DD1p ROM_1E8C:ROM_1E99p
		mov		A, R1
		setb	ACC.7
		xch		A, R1
		rlc	A
		mov		A, R0
		rlc	A
		mov		R0, A
		mov		PSW.5, C
		mov		A, R5
		setb	ACC.7
		xch		A, R5
		rlc	A
		mov		A, R4
		rlc	A
		mov		R4, A
		jnc		ROM_1FB4
		cpl	PSW.5

ROM_1FB4:					; ROM_1F9E+12j
		ret
; End of function ROM_1F9E

; START	OF FUNCTION CHUNK FOR ROM_1D94

ROM_1FB5:					; ROM_1D94+6Dj	ROM_1D94+CEj ...
		mov		A, R4
		jnb		ACC.7, ROM_1FC9
		inc		R7
		cjne	R7, #0,	ROM_1FC9
		inc		R6
		cjne	R6, #0,	ROM_1FC9
		inc		R5
		cjne	R5, #0,	ROM_1FC9
		inc		R3
		mov		A, R3
		jz		ROM_1FDD

ROM_1FC9:					; ROM_1E8C+3Dj	ROM_1D94+222j ...
		mov		C, PSW.5
		mov		A, R3
		rrc		A
		mov		R4, A
		mov		A, R5
		mov		ACC.7, C
		mov		R5, A
		ret

ROM_1FD3:					; ROM_1D94:ROM_1D91j ROM_1E8C:ROM_1E96j
		mov		A, #0xFF

ROM_1FD5:					; ROM_1D94+247j
		mov		R4, A
		mov		R5, A

ROM_1FD7:					; ROM_1D94+252j
		mov		R6, A
		mov		R7, A
		ret

ROM_1FDA:					; ROM_1D94+BBj	ROM_1E8C:ROM_1EB9j
		clr		A
		sjmp	ROM_1FD5

ROM_1FDD:					; ROM_1D94:ROM_1DE6j ROM_1D94+E3j ...
		mov		C, PSW.5
		mov		A, #0xFF
		rrc		A
		mov		R4, A
		mov		R5, #0x80 ; 'Ä'
		clr		A
		sjmp	ROM_1FD7
; END OF FUNCTION CHUNK	FOR ROM_1D94

; =============== S U B	R O U T	I N E =======================================


ROM_1FE8:					; ROM_1FE8+4j 204Cj
		mov		A, @R1
		inc		R1
		mov		@R0, A
		inc		R0
		djnz	R7, ROM_1FE8
		sjmp	ROM_2036

ROM_1FF0:					; ROM_1FE8+Cj 2048j
		mov		A, @R1
		inc		R1
		movx	@R0, A
		inc		R0
		djnz	R7, ROM_1FF0
		sjmp	ROM_2036

ROM_1FF8:					; 204Ej
		mov		DPL, R0			; Data Pointer,	Low Byte
		mov		DPH, R4			; Data Pointer,	High Byte

ROM_1FFC:					; ROM_1FE8+18j
		mov		A, @R1
		inc		R1
		movx	@DPTR, A
		inc		DPTR
		djnz	R7, ROM_1FFC
		sjmp	ROM_2036

ROM_2004:					; ROM_1FE8+20j	203Cj
		movx	A, @R1
		inc		R1
		mov		@R0, A
		inc		R0
		djnz	R7, ROM_2004
		sjmp	ROM_2084

ROM_200C:					; ROM_1FE8+28j	ROM_2038j
		movx	A, @R1
		inc		R1
		movx	@R0, A
		inc		R0
		djnz	R7, ROM_200C
		sjmp	ROM_2084

ROM_2014:					; 203Ej
		mov		DPL, R0			; Data Pointer,	Low Byte
		mov		DPH, R4			; Data Pointer,	High Byte

ROM_2018:					; ROM_1FE8+34j
		movx	A, @R1
		inc		R1
		movx	@DPTR, A
		inc		DPTR
		djnz	R7, ROM_2018
		sjmp	ROM_2084

ROM_2020:					; 2054j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte

ROM_2024:					; ROM_1FE8+40j
		movx	A, @DPTR
		inc		DPTR
		mov		@R0, A
		inc		R0
		djnz	R7, ROM_2024
		sjmp	ROM_2084

ROM_202C:					; 2050j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte

ROM_2030:					; ROM_1FE8+4Cj
		movx	A, @DPTR
		inc		DPTR
		movx	@R0, A
		inc		R0
		djnz	R7, ROM_2030

ROM_2036:					; ROM_1FE8+6j ROM_1FE8+Ej ...
		sjmp	ROM_2084
; End of function ROM_1FE8


ROM_2038:					; 20DAo
		sjmp	ROM_200C
		sjmp	ROM_2036
		sjmp	ROM_2004
		sjmp	ROM_2014
		sjmp	ROM_20AB
		sjmp	ROM_2036
		sjmp	ROM_2079
		sjmp	ROM_2058
		sjmp	ROM_1FF0
		sjmp	ROM_2036
		sjmp	ROM_1FE8
		sjmp	ROM_1FF8
		sjmp	ROM_202C
		sjmp	ROM_2036
		sjmp	ROM_2020
		sjmp	ROM_208B

ROM_2058:					; 2046j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte
		mov		A, R4
		mov		R2, A

ROM_205E:					; 2073j 2075j
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R4
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R4
		movx	@DPTR, A
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R4
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R4
		djnz	R7, ROM_205E
		djnz	R6, ROM_205E
		sjmp	ROM_2086

ROM_2079:					; 2044j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte

ROM_207D:					; 2082j
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		mov		@R0, A
		inc		R0
		djnz	R7, ROM_207D

ROM_2084:					; ROM_1FE8+22j	ROM_1FE8+2Aj ...
		mov		A, R4
		mov		R2, A

ROM_2086:					; 2077j 20A9j
		mov		R1, B
		mov		A, R5
		mov		R3, A
		ret

ROM_208B:					; 2056j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte
		mov		A, R4
		mov		R2, A

ROM_2091:					; 20A5j 20A7j
		movx	A, @DPTR
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R4
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R4
		movx	@DPTR, A
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R4
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R4
		djnz	R7, ROM_2091
		djnz	R6, ROM_2091
		sjmp	ROM_2086

ROM_20AB:					; 2040j
		mov		DPL, R1			; Data Pointer,	Low Byte
		mov		DPH, R2			; Data Pointer,	High Byte

ROM_20AF:					; 20B4j
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		movx	@R0, A
		inc		R0
		djnz	R7, ROM_20AF
		sjmp	ROM_2084

ROM_20B8:					; Fn_0D_1785+54p
		mov		B, R0
		mov		A, R7
		jz		ROM_20BE
		inc		R6

ROM_20BE:					; 20BBj
		orl		A, R6
		jz		ROM_2084
		mov		B, R0
		mov		A, R5
		add		A, #2
		cjne	A, #4, ROM_20C9

ROM_20C9:
		jnc		ROM_2084
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, R3
		add		A, #2
		cjne	A, #4, ROM_20D3

ROM_20D3:
		jnc		ROM_2084
		rl	A
		rl	A
		orl		A, DPL			; Data Pointer,	Low Byte
		rl	A
		mov		DPTR, #ROM_2038
		jmp		@A+DPTR

; =============== S U B	R O U T	I N E =======================================


ROM_20DE:					; ROM_1F2E+14p	ROM_1F67+34j
		clr		C
		clr		A
		subb	A, R7
		mov		R7, A
		clr		A
		subb	A, R6
		mov		R6, A
		clr		A
		subb	A, R5
		mov		R5, A
		clr		A
		subb	A, R4
		mov		R4, A
		ret
; End of function ROM_20DE


; =============== S U B	R O U T	I N E =======================================


ROM_20EC:					; ROM_213C+221p ROM_213C+22Fp	...
		mov		A, R0
		jz		ROM_20FE

ROM_20EF:					; ROM_20EC+10j
		mov		A, R4
		clr		C
		rrc		A
		mov		R4, A
		mov		A, R5
		rrc		A
		mov		R5, A
		mov		A, R6
		rrc		A
		mov		R6, A
		mov		A, R7
		rrc		A
		mov		R7, A
		djnz	R0, ROM_20EF

ROM_20FE:					; ROM_20EC+1j
		ret
; End of function ROM_20EC


; =============== S U B	R O U T	I N E =======================================


ROM_20FF:					; ROM_2DDD+4Ep	ROM_2F7E+37p
		mov		A, R0
		jz		ROM_2111

ROM_2102:					; ROM_20FF+10j
		mov		A, R7
		clr		C
		rlc	A
		mov		R7, A
		mov		A, R6
		rlc	A
		mov		R6, A
		mov		A, R5
		rlc	A
		mov		R5, A
		mov		A, R4
		rlc	A
		mov		R4, A
		djnz	R0, ROM_2102

ROM_2111:					; ROM_20FF+1j
		ret
; End of function ROM_20FF


; =============== S U B	R O U T	I N E =======================================


ROM_2112:					; Fn_0A_303B+30p ROM_3612+3Bp
		mov		A, @R0
		mov		R4, A
		inc		R0
		mov		A, @R0
		mov		R5, A
		inc		R0
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		ret
; End of function ROM_2112


; =============== S U B	R O U T	I N E =======================================


ROM_211E:					; Fn_16_287D+86p Fn_0A_303B+17p ...
		mov		A, R4
		mov		@R0, A
		inc		R0
		mov		A, R5
		mov		@R0, A
		inc		R0
		mov		A, R6
		mov		@R0, A
		inc		R0
		mov		A, R7
		mov		@R0, A
		ret
; End of function ROM_211E


; =============== S U B	R O U T	I N E =======================================


ROM_212A:					; ROM_16EC+8j ROM_213C+3p ...
		mov		A, R4
		movx	@DPTR, A
		inc		DPTR
		mov		A, R5
		movx	@DPTR, A
		inc		DPTR
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		ret
; End of function ROM_212A

; START	OF FUNCTION CHUNK FOR UsbFlush_1BED

Call_iR2R1_2136:				; UsbFlush_1BED+4j
		mov		DPH, R2			; Data Pointer,	High Byte
		mov		DPL, R1			; Data Pointer,	Low Byte
		clr		A
		jmp		@A+DPTR
; END OF FUNCTION CHUNK	FOR UsbFlush_1BED

; =============== S U B	R O U T	I N E =======================================


ROM_213C:					; Fn_16_287D+81p ROM_2DDD+77p	...
		mov		DPTR, #0x547
		lcall	ROM_212A
		lcall	ROM_3996
		lcall	ROM_1741
		mov		R3, A

ROM_2149:					; ROM_213C+1Aj
		mov		R0, #RAM_55_Cmd_2
		mov		A, @R0
		mov		R7, A
		mov		A, R3
		clr		C
		subb	A, R7
		jnc		ROM_2158
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_2149

ROM_2158:					; ROM_213C+14j
		mov		DPTR, #XRAM_54B
		movx	A, @DPTR
		mov		R2, A
		xrl		A, #0xA
		jnz		ROM_21A0
		lcall	PCA_Handler
		lcall	ROM_16C7
		mov		RAM_22.6, C
		lcall	JTAG_24_1_1637
		mov		RAM_22.7, C
		lcall	JTAG_24_2_164E
		mov		RAM_21.0, C
		lcall	JTAG_24_3_1658
		mov		RAM_21.1, C
		lcall	JTAG_24_4_1662
		mov		RAM_21.2, C
		lcall	JTAG_24_5_166C
		mov		RAM_21.3, C
		lcall	JTAG_24_6_1676
		mov		RAM_21.4, C
		lcall	JTAG_24_7_1680
		mov		RAM_21.5, C
		lcall	JTAG_23_0_168A
		mov		RAM_21.6, C
		lcall	JTAG_23_1_1694
		mov		RAM_21.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_219D
		setb	P2.0

ROM_219D:					; ROM_213C+5Dj
		ljmp	ROM_2321

ROM_21A0:					; ROM_213C+23j
		mov		A, R2
		xrl		A, #0xB
		jnz		ROM_21E9
		lcall	PCA_Handler
		lcall	ROM_16C7
		mov		RAM_22.5, C
		lcall	JTAG_24_1_1637
		mov		RAM_22.6, C
		lcall	JTAG_24_2_164E
		mov		RAM_22.7, C
		lcall	JTAG_24_3_1658
		mov		RAM_21.0, C
		lcall	JTAG_24_4_1662
		mov		RAM_21.1, C
		lcall	JTAG_24_5_166C
		mov		RAM_21.2, C
		lcall	JTAG_24_6_1676
		mov		RAM_21.3, C
		lcall	JTAG_24_7_1680
		mov		RAM_21.4, C
		lcall	JTAG_23_0_168A
		mov		RAM_21.5, C
		lcall	JTAG_23_1_1694
		mov		RAM_21.6, C
		lcall	JTAG_23_2_169E
		mov		RAM_21.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_21E6
		setb	P2.0

ROM_21E6:					; ROM_213C+A6j
		ljmp	ROM_2321

ROM_21E9:					; ROM_213C+67j
		mov		DPTR, #XRAM_54B
		movx	A, @DPTR
		mov		R2, A
		xrl		A, #0x13
		jz		ROM_21F5
		ljmp	ROM_227C

ROM_21F5:					; ROM_213C+B4j
		lcall	PCA_Handler
		mov		C, RAM_23.5
		mov		RAM_25.0, C
		mov		C, RAM_23.6
		mov		RAM_25.1, C
		mov		C, RAM_23.7
		mov		RAM_25.2, C
		mov		C, RAM_22.0
		mov		RAM_25.3, C
		mov		C, RAM_22.1
		mov		RAM_25.4, C
		mov		C, RAM_22.2
		mov		RAM_25.5, C
		lcall	ROM_16C7
		mov		RAM_23.5, C
		lcall	JTAG_24_1_1637
		mov		RAM_23.6, C
		lcall	JTAG_24_2_164E
		mov		RAM_23.7, C
		lcall	JTAG_24_3_1658
		mov		RAM_22.0, C
		lcall	JTAG_24_4_1662
		mov		RAM_22.1, C
		lcall	JTAG_24_5_166C
		mov		RAM_22.2, C
		lcall	JTAG_24_6_1676
		mov		RAM_22.3, C
		lcall	JTAG_24_7_1680
		mov		RAM_22.4, C
		lcall	JTAG_23_0_168A
		mov		RAM_22.5, C
		lcall	JTAG_23_1_1694
		mov		RAM_22.6, C
		lcall	JTAG_23_2_169E
		mov		RAM_22.7, C
		lcall	JTAG_23_3_16D8
		mov		RAM_21.0, C
		lcall	JTAG_23_4_175D
		mov		RAM_21.1, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	ROM_16C0
		mov		RAM_21.2, C
		lcall	JTAG_25_1_16A8
		mov		RAM_21.3, C
		lcall	JTAG_25_2_16E2
		mov		RAM_21.4, C
		lcall	JTAG_25_3_1767
		mov		RAM_21.5, C
		lcall	JTAG_25_4_1771
		mov		RAM_21.6, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.5
		lcall	ROM_1700
		jnz		ROM_2279
		setb	P2.0

ROM_2279:					; ROM_213C+139j
		ljmp	ROM_2321

ROM_227C:					; ROM_213C+B6j
		mov		A, R2
		xrl		A, #0x14
		jz		ROM_2284
		ljmp	ROM_232C

ROM_2284:					; ROM_213C+143j
		lcall	PCA_Handler
		mov		C, RAM_23.4
		mov		RAM_25.0, C
		mov		C, RAM_23.5
		mov		RAM_25.1, C
		mov		C, RAM_23.6
		mov		RAM_25.2, C
		mov		C, RAM_23.7
		mov		RAM_25.3, C
		mov		C, RAM_22.0
		mov		RAM_25.4, C
		mov		C, RAM_22.1
		mov		RAM_25.5, C
		mov		C, RAM_22.2
		mov		RAM_25.6, C
		mov		C, RAM_22.3
		mov		RAM_25.7, C
		lcall	ROM_16C7
		mov		RAM_23.4, C
		lcall	JTAG_24_1_1637
		mov		RAM_23.5, C
		lcall	JTAG_24_2_164E
		mov		RAM_23.6, C
		lcall	JTAG_24_3_1658
		mov		RAM_23.7, C
		lcall	JTAG_24_4_1662
		mov		RAM_22.0, C
		lcall	JTAG_24_5_166C
		mov		RAM_22.1, C
		lcall	JTAG_24_6_1676
		mov		RAM_22.2, C
		lcall	JTAG_24_7_1680
		mov		RAM_22.3, C
		lcall	JTAG_23_0_168A
		mov		RAM_22.4, C
		lcall	JTAG_23_1_1694
		mov		RAM_22.5, C
		lcall	JTAG_23_2_169E
		mov		RAM_22.6, C
		lcall	JTAG_23_3_16D8
		mov		RAM_22.7, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	ROM_16C0
		mov		RAM_21.0, C
		lcall	JTAG_25_1_16A8
		mov		RAM_21.1, C
		lcall	JTAG_25_2_16E2
		mov		RAM_21.2, C
		lcall	JTAG_25_3_1767
		mov		RAM_21.3, C
		lcall	JTAG_25_4_1771
		mov		RAM_21.4, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.5
		mov		P1.4, C
		mov		C, P1.1
		mov		RAM_21.5, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.6
		mov		P1.4, C
		mov		C, P1.1
		mov		RAM_21.6, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_25.7
		lcall	ROM_1700
		jnz		ROM_2321
		setb	P2.0

ROM_2321:					; ROM_213C:ROM_219Dj ROM_213C:ROM_21E6j ...
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		DPTR, #0x54C
		lcall	ROM_16EC
		sjmp	ROM_2390

ROM_232C:					; ROM_213C+145j
		clr		A
		mov		DPTR, #0x54C
		lcall	ROM_16F8
		mov		R3, A

ROM_2334:					; ROM_213C+252j
		mov		DPTR, #XRAM_54B
		movx	A, @DPTR
		mov		R2, A
		mov		A, R3
		clr		C
		subb	A, R2
		jnc		ROM_2390
		mov		DPTR, #0x547
		inc		DPTR
		inc		DPTR
		inc		DPTR
		movx	A, @DPTR
		anl		A, #1
		mov		R7, A
		mov		A, R7
		add		A, #0xFF
		mov		P1.4, C
		mov		DPTR, #0x547
		movx	A, @DPTR
		mov		R4, A
		inc		DPTR
		movx	A, @DPTR
		mov		R5, A
		inc		DPTR
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		mov		R0, #1
		lcall	ROM_20EC
		mov		DPTR, #0x547
		lcall	ROM_212A
		lcall	Load_x54C_R4567
		mov		R0, #1
		lcall	ROM_20EC
		mov		DPTR, #0x54C
		lcall	ROM_212A
		jnb		P1.1, ROM_237E
		mov		DPTR, #0x54C
		movx	A, @DPTR
		orl		A, #0x80
		movx	@DPTR, A

ROM_237E:					; ROM_213C+238j
		mov		A, R2
		dec	A
		cjne	A, RAM_3, ROM_238A
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_238A
		setb	P2.0

ROM_238A:					; ROM_213C+244j ROM_213C+24Aj
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_2334

ROM_2390:					; ROM_213C+1EEj ROM_213C+200j
		clr		P1.4
		clr		A
		mov		R3, A

ROM_2394:					; ROM_213C+26Cj
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		mov		R7, A
		mov		A, R3
		clr		C
		subb	A, R7
		jnc		ROM_23AA
		mov		A, R7
		dec	A
		cjne	A, RAM_3, ROM_23A4
		setb	P2.0

ROM_23A4:					; ROM_213C+263j
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_2394

ROM_23AA:					; ROM_213C+25Fj
		lcall	PulseHigh2_P16_3998
		lcall	Load_x54C_R4567
		ret
; End of function ROM_213C


; =============== S U B	R O U T	I N E =======================================


Fn_06_23B1:					; CmdExecute_1850:fn_06_1980p
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x557
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x556
		mov		A, #2
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x550
		mov		A, R7
		movx	@DPTR, A
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_23E3
		clr		A
		mov		DPTR, #0x552
		movx	@DPTR, A

ROM_23D6:					; Fn_06_23B1+2Dj
		lcall	ROM_170A
		jnc		ROM_23E0
		lcall	ROM_247D
		sjmp	ROM_23D6

ROM_23E0:					; Fn_06_23B1+28j
		mov		R7, #RESP_01
		ret

ROM_23E3:					; Fn_06_23B1+1Ej
		mov		DPTR, #0x550
		movx	A, @DPTR
		jnz		ROM_23FA
		mov		DPTR, #0x552
		movx	@DPTR, A

ROM_23ED:					; Fn_06_23B1+44j
		lcall	ROM_170A
		jnc		ROM_23F7
		lcall	ROM_247D
		sjmp	ROM_23ED

ROM_23F7:					; Fn_06_23B1+3Fj
		mov		R7, #RESP_00
		ret

ROM_23FA:					; Fn_06_23B1+36j
		mov		DPTR, #0x556
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		DPTR, #0x550
		movx	A, @DPTR
		mov		R7, A
		anl		A, #1
		mov		R6, A
		mov		DPTR, #0x555
		movx	@DPTR, A
		mov		A, R7
		clr		C
		rrc		A
		mov		DPTR, #0x551
		movx	@DPTR, A
		mov		A, R6
		jz		ROM_241E
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A

ROM_241E:					; Fn_06_23B1+68j
		mov		DPTR, #0x551
		movx	A, @DPTR
		mov		DPTR, #0x554
		movx	@DPTR, A
		mov		DPTR, #0x553
		mov		A, #5
		lcall	ROM_1748
		lcall	ROM_2F7E
		clr		A
		mov		DPTR, #0x552
		movx	@DPTR, A

ROM_2436:					; Fn_06_23B1+A2j
		mov		DPTR, #0x551
		movx	A, @DPTR
		dec	A
		mov		R7, A
		inc		DPTR
		movx	A, @DPTR
		clr		C
		subb	A, R7
		jnc		ROM_2455
		lcall	ROM_2469
		mov		DPTR, #0x554
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x552
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_2436

ROM_2455:					; Fn_06_23B1+8Fj
		lcall	ROM_2469
		mov		DPTR, #0x555
		movx	A, @DPTR
		jnz		ROM_2466
		mov		DPTR, #0x554
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4

ROM_2466:					; Fn_06_23B1+ABj
		mov		R7, #RESP_OK
		ret
; End of function Fn_06_23B1


; =============== S U B	R O U T	I N E =======================================


ROM_2469:					; Fn_06_23B1+91p Fn_06_23B1:ROM_2455p
		lcall	ROM_368B
		mov		DPTR, #0x553
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x553
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4
		ret
; End of function ROM_2469


; =============== S U B	R O U T	I N E =======================================


ROM_247D:					; Fn_06_23B1+2Ap Fn_06_23B1+41p
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x552
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		ret
; End of function ROM_247D


; =============== S U B	R O U T	I N E =======================================


ROM_2489:					; Fn_16_287D+6Ep Fn_11_2BD8+1Ap ...
		mov		A, R7
		mov		R6, A
		mov		A, R5
		mov		R7, A
		clr		A
		mov		RAM_24,	R7
		mov		RAM_23,	R6
		mov		RAM_22,	A
		mov		RAM_21,	A
		setb	P2.0
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	PulseHigh2_P16_3998
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		setb	P1.4
		mov		R7, A
		mov		R6, A

ROM_24A5:					; ROM_2489:ROM_24B4j
		mov		R0, #RAM_53_Cmd_0
		lcall	ROM_1736
		jnc		ROM_24B6
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R7
		cjne	R7, #0,	ROM_24B4
		inc		R6

ROM_24B4:					; ROM_2489+27j
		sjmp	ROM_24A5

ROM_24B6:					; ROM_2489+21j
		lcall	ROM_16C7
		mov		RAM_24.0, C
		lcall	JTAG_24_1_1637
		mov		RAM_24.1, C
		lcall	JTAG_24_2_164E
		mov		RAM_24.2, C
		lcall	JTAG_24_3_1658
		mov		RAM_24.3, C
		lcall	JTAG_24_4_1662
		mov		RAM_24.4, C
		lcall	JTAG_24_5_166C
		mov		RAM_24.5, C
		lcall	JTAG_24_6_1676
		mov		RAM_24.6, C
		lcall	JTAG_24_7_1680
		mov		RAM_24.7, C
		lcall	JTAG_23_0_168A
		mov		RAM_23.0, C
		lcall	JTAG_23_1_1694
		mov		RAM_23.1, C
		lcall	JTAG_23_2_169E
		mov		RAM_23.2, C
		lcall	JTAG_23_3_16D8
		mov		RAM_23.3, C
		lcall	JTAG_23_4_175D
		mov		RAM_23.4, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_23.5
		mov		P1.4, C
		mov		C, P1.1
		mov		RAM_23.5, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_23.6
		mov		P1.4, C
		mov		C, P1.1
		mov		RAM_23.6, C
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		C, RAM_23.7
		mov		P1.4, C
		mov		C, P1.1
		mov		RAM_23.7, C
		mov		R0, #RAM_57_AppEntry_H
		mov		A, @R0
		dec	R0
		orl		A, @R0
		jnz		ROM_2521
		setb	P2.0

ROM_2521:					; ROM_2489+94j
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		DPTR, #0x59B
		lcall	ROM_16EC
		setb	P1.4
		clr		A
		mov		R6, A
		mov		R7, A

ROM_252F:					; ROM_2489:ROM_2551j
		mov		R0, #RAM_56
		lcall	ROM_1736
		jnc		ROM_2553
		mov		A, @R0
		add		A, #0xFF
		mov		R5, A
		dec	R0
		mov		A, @R0
		addc	A, #0xFF
		mov		R4, A
		mov		A, R5
		cjne	A, RAM_7, ROM_2549
		mov		A, R4
		cjne	A, RAM_6, ROM_2549
		setb	P2.0

ROM_2549:					; ROM_2489+B7j	ROM_2489+BBj
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R7
		cjne	R7, #0,	ROM_2551
		inc		R6

ROM_2551:					; ROM_2489+C4j
		sjmp	ROM_252F

ROM_2553:					; ROM_2489+ABj
		lcall	PulseHigh2_P16_3998
		mov		DPTR, #0x59B
		lcall	Load_R4567_iDPTR
		ret
; End of function ROM_2489


; =============== S U B	R O U T	I N E =======================================


Send_XX_R7_255D:				; DataWrite_3897+12p C2_WriteAR_38F7+Ap
		clr		IE.7			; Pulse	low P1.4 C2CK
		clr		P1.4
		setb	P1.4
		setb	IE.7
		clr		IE.7			; Pulse	low P1.4 C2CK
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		RAM_20,	R7
		mov		C, RAM_20.0
		mov		P1.6, C			; Set R7.0 to P1.6 C2D
		clr		IE.7			; Pulse	low P1.4 C2CK
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.1
		mov		P1.6, C
		clr		IE.7			; Pulse	low P1.4 C2CK
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.2
		mov		P1.6, C
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.3
		mov		P1.6, C
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.4
		mov		P1.6, C
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.5
		mov		P1.6, C
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.6
		mov		P1.6, C
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		mov		C, RAM_20.7
		mov		P1.6, C
; End of function Send_XX_R7_255D


; =============== S U B	R O U T	I N E =======================================


Pulse_Low_P14_25C7:				; C2_ReadDR_2F1Fp C2_ReadDR_2F1F+Ap ...
		clr		IE.7
		clr		P1.4
		setb	P1.4
		setb	IE.7
		ret
; End of function Pulse_Low_P14_25C7


; =============== S U B	R O U T	I N E =======================================


ROM_25D0:					; Fn_33_27C1+5Ep Fn_33_27C1:ROM_286Cp	...
		mov		DPTR, #XRAM_539
		movx	A, @DPTR
		mov		R7, A
		xrl		A, #0xF
		ret
; End of function ROM_25D0


; =============== S U B	R O U T	I N E =======================================


ROM_25D8:					; INT0_0_0:ROM_31C2p Fn_25_350C+3Cp
		clr		P2.1			; APIN_OE = 0
		orl		P1MDOUT, #0x10

Set_Connected_25DD:				; Fn_34_2CDF+6Bp Fn_20_32D1+47p
		mov		R0, #RAM_A0
		mov		@R0, #1
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #2
		ret
; End of function ROM_25D8


; =============== S U B	R O U T	I N E =======================================

; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)

Check_C2_Connected_25E6:			; Fn_28_2A_2E_3E_262F+31p Fn_29_2B_2F_3F_26FA+31p ...
		mov		@R0, RAM_7
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		ret
; End of function Check_C2_Connected_25E6


; =============== S U B	R O U T	I N E =======================================


SetIn_P16_25EE:					; C2_ReadDR_2F1F+18p AddressRead_30EE+12p ...
		setb	P0.3			; Port 0
		anl		P1MDOUT, #0xBF
		orl		P1, #0x40
		ret
; End of function SetIn_P16_25EE


; =============== S U B	R O U T	I N E =======================================


Cmp_RAM_59_5A_25F7:				; Fn_28_2A_2E_3E_262F:fill_zeros_2669p	Fn_28_2A_2E_3E_262F:fill_zero_2687p ...
		mov		R1, #RAM_59
		mov		A, @R1
		clr		C
		mov		R0, #RAM_5A
		subb	A, @R0
		ret
; End of function Cmp_RAM_59_5A_25F7


; =============== S U B	R O U T	I N E =======================================


ROM_25FF:					; Fn_29_2B_2F_3F_26FA:ROM_2734p Fn_29_2B_2F_3F_26FA:ROM_2752p	...
		mov		R1, #RAM_5E
		mov		A, @R1
		clr		C
		mov		R0, #RAM_5F
		subb	A, @R0
		ret
; End of function ROM_25FF


; =============== S U B	R O U T	I N E =======================================


ROM_2607:					; Fn_25_350C+Ep Fn_25_350C+20p ...
		setb	P2.1
		anl		P1MDOUT, #0xEF
		orl		P1, #0x10
		ret
; End of function ROM_2607


; =============== S U B	R O U T	I N E =======================================


ROM_2610:					; Fn_33_27C1+23p Fn_32_2A8F+23p ...
		mov		DPTR, #XRAM_53A
		movx	A, @DPTR
		xrl		A, #1
		ret
; End of function ROM_2610


; =============== S U B	R O U T	I N E =======================================


ROM_2617:					; Set_Target_3141+Fp Set_Target_3141+24p
		mov		DPTR, #0x579
		movx	@DPTR, A
		mov		DPTR, #0x578
		inc		A
		movx	@DPTR, A
		mov		DPTR, #0x57B
		ret
; End of function ROM_2617


; =============== S U B	R O U T	I N E =======================================


ROM_2624:					; Fn_33_27C1+A8p T0OVF_0_0+14p
		anl		P2MDOUT, #0xF7		; OE_VPROG OpenDrain
		mov		DPTR, #XRAM_535
		movx	A, @DPTR
		cpl	A
		anl		P2, A
		ret
; End of function ROM_2624


; =============== S U B	R O U T	I N E =======================================

; Read:	[cmd] add_lo [addr_hi] count
; R7 = 09 SFR, = 2B RAM, = 06 FLASH, = 0E EMIF
;
;

Fn_28_2A_2E_3E_262F:				; CmdExecute_1850+1E5p	CmdExecute_1850+1F4p ...
		mov		DPTR, #XRAM_5A2
		mov		A, R7
		movx	@DPTR, A
		xrl		A, #0xE
		jz		add_16_263C
		movx	A, @DPTR
		cjne	A, #6, addr_8_2640

add_16_263C:					; Fn_28_2A_2E_3E_262F+7j
		mov		R7, #RESP_01		; Type 0E and 06 not supported
		sjmp	load_addr_2642

addr_8_2640:					; Fn_28_2A_2E_3E_262F+Aj
		mov		R7, #RESP_00

load_addr_2642:					; Fn_28_2A_2E_3E_262F+Fj
		mov		DPTR, #XRAM_5A3
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3	; Address Low
		mov		R0, #RAM_5C
		mov		@R0, RAM_7
		mov		DPTR, #XRAM_5A3
		movx	A, @DPTR
		jz		skip_addr_high_265B
		lcall	GetHostByte_1BB3	; Address High (optional)
		mov		R0, #RAM_5B
		mov		@R0, RAM_7

skip_addr_high_265B:				; Fn_28_2A_2E_3E_262F+23j
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_5A
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		read_2676
		clr		A
		mov		R0, #RAM_59
		mov		@R0, A

fill_zeros_2669:				; Fn_28_2A_2E_3E_262F+42j
		lcall	Cmp_RAM_59_5A_25F7
		jnc		done_2673
		lcall	Add_0_Inc_5A_26E7	; Add 0	to response and	increment RAM(59)
		sjmp	fill_zeros_2669

done_2673:					; Fn_28_2A_2E_3E_262F+3Dj
		mov		R7, #RESP_01
		ret

read_2676:					; Fn_28_2A_2E_3E_262F+34j
		mov		DPTR, #XRAM_5A2
		movx	A, @DPTR
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_26F0
		jz		cmd_ok_2691
		clr		A
		mov		R0, #RAM_59
		mov		@R0, A

fill_zero_2687:					; Fn_28_2A_2E_3E_262F+60j
		lcall	Cmp_RAM_59_5A_25F7
		jnc		exit_26E2
		lcall	Add_0_Inc_5A_26E7	; Add 0	to response and	increment RAM(59)
		sjmp	fill_zero_2687

cmd_ok_2691:					; Fn_28_2A_2E_3E_262F+52j
		mov		DPTR, #XRAM_5A3
		movx	A, @DPTR
		jz		add_8_269E
		mov		R0, #RAM_5B
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0

add_8_269E:					; Fn_28_2A_2E_3E_262F+66j
		mov		R0, #RAM_5C
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R0, #RAM_5A
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		DPTR, #XRAM_5A2
		movx	A, @DPTR
		xrl		A, #6
		jnz		read_26CE
		lcall	Wait_A0_DataRead_26F0
		jz		read_26CE
		clr		A
		mov		R0, #RAM_59
		mov		@R0, A

fill_zeros_26BD:				; Fn_28_2A_2E_3E_262F+9Bj
		lcall	Cmp_RAM_59_5A_25F7
		jnc		exit_26CC
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_59
		inc		@R0
		sjmp	fill_zeros_26BD

exit_26CC:					; Fn_28_2A_2E_3E_262F+91j
		sjmp	exit_26E2

read_26CE:					; Fn_28_2A_2E_3E_262F+83j Fn_28_2A_2E_3E_262F+88j
		clr		A
		mov		R0, #RAM_59
		mov		@R0, A

read_loop_26D2:					; Fn_28_2A_2E_3E_262F+B1j
		lcall	Cmp_RAM_59_5A_25F7
		jnc		exit_26E2
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_59
		inc		@R0
		sjmp	read_loop_26D2

exit_26E2:					; Fn_28_2A_2E_3E_262F+5Bj Fn_28_2A_2E_3E_262F:exit_26CCj ...
		mov		R0, #RAM_5D
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_28_2A_2E_3E_262F


; =============== S U B	R O U T	I N E =======================================

; Add 0	to response and	increment RAM(59)

Add_0_Inc_5A_26E7:				; Fn_28_2A_2E_3E_262F+3Fp Fn_28_2A_2E_3E_262F+5Dp
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_59
		inc		@R0
		ret
; End of function Add_0_Inc_5A_26E7


; =============== S U B	R O U T	I N E =======================================


Wait_A0_DataRead_26F0:				; Fn_28_2A_2E_3E_262F+4Fp Fn_28_2A_2E_3E_262F+85p
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_5D
		mov		A, R7
		mov		@R0, A
		xrl		A, #RESP_OK
		ret
; End of function Wait_A0_DataRead_26F0


; =============== S U B	R O U T	I N E =======================================


Fn_29_2B_2F_3F_26FA:				; CmdExecute_1850+1EDp	CmdExecute_1850+1FBp ...
		mov		DPTR, #0x5A4
		mov		A, R7
		movx	@DPTR, A
		xrl		A, #0xF
		jz		ROM_2707
		movx	A, @DPTR
		cjne	A, #7, ROM_270B

ROM_2707:					; Fn_29_2B_2F_3F_26FA+7j
		mov		R7, #1
		sjmp	ROM_270D

ROM_270B:					; Fn_29_2B_2F_3F_26FA+Aj
		mov		R7, #0

ROM_270D:					; Fn_29_2B_2F_3F_26FA+Fj
		mov		DPTR, #0x5A5
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_61
		mov		@R0, RAM_7
		mov		DPTR, #0x5A5
		movx	A, @DPTR
		jz		ROM_2726
		lcall	GetHostByte_1BB3
		mov		R0, #0x60 ; '`'
		mov		@R0, RAM_7

ROM_2726:					; Fn_29_2B_2F_3F_26FA+23j
		lcall	GetHostByte_1BB3
		mov		R0, #0x5F ; '_'
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		ROM_2741
		clr		A
		mov		R0, #0x5E ; '^'
		mov		@R0, A

ROM_2734:					; Fn_29_2B_2F_3F_26FA+42j
		lcall	ROM_25FF
		jnc		ROM_273E
		lcall	ROM_27B0
		sjmp	ROM_2734

ROM_273E:					; Fn_29_2B_2F_3F_26FA+3Dj
		mov		R7, #1
		ret

ROM_2741:					; Fn_29_2B_2F_3F_26FA+34j
		mov		DPTR, #0x5A4
		movx	A, @DPTR
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	ROM_27B7
		jz		ROM_275C
		clr		A
		mov		R0, #0x5E ; '^'
		mov		@R0, A

ROM_2752:					; Fn_29_2B_2F_3F_26FA+60j
		lcall	ROM_25FF
		jnc		ROM_27AB
		lcall	ROM_27B0
		sjmp	ROM_2752

ROM_275C:					; Fn_29_2B_2F_3F_26FA+52j
		mov		DPTR, #0x5A5
		movx	A, @DPTR
		jz		ROM_2769
		mov		R0, #RAM_60
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0

ROM_2769:					; Fn_29_2B_2F_3F_26FA+66j
		mov		R0, #RAM_61
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R0, #RAM_5F
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		DPTR, #0x5A4
		movx	A, @DPTR
		xrl		A, #7
		jnz		ROM_2797
		lcall	ROM_27B7
		jz		ROM_2797
		clr		A
		mov		R0, #RAM_5E
		mov		@R0, A

ROM_2788:					; Fn_29_2B_2F_3F_26FA+99j
		lcall	ROM_25FF
		jnc		ROM_2795
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_5E
		inc		@R0
		sjmp	ROM_2788

ROM_2795:					; Fn_29_2B_2F_3F_26FA+91j
		sjmp	ROM_27AB

ROM_2797:					; Fn_29_2B_2F_3F_26FA+83j Fn_29_2B_2F_3F_26FA+88j
		clr		A
		mov		R0, #RAM_5E
		mov		@R0, A

ROM_279B:					; Fn_29_2B_2F_3F_26FA+AFj
		lcall	ROM_25FF
		jnc		ROM_27AB
		lcall	GetHostByte_1BB3
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R0, #RAM_5E
		inc		@R0
		sjmp	ROM_279B

ROM_27AB:					; Fn_29_2B_2F_3F_26FA+5Bj Fn_29_2B_2F_3F_26FA:ROM_2795j ...
		mov		R0, #RAM_62
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_29_2B_2F_3F_26FA


; =============== S U B	R O U T	I N E =======================================


ROM_27B0:					; Fn_29_2B_2F_3F_26FA+3Fp Fn_29_2B_2F_3F_26FA+5Dp
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_5E
		inc		@R0
		ret
; End of function ROM_27B0


; =============== S U B	R O U T	I N E =======================================


ROM_27B7:					; Fn_29_2B_2F_3F_26FA+4Fp Fn_29_2B_2F_3F_26FA+85p
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_62
		mov		A, R7
		mov		@R0, A
		xrl		A, #0xD
		ret
; End of function ROM_27B7


; =============== S U B	R O U T	I N E =======================================


Fn_33_27C1:					; CmdExecute_1850:fn_33_1A77p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_71
		mov		@R0, #0
		inc		R0
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		A, R7
		mov		R0, #RAM_71
		orl		A, @R0
		mov		@R0, A
		inc		R0
		mov		A, @R0
		mov		@R0, A
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_74
		mov		@R0, RAM_7
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.6, ROM_2801
		lcall	ROM_2610
		jz		ROM_2801
		clr		A
		mov		R0, #RAM_73
		mov		@R0, A

ROM_27ED:					; Fn_33_27C1+3Bj
		mov		R1, #RAM_73
		mov		A, @R1
		clr		C
		mov		R0, #RAM_74
		subb	A, @R0
		jnc		ROM_27FE
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_73
		inc		@R0
		sjmp	ROM_27ED

ROM_27FE:					; Fn_33_27C1+33j
		mov		R7, #3
		ret

ROM_2801:					; Fn_33_27C1+20j Fn_33_27C1+26j
		mov		DPTR, #XRAM_53A
		movx	A, @DPTR
		cjne	A, #1, ROM_2815
		orl		P2MDOUT, #8
		orl		P2, #8
		mov		R7, #0xFB
		mov		R6, #0xFF
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value

ROM_2815:					; Fn_33_27C1+44j
		mov		R0, #RAM_71
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		lcall	ROM_3440
		lcall	ROM_25D0
		jz		ROM_2828
		mov		A, R7
		cjne	A, #0x12, ROM_282D

ROM_2828:					; Fn_33_27C1+61j
		mov		R7, #1
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_282D:					; Fn_33_27C1+64j
		mov		DPTR, #0x57B
		movx	A, @DPTR
		mov		R7, A
		lcall	C2_WriteAR_38F7
		clr		A
		mov		R0, #0x73 ; 's'
		mov		@R0, A

ROM_2839:					; Fn_33_27C1+9Fj
		mov		R1, #0x73 ; 's'
		mov		A, @R1
		clr		C
		mov		R0, #0x74 ; 't'
		subb	A, @R0
		jnc		ROM_2862
		lcall	ROM_1D86
		setb	IE.1
		lcall	GetHostByte_1BB3
		lcall	DataWrite_3897
		clr		IE.1
		lcall	ROM_1D86
		setb	IE.1

ROM_2854:					; Fn_33_27C1+97j
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.7, ROM_2854
		clr		IE.1
		mov		R0, #0x73 ; 's'
		inc		@R0
		sjmp	ROM_2839

ROM_2862:					; Fn_33_27C1+7Fj
		mov		DPTR, #XRAM_53A
		movx	A, @DPTR
		cjne	A, #1, ROM_286C
		lcall	ROM_2624

ROM_286C:					; Fn_33_27C1+A5j
		lcall	ROM_25D0
		jz		ROM_2875
		mov		A, R7
		cjne	A, #0x12, ROM_287A

ROM_2875:					; Fn_33_27C1+AEj
		clr		A
		mov		R7, A
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_287A:					; Fn_33_27C1+B1j
		mov		R7, #RESP_OK
		ret
; End of function Fn_33_27C1


; =============== S U B	R O U T	I N E =======================================


Fn_16_287D:					; CmdExecute_1850:fn_16_19EBp
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x56A
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x566
		lcall	ROM_16F7
		mov		DPTR, #0x56B
		movx	@DPTR, A

ROM_288F:					; Fn_16_287D+35j
		mov		DPTR, #0x56A
		lcall	ROM_174F
		jnc		ROM_28B4
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x56B
		lcall	ROM_172A
		mov		A, #0x66 ; 'f'
		add		A, R5
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		A, #5
		addc	A, R4
		mov		DPH, A			; Data Pointer,	High Byte
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x56B
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_288F

ROM_28B4:					; Fn_16_287D+18j
		mov		DPTR, #0x56A
		movx	A, @DPTR
		mov		R6, A
		setb	C
		subb	A, #4
		jc		ROM_28C1
		mov		R7, #RESP_00
		ret

ROM_28C1:					; Fn_16_287D+3Fj
		mov		DPTR, #0x538
		movx	A, @DPTR
		jnz		ROM_28F0
		mov		A, R6
		clr		C
		subb	A, #2
		jnc		ROM_28D0
		mov		R7, #RESP_00
		ret

ROM_28D0:					; Fn_16_287D+4Ej
		mov		DPTR, #0x568
		movx	A, @DPTR
		mov		DPTR, #0x534
		movx	@DPTR, A
		movx	A, @DPTR
		mov		R7, A
		jz		ROM_28E0
		mov		R6, #2
		sjmp	ROM_28E2

ROM_28E0:					; Fn_16_287D+5Dj
		mov		R6, #1

ROM_28E2:					; Fn_16_287D+61j
		mov		R0, #RAM_A1_LEDS
		mov		@R0, RAM_6
		mov		DPTR, #0x569
		movx	A, @DPTR
		mov		R5, A
		lcall	ROM_2489
		sjmp	ROM_2901

ROM_28F0:					; Fn_16_287D+48j
		mov		DPTR, #0x566
		lcall	Load_R4567_iDPTR
		mov		DPTR, #0x5AE
		movx	A, @DPTR
		mov		DPTR, #XRAM_54B
		movx	@DPTR, A
		lcall	ROM_213C

ROM_2901:					; Fn_16_287D+71j
		mov		R0, #0x79 ; 'y'
		lcall	ROM_211E
		clr		A
		mov		DPTR, #0x56B
		movx	@DPTR, A

ROM_290B:					; Fn_16_287D+AFj
		mov		DPTR, #0x56A
		movx	A, @DPTR
		mov		R7, A
		inc		DPTR
		movx	A, @DPTR
		mov		R6, A
		clr		C
		subb	A, R7
		jnc		ROM_292E
		mov		A, R6
		mov		R5, A
		clr		C
		mov		A, R7
		subb	A, R5
		mov		R7, A
		mov		A, #0x78 ; 'x'
		add		A, R7
		mov		R0, A
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x56B
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_290B

ROM_292E:					; Fn_16_287D+98j
		mov		R7, #RESP_OK
		ret
; End of function Fn_16_287D


; =============== S U B	R O U T	I N E =======================================


Fn_02_2931:					; CmdExecute_1850:fn_02_196Ep
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x58A
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x589
		mov		A, #2
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_90
		mov		@R0, RAM_7
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_2969
		clr		A
		mov		DPTR, #0x588
		movx	@DPTR, A

ROM_2955:					; Fn_02_2931+33j
		mov		DPTR, #0x588
		movx	A, @DPTR
		clr		C
		mov		R0, #RAM_90
		subb	A, @R0
		jnc		ROM_2966
		clr		A
		mov		R7, A
		lcall	ROM_29D7
		sjmp	ROM_2955

ROM_2966:					; Fn_02_2931+2Cj
		mov		R7, #RESP_01
		ret

ROM_2969:					; Fn_02_2931+1Dj
		mov		DPTR, #0x589
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		R0, #RAM_90
		mov		A, @R0
		jnb		ACC.0, ROM_2980
		clr		C
		rrc		A
		inc		A
		mov		R7, A
		sjmp	ROM_2986

ROM_2980:					; Fn_02_2931+46j
		mov		R0, #RAM_90
		mov		A, @R0
		clr		C
		rrc		A
		mov		R7, A

ROM_2986:					; Fn_02_2931+4Dj
		mov		DPTR, #0x587
		mov		A, R7
		movx	@DPTR, A
		mov		R0, #0x92 ; 'í'
		mov		@R0, A
		dec	R0
		mov		@R0, #3
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		lcall	ROM_2F7E
		mov		DPTR, #0x588
		mov		A, #1
		movx	@DPTR, A

ROM_299F:					; Fn_02_2931+80j
		mov		DPTR, #0x587
		lcall	ROM_174F
		jnc		ROM_29B3
		lcall	ROM_29C6
		mov		R0, #0x92 ; 'í'
		mov		A, @R0
		mov		R7, A
		lcall	ROM_29D7
		sjmp	ROM_299F

ROM_29B3:					; Fn_02_2931+74j
		lcall	ROM_29C6
		mov		R0, #RAM_90
		mov		A, @R0
		jb		ACC.0, ROM_29C3
		mov		R0, #0x92 ; 'í'
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4

ROM_29C3:					; Fn_02_2931+88j
		mov		R7, #RESP_OK
		ret
; End of function Fn_02_2931


; =============== S U B	R O U T	I N E =======================================


ROM_29C6:					; Fn_02_2931+76p Fn_02_2931:ROM_29B3p
		lcall	ROM_368B
		mov		R0, #RAM_91
		mov		@R0, RAM_6
		inc		R0
		mov		@R0, RAM_7
		dec	R0
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		ret
; End of function ROM_29C6


; =============== S U B	R O U T	I N E =======================================


ROM_29D7:					; Fn_02_2931+30p Fn_02_2931+7Dp
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x588
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		ret
; End of function ROM_29D7


; =============== S U B	R O U T	I N E =======================================


ROM_29E1:					; ROM_2EBD+39p	ROM_2F08+4p ...
		lcall	ROM_3996
		lcall	ROM_1741
		mov		R3, A

ROM_29E8:					; ROM_29E1+14j
		mov		R0, #RAM_55_Cmd_2
		mov		A, @R0
		mov		R4, A
		mov		A, R3
		clr		C
		subb	A, R4
		jnc		ROM_29F7
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_29E8

ROM_29F7:					; ROM_29E1+Ej
		mov		A, R5
		cjne	A, #1, ROM_2A09
		lcall	ROM_16BE
		mov		RAM_25.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_2A3C
		setb	P2.0
		sjmp	ROM_2A3C

ROM_2A09:					; ROM_29E1+17j
		mov		A, R5
		xrl		A, #2
		jnz		ROM_2A21
		lcall	ROM_16BE
		mov		RAM_25.6, C
		lcall	JTAG_25_1_16A8
		mov		RAM_25.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_2A1F
		setb	P2.0

ROM_2A1F:					; ROM_29E1+3Aj
		sjmp	ROM_2A3C

ROM_2A21:					; ROM_29E1+2Bj
		mov		A, R5
		xrl		A, #3
		jnz		ROM_2A43
		lcall	ROM_16BE
		mov		RAM_25.5, C
		lcall	JTAG_25_1_16A8
		mov		RAM_25.6, C
		lcall	JTAG_25_2_16E2
		mov		RAM_25.7, C
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_2A3C
		setb	P2.0

ROM_2A3C:					; ROM_29E1+22j	ROM_29E1+26j ...
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		mov		R6, RAM_25
		sjmp	ROM_2A6F

ROM_2A43:					; ROM_29E1+43j
		clr		A
		mov		R6, A
		mov		R3, A

ROM_2A46:					; ROM_29E1+8Cj
		mov		A, R3
		clr		C
		subb	A, R5
		jnc		ROM_2A6F
		mov		A, R7
		rrc		A
		mov		P1.4, C
		mov		A, R7
		clr		C
		rrc		A
		mov		R7, A
		mov		A, R6
		clr		C
		rrc		A
		mov		R6, A
		jnb		P1.1, ROM_2A5D
		orl		A, #0x80
		mov		R6, A

ROM_2A5D:					; ROM_29E1+76j
		mov		A, R5
		dec	A
		cjne	A, RAM_3, ROM_2A69
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		jnz		ROM_2A69
		setb	P2.0

ROM_2A69:					; ROM_29E1+7Ej	ROM_29E1+84j
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_2A46

ROM_2A6F:					; ROM_29E1+60j	ROM_29E1+68j
		clr		P1.4
		clr		A
		mov		R3, A

ROM_2A73:					; ROM_29E1+A6j
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		mov		R7, A
		mov		A, R3
		clr		C
		subb	A, R7
		jnc		ROM_2A89
		mov		A, R7
		dec	A
		cjne	A, RAM_3, ROM_2A83
		setb	P2.0

ROM_2A83:					; ROM_29E1+9Dj
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R3
		sjmp	ROM_2A73

ROM_2A89:					; ROM_29E1+99j
		lcall	PulseHigh2_P16_3998
		mov		R7, RAM_6
		ret
; End of function ROM_29E1


; =============== S U B	R O U T	I N E =======================================


Fn_32_2A8F:					; CmdExecute_1850:fn_32_1A72p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_6D
		mov		@R0, #0
		inc		R0
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		A, R7
		mov		R0, #RAM_6D
		orl		A, @R0
		mov		@R0, A
		inc		R0
		mov		A, @R0
		mov		@R0, A
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_70
		mov		@R0, RAM_7
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.6, ROM_2AD1
		lcall	ROM_2610
		jz		ROM_2AD1
		clr		A
		mov		R0, #RAM_6F
		mov		@R0, A

ROM_2ABB:					; Fn_32_2A8F+3Dj
		mov		R1, #RAM_6F
		mov		A, @R1
		clr		C
		mov		R0, #RAM_70
		subb	A, @R0
		jnc		ROM_2ACE
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_6F
		inc		@R0
		sjmp	ROM_2ABB

ROM_2ACE:					; Fn_32_2A8F+33j
		mov		R7, #RESP_03
		ret

ROM_2AD1:					; Fn_32_2A8F+20j Fn_32_2A8F+26j
		mov		R0, #RAM_6D
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		lcall	ROM_3440
		mov		DPTR, #XRAM_539
		movx	A, @DPTR
		xrl		A, #0xF
		jz		ROM_2AF3
		inc		DPTR
		movx	A, @DPTR
		xrl		A, #1
		jz		ROM_2AF3
		mov		R7, #0xB6
		lcall	C2_WriteAR_38F7
		mov		R7, #0x40
		lcall	DataWrite_3897

ROM_2AF3:					; Fn_32_2A8F+52j Fn_32_2A8F+58j
		lcall	ROM_25D0
		jz		ROM_2AFC
		mov		A, R7
		cjne	A, #0x12, ROM_2B01

ROM_2AFC:					; Fn_32_2A8F+67j
		mov		R7, #1
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_2B01:					; Fn_32_2A8F+6Aj
		mov		DPTR, #0x57B
		movx	A, @DPTR
		mov		R7, A
		lcall	C2_WriteAR_38F7
		clr		A
		mov		R0, #RAM_6F
		mov		@R0, A

ROM_2B0D:					; Fn_32_2A8F+97j
		mov		R1, #RAM_6F
		mov		A, @R1
		clr		C
		mov		R0, #RAM_70
		subb	A, @R0
		jnc		ROM_2B28
		lcall	C2_ReadDR_2F1F
		lcall	AddToResponse_1BF4

ROM_2B1C:					; Fn_32_2A8F+91j
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.7, ROM_2B1C
		mov		R0, #RAM_6F
		inc		@R0
		sjmp	ROM_2B0D

ROM_2B28:					; Fn_32_2A8F+85j
		lcall	ROM_25D0
		jz		ROM_2B31
		mov		A, R7
		cjne	A, #0x12, ROM_2B36

ROM_2B31:					; Fn_32_2A8F+9Cj
		clr		A
		mov		R7, A
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_2B36:					; Fn_32_2A8F+9Fj
		mov		R7, #RESP_OK
		ret
; End of function Fn_32_2A8F


; =============== S U B	R O U T	I N E =======================================


Fn_07_2B39:					; CmdExecute_1850:fn_07_1986p
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x55E
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x55D
		mov		A, #2
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x558
		mov		A, R7
		movx	@DPTR, A
		mov		R0, #RAM_A0
		mov		A, @R0
		cjne	A, #1, ROM_2B59
		movx	A, @DPTR
		jnb		ACC.0, ROM_2B83

ROM_2B59:					; Fn_07_2B39+19j
		clr		A
		mov		DPTR, #0x55A
		movx	@DPTR, A

ROM_2B5E:					; Fn_07_2B39+3Bj
		mov		DPTR, #0x558
		movx	A, @DPTR
		mov		R7, A
		mov		DPTR, #0x55A
		movx	A, @DPTR
		clr		C
		subb	A, R7
		jnc		ROM_2B76
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x55A
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_2B5E

ROM_2B76:					; Fn_07_2B39+30j
		mov		DPTR, #0x558
		movx	A, @DPTR
		jnb		ACC.0, ROM_2B80
		mov		R7, #RESP_00
		ret

ROM_2B80:					; Fn_07_2B39+41j
		mov		R7, #RESP_01
		ret

ROM_2B83:					; Fn_07_2B39+1Dj
		mov		DPTR, #0x55D
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		DPTR, #0x558
		movx	A, @DPTR
		clr		C
		rrc		A
		inc		DPTR
		movx	@DPTR, A
		mov		DPTR, #0x55C
		movx	@DPTR, A
		mov		DPTR, #0x55B
		mov		A, #8
		lcall	ROM_1748
		lcall	ROM_2F7E
		clr		A
		mov		DPTR, #0x55A
		movx	@DPTR, A

ROM_2BAA:					; Fn_07_2B39+9Aj
		mov		DPTR, #0x559
		lcall	ROM_174F
		jnc		ROM_2BD5
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x55B
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x55C
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x55B
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		DPTR, #0x55A
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_2BAA

ROM_2BD5:					; Fn_07_2B39+77j
		mov		R7, #RESP_OK
		ret
; End of function Fn_07_2B39


; =============== S U B	R O U T	I N E =======================================


Fn_11_2BD8:					; CmdExecute_1850:fn_11_19C2p
		mov		DPTR, #0x546
		mov		A, #0xD
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x543
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x542
		lcall	ROM_16CE
		lcall	ROM_2489
		lcall	ROM_36C5
		mov		DPTR, #0x542
		movx	A, @DPTR
		jnz		ROM_2C00
		inc		DPTR
		movx	A, @DPTR

ROM_2C00:					; Fn_11_2BD8+24j
		jnz		ROM_2C05
		mov		R7, #RESP_OK
		ret

ROM_2C05:					; Fn_11_2BD8:ROM_2C00j
		clr		A
		mov		DPTR, #0x544
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A

ROM_2C0C:					; Fn_11_2BD8+75j Fn_11_2BD8+7Dj
		mov		DPTR, #0x542
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		clr		C
		mov		DPTR, #0x545
		movx	A, @DPTR
		subb	A, R7
		mov		DPTR, #0x544
		movx	A, @DPTR
		subb	A, R6
		jnc		ROM_2C57
		lcall	ROM_36C5
		mov		DPTR, #0x53E
		lcall	ROM_212A
		mov		DPTR, #0x53F
		movx	A, @DPTR
		anl		A, #0x80
		mov		R7, A
		cjne	R7, #1,	ROM_2C3F
		clr		A
		mov		DPTR, #0x53E
		movx	@DPTR, A
		mov		DPTR, #0x546
		mov		A, #3
		movx	@DPTR, A

ROM_2C3F:					; Fn_11_2BD8+59j
		mov		DPTR, #0x53E
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x545
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		jnz		ROM_2C0C
		mov		DPTR, #0x544
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_2C0C

ROM_2C57:					; Fn_11_2BD8+47j
		mov		DPTR, #0x546
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function Fn_11_2BD8


; =============== S U B	R O U T	I N E =======================================


Fn_2C_2C5D:					; CmdExecute_1850:fn_2C_1A50p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_66
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_65
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_65
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		ROM_2C8F
		clr		A
		mov		R0, #RAM_63
		mov		@R0, A

ROM_2C79:					; Fn_2C_2C5D+2Dj
		mov		R1, #RAM_63
		mov		A, @R1
		clr		C
		mov		R0, #RAM_65
		subb	A, @R0
		jnc		ROM_2C8C
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_63
		inc		@R0
		sjmp	ROM_2C79

ROM_2C8C:					; Fn_2C_2C5D+23j
		mov		R7, #RESP_01
		ret

ROM_2C8F:					; Fn_2C_2C5D+16j
		clr		A
		mov		R0, #RAM_64
		mov		@R0, A

ROM_2C93:					; Fn_2C_2C5D+7Bj
		mov		R1, #RAM_64
		mov		A, @R1
		clr		C
		mov		R0, #RAM_65
		subb	A, @R0
		jnc		ROM_2CDA
		mov		R7, #9
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_67
		mov		A, R7
		mov		@R0, A
		xrl		A, #0xD
		jz		ROM_2CC3
		clr		A
		mov		R0, #RAM_63
		mov		@R0, A

ROM_2CB0:					; Fn_2C_2C5D+64j
		mov		R1, #RAM_63
		mov		A, @R1
		clr		C
		mov		R0, #RAM_65
		subb	A, @R0
		jnc		ROM_2CDA
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_63
		inc		@R0
		sjmp	ROM_2CB0

ROM_2CC3:					; Fn_2C_2C5D+4Dj
		mov		R0, #RAM_66
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #1
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_64
		inc		@R0
		sjmp	ROM_2C93

ROM_2CDA:					; Fn_2C_2C5D+3Dj Fn_2C_2C5D+5Aj
		mov		R0, #RAM_67
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_2C_2C5D


; =============== S U B	R O U T	I N E =======================================


Fn_34_2CDF:					; CmdExecute_1850:fn_34_1A7Cp
		mov		R7, #2
		lcall	C2_WriteAR_38F7
		mov		R7, #2
		lcall	DataWrite_3897
		mov		R7, #5
		lcall	DataWrite_3897		;
						; .
		clr		A
		mov		R7, A
		lcall	C2_WriteAR_38F7
		lcall	C2_ReadDR_2F1F
		mov		DPTR, #XRAM_539
		mov		A, R7
		movx	@DPTR, A
		lcall	Set_Target_3141		;
						; .
		mov		R7, #0xD9
		lcall	C2_WriteAR_38F7
		clr		A
		mov		R7, A
		lcall	DataWrite_3897		;
						; .
		mov		R7, #0xB7
		lcall	C2_WriteAR_38F7
		mov		R7, #0xA5
		lcall	DataWrite_3897
		mov		R7, #0xF1
		lcall	DataWrite_3897		;
						; .
		lcall	ROM_25D0
		jz		ROM_2D20
		mov		A, R7
		cjne	A, #0x12, ROM_2D25

ROM_2D20:					; Fn_34_2CDF+3Bj
		mov		R7, #RESP_01
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_2D25:					; Fn_34_2CDF+3Ej
		mov		R7, #0xDF
		lcall	C2_WriteAR_38F7
		mov		R7, #0xAD
		lcall	DataWrite_3897
		lcall	ROM_25D0
		jz		ROM_2D38
		mov		A, R7
		cjne	A, #0x12, ROM_2D3D

ROM_2D38:					; Fn_34_2CDF+53j
		clr		A
		mov		R7, A
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_2D3D:					; Fn_34_2CDF+56j Fn_34_2CDF+62j
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.7, ROM_2D3D
		mov		DPTR, #XRAM_534
		mov		A, #5
		movx	@DPTR, A
		lcall	Set_Connected_25DD
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.6, ROM_2D5C
		lcall	ROM_2610
		jz		ROM_2D5C
		mov		R7, #RESP_03
		ret

ROM_2D5C:					; Fn_34_2CDF+72j Fn_34_2CDF+78j
		mov		R7, #RESP_OK
		ret
; End of function Fn_34_2CDF


; =============== S U B	R O U T	I N E =======================================

; Write	XDATA F35x
; 2D 84	00 len [data]

Fn_2D_2D5F:					; CmdExecute_1850:fn_2D_1A55p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_6B
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_6A
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_6A
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		ROM_2D8F
		clr		A
		mov		R0, #RAM_68
		mov		@R0, A

ROM_2D7B:					; Fn_2D_2D5F+2Bj
		mov		R1, #RAM_68
		mov		A, @R1
		clr		C
		mov		R0, #RAM_6A
		subb	A, @R0
		jnc		ROM_2D8C
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_68
		inc		@R0
		sjmp	ROM_2D7B

ROM_2D8C:					; Fn_2D_2D5F+23j
		mov		R7, #RESP_01
		ret

ROM_2D8F:					; Fn_2D_2D5F+16j
		clr		A
		mov		R0, #RAM_69
		mov		@R0, A

ROM_2D93:					; Fn_2D_2D5F+77j
		mov		R1, #RAM_69
		mov		A, @R1
		clr		C
		mov		R0, #RAM_6A
		subb	A, @R0
		jnc		ROM_2DD8
		mov		R7, #0xA
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_6C
		mov		A, R7
		mov		@R0, A
		xrl		A, #RESP_OK
		jz		ROM_2DC1
		clr		A
		mov		R0, #RAM_68
		mov		@R0, A

ROM_2DB0:					; Fn_2D_2D5F+60j
		mov		R1, #RAM_68
		mov		A, @R1
		clr		C
		mov		R0, #RAM_6A
		subb	A, @R0
		jnc		ROM_2DD8
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_68
		inc		@R0
		sjmp	ROM_2DB0

ROM_2DC1:					; Fn_2D_2D5F+4Bj
		mov		R0, #RAM_6B
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #1
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	GetHostByte_1BB3
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R0, #RAM_69
		inc		@R0
		sjmp	ROM_2D93

ROM_2DD8:					; Fn_2D_2D5F+3Bj Fn_2D_2D5F+58j
		mov		R0, #RAM_6C
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_2D_2D5F


; =============== S U B	R O U T	I N E =======================================


ROM_2DDD:					; Fn_0D_1785+64p
		lcall	ROM_177B
		lcall	ROM_2489
		mov		DPTR, #0x571
		movx	A, @DPTR
		mov		R5, A
		cjne	A, #8, ROM_2DF0
		mov		DPTR, #0x56F
		sjmp	ROM_2DF7

ROM_2DF0:					; ROM_2DDD+Bj
		mov		A, R5
		cjne	A, #0x10, ROM_2DFD
		mov		DPTR, #0x56E

ROM_2DF7:					; ROM_2DDD+11j
		movx	A, @DPTR
		orl		A, #3
		movx	@DPTR, A
		sjmp	ROM_2E44

ROM_2DFD:					; ROM_2DDD+14j
		mov		DPTR, #0x571
		movx	A, @DPTR
		cjne	A, #0x11, ROM_2E0D
		mov		DPTR, #0x56E
		movx	A, @DPTR
		orl		A, #6
		movx	@DPTR, A
		sjmp	ROM_2E44

ROM_2E0D:					; ROM_2DDD+24j
		mov		DPTR, #0x56D
		movx	A, @DPTR
		mov		R0, A
		inc		DPTR
		movx	A, @DPTR
		mov		R1, A
		inc		DPTR
		movx	A, @DPTR
		mov		R2, A
		inc		DPTR
		movx	A, @DPTR
		mov		R3, A
		push	RAM_0
		push	RAM_1
		clr		A
		mov		R7, #3
		mov		R6, A
		mov		R5, A
		mov		R4, A
		mov		DPTR, #0x571
		movx	A, @DPTR
		mov		R1, A
		mov		R0, A
		lcall	ROM_20FF
		pop	RAM_1
		pop	RAM_0
		mov		A, R3
		orl		A, R7
		mov		R7, A
		mov		A, R2
		orl		A, R6
		mov		R6, A
		mov		A, R1
		orl		A, R5
		mov		R5, A
		mov		A, R0
		orl		A, R4
		mov		R4, A
		mov		DPTR, #0x56D
		lcall	ROM_212A

ROM_2E44:					; ROM_2DDD+1Ej	ROM_2DDD+2Ej
		mov		DPTR, #0x571
		movx	A, @DPTR
		add		A, #2
		mov		DPTR, #XRAM_54B
		movx	@DPTR, A
		mov		DPTR, #0x56D
		lcall	Load_R4567_iDPTR
		lcall	ROM_213C
		lcall	ROM_3401
		ret
; End of function ROM_2DDD


; =============== S U B	R O U T	I N E =======================================


Fn_19_2E5B:					; CmdExecute_1850:fn_19_19F7p
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_93
		mov		A, R7
		mov		@R0, A
		jnz		ROM_2E73
		mov		R7, A
		lcall	AddToResponse_1BF4
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_02
		ret

ROM_2E73:					; Fn_19_2E5B+Aj
		clr		A
		mov		R0, #RAM_94
		mov		@R0, A
		inc		R0
		mov		@R0, A
		mov		R5, A

while_2E7A:					; Fn_19_2E5B+4Fj
		mov		R0, #RAM_93
		mov		A, @R0
		mov		R7, A
		mov		A, R5
		clr		C
		subb	A, R7
		jnc		done_2EAC
		jb		P1.6, ROM_2E98		; CPIN_OUT
		setb	P1.6
		inc		R0
		lcall	ShiftRightWord_1716
		jnb		P0.0, ROM_2E94		; Port 0
		dec	R0
		mov		A, @R0
		orl		A, #0x80
		mov		@R0, A

ROM_2E94:					; Fn_19_2E5B+31j
		clr		P1.6			; CPIN_OUT
		sjmp	next_2EA9

ROM_2E98:					; Fn_19_2E5B+28j
		clr		P1.6			; CPIN_OUT
		setb	P1.6
		mov		R0, #RAM_94
		lcall	ShiftRightWord_1716
		jnb		P0.0, next_2EA9		; APIN_IN
		dec	R0
		mov		A, @R0
		orl		A, #0x80
		mov		@R0, A

next_2EA9:					; Fn_19_2E5B+3Bj Fn_19_2E5B+46j
		inc		R5
		sjmp	while_2E7A

done_2EAC:					; Fn_19_2E5B+26j
		mov		R0, #RAM_95
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_94
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_19_2E5B


; =============== S U B	R O U T	I N E =======================================


ROM_2EBD:					; Fn_12_2FDD+3Cp Fn_0F_390B+Cp
		mov		DPTR, #0x582
		mov		A, R7
		movx	@DPTR, A

ROM_2EC2:					; ROM_2EBD+9j
		lcall	ROM_2F08
		movx	A, @DPTR
		jb		ACC.7, ROM_2EC2
		clr		A
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A
		inc		DPTR
		mov		A, #3
		movx	@DPTR, A
		mov		DPTR, #0x582
		movx	A, @DPTR
		mov		DPTR, #0x586
		movx	@DPTR, A
		mov		DPTR, #0x583
		lcall	Load_R4567_iDPTR
		mov		DPTR, #XRAM_54B
		mov		A, #0xA
		movx	@DPTR, A
		lcall	ROM_213C
		lcall	ROM_3401

ROM_2EEB:					; ROM_2EBD+32j
		lcall	ROM_2F08
		movx	A, @DPTR
		jb		ACC.7, ROM_2EEB
		mov		R5, #3
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		DPTR, #0x583
		lcall	ROM_1756
		jnb		ACC.7, ROM_2F05
		mov		R7, #RESP_03
		ret

ROM_2F05:					; ROM_2EBD+42j
		mov		R7, #RESP_OK
		ret
; End of function ROM_2EBD


; =============== S U B	R O U T	I N E =======================================


ROM_2F08:					; ROM_2EBD:ROM_2EC2p ROM_2EBD:ROM_2EEBp
		mov		R5, #2
		mov		R7, #2
		lcall	ROM_29E1
		lcall	ROM_3401
		mov		R5, #2
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		DPTR, #0x583
		mov		A, R7
		movx	@DPTR, A
		ret
; End of function ROM_2F08


; =============== S U B	R O U T	I N E =======================================


C2_ReadDR_2F1F:					; Fn_32_2A8F+87p Fn_34_2CDF+14p ...
		lcall	Pulse_Low_P14_25C7
		clr		P0.3			; Port 0
		orl		P1MDOUT, #0x40
		clr		P1.6
		lcall	Pulse_Low_P14_25C7
		lcall	Pulse_Low_P14_25C7
		lcall	Pulse_Low_P14_25C7
		lcall	Pulse_Low_P14_25C7
		clr		P1.6
		lcall	SetIn_P16_25EE

ROM_2F3A:					; C2_ReadDR_2F1F+1Ej
		lcall	Pulse_Low_P14_25C7
		jnb		P1.5, ROM_2F3A
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.0, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.1, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.2, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.3, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.4, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.5, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.6, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.7, C
		lcall	Pulse_Low_P14_25C7
		mov		R7, RAM_20
		ret
; End of function C2_ReadDR_2F1F


; =============== S U B	R O U T	I N E =======================================


ROM_2F7E:					; Fn_06_23B1+51p Fn_06_23B1+7Dp ...
		mov		DPTR, #0x572
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		lcall	ROM_1722
		lcall	ROM_2489

ROM_2F8C:					; ROM_2F7E+1Dj
		lcall	ROM_33FA
		inc		R5
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		DPTR, #XRAM_574
		lcall	ROM_1756
		jb		ACC.7, ROM_2F8C
		mov		DPTR, #0x572
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		clr		A
		mov		R4, A
		mov		R5, A
		inc		DPTR
		lcall	ROM_212A
		mov		DPTR, #XRAM_574
		lcall	Load_R4567_iDPTR
		mov		R0, #2
		lcall	ROM_20FF
		mov		A, R7
		orl		A, #2
		mov		R7, A
		mov		A, R4
		mov		DPTR, #XRAM_574
		lcall	ROM_212A
		mov		DPTR, #XRAM_575
		movx	A, @DPTR
		orl		A, #0xC
		movx	@DPTR, A
		mov		DPTR, #XRAM_574
		lcall	Load_R4567_iDPTR
		mov		DPTR, #XRAM_54B
		mov		A, #0x14
		movx	@DPTR, A
		lcall	ROM_213C
		lcall	ROM_3401
		ret
; End of function ROM_2F7E


; =============== S U B	R O U T	I N E =======================================


Fn_12_2FDD:					; CmdExecute_1850:fn_12_19C8p
		mov		DPTR, #0x581
		mov		A, #0xD
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x57E
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x57D
		lcall	ROM_16CE
		lcall	ROM_2489
		clr		A
		mov		DPTR, #0x57F
		movx	@DPTR, A
		inc		DPTR
		movx	@DPTR, A

ROM_3001:					; Fn_12_2FDD+4Ej Fn_12_2FDD+56j
		mov		DPTR, #0x57D
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		clr		C
		mov		DPTR, #0x580
		movx	A, @DPTR
		subb	A, R7
		mov		DPTR, #0x57F
		movx	A, @DPTR
		subb	A, R6
		jnc		ROM_3035
		lcall	GetHostByte_1BB3
		lcall	ROM_2EBD
		cjne	R7, #3,	ROM_3025
		mov		DPTR, #0x581
		mov		A, #3
		movx	@DPTR, A

ROM_3025:					; Fn_12_2FDD+3Fj
		mov		DPTR, #0x580
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		jnz		ROM_3001
		mov		DPTR, #0x57F
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_3001

ROM_3035:					; Fn_12_2FDD+37j
		mov		DPTR, #0x581
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function Fn_12_2FDD


; =============== S U B	R O U T	I N E =======================================


Fn_0A_303B:					; CmdExecute_1850:fn_0A_1998p
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x534
		movx	A, @DPTR
		mov		R7, A
		mov		R5, #4
		lcall	ROM_2489
		mov		A, #0x20 ; ' '
		lcall	Clr_i54B_R7654
		lcall	ROM_213C
		mov		R0, #0x7D ; '}'
		lcall	ROM_211E
		mov		R0, #0x80 ; 'Ä'
		mov		A, @R0
		clr		C
		rrc		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #0x7F ; ''
		mov		A, @R0
		anl		A, #0xF
		clr		C
		rrc		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #0x7D ; '}'
		lcall	ROM_2112
		mov		R0, #4
		lcall	ROM_20EC
		mov		R0, #0x7D ; '}'
		lcall	ROM_211E
		mov		R0, #0x7F ; ''
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #0x7E ; '~'
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R0, #0x7D ; '}'
		mov		A, @R0
		anl		A, #0xF
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #0xC
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_0A_303B


; =============== S U B	R O U T	I N E =======================================


Fn_35_3097:					; CmdExecute_1850:fn_35_1A81p
		lcall	GetHostByte_1BB3
		mov		A, R7
		mov		R0, A
		clr		A
		mov		R1, #0x9B ; 'õ'
		mov		@R1, A
		mov		A, R0
		add		A, ACC
		dec	R1
		mov		@R1, A
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.6, ROM_30B4
		lcall	ROM_2610
		jz		ROM_30B4
		mov		R7, #RESP_03
		ret

ROM_30B4:					; Fn_35_3097+12j Fn_35_3097+18j
		mov		R0, #0x9A ; 'ö'
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		lcall	ROM_3440
		lcall	ROM_25D0
		jz		ROM_30C7
		mov		A, R7
		cjne	A, #0x12, ROM_30CC

ROM_30C7:					; Fn_35_3097+2Aj
		mov		R7, #1
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_30CC:					; Fn_35_3097+2Dj
		mov		R7, #0xDF
		lcall	C2_WriteAR_38F7
		mov		R7, #0xDE
		lcall	DataWrite_3897
		lcall	ROM_25D0
		jz		ROM_30DF
		mov		A, R7
		cjne	A, #0x12, ROM_30E4

ROM_30DF:					; Fn_35_3097+42j
		clr		A
		mov		R7, A
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_30E4:					; Fn_35_3097+45j Fn_35_3097+51j
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.7, ROM_30E4
		mov		R7, #RESP_OK
		ret
; End of function Fn_35_3097


; =============== S U B	R O U T	I N E =======================================


AddressRead_30EE:				; Fn_33_27C1+1Cp Fn_33_27C1:ROM_2854p	...
		lcall	Pulse_Low_P14_25C7
		clr		P1.6
		clr		P0.3			; Port 0
		orl		P1MDOUT, #0x40
		lcall	Pulse_Low_P14_25C7
		setb	P1.6
		lcall	Pulse_Low_P14_25C7
		lcall	SetIn_P16_25EE
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.0, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.1, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.2, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.3, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.4, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.5, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.6, C
		lcall	Pulse_Low_P14_25C7
		mov		C, P1.5
		mov		RAM_20.7, C
		lcall	Pulse_Low_P14_25C7
		mov		R7, RAM_20
		ret
; End of function AddressRead_30EE


; =============== S U B	R O U T	I N E =======================================


Set_Target_3141:				; Fn_34_2CDF+1Cp Fn_20_32D1+44p
		clr		A
		mov		DPTR, #XRAM_53A
		movx	@DPTR, A
		mov		DPTR, #XRAM_539
		movx	A, @DPTR
		mov		R7, A
		cjne	A, #0xF, ROM_3163
		mov		A, #0xB6		; DeviceID = 0xF
		lcall	ROM_2617
		mov		A, #0xB5
		movx	@DPTR, A
		mov		DPTR, #C2_FPDAT_57A
		mov		A, #0xAD
		movx	@DPTR, A
		mov		DPTR, #XRAM_57C
		mov		A, #0xBF
		movx	@DPTR, A
		ret

ROM_3163:					; Set_Target_3141+Aj
		mov		A, #0xAE		; DeviceID = 0xB
		lcall	ROM_2617
		mov		A, #0xBF
		movx	@DPTR, A
		mov		DPTR, #C2_FPDAT_57A
		mov		A, #0xB4
		movx	@DPTR, A
		mov		DPTR, #XRAM_57C
		mov		A, #0xA7
		movx	@DPTR, A
		mov		A, R7
		cjne	A, #0xB, ROM_317E
		mov		A, #0x97
		movx	@DPTR, A

ROM_317E:					; Set_Target_3141+37j
		mov		DPTR, #XRAM_539
		movx	A, @DPTR
		mov		R7, A
		xrl		A, #0x10
		jz		ROM_318B
		mov		A, R7
		cjne	A, #0x13, ROM_3191

ROM_318B:					; Set_Target_3141+44j
		mov		DPTR, #XRAM_53A		; DeviceID = 10, 13
		mov		A, #1
		movx	@DPTR, A

ROM_3191:					; Set_Target_3141+47j
		ret
; End of function Set_Target_3141


; =============== S U B	R O U T	I N E =======================================


INT0_0_0:
		push	ACC
		push	B
		push	DPH			; Data Pointer,	High Byte
		push	DPL			; Data Pointer,	Low Byte
		push	FSR_86
		mov		FSR_86,	#0
		push	PSW
		mov		PSW, #0
		push	RAM_0
		push	RAM_1
		push	RAM_2
		push	RAM_3
		push	RAM_4
		push	RAM_5
		push	RAM_6
		push	RAM_7
		clr		IE.0
		lcall	ROM_1D86

ROM_31B9:					; INT0_0_0+2Aj
		jb		P0.0, ROM_31C2		; Port 0
		jnb		TCON.5,	ROM_31B9
		anl		TCON, #0xCF

ROM_31C2:					; INT0_0_0:ROM_31B9j
		lcall	ROM_25D8
		pop	RAM_7
		pop	RAM_6
		pop	RAM_5
		pop	RAM_4
		pop	RAM_3
		pop	RAM_2
		pop	RAM_1
		pop	RAM_0
		pop	PSW
		pop	FSR_86
		pop	DPL			; Data Pointer,	Low Byte
		pop	DPH			; Data Pointer,	High Byte
		pop	B
		pop	ACC
		reti
; End of function INT0_0_0


; =============== S U B	R O U T	I N E =======================================


Fn_08_31E2:					; CmdExecute_1850:fn_08_198Cp
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x59F
		mov		A, R7
		movx	@DPTR, A
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_3201
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_01
		ret

ROM_3201:					; Fn_08_31E2+10j
		mov		DPTR, #0x59F
		movx	A, @DPTR
		mov		DPTR, #0x5A1
		movx	@DPTR, A
		mov		DPTR, #0x5A0
		mov		A, #9
		lcall	ROM_1748
		lcall	ROM_2F7E
		lcall	ROM_368B
		mov		DPTR, #0x5A0
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x5A0
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #0x5A1
		movx	A, @DPTR
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_08_31E2


; =============== S U B	R O U T	I N E =======================================


Fn_0C_3232:					; CmdExecute_1850:fn_0C_19A4p
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_5A8
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		R6, RAM_7
		mov		A, R6
		jz		ROM_324A
		setb	C
		subb	A, #0x18
		jc		ROM_324D

ROM_324A:					; Fn_0C_3232+11j
		mov		R7, #0
		ret

ROM_324D:					; Fn_0C_3232+16j
		mov		DPTR, #XRAM_5A8
		movx	A, @DPTR
		mov		R7, A
		mov		R5, RAM_6
		lcall	ROM_3612
		mov		R0, #0x81 ; 'Å'
		lcall	ROM_211E
		clr		A
		mov		DPTR, #XRAM_5A9
		movx	@DPTR, A

ROM_3261:					; Fn_0C_3232+4Bj
		mov		DPTR, #XRAM_5A9
		movx	A, @DPTR
		mov		R7, A
		clr		C
		subb	A, #3
		jnc		ROM_327F
		clr		C
		mov		A, #2
		subb	A, R7
		add		A, #0x81 ; 'Å'
		mov		R0, A
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #XRAM_5A9
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	ROM_3261

ROM_327F:					; Fn_0C_3232+37j
		mov		R7, #RESP_OK
		ret
; End of function Fn_0C_3232


; =============== S U B	R O U T	I N E =======================================

; Device Unique	ID

Fn_23_3282:					; CmdExecute_1850:fn_23_1A15p
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_328F
		lcall	Add_00_Response_32BB
		mov		R7, #1
		ret

ROM_328F:					; Fn_23_3282+5j
		mov		R7, #1
		lcall	Write_R7_FDAT_Read_FDAT_32C6
		cjne	R7, #RESP_OK, ROM_329F
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		lcall	AddToResponse_1BF4
		sjmp	ROM_32A4

ROM_329F:					; Fn_23_3282+12j
		lcall	Add_00_Response_32BB
		sjmp	ROM_32B6

ROM_32A4:					; Fn_23_3282+1Bj
		mov		R7, #2
		lcall	Write_R7_FDAT_Read_FDAT_32C6
		cjne	R7, #RESP_OK, ROM_32B1
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		sjmp	ROM_32B3

ROM_32B1:					; Fn_23_3282+27j
		clr		A
		mov		R7, A

ROM_32B3:					; Fn_23_3282+2Dj
		lcall	AddToResponse_1BF4

ROM_32B6:					; Fn_23_3282+20j
		mov		R0, #RAM_26
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_23_3282


; =============== S U B	R O U T	I N E =======================================


Add_00_Response_32BB:				; Fn_23_3282+7p Fn_23_3282:ROM_329Fp
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		ret
; End of function Add_00_Response_32BB


; =============== S U B	R O U T	I N E =======================================


Write_R7_FDAT_Read_FDAT_32C6:			; Fn_23_3282+Fp Fn_23_3282+24p
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_26
		mov		A, R7
		mov		@R0, A
		ret
; End of function Write_R7_FDAT_Read_FDAT_32C6


; =============== S U B	R O U T	I N E =======================================

; Connect Target

Fn_20_32D1:					; CmdExecute_1850:fn_20_1A03p
		lcall	C2_Reset_393A
		mov		DPTR, #XRAM_534
		mov		A, #2
		movx	@DPTR, A
		mov		R7, A
		lcall	C2_WriteAR_38F7		; Address = 2
		mov		DPTR, #XRAM_534
		movx	A, @DPTR
		mov		R7, A
		lcall	DataWrite_3897		; Data = 2
		mov		DPTR, #XRAM_534
		mov		A, #4
		movx	@DPTR, A
		mov		R7, A
		lcall	DataWrite_3897		; Data = 4
		mov		R7, #0xF4
		mov		R6, #0xFF
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		mov		DPTR, #XRAM_534
		mov		A, #1
		movx	@DPTR, A
		mov		R7, A
		lcall	DataWrite_3897		; Data = 1
		mov		R7, #0xF0		; 20 mS
		mov		R6, #0xD8
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		clr		A
		mov		R7, A
		lcall	C2_WriteAR_38F7		; Address = 0
		lcall	C2_ReadDR_2F1F		; Data Read
		mov		DPTR, #XRAM_539		; DeviceID
		mov		A, R7
		movx	@DPTR, A
		lcall	Set_Target_3141
		lcall	Set_Connected_25DD
		mov		R7, #RESP_OK
		ret
; End of function Fn_20_32D1


; =============== S U B	R O U T	I N E =======================================


Fn_0B_331E:					; CmdExecute_1850:fn_0B_199Ep
		mov		DPTR, #0x593
		lcall	ROM_16F7
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x534
		mov		A, R7
		movx	@DPTR, A
		jz		ROM_3335
		mov		R0, #RAM_A0
		mov		@R0, #1

ROM_3335:					; Fn_0B_331E+11j
		lcall	GetHostByte_1BB3
		mov		R0, #0xA8 ; '®'
		mov		A, R7
		mov		@R0, A
		mov		DPTR, #0x534
		movx	A, @DPTR
		swap	A
		anl		A, #0xF0
		mov		R6, A
		movx	@DPTR, A
		mov		A, R7
		anl		A, #3
		add		A, ACC
		add		A, ACC
		mov		@R0, A
		orl		A, R6
		movx	@DPTR, A
		jz		ROM_3355
		mov		R7, #2
		sjmp	ROM_3357

ROM_3355:					; Fn_0B_331E+31j
		mov		R7, #1

ROM_3357:					; Fn_0B_331E+35j
		mov		R0, #RAM_A1_LEDS
		mov		@R0, RAM_7
		mov		DPTR, #0x534
		movx	A, @DPTR
		mov		R7, A
		mov		R5, #4
		lcall	ROM_2489
		mov		R7, #RESP_OK
		ret
; End of function Fn_0B_331E


; =============== S U B	R O U T	I N E =======================================


ROM_3368:					; MeasureADC_1B0A+22p 1CFAp
		mov		DPTR, #0x53B
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		mov		R5, A
		mov		R4, RAM_6
		clr		A
		lcall	ROM_1F2E
		mov		R3, #0x33 ; '3'
		mov		R2, #0x33 ; '3'
		mov		R1, #0xB3 ; '≥'
		mov		R0, #0x40 ; '@'
		lcall	ROM_1E8C
		mov		R0, RAM_4
		mov		R1, RAM_5
		mov		R2, RAM_6
		mov		R3, RAM_7
		clr		A
		mov		R7, A
		mov		R6, A
		mov		R5, #0x7F ; ''
		mov		R4, #0x43 ; 'C'
		lcall	ROM_1D94
		lcall	ROM_1F67
		mov		DPTR, #XRAM_53D
		mov		A, R7
		movx	@DPTR, A
		ret
; End of function ROM_3368


; =============== S U B	R O U T	I N E =======================================


ROM_339D:					; CmdExecute_1850+35p MeasureADC_1B0A+2Ep
		clr		P0.4			; DPIN_OUT = 0
		orl		P2MDOUT, #1		; DPIN_OE Push output
		clr		P2.1			; APIN_OE = 0
		orl		P1MDOUT, #0x10		; APIN_OE Push output
		ret
; End of function ROM_339D


; =============== S U B	R O U T	I N E =======================================


Inc_RAM_EF_R67_33A8:				; CmdInit_39D0:ROM_1816p AddToResponse_1BF4:ROM_1C09p
		mov		A, RAM_F
		add		A, #1
		mov		R7, A
		clr		A
		addc	A, RAM_E
		mov		R6, A
		ret
; End of function Inc_RAM_EF_R67_33A8


; =============== S U B	R O U T	I N E =======================================


Fn_31_33B2:					; CmdExecute_1850:fn_31_1A6Dp
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_98
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		ROM_33C9
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_01
		ret

ROM_33C9:					; Fn_31_33B2+8j
		mov		R7, #5
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_99
		mov		A, R7
		mov		@R0, A
		xrl		A, #RESP_OK
		jz		ROM_33E2
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		clr		A
		mov		R7, A
		sjmp	ROM_33F2

ROM_33E2:					; Fn_31_33B2+25j
		mov		R0, #RAM_98
		mov		A, @R0
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		lcall	AddToResponse_1BF4
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead

ROM_33F2:					; Fn_31_33B2+2Ej
		lcall	AddToResponse_1BF4
		mov		R0, #RAM_99
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_31_33B2


; =============== S U B	R O U T	I N E =======================================


ROM_33FA:					; ROM_2F7E:ROM_2F8Cp ROM_368B:ROM_3691p
		mov		R5, #2
		mov		R7, #2
		lcall	ROM_29E1
; End of function ROM_33FA


; =============== S U B	R O U T	I N E =======================================


ROM_3401:					; ROM_1756+2p ROM_2DDD+7Ap ...
		lcall	ROM_3996
		lcall	ROM_1741
		mov		R7, A

ROM_3408:					; ROM_3401+14j
		mov		R0, #RAM_55_Cmd_2
		mov		A, @R0
		mov		R6, A
		mov		A, R7
		clr		C
		subb	A, R6
		jnc		ROM_3417
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R7
		sjmp	ROM_3408

ROM_3417:					; ROM_3401+Ej
		lcall	ROM_1702
		jnz		ROM_341E
		setb	P2.0

ROM_341E:					; ROM_3401+19j
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		clr		A
		mov		R7, A

ROM_3423:					; ROM_3401+36j
		mov		R0, #RAM_58_AppEntry_L
		mov		A, @R0
		mov		R6, A
		mov		A, R7
		clr		C
		subb	A, R6
		jnc		ROM_3439
		mov		A, R6
		dec	A
		cjne	A, RAM_7, ROM_3433
		setb	P2.0

ROM_3433:					; ROM_3401+2Dj
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		inc		R7
		sjmp	ROM_3423

ROM_3439:					; ROM_3401+29j
		lcall	PulseHigh2_P16_3998
		jb		RAM_21.7, ROM_3401
		ret
; End of function ROM_3401


; =============== S U B	R O U T	I N E =======================================


ROM_3440:					; Fn_33_27C1+5Bp Fn_32_2A8F+49p ...
		mov		DPTR, #0x5A6
		mov		A, R6
		movx	@DPTR, A
		inc		DPTR
		mov		A, R7
		movx	@DPTR, A
		lcall	ROM_25D0
		jz		ROM_3451
		mov		A, R7
		cjne	A, #0x12, ROM_3456

ROM_3451:					; ROM_3440+Bj
		mov		R7, #1
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_3456:					; ROM_3440+Ej
		mov		DPTR, #0x579
		movx	A, @DPTR
		mov		R7, A
		lcall	C2_WriteAR_38F7
		mov		DPTR, #0x5A7
		movx	A, @DPTR
		mov		R7, A
		lcall	DataWrite_3897
		mov		DPTR, #0x578
		movx	A, @DPTR
		mov		R7, A
		lcall	C2_WriteAR_38F7
		mov		DPTR, #0x5A6
		movx	A, @DPTR
		mov		R7, A
		lcall	DataWrite_3897
		lcall	ROM_25D0
		jz		ROM_347F
		mov		A, R7
		cjne	A, #0x12, ROM_3484

ROM_347F:					; ROM_3440+39j
		clr		A
		mov		R7, A
		lcall	DataWrite_i57C_17EF	; Write	R7 to Address @57C

ROM_3484:					; ROM_3440+3Cj
		ret
; End of function ROM_3440


; =============== S U B	R O U T	I N E =======================================

; Special Write	to SFR:	37 sfr count [values] sfr_value

Fn_37_3485:					; CmdExecute_1850:fn_37_1A8Bp
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_8D
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_8F
		mov		A, R7
		mov		@R0, A
		setb	C
		subb	A, #1
		jc		write_34B5
		clr		A
		mov		DPTR, #XRAM_5AD
		movx	@DPTR, A

skip_349D:					; Fn_37_3485+2Bj
		mov		DPTR, #XRAM_5AD
		movx	A, @DPTR
		clr		C
		mov		R0, #RAM_8F
		subb	A, @R0
		jnc		error_34B2
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_5AD
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	skip_349D

error_34B2:					; Fn_37_3485+20j
		mov		R7, #RESP_00
		ret

write_34B5:					; Fn_37_3485+11j
		mov		R0, #RAM_8D
		mov		A, @R0
		mov		R7, A
		lcall	C2_WriteAR_38F7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_8E
		mov		A, R7
		mov		@R0, A
		lcall	DataWrite_3897
		mov		R7, #RESP_OK
		ret
; End of function Fn_37_3485


; =============== S U B	R O U T	I N E =======================================


Fn_18_34C9:					; CmdExecute_1850:fn_18_19F1p
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_A7
		mov		A, R7
		mov		@R0, A
		rrc		A
		mov		P1.6, C
		mov		A, R7
		mov		C, ACC.1
		mov		P2.0, C
		mov		C, ACC.2
		mov		P1.4, C
		jnb		ACC.7, ROM_34EB
		lcall	ROM_16B2
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #1
		sjmp	ROM_34F9

ROM_34EB:					; Fn_18_34C9+16j
		mov		R0, #RAM_A0
		mov		@R0, #1
		lcall	ROM_16B6
		orl		A, #0x10
		movx	@DPTR, A
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #2

ROM_34F9:					; Fn_18_34C9+20j
		jnb		P1.1, ROM_3500
		mov		R7, #RESP_01
		sjmp	ROM_3502

ROM_3500:					; Fn_18_34C9:ROM_34F9j
		mov		R7, #RESP_00

ROM_3502:					; Fn_18_34C9+35j
		mov		R0, #RAM_A7
		mov		A, R7
		mov		@R0, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_18_34C9


; =============== S U B	R O U T	I N E =======================================


Fn_25_350C:					; CmdExecute_1850:fn_25_1A21p
		clr		IE.0
		mov		R0, #RAM_A0
		mov		A, @R0
		cjne	A, #1, ROM_3517
		mov		R7, #RESP_OK
		ret

ROM_3517:					; Fn_25_350C+5j
		anl		EIE1, #0xFD
		lcall	ROM_2607
		jnb		P0.0, ROM_352A		; Port 0
		jb		TCON.1,	ROM_352A
		clr		P2.1
		orl		P1MDOUT, #0x10
		clr		P1.4

ROM_352A:					; Fn_25_350C+11j Fn_25_350C+14j
		setb	P1.4
		lcall	ROM_2607
		orl		EIE1, #2
		lcall	ROM_1D86

ROM_3535:					; Fn_25_350C+2Cj
		jb		P0.0, ROM_3541		; Port 0
		jnb		TCON.5,	ROM_3535
		anl		TCON, #0xCF
		mov		R7, #RESP_02
		ret

ROM_3541:					; Fn_25_350C:ROM_3535j
		mov		R7, #0xF0
		mov		R6, #0xD8
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		lcall	ROM_25D8
		mov		R7, #RESP_OK
		ret
; End of function Fn_25_350C


; =============== S U B	R O U T	I N E =======================================

; Special Read:	36 sfr count (1)

Fn_36_354E:					; CmdExecute_1850:fn_36_1A86p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_9C
		mov		@R0, RAM_7
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_9D
		mov		A, R7
		mov		@R0, A
		setb	C
		subb	A, #1
		jc		read_3580
		clr		A
		mov		DPTR, #XRAM_5AC
		movx	@DPTR, A

skip_3566:					; Fn_36_354E+2Dj
		mov		DPTR, #XRAM_5AC
		movx	A, @DPTR
		clr		C
		mov		R0, #RAM_9D
		subb	A, @R0
		jnc		error_357D
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		DPTR, #XRAM_5AC
		movx	A, @DPTR
		inc		A
		movx	@DPTR, A
		sjmp	skip_3566

error_357D:					; Fn_36_354E+20j
		mov		R7, #RESP_00
		ret

read_3580:					; Fn_36_354E+11j
		mov		R0, #RAM_9C
		mov		A, @R0
		mov		R7, A
		lcall	C2_WriteAR_38F7
		lcall	C2_ReadDR_2F1F
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_36_354E


; =============== S U B	R O U T	I N E =======================================


Fn_03_3590:					; CmdExecute_1850:fn_03_1974p
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x58E
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x58D
		mov		A, #2
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #0x58C
		mov		A, R7
		movx	@DPTR, A
		mov		DPTR, #0x58B
		mov		A, #6
		movx	@DPTR, A
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_35B9
		mov		R7, #RESP_01
		ret

ROM_35B9:					; Fn_03_3590+24j
		mov		DPTR, #0x58D
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		DPTR, #0x58B
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		lcall	ROM_2F7E
		mov		R7, #RESP_OK
		ret
; End of function Fn_03_3590


; =============== S U B	R O U T	I N E =======================================


Fn_13_35D2:					; CmdExecute_1850:fn_13_19CEp
		lcall	GetHostByte_1BB3
		lcall	ROM_1722
		lcall	ROM_2489
		mov		R5, #2
		mov		R7, #2
		lcall	ROM_29E1
		lcall	ROM_3401
		mov		R5, #2
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		DPTR, #0x58F
		lcall	ROM_1756
		jnb		ACC.7, ROM_360A
		mov		R7, #1
		lcall	AddToResponse_1BF4
		mov		R0, #0xA0 ; '†'
		mov		@R0, #1
		lcall	ROM_16B6
		orl		A, #0x10
		movx	@DPTR, A
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #2			; LED2 ON
		sjmp	ROM_360F

ROM_360A:					; Fn_13_35D2+20j
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4

ROM_360F:					; Fn_13_35D2+36j
		mov		R7, #RESP_OK
		ret
; End of function Fn_13_35D2


; =============== S U B	R O U T	I N E =======================================


ROM_3612:					; Fn_0C_3232+22p
		mov		R3, RAM_5
		lcall	ROM_177B
		lcall	ROM_2489
		lcall	ROM_3996
		clr		P2.0
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		setb	RAM_24.1
		clr		RAM_24.0
		lcall	ROM_16C7
		mov		RAM_21.6, C
		lcall	JTAG_24_1_1637
		mov		RAM_21.7, C
		setb	P2.0
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	ROM_3996
		lcall	ROM_3401
		mov		A, R3
		inc		A
		lcall	Clr_i54B_R7654
		lcall	ROM_213C
		mov		R0, #0x85 ; 'Ö'
		lcall	ROM_211E
		lcall	ROM_3401
		mov		R0, #0x85 ; 'Ö'
		lcall	ROM_2112
		ret
; End of function ROM_3612


; =============== S U B	R O U T	I N E =======================================

; Erase	flash sector

Fn_30_3651:					; CmdExecute_1850:fn_30_1A68p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_96
		lcall	Check_C2_Connected_25E6	; Save R7 to @R0 and check C2 connected	(SRAM_A0 == 1)
		jz		ROM_365E
		mov		R7, #RESP_01
		ret

ROM_365E:					; Fn_30_3651+8j
		mov		R7, #8
		lcall	Read_FDAT_iR7_3680
		xrl		A, #RESP_OK
		jz		ROM_366A
		mov		A, @R0
		mov		R7, A
		ret

ROM_366A:					; Fn_30_3651+14j
		mov		R0, #RAM_96
		mov		A, @R0
		mov		R7, A
		lcall	Read_FDAT_iR7_3680
		cjne	R7, #RESP_OK, ROM_367B
		clr		A
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		sjmp	ROM_367B

ROM_367B:					; Fn_30_3651+20j
		mov		R0, #RAM_97
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_30_3651


; =============== S U B	R O U T	I N E =======================================


Read_FDAT_iR7_3680:				; Fn_30_3651+Fp Fn_30_3651+1Dp
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_97
		mov		A, R7
		mov		@R0, A
		ret
; End of function Read_FDAT_iR7_3680


; =============== S U B	R O U T	I N E =======================================


ROM_368B:					; ROM_2469p ROM_29C6p	...
		lcall	ROM_1722
		lcall	ROM_2489

ROM_3691:					; ROM_368B+13j
		lcall	ROM_33FA
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		R0, #RAM_89
		mov		@R0, RAM_7
		mov		A, @R0
		jnb		ACC.7, ROM_3691
		mov		DPTR, #XRAM_54B
		mov		A, #0x13
		lcall	Clr_iDPTR_R7654
		lcall	ROM_213C
		mov		R0, #RAM_89
		lcall	ROM_211E
		mov		R0, #RAM_89
		mov		A, @R0
		mov		DPTR, #0x5AA
		movx	@DPTR, A
		inc		R0
		mov		A, @R0
		inc		DPTR
		movx	@DPTR, A
		mov		DPTR, #0x5AA
		movx	A, @DPTR
		mov		R6, A
		inc		DPTR
		movx	A, @DPTR
		mov		R7, A
		ret
; End of function ROM_368B


; =============== S U B	R O U T	I N E =======================================


ROM_36C5:					; Fn_11_2BD8+1Dp Fn_11_2BD8+49p ...
		mov		R5, #2
		mov		R7, #2
		lcall	ROM_29E1
		lcall	ROM_3401
		mov		R5, #2
		clr		A
		mov		R7, A
		lcall	ROM_29E1
		mov		DPTR, #0x597
		mov		A, R7
		movx	@DPTR, A
		movx	A, @DPTR
		jb		ACC.7, ROM_36C5
		mov		A, #0xB
		lcall	Clr_i54B_R7654
		lcall	ROM_213C
		mov		DPTR, #0x597
		lcall	ROM_212A
		lcall	ROM_3401
		mov		DPTR, #0x597
		lcall	Load_R4567_iDPTR
		ret
; End of function ROM_36C5


; =============== S U B	R O U T	I N E =======================================


Fn_10_36F7:					; CmdExecute_1850:fn_10_19BCp
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_3709
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_01
		ret

ROM_3709:					; Fn_10_36F7+8j
		mov		R0, #0x9E ; 'û'
		mov		@R0, #1
		mov		A, @R0
		mov		R6, A
		inc		R0
		mov		A, @R0
		mov		R7, A
		lcall	ROM_2F7E
		lcall	ROM_368B
		mov		R0, #0x9E ; 'û'
		mov		@R0, RAM_6
		inc		R0
		mov		@R0, RAM_7
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_10_36F7


; =============== S U B	R O U T	I N E =======================================


Fn_1A_3727:					; CmdExecute_1850:fn_1A_19FDp
		lcall	GetHostByte_1BB3

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_55_Cmd_2
		mov		@R0, RAM_7

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_58_AppEntry_L
		mov		@R0, RAM_7

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_54_Cmd_1
		mov		@R0, RAM_7

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_53_Cmd_0
		mov		@R0, RAM_7

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_57_AppEntry_H
		mov		@R0, RAM_7

		lcall	GetHostByte_1BB3
		mov		R0, #RAM_56
		mov		@R0, RAM_7

		mov		R7, #RESP_OK
		ret

; =============== S U B	R O U T	I N E =======================================

Fn_0E_3757:
		lcall	GetHostByte_1BB3
		lcall	ROM_16D0
		lcall	ROM_2489
		lcall	ROM_36C5
		mov		R0, #RAM_75
		lcall	ROM_211E
		mov		R0, #RAM_76
		mov		A, @R0
		anl		A, #0x80
		mov		R7, A
		cjne	R7, #1,	ROM_3779
		clr		A
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_03
		ret

ROM_3779:					; Fn_0E_3757+17j
		mov		R0, #0x75
		mov		A, @R0
		mov		R7, A
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_0E_3757


; =============== S U B	R O U T	I N E =======================================

; Erase	flash

Fn_3C_3783:					; CmdExecute_1850:fn_3C_1AA4p
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_378D
		mov		R7, #RESP_01
		ret

ROM_378D:					; Fn_3C_3783+5j
		mov		R7, #3
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		A, R7
		xrl		A, #0xD
		jz		ROM_379B
		ret

ROM_379B:					; Fn_3C_3783+15j
		mov		R7, #0xDE
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #0xAD
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #0xA5
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		ret
; End of function Fn_3C_3783


; =============== S U B	R O U T	I N E =======================================


Fn_3D_37AE:					; CmdExecute_1850:fn_3D_1AA9p
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_37B8
		mov		R7, #RESP_01
		ret

ROM_37B8:					; Fn_3D_37AE+5j
		mov		R7, #4
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		A, R7
		xrl		A, #0xD
		jz		ROM_37C6
		ret

ROM_37C6:					; Fn_3D_37AE+15j
		mov		R7, #0xDE
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #0xAD
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		mov		R7, #0xA5
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		ret
; End of function Fn_3D_37AE


; =============== S U B	R O U T	I N E =======================================


Fn_24_37D9:					; CmdExecute_1850:fn_24_1A1Bp
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		ROM_37E3
		mov		R7, #RESP_01
		ret

ROM_37E3:					; Fn_24_37D9+5j
		mov		R7, #2
		lcall	C2_WriteAR_38F7
		mov		R7, #8
		lcall	DataWrite_3897
		lcall	ROM_2607
		anl		IT01CF,	#0xF0
		clr		TCON.1
		setb	IE.0
		clr		A
		mov		R0, #RAM_A0
		mov		@R0, A
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #1
		mov		R7, #RESP_OK
		ret
; End of function Fn_24_37D9


; =============== S U B	R O U T	I N E =======================================


T0OVF_0_0:					; T0OVF_Handlerj
		push	ACC
		push	DPH			; Data Pointer,	High Byte
		push	DPL			; Data Pointer,	Low Byte
		push	FSR_86
		mov		FSR_86,	#0
		push	PSW
		mov		DPTR, #XRAM_53A
		movx	A, @DPTR
		cjne	A, #1, ROM_381C
		lcall	ROM_2624
		anl		TCON, #0xCF

ROM_381C:					; T0OVF_0_0+11j
		clr		IE.1
		pop	PSW
		pop	FSR_86
		pop	DPL			; Data Pointer,	Low Byte
		pop	DPH			; Data Pointer,	High Byte
		pop	ACC
		reti
; End of function T0OVF_0_0


; =============== S U B	R O U T	I N E =======================================


Fn_26_3829:					; CmdExecute_1850:fn_26_1A27p
		mov		R0, #RAM_A0
		mov		A, @R0
		xrl		A, #1
		jz		connect_3833
		mov		R7, #NOT_CONNECT
		ret

connect_3833:					; Fn_26_3829+5j
		clr		A
		mov		R7, A
		lcall	DataWrite_FDAT_Wait_A1	; Write	R7 to FDAT and wait for	Address.1 == 0
		lcall	Wait_A0_DataRead_3988	; Wait Address.0 == 1 and DataRead
		mov		R0, #RAM_A4
		mov		A, R7
		mov		@R0, A
		cjne	R7, #RESP_OK, fail_3849
		mov		R7, #0xF0
		mov		R6, #0xD8
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value

fail_3849:					; Fn_26_3829+16j
		mov		R0, #RAM_A4
		mov		A, @R0
		mov		R7, A
		ret
; End of function Fn_26_3829


; =============== S U B	R O U T	I N E =======================================


Fn_04_384E:					; CmdExecute_1850:fn_04_197Ap
		setb	P0.2			; Port 0
		clr		P0.3			; Port 0
		lcall	Fn_00_38B9
		clr		A
		mov		DPTR, #XRAM_534
		movx	@DPTR, A
		mov		DPTR, #XRAM_538
		inc		A
		movx	@DPTR, A
		clr		A
		mov		R0, #0x55 ; 'U'
		mov		@R0, A
		mov		R0, #0x58 ; 'X'
		mov		@R0, A
		mov		R0, #0x53 ; 'S'
		mov		@R0, A
		inc		R0
		mov		@R0, A
		mov		R0, #0x56 ; 'V'
		mov		@R0, A
		inc		R0
		mov		@R0, A
		mov		R7, #RESP_OK
		ret
; End of function Fn_04_384E


; =============== S U B	R O U T	I N E =======================================


ROM_3873:					; CmdExecute_1850+189p	CmdExecute_1850+195p
		mov		R7, #4
		lcall	AddToResponse_1BF4
		lcall	GetHostByte_1BB3
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_5AE
		mov		A, R7
		movx	@DPTR, A
		lcall	GetHostByte_1BB3
		mov		DPTR, #XRAM_5AE
		movx	A, @DPTR
		jz		ROM_3891
		setb	C
		subb	A, #0x20
		jc		ROM_3894

ROM_3891:					; ROM_3873+17j
		mov		R7, #RESP_02
		ret

ROM_3894:					; ROM_3873+1Cj
		mov		R7, #RESP_OK
		ret
; End of function ROM_3873


; =============== S U B	R O U T	I N E =======================================


DataWrite_3897:					; DataWrite_i57C_17EF+Cj Fn_33_27C1+89p ...
		lcall	Pulse_Low_P14_25C7
		setb	P1.6
		clr		P0.3			; CPIN_OE low
		orl		P1MDOUT, #0x40
		lcall	Pulse_Low_P14_25C7
		clr		P1.6
		lcall	Pulse_Low_P14_25C7
		lcall	Send_XX_R7_255D
		lcall	SetIn_P16_25EE

ROM_38AF:					; DataWrite_3897+1Bj
		lcall	Pulse_Low_P14_25C7
		jnb		P1.5, ROM_38AF
		lcall	Pulse_Low_P14_25C7
		ret
; End of function DataWrite_3897


; =============== S U B	R O U T	I N E =======================================


Fn_00_38B9:					; CmdExecute_1850:fn_00_1968p Fn_04_384E+4p
		clr		P1.6			; Set TCK low
		setb	P2.0
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		lcall	PulseHigh2_P16_3998
		mov		R0, #RAM_A0
		mov		@R0, #3
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #2
		mov		R7, #RESP_OK
		ret
; End of function Fn_00_38B9


; =============== S U B	R O U T	I N E =======================================

; Disconnect Target

Fn_21_38D7:					; CmdExecute_1850:fn_21_1A09p
		mov		R7, #2
		lcall	C2_WriteAR_38F7		; Address = 2
		clr		A
		mov		R7, A
		lcall	DataWrite_3897		; Data = 0
		mov		R7, #0x3C
		mov		R6, #0xF6
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		lcall	C2_Reset_393A
		clr		A
		mov		R0, #RAM_A1_LEDS
		mov		@R0, A
		mov		R7, #RESP_OK
		ret
; End of function Fn_21_38D7


; =============== S U B	R O U T	I N E =======================================


AddressWrite_FDAT_38F2:				; DataWrite_FDAT_Wait_A1+2p Wait_A0_DataRead_3988+7p
		mov		DPTR, #C2_FPDAT_57A
		movx	A, @DPTR
		mov		R7, A
; End of function AddressWrite_FDAT_38F2


; =============== S U B	R O U T	I N E =======================================


C2_WriteAR_38F7:				; DataWrite_i57C_17EF+7p Fn_33_27C1+71p ...
		lcall	Pulse_Low_P14_25C7
		setb	P1.6
		clr		P0.3			; Port 0
		orl		P1MDOUT, #0x40
		lcall	Send_XX_R7_255D
		lcall	SetIn_P16_25EE
		lcall	Pulse_Low_P14_25C7
		ret
; End of function C2_WriteAR_38F7


; =============== S U B	R O U T	I N E =======================================


Fn_0F_390B:					; CmdExecute_1850:fn_0F_19B6p
		lcall	GetHostByte_1BB3
		lcall	ROM_16D0
		lcall	ROM_2489
		lcall	GetHostByte_1BB3
		lcall	ROM_2EBD
		cjne	R7, #3,	ROM_3920
		mov		R7, #3
		ret

ROM_3920:					; Fn_0F_390B+Fj
		mov		R7, #RESP_OK
		ret
; End of function Fn_0F_390B


; =============== S U B	R O U T	I N E =======================================

; Response DeviceID (Addr:0) and Revision (Addr:1)

Fn_22_3923:					; CmdExecute_1850:fn_22_1A0Fp
		clr		A
		mov		R7, A
		lcall	ReadRegister_3930
		mov		R7, #1
		lcall	ReadRegister_3930
		mov		R7, #RESP_OK
		ret
; End of function Fn_22_3923


; =============== S U B	R O U T	I N E =======================================


ReadRegister_3930:				; Fn_22_3923+2p Fn_22_3923+7p
		lcall	C2_WriteAR_38F7
		lcall	C2_ReadDR_2F1F
		lcall	AddToResponse_1BF4
		ret
; End of function ReadRegister_3930


; =============== S U B	R O U T	I N E =======================================


C2_Reset_393A:					; Fn_20_32D1p Fn_21_38D7+11p
		clr		IE.0
		clr		P1.4
		mov		R7, #0xF4		; FFF4 = 20 uS
		mov		R6, #0xFF
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		setb	TCON.0
		setb	P1.4
		mov		A, #0xFF
		mov		R7, A
		mov		R6, A
		lcall	Delay_T0_R67_1D74	; Delay	via Timer 0 with R6(high), R7(low) value
		ret
; End of function C2_Reset_393A


; =============== S U B	R O U T	I N E =======================================


Fn_09_3951:					; CmdExecute_1850:fn_09_1992p
		lcall	GetHostByte_1BB3
		clr		A
		mov		R7, A
		mov		R6, A
		lcall	ROM_2F7E
		lcall	ROM_16B2
		mov		R0, #RAM_A1_LEDS
		mov		@R0, #1
		mov		R7, #RESP_OK
		ret
; End of function Fn_09_3951


; =============== S U B	R O U T	I N E =======================================


Fn_27_3964:					; CmdExecute_1850:fn_27_1A2Dp
		mov		R0, #RAM_A0
		mov		A, @R0
		cjne	A, #1, ROM_396E
		mov		R7, #1
		sjmp	ROM_3970

ROM_396E:					; Fn_27_3964+3j
		mov		R7, #0

ROM_3970:					; Fn_27_3964+8j
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_27_3964


; =============== S U B	R O U T	I N E =======================================

; Write	R7 to FDAT and wait for	Address.1 == 0

DataWrite_FDAT_Wait_A1:				; Fn_28_2A_2E_3E_262F+4Cp Fn_28_2A_2E_3E_262F+6Cp ...
		mov		R6, RAM_7
		lcall	AddressWrite_FDAT_38F2
		mov		R7, RAM_6
		lcall	DataWrite_3897

ROM_3980:					; DataWrite_FDAT_Wait_A1+Ej
		lcall	AddressRead_30EE
		mov		A, R7
		jb		ACC.1, ROM_3980
		ret
; End of function DataWrite_FDAT_Wait_A1


; =============== S U B	R O U T	I N E =======================================

; Wait Address.0 == 1 and DataRead

Wait_A0_DataRead_3988:				; Fn_28_2A_2E_3E_262F+A8p Wait_A0_DataRead_26F0p ...
		lcall	AddressRead_30EE
		mov		A, R7
		jnb		ACC.0, Wait_A0_DataRead_3988 ; Wait Address.0 == 1 and DataRead
		lcall	AddressWrite_FDAT_38F2
		lcall	C2_ReadDR_2F1F
		ret
; End of function Wait_A0_DataRead_3988


; =============== S U B	R O U T	I N E =======================================


ROM_3996:					; ROM_213C+6p ROM_29E1p ...
		setb	P2.0
; End of function ROM_3996


; =============== S U B	R O U T	I N E =======================================


PulseHigh2_P16_3998:				; ROM_213C:ROM_23AAp ROM_2489+12p ...
		lcall	PulseHigh_P16_399D	; Pulse	high TCK (P1.6)
		clr		P2.0
; End of function PulseHigh2_P16_3998


; =============== S U B	R O U T	I N E =======================================

; Pulse	high TCK (P1.6)

PulseHigh_P16_399D:				; JTAG_24_1_1637p JTAG_24_2_164Ep ...
		clr		P1.6
		setb	P1.6
		clr		P1.6
		ret
; End of function PulseHigh_P16_399D


; =============== S U B	R O U T	I N E =======================================

; Address Write

Fn_38_39A4:					; CmdExecute_1850:fn_38_1A90p
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_A5
		mov		A, R7
		mov		@R0, A
		lcall	C2_WriteAR_38F7
		mov		R7, #RESP_OK
		ret
; End of function Fn_38_39A4


; =============== S U B	R O U T	I N E =======================================

; Data Write

Fn_3A_39B1:					; CmdExecute_1850:fn_3A_1A9Ap
		lcall	GetHostByte_1BB3
		mov		R0, #RAM_A6
		mov		A, R7
		mov		@R0, A
		lcall	DataWrite_3897
		mov		R7, #RESP_OK
		ret
; End of function Fn_3A_39B1


; =============== S U B	R O U T	I N E =======================================

; Address Read

Fn_39_39BE:					; CmdExecute_1850:fn_39_1A95p
		lcall	AddressRead_30EE
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_39_39BE


; =============== S U B	R O U T	I N E =======================================

; Data Read

Fn_3B_39C7:					; CmdExecute_1850:fn_3B_1A9Fp
		lcall	C2_ReadDR_2F1F
		lcall	AddToResponse_1BF4
		mov		R7, #RESP_OK
		ret
; End of function Fn_3B_39C7


; =============== S U B	R O U T	I N E =======================================


CmdInit_39D0:					; j_CmdInit_39D0j

; FUNCTION CHUNK AT 1803 SIZE 0000004D BYTES

		mov		SP, #RAM_A8		; Stack	Pointer
		ljmp	CmdInit_1803
; End of function CmdInit_39D0


; =============== S U B	R O U T	I N E =======================================


RestartDevice_39D6:
		lcall	InitPorts_1B59
		setb	P0.3			; CPIN_OE = 1
		anl		P1MDOUT, #0xBF
		orl		P1, #0x40
		setb	P2.1			; APIN_OE = 1
		anl		P1MDOUT, #0xEF
		orl		P1, #0x10
		mov		RAM_A, #high(XRAM_257)
		mov		RAM_B, #low(XRAM_257)
		mov		RAM_8_GetIndexHi, #high(XRAM_257)
		mov		RAM_9_GetIndexLo, #low(XRAM_257)
		mov		RAM_E, #high(XRAM_257)
		mov		RAM_F, #low(XRAM_257)
		mov		RAM_C, #high(XRAM_257)
		mov		RAM_D, #low(XRAM_257)
		clr		TMR2CN.2
		clr		IE.0
		clr		IE.5
		anl		PCA0CN,	#0xBF		; PCA Control Register
		clr		TMR2CN.7
		clr		TCON.1
		mov		R7, #0xFF
		lcall	AddToResponse_1BF4
		lcall	UsbFlush_1BED
		mov		SP, #RAM_59		; Stack	Pointer
		ljmp	UsbStart_A98


		DB 0x22 ; "
		DB 0x41 ; A
		DB	 5
		DB 0x33 ; 3
		DB	 0



		CSEG	AT 0x3C00
ROM_3C00:
		sjmp	ROM_3C00

; =============== S U B	R O U T	I N E =======================================

Usb_Fn_03_3C02:
		clr		C
		mov		A, RAM_57_AppEntry_H
		subb	A, #0x16
		jnc		ROM_3C1E
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3C19 ; 'W'
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3C19
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3C53

ROM_3C19:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7
		sjmp	ROM_3C53

ROM_3C1E:
		mov		RAM_29,	#0
		mov		RAM_2A,	RAM_54_Cmd_1
		mov		A, RAM_2A
		mov		RAM_2A,	#0
		mov		RAM_29,	A
		mov		A, RAM_55_Cmd_2
		orl		RAM_2A,	A
		mov		A, RAM_2A
		orl		A, RAM_29
		jz		ROM_3C40
		setb	C
		mov		A, RAM_2A
		subb	A, #0
		mov		A, RAM_29
		subb	A, #2
		jc		ROM_3C5B

ROM_3C40:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3C50 ; 'W'
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3C50
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3C53

ROM_3C50:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_3C53:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #1
		ljmp	ROM_3CDB

ROM_3C5B:
		mov		RAM_2B,	RAM_57_AppEntry_H
		mov		RAM_2C,	RAM_58_AppEntry_L
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3C71
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3C71
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3C74

ROM_3C71:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_3C74:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		clr		A
		movx	@DPTR, A
		lcall	UsbFlush_D54
		clr		A
		mov		RAM_27,	A
		mov		RAM_28,	A

ROM_3C81:
		clr		C
		mov		A, RAM_28
		subb	A, RAM_2A
		mov		A, RAM_27
		subb	A, RAM_29
		jnc		ROM_3CC4
		lcall	GetHostByte_132E
		clr		IE.7
		mov		FLKEY, #0xA5
		mov		FLKEY, #0xF1
		mov		PSCTL, #1
		mov		VDM0CN,	#0x80
		mov		RSTSRC,	#6
		mov		A, R7
		xrl		A, #0x55
		mov		R6, A
		inc		RAM_2C
		mov		A, RAM_2C
		mov		R4, RAM_2B
		jnz		ROM_3CAE
		inc		RAM_2B

ROM_3CAE:
		dec	A
		mov		DPL, A			; Data Pointer,	Low Byte
		mov		DPH, R4			; Data Pointer,	High Byte
		mov		A, R6
		movx	@DPTR, A
		clr		A
		mov		PSCTL, A
		setb	IE.7
		inc		RAM_28
		mov		A, RAM_28
		jnz		ROM_3C81
		inc		RAM_27
		sjmp	ROM_3C81

ROM_3CC4:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3CD4
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3CD4
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3CD7

ROM_3CD4:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_3CD7:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		clr		A

ROM_3CDB:
		movx	@DPTR, A
		lcall	UsbFlush_D54
		ret

; =============== S U B	R O U T	I N E =======================================

Usb_Fn_01_3CE0:
		mov		RAM_27,	RAM_54_Cmd_1
		mov		A, RAM_27
		clr		C
		subb	A, #0xB
		jc		ROM_3CFC
		mov		A, RAM_27
		xrl		A, #0x1F
		jz		ROM_3CFC
		mov		A, RAM_27
		setb	C
		subb	A, #0x20
		jnc		ROM_3CFC
		mov		A, RAM_27
		cjne	A, #0x1E, valid_app_3D16

ROM_3CFC:
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3D0C
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3D0C
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3D0F

ROM_3D0C:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_3D0F:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		mov		A, #RESP_01
		sjmp	usb_fn_done_3D33

valid_app_3D16:
		mov		RAM_56,	RAM_27
		lcall	SetAppEntry_1223	; Set AppEntry = (RAM(56) * 2 << 8)
		mov		A, RAM_F
		cjne	A, #low(XRAM_257), ROM_3D2C
		mov		A, RAM_E
		cjne	A, #high(XRAM_257), ROM_3D2C
		mov		R6, #0
		mov		R7, #0
		sjmp	ROM_3D2F

ROM_3D2C:
		lcall	inc_RAM_EF_R67_11E5	; Get RAM(E,F)+1 to R6,7

ROM_3D2F:
		lcall	Mov_RAM_EF_R67_11D6	; Save R6,7 to RAM(E,F)	and DPTR
		clr		A

usb_fn_done_3D33:
		movx	@DPTR, A
		lcall	UsbFlush_D54
		ret

; =============== S U B	R O U T	I N E =======================================

LongDelay_3D38:
		clr		A
		mov		R7, A
		mov		R6, A

loop_3D3B:
		inc		R7
		cjne	R7, #0,	loop_3D40
		inc		R6

loop_3D40:
		cjne	R6, #1,	loop_3D3B
		cjne	R7, #0xF4, loop_3D3B
		ret

; =============== S U B	R O U T	I N E =======================================

RESET_Handler:

		mov		R0, #0x7F
		clr		A

clear_RAM_3D4A:
		mov		@R0, A
		djnz	R0, clear_RAM_3D4A

		mov		SP, #RAM_58_AppEntry_L	; Stack	Pointer
		ljmp	init_XRAM_3D8E

init_done_3D53:
		ljmp	main_147C

ROM_3D56:
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		mov		R0, A

ROM_3D5A:
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		jc		ROM_3D62
		mov		@R0, A
		sjmp	ROM_3D63

ROM_3D62:
		movx	@R0, A

ROM_3D63:
		inc		R0
		djnz	R7, ROM_3D5A
		sjmp	ROM_3D91

ROM_3D68:
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		mov		R0, A
		anl		A, #7
		add		A, #0xC
		xch		A, R0
		clr		C
		rlc	A
		swap	A
		anl		A, #0xF
		orl		A, #0x20
		xch		A, R0
		movc	A, @A+PC
		jc		ROM_3D80
		cpl	A
		anl		A, @R0
		sjmp	ROM_3D81

ROM_3D80:
		orl		A, @R0

ROM_3D81:
		mov		@R0, A
		djnz	R7, ROM_3D68
		sjmp	ROM_3D91

		DB	 1
		DB	 2
		DB	 4
		DB	 8
		DB 0x10
		DB 0x20
		DB 0x40
		DB 0x80

init_XRAM_3D8E:
		mov		DPTR, #data_XRAM_1456

ROM_3D91:
		clr		A
		mov		R6, #1
		movc	A, @A+DPTR
		jz		init_done_3D53
		inc		DPTR
		mov		R7, A
		anl		A, #0x3F
		jnb		ACC.5, ROM_3DA7
		anl		A, #0x1F
		mov		R6, A
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		jz		ROM_3DA7
		inc		R6

ROM_3DA7:
		xch		A, R7
		anl		A, #0xC0
		add		A, ACC
		jz		ROM_3D56
		jc		ROM_3D68
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		mov		R2, A
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		mov		R0, A

ROM_3DB8:
		clr		A
		movc	A, @A+DPTR
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R2
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R2
		movx	@DPTR, A
		inc		DPTR
		xch		A, R0
		xch		A, DPL			; Data Pointer,	Low Byte
		xch		A, R0
		xch		A, R2
		xch		A, DPH			; Data Pointer,	High Byte
		xch		A, R2
		djnz	R7, ROM_3DB8
		djnz	R6, ROM_3DB8
		sjmp	ROM_3D91

; =============== S U B	R O U T	I N E =======================================

InitOsc_3DD3:
		anl		OSCICN,	#0xFC
		clr		A
		mov		CLKMUL,	A
		orl		CLKMUL,	#0x80
		orl		CLKMUL,	#0xC0
		lcall	LongDelay_3D38

wait_3DE2:
		mov		A, CLKMUL
		jnb		ACC.5, wait_3DE2
		mov		CLKSEL,	#2
		ret

; =============== S U B	R O U T	I N E =======================================

Usb_Fn_06_3DEB:
		mov		R2, RAM_57_AppEntry_H
		mov		R1, RAM_58_AppEntry_L
		ljmp	Jmp_iR21_F6F

		cseg at	0x3DFF
		db		0xFF
//		db		0

		END