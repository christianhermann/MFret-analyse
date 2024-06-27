%% Clear and remove old stuff
clearvars
close all
%% FRET Pair%%
% Donor = "cpmTq2";
% Acceptor = "FlAsH";
%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, ...
    imagesPath, tablePath, utilitiesPath] = getFolderPaths(basePath);
%% Get Background Intensities
% bgData = getBackground(backgroundPath);
%% Get Bleedthrough Ratios
% bleedthroughDonor = getBleedthrough(bleedthroughPath, Donor);
% bleedthroughAcceptor = getBleedthrough(bleedthroughPath, Acceptor);
% btData.btDF = bleedthroughDonor.mean.mean_SexSemSexLem;
% btData.btAF = bleedthroughAcceptor.mean.mean_LexLemSexLem;
% %btData.btAD = bleedthroughAcceptor.mean.mean_LexLemSexSem;
% %btData.btDA = bleedthroughDonor.mean.mean_SexSemLexLem;
% %btData.btAF = 0;
% btData.btAD = 0;
% btData.btDA = 0;
%% Update and get Infotable
infoTable = getInfotable(tablePath);
%% Get Files
folder = uigetdir(); % replace with the actual path to the folder

%files = dir(fullfile(folder, '**\*.09.*'));
files = dir(fullfile(folder, '**\*.mat'));

data = importProcessedData(files);
%% Process
f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
%parpool(3)
parfor i = 1:numel(data)
%for i = 1:numel(data)


%filename = fullfile(files(i).folder, files(i).name);
  %  waitbar(i/numel(data),f,append("Loading: ", filename));

    FretData = data{1,i}.obj;

    FretData.protocolStartTime = FretData.getProtocolTime(infoTable, FretData.fileName);
    [FretData.protocol, FretData.protocolStructure] = getProtocolData(FretData.fileName, "-", 2, settingsPath);

    % if ~isempty(FretData.RawRatio) continue; end
    % FretData.RawRatio = FretData.calculateRatio("cutData");
 %   if FretData.btData.btAF ~= 0
 %       continue
 %   end
    % Filter for empty pbIndices
  %  if ~isempty(FretData.pbIndices)
  %      continue
  %  end
    % FretData.btData = btData;
    % FretData.btCorrectedData = FretData.correctIntensities("cutData");
    % 
    % 
    % if isempty(FretData.pbIndices)
    %     [FretData.pbIndices, FretData.pbSlope, FretData.btPbCorrectedData] = FretData.correctBleaching("btCorrectedData", 200);
    % else
    %     dIwB1Old = FretData.pbIndices(2,:);
    %     dIwB2Old = FretData.pbIndices(3,:);
    %     [FretData.pbIndices, FretData.pbSlope, FretData.btPbCorrectedData] = FretData.correctBleaching("btCorrectedData", 200,dIwB1Old, dIwB2Old);
    % 
    % end
    % 
    % FretData.Ratio = FretData.calculateRatio("btCorrectedData");
    % FretData.NFRET = FretData.calculateNFRET("btCorrectedData");
    % FretData.EFRET = 0;
    % FretData.DFRET = 0;
    % FretData.normPbCorrectedFRET = FretData.normFRETtoOne("btPbCorrectedData", 100,500);
    % FretData.normFRET = FretData.normFRETtoOne("btCorrectedData", 100,500);
    % FretData.normRatio = FretData.calculateRatio("normFRET");
    % FretData.normPbCorrectedRatio = FretData.calculateRatio("normPbCorrectedFRET");
    %% Saving

 %   FretData.savePath = fileparts(filename);
    FretData.saveMatFile
    % dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET"];
    % set(0,'DefaultFigureVisible','off');
    % for l = 1:numel(dataTypes)
    %     fig = makePrettyPlot(FretData, dataTypes(l));
    %     fig = FretData.addPharmakaToFig("cutTime", fig, FretData.protocolStartTimeAC, FretData.protocolStructure);
    %     lg = legend(fig.Children(1).Children(1));
    %     lg.Layout.Tile = 4;
    % 
    %     imgSavePath =  strrep(FretData.savePath, 'Processed', 'Images');
    %     warning('off', 'MATLAB:MKDIR:DirectoryExists');
    %     mkdir(imgSavePath);
    %     warning('on', 'MATLAB:MKDIR:DirectoryExists');  % Restore the warning state
    %     savePlotFigPng(fig, fullfile(imgSavePath,FretData.fileName), dataTypes(l));
    % end
    % close all

end
set(0,'DefaultFigureVisible','on');
close(f)
