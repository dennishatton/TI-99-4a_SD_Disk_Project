# TI-99/4a SD Disk Project
Allows TI to use floppy images on SD card
<br />
<br />
Note:<br />
	Added optional LED to 32K board 5/25/22<br /><br />

	I have also uploaded 32K board, RS232/PIO board and ESP-01 adaptor for Telnet transfers<br />
	<br />
	I'm not trying to re-invent TI-99/4a or turn it into a PC.<br />
	My goal is to keep it compatible with an original TI system.<br />
	If you have already order the old PCBs as I have.<br />
	You will need the adaptor board. See the Adaptor ReadMe.pdf in KiCad folder.<br />
	The pin header will also be used for the optional 32K daughter board.<br />
	I recommend you use a long pin wire wrap edge card connector for side port, If you want to mount in a case.<br />
	<br />	
	This should go without saying but the edge card connector goes on back of the board, Not front components side.<br />
	Also If you can't figure out where the emitter, base & collector is on a transistor. This project is not for you.<br />
	Must power up SD drive first then console.<br />
	<br />

I built this on a wire wrap board and tested.<br />
I have included the KICAD schematic and PCB.<br />
You must format SD card to EXFAT allocation unit size 512k.<br />
The reason I use 512k clusters is make sure another file can't be save between volumes.<br />
You will need to find a TI DSR rom. I'm not including one.<br />
You can use TI DSR rom as is or apply patches for CALL MOUNT and 360k disk images<br />
I'm using an ATMEGA162 to interface with the TI. Source included for MPLABX<br />
The volumes are V9T9 sector images of TI disk.<br />
You can use Disk Manager 2 on TI or on PC use TI99DIR.<br />
I'm also including some PC utilties.<br />
To use the PC utilities, You will need Visual C++ Redistributable for Visual Studio 2019.<br />
Go here to download for your computer.<br />
https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads<br />
There is a cartridge VolumeMgr.bin to list volumes on the TI.<br />
The cartridge is optional, You will need FLASHROM99 to run it.<br />
<br />
If someone does build this, Please let me know.<br />
I have mine working for a couple years.<br />
dennishsr@charter.net<br />

You must use a 16MHz Atmega162<br />
Low High Extend<br />
with fuses FF D9 FF<br />
<br />
Can use ESP-01 adaptor to Telnet send/receive volumes from PC to SD Drive.<br />
Also allowed the TI to access the ATmega usart<br />
by writing to the FDC Command register and reading or writing data registers.<br />
0x83 read usart status, 0x84 read usart data, 0x85 write usart data.<br />
There is a 128 byte buffer storing status & char received. (64 chars)<br />
The baud is 115.2k 8N1.<br />

![VOLMGR](https://user-images.githubusercontent.com/6753466/170409919-f03c4be6-b2cd-4ad9-8e55-f5db8eb0c81e.jpg)
Volume Manger.<br />
![20220517_162338](https://user-images.githubusercontent.com/6753466/168922696-897ccd0c-7b33-4925-9729-05f90aae67c3.jpg)
![20220517_162359](https://user-images.githubusercontent.com/6753466/168922706-d60dbe1b-8071-4687-9492-6ff588b4eeda.jpg)
![DiskTest](https://user-images.githubusercontent.com/6753466/170410018-41deb22a-349a-4567-8553-665e0abd1e83.jpg)
Disk test with TI Disk Manager.<br />

![RS232Front](https://user-images.githubusercontent.com/6753466/170385157-a1ae4dae-aca4-40f6-b0ba-a97418f05ad7.jpg)
![RS232Back](https://user-images.githubusercontent.com/6753466/170385183-7e2a265d-ba2d-4571-b4ab-a3838b95cb57.jpg)
![RS232Test](https://user-images.githubusercontent.com/6753466/170385251-ecc8b067-6b48-4101-a602-6b5ccba13977.jpg)
RS232 test with my EPROM programmer.<br />

![32KFront](https://user-images.githubusercontent.com/6753466/170385277-1d3e4d23-2535-4788-9d59-5e41630f1e7f.jpg)
![32KBack](https://user-images.githubusercontent.com/6753466/170385330-92a88344-faf3-4186-8be0-442de668cd32.jpg)
![32KTest](https://user-images.githubusercontent.com/6753466/170385347-df5e4ec9-c7d2-4b8b-b01b-8a38bdbc6fa9.jpg)
32K Memory test.<br />

![flat](https://user-images.githubusercontent.com/6753466/170385386-dd5b3b63-0bef-4345-ada1-49e55a1afe5a.jpg)
![Upright](https://user-images.githubusercontent.com/6753466/170385400-cbff3c3e-c67e-442b-950f-4775f3b8f58e.jpg)
Attached with Velcro.<br />

![TI_Telnet](https://user-images.githubusercontent.com/6753466/170412623-5f40a246-60f6-41b0-a636-38ab1d46b639.jpg)
TI Sending Volume to PC via Telnet Xmodem

![PC_Telnet](https://user-images.githubusercontent.com/6753466/170412728-b391a19d-4436-4d80-b0a1-7085718cf3c1.jpg)
PC Receiving Volume from TI via Telnet Xmodem 1.8 KB/Sec


