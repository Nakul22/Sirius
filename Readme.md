Sirius - A Self-Localization System for Resource-Constrained IoT Sensors
====

Welcome to the Sirius Artifact repository. This repository contains artifacts and instructures for ACM Badging in Mobisys'23 proceedings.

The instructions for the artifacts provided are divided into the following sections:

1. Hardware - Provides the necessary files and instructions to design, optimize and fabricate a reconfigurable antenna.

2. Software - Provides the scripts, datasets and pretrained models as artifacts as well as instructions to replicate the performance results of angle-of-arrival estimation.

# Hardware

## Hardware requirements

The hardware setup requires various components and tools during the design and fabrication process. The table below lists the components/tools that we used for our prototype. The links are provided for reference only and the user can use any other components that are available to them.

| Component/Tool  | Link |
| ------------- | ------------- |
| FR4 PCB sheet  | https://www.amazon.com/dp/B07R592M7G/ref=cm_sw_em_r_mt_dp_64GBDSG48XJH234KXX3A?th=1  |
| PCB milling machine  | https://www.digikey.com/en/product-highlight/b/bantam-tools/desktop-pcb-milling-machine  |
| Pin diodes  | https://www.mouser.com/ProductDetail/Infineon-Technologies/BAR-50-02V-H6327?qs=mzcOS1kGbgfPFJ4O0G4Xhg%3D%3D  |
| Inductors  | https://www.mouser.com/ProductDetail/Coilcraft/C403-2/?qs=lc2O%252BfHJPVZCAfzA70W0Ag%3D%3D  |
| Capacitors  | https://www.digikey.com/en/products/detail/avx-corporation/ACCU-P0805KITL2/724571  |
| Schottky diodes | https://www.digikey.com/en/products/detail/skyworks-solutions-inc/SMS7630-079LF/2052135 |
| USRP N210 | https://www.ettus.com/all-products/un210-kit/ |
| Tx Power Amplifier | https://www.qorvo.com/products/p/RF5110G |

## Antenna Design 

The Sirius antenna prototype is built for 900Mhz and 2.4Ghz ISM bands. We provide the Ansys HFSS design files for these antennas along with the Eagle schematic files for fabrication. The HFSS design file can be found in "HFSS_design/HFSS_design_900Mhz.aedt". The file consists of the antenna design along with lumped models of the pin-diode based switches. The HFSS model of the antenna can be opened using Ansys HFSS 2022R2 and tuned for any desired frequency based on the user's requirements.

We have also provided an accompaning matlab script "HFSS_design/show_antenna_gain_pattern.m" to visualise the antenna's gain-patterns and S11 response.

## Antenna Fabrication

We have provided the brd files for the already tuned antennas so that the user can directly fabricate the antenna. These file can be found in "hardware/reconfigurable_antennas/". We used 1.5mm thick FR4 substrate for our prototyping. We used the Bantam PCB milling machine to fabricate the double sided PCBs. The antenna cosists of two pin-diode swicthes along with DC blocking circuit. The brd file contians solder pads for these components. We used the BAR50-02v pin diode as switches, but any RF grade pin diode will work. The inductors are used as RF chokes to block AC current and isolate other wires from the antenna. More details about the antenna fabrication can be found in the paper.

## Envelope Detector

The envelope detector is used to extract the envelope of the received signal. We used a simple envelope detector circuit that consists of schottky diodes as rectifier, a low pass filter and an impedance mathcing network. The diode is used to rectify the signal and the low pass filter is used to filter out the high frequency components. The schematic and brd files for the envelope detector are provided in the folder "hardware/envelope_detector". Reference values of the low pass filter can be found in the paper.

The impedance matching network is not required for the recevier, but it is recommended to improve the sensitivity and range of the receiver. It is used to match the impedance of the envelope detector to the impedance of the antenna (50ohms). The schematic and brd files consists placeholders to add capacitors and inductors in pi-network. The user can use the provided schematic or modify it based on their implementation. We used a VNA to measure the required values of the impedance mathcing network.

# Software

## Software requirements

| Process | Software used |
| ------------- | ------------- |
| Antenna Design  | Ansys HFSS  |
| PCB Fabrication  | Autodesk Eagle  |
| Data processing  | Matlab  |

The results have been validated on a Macbook Air M1 running Matlab 2023a. the provided scripts will work on any linux or windows machine as well, with the following matlab packages installed.

| Matlab add-on package  | Version |
| ------------- | ------------- |
|DSP System Toolbox | 9.16 |
|Signal Processing Toolbox | 9.2 |
|Statistics and Machine Learning Toolbox | 12.5 |
|Communications Toolbox | 8.0 |
|Antenna Toolbox | 5.4 |
|Deep Learning Toolbox | 14.6 |
|Phased Array System Toolbox | 5.0 |

## Angle-of-arrival Performance

The performance of the angle-of-arrival estimation is evaluated using the dataset and scripts provided in the folder "aoa_performance". The dataset consists of collected gain patterns for the 900Mhz reconfigurable antenna. The test data and pretrained model are both stored as .mat files. Running the script "evaluate_aoa_estimation.m" will load the test data and pretrained model and evaluate the performance of the angle-of-arrival estimation. The script will plot the CDF of the errors along with a scatter plot of the estimated angles. These are the core results of the paper shown in Figure 14 (a) and (b).