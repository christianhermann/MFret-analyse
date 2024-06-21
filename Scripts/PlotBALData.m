%% Paths and Settings
filepath = matlab.desktop.editor.getActiveFilename;
filepathSplit = regexp(filepath, '\', 'split');
basePath = strjoin(filepathSplit(1:(numel(filepathSplit)-1)),'\');
addpath(genpath(append(basePath, '\Scripts')));
[backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, imagesPath, tablePath] = getFolderPaths(basePath);

%% BAl Table 

BALDataRaw = getBALtable(tablePath);

%Localisation = readtable(append(basePath,'Localisation.xlsx', opts, "UseExcel", false));
%BALData = join(BALData, Localisation);

BALData = BALDataRaw(BALDataRaw.quality == 1,:);
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(double(BALData.midi)) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.btCorrectedData_Rel);
g.facet_grid([],BALData.loc)
g.set_title("btCorrectedData_Rel")
%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();



fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.btPbCorrectedData_Rel);
g.set_title("btPbCorrectedData_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.normFRET_Rel);
g.set_title("normFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.normRatio_Rel);
g.set_title("normRatio_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.NFRET_Rel);
g.set_title("NFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.EFRET_Rel);
g.set_title("EFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();