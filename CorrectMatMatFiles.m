%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, ...
    imagesPath, tablePath, utilitiesPath] = getFolderPaths(basePath);

folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.

files = files(contains({files.name}, '.mat.mat'));


data = importProcessedData(files);

parfor i = 1:numel(data)
    FretData = data{1,i}.obj;
    if contains(FretData.fileName, '.mat') == 1
        [~, fileName, ~] = fileparts(FretData.fileName);
        FretData.fileName    = fileName;
    end
    savePath = FretData.savePath;
    splitPath = strsplit(savePath, '\');
    if numel(splitPath) == 12
        splitPath = splitPath(1:11);
    end
    savePath =  strjoin(splitPath(numel(splitPath)-3:numel(splitPath)), '/');
    FretData.savePath = fullfile(measurementsPath,savePath);
    FretData.saveMatFile

    delete(fullfile(files(i).folder, files(i).name))
end
