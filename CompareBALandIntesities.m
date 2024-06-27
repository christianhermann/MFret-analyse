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
BALData = BALDataRaw;


Localisation = readtable(fullfile(tablePath,'Localisation.xlsx'), "UseExcel", false);
Localisation.vec = categorical(Localisation.vec);
Localisation.AA = categorical(Localisation.AA);
Localisation.newMidi = categorical(Localisation.midi);
Localisation = removevars(Localisation, "midi");
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(double(BALData.midi)) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;
BALData = join(BALData, Localisation);
BALDataFil = BALDataRaw(BALDataRaw.quality == 1,:);

%% Plots
g(1,1) = gramm('x',BALData.cutData_Rel,'y',BALData.cutData_Abs, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Data");
g(1,1).axe_property('XLim',[0 1]);
g(1,1).set_names('x','Relative Change','y','Absolute Change', 'color', 'quality');
g(2,1) = gramm('x',BALData.btCorrectedData_Rel,'y',BALData.btCorrectedData_Abs, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Data");
g(2,1).axe_property('XLim',[0 1]);
g(2,1).set_names('x','Relative Change','y','Absolute Change', 'color', 'Vector');
g.draw

g(1,1) = gramm('x',BALData.cutData_Bef,'y',BALData.cutData_Rel, color = BALData.midi);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Data");
g(1,1).set_names('x','Intensity Before Bal','y','Relative Change in Intensity', 'color', 'Midi');
g(2,1) = gramm('x',BALData.cutData_Bef,'y',BALData.RawRatio_Rel, color = BALData.midi);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Uncorrected Data");
g(2,1).set_names('x','Intensity Before Bal','y','Relative Change in Ratio', 'color', 'Midi');
g.draw



g(1,1) = gramm('x',BALData.RawRatio_Rel,'y',BALData.RawRatio_Abs, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).axe_property('XLim',[0 1]);
g(1,1).set_names('x','Ratio Relative Change','y','Ratio Absolute Change', 'color', 'quality');
g(2,1) = gramm('x',BALData.Ratio_Rel,'y',BALData.Ratio_Abs, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).axe_property('XLim',[0 1]);
g(2,1).set_names('x','Ratio Cor Relative Change','y','Ratio Cor Absolute Change', 'color', 'quality');
g.draw

g(1,1) = gramm('x',BALData.RawRatio_Rel,'y',BALData.RawRatio_Bef, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).axe_property('XLim',[0 1]);
g(1,1).set_names('x','Ratio Relative Change','y','Ratio Bef', 'color', 'quality');
g(2,1) = gramm('x',BALData.Ratio_Rel,'y',BALData.Ratio_Bef, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).axe_property('XLim',[0 1]);
g(2,1).set_names('x','Ratio Cor Relative Change','y','Ratio Cor Bef', 'color', 'quality');
g.draw


g(1,1) = gramm('x',BALData.RawRatio_Rel,'y',BALData.RawRatio_Aft, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).axe_property('XLim',[0 1]);
g(1,1).set_names('x','Ratio Relative Change','y','Ratio Aft', 'color', 'quality');
g(2,1) = gramm('x',BALData.Ratio_Rel,'y',BALData.Ratio_Aft, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).axe_property('XLim',[0 1]);
g(2,1).set_names('x','Ratio Cor Relative Change','y','Ratio Cor Aft', 'color', 'quality');
g.draw


g(1,1) = gramm('x',BALData.RawRatio_Bef,'y',BALData.RawRatio_Aft, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).set_names('x','Ratio Relative Change','y','Ratio Aft', 'color', 'quality');
g(2,1) = gramm('x',BALData.Ratio_Bef,'y',BALData.Ratio_Aft, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).set_names('x','Ratio Cor Relative Change','y','Ratio Cor Aft', 'color', 'quality');
g.draw



g(1,1) = gramm('x',BALData.cutData_Abs,'y',BALData.RawRatio_Rel, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).set_names('x','cutData_Bef','y','Ratio Relative Change', 'color', 'quality');
g(2,1) = gramm('x',BALData.cutData_Abs,'y',BALData.Ratio_Rel, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).set_names('x','cutData_Bef','y','Ratio Cor Relative Change', 'color', 'quality');
g.draw

g(1,1) = gramm('x',BALData.RawRatio_Rel,'y',BALData.cutData_Aft, color = BALData.quality);
g(1,1).geom_point('dodge',0.7, 'alpha',1);
g(1,1).set_title("Uncorrected Ratio");
g(1,1).axe_property('XLim',[0 1]);
g(1,1).set_names('x','Ratio Relative Change','y','cutData_Aft', 'color', 'quality');
g(2,1) = gramm('x',BALData.Ratio_Rel,'y',BALData.cutData_Aft, color = BALData.quality);
g(2,1).geom_point('dodge',0.7, 'alpha',1);
g(2,1).set_title("Corrected Ratio");
g(2,1).axe_property('XLim',[0 1]);
g(2,1).set_names('x','Ratio Cor Relative Change','y','cutData_Aft', 'color', 'quality');
g.draw

