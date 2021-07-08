;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;    TI SD Disk.asm
;
; Created: 1/1/2019 3:45:02 PM
; Author : Dennis Hatton
;
; Fuses FF D9 FF
; 16mhz ext crystal
;
;   Atmega8515 Converted to Atmega162		
;    PortA	PortB	    Portc	PortD	    PortE			
;    0<Data0	0<A0	    0>Data0	0<RXD	    0<!INT2			
;    1<Data1	1<A1	    1>Data1	1>TXD	    1<!WE		
;    2<Data2	2<	    2>Data2	2<	    2>!ready			
;    3<Data3	3<	    3>Data3	3>HLD			
;    4<Data4	4>CS	    4>Data4	4<Drive1
;    5<Data5	5>MOSI	    5>Data5	5<Drive2    
;    6<Data6	6<MISO	    6>Data6	6<Drive3
;    7<Data7	7>SCK	    7>Data7	7<Side   
;
; IN PINx
; OUT PORTx
; OUT PINx turns on pullup						
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			

			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PortE bits
			.equ intbit = PE0
			.equ webit = PE1
			.equ rdybit = PE2
			
; Dedicated registers			
; INT2:	XL XH r13 r14			
; SD error count: r10			
; Save arg: r6-r9
;			
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.DSEG
fdcRegisters:
fdcStatus:	.byte 1			;TI 5FF0 Read Status
fdcTrack:	.byte 1			;TI 5FF2/5FFA Rd/Wr Track Register
fdcSector:	.byte 1			;TI 5FF4/5FFC Rd/Wr Sector Register
fdcData:	.byte 1			;TI 5FF6/5FFE Rd/ Data Register
fdcCommand:	.byte 1			;TI 5FF8 Write Command Register
fdcSide:	.byte 1			;	

flags:		.byte 1			;flags + address
			.equ iflag = 7	;1 int occured
			.equ wflag = 2	;1 write occured

DSK1address:	.byte	4	;LSB -- MSB			
DSK2address:	.byte	4	;LSB -- MSB
DSK3address:	.byte	4	;LSB -- MSB
DSK1LastTrk:	.byte	1
DSK2LastTrk:	.byte	1
DSK3LastTrk:	.byte	1
TIlowbyte:	.byte	1
	
	
;SD variables
		.equ CS = PB4
ocr:		.byte	1
		.equ ccs = 6	;bit 6
cmd:		.byte	1
arg:		.byte	4	;LSB -- MSB		
crc:		.byte	1
resp:		.byte	1

SectorsPerCluster:		;in Powers of 2 (Number of left shifts to use)
		.byte	1
Offset:		.byte	4	;LSB -- MSB	
StartSector:	.byte	2
StepSectors:	.byte	2
		
;Use buffer to calc end of fdcRegisters variables to send to USART intr
TIbuffer:	.byte	256
SDbuffer:	.byte	512
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Interrupts vector tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	.CSEG		;8515 use rjmp 162 use jmp
	.org $000
	jmp setup	;Reset Handler
	.org URXC0addr	;8515 URXCaddr, 162 URXC0addr
	jmp USART_RXC	;USART RX Complete Handler  
	.org INT2addr
	jmp EXT_INT2	;IRQ2 Handler
	

;Interrupt Service Routines
	.org INT_VECTORS_SIZE		;End of Int vector table

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IRQ2 Interrupt Handler
; XH XL r13 r14 r15 not saved
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cycle = 62.5ns
EXT_INT2:
    	in r13, SREG			;Save SREG			1
	mov r14, r16			;				1
	in r16, PinB			;Get FDC address		1
	andi r16,0x03			;				1
	clr r15				;				1								
	ldi XH, high(fdcRegisters)	;Point X to FDC_Registers base	1
	ldi XL, low(fdcRegisters)	; "				1
	add XL, r16			;add FDC address offset		1
	adc XH, r15			; "				1
	ld r15, X			;Get data in FDC register	2
	out PortA, r15			;Send it to TI			1
	sbr r16, 1<<iflag		;Set our interrupt flag		1
	nop				;				1
	nop				;				1
 ;Need 13-19 cycles to here, Min 15 without errors			15
	
	sbic PinE, webit		;Test !we
	rjmp isr2end			;Read if 1
	in r15, PinC			;Get  write data
	com r15				;TI sends inverted data
	sbr r16, 1<<wflag		;Set write flag
	cpi r16,0x84			;Check If Command
	brne NotCMD			; "
	adiw X, 4			;Point to Command registers
NotCMD:	
	st X, r15			;Write data to FDC register
isr2end:
	sts flags, r16			;
	mov r16, r14			;
	out SREG, r13			;Restore SREG	
	reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; USART RX Complete Interrupt Handler	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
USART_RXC:
	push ZH
	push ZL
	push YH
	push YL
	push XH
	push XL
	push r25
	push r24
	push r23
	push r22
	push r21
	push r20
	push r19
	push r18
	push r17
	push r16
	in r16, SREG
	PUSH r16
	
	rcall USARTRead		    ;Get char received
	cbr r16, 1<<5		    ;If lowercase convert to uppercase
chkR:	
	cpi r16,'R'		    ;Send reg 16-31, SREG, Ret PC
	brne chkS
	in ZH, SPH
	in ZL, SPL
	adiw Z,1
	ldi r17, 19
	rjmp TXLP0
chkS:	
	cpi r16,'S'		    ;Send all calls on stack
	brne chkB
	in ZH, SPH
	in ZL, SPL
	adiw Z,17
	ldi r17, low(RAMEND)
	sub r17, ZL
	adiw Z,1
	rjmp TXLP0	
chkB:
 	cpi r16,'B'		    ;Send TIbuffer
	brne chkC
	clr r17
TXJP0:	
	ldi ZH, high(TIbuffer)	    ; Get address to TIbuffer
	ldi ZL, low(TIbuffer)	    ; "
	rjmp TXLP0
chkC:
 	cpi r16,'C'	;Send all FDC registers (variables) except buffer
	brne RXCIntRtn
	ldi r17, TIbuffer-fdcRegisters ;All between fdcRegisters & buffer
	ldi ZH, high(fdcRegisters)  ; Get address to FDC registers
	ldi ZL, low(fdcRegisters)   ; "
TXLP0:	
	ld r16,Z+
	rcall USARTWrite	    ; Send data byte
	dec R17
	brne TXLP0
	
RXCIntRtn:
	pop r16
 	out SREG, r16
	pop r16
	pop r17
	pop r18
	pop r19
	pop r20
	pop r21
	pop r22
	pop r23
	pop r24
	pop r25
	pop XL
	pop XH
	pop YL
	pop YH
	pop ZL
	pop ZH
  	reti	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Use to access program memory	
; ldi ZH,high(hello<<1)	;Shift (address*2) because program memory is 16 bits
; ldi ZL,low(hello<<1)	;When address bit0 is 0 low byte of word is accessed
; lpm r16,Z+		;When address bit0 is 1 high byte of word is accessed
;			;Effectively changing to byte access
;hello:
;	.db "HELLO",0
EXFATstr: .db 0xEB,0x76,0x90,"EXFAT",0xFF,0 ;make even bytes
VOLstr:	.db 0xC1,0,'V',0,'O',0,'L',0,'U',0,'M',0,'E',0,'S',0xFF
TIVOLstr: .db 0xC1,0,'T',0,'I',0,'V',0,'O',0,'L',0,'0',0,'0',0,'0',0xFF
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setup:
	ldi r16, low(RAMEND)		;Init stack
	out spl, r16			;	"
	ldi r16, high(RAMEND)		;	"
	out sph, r16			;	"
;Setup ports
	ser	r16			;PortA (FF) output mode for TI read
	out DDRA, r16			; "
	clr	r16			;PortC (00) input mode for TI write
	out DDRC, r16			; "
	ldi	r16,0b10110000		;SCK,MI,MO,CS,0,0,A1,A0
	out DDRB, r16			;O  ,I ,O ,O ,I,I,I ,I
	sbi PortB, PB6			;Pullup MISO
	ldi	r16,0b00001010		;Side,DR3,DR2,DR1,HLD,0,TDX,RXD
	out DDRD, r16			;I   ,I  ,I  ,I  ,O  ,I,O  ,I
	ldi	r16,0b00000100		;0,0,0,0,0,!Ready,!WE,!INT
	out DDRE, r16			;I,I,I,I,I,O     ,I  ,I
	cbi PortE, rdybit		;Ready to TI

	in r16, EMCUCR			;Set INT2 falling edge trigger
	cbr r16, 1<<ISC2		; " ISC2=bit0 same as andi r16, 0xFE
	out EMCUCR, r16			; "
	in r16, GICR			;Enable INT2
	sbr r16, 1<<INT2		; " INT2=bit5 same as ori r16, 32
	out GICR, r16			; "	
;Set status				;NotReady  track0  busy
	ldi r16, 0x04			;b7=0      b3=1    b0=0
	sts fdcStatus, r16		;
	clr r16				; 
	sts fdcTrack, r16		;
	sts fdcSector, r16		;
	sts fdcData, r16		;
	sts fdcCommand, r16		;
	cbi PortD, 3			;data not ready
;Setup USART				;baud @ 16MHz (Using double baud rate)
	ldi r17, 0			;230.4k=0,8 115.2k=0,16
	ldi r16, 16			;
	rcall USARTInit
	in r16, UCSR0B			;Enable RXC interrupt
	sbr r16, 1<<RXCIE		; "
	out UCSR0B, r16			; "	
;Setup SPI
	ldi r16, 16
	mov r10, r16			;SD error count, So it doesn't run away
	rcall SPIInit  
	rcall MMCInit
;Setup Drives	
SetupStartStep:  
	rcall FindTIVOL		;Find TIVOL000, Save Start and Step
	breq SetupDSK
	ldi r16, 0x80		;disk error, not ready
	sts fdcStatus, r16	;
;Get DSKx addresses from SD sector 1    
SetupDSK:
	ldi r16, 0x01
	sts arg, r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1, r16
	sts arg+2, r16
	sts arg+3, r16		; (MSB)
	rcall ReadMMC           ; First half 512 sector (uses ZL & ZH)
	
;XL & XH ok to use before interrupts are enabled    	
	ldi ZL, low(SDbuffer+4)	    ;
	ldi ZH, high(SDbuffer+4)	    ;

	ld r16, Z+		    ;Get Drive 1 Disk #
	push r16		    ;		    
	ld r16, Z+		    ;Get Drive 2 Disk #
	push r16		    ;
	ld r16, Z+		    ;Get Drive 3 Disk #
	push r16
	
	ldi YL, low(DSK3address)    ;
	ldi YH, high(DSK3address)   ;
	
	ldi r18, 3
LP02:	pop r21			    ;Restore disk number (stepping 3 - 1)
	rcall Disk2Sector	    ;Convert disk # to sector address
	st Y+, r0		    ;Save into DSKXaddress
	st Y+, r1		    ;
	st Y+, r2		    ;
	st Y+, r3		    ;
	sbiw Y, 8		    ;Back to start of current drive + start preceding drive
	dec r18			    ;
	brne LP02		    ;All 3 drives done 
	
;Set last track for drives
	ldi ZL, low(DSK1address)    ;LSB -- MSB
	ldi ZH, high(DSK1address)   ;
	ldi YL, low(arg)	    ;
	ldi YH, high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC 		    ;First half 512 sector (uses ZL & ZH)
	ldi r16, 39
	lds r17, SDbuffer+10
	sbrc r17, 2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16, 79
	sts DSK1LastTrk, r16
	
	ldi ZL, low(DSK2address)    ;LSB -- MSB
	ldi ZH, high(DSK2address)   ;
	ldi YL, low(arg)	    ;
	ldi YH, high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC		    ;First half 512 sector (uses ZL & ZH)
	ldi r16, 39
	lds r17, SDbuffer+10
	sbrc r17, 2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16, 79
	sts DSK2LastTrk, r16
	
	ldi ZL, low(DSK3address)    ;LSB -- MSB
	ldi ZH, high(DSK3address)   ;
	ldi YL, low(arg)	    ;
	ldi YH, high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC		    ;First half 512 sector (uses ZL & ZH)
	ldi r16, 39
	lds r17, SDbuffer+10
	sbrc r17, 2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16, 79
	sts DSK3LastTrk, r16
	
;Enable interrupts	
	clr r16				;Clear flags
	sts flags, r16			;
	sei				;Global enable interrupts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:	clr r16			    ; Clear busy, No errors	
JP02:	sts fdcStatus, r16	    ; "	     
	cbi PortE, 2		    ;Release TI
	
LP00:	lds r16, flags		    ;Get flags
	sbrs r16, iflag		    ;Has TI has sent data?
	rjmp LP00
	clr r17			    ;Clear flags
	sts flags, r17		    ; "		    
	
	lds r16, fdcCommand	    ;
	cpi r16, 0x00		    ;
	breq LP00
	
	sbi PortE, 2		    ;Put TI on hold while process command
	sts fdcCommand, r17	    ;Clear command (r17=0 from above)
;	ldi r17, 0x01		    ;Set Busy bit
;	sts fdcStatus, r17	    ; "
	
;	rcall USARTWrite	    ;Send command in r16 (enable for debbuging)
	
;Our Mount Disk command	
fdcCMD81:			    	
	cpi r16, 0x81		   
	brne fdcCMD82
	rcall ChgDisk
	rjmp SetupDSK		    ;Setup disk addresses and last track
;Our Send all disk names command		
fdcCMD82:			    
	cpi r16, 0x82		    
	brne fdcCMD0A
	rcall SendNames
	rjmp main
;0A Restore (h=1, V=0, r0r1=10)	
fdcCMD0A:			   
	cpi r16, 0x0A		    ;
	brne fdcCMD1E
	clr r16			    ;
	sts fdcTrack, r16	    ;Set to track 0
	sts fdcSector, r16	    ;Set to sector 0
	sbr r16, 0x04		    ;Set track 0 in status
	rjmp JP02
;1E Seek h=1 V=1 r1r0=10
fdcCMD1E:			    
	cpi r16, 0x1E		    ;
	brne fdcCMD5A
	lds r16, fdcData
	sts fdcTrack, r16
	rjmp main
;2x Step not used by TI
;5A Step-in T=1, h=1, V=0, r0r1=10	
fdcCMD5A:			    
	cpi r16, 0x5A		    ;
	brne fdcCMD88
	lds r16, fdcTrack
	inc r16
	sts fdcTrack, r16
	rjmp main
;6x Step-out not used by TI
;88 Read sector m=0 S=1 E=0 C=0		    
fdcCMD88:			    
   	cpi r16, 0x88		    ;
	brne fdcCMDA8
	rcall TIreadsec
	rjmp main
;A8 Write sector m=0 S=1 E=0 C=0 a=0
fdcCMDA8:			    
	cpi r16, 0xA8		    ;
	brne fdcCMDC0
	rcall TIwritesec
mainRLY: rjmp main
;C0 Read ID E=0
fdcCMDC0:			    
	cpi r16, 0xC0		    ;
	brne fdcCMDF4
	rcall TIreadID
	rjmp main
;Ex Read track not used by TI
;F4 Write track (E=1)
fdcCMDF4:			    
    	cpi r16, 0xF4		    ;
	brne fdcCMDD0
	rcall TIwritetrack
	rjmp mainRLY
;D0 Force interrupt
fdcCMDD0:			    
    	cpi r16, 0xD0		    ;Sent after software reset (FTCN =)
	brne mainRLY
	rcall delay1ms
	rjmp SetupDSK		    ;Setup disks in case one was formatted
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIreadID:
	cbi PortE, 2		;Release TI
	lds r16, fdcTrack	;Get track
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	clr r16			;Side 0
	sbic PinD, 7		;Get Side
	inc r16			;Side 1
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	lds r16, fdcSector	;Get sector
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	clr r16			;Sector lenght code?
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	clr r16			;CRC byte1
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	clr r16			;CRC byte2
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIwritesec:
 	ldi ZH, high(TIbuffer)	;Get address to buffer
	ldi ZL, low(TIbuffer)	; "
	ldi r18, 0x00		;256 bytes per sector
	
	cbi PortE, 2		;Release TI
lp24:	rcall WaitTIwrite	;Wait for data from TI
	lds r16, fdcData	;Get next byte
	st Z+, r16		;Save to buffer
	dec r18
	brne LP24
	
	sbi PortE, 2		;Put TI on hold while process command
	ldi r16,1
	sbis PinD, 7		;Test pin, Skip if side 1
	clr r16
	sts fdcSide,r16
	rcall Track2Arg		;Set arg to SD sector for TI DISK
	rcall TI_SD_wr		;Write to SD
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIreadsec:
	ldi r16,1
	sbis PinD, 7		;Test pin, Skip if side 1
	clr r16
	sts fdcSide,r16
	rcall Track2Arg		;Set arg to SD sector for TI DISK
	rcall TI_SD_rd		;Get sector from SD
	ldi ZH, high(TIbuffer)	; Get address to buffer
	ldi ZL, low(TIbuffer)	; "
	ldi r18, 0x00		;256 bytes per sector
	
	cbi PortE, 2		;Release TI
lp13:	ld r16, Z+		;Get next byte
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	dec r18
	brne LP13
	ret
;	
;Convert TI track&sector to SD sector	
Track2Arg:
	lds r16, fdcTrack
	lds r17,fdcSide
	sbrs r17, 0		;Test bit, Skip if side 1	
	rjmp j00
	lds r17, DSK1LastTrk	;
	sbic PinD, 5		;
	lds r17, DSK2LastTrk	;
	sbic PinD, 6		;
	lds r17, DSK3LastTrk	;
	sub r16, R17		;Reverse track (0=-39 or -79) 
	neg r16			;Make postive
	inc r17			;
	add r16, r17		;Track + 40 or 80
j00:	
	ldi r17, 9		;Track*9
	mul r16, r17		;Result in r0 r1
	clr r17			;Add sector offset 0-8		
	lds r16, fdcSector	; "
	add r0, r16		; "
	adc r1, r17		; "
	
	;Divide TI sector by 2 to put in upper or lower half of SD sector
	sts TIlowbyte, r0 	;save low byte for bit 0 test
	lsr r1			;Divide 16 bits by 2
	ror r0			; "	"	"
	
	;Add TI sector to DSKx SD start sector address and place in ARG
	ldi ZH, high(DSK1address)   ;
	ldi ZL, low(DSK1address)    ;
	sbic PinD, 5		    ;
	adiw Z,4		    ;DSK2address
	sbic PinD, 6		    ;
	adiw Z,8		    ;DSK3address

	ld r16, Z+
	add r16, r0
	sts arg, r16
	ld r16, Z+
	adc r16, r1
	sts arg+1, r16
	clr r0			;carry not affected
	ld r16, Z+
	adc r16, r0
	sts arg+2, r16
	ld r16, Z
	adc r16, r0
	sts arg+3, r16
	ret
;	
WaitTIread:
	lds r16, flags		;Get flags
	sbrs r16, iflag		;Has TI read data?
	rjmp WaitTIread
	clr r17			;Clear interrupt flag
	sts flags, r17		; "
	cpi r16, 0x83		;Was it read data register
	brne WaitTIread
	ret
WaitTIwrite:
	lds r16, flags		;Get flags
	sbrs r16, iflag		;Has TI written data?
	rjmp WaitTIwrite
	clr r17			;Clear interrupt flag
	sts flags, r17		; "
	cpi r16, 0x87		;Was it write data register
	brne WaitTIwrite
	ret
	
TI_SD_rd:
	rcall readmmc		;512 bytes in sdbuffer
	ldi ZL, low(SDbuffer)
	ldi ZH, high(SDbuffer)
	lds r16,TIlowbyte
	sbrc r16,0
	inc ZH			;Add 256 to Z
	ldi YL, low(TIbuffer)
	ldi YH, high(TIbuffer)
;Move 256 bytes from source(Z) to destination(Y)
mov256:	clr r16		
LP03:	ld r17, Z+ 
	st Y+, r17
	dec r16
	brne LP03
	ret	;and send to TI
TI_SD_wr:
	rcall readmmc	//512 bytes in sdbuffer
	ldi ZL, low(TIbuffer)
	ldi ZH, high(TIbuffer)
	ldi YL, low(SDbuffer)
	ldi YH, high(SDbuffer)
	lds r16,TIlowbyte
	sbrc r16,0
	inc YH			;Add 256 to Y
	rcall mov256
	rcall writemmc	//512 bytes in sdbuffer
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIwritetrack:
	ldi r20,9
LP25:	
	cbi PortE, 2		;Release TI
	
;Get (FE, Track, Side, Sector, 1?, F7)	
LP26:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData		;Get next byte
	cpi r16,0xFE
	brne LP26
	
	rcall WaitTIwrite	;Throw away Track, already loaded

	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	
;	ror r16			;Move bit0 to bit7
;	ror r16			; "
	sts fdcSide,r16		;Save Side
	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	
	sts fdcSector,r16	;Save Sector

;Get (FB, 256 bytes E5, F7)	
LP27:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData		;Get next byte
	cpi r16,0xFB
	brne LP27
	
 	ldi ZH, high(TIbuffer)	;Get address to buffer
	ldi ZL, low(TIbuffer)	; "
	ldi r18, 0x00		;256 bytes per sector
lp28:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16, fdcData	;Get next byte
	st Z+, r16		;Save to buffer
	dec r18
	brne LP28
	
	sbi PortE, 2		;Put TI on hold while process command
	rcall Track2Arg		;Set arg to SD sector for TI DISK
	rcall TI_SD_wr		;Write to SD
	
	dec r20			;All 9 sectors done?
	brne LP25      
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;All disks names 0-255 sent to TI
; ENTRY:
;
; EXIT:
;	
; Registers used r16 r20 r21	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
SendNames:
;Send disk numbers DSK1-3 
	ldi r16, 0x01
	sts arg, r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1, r16
	sts arg+2, r16
	sts arg+3, r16		; (MSB)
	rcall ReadMMC           ; Read sector 1
	ldi ZH, high(SDbuffer+4)	; Point to disk #s in buffer
	ldi ZL, low(SDbuffer+4)	; "
   
	ldi r20, 3
lp93:	ld r16, Z+		;Mov char from buffer to fdcData
	sts fdcData,r16		;
	cbi PortE, 2		;Release TI
	rcall WaitTIread	;Wait for TI to read
	sbi PortE, 2		;Put TI on hold
	dec r20
	brne lp93
	
;Send Names
	clr r21			;Start at disk 0
lp91:	rcall Disk2Sector	;Convert disk# in R21 to sector address
	rcall ReadMMC           ;Read sector
	ldi ZL, low(SDbuffer)	;Get address to buffer
	ldi ZH, high(SDbuffer)	; "
	
	ldi r20, 10
lp92:	ld r16, Z+		;Mov char from buffer to fdcData
	sts fdcData,r16		;
	cbi PortE, 2		;Release TI
	rcall WaitTIread	;Wait for TI to read
	sbi PortE, 2		;Put TI on hold
	dec r20
	brne lp92
	
	inc r21			;Next disk
	brne LP91		;If roll over then finished
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Change disk in drive
; ENTRY:
;	From TI	- r20 Drive 1-3 
;	From TI - r21 Disk 0-255
; EXIT:
;	
; Registers used r16 r17 r20 r21	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChgDisk:
;Get drive number from TI
	cbi PortE, 2		;Release TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r20, fdcData	;Get Drive number
	andi r20, 0x03		;
	dec r20			;DSK 1-3 to 0-2
;Get disk number from TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r21, fdcData	;Get disk number
	sbi PortE, 2		;Put TI on hold
	
;Put new disk number in sector 1	
	ldi r16, 0x01
	sts arg, r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1, r16
	sts arg+2, r16
	sts arg+3, r16		; (MSB)
	rcall ReadMMC           ; Read sector 1
	ldi ZH, high(SDbuffer)	; Get address to buffer
	ldi ZL, low(SDbuffer)	; "
; Drive number r20
; Disk number r21
	add ZL, r20		;Point to drive in sector 1		
	clr r16			; "
	adc ZH, r16		; "
	std Z+4, r21		; Save new disk number
	rcall WriteMMC          ; Write sector 1 back to SD
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; Multiply DISK number and store sector address at DSKx addresses
; Entry:
;	r21 = disk number
;
; Exit:	    
;	Disk sector address store in arg also in r0-r3	
;	Registers used r0-r5 r16 r17 Z
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disk2Sector:
 	mov r5, r21		    ;Save dsisk number

	ldi ZH, high(StartSector)   ; "
	ldi ZL, low(StartSector)    ; "
	ld r0, Z+		    ;initilize to start sector
	ld r1, Z+		    ; "
	clr r2			    ; "
	clr r3			    ; "
	ld r16, Z+		    ;Get step sectors
	ld r17, Z+		    ; "   

	tst r5			    ; Test for Disk number zero
	breq jp90		    ; skip if zero
lp90:	rcall Add32_16		    ;Multiply disk number by step
	dec r5			    ; "
	brne LP90		    ; "
	
jp90:	ldi ZH, high(arg)	    ;Place result in argument
	ldi ZL, low(arg)	    ; "
 	st Z+, r0
	st Z+, r1	
	st Z+, r2	
	st Z+, r3
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; Add 16 bits to 32 bits (lsbyte first)
; Entry		r0,r1,r2,r3 + r16,r17 
; Exit result	r0,r1,r2,r3
; r4 cleared, r16,r17 not destroyed	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Add32_16:	
	clr r4
	add r0, r16  ;add low byte
	adc r1, r4
	adc r2, r4
	adc r3, r4
	add r1, r17 ;add high byte
	adc r2, r4
	adc r3, r4
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; USART routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USARTInit:
	out UBRR0L, r16			  ;Set Baud rate
	out UBRR0H, r17
	ldi r16, (1<<URSEL0)|(3<<UCSZ00)	  ;8N1
	out UCSR0C, r16
	ldi r16, (1<<RXEN)|(1<<TXEN)	  ;Enable receive & transmit
	out UCSR0B, r16
	ldi r16, (1<<U2X)		    ;Double the baud rate
	out UCSR0A, r16
	ret
USARTRead:
	sbis	UCSR0A, RXC		  ;Wait until data is available
	rjmp USARTRead
	in r16, UDR			  ;Get received data
	ret
USARTWrite:
	sbis	UCSR0A, UDRE		   ;Wait until transmit is ready
	rjmp USARTWrite
	out UDR, r16			   ;Send data
	ret
USARTFlush:
	sbis UCSR0A, RXC
	ret
	in r16, UDR
	rjmp USARTFlush
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; SPI routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPIInit:
	ldi r16, (1<<SPE)|(1<<MSTR)|(3<<SPR0)	;En SPI, Master, fosc/128(125k)
	out SPCR, r16	;DORD=MSB, CPOL=rising, CPHA=LeadSample/TrailSetup
;	ldi r16,(1<<SPI2X)			; SPI double speed
;	out SPSR,r16	
	ret
SPIRead:
	ser r16			;Transmit ones to receive byte
SPIWrite:
	out SPDR, r16		;Send transmit byte
SPIWait:	
	sbis SPSR, SPIF		;Wait Fot Transmission complete
	rjmp SPIWait
	in	r16, SPDR	; Get received byte
	ret
FullThrottle:
	cbi SPCR, SPR0
	cbi SPCR, SPR1
	SBI SPSR, SPI2X
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Access EXFAT find file TIVOL000
;	
;************************************************************************************
; Process Master Boot Sector
;************************************************************************************
FindTIVOL:
	clr r16				;Get MBR sector
	sts arg, r16			; (LSB) sector 00 00 00 00
	sts arg+1, r16
	sts arg+2, r16
	sts arg+3, r16			; (MSB)
	rcall ReadMMC           	; First 512 sector (uses ZL & ZH)
		
	ldi ZL, low(SDbuffer+0x1C6)	;Save VBR in Offset
	ldi ZH, high(SDbuffer+0x1C6)	; "
	ldi YL, low(Offset)		; "
	ldi YH, high(Offset)		; "
	rcall mov4

;************************************************************************************
; Process Volume Boot Sector
;************************************************************************************
	ldi ZL, low(Offset)		;Put vbr in arg
	ldi ZH, high(Offset)		;
	ldi YL, low(arg)    		; "
	ldi YH, high(arg)   		; "
	rcall mov4
	rcall ReadMMC           	; Get VBR sector	
	
	ldi ZL, low(SDbuffer)		;Point to buffer
	ldi ZH, high(SDbuffer)		;
	ldi YL, low(EXFATstr<<1)
	ldi YH, high(EXFATstr<<1)
	rcall cmpstr
	brne DiskErrRly			;Partition is not EXFAT
	
	ldi YL, low(SDbuffer+0x58)	;Save HeapOffset+VBR
	ldi YH, high(SDbuffer+0x58)	; "
	ldi XL, low(OffSet)    		; "
	ldi XH, high(Offset)   		; "
	rcall AddDword			; Result in Offset

	ldi ZL, low(SDbuffer+0x60)	;Get RootDirectory cluster
	ldi ZH, high(SDbuffer+0x60)	; "
	ld r16, Z			; Start cluster - 2
	dec r16				;
	dec r16				;
	st Z, r16			;
	ldi YL, low(arg)    		; "
	ldi YH, high(arg)   		; "
	rcall mov4

	ldi ZL, low(SDbuffer+0x6D)	;Point to SectorsPerClusterShift
	ldi ZH, high(SDbuffer+0x6D)	;
	ld r19, Z			;
	sts SectorsPerCluster, r19 	;Save SectorsPerClusterShift
	rcall LslArg			;RootDirectory * SectorsPerClusterShift

;************************************************************************************
; Process Root Directory Sector	(Find VOLUMES folder)
;************************************************************************************
	ldi XL, low(arg)		;Add VBR+HeapOffset to RootDirectory in arg
	ldi XH, high(arg)		; "
	ldi YL, low(OffSet)    		; "
	ldi YH, high(Offset)   		; "
	rcall AddDword			; "
	rcall ReadMMC           	;Get RootDirectory sector
	    
	ldi ZL, low(SDbuffer)		;Point to buffer
	ldi ZH, high(SDbuffer)		;
	ldi YL, low(VOLstr<<1)
	ldi YH, high(VOLstr<<1)

LP06:	ld r16, Z
	cpi r16, 0xC1			;Check for type C1 entry
	brne JP06
	rcall cmpstr
	breq JP03

JP06:	adiw ZH:ZL, 32			;Next entry
	ldi R16, low(SDbuffer+512)
	cp ZL, r16			;Check end of buffer
	brne LP06  
	ldi R16, high(SDbuffer+512)
	cp ZH, r16			;Check end of buffer
	brne LP06  
DiskErrRly:
	rjmp DiskErr			;VOLUMES not found

JP03:	
 	sbiw ZH:ZL, 32			;Back up from type C1 entry to C0 entry
 	adiw ZH:ZL, 20			;Point to VOLUMES folder cluster dword at 20
    	ld r16, Z			; Start cluster - 2
	dec r16				;
	dec r16				;
	st Z, r16			;
	ldi YL, low(arg)    		; "
	ldi YH, high(arg)   		; "
	rcall mov4
	lds r19, SectorsPerCluster
	rcall LslArg			;VOLUMES folder * SectorsPerCluster

;************************************************************************************
; Process VOLUMES Sector	(Find TIVOL000 file sector)
;************************************************************************************
	ldi XL, low(arg)		;Add VBR+HeapOffset to VOLUMES folder in arg
	ldi XH, high(arg)		; "
	ldi YL, low(Offset)    		; "
	ldi YH, high(Offset)   		; "
	rcall AddDword			; "
	rcall ReadMMC           	;Get VOLUMES folder sector
	
	ldi ZL, low(SDbuffer)		;Point to buffer
	ldi ZH, high(SDbuffer)		;
	ldi YL, low(TIVOLstr<<1)
	ldi YH, high(TIVOLstr<<1)
	
LP04:	ld r16, Z
	cpi r16, 0xC1			;Check for type C1 entry
	brne JP04
	rcall cmpstr
	breq JP05			;TIVOL000 found

JP04:	adiw ZH:ZL, 32			;Next entry
	ldi R16, low(SDbuffer+512)
	cp ZL, r16			;Check end of buffer
	brne LP04  
	ldi R16, high(SDbuffer+512)
	cp ZH, r16			;Check end of buffer
	brne LP04  
	rjmp DiskErr			;TIVOL000 not found

JP05:	sbiw ZH:ZL, 32			;Back up from type C1 entry to C0 entry
	adiw ZH:ZL, 20			;Point TIVOL000 file cluster dword at 20
        ld r16, Z			; Start cluster - 2
	dec r16				;
	dec r16				;
	st Z, r16			;
	ldi YL, low(arg)    		; TIVOL000 file cluster
	ldi YH, high(arg)   		; "
	rcall mov4
	lds r19, SectorsPerCluster
	rcall LslArg			;TIVOL000 file * SectorsPerCluster

	ldi XL, low(arg)		;Add VBR+HeapOffset to TIVOL000 file in arg
	ldi XH, high(arg)		; "
	ldi YL, low(OffSet)    		; "
	ldi YH, high(OffSet)   		; "
	rcall AddDword			;
	lds r16, arg			;Save TIVOL000 start sector
	sts StartSector, r16		; "
	lds r16, arg+1			; "
	sts StartSector+1, r16		; " 

	ldi YL, low(arg)    		;Z left pointing to file size at 24
	ldi YH, high(arg)   		;file size is qword but we will never exceed dword
	rcall mov4
		
	lds r19, SectorsPerCluster
	ldi r16, 9
	add r19, r16
	rcall LsrArg			;Divide by SectorsPerCluster + 512 bytes per sector
	brtc JP01			;If t not set then no carry (no remainder)
	lds ZL, arg
	lds ZH, arg+1
	adiw ZH:ZL, 1
	sts arg, ZL
	sts arg+1, ZH
JP01:	lds r19, SectorsPerCluster
	rcall LslArg			;Size in clusters back to size in sectors

	lds r16, arg			;Save sector step
	sts StepSectors, r16		; "
	lds r16, arg+1			; "
	sts StepSectors+1, r16		; 
	
	sez				;Set Z bit (No error)
DiskErr:				;Return error, Z bit cleared
	ret				;On return will set disk ready status	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	
; Low level SD card access
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Send command to MMC, Uses cmd resp r16 r17 r18 nz=error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendMMC:
    ;4.8ms delay, PNY 1GB had trouble without delay
    	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
		
	ldi r16, 0xFF		;
       	rcall SPIWrite	;
	lds r16,cmd		; Send the command byte
	rcall SPIWrite	;
	lds r16, arg+3		; Send 4 argument bytes starting with MSB
	rcall SPIWrite	;
	lds r16, arg+2		;
	rcall SPIWrite	;
	lds r16, arg+1		;
	rcall SPIWrite	;
	lds r16, arg		;
	rcall SPIWrite	;
	lds r16, crc		; Send the CRC7 byte (always use 95)
       	rcall SPIWrite	;
			
WaitResp:
	clr r18
LP10:
    ;.69ms delay, PNY 1GB had trouble without delay	
	rcall delay1ms		
				
	rcall SPIRead	;
	lds r17, resp
	cp r16,r17		; expected response?
	breq JP11		; YES - return
	dec r18			; waiting period is over?
       	brne LP10		; NO - keep waiting
	rcall SendErrorSPI	;
	clz			; Clear zero flag for time out
JP11:	ret			;

    
;********************************************************************
; Init SD/MMC memory card
;******************************************************************** 
MMCInit:	
	sbi PortB, CS		    ; disable MMC
	ldi r17, 10		    ; Send 80 dummy clocks
LP20:
	rcall SPIRead	    ;
       	dec R17			    ;
	brne LP20		    ;
        cbi PortB, CS		    ; enable MMC         
SendCMD0:
	ldi r16, 0x40		    ; CMD0 GO_IDLE_STATE
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x00000000
	sts arg+1, r16              ;	
	sts arg+2, r16              ;	
	sts arg+3, r16              ; MSB
	ldi r16, 0x95
       	sts crc, r16
	ldi r16, 1
	sts resp, r16		    ; expected response cnt 8
	rcall SendMMC		    ;
       	brne SendCMD0		    ; Expected response timed out
SendCMD8:
	ldi r16, 0x48		    ; CMD8 SEND_IF_COND
	sts cmd, r16
	ldi r16, 0xAA		    ; LSB
	sts arg, r16                ; 0x000001AA
	ldi r16, 0x01		    ;
	sts arg+1, r16              ;
	clr r16			    ;
	sts arg+2, r16              ;
	sts arg+3, r16              ; MSB
	ldi r16, 0x87
	sts crc, r16
	ldi r16, 1		    ; Response V2=0x01 0x000001AA or V1=0x05
	sts resp, r16
	rcall SendMMC               ; 
	brne SendCMD1
	rcall SPIRead		    ; need to clear 0x000001AA
	rcall SPIRead		    ;	
        rcall SPIRead		    ;	      	
	rcall SPIRead		    ;			; 
			
;ACMD41 (CMD55+CMD41)			
SendCMD55:
	ldi r16, 0x77		    ; CMD55 APP_CMD
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x00000000
	sts arg+1, r16              ;	
	sts arg+2, r16              ;	
	sts arg+3, r16              ; MSB
	ldi r16, 0xFF
       	sts crc, r16
	ldi r16, 1
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD55		    ;  Expected response timed out	
SendCMD41: 	
	ldi r16, 0x69		    ; CMD41 SD_SEND_OP_COND
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x40000000
	sts arg+1, r16              ;
	sts arg+2, r16              ;
	ldi r16, 0x40
	sts arg+3, r16              ; MSB
	ldi r16, 0xFF
       	sts crc, r16
	clr r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD55		    ;  Expected response timed out
	rjmp SendCMD58

SendCMD1:
	ldi r16, 0x41		    ; CMD1 SEND_OP_COND
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x00000000
	sts arg+1, r16              ;	
	sts arg+2, r16              ;	
	sts arg+3, r16              ; MSB
	ldi r16, 0xFF
       	sts crc, r16
	clr r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD1		    ;  Expected response timed out
   			
SendCMD58:
	ldi r16, 0x7A		    ; CMD58 READ_OCR
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x00000000
	sts arg+1, r16              ;	
	sts arg+2, r16              ;	
	sts arg+3, r16              ; MSB
	ldi r16, 0xFF
       	sts crc, r16
	clr r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD58		    ;  Expected response timed out

	ldi ZH, high(SDbuffer)	    ; Get address to buffer
	ldi ZL, low(SDbuffer)	    ; "
	ldi R19, 4
LP21:
	rcall SPIRead		    ; Get MSByte 1 of 4 OCR register
	st Z+, r16		    ; Save OCR to buffer
	dec R19
	brne LP21
	lds r16, SDbuffer
	sts ocr, r16		    ; bit6=1 SDHC

SendCMD9:
	ldi r16, 0x49		    ; CMD9 READ_CSD
	sts cmd, r16              
       	clr r16			    ;
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
	brne SendCMD9		    ; Expected response timed out
	ldi r16, 0xFE
	sts resp, r16
	rcall WaitResp		    ; Wait for FE Start
	brne SendCMD9
	ldi r19, 18
LP22:	
	rcall SPIRead
	dec r19
	brne LP22

SendCMD10:
    	ldi r16, 0x4A		    ; CMD10 READ_CID
	sts cmd, r16              
       	clr r16			    ;
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
	brne SendCMD10		    ; Expected response timed out
	ldi r16, 0xFE
	sts resp, r16
	rcall WaitResp		    ; Wait for FE Start
	brne SendCMD10
    	ldi r19, 18
LP23:	
	rcall SPIRead
	dec r19
	brne LP23

	rcall FullThrottle
			
; Let fall thru to Set Block			
;********************************************************************
; CMD16 SET_BLOCKLEN default 512
; The only valid block length for write is 512!
; Read is 1 to 2048
;********************************************************************
SetBlockMMC: 
	cbi PortB, CS		    ; enable MMC         
	ldi r16, 0x50		    ; CMD16 SET_BLOCKLEN
	sts cmd, r16              
       	clr r16			    ; LSB
	sts arg, r16                ; 0x00000200 (512 block)
	ldi r16, 2
	sts arg+1, r16              ;
	clr r16
	sts arg+2, r16              ;	
	sts arg+3, r16              ; MSB
	clr r16
	sts crc, r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne SetBlockMMC	    ; Expected response timed out
	sbi PortB, CS		    ; Disable MMC
	ret 							;

;********************************************************************
; CMD24 WRITE_BLOCK 512 bytes
; Entry ARG = 4 byte sector
; Exit nz=write error
;********************************************************************
WriteMMC:			    ;Write 1st 256 bytes of sector
	cbi PortB, CS		    ; enable MMC   
	rcall SaveArg		    ; Save argument, in case multipled
	
	lds r16, ocr
	sbrs r16, ccs		    ; Skip bit 6 is 1 (SDHC)
	rcall Mul512Arg		    ; bit 6 is 0 (SDSC)
LP40:
	ldi r16, 0x58		    ; CMD24 WRITE_BLOCK
	sts cmd, r16 
	clr r16
	sts crc, r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne LP40		    ; Expected response timed out
	
	rcall SPIRead		    ; write prefix (Read writes FFFF)
	rcall SPIRead
	ldi r16, 0xFE		    ; Send start data token
	rcall SPIWrite
	
	ldi ZH, high(SDbuffer)	    ; Get address to buffer
	ldi ZL, low(SDbuffer)	    ; "
	clr R19			    ; Write 256 bytes to SD
;Write 1st 256 bytes of sector	
LP41:
	ld r16,Z+
	rcall SPIWrite		    ; Write data byte
	dec R19
	brne LP41
;Write 2nd 256 bytes of sector    		 
LP42:
	ld r16,Z+
	rcall SPIWrite		    ; Write data byte
	dec R19
	brne LP42				
	rcall SPIRead		    ; write 2 bytes CRC 0xFF (Read writes FFFF)
	rcall SPIRead		    ;  "
	    
	rcall SPIRead		    ; was data accepted			
	andi r16, 0x1F
	cpi r16, 5
	brne JP45
	ldi r16, 0xFF		    ; wait for 0xFF
	sts resp, r16
	rcall WaitResp
	brne JP45
	rcall RestoreArg
	sbi PortB, CS		    ; Disable MMC
	sez			    ;Set zero fla
       	ret			    ; normal return z-flag set
JP45:
	rcall RestoreArg
	rcall SendErrorSPI         
	sbi PortB, CS		    ; Disable MMC
	clz			    ;Clr zero flag
	ret			    ; write error return z-flag clear
 			
			
      		
;********************************************************************
; CMD17 READ_BLOCK 512 bytes
; Entry ARG = 4 byte sector
;********************************************************************
ReadMMC:			    ;Read 1st 256 bytes of sector
	cbi PortB, CS		    ; enable MMC   
	rcall SaveArg		    ; Save argument, in case multipled
	
	lds r16, ocr
	sbrs r16, ccs		    ; Skip bit 6 is 1 (SDHC)
	rcall Mul512Arg		    ; bit 6 is 0 (SDSC)
LP50:
	ldi r16, 0x51		    ; CMD17 READ_SINGLE_BLOCK
	sts cmd, r16 
	clr r16
	sts crc, r16
	sts resp, r16		    ; expected response
	rcall SendMMC		    ;
       	brne LP50		    ; Expected response timed out
	
	ldi r16, 0xFE		    ; Send start data token
	sts resp, r16
	rcall WaitResp		    ; Wait for FE Start
	brne LP50
;Read 1st 256 bytes of sector	
	ldi ZH, high(SDbuffer)	    ; Get address to buffer
	ldi ZL, low(SDbuffer)	    ; "
	clr R19			    ; Always read 256 the size of buffer
LP51:
	rcall SPIRead		    ; Get data byte
	st Z+, r16
	dec R19
	brne LP51
;Read 2nd 256 bytes of sector    		 
LP52:
	rcall SPIRead		    ; Get data byte
	st Z+, r16
	dec R19
	brne LP52		
	rcall SPIRead		    ; read 2 bytes CRC	
	rcall SPIRead		    ; and discard	
	sbi PortB, CS		    ; Disable MMC
 	rcall RestoreArg
   	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Send error command/response to PC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendErrorSPI:
       	rcall USARTWrite	    ; Send response received
	lds r16, resp		    
	rcall USARTWrite	    ; Send expected response
	lds r16, cmd
	rcall USARTWrite	    ; Send cmd used
	dec r10
ErrLP:	
	breq ErrLP		    ; Keep from runnig away, Until reset
	ret			    ; Fail 2 or 3 times on start, Just return 
	
SendErrorMedia:
	nop
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
delay1ms:		;  15431x.0625us aprox 1ms, not exact(.965ms)
	push r16	;   2
	push r17	;   2
	ldi r17, 20	;   1
	clr r16		;   1
dly1:	dec r16		; 768x20=15360          
        brne dly1	; 
	dec r17		; 3x20=60   
	brne dly1
	pop r17		;   2
	pop r16		;   2
	ret		;   1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
 SaveArg:   
    	lds r6, arg		; Save argument, in case multipled
  	lds r7, arg+1
  	lds r8, arg+2
  	lds r9, arg+3
	ret
RestoreArg:
	sts arg+3, r9		; Restore argument
	sts arg+2, r8 
	sts arg+1, r7  
	sts arg, r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Mul512Arg:
	ldi r19, 9		; multiply arg by 512
LslArg:				; shift arg left per r19
LP60:	
	lds r16, arg
	lsl r16
	sts arg, r16
	lds r16, arg+1
	rol r16
	sts arg+1, r16
	lds r16, arg+2
	rol r16
	sts arg+2, r16
	lds r16, arg+3
	rol r16
	sts arg+3, r16
	dec r19
	brne LP60
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmpstr:	push ZL
	push ZH
	push YL
	push YH
		
	movw r17:r16,ZH:ZL  ;LPM only works with Z
	movw ZH:ZL,YH:YL
	movw YH:YL,r17:r16
  	
LP07:	lpm r16, Z+
	cpi r16, 0xFF	;Check end of string
	breq JP07
	ld r17, Y+
	cp r16, r17
	brne JP07	;Not equal, return
	rjmp LP07	;Next char
JP07:	pop YH
	pop YL
	pop ZH
	pop ZL
	ret		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov4:	ldi r16, 4		    ;
LP01:	ld r17, Z+ 
	st Y+, r17
	dec r16
	brne LP01
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add Dword pointed to by X & Y Result pointed to by X
AddDword:
	ld r16, X
	ld r17, Y+
	add r16, r17
	st X+, r16

	ld r16, X
	ld r17, Y+
	adc r16, r17
	st X+, r16

	ld r16, X
	ld r17, Y+
	adc r16, r17
	st X+, r16

	ld r16, X
	ld r17, Y+
	adc r16, r17
	st X+, r16
	ret

; shift arg right per r19
LsrArg:	clt			
LP61:	lds r16, arg+3
	lsr r16
	sts arg+3, r16
	lds r16, arg+2
	ror r16
	sts arg+2, r16
	lds r16, arg+1
	ror r16
	sts arg+1, r16
	lds r16, arg
	ror r16
	sts arg, r16
	brcc JP61
	set		;Set t bit if carry
JP61:	dec r19
	brne LP61
	ret
	
