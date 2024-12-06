# Overview
This repository contains two MATLAB scripts designed to preprocess and analyze acceleration data for two different experimental groups: the Futsal Group and the Control Group. These scripts implement standardized signal processing techniques, including filtering, resampling, and entropy calculation, to extract meaningful metrics for further analysis.

# Scripts
# # 1. Futsal Group Processing
Processes acceleration data for futsal players, focusing on specific tests. The script:

1. Imports Data: Reads .mat files containing acceleration signals along three axes (mediolateral, anteroposterior, and vertical).
2. Signal Segmentation: Extracts test-specific signal segments based on predefined markers.
3. Preprocessing:
3.1. Extracts the central 20 seconds of each segment.
3.2. Resamples signals to 1500 Hz for uniform analysis.
3.3. Centers signals at zero using detrending.
3.4. Applies a low-pass Butterworth filter (cut-off frequency: 10 Hz, 4th order).
4. Feature Extraction:
4.1. Calculates Root Mean Square (RMS) for filtered signals.
4.2. Computes entropy of the filtered signals using predefined parameters (e.g., m=2, r=0.2).

# # 2. Control Group Processing
Processes acceleration data for the control group, handling multiple files in a batch. The script:

1. Batch Processing:
1.1. Loops through all .mat files in a specified folder.
1.2. Extracts acceleration signals along mediolateral and anteroposterior axes.
2. Preprocessing:
2.1. Trims the first 5 seconds and extracts 30-second segments for each test.
2.2. Centers signals at zero using detrending.
2.3. Applies a low-pass Butterworth filter (cut-off frequency: 10 Hz, 4th order).
3. Feature Extraction:
3.1. Computes RMS for filtered signals.
3.3. Calculates entropy for each signal.

# Requirements
- MATLAB R2020a or later. 
- Input data should be in .mat format, containing acceleration signals and metadata (e.g., sampling frequency, test markers).
- Predefined function 'calcula_entropia.m' is required for entropy calculation (included, plus its nested functions in file 'calcula_entropia')

