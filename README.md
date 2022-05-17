# TI-99/4a SD Disk Project
Allows TI to use floppy images on SD card
<br />
<br />
Note:<br />
	If you have downloaded the PCBs, Please update 5/17/22<br /><br />

	I have uploaded a new SD Drive board that does not need the adaptor.<br />
	I have also uploaded the adaptor and 32K daughter board.<br />
	<br />
	If you have already order the old PCBs as I have.<br />
	You will need the adaptor board. See the Adaptor ReadMe.pdf in KiCad folder.<br />
	The pin header will also be used for the optional 32K daughter board.<br />
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
I have moved the Atmega project from MPLABX to Microchip Studio.<br />
Also allowed the TI to access the ATmega usart<br />
by writing to the FDC Command register and reading or writing data registers.<br />
0x83 read usart status, 0x84 read usart data, 0x85 write usart data.<br />
There is a 128 byte buffer storing status & char received. (64 chars)<br />
The baud is 115.2k 8N1. I may latter let TI change baud<br />

![20210210_215252-ConvertImage](https://user-images.githubusercontent.com/6753466/107654000-d8295f80-6c47-11eb-8724-41792cc1835e.jpg)

![20210210_215518-ConvertImage](https://user-images.githubusercontent.com/6753466/107654174-0313b380-6c48-11eb-8869-f22a397665a8.jpg)
![20220517_162552](https://user-images.githubusercontent.com/6753466/168922685-4b889890-207c-45b6-8742-5c7b9b2f0e74.jpg)
![20220517_162338](https://user-images.githubusercontent.com/6753466/168922696-897ccd0c-7b33-4925-9729-05f90aae67c3.jpg)
![20220517_162359](https://user-images.githubusercontent.com/6753466/168922706-d60dbe1b-8071-4687-9492-6ff588b4eeda.jpg)
![20220517_162436](https://user-images.githubusercontent.com/6753466/168922715-f000a3a5-55d0-4d39-a41b-d1926b3e4fd6.jpg)
![20220517_162520](https://user-images.githubusercontent.com/6753466/168922727-ac75ca91-70f3-471f-a8ea-054d1014aa5b.jpg)

