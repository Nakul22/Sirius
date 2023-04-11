Sirius - A Self-Localization System for Resource-Constrained IoT Sensors
====

Welcome to the Sirius Artifact repository. This repository contains artifacts and instructions for ACM Badging in Mobisys'23 proceedings.

The instructions for the artifacts provided are divided into the following sections:

1. [Hardware](#hardware) - Provides the necessary files and instructions to design, optimize and fabricate the reconfigurable antenna and the envelope detector. The antenna design and fabrication files are found in the [./hardware_schematics](./hardware_schematics) folder.

2. [Software](#software) - Provides the scripts, datasets and pretrained models to evaluate the angle-of-arrival estimation performance of the system. The matlab script [./aoa_performance/evaluate_aoa_estimation.m](./aoa_performance/evaluate_aoa_estimation.m) can be used to evaluate the performance of the AoA estimation.


# Hardware

## Hardware requirements

The hardware setup requires various components and tools during the design and fabrication process. Below is a list of components and tools we used for our prototype. However, users can choose to use any other available components.

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

The Sirius antenna prototypes have been designed to operate in the 900MHz and 2.4GHz ISM bands. We provide the Ansys HFSS design files for these antennas, which can be used along with the Eagle schematic files for PCB fabrication. The HFSS design files are located in [./HFSS_design](./HFSS_design). The .aedt file consists of the antenna model as well as the lumped components of the pin-diode based switches. These files can be opened with Ansys HFSS 2022R2 and can be modified for any desired frequency based on user requirements.

To help visualize the designed antenna's gain-patterns and S11 return loss (reflection coefficient), we have also included a MATLAB script called [./HFSS_design/show_antenna_gain_pattern.m](./HFSS_design/show_antenna_gain_pattern.m).

## Antenna Fabrication

We have provided BRD files for pre-tuned 900MHz and 2.4GHz antennas to allow users to directly fabricate the hardware. These files can be found in the [./hardware_schematics/reconfigurable_antennas](./hardware_schematics/reconfigurable_antennas) folder. For our prototypes, we used 1.5mm thick FR4 substrate and the Bantam PCB milling machine to fabricate double-sided PCBs. The antenna consists of two pin-diode switches along with DC blocking circuits, and the BRD file has solder pad placeholders for these components. While we used BAR50-02v pin-diodes in our prototype, any RF grade pin-diode should also work. We also utilized inductors as RF chokes to block AC current and isolate other wires from the antenna, resulting in improved performance. Additional details about antenna fabrication can be found in the accompanying paper.

## Envelope Detector

An envelope detector is used to extract the envelope of the received signal. We implemented a simple envelope detector circuit, which includes schottky diodes as rectifiers, a low pass filter, and an impedance matching network. The diode rectifies the signal, and the low pass filter eliminates high-frequency components. The schematic and BRD files for the envelope detector are available in the [./hardware_schematics/envelope_detector/](./hardware_schematics/envelope_detector/)" folder. Reference values for the low pass filter can be found in the paper.

Although not required, an impedance matching network can improve the sensitivity and range of the receiver. This network is used to match the impedance of the envelope detector to the impedance of the designed antenna (50ohms). The schematic and BRD files contain solder pads for capacitors and inductors in a pi-network. Users can choose to use the provided schematic or modify it based on their implementation. We suggest using a Vector Network Analyzer (VNA) to measure the impedance of both the antenna and the envelope detector for precise matching.

# Software

## Software requirements

Sirius implementation used the folllwing software tools for antenna design, PCB fabrication, and data processing. The table below lists the software used for each process.

| Process | Software used |
| ------------- | ------------- |
| Antenna Design  | Ansys HFSS  |
| PCB Fabrication  | Autodesk Eagle  |
| Data processing  | Matlab  |

We have validated the results on a Macbook Air M1 running Matlab 2023a. However, the provided scripts should work on any Linux or Windows machine with the following add-on packages installed.

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

To evaluate the performance of the angle-of-arrival (AoA) estimation, we provide sample datasets and Matlab scripts in the [./aoa_performance](./aoa_performance) folder. These datasets include real world experiments data collected for the 900Mhz reconfigurable antenna. The test data and pretrained model are stored as .mat files. Running the "evaluate_aoa_estimation.m" script will load the test data and pretrained model, and evaluate the AoA estimation performance. The script also generates plots of the CDF of angle-errors and a scatter plot of the estimated angles. These plots reflect the core results of the paper and demonstrate the overall system performance, as shown in section "AoA Performance" of the paper.