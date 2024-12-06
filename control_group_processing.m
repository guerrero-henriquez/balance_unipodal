% Code for Control Group processing

% Clears the workspace, closes all open figures, and clears the command window
clear all
close all
clc

%% Data Import (Step 1)
% Defines the folder where the .mat files are located
folder = % Specify folder

% Retrieves a list of all .mat files in the folder
files = dir(fullfile(folder, '*.mat'));

% Counts the total number of files
num_files = length(files);

% Loops through each file to process the data
for i = 1:num_files
    % Imports data from the current file (commented out in the original code)
    % data(i).oa_d = importdata(files(i).name);

    % Sampling frequency (assumed to be consistent across all files)
    fs = data(1).oa_d.samplingRate;

    % Extracts acceleration time series: mediolateral (ML) and anteroposterior (AP)
    data(i).oa_d_ml = cell2mat(data(i).oa_d.Data(1,1));
    data(i).oa_d_ap = cell2mat(data(i).oa_d.Data(1,3));

    % Calculates the start index of activity plus 5 seconds
    % The start is based on a temporal marker and the sampling frequency
    data(i).in_oa_d = (data(i).oa_d.Markers(1,1) * fs) + 5 * fs;

    % Calculates the index for a 30-second segment, considering an initial 5-second offset
    data(i).seg_30_oa_d = data(i).in_oa_d + (25 * fs);

    % Extracts the trimmed signal for the defined interval (30 seconds)
    data(i).cortadas_ml  = data(i).oa_d_ml(data(i).in_oa_d:data(i).seg_30_oa_d-1);
    data(i).cortadas_ap = data(i).oa_d_ap(data(i).in_oa_d:data(i).seg_30_oa_d-1);
end

%% Signal Processing
% Defines the method for centering the signals to zero
method = 'constant';

% Defines the parameters for the Butterworth filter
fc = 10; % Cut-off frequency (Hz)
n = 4;   % Filter order

% Designs the Butterworth filter
[b, a] = butter(n, fc / (fs / 2));

% Processes each data set
for i = 1:size(data, 2)
    % Centers the signals to zero using the 'detrend' function
    data(i).signal_centered_ml = detrend(data(i).cortadas_ml, method);
    data(i).signal_centered_ap = detrend(data(i).cortadas_ap, method);

    % Applies the Butterworth filter to the centered signals
    data(i).signal_butt_ml = filter(b, a, data(i).signal_centered_ml);
    data(i).signal_butt_ap = filter(b, a, data(i).signal_centered_ap);

    % Calculates the RMS (Root Mean Square) of the filtered signals
    data(i).rms_ml = rms(data(i).signal_butt_ml);
    data(i).rms_ap = rms(data(i).signal_butt_ap);

    % Calculates the entropy of the filtered signals
    % Assumes 'calcula_entropia' is a user-defined function
    [data(i).entropy_ml] = calcula_entropia(data(i).signal_butt_ml);
    [data(i).entropy_ap] = calcula_entropia(data(i).signal_butt_ap);
end
