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
; INT2:	XL XH r13 r14 r15			
; SD error count: r10			
; Save arg: r6-r9
;			
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.DSEG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;FDC variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fdcRegisters:
fdcStatus:	.byte 1			;TI 5FF0 Read Status
fdcTrack:	.byte 1			;TI 5FF2/5FFA Rd/Wr Track Register
fdcSector:	.byte 1			;TI 5FF4/5FFC Rd/Wr Sector Register
fdcData:	.byte 1			;TI 5FF6/5FFE Rd/Wr Data Register
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;SD variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.equ CS = PB4
ocr:		.byte	1
		.equ ccs = 6	;bit 6
cmd:		.byte	1
arg:		.byte	4	;LSB -- MSB		
crc:		.byte	1
resp:		.byte	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Disk variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
SectorsPerCluster:		;in Powers of 2 (Number of left shifts to use)
		.byte	1
Offset:		.byte	4	;LSB -- MSB	
StartSector:	.byte	2
StepSectors:	.byte	2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Serial interrupt variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
SerWrPtr:	.byte	1
SerRdPtr:	.byte	1
SerCnt:		.byte	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; XMODEM variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.equ SOH = 1
	.equ EOT = 4
	.equ CAN = 24
	.equ NAK = 21
	.equ ACK = 6
	.equ CR = 13
PAKNUM:	.byte 2		;16 bit packet# (LSByte - MSByte)
CHKSUM:	.byte 1
CRCFLG:	.byte 1
TELFLG:	.byte 1
;CRC r1:r0		;also uses r2
	
VAR_END:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		.equ Serbuffsize = 160
Serbuffer:	.byte	Serbuffsize
TIbuffer:	.byte	256
SDbuffer:	.byte	512
	
;Stack area	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Interrupts vector tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	.CSEG		;8515 use rjmp 162 use jmp
	.org $000
	jmp setup	;Reset Handler
	.org URXC0addr	;8515 URXCaddr,162 URXC0addr
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
    	in r13,SREG			;Save SREG			1
	mov r14,r16			;				1
	in r16,PinB			;Get FDC address		1
	andi r16,0x03			;				1
	clr r15				;				1								
	ldi XH,high(fdcRegisters)	;Point X to FDC_Registers base	1
	ldi XL,low(fdcRegisters)	; "				1
	add XL,r16			;add FDC address offset		1
	adc XH,r15			; "				1
	ld r15,X			;Get data in FDC register	2
	out PortA,r15			;Send it to TI			1
	sbr r16,1<<iflag		;Set our interrupt flag		1
	nop				;				1
	nop				;				1
 ;Need 13-19 cycles to here,Min 15 without errors			15
	
	sbic PinE,webit		;Test !we
	rjmp isr2end			;Read if 1
	in r15,PinC			;Get  write data
	com r15				;TI sends inverted data
	sbr r16,1<<wflag		;Set write flag
	cpi r16,0x84			;Check If Command
	brne NotCMD			; "
	adiw X,4			;Point to Command registers
NotCMD:	
	st X,r15			;Write data to FDC register
isr2end:
	sts flags,r16			;
	mov r16,r14			;
	out SREG,r13			;Restore SREG	
	reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; USART RX Complete Interrupt Handler	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
USART_RXC:
	push r16
	in r16,SREG	;Push SREG
	push r16	; "
	push ZH
	push ZL
	
;Move Stat & Char to buffer
	lds r16,SerCnt
	inc r16
	sts SerCnt,r16

	ldi ZH,high(Serbuffer)
	ldi ZL,low(Serbuffer)
	lds r16,SerWrPtr
	add ZL,r16		;
;	clr r17
;	adc ZH,r17
	
	inc r16
	cpi r16,Serbuffsize		;
	brne jp00
	clr r16
jp00:	sts SerWrPtr,r16

;	in r16,UCSR0A		;Get status
;	st Z+,r16		;Put in buffer
	in r16,UDR		;Get data (We know data is there because of Recv interrupt)
	st Z,r16		;Put in buffer
	
;Check If AT+#xCRLF is in buffer (x is Char used below)
	cpi r16,10	;check if LF
	brne jp09
	
	ld r16,-Z
	cpi r16,13	;check if CR
	brne jp09

	sbiw Z,4
	ld r16,Z+
	cpi r16,'A'	;
	brne jp09

	ld r16,Z+
	cpi r16,'T'	;	
	brne jp09

	ld r16,Z+
	cpi r16,'#'	;
	breq jp08
jp09:	jmp RXCrtn
 
jp08:	ld r16,Z	; 

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
	
chkR:	cpi r16,'R'		    ;Send reg 16-31,SREG,Ret PC
	brne chkS
	in ZH,SPH
	in ZL,SPL
	adiw Z,1
	ldi r17,19
	rjmp TXLP0
	
chkS:	cpi r16,'S'		    ;Send all calls on stack
	brne chkB
	in ZH,SPH
	in ZL,SPL
	adiw Z,17
	ldi r17,low(RAMEND)
	sub r17,ZL
	adiw Z,1
	rjmp TXLP0
	
chkB:	cpi r16,'B'		    ;Send Serial buffer
	brne chkT
	ldi r17,Serbuffsize
	ldi ZH,high(Serbuffer)	    ; Get address to Serial buffer
	ldi ZL,low(Serbuffer)	    ; "
	rjmp TXLP0
	
chkT:	cpi r16,'T'		    ;Send TIbuffer
	brne chkU
	clr r17
	ldi ZH,high(TIbuffer)	    ;Point to TIbuffer
	ldi ZL,low(TIbuffer)	    ; "
	rjmp TXLP0
	
chkU: 	cpi r16,'U'		    ;Send upper 256 bytes of SDbuffer
	brne chkL
	clr r17
	ldi ZH,high(SDbuffer)	    ;Point to SDbuffer
	ldi ZL,low(SDbuffer)	    ; "
	rjmp TXLP0
	
chkL: 	cpi r16,'L'		    ;Send lower 256 bytes of SDbuffer
	brne chkV
	clr r17
	ldi ZH,high(SDbuffer+128)   ;Point to lower SDbuffer
	ldi ZL,low(SDbuffer+128)    ; "
	rjmp TXLP0
	
chkV: 	cpi r16,'V'	;Send all sram (variables) except buffers
	brne jp13
	ldi r17,VAR_END-SRAM_START  ;Count between fdcRegisters & buffers
	ldi ZH,high(SRAM_START)	    ; Get sram start address
	ldi ZL,low(SRAM_START)	    ; "
	
TXLP0:	ld r16,Z+
lp08:	sbis UCSR0A,UDRE	;Wait until transmit is ready
	rjmp lp08
	out UDR,r16		;Send data
	dec R17
	brne TXLP0
	
jp13:	pop r17
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
	
RXCrtn:	pop ZL
	pop ZH
	pop r16		;pop SREG
 	out SREG,r16	; "
	pop r16
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
	ldi r16,low(RAMEND)		;Init stack
	out spl,r16			;	"
	ldi r16,high(RAMEND)		;	"
	out sph,r16			;	"
;Setup ports
	ser	r16			;PortA (FF) output mode for TI read
	out DDRA,r16			; "
	clr	r16			;PortC (00) input mode for TI write
	out DDRC,r16			; "
	ldi	r16,0b10110000		;SCK,MI,MO,CS,0,0,A1,A0
	out DDRB,r16			;O  ,I ,O ,O ,I,I,I ,I
	sbi PortB,PB6			;Pullup MISO
	ldi	r16,0b00001010		;Side,DR3,DR2,DR1,HLD,0,TDX,RXD
	out DDRD,r16			;I   ,I  ,I  ,I  ,O  ,I,O  ,I
	ldi	r16,0b00000100		;0,0,0,0,0,!Ready,!WE,!INT
	out DDRE,r16			;I,I,I,I,I,O     ,I  ,I
	
	ldi r16,0x80			;Set TI to read status NotReady 
	out PortA,r16			;Until Int2 enabled	
	cbi PortE,rdybit		;Enable TI hardwire

	in r16,EMCUCR			;Set INT2 falling edge trigger
	cbr r16,1<<ISC2		; " ISC2=bit0 same as andi r16,0xFE
	out EMCUCR,r16			; "
	in r16,GICR			;Enable INT2
	sbr r16,1<<INT2		; " INT2=bit5 same as ori r16,32
	out GICR,r16			; "	
;Set status				;NotReady  track0  busy
	ldi r16,0x04			;b7=0      b2=1    b0=0
	sts fdcStatus,r16		;
	clr r16				; 
	sts fdcTrack,r16		;
	sts fdcSector,r16		;
	sts fdcData,r16		;
	sts fdcCommand,r16		;
	cbi PortD,3			;data not ready
;Setup USART				;baud @ 16MHz
	ldi r17,0			;230.4k=0,3 115.2k=0,8(double 8&16)
	ldi r16,8			;Disabled doubling
	rcall USARTInit	
	in r16,UCSR0B			;Enable RXC interrupt
	sbr r16,1<<RXCIE		; "
	out UCSR0B,r16			; "	
;Setup SPI
	ldi r16,16
	mov r10,r16			;SD error count,So it doesn't run away
	rcall SPIInit  
	rcall MMCInit
;Setup Drives	
SetupStartStep:  
	rcall FindTIVOL		;Find TIVOL000,Save Start and Step
	breq SetupDSK
	ldi r16,0x80		;disk error,not ready
	sts fdcStatus,r16	;
;Get DSKx addresses from SD sector 1    
SetupDSK:
	ldi r16,0x01
	sts arg,r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1,r16
	sts arg+2,r16
	sts arg+3,r16		; (MSB)
	rcall ReadMMC           ; First half 512 sector (uses ZL & ZH)
	
;XL & XH ok to use before interrupts are enabled    	
	ldi ZL,low(SDbuffer+4)	    ;
	ldi ZH,high(SDbuffer+4)	    ;

	ld r16,Z+		    ;Get Drive 1 Disk #
	push r16		    ;		    
	ld r16,Z+		    ;Get Drive 2 Disk #
	push r16		    ;
	ld r16,Z+		    ;Get Drive 3 Disk #
	push r16
	
	ldi YL,low(DSK3address)    ;
	ldi YH,high(DSK3address)   ;
	
	ldi r18,3
lp02:	pop r21			    ;Restore disk number (stepping 3 - 1)
	rcall Disk2Sector	    ;Convert disk # to sector address
	st Y+,r0		    ;Save into DSKXaddress
	st Y+,r1		    ;
	st Y+,r2		    ;
	st Y+,r3		    ;
	sbiw Y,8		    ;Back to start of current drive + start preceding drive
	dec r18			    ;
	brne lp02		    ;All 3 drives done 
	
;Set last track for drives
	ldi ZL,low(DSK1address)    ;LSB -- MSB
	ldi ZH,high(DSK1address)   ;
	ldi YL,low(arg)	    ;
	ldi YH,high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC 		    ;First half 512 sector (uses ZL & ZH)
	ldi r16,39
	lds r17,SDbuffer+10
	sbrc r17,2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16,79
	sts DSK1LastTrk,r16
	
	ldi ZL,low(DSK2address)    ;LSB -- MSB
	ldi ZH,high(DSK2address)   ;
	ldi YL,low(arg)	    ;
	ldi YH,high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC		    ;First half 512 sector (uses ZL & ZH)
	ldi r16,39
	lds r17,SDbuffer+10
	sbrc r17,2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16,79
	sts DSK2LastTrk,r16
	
	ldi ZL,low(DSK3address)    ;LSB -- MSB
	ldi ZH,high(DSK3address)   ;
	ldi YL,low(arg)	    ;
	ldi YH,high(arg)	    ;
	rcall mov4		    ;
	rcall ReadMMC		    ;First half 512 sector (uses ZL & ZH)
	ldi r16,39
	lds r17,SDbuffer+10
	sbrc r17,2		    ;Check bit 2 for value 4 in 5 A0	
	ldi r16,79
	sts DSK3LastTrk,r16
	
;Enable interrupts	
	clr r16				;Clear flags
	sts flags,r16			;
	sts SerRdPtr,r16		;Init Serial pointers
	sts SerWrPtr,r16
	sts SerCnt,r16
	sei				;Global enable interrupts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:	clr r16			    ; Clear busy,No errors	
jp02:	sts fdcStatus,r16	    ; "	     
	cbi PortE,2		    ;Release TI
	
lp00:	lds r16,flags		    ;Get flags
	sbrs r16,iflag		    ;Has TI has sent data?
	rjmp lp00
	clr r17			    ;Clear flags
	sts flags,r17		    ; "		    
	
	lds r16,fdcCommand	    ;
	cpi r16,0x00		    ;
	breq lp00
	
	sbi PortE,2		    ;Put TI on hold while process command
	sts fdcCommand,r17	    ;Clear command (r17=0 from above)
;	ldi r17,0x01		    ;Set Busy bit
;	sts fdcStatus,r17	    ; "
	
;	rcall USARTWrite	    ;Send command in r16 (enable for debbuging)
	
;Our Mount Disk command	
fdcCMD81:			    	
	cpi r16,0x81		   
	brne fdcCMD82
	rcall ChgDisk
	rjmp SetupDSK		    ;Setup disk addresses and last track
;Our Send all disk names command		
fdcCMD82:			    
	cpi r16,0x82		    
	brne usartCMD83
	rcall SendNames
	rjmp main
;Read Usart status
usartCMD83:			    
	cpi r16,0x83		    
	brne usartCMD84
	rcall TIrdUsartStat
	rjmp main
;Read Usart data
usartCMD84:			    
	cpi r16,0x84		    
	brne usartCMD85
	rcall TIrdUsartData
	rjmp main
;Write Usart data
usartCMD85:			    
	cpi r16,0x85		    
	brne usartCMD86
	rcall TIwrUsartData
	rjmp main
;Usart Sub Command
usartCMD86:			    
	cpi r16,0x86		    
	brne xmdCMD87
	rcall TIwrUsartSub
	rjmp main
;Xmodem Volume Transfer
xmdCMD87:			    
	cpi r16,0x87		    
	brne fdcCMD0A
	rcall XMODEM
	rjmp main	
;0A Restore (h=1,V=0,r0r1=10)	
fdcCMD0A:			   
	cpi r16,0x0A		    ;
	brne fdcCMD1E
	clr r16			    ;
	sts fdcTrack,r16	    ;Set to track 0
	sts fdcSector,r16	    ;Set to sector 0
	sbr r16,0x04		    ;Set track 0 in status
	rjmp jp02
;1E Seek h=1 V=1 r1r0=10
fdcCMD1E:			    
	cpi r16,0x1E		    ;
	brne fdcCMD5A
	lds r16,fdcData
	sts fdcTrack,r16
	rjmp main
;2x Step not used by TI
;5A Step-in T=1,h=1,V=0,r0r1=10	
fdcCMD5A:			    
	cpi r16,0x5A		    ;
	brne fdcCMD88
	lds r16,fdcTrack
	inc r16
	sts fdcTrack,r16
	rjmp main
;6x Step-out not used by TI
;88 Read sector m=0 S=1 E=0 C=0		    
fdcCMD88:			    
   	cpi r16,0x88		    ;
	brne fdcCMDA8
	rcall TIreadsec
	rjmp main
;A8 Write sector m=0 S=1 E=0 C=0 a=0
fdcCMDA8:			    
	cpi r16,0xA8		    ;
	brne fdcCMDC0
	rcall TIwritesec
mainRLY: rjmp main
;C0 Read ID E=0
fdcCMDC0:			    
	cpi r16,0xC0		    ;
	brne fdcCMDF4
	rcall TIreadID
	rjmp main
;Ex Read track not used by TI
;F4 Write track (E=1)
fdcCMDF4:			    
    	cpi r16,0xF4		    ;
	brne fdcCMDD0
	rcall TIwritetrack
	rjmp mainRLY
;D0 Force interrupt
fdcCMDD0:			    
    	cpi r16,0xD0		    ;Sent after software reset (FTCN =)
	brne mainRLY
	rcall delay1ms
	rjmp SetupDSK		    ;Setup disks in case one was formatted
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIreadID:
	cbi PortE,2		;Release TI
	lds r16,fdcTrack	;Get track
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	clr r16			;Side 0
	sbic PinD,7		;Get Side
	inc r16			;Side 1
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	lds r16,fdcSector	;Get sector
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
 	ldi ZH,high(TIbuffer)	;Get address to buffer
	ldi ZL,low(TIbuffer)	; "
	ldi r18,0x00		;256 bytes per sector
	
	cbi PortE,2		;Release TI
lp24:	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	;Get next byte
	st Z+,r16		;Save to buffer
	dec r18
	brne lp24
	
	sbi PortE,2		;Put TI on hold while process command
	ldi r16,1
	sbis PinD,7		;Test pin,Skip if side 1
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
	sbis PinD,7		;Test pin,Skip if side 1
	clr r16
	sts fdcSide,r16
	rcall Track2Arg		;Set arg to SD sector for TI DISK
	rcall TI_SD_rd		;Get sector from SD
	ldi ZH,high(TIbuffer)	; Get address to buffer
	ldi ZL,low(TIbuffer)	; "
	ldi r18,0x00		;256 bytes per sector
	
	cbi PortE,2		;Release TI
lp13:	ld r16,Z+		;Get next byte
	sts fdcData,r16		;Send to TI
	rcall WaitTIread	; "
	dec r18
	brne lp13
	ret
;	
;Convert TI track&sector to SD sector	
Track2Arg:
	lds r16,fdcTrack
	lds r17,fdcSide
	sbrs r17,0		;Test bit,Skip if side 1	
	rjmp jp10
	lds r17,DSK1LastTrk	;
	sbic PinD,5		;
	lds r17,DSK2LastTrk	;
	sbic PinD,6		;
	lds r17,DSK3LastTrk	;
	sub r16,R17		;Reverse track (0=-39 or -79) 
	neg r16			;Make postive
	inc r17			;
	add r16,r17		;Track + 40 or 80
jp10:	
	ldi r17,9		;Track*9
	mul r16,r17		;Result in r0 r1
	clr r17			;Add sector offset 0-8		
	lds r16,fdcSector	; "
	add r0,r16		; "
	adc r1,r17		; "
	
	;Divide TI sector by 2 to put in upper or lower half of SD sector
	sts TIlowbyte,r0 	;save low byte for bit 0 test
	lsr r1			;Divide 16 bits by 2
	ror r0			; "	"	"
	
	;Add TI sector to DSKx SD start sector address and place in ARG
	ldi ZH,high(DSK1address)   ;
	ldi ZL,low(DSK1address)    ;
	sbic PinD,5		    ;
	adiw Z,4		    ;DSK2address
	sbic PinD,6		    ;
	adiw Z,8		    ;DSK3address

	ld r16,Z+
	add r16,r0
	sts arg,r16
	ld r16,Z+
	adc r16,r1
	sts arg+1,r16
	clr r0			;carry not affected
	ld r16,Z+
	adc r16,r0
	sts arg+2,r16
	ld r16,Z
	adc r16,r0
	sts arg+3,r16
	ret
;	
WaitTIread:
	lds r16,flags		;Get flags
	sbrs r16,iflag		;Has TI read data?
	rjmp WaitTIread
	clr r17			;Clear interrupt flag
	sts flags,r17		; "
	cpi r16,0x83		;Was it read data register
	brne WaitTIread
	ret
WaitTIwrite:
	lds r16,flags		;Get flags
	sbrs r16,iflag		;Has TI written data?
	rjmp WaitTIwrite
	clr r17			;Clear interrupt flag
	sts flags,r17		; "
	cpi r16,0x87		;Was it write data register
	brne WaitTIwrite
	ret
	
TI_SD_rd:
	rcall readmmc		;512 bytes in sdbuffer
	ldi ZL,low(SDbuffer)
	ldi ZH,high(SDbuffer)
	lds r16,TIlowbyte
	sbrc r16,0
	inc ZH			;Add 256 to Z
	ldi YL,low(TIbuffer)
	ldi YH,high(TIbuffer)
;Move 256 bytes from source(Z) to destination(Y)
mov256:	clr r16		
lp03:	ld r17,Z+ 
	st Y+,r17
	dec r16
	brne lp03
	ret	;and send to TI
TI_SD_wr:
	rcall readmmc	//512 bytes in sdbuffer
	ldi ZL,low(TIbuffer)
	ldi ZH,high(TIbuffer)
	ldi YL,low(SDbuffer)
	ldi YH,high(SDbuffer)
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
lp25:	
	cbi PortE,2		;Release TI
	
;Get (FE,Track,Side,Sector,1?,F7)	
lp26:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData		;Get next byte
	cpi r16,0xFE
	brne lp26
	
	rcall WaitTIwrite	;Throw away Track,already loaded

	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	
;	ror r16			;Move bit0 to bit7
;	ror r16			; "
	sts fdcSide,r16		;Save Side
	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	
	sts fdcSector,r16	;Save Sector

;Get (FB,256 bytes E5,F7)	
lp27:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData		;Get next byte
	cpi r16,0xFB
	brne lp27
	
 	ldi ZH,high(TIbuffer)	;Get address to buffer
	ldi ZL,low(TIbuffer)	; "
	ldi r18,0x00		;256 bytes per sector
lp28:	
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData	;Get next byte
	st Z+,r16		;Save to buffer
	dec r18
	brne lp28
	
	sbi PortE,2		;Put TI on hold while process command
	rcall Track2Arg		;Set arg to SD sector for TI DISK
	rcall TI_SD_wr		;Write to SD
	
	dec r20			;All 9 sectors done?
	brne lp25      
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
	ldi r16,0x01
	sts arg,r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1,r16
	sts arg+2,r16
	sts arg+3,r16		; (MSB)
	rcall ReadMMC           ; Read sector 1
	ldi ZH,high(SDbuffer+4)	; Point to disk #s in buffer
	ldi ZL,low(SDbuffer+4)	; "
   
	ldi r20,3
lp93:	ld r16,Z+		;Mov char from buffer to fdcData
	sts fdcData,r16		;
	cbi PortE,2		;Release TI
	rcall WaitTIread	;Wait for TI to read
	sbi PortE,2		;Put TI on hold
	dec r20
	brne lp93
	
;Send Names
	clr r21			;Start at disk 0
lp91:	rcall Disk2Sector	;Convert disk# in R21 to sector address
	rcall ReadMMC           ;Read sector
	ldi ZL,low(SDbuffer)	;Get address to buffer
	ldi ZH,high(SDbuffer)	; "
	
	ldi r20,10
lp92:	ld r16,Z+		;Mov char from buffer to fdcData
	sts fdcData,r16		;
	cbi PortE,2		;Release TI
	rcall WaitTIread	;Wait for TI to read
	sbi PortE,2		;Put TI on hold
	dec r20
	brne lp92
	
	inc r21			;Next disk
	brne lp91		;If roll over then finished
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
	cbi PortE,2		;Release TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r20,fdcData	;Get Drive number
	andi r20,0x03		;
	dec r20			;DSK 1-3 to 0-2
;Get disk number from TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r21,fdcData	;Get disk number
	sbi PortE,2		;Put TI on hold
	
;Put new disk number in sector 1	
	ldi r16,0x01
	sts arg,r16		; (LSB) sector 00 00 00 01
 	clr r16
	sts arg+1,r16
	sts arg+2,r16
	sts arg+3,r16		; (MSB)
	rcall ReadMMC           ; Read sector 1
	ldi ZH,high(SDbuffer)	; Get address to buffer
	ldi ZL,low(SDbuffer)	; "
; Drive number r20
; Disk number r21
	add ZL,r20		;Point to drive in sector 1		
	clr r16			; "
	adc ZH,r16		; "
	std Z+4,r21		; Save new disk number
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
 	mov r5,r21		    ;Save dsisk number

	ldi ZH,high(StartSector)   ; "
	ldi ZL,low(StartSector)    ; "
	ld r0,Z+		    ;initilize to start sector
	ld r1,Z+		    ; "
	clr r2			    ; "
	clr r3			    ; "
	ld r16,Z+		    ;Get step sectors
	ld r17,Z+		    ; "   

	tst r5			    ; Test for Disk number zero
	breq jp90		    ; skip if zero
lp90:	rcall Add32_16		    ;Multiply disk number by step
	dec r5			    ; "
	brne lp90		    ; "
	
jp90:	ldi ZH,high(arg)	    ;Place result in argument
	ldi ZL,low(arg)	    ; "
 	st Z+,r0
	st Z+,r1	
	st Z+,r2	
	st Z+,r3
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; Add 16 bits to 32 bits (lsbyte first)
; Entry		r0,r1,r2,r3 + r16,r17 
; Exit result	r0,r1,r2,r3
; r4 cleared,r16,r17 not destroyed	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Add32_16:	
	clr r4
	add r0,r16  ;add low byte
	adc r1,r4
	adc r2,r4
	adc r3,r4
	add r1,r17 ;add high byte
	adc r2,r4
	adc r3,r4
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; USART routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USARTInit:
	out UBRR0L,r16			;Set Baud rate
	out UBRR0H,r17
	ldi r16,(1<<URSEL0)|(3<<UCSZ00)	;8N1
	out UCSR0C,r16
	ldi r16,(1<<RXEN)|(1<<TXEN)	;Enable receive & transmit
	out UCSR0B,r16
;	ldi r16,(1<<U2X)		;Double the baud rate
;	out UCSR0A,r16
	ret
USARTRead:
	sbis UCSR0A,RXC			;Wait until data is available
	rjmp USARTRead
	in r16,UDR			;Get received data
	ret
USARTWrite:
	sbis UCSR0A,UDRE		;Wait until transmit is ready
	rjmp USARTWrite
	out UDR,r16			;Send data
	ret
USARTFlush:
	sbis UCSR0A,RXC
	ret
	in r16,UDR
	rjmp USARTFlush
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; TI access to USART
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIrdUsartStat:
    	in r16,UCSR0B		;Check if RXC interrupt enabled
	sbrs r16,RXCIE		;Skip if intr set
	rjmp jp16		;Get data from USART
	    
	lds r16,SerCnt
	cpi r16,0
	breq jp17		;Send 0 No data available
	ldi r16,226		;Send 226 status If buffer not 0
	rjmp jp17		;

jp16:	in r16,UCSR0A
jp17:	sts fdcData,r16		;Send to TI
	cbi PortE,2		;Release TI
	ret

TIrdUsartData:
        in r16,UCSR0B		;Check if RXC interrupt enabled
	sbrs r16,RXCIE		;Skip if intr set
	rjmp jp18		;Get data from USART
    
	lds r16,SerCnt
	cpi r16,0
	breq jp19		;Send 0 No data available
	dec r16
	sts SerCnt,r16
	
	ldi ZH,high(Serbuffer)
	ldi ZL,low(Serbuffer)
	lds r16,SerRdPtr	;ptr Status byte
	add ZL,r16		;Point Z to Char byte
;	clr r17			;
;	adc ZH,r17
	inc r16			;ptr next entry
	cpi r16,Serbuffsize
	brne jp14
	clr r16
jp14:	sts SerRdPtr,r16
	ld r16,Z		;Get char from buffer
	rjmp jp19
	
jp18:	in r16,UDR		;Get char from USART
jp19:	sts fdcData,r16		;Send to TI
	cbi PortE,2		;Release TI
	ret 
	 
TIwrUsartData:
	cbi PortE,2		;Release TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData
	rcall USARTWrite
	ret
    
TIwrUsartSub:
	cbi PortE,2		;Release TI
	rcall WaitTIwrite	;Wait for data from TI
	lds r16,fdcData
	sbi PortE,2		;Hold TI

	cpi r16,0		;Flush Buffer
	brne jp20
	rcall USARTFlush
	clr r16			;
	sts SerRdPtr,r16	;Reset pointers
	sts SerWrPtr,r16
	sts SerCnt,r16
	ret

jp20:	cpi r16,1		;Turn on 128 buffer
	brne jp21		;
	in r16,UCSR0B		;Enable RXC interrupt
	sbr r16,1<<RXCIE	; "
	out UCSR0B,r16		; "
	ret			;		

jp21:	cpi r16,2		;Turn off 128 buffer
	brne jp22		;
	in r16,UCSR0B		;Disable RXC interrupt
	cbr r16,1<<RXCIE	; "
	out UCSR0B,r16		; "
jp22:	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
; SPI routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPIInit:
	ldi r16,(1<<SPE)|(1<<MSTR)|(3<<SPR0)	;En SPI,Master,fosc/128(125k)
	out SPCR,r16	;DORD=MSB,CPOL=rising,CPHA=LeadSample/TrailSetup
;	ldi r16,(1<<SPI2X)			; SPI double speed
;	out SPSR,r16	
	ret
SPIRead:
	ser r16			;Transmit ones to receive byte
SPIWrite:
	out SPDR,r16		;Send transmit byte
SPIWait:	
	sbis SPSR,SPIF		;Wait Fot Transmission complete
	rjmp SPIWait
	in	r16,SPDR	; Get received byte
	ret
FullThrottle:
	cbi SPCR,SPR0
	cbi SPCR,SPR1
	SBI SPSR,SPI2X
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
	sts arg,r16			; (LSB) sector 00 00 00 00
	sts arg+1,r16
	sts arg+2,r16
	sts arg+3,r16			; (MSB)
	rcall ReadMMC           	; First 512 sector (uses ZL & ZH)
		
	ldi ZL,low(SDbuffer+0x1C6)	;Save VBR in Offset
	ldi ZH,high(SDbuffer+0x1C6)	; "
	ldi YL,low(Offset)		; "
	ldi YH,high(Offset)		; "
	rcall mov4

;************************************************************************************
; Process Volume Boot Sector
;************************************************************************************
	ldi ZL,low(Offset)		;Put vbr in arg
	ldi ZH,high(Offset)		;
	ldi YL,low(arg)    		; "
	ldi YH,high(arg)   		; "
	rcall mov4
	rcall ReadMMC           	; Get VBR sector	
	
	ldi ZL,low(SDbuffer)		;Point to buffer
	ldi ZH,high(SDbuffer)		;
	ldi YL,low(EXFATstr<<1)
	ldi YH,high(EXFATstr<<1)
	rcall cmpstr
	brne DiskErrRly			;Partition is not EXFAT
	
	ldi YL,low(SDbuffer+0x58)	;Save HeapOffset+VBR
	ldi YH,high(SDbuffer+0x58)	; "
	ldi XL,low(OffSet)    		; "
	ldi XH,high(Offset)   		; "
	rcall AddDword			; Result in Offset

	ldi ZL,low(SDbuffer+0x60)	;Get RootDirectory cluster
	ldi ZH,high(SDbuffer+0x60)	; "
	ldi YL,low(arg)    		; "
	ldi YH,high(arg)   		; "
	rcall mov4
	
	lds r16,arg			; Start cluster - 2
	dec r16				;
	dec r16				;
	sts arg,r16			;

	ldi ZL,low(SDbuffer+0x6D)	;Point to SectorsPerClusterShift
	ldi ZH,high(SDbuffer+0x6D)	;
	ld r19,Z			;
	sts SectorsPerCluster,r19 	;Save SectorsPerClusterShift
	rcall LslArg			;RootDirectory * SectorsPerClusterShift

;************************************************************************************
; Process Root Directory Sector	(Find VOLUMES folder)
;************************************************************************************
	ldi XL,low(arg)		;Add VBR+HeapOffset to RootDirectory in arg
	ldi XH,high(arg)		; "
	ldi YL,low(OffSet)    		; "
	ldi YH,high(Offset)   		; "
	rcall AddDword			; "
	rcall ReadMMC           	;Get RootDirectory sector
	    
	ldi ZL,low(SDbuffer)		;Point to buffer
	ldi ZH,high(SDbuffer)		;
	ldi YL,low(VOLstr<<1)
	ldi YH,high(VOLstr<<1)

lp06:	ld r16,Z
	cpi r16,0xC1			;Check for type C1 entry
	brne jp06
	rcall cmpstr
	breq jp03

jp06:	adiw ZH:ZL,32			;Next entry
	ldi R16,low(SDbuffer+512)
	cp ZL,r16			;Check end of buffer
	brne lp06  
	ldi R16,high(SDbuffer+512)
	cp ZH,r16			;Check end of buffer
	brne lp06  
DiskErrRly:
	rjmp DiskErr			;VOLUMES not found

jp03:	
 	sbiw ZH:ZL,32			;Back up from type C1 entry to C0 entry
 	adiw ZH:ZL,20			;Point to VOLUMES folder cluster dword at 20
	ldi YL,low(arg)    		; "
	ldi YH,high(arg)   		; "
	rcall mov4
	
	lds r16,arg			; Start cluster - 2
	dec r16				;
	dec r16				;
	sts arg,r16			;

	lds r19,SectorsPerCluster
	rcall LslArg			;VOLUMES folder * SectorsPerCluster

;************************************************************************************
; Process VOLUMES Sector	(Find TIVOL000 file sector)
;************************************************************************************
	ldi XL,low(arg)		;Add VBR+HeapOffset to VOLUMES folder in arg
	ldi XH,high(arg)		; "
	ldi YL,low(Offset)    		; "
	ldi YH,high(Offset)   		; "
	rcall AddDword			; "
	rcall ReadMMC           	;Get VOLUMES folder sector
	
	ldi ZL,low(SDbuffer)		;Point to buffer
	ldi ZH,high(SDbuffer)		;
	ldi YL,low(TIVOLstr<<1)
	ldi YH,high(TIVOLstr<<1)
	
lp04:	ld r16,Z
	cpi r16,0xC1			;Check for type C1 entry
	brne jp04
	rcall cmpstr
	breq jp05			;TIVOL000 found

jp04:	adiw ZH:ZL,32			;Next entry
	ldi R16,low(SDbuffer+512)
	cp ZL,r16			;Check end of buffer
	brne lp04  
	ldi R16,high(SDbuffer+512)
	cp ZH,r16			;Check end of buffer
	brne lp04  
	rjmp DiskErr			;TIVOL000 not found

jp05:	sbiw ZH:ZL,32			;Back up from type C1 entry to C0 entry
	adiw ZH:ZL,20			;Point TIVOL000 file cluster dword at 20
	ldi YL,low(arg)    		; TIVOL000 file cluster
	ldi YH,high(arg)   		; "
	rcall mov4
	
	lds r16,arg			; Start cluster - 2
	dec r16				;
	dec r16				;
	sts arg,r16			;
	
	lds r19,SectorsPerCluster
	rcall LslArg			;TIVOL000 file * SectorsPerCluster

	ldi XL,low(arg)		;Add VBR+HeapOffset to TIVOL000 file in arg
	ldi XH,high(arg)		; "
	ldi YL,low(OffSet)    		; "
	ldi YH,high(OffSet)   		; "
	rcall AddDword			;
	lds r16,arg			;Save TIVOL000 start sector
	sts StartSector,r16		; "
	lds r16,arg+1			; "
	sts StartSector+1,r16		; " 

	ldi YL,low(arg)    		;Z left pointing to file size at 24
	ldi YH,high(arg)   		;file size is qword but we will never exceed dword
	rcall mov4
		
	lds r19,SectorsPerCluster
	ldi r16,9
	add r19,r16
	rcall LsrArg			;Divide by SectorsPerCluster + 512 bytes per sector
	brtc jp01			;If t not set then no carry (no remainder)
	lds ZL,arg
	lds ZH,arg+1
	adiw ZH:ZL,1
	sts arg,ZL
	sts arg+1,ZH
jp01:	lds r19,SectorsPerCluster
	rcall LslArg			;Size in clusters back to size in sectors

	lds r16,arg			;Save sector step
	sts StepSectors,r16		; "
	lds r16,arg+1			; "
	sts StepSectors+1,r16		; 
	
	sez				;Set Z bit (No error)
DiskErr:				;Return error,Z bit cleared
	ret				;On return will set disk ready status	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	
; Low level SD card access
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Send command to MMC,Uses cmd resp r16 r17 r18 nz=error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendMMC:
    ;4.8ms delay,PNY 1GB had trouble without delay
    	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
	rcall delay1ms
		
	ldi r16,0xFF		;
       	rcall SPIWrite	;
	lds r16,cmd		; Send the command byte
	rcall SPIWrite	;
	lds r16,arg+3		; Send 4 argument bytes starting with MSB
	rcall SPIWrite	;
	lds r16,arg+2		;
	rcall SPIWrite	;
	lds r16,arg+1		;
	rcall SPIWrite	;
	lds r16,arg		;
	rcall SPIWrite	;
	lds r16,crc		; Send the CRC7 byte (always use 95)
       	rcall SPIWrite	;
			
WaitResp:
	clr r18
lp10:
    ;.69ms delay,PNY 1GB had trouble without delay	
	rcall delay1ms		
				
	rcall SPIRead	;
	lds r17,resp
	cp r16,r17		; expected response?
	breq jp11		; YES - return
	dec r18			; waiting period is over?
       	brne lp10		; NO - keep waiting
	rcall SendErrorSPI	;
	clz			; Clear zero flag for time out
jp11:	ret			;

    
;********************************************************************
; Init SD/MMC memory card
;******************************************************************** 
MMCInit:	
	sbi PortB,CS		    ; disable MMC
	ldi r17,10		    ; Send 80 dummy clocks
lp20:
	rcall SPIRead	    ;
       	dec R17			    ;
	brne lp20		    ;
        cbi PortB,CS		    ; enable MMC         
SendCMD0:
	ldi r16,0x40		    ; CMD0 GO_IDLE_STATE
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x00000000
	sts arg+1,r16              ;	
	sts arg+2,r16              ;	
	sts arg+3,r16              ; MSB
	ldi r16,0x95
       	sts crc,r16
	ldi r16,1
	sts resp,r16		    ; expected response cnt 8
	rcall SendMMC		    ;
       	brne SendCMD0		    ; Expected response timed out
SendCMD8:
	ldi r16,0x48		    ; CMD8 SEND_IF_COND
	sts cmd,r16
	ldi r16,0xAA		    ; LSB
	sts arg,r16                ; 0x000001AA
	ldi r16,0x01		    ;
	sts arg+1,r16              ;
	clr r16			    ;
	sts arg+2,r16              ;
	sts arg+3,r16              ; MSB
	ldi r16,0x87
	sts crc,r16
	ldi r16,1		    ; Response V2=0x01 0x000001AA or V1=0x05
	sts resp,r16
	rcall SendMMC               ; 
	brne SendCMD1
	rcall SPIRead		    ; need to clear 0x000001AA
	rcall SPIRead		    ;	
        rcall SPIRead		    ;	      	
	rcall SPIRead		    ;			; 
			
;ACMD41 (CMD55+CMD41)			
SendCMD55:
	ldi r16,0x77		    ; CMD55 APP_CMD
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x00000000
	sts arg+1,r16              ;	
	sts arg+2,r16              ;	
	sts arg+3,r16              ; MSB
	ldi r16,0xFF
       	sts crc,r16
	ldi r16,1
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD55		    ;  Expected response timed out	
SendCMD41: 	
	ldi r16,0x69		    ; CMD41 SD_SEND_OP_COND
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x40000000
	sts arg+1,r16              ;
	sts arg+2,r16              ;
	ldi r16,0x40
	sts arg+3,r16              ; MSB
	ldi r16,0xFF
       	sts crc,r16
	clr r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD55		    ;  Expected response timed out
	rjmp SendCMD58

SendCMD1:
	ldi r16,0x41		    ; CMD1 SEND_OP_COND
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x00000000
	sts arg+1,r16              ;	
	sts arg+2,r16              ;	
	sts arg+3,r16              ; MSB
	ldi r16,0xFF
       	sts crc,r16
	clr r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD1		    ;  Expected response timed out
   			
SendCMD58:
	ldi r16,0x7A		    ; CMD58 READ_OCR
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x00000000
	sts arg+1,r16              ;	
	sts arg+2,r16              ;	
	sts arg+3,r16              ; MSB
	ldi r16,0xFF
       	sts crc,r16
	clr r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne SendCMD58		    ;  Expected response timed out

	ldi ZH,high(SDbuffer)	    ; Get address to buffer
	ldi ZL,low(SDbuffer)	    ; "
	ldi R19,4
lp21:
	rcall SPIRead		    ; Get MSByte 1 of 4 OCR register
	st Z+,r16		    ; Save OCR to buffer
	dec R19
	brne lp21
	lds r16,SDbuffer
	sts ocr,r16		    ; bit6=1 SDHC

SendCMD9:
	ldi r16,0x49		    ; CMD9 READ_CSD
	sts cmd,r16              
       	clr r16			    ;
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
	brne SendCMD9		    ; Expected response timed out
	ldi r16,0xFE
	sts resp,r16
	rcall WaitResp		    ; Wait for FE Start
	brne SendCMD9
	ldi r19,18
lp22:	
	rcall SPIRead
	dec r19
	brne lp22

SendCMD10:
    	ldi r16,0x4A		    ; CMD10 READ_CID
	sts cmd,r16              
       	clr r16			    ;
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
	brne SendCMD10		    ; Expected response timed out
	ldi r16,0xFE
	sts resp,r16
	rcall WaitResp		    ; Wait for FE Start
	brne SendCMD10
    	ldi r19,18
lp23:	
	rcall SPIRead
	dec r19
	brne lp23

	rcall FullThrottle
			
; Let fall thru to Set Block			
;********************************************************************
; CMD16 SET_BLOCKLEN default 512
; The only valid block length for write is 512!
; Read is 1 to 2048
;********************************************************************
SetBlockMMC: 
	cbi PortB,CS		    ; enable MMC         
	ldi r16,0x50		    ; CMD16 SET_BLOCKLEN
	sts cmd,r16              
       	clr r16			    ; LSB
	sts arg,r16                ; 0x00000200 (512 block)
	ldi r16,2
	sts arg+1,r16              ;
	clr r16
	sts arg+2,r16              ;	
	sts arg+3,r16              ; MSB
	clr r16
	sts crc,r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne SetBlockMMC	    ; Expected response timed out
	sbi PortB,CS		    ; Disable MMC
	ret 							;

;********************************************************************
; CMD24 WRITE_BLOCK 512 bytes
; Entry ARG = 4 byte sector
; Exit nz=write error
;********************************************************************
WriteMMC:			    ;Write 1st 256 bytes of sector
	cbi PortB,CS		    ; enable MMC   
	rcall SaveArg		    ; Save argument,in case multipled
	
	lds r16,ocr
	sbrs r16,ccs		    ; Skip bit 6 is 1 (SDHC)
	rcall Mul512Arg		    ; bit 6 is 0 (SDSC)
lp40:
	ldi r16,0x58		    ; CMD24 WRITE_BLOCK
	sts cmd,r16 
	clr r16
	sts crc,r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne lp40		    ; Expected response timed out
	
	rcall SPIRead		    ; write prefix (Read writes FFFF)
	rcall SPIRead
	ldi r16,0xFE		    ; Send start data token
	rcall SPIWrite
	
	ldi ZH,high(SDbuffer)	    ; Get address to buffer
	ldi ZL,low(SDbuffer)	    ; "
	clr R19			    ; Write 256 bytes to SD
;Write 1st 256 bytes of sector	
lp41:
	ld r16,Z+
	rcall SPIWrite		    ; Write data byte
	dec R19
	brne lp41
;Write 2nd 256 bytes of sector    		 
lp42:
	ld r16,Z+
	rcall SPIWrite		    ; Write data byte
	dec R19
	brne lp42				
	rcall SPIRead		    ; write 2 bytes CRC 0xFF (Read writes FFFF)
	rcall SPIRead		    ;  "
	    
	rcall SPIRead		    ; was data accepted			
	andi r16,0x1F
	cpi r16,5
	brne jp45
	ldi r16,0xFF		    ; wait for 0xFF
	sts resp,r16
	rcall WaitResp
	brne jp45
	rcall RestoreArg
	sbi PortB,CS		    ; Disable MMC
	sez			    ;Set zero fla
       	ret			    ; normal return z-flag set
jp45:
	rcall RestoreArg
	rcall SendErrorSPI         
	sbi PortB,CS		    ; Disable MMC
	clz			    ;Clr zero flag
	ret			    ; write error return z-flag clear
 			
			
      		
;********************************************************************
; CMD17 READ_BLOCK 512 bytes
; Entry ARG = 4 byte sector
;********************************************************************
ReadMMC:			    ;Read 1st 256 bytes of sector
	cbi PortB,CS		    ; enable MMC   
	rcall SaveArg		    ; Save argument,in case multipled
	
	lds r16,ocr
	sbrs r16,ccs		    ; Skip bit 6 is 1 (SDHC)
	rcall Mul512Arg		    ; bit 6 is 0 (SDSC)
lp50:
	ldi r16,0x51		    ; CMD17 READ_SINGLE_BLOCK
	sts cmd,r16 
	clr r16
	sts crc,r16
	sts resp,r16		    ; expected response
	rcall SendMMC		    ;
       	brne lp50		    ; Expected response timed out
	
	ldi r16,0xFE		    ; Send start data token
	sts resp,r16
	rcall WaitResp		    ; Wait for FE Start
	brne lp50
;Read 1st 256 bytes of sector	
	ldi ZH,high(SDbuffer)	    ; Get address to buffer
	ldi ZL,low(SDbuffer)	    ; "
	clr R19			    ; Always read 256 the size of buffer
lp51:
	rcall SPIRead		    ; Get data byte
	st Z+,r16
	dec R19
	brne lp51
;Read 2nd 256 bytes of sector    		 
lp52:
	rcall SPIRead		    ; Get data byte
	st Z+,r16
	dec R19
	brne lp52		
	rcall SPIRead		    ; read 2 bytes CRC	
	rcall SPIRead		    ; and discard	
	sbi PortB,CS		    ; Disable MMC
 	rcall RestoreArg
   	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Send error command/response to PC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendErrorSPI:
       	rcall USARTWrite	    ; Send response received
	lds r16,resp		    
	rcall USARTWrite	    ; Send expected response
	lds r16,cmd
	rcall USARTWrite	    ; Send cmd used
	dec r10
ErrLP:	
	breq ErrLP		    ; Keep from runnig away,Until reset
	ret			    ; Fail 2 or 3 times on start,Just return 
	
SendErrorMedia:
	nop
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dlylong:
	push r17	;
	clr r17		;
	rjmp jp51
delay1ms:		;  15431x.0625us aprox 1ms,not exact(.965ms)
	push r17	;   2
	ldi r17,20	;   1
jp51:	push r16	;   2
	clr r16		;   1
dly1:	dec r16		; 768x20=15360          
        brne dly1	; 
	dec r17		; 3x20=60   
	brne dly1
	pop r16		;   2
	pop r17 	;   2
	ret		;   1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
 SaveArg:   
    	lds r6,arg		; Save argument,in case multipled
  	lds r7,arg+1
  	lds r8,arg+2
  	lds r9,arg+3
	ret
RestoreArg:
	sts arg+3,r9		; Restore argument
	sts arg+2,r8 
	sts arg+1,r7  
	sts arg,r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Mul512Arg:
	ldi r19,9		; multiply arg by 512
LslArg:				; shift arg left per r19
lp60:	
	lds r16,arg
	lsl r16
	sts arg,r16
	lds r16,arg+1
	rol r16
	sts arg+1,r16
	lds r16,arg+2
	rol r16
	sts arg+2,r16
	lds r16,arg+3
	rol r16
	sts arg+3,r16
	dec r19
	brne lp60
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmpstr:	push ZL
	push ZH
	push YL
	push YH
		
	movw r17:r16,ZH:ZL  ;LPM only works with Z
	movw ZH:ZL,YH:YL
	movw YH:YL,r17:r16
  	
lp07:	lpm r16,Z+
	cpi r16,0xFF	;Check end of string
	breq jp07
	ld r17,Y+
	cp r16,r17
	brne jp07	;Not equal,return
	rjmp lp07	;Next char
jp07:	pop YH
	pop YL
	pop ZH
	pop ZL
	ret		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov4:	ldi r16,4		    ;
lp01:	ld r17,Z+ 
	st Y+,r17
	dec r16
	brne lp01
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add Dword pointed to by X & Y Result pointed to by X
AddDword:
	ld r16,X
	ld r17,Y+
	add r16,r17
	st X+,r16

	ld r16,X
	ld r17,Y+
	adc r16,r17
	st X+,r16

	ld r16,X
	ld r17,Y+
	adc r16,r17
	st X+,r16

	ld r16,X
	ld r17,Y+
	adc r16,r17
	st X+,r16
	ret

; shift arg right per r19
LsrArg:	clt			
lp61:	lds r16,arg+3
	lsr r16
	sts arg+3,r16
	lds r16,arg+2
	ror r16
	sts arg+2,r16
	lds r16,arg+1
	ror r16
	sts arg+1,r16
	lds r16,arg
	ror r16
	sts arg,r16
	brcc jp61
	set		;Set t bit if carry
jp61:	dec r19
	brne lp61
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Xmodem Volume transfer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
XMODEM:	cbi PortE,2		;Release TI
	rcall WaitTIwrite	;Wait for volume# from TI
	lds r21,fdcData		;Save volume in r21
	
	rcall WaitTIwrite	;Wait Telnet mode from TI
	lds r16,fdcData
	sts TELFLG,r16
	
	rcall WaitTIwrite	;Wait send/receive mode from TI
	lds r20,fdcData		;Save in r20
	
	in r16,GICR		;Disable INT2
	cbr r16,1<<INT2		; "
	out GICR,r16		; "	
	ldi r16,0x80		;Set TI to read status NotReady 
	out PortA,r16		;Until Int2 enabled

	clr r16
	sts CRCFLG,r16		;Init CRC flag to checksum mode
	sts PAKNUM+1,r16	;Init packet # to 1
	inc r16			; "
	sts PAKNUM,r16		; "
	rcall Disk2Sector	;Entry r21=disk, Exit arg=SD sector address
	rcall BUFFL		;Clear buffer
	
	tst r20			;Send/Receive
	brne SEND 
	rjmp RECV	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; Send Volume	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
SEND:	rcall SERRD		;Wait for starting NAK
	breq SEND		;Timed out,Loop back
	cpi r17,CAN		;Check if remote sent cancel
	breq CANRL1		;Cancel Exit Can't continue
	cpi r17,NAK		;Did remote sent checksum start
	breq NXTSEC		;flag already set for checksum mode
	cpi r17,'C'		;Did remote sent CRC start
	brne SEND
	ldi r16,1		;Set flag for CRC mode
	sts CRCFLG,r16		; "		

NXTSEC:	rcall RDSEC
SAMSEC:	ldi r17,SOH		;Send start
	rcall UARTWR		; "	
	lds r17,PAKNUM		;Send LSByte packet#
	rcall UARTWR		; "
	com r17			;Send LSByte inverted packet#
	rcall UARTWR		;
	
	ldi XH,high(SDbuffer)	;Set SDbuffer pointer
	ldi XL,low(SDbuffer)
	clr r25
	lds r24,PAKNUM
	dec r24			;(1-4) to (0-3)
	andi r24,0x03		;Keep 2 lsbits
	ldi r16,7		;r25:24 times 128
	rcall lsl_r25r24	; "
	add XL,r24		;Add to SDbuffer pointer
	adc XH,r25
	
	clr r0			;Init CRC
	clr r1
	sts CHKSUM,r0		;Init checksum
	ldi r18,128		;Init byte counter
lp29:	ld r17,X+
	rcall UARTWR
	lds r16,CHKSUM
	add r16,r17
	sts CHKSUM,r16
	rcall CRC16		;r17 added to crc in r1:r0
	dec r18
	brne lp29

	lds r16,CRCFLG
	tst r16
	breq jp29

	mov r17,r1		;Send high byte of CRC
	rcall UARTWR
	mov r17,r0		;Send low byte of CRC
	rcall UARTWR
	rjmp lp30
	
jp29:	lds r17,CHKSUM		;Send checksum
	rcall UARTWR

lp30:	rcall SERRD		;Wait for Response
;	breq SAMSEC		;Timed out,Assume NAK
	breq lp30
	cpi r17,NAK		;If NAK
	breq SAMSEC		;Resend from same sector	
	cpi r17,CAN		;If remote cancel
CANRL1:	breq CANRLY		;Exit Can't continue
	cpi r17,ACK		;If not ACK,Ignore
	brne lp30

;ACK
	lds r24,PAKNUM		;Inc byte packet number
	lds r25,PAKNUM+1
	adiw r25:r24,1
	sts PAKNUM+1,r25
	sts PAKNUM,r24
	cpi r24,0x41		;If packet 2881 then done
	brne jp30		; "
	cpi r25,0x0B		; "
	breq jp31		; "
	
jp30:	andi r24,0x03		;Check if next packet is 1
	cpi r24,0x01		
	breq NXTRLY		;Read new sector If zero
	rjmp SAMSEC 
	
jp31:	ldi r17,EOT		;Transfer completed
	rcall UARTWR
EXTRLY:	rjmp EXIT		;Exit normal
CANRLY:	rjmp CANCEL
NXTRLY:	rjmp NXTSEC
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Receive volume
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECV: 	ldi r18,8		;Send 'C' 8 times
lp31:	ldi r17,'C'
	rcall UARTWR
	rcall SERRD
	
	breq jp32		;Skip if nothing read
	cpi r17,SOH 
	breq jp33		;Jump CRC
jp32:	dec r18
	brne lp31
	rjmp NAKLP		;Jump Checksum
;CRC	
jp33:	sts CRCFLG,r17		;Set flag 01 for CRC mode	
	rcall dlylong
	rcall dlylong
	rcall dlylong
	rjmp STARTR		;r17 already SOH
;Checksum
;
;
NAKLP:	rcall BUFFL		;Clear buffer
	ldi r17,NAK		;1st response NAK to start
ACKLP:	rcall dlylong
	rcall dlylong
	rcall dlylong
	rcall UARTWR		;Send response
	rcall SERRD		;Get SOH of packet
	breq NAKLP		;Timed out,Resend NAK
;	
STARTR:	sts CHKSUM,r17		;Init checksum
	cpi r17,EOT
	breq EXTRLY
	cpi r17,CAN
	breq CANRLY
	cpi r17,SOH
	brne NAKLP	

	rcall SERRD		;Get packet number
	breq NAKLP		;Timed out,Resend NAK	
	lds r16,CHKSUM		;Add packet number to checksum
	add r16,r17
	sts CHKSUM,r16
	lds r16,PAKNUM		;LSByte packet#	
	cp r17,r16		;Does Received packet = Expected packet
	brne NAKLP	

	rcall SERRD		;Get inverted packet number
	breq NAKLP		;Timed out,Resend NAK
	lds r16,CHKSUM		;Add Inv packet number to checksum
	add r16,r17		;Sets Z only for r0 thru r7
	sts CHKSUM,r16
	tst r16
	brne NAKLP		;Does SOH+PACKET#+INV PACKET#=0
	
	ldi XH,high(SDbuffer)	;Set SDbuffer pointer
	ldi XL,low(SDbuffer)
	clr r25
	lds r24,PAKNUM
	dec r24			;(1-4) to (0-3)
	andi r24,0x03		;Keep 2 lsbits
	ldi r16,7		;r25:24 times 128
	rcall lsl_r25r24	; "
	add XL,r24		;Add to SDbuffer pointer
	adc XH,r25
	
	clr r0			;Init CRC
	clr r1
	sts CHKSUM,r0		;Init checksum
	ldi r18,128		;Init byte counter
lp34:	rcall SERRD		;Read packet
	breq NAKLP		;Timed out,Resend NAK
	st X+,r17
	lds r16,CHKSUM		;Add byte to checksum
	add r16,r17
	sts CHKSUM,r16
	rcall CRC16		;r17 added to crc in r1:r0
	dec r18
	brne lp34

	rcall SERRD		;Get Checksum or MSByte of CRC
	breq NAKRLY		;Timed out,Resend NAK
	lds r16,CRCFLG
	tst r16
	breq jp35
;CRC
	cp r17,r1		;Compare of MSByte CRC
	brne NAKRLY
	rcall SERRD		;Get LSByte CRC
	breq NAKRLY		;Timed out,Resend NAK
	cp r17,r0		;Compare LSByte of CRC
	brne NAKRLY	
	rjmp jp36
	
NAKRLY: rjmp NAKLP
;Checksum	
jp35:	lds r16,CHKSUM
	cp r17,r16
	brne NAKRLY

; ACK
jp36:	lds r24,PAKNUM		;Inc byte packet number
	lds r25,PAKNUM+1
	adiw r25:r24,1
	sts PAKNUM+1,r25
	sts PAKNUM,r24	
	
	andi r24,0x03		;Check if next packet is 1
	cpi r24,0x01		
	brne jp37		;Write SDbuffer If buffer finished
	rcall WRSEC		;
jp37:	ldi r17,ACK		;Send ACK response
	rjmp ACKLP		;Get next packet
    
CANCEL:	ldi r16,0x90		;TI status NotReady & Error 
	out PortA,r16		;	
	clr r16			;Give TI time to read status
lp35:	dec r16			;		
	brne lp35		;
	
EXIT:	ldi r17,ACK
	rcall UARTWR    
	in r16,GICR		;Enable INT2
	sbr r16,1<<INT2		; "
	out GICR,r16		; "
	
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CRC-16/XMODEM
;
; On entry r17  = byte
;          r0 = old CRC low byte
;          r1 = old CRC high byte
; On exit  r0 = new CRC low byte
;          r1 = new CRC high byte
;          r17,r2 = undefined
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CRC16:
        eor     r17,r1           
        mov     r1,r17            
        swap    r17               
        andi    r17,0x0f          
        eor     r17,r1            
        mov     r1,r17            
        swap    r17               
        mov     r2,r17            
        andi    r17,0xf0         
        eor     r17,r0 
	
	push	r17		; xch r17,r2            
	push	r2
	pop	r17
	pop	r2
	
	bst	r17,7		; rl r17
	lsl	r17
	bld	r17,0
	
        mov     r0,r17            
        andi    r17,0xe0         
        eor     r17,r1 
	
	push	r17		; xch r17,r0            
	push	r0
	pop	r17
	pop	r0
	
	andi    r17,0x1f          
        eor     r17,r2            
        mov     r1,r17            
        ret
;
;Exit r17 = byte read form USART
;Equ set if timed out
;discard nul after cr
SERRD:	rcall UARTST		
	breq jp42		;Equ set if timed out
	rcall UARTRD		;data returned in r16
	MOV r17,R16
	
	lds r16,TELFLG		;If telnet
	tst r16
	breq jp49
	
	cpi r17,0x0D		;Check 13 cr
	brne JP49		;
		
	rcall UARTST		
	breq jp42		;Equ set if timed out
	rcall UARTRD		;data returned in r16
	
jp49:	clz			;Clear EQU status
jp42:	ret
;
;Read USART status into r16
;
UARTST:	ldi r21,85		;85=10Sec
	clr r20
	clr r19
	
lp36:	
	in r16,UCSR0B		;Check if RXC interrupt enabled
	sbrc r16,RXCIE		;Skip if not set
	rjmp jp50		;Get data from buffer
	
	in r16,UCSR0A		;Get status here, Interrrupt disabled
	andi r16,0x80
	breq jp43		;No data
	rjmp jp44		;Data in USART
	
jp50:	lds r16,SerCnt		;Get status here, Interrrupt enabled
	cpi r16,0
	breq jp43		;No data	    
	ldi r16,226		;Data in buffer, Send status 226
	rjmp jp44		;Equ not set
	
jp43:	
	dec r19
	brne lp36
	dec r20
	brne lp36
	dec r21
 	brne lp36		;Timed out, EQU set
    
jp44:	ret
;
;Read USART data into r16
;
UARTRD: 
	in r16,UCSR0B		;Check if RXC interrupt enabled
	sbrc r16,RXCIE		;Skip if not set
	rjmp jp47		;Get data from buffer
	in r16,UDR		;Get data from USART
	rjmp jp48
   
jp47:	lds r16,SerCnt
	cpi r16,0
	breq jp48		;Sent data from USART
	dec r16
	sts SerCnt,r16
	
	ldi ZH,high(Serbuffer)
	ldi ZL,low(Serbuffer)
	lds r16,SerRdPtr	;ptr Status byte
	add ZL,r16		;Point Z to Char byte
	inc r16			;ptr next entry
	cpi r16,Serbuffsize
	brne jp46
	clr r16
jp46:	sts SerRdPtr,r16
	ld r16,Z		;Get char from buffer

jp48:	ret 
;
;Send data in r17 to USART
;Add nul after cr & 2nd ff after ff
UARTWR:	mov r16,r17
	rcall USARTWrite	;Write data in r16 to USART
	lds r16,TELFLG
	tst r16
	breq jp41		;Return,If not Telnet
	
	cpi r17,0x0D		;Check 13 cr
	brne JP39		;
	clr r16			;Send 2nd 0x00
	rjmp JP40
	
jp39:	cpi r17,0xFF		;Check 255
	brne JP41		;
	ldi r16,0xFF		;Send 2nd 0xFF
	
jp40:	rcall USARTWrite	;Write data in r16 to USART
jp41:	ret
;
; Flush buffer
;	
BUFFL:	rcall USARTFlush
	clr r16			;
	sts SerRdPtr,r16	;Reset pointers
	sts SerWrPtr,r16
	sts SerCnt,r16
	ret
;
; Write/Read sector to SD card
;
RDSEC:	rcall ReadMMC
	jmp jp38
WRSEC:	rcall WriteMMC
;Increment arg (next sector)    
jp38:   ldi r17,1	
	lds r16,arg
	add r16,r17	    ;Inc doesn't affect carry
	sts arg,r16
	
	clr r17
	lds r16,arg+1
	adc r16,r17
	sts arg+1,r16
	
	lds r16,arg+2
	adc r16,r17
	sts arg+2,r16
	
	lds r16,arg+3
	adc r16,r17
	sts arg+3,r16    
	ret
;
;Logical shift left r25:r24 times r16
; 
lsl_r25r24:
	lsl r24
	rol r25
	dec r16
	brne lsl_r25r24
	ret