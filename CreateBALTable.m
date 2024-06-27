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
bandwith = 100; %% How many individuel points will be averaged to get a value
%% Select Folder to Import
folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.

filesBAL = files(contains({files.name}, 'BAL.mat'));

%% Create some variables
name = struct2table(filesBAL).name;
splitnames = cell(size(name));
if exist("BALTable", "var")
    tableNames = BALTable.name;
else
    tableNames = "0";
end
%% Check if there are new files to process
clear isThere;
for i = 1:numel(name)
    isThere(i) = ~any(strcmp(tableNames, strrep(name{i},'.mat','')));
end
filesBALNew = filesBAL(isThere);
%% Import
data = importProcessedData(filesBALNew);
clear quality
%% Process Data
for i = 1:numel(data)
    FretData = data{1,i}.obj;
    fig = tiledlayout(2,2);
    title(FretData.fileName);
    nexttile
    plot(FretData.cutTime, FretData.btCorrectedData.FRET,  '-o');
    nexttile
    plot(FretData.cutTime, FretData.btCorrectedData.Donor,  '-o');
    for j = 1:2
        shg
        dcm_obj = datacursormode(1);
        set(dcm_obj,'DisplayStyle','window',...
            'SnapToDataVertex','off','Enable','on');
        waitforbuttonpress
        c_info{j} = getCursorInfo(dcm_obj);
        dataIndex(i,j) = c_info{j}.DataIndex;
    end
    iwB1 = indexWBandwith(dataIndex(i,1), bandwith);
    iwB2 = indexWBandwith(dataIndex(i,2), bandwith);

    %Which data will be used for the bal ratio calculation
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

    %Set quality
    quality(i) = openMeasQualityDialog(FretData.fileName);

    timeBef(i,1) = FretData.cutTime(dataIndex(i,1));
    timeAft(i,1) = FretData.cutTime(dataIndex(i,2));
    close;

    if contains(filesBALNew(i).folder, "+") == true
        nameInfoTable(i,:) = extractNameInfo(FretData.fileName, 4,6);
    else
        nameInfoTable(i,:) = extractNameInfo(FretData.fileName, 4);
    end

end
disp("Finished processing");
disp('--------------------------------------------------------')

%% Update and safe BAL Table
quality = quality';
newBALTable = [nameInfoTable table(quality, timeBef, timeAft) struct2table(structfun(@(x) x', tableData, 'UniformOutput', false))];
newBALTable = findDifferentRows(newBALTable, BALTable);
BALTable = [BALTable; newBALTable];
writetable(BALTable, append(tablePath,'\BALTable.xlsx'));
disp("BALTable calculated and saved under:");
disp(append(tablePath,'\BALTable.xlsx'));
disp('--------------------------------------------------------')


%% Check new Measurement plots and decide quality (optional)
clear quality
for i = 1:numel(data)
    FretData = data{1,i}.obj;
    FretData.createFRETPlot('btCorrectedData');
    quality(i) = openMeasQualityDialog(FretData.fileName);
    close
end
