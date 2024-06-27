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
%% BAl Table
BALDataRaw = getBALtable(tablePath);
%%
Localisation = readtable(fullfile(tablePath,'Localisation.xlsx'), "UseExcel", false);
Localisation.vec = categorical(Localisation.vec);
Localisation.AA = categorical(Localisation.AA);
Localisation.newMidi = categorical(Localisation.midi);
Localisation = removevars(Localisation, "midi");
%%
BALData = BALDataRaw(BALDataRaw.quality == 1,:);
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(double(BALData.midi)) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;
BALData = join(BALData, Localisation); 
%%
BALStats = grpstats(BALData, "newMidi", ["median", "min", "max", "std"] , "DataVars", ["RawRatio_Rel", "RawRatio_Abs"]);
unique_dates_count = groupsummary(BALData, ["newMidi", "dateMeas"]);
unique_Measdays = groupsummary(unique_dates_count, "newMidi");
unique_Measdays.Properties.VariableNames = {'Midi' ,  'Measurement Days'};

writetable(BALStats, fullfile(tablePath,'BALStatsSummary.xlsx'));
writetable(unique_Measdays , fullfile(tablePath,'BALStatsSummary.xlsx'), 'Sheet', 'uniqueMeasurementdays');


disp("BALStats calculated and saved under:");
disp(fullfile(tablePath,'BALStatsSummary.xlsx'));
disp('--------------------------------------------------------');
