%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, imagesPath] = getFolderPaths(basePath);

%% BAl Table 

dataTable = readtable(append(basePath,'AnalysisBAL.xlsx'));

bandwith = 100;

folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.

filesBAL = files(contains({files.name}, 'BAL.mat'));

name = struct2table(filesBAL).name;
splitnames = cell(size(name));


if exist("dataTable", "var")
    tableNames = dataTable.name;
else
    tableNames = "0";
end
for i = 1:numel(name)
isThere(i) = ~any(strcmp(tableNames, name{i}));
end
filesBAL = filesBAL(isThere);


f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
                f.Children(1).Title.Interpreter = 'none';

data = cell(1, numel(filesBAL));
for i = 1:numel(filesBAL)
    filename = fullfile(filesBAL(i).folder, filesBAL(i).name);
    waitbar(i/numel(filesBAL),f,append("Loading: ", filename), 'Interpreter', 'none');
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end
                close(f)


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

   % dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "DFRET", "normFRET", "normRatio"];

    dataTypes = ["cutData", "btCorrectedData",  "Ratio"];
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

    timeBef(i,1) = FretData.cutTime(dataIndex(i,1));
    timeAft(i,1) = FretData.cutTime(dataIndex(i,2));
    close;

    nameTable(i,1) = string(filesBAL(i).name);
    splitnames{i} = split(filesBAL(i).name, '-');
    midi(i,1) = str2double(splitnames{i}{4});
    midiCo(i,1) = NaN;
    if length(splitnames{i}) == 9
        midiCo(i,1) = str2double(splitnames{i}{6});
    end
    dateMeas(i,1) = string(splitnames{i}{1});
    quality(i,1) = 1;
end
name = nameTable;



% 
% for i = 1:length(name)
%     splitnames{i} = split(name{i}, '-');
%     midi(i,1) = str2double(splitnames{i}{4});
%     midiCo(i,1) = NaN;
%     if length(splitnames{i}) == 9
%         midiCo(i,1) = str2double(splitnames{i}{6});
%     end
%     dateMeas(i,1) = string(splitnames{i}{1});
% end
% quality = ones(numel(name),1);
newTable = [table(name, midi, midiCo,dateMeas, timeBef, timeAft, quality) struct2table(structfun(@(x) x', tableData, 'UniformOutput', false))];

name1 = dataTable.name;
name2 = newTable.name;
newNames = name2(~ismember(name2, name1));  
newTable = newTable(ismember(newTable.name, newNames), :);
dataTable = [dataTable; newTable];

writetable(dataTable, 'C:\Users\Chris\OneDrive\Dokumente\FRET\AnalysisBAL2.xlsx');



