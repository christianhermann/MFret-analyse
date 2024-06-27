%% Clear and remove old stuff
clearvars
close all
%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, ...
    imagesPath, tablePath, utilitiesPath] = getFolderPaths(basePath);
addpath(genpath(utilitiesPath));

%% Select Folder of Measurements
folder = uigetdir(); % replace with the actual path to the folder
%% Select wanted dataTypes
%dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "DFRET", "normFRET", "normRatio"];
dataTypes = ["cutData", "RawRatio"];
%% Create Plots with seperation lines
%createPlots(measurementsPath, imagesPath, folder, dataTypes, true);
%% Create Plots without seperation lines
createPlots(measurementsPath, imagesPath, folder, dataTypes, true);