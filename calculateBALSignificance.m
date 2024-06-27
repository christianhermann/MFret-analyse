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
addpath(genpath(utilitiesPath));
%% BAl Table
BALDataRaw = getBALtable(tablePath);


%% Localisation table
Localisation = readtable(fullfile(tablePath,'Localisation.xlsx'), "UseExcel", false);
Localisation.vec = categorical(Localisation.vec);
Localisation.AA = categorical(Localisation.AA);
Localisation.newMidi = categorical(Localisation.midi);
Localisation = removevars(Localisation, "midi");
%% augment table
BALData = BALDataRaw(BALDataRaw.quality == 1,:);
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(double(BALData.midi)) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;
BALData = join(BALData, Localisation);

%% Filter

BalDataC = BALData(BALData.locFlAsH == "C",:);
BalDataC_C = BalDataC(BalDataC.vec == "fl-mTq2" | BalDataC.vec == "trunc-mTq2",:);
BalDataC_N = BalDataC(BalDataC.vec == "cpmTq2-fl",:);
BalDataN = BALData(BALData.locFlAsH == "N",:);
BalDataN_C = BalDataN(BalDataN.vec == "fl-mTq2" | BalDataN.vec == "trunc-mTq2",:);
BalDataN_N = BalDataN(BalDataN.vec == "cpmTq2-fl",:);

BalDataWoRec = BALData(ismissing(BALData.midiCo),:);
BalDataflmtq2 = BalDataWoRec(BalDataWoRec.vec == "fl-mTq2",:);
BalDatatruncmtq2 = BalDataWoRec(BalDataWoRec.vec == "trunc-mTq2",:);
BalDatamtq2fl = BalDataWoRec(BalDataWoRec.vec == "cpmTq2-fl",:);

BalDataRec = BALData(~ismissing(BALData.midiCo),:);

BalDataRec = BALData(ismember(BALData.midi, unique(BalDataRec.midi)),:);
BalDataRec = BalDataRec(BalDataRec.midi ~= "1381",:);

%% Significance U tests Receptors
Variable = 'RawRatio_Rel';
uniqueMidis = string(unique(BalDataRec.midi));
for i = 1:height(uniqueMidis)
   testData{i} = testSignificanceUTestReceptor(BalDataRec, char(uniqueMidis(i)),Variable);
end
testDataFlat = vertcat(testData{:});

writecell(testDataFlat, fullfile(tablePath,'Significance_U-testReceptor.xlsx'));
disp("Significances for U tests calculated and saved under:");
disp(fullfile(tablePath,'Significance_U-testReceptor.xlsx'));
disp('--------------------------------------------------------')

%% Significance U tests midis
Variable = 'RawRatio_Rel';
Midi1 = "1300";
MidiList = ["1300+362", "1458", "1461", "1300+122", "1392", "1389"];
testData = testSignificanceUTestMidis(BALData, Midi1, MidiList, Variable);

writecell(testData, fullfile(tablePath,strjoin(['Significance_U-test_', Midi1 ,'vs', strjoin(MidiList,"_"), '.xlsx'])));
disp("Significances for U tests calculated and saved under:");
disp(fullfile(tablePath,'Significance_U-testReceptor.xlsx'));
disp('--------------------------------------------------------')

%% Significance Kruskal tests

testDataKruskal.flmtq2 = testSignificanceKruskal(BalDataflmtq2, 'cutData_Rel', 'AA');
testDataKruskal.truncmtq2 = testSignificanceKruskal(BalDatatruncmtq2, 'cutData_Rel', 'AA');
testDataKruskal.mtq2fl = testSignificanceKruskal(BalDatamtq2fl, 'cutData_Rel', 'AA');

kruskalTable = table(["fl-mtq2" "truc-mtq2" "mtq-2fl"]',[testDataKruskal.flmtq2.kruskal.p testDataKruskal.truncmtq2.kruskal.p testDataKruskal.mtq2fl.kruskal.p]', ...
    'VariableNames', {'Vector', 'P value'});
writetable(kruskalTable, fullfile(tablePath,'Significance_Kruskall.xlsx'), 'Sheet', 'Kruskal');
writetable(testDataKruskal.flmtq2.multcompare.result, fullfile(tablePath,'Significance_Kruskall.xlsx'), 'Sheet', 'Dunn_fl-mtq2');
writetable(testDataKruskal.truncmtq2.multcompare.result, fullfile(tablePath,'Significance_Kruskall.xlsx'), 'Sheet', 'Dunn_truc-mtq2');
writetable(testDataKruskal.mtq2fl.multcompare.result, fullfile(tablePath,'Significance_Kruskall.xlsx'), 'Sheet', 'Dunn_mtq-2fl');

disp("Significances for Kruskal Wallis and Dunn tests calculated and saved under:");
disp(fullfile(tablePath,'Significance_Kruskall.xlsx'));
disp('--------------------------------------------------------')

