%% Clear and remove old stuff%%
clearvars
close all
%% FRET Pair%% 
Donor = "cpmTq2";
Acceptor = "FlAsH";
%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, ...
    imagesPath, tablePath, utilitiesPath] = getFolderPaths(basePath);
%% Get Background Intensities
bgData = getBackground(backgroundPath);
%% Get Bleedthrough Ratios
bleedthroughDonor = getBleedthrough(bleedthroughPath, Donor);
bleedthroughAcceptor = getBleedthrough(bleedthroughPath, Acceptor);
btData.btDF = bleedthroughDonor.mean.mean_SexSemSexLem;
btData.btAF = bleedthroughAcceptor.mean.mean_LexLemSexLem;
%btData.btAD = bleedthroughAcceptor.mean.mean_LexLemSexSem;
%btData.btDA = bleedthroughDonor.mean.mean_SexSemLexLem;
%btData.btAF = 0;
btData.btAD = 0;
btData.btDA = 0;
%% Get Gfactor
Gfactor = 0;
%% Get Efactor
Efactor = 0;
%% Update and get Infotable
infoTable = getInfotable(tablePath);
%% Get FileNames
mainPath = uigetdir;
matFiles = getFilePaths(mainPath);
matFilesProc = getFilePaths(createProcessedFilePath(char(measurementsPath), mainPath, true));
matFilesDif = findDifferentRows(matFiles, matFilesProc, 'FileName');

%% Import Data

%% Load and process measurements one by one
f0 = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
f0.Children(1).Title.Interpreter = 'none';
for i = 1:height(matFilesDif)
    file = matFilesDif.FilePath{i};
    [~, fileName, ~] = fileparts(matFilesDif.FileName{i});
    fullName = matFilesDif.FilePath{i};
    filePathFolder = matFilesDif.FilePathFolder{i};
    disp(append('Loading: ', fullName));
    f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
    f.Children(1).Title.Interpreter = 'none';
    waitbar(0,f,append("Loading: ", fullName), 'Interpreter', 'none');
    waitbar(i/height(matFilesDif),f0,append("Loading: ", fullName), 'Interpreter', 'none');
    load(fullName) % load the file
    saveFolder = createProcessedFilePath(char(measurementsPath), fullName, false);
    %% Downsampling and creation of FRETdata object
    waitbar(.11,f,'Downsampling your data');
    tableData = downsampleMeasData(measurementPlotData, 50, 10);
    FretData = FRETdata(tableData, bgData, btData, Gfactor, Efactor,fileName, filePathFolder, saveFolder);
    %% get Protocol Info
    FretData.protocolStartTime = FretData.getProtocolTime(infoTable, fileName);
    [FretData.protocol, FretData.protocolStructure] = getProtocolData(fileName, "-", 2, settingsPath);
    %% Cutting data
    waitbar(.20,f,'Cutting your data');
    [FretData.cutData, FretData.protocolStartTimeAC, FretData.cutTime] = FretData.cutMeasurement("rawData");
    %% Correcting intensities and BG
    waitbar(.29,f,'Correcting intensities of your data');
    FretData.btCorrectedData = FretData.correctIntensities("cutData");
    %% Correct photobleaching
    waitbar(.38,f,'Correct photobleaching of your data');
    [FretData.pbIndices, FretData.pbSlope, FretData.btPbCorrectedData] = FretData.correctBleaching("btCorrectedData", 200);
    %% Calculation FRET Ratio
    waitbar(.47,f,'Calculation FRET Ratio');
    FretData.RawRatio = FretData.calculateRatio("cutData");
    FretData.Ratio = FretData.calculateRatio("btCorrectedData");
    FretData.pbCorrectedRatio = FretData.calculateRatio("btPbCorrectedData");
    %% Calculation NFRET
    waitbar(.56,f,'Calculation NFRET');
    FretData.NFRET = FretData.calculateNFRET("btCorrectedData");
    %% Calculation EFRET
    waitbar(.65,f,'Calculation EFRET');
    FretData.EFRET = FretData.calculateEFRET("cutData");
    %% Calculation DFRET
    waitbar(.74,f,'Calculation DFRET');
    FretData.DFRET = FretData.calculateDFRET("cutData");
    %% Norming
    waitbar(.83,f,'Norming your data');
    FretData.normPbCorrectedFRET = FretData.normFRETtoOne("btPbCorrectedData", 100,500);
    FretData.normFRET = FretData.normFRETtoOne("btCorrectedData", 100,500);
    %% Calculation normed FRET Ratio
    waitbar(.92,f,'Calculation normed FRET Ratio');
    FretData.normRatio = FretData.calculateRatio("normFRET");
    FretData.normPbCorrectedRatio = FretData.calculateRatio("normPbCorrectedFRET");
    %% Saving
    waitbar(1,f,'Saving your data');
    FretData.saveMatFile
    close(f)
end
    close(f0)
%% Load everything at once and then process one by one
f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
f.Children(1).Title.Interpreter = 'none';
for i = 1:height(matFilesDif)
    file = matFilesDif.FilePath{i};
    [~, fileName{i}, ~] = fileparts(matFilesDif.FileName{i});
    fullName = matFilesDif.FilePath{i};
    filePathFolder = matFilesDif.FilePathFolder{i};
    disp(append('Loading: ', fullName));
    waitbar(i/height(matFilesDif),f,append("Loading: ", fullName), 'Interpreter', 'none');
    load(fullName) % load the file
    saveFolder = createProcessedFilePath(char(measurementsPath), fullName, false);
    %% Downsampling and creation of FRETdata object
    tableData = downsampleMeasData(measurementPlotData, 50, 10);
    FretData(i) = FRETdata(tableData, bgData, btData, Gfactor, Efactor,fileName{i}, filePathFolder, saveFolder);
end
disp('Loading: Done!');
close(f)
%% Process data
for i = 1:numel(FretData)
    f = waitbar(0, "This is a slightly smaller placeholder");
    f.Children(1).Title.Interpreter = 'none';
    %% get Protocol Info
    FretData(i).protocolStartTime = FretData(i).getProtocolTime(infoTable, fileName{i});
    [FretData(i).protocol, FretData(i).protocolStructure] = getProtocolData(fileName{i}, "-", 1, settingsPath);
    %% Cutting data
    waitbar(.20,f,'Cutting your data');
    [FretData(i).cutData, FretData(i).protocolStartTimeAC, FretData(i).cutTime] = FretData(i).cutMeasurement("rawData");
    %% Correcting intensities and BG
    waitbar(.29,f,'Correcting intensities of your data');
    FretData(i).btCorrectedData = FretData(i).correctIntensities("cutData");
    %% Correct photobleaching
    waitbar(.38,f,'Correct photobleaching of your data');
    [FretData(i).pbIndices, FretData(i).pbSlope, FretData(i).btPbCorrectedData] = FretData(i).correctBleaching("btCorrectedData", 200);
    %% Calculation FRET Ratio
    waitbar(.47,f,'Calculation FRET Ratio');
    FretData(i).RawRatio = FretData(i).calculateRatio("cutData");
    FretData(i).Ratio = FretData(i).calculateRatio("btCorrectedData");
    FretData(i).pbCorrectedRatio = FretData(i).calculateRatio("btPbCorrectedData");
    %% Calculation NFRET
    waitbar(.56,f,'Calculation NFRET');
    FretData(i).NFRET = FretData(i).calculateNFRET("btCorrectedData");
    %% Calculation EFRET
    waitbar(.65,f,'Calculation EFRET');
    FretData(i).EFRET = FretData(i).calculateEFRET("cutData");
    %% Calculation DFRET
    waitbar(.74,f,'Calculation DFRET');
    FretData(i).DFRET = FretData(i).calculateDFRET("cutData");
    %% Norming
    waitbar(.83,f,'Norming your data');
    FretData(i).normPbCorrectedFRET = FretData(i).normFRETtoOne("btPbCorrectedData", 100,500);
    FretData(i).normFRET = FretData(i).normFRETtoOne("btCorrectedData", 100,500);
    %% Calculation normed FRET Ratio
    waitbar(.92,f,'Calculation normed FRET Ratio');
    FretData(i).normRatio = FretData(i).calculateRatio("normFRET");
    FretData(i).normPbCorrectedRatio = FretData(i).calculateRatio("normPbCorrectedFRET");
    %% Saving
    waitbar(1,f,'Saving your data');
    FretData(i).saveMatFile
    close(f)
    disp('Done!');
end