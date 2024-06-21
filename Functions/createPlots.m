function createPlots(measurementsPath, imagesPath, folder, dataTypes, sepLines)

filesMat = dir(fullfile(folder, '**\*.*.mat'));


data = importProcessedData(filesMat);
parfor i = 1:numel(data)
    FretData = data{1,i}.obj;
    for l = 1:numel(dataTypes)
        fig = makePrettyPlot(FretData, dataTypes(l));
        fig = FretData.addPharmakaToFig("cutTime", fig, FretData.protocolStartTimeAC, FretData.protocolStructure, sepLines);
        lg = legend(fig.Children(1).Children(1));
        lg.Layout.Tile = 4;

        savePath = FretData.savePath;
        splitPath = strsplit(savePath, '\');
        if numel(splitPath) == 12
            splitPath = splitPath(1:11);
        end
        savePath =  strjoin(splitPath(numel(splitPath)-3:numel(splitPath)), '/');
        FretData.savePath = fullfile(measurementsPath,savePath);

        imgSavePath =  strrep(FretData.savePath, 'Processed', 'Images');
        warning('off', 'MATLAB:MKDIR:DirectoryExists');
        mkdir(imgSavePath);
        warning('on', 'MATLAB:MKDIR:DirectoryExists');  % Restore the warning state
        savePlotFigPng(fig, fullfile(imgSavePath,FretData.fileName), dataTypes(l));
    end
    close all
end
end
