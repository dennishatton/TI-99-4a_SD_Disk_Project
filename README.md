# TI-99/4a SD Disk Project
Allows TI to use floppy images on SD card

I built this on a wire wrap board and tested.<br />
I've included the KICAD schematic but no PCB.<br />
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
There is a cartridge TISDMGRC.bin to list volumes on the TI.<br />
The cartridge is optional, You will need FLASHROM99 to run it.<br />
I've already added 32k inside my console so I didn't put 32k on this board.<br />
If someone does build this, Please let me know.<br />
I have mine working for a couple years.<br />

![20210211_083814-ConvertImage](https://user-images.githubusercontent.com/6753466/107653626-736e0500-6c47-11eb-956a-0ce666fc9371.jpg)

![20210210_214707-ConvertImage](https://user-images.githubusercontent.com/6753466/107653811-a7492a80-6c47-11eb-9e17-8fb9d23c6c07.jpg)

![20210210_215252-ConvertImage](https://user-images.githubusercontent.com/6753466/107654000-d8295f80-6c47-11eb-8724-41792cc1835e.jpg)

![20210210_215518-ConvertImage](https://user-images.githubusercontent.com/6753466/107654174-0313b380-6c48-11eb-8869-f22a397665a8.jpg)
