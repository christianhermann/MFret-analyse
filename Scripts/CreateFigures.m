folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.



filesMat = files(contains({files.name}, '.mat'));
dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "DFRET", "normFRET", "normRatio"];

for i = 1:numel(filesMat)
    filename = fullfile(filesMat(i).folder, filesMat(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
    FretData = data{1,i}.obj;
    for l = 1:numel(dataTypes)
        fig = makePrettyPlot(FretData, dataTypes(l));
        fig = FretData.addPharmakaToFig("cutTime", fig, FretData.protocolStartTimeAC, FretData.protocolStructure);
        lg = legend(fig.Children(1).Children(1));
        lg.Layout.Tile = 4;

        imgSavePath =  strrep(FretData.savePath, 'Processed', 'Images');
warning('off', 'MATLAB:MKDIR:DirectoryExists');
            mkdir(imgSavePath);
warning('on', 'MATLAB:MKDIR:DirectoryExists');  % Restore the warning state
        savePlotFigPng(fig, fullfile(imgSavePath,FretData.fileName), dataTypes(l));
    end
    close all
end

