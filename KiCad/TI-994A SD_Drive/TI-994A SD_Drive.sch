EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L TI-994A-SD_Drive-rescue:Conn_02x22_Odd_Even-TI-994A-SD_Drive-rescue J1
U 1 1 5C00C563
P 2550 6200
F 0 "J1" H 2600 7300 50  0000 C CNN
F 1 "SIDE PORT CONNECTOR" H 2600 5000 50  0000 C CNN
F 2 "" H 2550 6200 50  0001 C CNN
F 3 "" H 2550 6200 50  0001 C CNN
	1    2550 6200
	1    0    0    1   
$EndComp
$Comp
L TI-994A-SD_Drive-rescue:74LS251-TI-994A-SD_Drive-rescue U4
U 1 1 5C11BF80
P 5500 4250
F 0 "U4" H 5500 4250 50  0000 C CNN
F 1 "74LS251" H 5500 4100 50  0000 C CNN
F 2 "" H 5500 4250 50  0001 C CNN
F 3 "" H 5500 4250 50  0001 C CNN
	1    5500 4250
	1    0    0    -1  
$EndComp
$Comp
L TI-994A-SD_Drive-rescue:74LS259-TI-994A-SD_Drive-rescue U5
U 1 1 5C11BFE9
P 5500 5600
F 0 "U5" H 5500 5700 50  0000 C CNN
F 1 "74LS259" H 5500 5450 50  0000 C CNN
F 2 "" H 5500 5600 50  0001 C CNN
F 3 "" H 5500 5600 50  0001 C CNN
	1    5500 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5C11D4EF
P 6900 5050
F 0 "D1" H 6900 5150 50  0000 C CNN
F 1 "LED" H 6900 4950 50  0000 C CNN
F 2 "" H 6900 5050 50  0001 C CNN
F 3 "" H 6900 5050 50  0001 C CNN
	1    6900 5050
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R1
U 1 1 5C11D807
P 6900 5450
F 0 "R1" H 6930 5470 50  0000 L CNN
F 1 "100" H 6930 5410 50  0000 L CNN
F 2 "" H 6900 5450 50  0001 C CNN
F 3 "" H 6900 5450 50  0001 C CNN
	1    6900 5450
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 5C11DCBA
P 7100 5050
F 0 "#PWR0101" H 7100 4900 50  0001 C CNN
F 1 "+5V" H 7100 5190 50  0000 C CNN
F 2 "" H 7100 5050 50  0001 C CNN
F 3 "" H 7100 5050 50  0001 C CNN
	1    7100 5050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5C11DCDE
P 7100 5450
F 0 "#PWR0102" H 7100 5200 50  0001 C CNN
F 1 "GND" H 7100 5300 50  0000 C CNN
F 2 "" H 7100 5450 50  0001 C CNN
F 3 "" H 7100 5450 50  0001 C CNN
	1    7100 5450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0103
U 1 1 5C12ECE6
P 4800 5950
F 0 "#PWR0103" H 4800 5800 50  0001 C CNN
F 1 "+5V" H 4800 6090 50  0000 C CNN
F 2 "" H 4800 5950 50  0001 C CNN
F 3 "" H 4800 5950 50  0001 C CNN
	1    4800 5950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0104
U 1 1 5C130530
P 4550 2100
F 0 "#PWR0104" H 4550 1950 50  0001 C CNN
F 1 "+5V" H 4550 2240 50  0000 C CNN
F 2 "" H 4550 2100 50  0001 C CNN
F 3 "" H 4550 2100 50  0001 C CNN
	1    4550 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5C16C04A
P 4700 4100
F 0 "#PWR0105" H 4700 3850 50  0001 C CNN
F 1 "GND" H 4700 3950 50  0000 C CNN
F 2 "" H 4700 4100 50  0001 C CNN
F 3 "" H 4700 4100 50  0001 C CNN
	1    4700 4100
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 5C16C06E
P 4750 4200
F 0 "#PWR0106" H 4750 4050 50  0001 C CNN
F 1 "+5V" H 4750 4340 50  0000 C CNN
F 2 "" H 4750 4200 50  0001 C CNN
F 3 "" H 4750 4200 50  0001 C CNN
	1    4750 4200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4850 700  600  700 
Wire Wire Line
	600  700  600  4950
Wire Wire Line
	600  6300 2350 6300
Wire Wire Line
	4850 800  4250 800 
Wire Wire Line
	4850 900  4200 900 
Wire Wire Line
	650  6500 2350 6500
Wire Wire Line
	4850 1000 700  1000
Wire Wire Line
	700  6700 2350 6700
Wire Wire Line
	4850 1100 3900 1100
Wire Wire Line
	3900 1100 3900 2600
Wire Wire Line
	3900 6900 2850 6900
Wire Wire Line
	4850 1200 3950 1200
Wire Wire Line
	3950 1200 3950 2700
Wire Wire Line
	3950 7000 2850 7000
Wire Wire Line
	4850 1300 4000 1300
Wire Wire Line
	4000 1300 4000 2650
Wire Wire Line
	4000 6400 2850 6400
Wire Wire Line
	4850 1400 4050 1400
Wire Wire Line
	4050 1400 4050 4400
Wire Wire Line
	4050 6600 2850 6600
Wire Wire Line
	750  6400 1750 6400
Wire Wire Line
	4850 1600 800  1600
Wire Wire Line
	800  1600 800  3900
Wire Wire Line
	800  5800 1700 5800
Wire Wire Line
	4850 1700 850  1700
Wire Wire Line
	850  1700 850  3800
Wire Wire Line
	850  7000 1550 7000
Wire Wire Line
	900  1800 900  3700
Wire Wire Line
	900  6900 1600 6900
Wire Wire Line
	4850 1900 4100 1900
Wire Wire Line
	1250 2750 1250 5400
Wire Wire Line
	1250 5400 2350 5400
Wire Wire Line
	3700 2800 3700 5300
Wire Wire Line
	3700 5300 2850 5300
Wire Wire Line
	1300 2850 1300 5300
Wire Wire Line
	1300 5300 2350 5300
Wire Wire Line
	3650 2900 3650 5200
Wire Wire Line
	3650 5200 2850 5200
Wire Wire Line
	1350 2950 1350 5500
Wire Wire Line
	1350 5500 2350 5500
Wire Wire Line
	3600 3000 3600 5400
Wire Wire Line
	3600 5400 2850 5400
Wire Wire Line
	3550 3050 3550 5500
Wire Wire Line
	3550 5500 2850 5500
Wire Wire Line
	3500 3100 3500 5600
Wire Wire Line
	3500 5600 2850 5600
Wire Wire Line
	3850 6500 2850 6500
Wire Wire Line
	4100 6800 2850 6800
Wire Wire Line
	4100 1900 4100 3250
Wire Wire Line
	4550 2100 4650 2100
Wire Wire Line
	4650 2200 4850 2200
Wire Wire Line
	4650 2000 4650 2100
Connection ~ 600  4950
Wire Wire Line
	4800 5250 4450 5250
Wire Wire Line
	4450 5250 4450 4950
Wire Wire Line
	4450 4950 600  4950
Wire Wire Line
	2350 5600 1400 5600
Wire Wire Line
	6600 5450 6800 5450
Wire Wire Line
	6600 5050 6750 5050
Wire Wire Line
	7000 5450 7100 5450
Wire Wire Line
	7050 5050 7100 5050
Wire Wire Line
	2850 6200 4150 6200
Connection ~ 4100 6800
Wire Wire Line
	4450 7350 1750 7350
Wire Wire Line
	1750 7350 1750 6400
Connection ~ 1750 6400
Wire Wire Line
	4500 7400 1700 7400
Wire Wire Line
	1700 7400 1700 5800
Connection ~ 1700 5800
Wire Wire Line
	4700 6400 4700 5750
Wire Wire Line
	4700 5750 4800 5750
Wire Wire Line
	4800 5400 4500 5400
Wire Wire Line
	4500 5400 4500 4500
Wire Wire Line
	4800 5500 4550 5500
Wire Wire Line
	4550 5500 4550 4600
Wire Wire Line
	4800 5600 4600 5600
Wire Wire Line
	4600 5600 4600 4700
Wire Wire Line
	4850 2000 4650 2000
Connection ~ 4650 2100
Wire Wire Line
	6200 3200 1400 3200
Wire Wire Line
	1400 3200 1400 5600
Wire Wire Line
	6200 5250 6250 5250
Connection ~ 6250 5250
Wire Wire Line
	4550 7450 1600 7450
Wire Wire Line
	4900 7450 4600 7450
Wire Wire Line
	4600 7500 1550 7500
Wire Wire Line
	4700 6400 6400 6400
Wire Wire Line
	1550 7500 1550 7000
Connection ~ 1550 7000
Wire Wire Line
	1600 7450 1600 6900
Connection ~ 1600 6900
Wire Wire Line
	4500 6950 4900 6950
Wire Wire Line
	6450 7050 6100 7050
Wire Wire Line
	6400 6950 6100 6950
Wire Wire Line
	4700 4100 4750 4100
Wire Wire Line
	4750 4200 4800 4200
Wire Wire Line
	3400 4500 1000 4500
Wire Wire Line
	6250 3150 6250 5250
Wire Wire Line
	2650 3150 6250 3150
Wire Wire Line
	4850 2500 4350 2500
Wire Wire Line
	900  1800 4850 1800
$Comp
L TI-994A-SD_Drive-rescue:74LS30-TI-994A-SD_Drive-rescue U2
U 1 1 5C1B09B5
P 2700 3850
F 0 "U2" H 2700 3950 50  0000 C CNN
F 1 "74LS30" H 2700 3750 50  0000 C CNN
F 2 "" H 2700 3850 50  0001 C CNN
F 3 "" H 2700 3850 50  0001 C CNN
	1    2700 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 3300 3300 3850
Wire Wire Line
	4100 3250 1650 3250
Wire Wire Line
	1650 3250 1650 3600
Wire Wire Line
	1650 3600 2100 3600
Connection ~ 4100 3250
Wire Wire Line
	900  3700 2100 3700
Connection ~ 900  3700
Wire Wire Line
	850  3800 2100 3800
Connection ~ 850  3800
Wire Wire Line
	800  3900 2100 3900
Connection ~ 800  3900
Wire Wire Line
	750  4000 2100 4000
Wire Wire Line
	1650 4100 2100 4100
Wire Wire Line
	4050 4400 1650 4400
Connection ~ 4050 4400
Wire Wire Line
	600  4950 600  6300
Wire Wire Line
	1750 6400 2350 6400
Wire Wire Line
	1700 5800 2350 5800
Wire Wire Line
	4650 2100 4850 2100
Wire Wire Line
	4650 2100 4650 2200
Wire Wire Line
	6250 5250 6300 5250
Wire Wire Line
	1550 7000 2350 7000
Wire Wire Line
	1600 6900 2350 6900
Wire Wire Line
	4100 3250 4100 6800
Wire Wire Line
	900  3700 900  6900
Wire Wire Line
	850  3800 850  7000
Wire Wire Line
	800  3900 800  5800
Wire Wire Line
	750  4000 750  6400
Wire Wire Line
	4050 4400 4050 6600
$Comp
L 74xx:74LS04 U8
U 1 1 5C245CA9
P 7650 800
F 0 "U8" H 7600 800 50  0000 C CNN
F 1 "74LS04" H 7750 950 50  0000 C CNN
F 2 "" H 7650 800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 7650 800 50  0001 C CNN
	1    7650 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 3300 7700 3300
Connection ~ 3300 3300
Wire Wire Line
	550  6800 2350 6800
$Comp
L power:GND #PWR0107
U 1 1 5C60B3DB
P 7200 2400
F 0 "#PWR0107" H 7200 2150 50  0001 C CNN
F 1 "GND" H 7205 2227 50  0000 C CNN
F 2 "" H 7200 2400 50  0001 C CNN
F 3 "" H 7200 2400 50  0001 C CNN
	1    7200 2400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 5C60B48B
P 7200 800
F 0 "#PWR0108" H 7200 650 50  0001 C CNN
F 1 "+5V" H 7100 900 50  0000 C CNN
F 2 "" H 7200 800 50  0001 C CNN
F 3 "" H 7200 800 50  0001 C CNN
	1    7200 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 2100 7700 3300
Wire Wire Line
	6700 1100 6600 1100
Wire Wire Line
	7700 1100 9300 1100
Wire Wire Line
	7700 1200 9300 1200
Wire Wire Line
	7700 1300 9300 1300
Wire Wire Line
	7700 1400 9300 1400
Wire Wire Line
	7700 1500 9300 1500
Wire Wire Line
	7700 1600 9300 1600
Wire Wire Line
	7700 1700 9300 1700
Wire Wire Line
	7700 1800 9300 1800
$Comp
L power:GND #PWR0109
U 1 1 5C9326E0
P 9900 4800
F 0 "#PWR0109" H 9900 4550 50  0001 C CNN
F 1 "GND" H 9905 4627 50  0000 C CNN
F 2 "" H 9900 4800 50  0001 C CNN
F 3 "" H 9900 4800 50  0001 C CNN
	1    9900 4800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R3
U 1 1 5C932F57
P 11000 950
F 0 "R3" H 10800 1050 50  0000 L CNN
F 1 "10k" H 10750 950 50  0000 L CNN
F 2 "" V 11040 940 50  0001 C CNN
F 3 "~" H 11000 950 50  0001 C CNN
	1    11000 950 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5C933056
P 11000 800
F 0 "#PWR0111" H 11000 650 50  0001 C CNN
F 1 "+5V" H 10900 900 50  0000 C CNN
F 2 "" H 11000 800 50  0001 C CNN
F 3 "" H 11000 800 50  0001 C CNN
	1    11000 800 
	1    0    0    -1  
$EndComp
$Comp
L Device:CP1_Small C3
U 1 1 5C93321D
P 11000 1200
F 0 "C3" H 10800 1150 50  0000 L CNN
F 1 ".01" H 10800 1250 50  0000 L CNN
F 2 "" H 11000 1200 50  0001 C CNN
F 3 "~" H 11000 1200 50  0001 C CNN
	1    11000 1200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 5C943FC5
P 11000 1300
F 0 "#PWR0112" H 11000 1050 50  0001 C CNN
F 1 "GND" H 11005 1127 50  0000 C CNN
F 2 "" H 11000 1300 50  0001 C CNN
F 3 "" H 11000 1300 50  0001 C CNN
	1    11000 1300
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal_Small Y1
U 1 1 5C94407B
P 10700 1500
F 0 "Y1" H 10650 1600 50  0000 R CNN
F 1 "16mhz" V 10850 1600 50  0000 R CNN
F 2 "" H 10700 1500 50  0001 C CNN
F 3 "~" H 10700 1500 50  0001 C CNN
	1    10700 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:CP1_Small C1
U 1 1 5C94430C
P 10600 1700
F 0 "C1" H 10500 1550 50  0000 L CNN
F 1 "22pf" H 10450 1450 50  0000 L CNN
F 2 "" H 10600 1700 50  0001 C CNN
F 3 "~" H 10600 1700 50  0001 C CNN
	1    10600 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:CP1_Small C2
U 1 1 5C944442
P 10800 1700
F 0 "C2" H 10800 1550 50  0000 L CNN
F 1 "22pf" H 10800 1450 50  0000 L CNN
F 2 "" H 10800 1700 50  0001 C CNN
F 3 "~" H 10800 1700 50  0001 C CNN
	1    10800 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	10500 1500 10600 1500
Wire Wire Line
	10500 1300 10800 1300
Wire Wire Line
	10800 1300 10800 1500
Wire Wire Line
	10800 1600 10800 1500
Connection ~ 10800 1500
Wire Wire Line
	10600 1600 10600 1500
Connection ~ 10600 1500
Wire Wire Line
	10600 1800 10700 1800
$Comp
L power:GND #PWR0113
U 1 1 5C9AAA57
P 10700 1800
F 0 "#PWR0113" H 10700 1550 50  0001 C CNN
F 1 "GND" H 10705 1627 50  0000 C CNN
F 2 "" H 10700 1800 50  0001 C CNN
F 3 "" H 10700 1800 50  0001 C CNN
	1    10700 1800
	1    0    0    -1  
$EndComp
Connection ~ 10700 1800
Wire Wire Line
	10700 1800 10800 1800
Wire Wire Line
	2850 5900 3400 5900
Wire Wire Line
	3400 4500 3400 5900
Wire Wire Line
	9300 3600 9150 3600
Wire Wire Line
	9150 3600 9150 2750
Wire Wire Line
	9300 3500 9100 3500
Wire Wire Line
	9100 3500 9100 2800
Wire Wire Line
	9300 3400 9050 3400
Wire Wire Line
	9050 3400 9050 2850
Wire Wire Line
	9300 3300 9000 3300
Wire Wire Line
	9000 3300 9000 2900
Wire Wire Line
	9300 3200 8950 3200
Wire Wire Line
	8950 3200 8950 2950
Wire Wire Line
	8900 3150 8900 3000
Wire Wire Line
	9250 3050 9250 3000
Wire Wire Line
	9250 3000 9300 3000
Wire Wire Line
	9200 3100 9200 2900
Wire Wire Line
	9200 2900 9300 2900
Wire Wire Line
	9300 3100 9250 3100
Wire Wire Line
	9250 3100 9250 3150
Wire Wire Line
	9250 3150 8900 3150
Wire Wire Line
	10600 3800 10500 3800
Wire Wire Line
	2850 6000 3800 6000
Wire Wire Line
	3800 6000 3800 7700
Wire Wire Line
	3800 7700 6800 7700
Wire Wire Line
	6800 7700 6800 6300
Wire Wire Line
	6800 6300 11100 6300
Wire Wire Line
	11100 6300 11100 3900
Wire Wire Line
	11100 3900 10500 3900
Wire Wire Line
	2850 6700 3750 6700
Wire Wire Line
	3750 6700 3750 7750
Wire Wire Line
	3750 7750 6850 7750
Wire Wire Line
	6850 7750 6850 6350
Wire Wire Line
	6850 6350 11150 6350
Wire Wire Line
	4800 4000 4750 4000
Wire Wire Line
	4750 4000 4750 4100
Connection ~ 4750 4100
Wire Wire Line
	4750 4100 4800 4100
Wire Wire Line
	6200 5950 6200 6150
Wire Wire Line
	6200 6150 4400 6150
Wire Wire Line
	4400 6150 4400 4300
Wire Wire Line
	6200 5850 6300 5850
Wire Wire Line
	6300 5850 6300 6200
Wire Wire Line
	6300 6200 4350 6200
Wire Wire Line
	4350 6200 4350 3900
Wire Wire Line
	6200 5750 6400 5750
Wire Wire Line
	6400 5750 6400 6250
Wire Wire Line
	6400 6250 4300 6250
Wire Wire Line
	4300 6250 4300 3800
Wire Wire Line
	6200 5650 6500 5650
Wire Wire Line
	6500 5650 6500 6300
Wire Wire Line
	4250 6300 4250 3700
Wire Wire Line
	9300 2000 8400 2000
Wire Wire Line
	8400 2000 8400 2650
Wire Wire Line
	8400 2650 4250 2650
Wire Wire Line
	4250 2650 4250 800 
Connection ~ 4250 800 
Wire Wire Line
	4250 800  3850 800 
Wire Wire Line
	9300 2100 8450 2100
Wire Wire Line
	8450 2100 8450 2700
Wire Wire Line
	8450 2700 4200 2700
Wire Wire Line
	4200 2700 4200 900 
Connection ~ 4200 900 
Wire Wire Line
	4200 900  650  900 
$Comp
L Transistor_BJT:2N3904 Q2
U 1 1 5C2B1A3B
P 10950 3200
F 0 "Q2" H 10900 3400 50  0000 L CNN
F 1 "2N3904" H 10800 3500 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 11150 3125 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 10950 3200 50  0001 L CNN
	1    10950 3200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5C2B1BAE
P 10750 3400
F 0 "R2" H 10809 3446 50  0000 L CNN
F 1 "10k" V 10650 3350 50  0000 L CNN
F 2 "" H 10750 3400 50  0001 C CNN
F 3 "~" H 10750 3400 50  0001 C CNN
	1    10750 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5C300A92
P 11050 3450
F 0 "#PWR0114" H 11050 3200 50  0001 C CNN
F 1 "GND" H 11055 3277 50  0000 C CNN
F 2 "" H 11050 3450 50  0001 C CNN
F 3 "" H 11050 3450 50  0001 C CNN
	1    11050 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10750 3300 10750 3200
Wire Wire Line
	11050 3450 11050 3400
Wire Wire Line
	11050 3000 11150 3000
Wire Wire Line
	11150 3000 11150 6350
Wire Wire Line
	10500 4000 10750 4000
Wire Wire Line
	10750 4000 10750 3500
Wire Wire Line
	6200 5950 9050 5950
Connection ~ 6200 5950
Wire Wire Line
	6300 5850 9000 5850
Wire Wire Line
	9000 5850 9000 4400
Wire Wire Line
	9000 4400 9300 4400
Connection ~ 6300 5850
Wire Wire Line
	6400 5750 8950 5750
Wire Wire Line
	8950 5750 8950 4300
Wire Wire Line
	8950 4300 9300 4300
Connection ~ 6400 5750
Wire Wire Line
	6500 5650 8900 5650
Wire Wire Line
	8900 4200 9300 4200
Connection ~ 6500 5650
Wire Wire Line
	9300 4500 9050 4500
Wire Wire Line
	9050 4500 9050 5950
Wire Wire Line
	7950 800  7950 2000
Wire Wire Line
	7950 2000 7700 2000
Wire Wire Line
	7700 2100 8000 2100
Wire Wire Line
	8000 2100 8000 600 
Wire Wire Line
	11150 600  11150 2700
Wire Wire Line
	11150 2700 10600 2700
Wire Wire Line
	10600 2700 10600 3800
Text Label 6150 5650 0    39   ~ 0
DRIVE1
$Comp
L TI-994A-SD_Drive-rescue:SD_Module-MyLibrary-TI-994A-SD_Drive-rescue J2
U 1 1 5C36DC9F
P 7200 3900
F 0 "J2" H 7350 3650 50  0000 C CNN
F 1 "SD_Module" H 7350 3800 50  0000 C CNN
F 2 "" H 7200 3900 50  0001 C CNN
F 3 "http://portal.fciconnect.com/Comergent//fci/drawing/10067847.pdf" H 7200 3900 50  0001 C CNN
	1    7200 3900
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0115
U 1 1 5C36DEDF
P 8100 3500
F 0 "#PWR0115" H 8100 3250 50  0001 C CNN
F 1 "GND" V 8105 3372 50  0000 R CNN
F 2 "" H 8100 3500 50  0001 C CNN
F 3 "" H 8100 3500 50  0001 C CNN
	1    8100 3500
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 5C36DF80
P 8100 4200
F 0 "#PWR0116" H 8100 3950 50  0001 C CNN
F 1 "GND" V 8105 4072 50  0000 R CNN
F 2 "" H 8100 4200 50  0001 C CNN
F 3 "" H 8100 4200 50  0001 C CNN
	1    8100 4200
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0117
U 1 1 5C36E20B
P 8100 4000
F 0 "#PWR0117" H 8100 3850 50  0001 C CNN
F 1 "+5V" V 8115 4128 50  0000 L CNN
F 2 "" H 8100 4000 50  0001 C CNN
F 3 "" H 8100 4000 50  0001 C CNN
	1    8100 4000
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 2400 9300 2400
Wire Wire Line
	8600 2500 9300 2500
Wire Wire Line
	8700 2700 9300 2700
Wire Wire Line
	8750 2600 9300 2600
Wire Wire Line
	8100 3900 8550 3900
Wire Wire Line
	8550 2400 8550 3900
Wire Wire Line
	8600 3800 8100 3800
Wire Wire Line
	8600 2500 8600 3800
Wire Wire Line
	8700 3700 8100 3700
Wire Wire Line
	8700 2700 8700 3700
Wire Wire Line
	8750 3600 8100 3600
Wire Wire Line
	8750 2600 8750 3600
Wire Wire Line
	1650 4400 1650 4100
Text Label 2800 1950 0    39   ~ 0
MBE
Text Label 2750 2150 0    39   ~ 0
DSR_EN
Text Label 6250 5100 0    39   ~ 0
DSR_EN
Text Label 3500 1350 0    39   ~ 0
!CE
Text Label 1350 1350 0    39   ~ 0
!MBE
Text Label 2100 3500 0    39   ~ 0
CE
Text Label 4350 2500 0    39   ~ 0
!4000-5FEF
Text Label 2900 3650 0    39   ~ 0
!5FF0-5FFF
Text Label 4450 1900 0    39   ~ 0
A3
Text Label 2100 3600 0    39   ~ 0
A3
Text Label 1950 4200 0    39   ~ 0
A9-A11
Text Label 2100 3700 0    39   ~ 0
A4
Text Label 2100 3800 0    39   ~ 0
A5
Text Label 2100 3900 0    39   ~ 0
A6
Text Label 2100 4000 0    39   ~ 0
A7
Text Label 2100 4100 0    39   ~ 0
A8
Text Label 4650 4300 0    39   ~ 0
SIDE
Text Label 4600 4000 0    39   ~ 0
MOTORON
Text Label 4650 3700 0    39   ~ 0
DRIVE1
Text Label 4650 3800 0    39   ~ 0
DRIVE2
Text Label 4650 3900 0    39   ~ 0
DRIVE3
Text Label 6150 5750 0    39   ~ 0
DRIVE2
Text Label 6150 5850 0    39   ~ 0
DRIVE3
Text Label 6150 5950 0    39   ~ 0
SIDE
Text Label 6150 5350 0    39   ~ 0
STROBE
Text Label 6150 5450 0    39   ~ 0
IRQ
Text Label 6150 5550 0    39   ~ 0
HLT
Text Label 4650 3600 0    39   ~ 0
HLD
Text Label 6100 6750 0    39   ~ 0
1000_O
Text Label 6100 6850 0    39   ~ 0
1000_I
Text Label 6100 6950 0    39   ~ 0
1100_O
Text Label 6100 7050 0    39   ~ 0
1100_I
Text Label 6100 7150 0    39   ~ 0
1200_O
Text Label 6100 7250 0    39   ~ 0
1200_I
Text Label 6100 7350 0    39   ~ 0
1300_O
Text Label 6100 7450 0    39   ~ 0
1300_I
Text Label 4700 6750 0    39   ~ 0
!CRUCLK
Text Label 4800 6850 0    39   ~ 0
A7
Text Label 4800 6950 0    39   ~ 0
A6
Text Label 4800 7250 0    39   ~ 0
A3
Text Label 4800 7350 0    39   ~ 0
A4
Text Label 4800 7450 0    39   ~ 0
A5
Text Label 4700 5250 0    39   ~ 0
CRUOUT
Text Label 4700 5400 0    39   ~ 0
A14
Text Label 4700 5500 0    39   ~ 0
A13
Text Label 4700 5600 0    39   ~ 0
A12
Text Label 4700 5750 0    39   ~ 0
1100_O
Text Label 4700 4500 0    39   ~ 0
A14
Text Label 4700 4600 0    39   ~ 0
A13
Text Label 4700 4700 0    39   ~ 0
A12
Text Label 4700 4900 0    39   ~ 0
1100_I
Text Label 9050 4200 0    39   ~ 0
DRIVE1
Text Label 9050 4300 0    39   ~ 0
DRIVE2
Text Label 9050 4400 0    39   ~ 0
DRIVE3
Text Label 9100 4500 0    39   ~ 0
SIDE
Text Label 10500 4000 0    39   ~ 0
!READY
Text Label 10500 3900 0    39   ~ 0
!WE
Text Label 9100 2400 0    39   ~ 0
CS
Text Label 9100 2500 0    39   ~ 0
MOSI
Text Label 9100 2600 0    39   ~ 0
MISO
Text Label 9100 2700 0    39   ~ 0
SCK
Text Label 9100 2000 0    39   ~ 0
A14
Text Label 9100 2100 0    39   ~ 0
A13
Wire Wire Line
	10500 1100 11000 1100
Connection ~ 11000 1100
Text Notes 10050 3800 0    39   ~ 0
!INT2
Text Label 10650 2700 0    39   ~ 0
!5FC0-5FFF
Text Label 7750 2200 0    39   ~ 0
!5FF0-5FFF
$Comp
L 74xx:74LS04 U8
U 2 1 5F9BF9D9
P 9450 5150
F 0 "U8" H 9400 5150 50  0000 C CNN
F 1 "74LS04" H 9550 5300 50  0000 C CNN
F 2 "" H 9450 5150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 9450 5150 50  0001 C CNN
	2    9450 5150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U8
U 4 1 5F9C01FD
P 1750 1250
F 0 "U8" H 1700 1250 50  0000 C CNN
F 1 "74LS04" H 1800 1400 50  0000 C CNN
F 2 "" H 1750 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 1750 1250 50  0001 C CNN
	4    1750 1250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U8
U 3 1 5F9C039B
P 3350 1250
F 0 "U8" H 3300 1250 50  0000 C CNN
F 1 "74LS04" H 3400 1400 50  0000 C CNN
F 2 "" H 3350 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 3350 1250 50  0001 C CNN
	3    3350 1250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U8
U 5 1 5F9C0468
P 2600 1250
F 0 "U8" H 2550 1250 50  0000 C CNN
F 1 "74LS04" H 2650 1400 50  0000 C CNN
F 2 "" H 2600 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 2600 1250 50  0001 C CNN
	5    2600 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 3500 950  3500
Text Label 2000 1400 1    39   ~ 0
MBE
Wire Wire Line
	1000 1250 1000 4500
Text Label 2550 1400 0    39   ~ 0
!4000-5FEF
Text Label 2300 1450 1    39   ~ 0
!5FF0-5FFF
Wire Wire Line
	4350 1650 4350 2500
Wire Wire Line
	950  1050 3000 1050
$Comp
L 74xx:74LS04 U8
U 6 1 602C623D
P 10150 5150
F 0 "U8" H 10100 5150 50  0000 C CNN
F 1 "74LS04" H 10200 5300 50  0000 C CNN
F 2 "" H 10150 5150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 10150 5150 50  0001 C CNN
	6    10150 5150
	1    0    0    -1  
$EndComp
Text Label 3100 1350 0    39   ~ 0
CE
Wire Wire Line
	950  1050 950  3500
Wire Wire Line
	4400 1250 4400 2400
Wire Wire Line
	4400 2400 4850 2400
Wire Wire Line
	3450 2000 3450 1450
Wire Wire Line
	2150 2400 2150 2500
Wire Wire Line
	2150 2500 2850 2500
Wire Wire Line
	1550 2500 1550 2650
Text Label 1550 2550 0    39   ~ 0
A9
Text Label 1550 2350 0    39   ~ 0
A10
Text Label 2850 2350 0    39   ~ 0
A11
Wire Wire Line
	2100 4200 2100 4350
Wire Wire Line
	2100 4350 3450 4350
Wire Wire Line
	3450 4350 3450 2400
Text Label 3300 2500 0    39   ~ 0
A9-A11
Text Label 3300 2100 0    39   ~ 0
CE
$Comp
L 74xx:74LS08 U1
U 1 1 5FEC8A52
P 1850 2000
F 0 "U1" H 1800 2100 50  0000 C CNN
F 1 "74LS08" H 1850 2000 50  0000 C CNN
F 2 "" H 1850 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 1850 2000 50  0001 C CNN
	1    1850 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U1
U 2 1 5FEC8B21
P 1850 2400
F 0 "U1" H 1800 2500 50  0000 C CNN
F 1 "74LS08" H 1850 2400 50  0000 C CNN
F 2 "" H 1850 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 1850 2400 50  0001 C CNN
	2    1850 2400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U1
U 3 1 5FEC8BA6
P 3150 2000
F 0 "U1" H 3100 2100 50  0000 C CNN
F 1 "74LS08" H 3150 2000 50  0000 C CNN
F 2 "" H 3150 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 3150 2000 50  0001 C CNN
	3    3150 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U1
U 4 1 5FEC8C2B
P 3150 2400
F 0 "U1" H 3100 2500 50  0000 C CNN
F 1 "74LS08" H 3150 2400 50  0000 C CNN
F 2 "" H 3150 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 3150 2400 50  0001 C CNN
	4    3150 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 2100 2650 2100
Wire Wire Line
	2650 2100 2650 3150
Wire Wire Line
	1450 2300 1450 2700
Wire Wire Line
	1550 2300 1450 2300
Connection ~ 4000 2650
Wire Wire Line
	4000 2650 4000 6400
Wire Wire Line
	3950 2700 1450 2700
Connection ~ 3950 2700
Wire Wire Line
	3950 2700 3950 7000
Wire Wire Line
	3900 2600 2750 2600
Wire Wire Line
	2750 2600 2750 2300
Connection ~ 3900 2600
Wire Wire Line
	3900 2600 3900 6900
Wire Wire Line
	2750 2300 2850 2300
Wire Wire Line
	1550 2650 4000 2650
Wire Wire Line
	3000 1050 3000 1250
Wire Wire Line
	3000 1450 3450 1450
Wire Wire Line
	3650 1250 4400 1250
Wire Wire Line
	3000 1250 3050 1250
Connection ~ 3000 1250
Wire Wire Line
	3000 1250 3000 1450
Wire Wire Line
	2900 1250 2950 1250
Wire Wire Line
	2950 1250 2950 1650
Wire Wire Line
	2950 1650 4350 1650
Wire Wire Line
	2300 3300 3300 3300
Wire Wire Line
	1550 2100 1450 2100
Wire Wire Line
	1050 2100 1050 7100
Wire Wire Line
	1050 7100 2350 7100
Wire Wire Line
	1550 1900 1450 1900
Wire Wire Line
	1450 1900 1450 2100
Connection ~ 1450 2100
Wire Wire Line
	1450 2100 1050 2100
Wire Wire Line
	2300 1250 2300 3300
Wire Wire Line
	1450 1250 1000 1250
Wire Wire Line
	2050 1250 2050 1900
Wire Wire Line
	2050 1900 2850 1900
Text Label 1250 2050 0    39   ~ 0
!RESET
Wire Wire Line
	11000 1100 11100 1100
Wire Wire Line
	11100 1100 11100 500 
Wire Wire Line
	11100 500  8650 500 
Wire Wire Line
	2150 500  2150 2000
Wire Wire Line
	6600 3100 6600 1100
Connection ~ 6600 3100
Wire Wire Line
	6600 3100 9200 3100
Connection ~ 6600 1100
Wire Wire Line
	6600 1100 6600 700 
Wire Wire Line
	6250 700  6600 700 
Wire Wire Line
	3500 3100 6600 3100
Wire Wire Line
	3650 2900 6400 2900
Wire Wire Line
	1300 2850 6350 2850
Wire Wire Line
	1250 2750 6250 2750
Wire Wire Line
	3550 3050 6550 3050
Wire Wire Line
	3600 3000 6500 3000
Wire Wire Line
	1350 2950 6450 2950
$Comp
L TI-994A-SD_Drive-rescue:2764-TI-994A-SD_Drive-rescue U3
U 1 1 5C01D760
P 5550 1600
F 0 "U3" H 5550 1750 50  0000 C CNN
F 1 "2764" H 5550 1600 50  0000 C CNN
F 2 "" H 5550 1600 50  0001 C CNN
F 3 "" H 5550 1600 50  0001 C CNN
	1    5550 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 800  6550 800 
Wire Wire Line
	6550 800  6550 1200
Connection ~ 6550 3050
Wire Wire Line
	6550 3050 9250 3050
Wire Wire Line
	6250 900  6500 900 
Wire Wire Line
	6500 900  6500 1300
Connection ~ 6500 3000
Wire Wire Line
	6500 3000 8900 3000
Wire Wire Line
	6250 1000 6450 1000
Wire Wire Line
	6450 1000 6450 1400
Connection ~ 6450 2950
Wire Wire Line
	6450 2950 8950 2950
Wire Wire Line
	6250 1100 6400 1100
Wire Wire Line
	6400 1100 6400 1500
Connection ~ 6400 2900
Wire Wire Line
	6400 2900 9000 2900
Wire Wire Line
	6250 1200 6350 1200
Connection ~ 6350 2850
Wire Wire Line
	6350 2850 9050 2850
Wire Wire Line
	6350 1200 6350 1600
Wire Wire Line
	3700 2800 6300 2800
Wire Wire Line
	6250 1300 6300 1300
Wire Wire Line
	6300 1300 6300 1700
Connection ~ 6300 2800
Wire Wire Line
	6300 2800 9100 2800
Wire Wire Line
	6250 1400 6250 1800
Connection ~ 6250 2750
Wire Wire Line
	6250 2750 9150 2750
Wire Wire Line
	6700 1200 6550 1200
Connection ~ 6550 1200
Wire Wire Line
	6550 1200 6550 3050
Wire Wire Line
	6700 1300 6500 1300
Connection ~ 6500 1300
Wire Wire Line
	6500 1300 6500 3000
Wire Wire Line
	6700 1400 6450 1400
Connection ~ 6450 1400
Wire Wire Line
	6450 1400 6450 2950
Wire Wire Line
	6700 1500 6400 1500
Connection ~ 6400 1500
Wire Wire Line
	6400 1500 6400 2900
Wire Wire Line
	6700 1600 6350 1600
Connection ~ 6350 1600
Wire Wire Line
	6350 1600 6350 2850
Wire Wire Line
	6700 1700 6300 1700
Connection ~ 6300 1700
Wire Wire Line
	6300 1700 6300 2800
Wire Wire Line
	6700 1800 6250 1800
Connection ~ 6250 1800
Wire Wire Line
	6250 1800 6250 2750
NoConn ~ 9300 4000
NoConn ~ 9300 4100
NoConn ~ 8100 4100
NoConn ~ 6200 5350
NoConn ~ 6200 5450
NoConn ~ 6200 5550
NoConn ~ 6100 6750
NoConn ~ 6100 6850
NoConn ~ 6100 7150
NoConn ~ 6100 7250
NoConn ~ 6100 7350
NoConn ~ 6100 7450
NoConn ~ 2850 7200
NoConn ~ 2850 7100
NoConn ~ 2350 6600
NoConn ~ 2850 6300
NoConn ~ 2850 5100
NoConn ~ 2350 5100
NoConn ~ 2350 5200
NoConn ~ 2350 5700
NoConn ~ 4800 3600
NoConn ~ 2850 6100
NoConn ~ 2850 5800
NoConn ~ 2850 5700
NoConn ~ 9300 2200
NoConn ~ 9300 2300
Wire Wire Line
	2350 5900 2350 6000
Connection ~ 2350 6000
Wire Wire Line
	2350 6000 2350 6100
Connection ~ 2350 6100
Wire Wire Line
	2350 6100 2350 6200
$Comp
L power:GND #PWR0119
U 1 1 60D9198E
P 5500 7600
F 0 "#PWR0119" H 5500 7350 50  0001 C CNN
F 1 "GND" V 5505 7472 50  0000 R CNN
F 2 "" H 5500 7600 50  0001 C CNN
F 3 "" H 5500 7600 50  0001 C CNN
	1    5500 7600
	0    1    1    0   
$EndComp
$Comp
L TI-994A-SD_Drive-rescue:74LS138-TI-994A-SD_Drive-rescue U6
U 1 1 5C01E98E
P 5500 7100
F 0 "U6" H 5500 7250 50  0000 C CNN
F 1 "74LS138" H 5450 7100 50  0000 C CNN
F 2 "" H 5500 7100 50  0001 C CNN
F 3 "" H 5500 7100 50  0001 C CNN
	1    5500 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 6750 4900 6750
Wire Wire Line
	4450 6850 4900 6850
Wire Wire Line
	4100 7250 4900 7250
Wire Wire Line
	4550 7350 4900 7350
Wire Wire Line
	5500 7550 5500 7600
Wire Wire Line
	4100 6800 4100 7250
Wire Wire Line
	4150 6200 4150 6750
Wire Wire Line
	6400 6400 6400 6950
Wire Wire Line
	6450 6350 6450 7050
Wire Wire Line
	4600 7500 4600 7450
Wire Wire Line
	4550 7450 4550 7350
Wire Wire Line
	4500 6950 4500 7400
Wire Wire Line
	4450 6850 4450 7350
Wire Wire Line
	4650 6350 6450 6350
Wire Wire Line
	4250 6300 6500 6300
$Comp
L power:GND #PWR0122
U 1 1 6146DF79
P 5200 6050
F 0 "#PWR0122" H 5200 5800 50  0001 C CNN
F 1 "GND" V 5205 5922 50  0000 R CNN
F 2 "" H 5200 6050 50  0001 C CNN
F 3 "" H 5200 6050 50  0001 C CNN
	1    5200 6050
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0123
U 1 1 61495DD8
P 5200 5150
F 0 "#PWR0123" H 5200 5000 50  0001 C CNN
F 1 "+5V" V 5215 5278 50  0000 L CNN
F 2 "" H 5200 5150 50  0001 C CNN
F 3 "" H 5200 5150 50  0001 C CNN
	1    5200 5150
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 5150 5200 5200
Wire Wire Line
	5200 6000 5200 6050
$Comp
L power:+5V #PWR0124
U 1 1 6150D8C2
P 2500 3600
F 0 "#PWR0124" H 2500 3450 50  0001 C CNN
F 1 "+5V" H 2515 3773 50  0000 C CNN
F 2 "" H 2500 3600 50  0001 C CNN
F 3 "" H 2500 3600 50  0001 C CNN
	1    2500 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0125
U 1 1 6150DDAA
P 2500 4100
F 0 "#PWR0125" H 2500 3850 50  0001 C CNN
F 1 "GND" H 2505 3927 50  0000 C CNN
F 2 "" H 2500 4100 50  0001 C CNN
F 3 "" H 2500 4100 50  0001 C CNN
	1    2500 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 4100 2500 4050
Wire Wire Line
	2500 3650 2500 3600
Wire Wire Line
	6200 3200 6200 3750
NoConn ~ 6200 3850
Wire Wire Line
	4800 4900 4650 4900
Wire Wire Line
	4650 4900 4650 6350
Wire Wire Line
	4800 4700 4600 4700
Connection ~ 4600 4700
Wire Wire Line
	4800 4600 4550 4600
Connection ~ 4550 4600
Wire Wire Line
	4800 4500 4500 4500
Connection ~ 4500 4500
Wire Wire Line
	4600 4700 700  4700
Connection ~ 700  4700
Wire Wire Line
	700  4700 700  6700
Wire Wire Line
	700  1000 700  4700
Wire Wire Line
	4550 4600 650  4600
Connection ~ 650  4600
Wire Wire Line
	650  4600 650  6500
Wire Wire Line
	650  900  650  4600
Wire Wire Line
	4500 4500 3850 4500
Connection ~ 3850 4500
Wire Wire Line
	3850 4500 3850 6500
Wire Wire Line
	3850 800  3850 4500
Wire Wire Line
	4800 4300 4400 4300
Wire Wire Line
	4800 3900 4350 3900
Wire Wire Line
	4800 3700 4250 3700
$Comp
L power:GND #PWR0126
U 1 1 6196BE83
P 5200 5000
F 0 "#PWR0126" H 5200 4750 50  0001 C CNN
F 1 "GND" V 5205 4872 50  0000 R CNN
F 2 "" H 5200 5000 50  0001 C CNN
F 3 "" H 5200 5000 50  0001 C CNN
	1    5200 5000
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0127
U 1 1 6199537C
P 5200 3500
F 0 "#PWR0127" H 5200 3350 50  0001 C CNN
F 1 "+5V" V 5215 3628 50  0000 L CNN
F 2 "" H 5200 3500 50  0001 C CNN
F 3 "" H 5200 3500 50  0001 C CNN
	1    5200 3500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 3500 5200 3550
Wire Wire Line
	7350 550  550  550 
Wire Wire Line
	7350 550  7350 800 
Wire Wire Line
	550  550  550  6800
$Comp
L power:+5V #PWR0128
U 1 1 61A8DE79
P 5500 600
F 0 "#PWR0128" H 5500 450 50  0001 C CNN
F 1 "+5V" V 5515 728 50  0000 L CNN
F 2 "" H 5500 600 50  0001 C CNN
F 3 "" H 5500 600 50  0001 C CNN
	1    5500 600 
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0129
U 1 1 61A8F4C6
P 5500 2600
F 0 "#PWR0129" H 5500 2350 50  0001 C CNN
F 1 "GND" V 5505 2472 50  0000 R CNN
F 2 "" H 5500 2600 50  0001 C CNN
F 3 "" H 5500 2600 50  0001 C CNN
	1    5500 2600
	0    1    1    0   
$EndComp
Wire Wire Line
	5550 2600 5500 2600
Wire Wire Line
	5550 600  5500 600 
Wire Wire Line
	4300 3800 4800 3800
$Comp
L power:+5V #PWR0120
U 1 1 60FC3761
P 5500 6550
F 0 "#PWR0120" H 5500 6400 50  0001 C CNN
F 1 "+5V" V 5515 6678 50  0000 L CNN
F 2 "" H 5500 6550 50  0001 C CNN
F 3 "" H 5500 6550 50  0001 C CNN
	1    5500 6550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 4950 5200 5000
Wire Wire Line
	5500 6550 5500 6650
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 61EE81F6
P 2250 6000
F 0 "#FLG0101" H 2250 6075 50  0001 C CNN
F 1 "PWR_FLAG" V 2250 6127 50  0001 L CNN
F 2 "" H 2250 6000 50  0001 C CNN
F 3 "~" H 2250 6000 50  0001 C CNN
	1    2250 6000
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 61EEB0AF
P 2300 7200
F 0 "#FLG0102" H 2300 7275 50  0001 C CNN
F 1 "PWR_FLAG" V 2300 7327 50  0001 L CNN
F 2 "" H 2300 7200 50  0001 C CNN
F 3 "~" H 2300 7200 50  0001 C CNN
	1    2300 7200
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR0118
U 1 1 61EEEFD7
P 2250 7200
F 0 "#PWR0118" H 2250 7050 50  0001 C CNN
F 1 "+5V" V 2265 7328 50  0000 L CNN
F 2 "" H 2250 7200 50  0001 C CNN
F 3 "" H 2250 7200 50  0001 C CNN
	1    2250 7200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2250 6000 2350 6000
$Comp
L power:GND #PWR0121
U 1 1 61EEC677
P 2200 6000
F 0 "#PWR0121" H 2200 5750 50  0001 C CNN
F 1 "GND" H 2205 5827 50  0000 C CNN
F 2 "" H 2200 6000 50  0001 C CNN
F 3 "" H 2200 6000 50  0001 C CNN
	1    2200 6000
	1    0    0    -1  
$EndComp
Connection ~ 2250 6000
Wire Wire Line
	2200 6000 2250 6000
Wire Wire Line
	2250 7200 2300 7200
Wire Wire Line
	2350 7200 2300 7200
Connection ~ 2300 7200
$Comp
L MCU_Microchip_ATmega:ATmega162-16PU U9
U 1 1 62139133
P 9900 2800
F 0 "U9" H 9900 3900 50  0000 C CNN
F 1 "ATmega162-16PU" H 9850 3700 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm" H 9900 2800 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-2513-8-bit-AVR-Microntroller-ATmega162_Datasheet.pdf" H 9900 2800 50  0001 C CNN
	1    9900 2800
	-1   0    0    -1  
$EndComp
Text Label 2200 5100 0    39   ~ 0
-5V
Text Label 2200 5200 0    39   ~ 0
IAQ
Text Label 2200 5300 0    39   ~ 0
D2
Text Label 2200 5400 0    39   ~ 0
D0
Text Label 2200 5500 0    39   ~ 0
D4
Text Label 2150 5600 0    39   ~ 0
CRUIN
Text Label 2200 5700 0    39   ~ 0
A0
Text Label 2200 5800 0    39   ~ 0
A6
Text Label 1950 6300 0    39   ~ 0
A15_CRUOUT
Text Label 2200 6400 0    39   ~ 0
A7
Text Label 2200 6500 0    39   ~ 0
A13
Text Label 2150 6600 0    39   ~ 0
!LOAD
Text Label 2200 6700 0    39   ~ 0
A12
Text Label 2200 6800 0    39   ~ 0
DBIN
Text Label 2200 6900 0    39   ~ 0
A4
Text Label 2200 7000 0    39   ~ 0
A5
Text Label 2150 7100 0    39   ~ 0
!RESET
Text Label 2900 5100 0    39   ~ 0
AUDIO_IN
Text Label 2900 5200 0    39   ~ 0
D3
Text Label 2900 5300 0    39   ~ 0
D1
Text Label 2900 5400 0    39   ~ 0
D5
Text Label 2900 5500 0    39   ~ 0
D6
Text Label 2900 5600 0    39   ~ 0
D7
Text Label 2900 5700 0    39   ~ 0
!MEMEN
Text Label 2900 5800 0    39   ~ 0
A1
Text Label 2900 5900 0    39   ~ 0
!MBE
Text Label 2900 6000 0    39   ~ 0
!WE
Text Label 2900 6100 0    39   ~ 0
PHASE_3_CLK
Text Label 2900 6200 0    39   ~ 0
!CRUCLK
Text Label 2900 6300 0    39   ~ 0
A2
Text Label 2900 6400 0    39   ~ 0
A9
Text Label 2900 6500 0    39   ~ 0
A14
Text Label 2900 6600 0    39   ~ 0
A8
Text Label 2900 6700 0    39   ~ 0
READY
Text Label 2900 6800 0    39   ~ 0
A3
Text Label 2900 6900 0    39   ~ 0
A11
Text Label 2900 7000 0    39   ~ 0
A10
Text Label 2900 7100 0    39   ~ 0
!EXTINT
Text Label 2900 7200 0    39   ~ 0
SBE
$Comp
L Device:C C12
U 1 1 6049D81C
P 10850 5750
F 0 "C12" H 10965 5796 50  0000 L CNN
F 1 "0.1uf" H 10965 5705 50  0000 L CNN
F 2 "" H 10888 5600 50  0001 C CNN
F 3 "~" H 10850 5750 50  0001 C CNN
	1    10850 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C10
U 1 1 604A11AE
P 10600 5750
F 0 "C10" H 10715 5796 50  0000 L CNN
F 1 "0.1uf" H 10715 5705 50  0000 L CNN
F 2 "" H 10638 5600 50  0001 C CNN
F 3 "~" H 10600 5750 50  0001 C CNN
	1    10600 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 604A1660
P 10350 5750
F 0 "C8" H 10465 5796 50  0000 L CNN
F 1 "0.1uf" H 10465 5705 50  0000 L CNN
F 2 "" H 10388 5600 50  0001 C CNN
F 3 "~" H 10350 5750 50  0001 C CNN
	1    10350 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 604A1E65
P 10100 5750
F 0 "C7" H 10215 5796 50  0000 L CNN
F 1 "0.1uf" H 10215 5705 50  0000 L CNN
F 2 "" H 10138 5600 50  0001 C CNN
F 3 "~" H 10100 5750 50  0001 C CNN
	1    10100 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 604A2528
P 9850 5750
F 0 "C6" H 9965 5796 50  0000 L CNN
F 1 "0.1uf" H 9965 5705 50  0000 L CNN
F 2 "" H 9888 5600 50  0001 C CNN
F 3 "~" H 9850 5750 50  0001 C CNN
	1    9850 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 604A2C02
P 9350 5750
F 0 "C4" H 9465 5796 50  0000 L CNN
F 1 "0.1uf" H 9465 5705 50  0000 L CNN
F 2 "" H 9388 5600 50  0001 C CNN
F 3 "~" H 9350 5750 50  0001 C CNN
	1    9350 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C11
U 1 1 604D21BA
P 10850 4950
F 0 "C11" H 10965 4996 50  0000 L CNN
F 1 "0.1uf" H 10965 4905 50  0000 L CNN
F 2 "" H 10888 4800 50  0001 C CNN
F 3 "~" H 10850 4950 50  0001 C CNN
	1    10850 4950
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 604D2D40
P 10600 4950
F 0 "C9" H 10715 4996 50  0000 L CNN
F 1 "0.1uf" H 10715 4905 50  0000 L CNN
F 2 "" H 10638 4800 50  0001 C CNN
F 3 "~" H 10600 4950 50  0001 C CNN
	1    10600 4950
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 604D39B6
P 9600 5750
F 0 "C5" H 9715 5796 50  0000 L CNN
F 1 "0.1uf" H 9715 5705 50  0000 L CNN
F 2 "" H 9638 5600 50  0001 C CNN
F 3 "~" H 9600 5750 50  0001 C CNN
	1    9600 5750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0130
U 1 1 604D3D54
P 9600 5900
F 0 "#PWR0130" H 9600 5650 50  0001 C CNN
F 1 "GND" H 9605 5727 50  0000 C CNN
F 2 "" H 9600 5900 50  0001 C CNN
F 3 "" H 9600 5900 50  0001 C CNN
	1    9600 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0131
U 1 1 604D43D2
P 9350 5900
F 0 "#PWR0131" H 9350 5650 50  0001 C CNN
F 1 "GND" H 9355 5727 50  0000 C CNN
F 2 "" H 9350 5900 50  0001 C CNN
F 3 "" H 9350 5900 50  0001 C CNN
	1    9350 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0132
U 1 1 604D4797
P 10600 5100
F 0 "#PWR0132" H 10600 4850 50  0001 C CNN
F 1 "GND" H 10605 4927 50  0000 C CNN
F 2 "" H 10600 5100 50  0001 C CNN
F 3 "" H 10600 5100 50  0001 C CNN
	1    10600 5100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0133
U 1 1 604D4B18
P 10850 5100
F 0 "#PWR0133" H 10850 4850 50  0001 C CNN
F 1 "GND" H 10855 4927 50  0000 C CNN
F 2 "" H 10850 5100 50  0001 C CNN
F 3 "" H 10850 5100 50  0001 C CNN
	1    10850 5100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0134
U 1 1 604D4D78
P 10850 5900
F 0 "#PWR0134" H 10850 5650 50  0001 C CNN
F 1 "GND" H 10855 5727 50  0000 C CNN
F 2 "" H 10850 5900 50  0001 C CNN
F 3 "" H 10850 5900 50  0001 C CNN
	1    10850 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0135
U 1 1 604D54A5
P 10600 5900
F 0 "#PWR0135" H 10600 5650 50  0001 C CNN
F 1 "GND" H 10605 5727 50  0000 C CNN
F 2 "" H 10600 5900 50  0001 C CNN
F 3 "" H 10600 5900 50  0001 C CNN
	1    10600 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0136
U 1 1 604D567D
P 10350 5900
F 0 "#PWR0136" H 10350 5650 50  0001 C CNN
F 1 "GND" H 10355 5727 50  0000 C CNN
F 2 "" H 10350 5900 50  0001 C CNN
F 3 "" H 10350 5900 50  0001 C CNN
	1    10350 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0137
U 1 1 604D5987
P 10100 5900
F 0 "#PWR0137" H 10100 5650 50  0001 C CNN
F 1 "GND" H 10105 5727 50  0000 C CNN
F 2 "" H 10100 5900 50  0001 C CNN
F 3 "" H 10100 5900 50  0001 C CNN
	1    10100 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0138
U 1 1 604D5DA1
P 9850 5900
F 0 "#PWR0138" H 9850 5650 50  0001 C CNN
F 1 "GND" H 9855 5727 50  0000 C CNN
F 2 "" H 9850 5900 50  0001 C CNN
F 3 "" H 9850 5900 50  0001 C CNN
	1    9850 5900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0139
U 1 1 604D6001
P 9850 5600
F 0 "#PWR0139" H 9850 5450 50  0001 C CNN
F 1 "+5V" H 9950 5700 50  0000 C CNN
F 2 "" H 9850 5600 50  0001 C CNN
F 3 "" H 9850 5600 50  0001 C CNN
	1    9850 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0140
U 1 1 604D670F
P 10100 5600
F 0 "#PWR0140" H 10100 5450 50  0001 C CNN
F 1 "+5V" H 10200 5700 50  0000 C CNN
F 2 "" H 10100 5600 50  0001 C CNN
F 3 "" H 10100 5600 50  0001 C CNN
	1    10100 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0141
U 1 1 604D699A
P 10350 5600
F 0 "#PWR0141" H 10350 5450 50  0001 C CNN
F 1 "+5V" H 10450 5700 50  0000 C CNN
F 2 "" H 10350 5600 50  0001 C CNN
F 3 "" H 10350 5600 50  0001 C CNN
	1    10350 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0142
U 1 1 604D6E1D
P 10600 5600
F 0 "#PWR0142" H 10600 5450 50  0001 C CNN
F 1 "+5V" H 10700 5700 50  0000 C CNN
F 2 "" H 10600 5600 50  0001 C CNN
F 3 "" H 10600 5600 50  0001 C CNN
	1    10600 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0143
U 1 1 604D71E3
P 10850 5600
F 0 "#PWR0143" H 10850 5450 50  0001 C CNN
F 1 "+5V" H 10950 5700 50  0000 C CNN
F 2 "" H 10850 5600 50  0001 C CNN
F 3 "" H 10850 5600 50  0001 C CNN
	1    10850 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0144
U 1 1 604D756A
P 10850 4800
F 0 "#PWR0144" H 10850 4650 50  0001 C CNN
F 1 "+5V" H 10950 4900 50  0000 C CNN
F 2 "" H 10850 4800 50  0001 C CNN
F 3 "" H 10850 4800 50  0001 C CNN
	1    10850 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0145
U 1 1 604D7C78
P 10600 4800
F 0 "#PWR0145" H 10600 4650 50  0001 C CNN
F 1 "+5V" H 10700 4900 50  0000 C CNN
F 2 "" H 10600 4800 50  0001 C CNN
F 3 "" H 10600 4800 50  0001 C CNN
	1    10600 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0146
U 1 1 604D7EC4
P 9350 5600
F 0 "#PWR0146" H 9350 5450 50  0001 C CNN
F 1 "+5V" H 9450 5700 50  0000 C CNN
F 2 "" H 9350 5600 50  0001 C CNN
F 3 "" H 9350 5600 50  0001 C CNN
	1    9350 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0147
U 1 1 604D8308
P 9600 5600
F 0 "#PWR0147" H 9600 5450 50  0001 C CNN
F 1 "+5V" H 9700 5700 50  0000 C CNN
F 2 "" H 9600 5600 50  0001 C CNN
F 3 "" H 9600 5600 50  0001 C CNN
	1    9600 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	750  4000 750  1500
Wire Wire Line
	750  1500 4850 1500
Connection ~ 750  4000
NoConn ~ 10450 5150
NoConn ~ 9850 5150
NoConn ~ 9750 5150
NoConn ~ 9150 5150
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J3
U 1 1 60828467
P 8000 5050
F 0 "J3" H 8050 5467 50  0000 C CNN
F 1 "PROGRAM HEADER" H 8050 5376 50  0000 C CNN
F 2 "" H 8000 5050 50  0001 C CNN
F 3 "~" H 8000 5050 50  0001 C CNN
	1    8000 5050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0148
U 1 1 6082C12A
P 8350 5300
F 0 "#PWR0148" H 8350 5050 50  0001 C CNN
F 1 "GND" H 8350 5150 50  0000 C CNN
F 2 "" H 8350 5300 50  0001 C CNN
F 3 "" H 8350 5300 50  0001 C CNN
	1    8350 5300
	1    0    0    -1  
$EndComp
NoConn ~ 7800 4950
Wire Wire Line
	8300 5150 8350 5150
Wire Wire Line
	8350 5150 8350 5250
Wire Wire Line
	8300 5250 8350 5250
Connection ~ 8350 5250
Wire Wire Line
	8350 5250 8350 5300
Wire Wire Line
	8300 4950 8800 4950
Wire Wire Line
	8800 4950 8800 3800
Wire Wire Line
	8800 3800 9300 3800
Wire Wire Line
	8900 5650 8900 4200
Wire Wire Line
	8300 5050 8850 5050
Wire Wire Line
	8850 5050 8850 3900
Wire Wire Line
	8850 3900 9300 3900
Text Label 8350 4950 0    39   ~ 0
TX
Text Label 8350 5050 0    39   ~ 0
RX
Wire Wire Line
	7650 4600 7650 4850
Wire Wire Line
	7650 4850 7800 4850
Wire Wire Line
	8750 3600 8750 4450
Wire Wire Line
	8750 4450 7500 4450
Wire Wire Line
	7500 4450 7500 5250
Wire Wire Line
	7500 5250 7800 5250
Connection ~ 8750 3600
Wire Wire Line
	8700 3700 8700 4500
Wire Wire Line
	8700 4500 7550 4500
Wire Wire Line
	7550 4500 7550 5150
Wire Wire Line
	7550 5150 7800 5150
Connection ~ 8700 3700
Text Label 7650 4850 0    39   ~ 0
MOSI
Text Label 7650 5150 0    39   ~ 0
SCK
Text Label 7650 5250 0    39   ~ 0
MISO
Wire Wire Line
	8600 4600 7650 4600
Wire Wire Line
	8600 3800 8600 4600
Connection ~ 8600 3800
Wire Wire Line
	8000 600  11150 600 
Wire Wire Line
	7800 5050 7600 5050
Wire Wire Line
	7600 5050 7600 4550
Wire Wire Line
	7600 4550 8650 4550
Wire Wire Line
	8650 4550 8650 500 
Connection ~ 8650 500 
Wire Wire Line
	8650 500  2150 500 
Text Notes 9600 3800 0    39   ~ 0
RXD0
Text Notes 9600 3900 0    39   ~ 0
TXD0
$Comp
L power:+5P #PWR0110
U 1 1 60D79EE7
P 8500 4850
F 0 "#PWR0110" H 8500 4700 50  0001 C CNN
F 1 "+5P" H 8500 5000 50  0000 C CNN
F 2 "" H 8500 4850 50  0001 C CNN
F 3 "" H 8500 4850 50  0001 C CNN
	1    8500 4850
	1    0    0    -1  
$EndComp
$Comp
L power:+5P #PWR0149
U 1 1 60DAAF32
P 9900 750
F 0 "#PWR0149" H 9900 600 50  0001 C CNN
F 1 "+5P" H 10000 850 50  0000 C CNN
F 2 "" H 9900 750 50  0001 C CNN
F 3 "" H 9900 750 50  0001 C CNN
	1    9900 750 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0150
U 1 1 60DDCC40
P 9400 750
F 0 "#PWR0150" H 9400 600 50  0001 C CNN
F 1 "+5V" H 9300 850 50  0000 C CNN
F 2 "" H 9400 750 50  0001 C CNN
F 3 "" H 9400 750 50  0001 C CNN
	1    9400 750 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 750  9900 800 
$Comp
L Connector_Generic:Conn_02x01 J4
U 1 1 60E3DA6F
P 9600 750
F 0 "J4" H 9650 850 50  0000 C CNN
F 1 "PGM PWR" H 9650 650 50  0000 C CNN
F 2 "" H 9600 750 50  0001 C CNN
F 3 "~" H 9600 750 50  0001 C CNN
	1    9600 750 
	1    0    0    -1  
$EndComp
Connection ~ 9900 750 
Wire Wire Line
	8300 4850 8500 4850
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 60E75C7F
P 8600 4850
F 0 "#FLG0103" H 8600 4925 50  0001 C CNN
F 1 "PWR_FLAG" H 8600 5000 50  0001 C CNN
F 2 "" H 8600 4850 50  0001 C CNN
F 3 "~" H 8600 4850 50  0001 C CNN
	1    8600 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 4850 8600 4850
Connection ~ 8500 4850
Text Label 7650 5050 0    39   ~ 0
RST
$Comp
L Transistor_BJT:2N3904 Q1
U 1 1 6086F533
P 6500 5250
F 0 "Q1" H 6500 5500 50  0000 L CNN
F 1 "2N3904" H 6450 5600 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 6700 5175 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 6500 5250 50  0001 L CNN
	1    6500 5250
	1    0    0    -1  
$EndComp
Text Notes 9600 2200 0    39   ~ 0
RXD1
Text Notes 9600 2300 0    39   ~ 0
TXD1
$Comp
L 74xx:74LS540 U7
U 1 1 613F23A3
P 7200 1600
F 0 "U7" H 7200 1400 50  0000 C CNN
F 1 "74LS540" H 7200 1300 50  0000 C CNN
F 2 "" H 7200 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS540" H 7200 1600 50  0001 C CNN
	1    7200 1600
	-1   0    0    -1  
$EndComp
Connection ~ 7700 2100
$EndSCHEMATC
