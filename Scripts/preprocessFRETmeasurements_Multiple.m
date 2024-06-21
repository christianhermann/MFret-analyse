addpath(genpath('C:\Users\Chris\OneDrive\Dokumente\FRET\'));
bt = load('C:\Users\Chris\OneDrive\Dokumente\FRET\BleedThrough\btmTq2FlAsH.mat');
%bt = load('C:\Users\Chris\OneDrive\Dokumente\FRET\BleedThrough\btAtto425FlAsH.mat');
%bt = load('C:\Users\Chris\OneDrive\Dokumente\FRET\BleedThrough\btcpmTq2FlAsH.mat');
%bt = load('C:\Users\Chris\OneDrive\Dokumente\FRET\BleedThrough\btmTq2CF500.mat');
fns = fieldnames(bt);
bt = bt.(fns{1});
btData.btDF = bt.DF;
btData.btAF = bt.AF;
btData.btAD = bt.AD;
btData.btDA = bt.DA;

bgData = getBackground;

Gfactor  = load('C:\Users\Chris\OneDrive\Dokumente\FRET\G-Factor\G-Factor_mTq2-FlAsH.mat');
%Gfactor  = load('C:\Users\Chris\OneDrive\Dokumente\FRET\G-Factor\G-Factor_cpmTq2-FlAsH.mat');
Gfactor = Gfactor.MeanGFactor;
%Gfactor = 0;

Efactor = load('C:\Users\Chris\OneDrive\Dokumente\FRET\E-Factor\E-Factor_mTq2-FlAsH.mat');
Efactor = Efactor.MeanEFactor;
Efactor = 0;

settingsPath = 'C:\Users\Chris\OneDrive\Dokumente\FRET\Settings\';
infoTable = readtable("C:\Users\Chris\OneDrive\Dokumente\FRET\Auswertung.xlsx",  "UseExcel", false);
folderTopLevel = uigetdir(); % replace with the actual path to the folder

files = dir(folderTopLevel);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subDirs = files(dirFlags); % A structure with extra info.
% Get only the folder names into a cell array.
subDirsNames = {subDirs(3:end).name};


for k = 1:length(subDirsNames)
    %matFiles = dir(fullfile(folder,subDirsNames{k},'*.mat')); % get a list of all .mat files in the folder
    subfolder = dir(fullfile(folderTopLevel,subDirsNames{k}));
    % Get a logical vector that tells which is a directory.
    subdirFlags = [subfolder.isdir];
    % Extract only those that are directories.
    subsubDirs = subfolder(subdirFlags); % A structure with extra info.
    % Get only the folder names into a cell array.
    subsubDirsNames = {subsubDirs(3:end).name};

    for l = 1:length(subsubDirsNames)
        matFiles = dir(fullfile(folderTopLevel,subDirsNames{k},subsubDirsNames{l},'*.mat')); % get a list of all .mat files in the folder
        folderTopLevelSplit = regexp(folderTopLevel, '\', 'split');
        procFolder = append(strjoin(folderTopLevelSplit(1:(numel(folderTopLevelSplit)-1)),'\'), '\Processed\', strjoin(folderTopLevelSplit(numel(folderTopLevelSplit)),'\'));
        matProcFiles = dir(fullfile(procFolder,subDirsNames{k},subsubDirsNames{l},'*.mat')); % get a list of all .mat files in the folder
        matFilesDif = findDifferentRows(matFiles, matProcFiles);
        if isempty(matFilesDif)
            continue
        end
        for i = 1:length(matFilesDif) % iterate through the list
            file = matFilesDif(i);
            if file.isdir == 0 % check if the file is not a directory
                fullName = fullfile(folderTopLevel,subDirsNames{k},subsubDirsNames{l},file.name);
                disp(append('Loading: ', fullName));
                f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
                f.Children(1).Title.Interpreter = 'none';
                waitbar(0,f,append("Loading: ", fullName), 'Interpreter', 'none');
                load(fullName) % load the file
                disp('Finished');
                [folder, fileName, fileExtension] = fileparts(fullName);
                folderSplit = regexp(folder, '\', 'split');
                saveFolder = append(strjoin(folderSplit(1:(numel(folderSplit)-3)),'\'), '\Processed\', strjoin(folderSplit((numel(folderSplit)-2):numel(folderSplit)),'\'));
                waitbar(.11,f,'Downsampling your data');
                tableData = downsampleMeasData(measurementPlotData, 50, 10);
                FretData = FRETdata(tableData, bgData, btData, Gfactor, Efactor, fileName, folder, saveFolder);
                FretData.protocolStartTime = FretData.getProtocolTime(infoTable, fileName);
                fileNameSplit = split(fileName, '-');
                try
                FretData.protocol = FretData.getProtocolName(fileName, '-', -2);
                FretData.protocolStructure = FretData.getProtocolData(FretData.protocol, settingsPath);
                catch
                    disp('No protocol found')
                    FretData.protocol = "No";
                end
                waitbar(.20,f,'Cutting your data');
                [FretData.cutData, FretData.protocolStartTimeAC, FretData.cutTime] = FretData.cutMeasurement("rawData");
                waitbar(.29,f,'Correcting intensities of your data');
                FretData.btCorrectedData = FretData.correctIntensities("cutData");
                waitbar(.38,f,'Correct photobleaching of your data');
                [FretData.pbIndices, FretData.pbSlope, FretData.btPbCorrectedData] = FretData.correctBleaching("btCorrectedData", 200);
                waitbar(.47,f,'Calculation FRET Ratio');
                FretData.Ratio = FretData.calculateRatio("btCorrectedData");
                FretData.pbCorrectedRatio = FretData.calculateRatio("btPbCorrectedData");
                waitbar(.56,f,'Calculation NFRET');
                FretData.NFRET = FretData.calculateNFRET("btCorrectedData");
                waitbar(.65,f,'Calculation EFRET');
                FretData.EFRET = FretData.calculateEFRET("cutData");
                waitbar(.74,f,'Calculation DFRET');
                FretData.DFRET = FretData.calculateDFRET("cutData");
                waitbar(.83,f,'Norming your data');
                FretData.normPbCorrectedFRET = FretData.normFRETtoOne("btPbCorrectedData", 100,500);
                FretData.normFRET = FretData.normFRETtoOne("btCorrectedData", 100,500);
                waitbar(.92,f,'Calculation normed FRET Ratio');
                FretData.normRatio = FretData.calculateRatio("normFRET");
                FretData.normPbCorrectedRatio = FretData.calculateRatio("normPbCorrectedFRET");
                waitbar(1,f,'Saving your data');
                FretData.saveMatFile
                close(f)
            end
        end
    end
end