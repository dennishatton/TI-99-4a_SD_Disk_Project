# TI-99-4a_SD_Disk_Project
Allows TI to use floppy images on SD card

I built this on a wire wrap board and tested.
I'm sharing this project so if someone else would like to build one.
You can use any size SD card, Just format it EXFAT cluster size 512mb.
The reason I use 512mb clusters is make sure another file can't be save between volumes.
You could use FAT32, but I recommend EXFAT for the reason above
I've included the KICAD schematic.
You will need to find a TI DSR rom. I'm not including one.
You can use TI DSR rom as is or apply patches for CALL MOUNT and 360k disk images
I'm using an ATMEGA162 to interface with the TI. Source included for MPLABX
The volumes are sector images of disk.
You can use Disk Manager 2 on TI or on PC use TI99DIR.
I'm also including some PC utilties written in Visual C
I've already added 32k inside my console so I didn't put 32k on this board.
You can find instructions on internet to add 32k inside console.

![20210210_215518](https://user-images.githubusercontent.com/6753466/107609130-a098c400-6c03-11eb-8a6a-2bed2328b84c.jpg)

