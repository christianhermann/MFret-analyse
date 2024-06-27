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
%% Calculate Background Intensities
calculateBackground
%% Calculate Bleedthrough Ratios
calculateBleedthrough
%% create InfoTable
createInfoTable
%% Calculate E-Factor

%% Calculate G-Factor