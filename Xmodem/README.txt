Transfer disk between PC & TI using an ESP-01 with ESP-LINK firmare.
On PC side use ExtraPuTTY or Tera Term to transfer by Telnet.
On TI side use Xmodem program on this disk.

Load basic program XFR2. It will load XMDXFR2 object code.
It runs in XB, EA, or MM.
I'm using XFR2 now as it runs in ATMEGA162 and transfers directly to SD
I left XFR on the disk. It runs in the TI and slower.

You will need to start sender first then receiving program.
TI will ask for volumme number, Telenet yes/no.
If you are using direct connection answer no.
Telnet adds a extra nul char after cr that needs to be striped.

The ESP-01 will need a seperate 3v power supply.
It uses serveral ma of current.

Flash ESP-LINK firmware on ESP-8266

Download lastest release from
https://github.com/jeelabs/esp-link

Hookup for programming
                                                [FTDI USB to TTL]
                [ESP-01]                   ------------------------------
        --------------------------         | (DTR)                      |
    /VCC| (3V3)(RX ) TX-RX       |    RX-TX| (RXD)      Swap RX & TX    |
   |    | (RST)(IO0) GND\        |    TX-RX| (TXD)                      |
    \VCC| (EN )(IO2)     |       |      VCC| (VCC)      Set VCC to 3.3v!|
 RX<--TX| (TX )(GND) GND/        |         | (CTS)                      |
        --------------------------      GND| (GND)                      |
                                           ------------------------------
Hookup for operation
                                               [TTL Microprocessor]
              [ESP-01]                 -----------------------------
      ------------------------       NC| (VCC) No connection to VCC|    POWER   
  /3V3| (3V3)(RX )-[DIODE+]->TX      RX| (RXD)                     |    SUPPLY
 |    | (RST)(IO0)          |        TX| (TXD)                     |     (3V3)
  \3V3| (EN )(IO2)          |       GND| (GND)                     |     (GND)
 RX-TX| (TX )(GND) GND      |       GND| (GND)                     |
      -----------------------          -----------------------------       
   
        (Turn on RX pull-up in setup)
        (TX-RX direct wire)     


Download Nodemcu flasher here
https://github.com/nodemcu/nodemcu-flasher

Run ESP8266Flasher.exe

[Config] Point to ESP-LINK bin files
(x) boot_v1.X.bin               0x00000
(x) blank.bin                   0x3FE000
(x) esp_init_data_default.bin   0x3FC000
(x) user1.bin                   0x01000
[Operation]
Flash
Blue progess bar will advance across screen.
Will have green circle with check mark in Lower left bottom corner
If programmed ok.

For operation remove jumper I00 to GND
Programmer can not power for operation.
Peak current at startup: approx 320mA @3.3V.
I use a large cap (470uF SMD) as the peak only comes up periodically.
Normal operation with AP connected: 35mA average.
Note the peaks of 290+mA during packet operations.

Use phone connect to WIFI hotspot ESP_xxxx
Use browser go to 192.168.4.1
[Home]
 Pin assignment         ;After setting
Drop down Presets       ;Reset          gpio0
select esp-01           ;ISP/Flash      disabled
(x)RX pull-up           ;Conn LED       gpio2/TX1
Click Change!           ;Serial LED     disabled
                        ;UART pins      normal
                        ;RX pull-up     checked

Option connect to your nework
[WiFi Station]
 WiFi association
Click STA+AP mode to search for networks
Select your network
Enter password
Click Connect!

[Debug log]
Click off

[uC Console]
A terminal window

or use PuTTY
Host Name (or IP address)       Port
192.168.4.1                     23      (or IP address on your network)
Connection tpye:
        (x)Other [Telnet]
Click Open

