% Code for Futsal Group processing

% Clears the command window, closes all open figures, and clears the workspace
clc
close all
clear all

%% Import signal and define recording characteristics
% Load data from the specified .mat file
a = % use impordata for impoting the file you want to process

% Extract key recording properties
fm = round(a.samplingRate);         % Sampling frequency (Hz)
duration = a.length_sec;            % Recording duration (seconds)
in_test_1 = a.Markers(1,1) * fm;    % Start of Test 1 (samples)
in_test_2 = a.Markers(2,1) * fm;    % Start of Test 2 (samples)

% Gravitational acceleration constant
g = 1;

% Extract acceleration signals (scaled by gravity)
eje_x = cell2mat(a.Data(1,1)) * g;  % Mediolateral axis
eje_y = cell2mat(a.Data(1,2)) * g;  % Vertical axis
eje_z = cell2mat(a.Data(1,3)) * g;  % Anteroposterior axis

%% Define signal durations
dur_test = 30 * fm;                 % Actual test duration (samples)
fin_test_1 = in_test_1 + dur_test;  % End of Test 1 (samples)
fin_test_2 = in_test_2 + dur_test;  % End of Test 2 (samples)

% Test 1 (OA) occurs in the first 30 seconds; Test 2 (OC) occurs in the next 30 seconds

% Create a struct to store test information
pruebas(1).name = 'OA ML'; % Test 1 - Mediolateral axis
pruebas(2).name = 'OC ML'; % Test 2 - Mediolateral axis
pruebas(3).name = 'OA AP'; % Test 1 - Anteroposterior axis
pruebas(4).name = 'OC AP'; % Test 2 - Anteroposterior axis
pruebas(5).name = 'OA V';  % Test 1 - Vertical axis
pruebas(6).name = 'OC V';  % Test 2 - Vertical axis

% Extract mediolateral axis signals
pruebas(1).signal = eje_x(in_test_1:fin_test_1-1, 1); % Test 1
pruebas(2).signal = eje_x(in_test_2:fin_test_2-1, 1); % Test 2

% Extract anteroposterior axis signals
pruebas(3).signal = eje_z(in_test_1:fin_test_1-1, 1); % Test 1
pruebas(4).signal = eje_z(in_test_2:fin_test_2-1, 1); % Test 2

% Extract vertical axis signals
pruebas(5).signal = eje_y(in_test_1:fin_test_1-1, 1); % Test 1
pruebas(6).signal = eje_y(in_test_2:fin_test_2-1, 1); % Test 2

%% Preprocessing
% Extract the central 20 seconds of each recording (removes 5 seconds from start and end)
vent_elim = 5 * fm; % Number of samples to remove from start and end

% Resampling target frequency (Hz)
new_fm = 1500;

% Zero-centering method for detrend
method = 'constant';

% Digital filter design 
fc = 10;                             % Cut-off frequency (Hz)
n = 4;                               % Filter order
[b, a] = butter(n, fc / (new_fm / 2), 'low'); % Low-pass Butterworth filter

% Apply preprocessing steps to each test signal
for i = 1:size(pruebas, 2)
    % Extract central 20 seconds
    pruebas(i).signal_20s = pruebas(i).signal(vent_elim:...
        length(pruebas(i).signal) - vent_elim - 1, 1);
    
    % Resample signal to the target frequency
    pruebas(i).signal_resampled = resample(pruebas(i).signal_20s, new_fm, fm);
    
    % Zero-centering the signal
    pruebas(i).signal_centered = detrend(pruebas(i).signal_resampled, method);
    
    % Apply Butterworth filter
    pruebas(i).signal_filtered = filter(b, a, pruebas(i).signal_centered);
    
    % Compute RMS (Root Mean Square) of the filtered signal
    pruebas(i).rms_signal = rms(pruebas(i).signal_filtered);
    
    % Compute entropy of the filtered signal
    % Parameters: m = 2, r = 0.2 
    pruebas(i).signal_entropy = calcula_entropia(pruebas(i).signal_filtered);
end

