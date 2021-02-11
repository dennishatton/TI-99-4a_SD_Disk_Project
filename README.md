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

![20210211_083814-ConvertImage](https://user-images.githubusercontent.com/6753466/107653626-736e0500-6c47-11eb-956a-0ce666fc9371.jpg)

![20210210_214707-ConvertImage](https://user-images.githubusercontent.com/6753466/107653811-a7492a80-6c47-11eb-9e17-8fb9d23c6c07.jpg)

![20210210_215252-ConvertImage](https://user-images.githubusercontent.com/6753466/107654000-d8295f80-6c47-11eb-8724-41792cc1835e.jpg)

![20210210_215518-ConvertImage](https://user-images.githubusercontent.com/6753466/107654174-0313b380-6c48-11eb-8869-f22a397665a8.jpg)
