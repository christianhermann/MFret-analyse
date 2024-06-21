function [bleedthrough intensities] = bleedthroughFunction(folder, bgData)
%BLEEDTHROUGHFUNCTION Calculate bleedthrough values from measurement data
%   bleedthrough = bleedthroughFunction(folder) calculates the bleedthrough values from measurement
%   data files located in the specified folder. The function reads .mat files in the folder and
%   performs calculations to estimate the bleedthrough values.
%
%   Inputs:
%   - folder: The folder path containing the measurement data files.
%
%   Output:
%   - bleedthrough: A table containing the calculated bleedthrough values for each data file.
%
%   Example:
%   folder = 'C:\MeasurementData';
%   bleedthrough = bleedthroughFunction(folder);
%
%   See also DIR, STRUCT2CELL, CELL2MAT, MOVMEAN.

% Define parameters
windowSize = 1;
downsampleFrequency = 1;

% Get a list of .mat files in the specified folder
files = dir(folder);
dirFlags = [files.isdir];
files = files(~dirFlags);
files = files(contains({files.name}, '.mat'));
bleedthrough = table();

% Process each data file
for i = 1:size(files)
    % Load data from the .mat file
    load(fullfile(files(i).folder, files(i).name))
    
    downsampledData = cell(4, 1);
    rows = zeros(4, 1);
    
    % Process each measurement plot
    for j = 1:4 
        % Extract data from the measurement plot
        dataCell = struct2cell(struct(measurementPlotData(j)));
        dataMat = cell2mat(dataCell)';
        
        % Calculate rolling mean of the data
        rollingMean = movmean(dataMat, windowSize);
        
        % Downsample the data
        downsampledData{j} = array2table(rollingMean(1:downsampleFrequency:end, :), ...
            'VariableNames', {append('time_', num2str(j)), append('value_', num2str(j))});
        
        rows(j) = size(downsampledData{j}, 1);
    end
    
    % Determine the minimum number of rows in the downsampled data
    minRows = min(rows);
    
    % Trim the downsampled data to the minimum number of rows
    data{1} = table2array(downsampledData{1}(1:minRows, 2)) - bgData.Donor;
    data{2} = table2array(downsampledData{2}(1:minRows, 2)) - bgData.Empty;
    data{3} = table2array(downsampledData{3}(1:minRows, 2)) - bgData.FRET;
    data{4} = table2array(downsampledData{4}(1:minRows, 2)) - bgData.Acceptor;
    
    % Calculate the bleedthrough values

    bleedthrough.SexSemSexLem(i) = mean(data{3} ./ data{1});
    bleedthrough.LexLemSexLem(i) = mean(data{3} ./ data{4});
    bleedthrough.SexSemLexLem(i) = mean(data{4} ./ data{1});
    bleedthrough.LexLemSexSem(i) = mean(data{1} ./ data{4});

    intensities.Donor(i) = mean(data{1});
    intensities.FRET(i) = mean(data{2});
    intensities.Empty(i) = mean(data{3});
    intensities.Acceptor(i) = mean(data{4});
end

end