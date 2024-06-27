%% FRET Pair%%
Donor = "mTq2";
Acceptor = "FlAsH";
%% Paths and Settings
addpath(genpath('C:\Users\Chris\OneDrive\Dokumente\FRET\Scripts'));
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
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
btData.btAD = bleedthroughAcceptor.mean.mean_LexLemSexSem;
btData.btDA = bleedthroughDonor.mean.mean_SexSemLexLem;
%%
%% Get Infotable
infoTable = getInfotable(basePath);
%% Get FileNames
[fileName, filePathFolder] = uigetfile();
%% Import Data
    fullName = fullfile(filePathFolder, fileName);
    disp(append('Loading: ', fullName));
    f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
    f.Children(1).Title.Interpreter = 'none';
    waitbar(0,f,append("Loading: ", fullName), 'Interpreter', 'none');
    load(fullName) % load the file
    saveFolder = createProcessedFilePath(char(measurementsPath), fullName);
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



