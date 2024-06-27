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
%% get BAl Table
BALTable = getBALtable(tablePath);
%% Settings
bandwith = 100;
%% Select Folder to Import
folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.

filesBAL = files(contains({files.name}, 'BAL.mat'));

filesBALCell = struct2cell(filesBAL);

%% Update Data
f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
for i = 1:height(BALTable)
    selFile = filesBAL(contains(filesBALCell(1,:), BALTable.name(i)));
    waitbar(i/height(BALTable),f,append("Loading: ", fullfile(createProcessedFilePath(selFile.folder, selFile.name, false), selFile.name)));

    obj = load(fullfile(createProcessedFilePath(selFile.folder, selFile.name, false), selFile.name));
    FretData = obj.obj;

    index1 = find(FretData.cutTime ==BALTable.timeBef(i));
    index2 = find(FretData.cutTime ==BALTable.timeAft(i));

    iwB1 = indexWBandwith(index1, bandwith);
    iwB2 = indexWBandwith(index2, bandwith);

       % dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "DFRET", "normFRET", "normRatio"];
    dataTypes = ["cutData", "RawRatio","btCorrectedData", "Ratio", "btPbCorrectedData", "NFRET", "normFRET", "normRatio"];
    for l = 1:numel(dataTypes)
        dataType = dataTypes(l);
        % Generate variable name based on data type
        variableName = genvarname(dataType);
        % Call calcFRETEfficiency function and get output values
        [FRET_Rel, FRET_Abs, FRET_Bef, FRET_Aft] = calcFRETEfficiency(FretData.(dataType).FRET, iwB1, iwB2);

        % Add output values as columns to the table
        tableData.(variableName + "_Rel")(i) = FRET_Rel;
        tableData.(variableName + "_Abs")(i) = FRET_Abs;
        tableData.(variableName + "_Bef")(i) = FRET_Bef;
        tableData.(variableName + "_Aft")(i) = FRET_Aft;
    end
end
close(f)

newBALTable = [BALTable(:,1:7) struct2table(structfun(@(x) x', tableData, 'UniformOutput', false))];
writetable(newBALTable, append(tablePath,'\BALTable.xlsx'));

%% Check and decide quality (optional)

clear quality
filesBALCell = struct2cell(filesBAL);
f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
for i = 1:height(BALTable)
    waitbar(i/height(BALTable),f,append("Loading: ", BALTable.name(i)), 'intpreter', 'none');
    measInd = find(contains(filesBALCell(1,:),BALTable.name(i)));
    FretData = data{1,measInd}.obj;
    FretData.createFRETPlot('btCorrectedData');
    quality(i) = openMeasQualityDialog(FretData.fileName);
    close
end