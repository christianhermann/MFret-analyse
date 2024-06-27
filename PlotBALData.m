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

%% FlAsH localisation table

localisation = readtable(fullfile(tablePath,'localisation.xlsx'), "UseExcel", false);
localisation.vec = categorical(localisation.vec);
localisation.AA = categorical(localisation.AA);
localisation.newMidi = categorical(localisation.midi);
localisation = removevars(localisation, "midi");
%% augment table
BALData = BALDataRaw(BALDataRaw.quality == 1,:);
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(double(BALData.midi)) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;
BALData = join(BALData, localisation);

BALData.RawRatio_Rel = BALData.RawRatio_Rel * -1;
%% Filtered Table
BalDataC = BALData(BALData.locFlAsH == "C",:);
BalDataC_C = BalDataC(BalDataC.vec == "fl-mTq2" | BalDataC.vec == "trunc-mTq2",:);
BalDataC_N = BalDataC(BalDataC.vec == "cpmTq2-fl",:);
BalDataN = BALData(BALData.locFlAsH == "N",:);
BalDataN_C = BalDataN(BalDataN.vec == "fl-mTq2" | BalDataN.vec == "trunc-mTq2",:);
BalDataN_N = BalDataN(BalDataN.vec == "cpmTq2-fl",:);
%% Plot  

%% Cut Ratio Data Sorted by Midi
figure()

clear g
g(1,1) = gramm('x',BalDataC_C.newMidi,'y',BalDataC_C.RawRatio_Rel, color = BalDataC_C.AA);
g(1,1).set_title("FlAsH-C / mTq2-C -RawRatioRel")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'AA#');

g(1,2) = gramm('x',BalDataC_N.newMidi,'y',BalDataC_N.RawRatio_Rel, color = BalDataC_N.AA);
g(1,2).set_title("FlAsH-C / mTq2-N -RawRatioRel")
g(1,2).no_legend();
g(1,2).stat_boxplot('width',0.15);
g(1,2).axe_property('YLim',[-1 0]);
g(1,2).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'AA#');

g(2,1) = gramm('x',BalDataN_C.newMidi,'y',BalDataN_C.RawRatio_Rel, color = BalDataN_C.AA);
g(2,1).set_title("FlAsH-N / mTq2-C -RawRatioRel")
g(2,1).no_legend();
g(2,1).stat_boxplot('width',0.15);
g(2,1).axe_property('YLim',[-1 0]);
g(2,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'AA#');

g(2,2) = gramm('x',BalDataN_N.newMidi,'y',BalDataN_N.RawRatio_Rel, color = BalDataN_N.AA);
g(2,2).set_title("FlAsH-N / mTq2-N -RawRatioRel")
g(2,2).no_legend();
g(2,2).stat_boxplot('width',0.15);
g(2,2).axe_property('YLim',[-1 0]);
g(2,2).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'AA#');
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(1,2).update();
g(1,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,1).update();
g(2,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,2).update();
g(2,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();

%% Cut Ratio Data Sorted by FlAsH Morif
BALDataVec = BALData(BALData.vec == "cpmTq2-fl" | BALData.vec == "fl-mTq2" | BALData.vec == "trunc-mTq2",:);
BalData965 = BALDataVec(BALDataVec.AA == "965",:);
BalData904 = BALDataVec(BALDataVec.AA == "904",:);
BalData776 = BALDataVec(BALDataVec.AA == "776",:);
BalData690 = sortrows(BALDataVec(BALDataVec.AA == "690",:), "vec");

figure()
clear g
g(1,1) = gramm('x',BalData965.newMidi,'y',BalData965.RawRatio_Rel, color = BalData965.vec);
g(1,1).set_title("FlAsH965 -RawRatioRel")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');

g(1,2) = gramm('x',BalData904.newMidi,'y',BalData904.RawRatio_Rel, color = BalData904.vec);
g(1,2).set_title("FlAsH904 -RawRatioRel")
g(1,2).no_legend();
g(1,2).stat_boxplot('width',0.15);
g(1,2).axe_property('YLim',[-1 0]);
g(1,2).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');

g(2,1) = gramm('x',BalData776.newMidi,'y',BalData776.RawRatio_Rel, color = BalData776.vec);
g(2,1).set_title("FlAsH776 -RawRatioRel")
g(2,1).no_legend();
g(2,1).stat_boxplot('width',0.15);
g(2,1).axe_property('YLim',[-1 0]);
g(2,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');

g(2,2) = gramm('x',BalData690.newMidi,'y',BalData690.RawRatio_Rel, color = BalData690.vec);
g(2,2).set_title("FlAsH690 -RawRatioRel")
g(2,2).no_legend();
g(2,2).stat_boxplot('width',0.15);
g(2,2).axe_property('YLim',[-1 0]);
g(2,2).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');
g.set_color_options('map','brewer1')
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(1,2).update();
g(1,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,1).update();
g(2,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,2).update();
g(2,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


BalData172 = sortrows(BALDataVec(BALDataVec.AA == "172",:), "vec");
BalData25 = sortrows(BALDataVec(BALDataVec.AA == "25",:), "vec");
BalData2 = sortrows(BALDataVec(BALDataVec.AA == "2",:), "vec");


figure()
clear g
g(1,1) = gramm('x',BalData172.newMidi,'y',BalData172.RawRatio_Rel, color = BalData172.vec);
g(1,1).set_title("FlAsH172 -RawRatioRel")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');

g(1,2) = gramm('x',BalData25.newMidi,'y',BalData25.RawRatio_Rel, color = BalData25.vec);
g(1,2).set_title("FlAsH25 -RawRatioRel")
g(1,2).no_legend();
g(1,2).stat_boxplot('width',0.15);
g(1,2).axe_property('YLim',[-1 0]);
g(1,2).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');

g(2,1) = gramm('x',BalData2.newMidi,'y',BalData2.RawRatio_Rel, color = BalData2.vec);
g(2,1).set_title("FlAsH2 -RawRatioRel")
g(2,1).no_legend();
g(2,1).stat_boxplot('width',0.15);
g(2,1).axe_property('YLim',[-1 0]);
g(2,1).set_names('x','Midi','y','Δ FRET Ratio', 'color', 'vec');
g.set_color_options('map','brewer1')
g.draw();
g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(1,2).update();
g(1,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,1).update();
g(2,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();

%%  Sorted by AA of flash motif
BalDataWoRec = BALData(ismissing(BALData.midiCo),:);
BalDataflmtq2 = BalDataWoRec(BalDataWoRec.vec == "fl-mTq2",:);
BalDatatruncmtq2 = BalDataWoRec(BalDataWoRec.vec == "trunc-mTq2",:);
BalDatacpmtq2fl = BalDataWoRec(BalDataWoRec.vec == "cpmTq2-fl",:);
BalDatacpmtq2fl = BalDatacpmtq2fl(BalDatacpmtq2fl.midi ~= "1120",:);


figure()
clear g
g(1,1) = gramm('x',BalDataflmtq2.AA,'y',BalDataflmtq2.RawRatio_Rel, color = BalDataflmtq2.midi);
g(1,1).set_title("mTRPC5-mTq2 -RawRatioRel")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','AA#','y','Δ FRET Ratio', 'color', 'midi');
g(1,1).set_order_options('x',[2 3 1 4 5 6 7]);


g(1,2) = gramm('x',BalDatatruncmtq2.AA,'y',BalDatatruncmtq2.RawRatio_Rel, color = BalDatatruncmtq2.midi);
g(1,2).set_title("mTRPC5(trunc)-mTq2 -RawRatioRel")
g(1,2).no_legend();
g(1,2).stat_boxplot('width',0.15);
g(1,2).axe_property('YLim',[-1 0]);
g(1,2).set_names('x','AA#','y','Δ FRET Ratio', 'color', 'midi');
g(1,2).set_order_options('x',[2 3 1 4]);


g(2,1) = gramm('x',BalDatacpmtq2fl.AA,'y',BalDatacpmtq2fl.RawRatio_Rel, color = BalDatacpmtq2fl.midi);
g(2,1).set_title("cpmTq2-mTRPC5 -RawRatioRel")
g(2,1).no_legend();
g(2,1).stat_boxplot('width',0.15);
g(2,1).axe_property('YLim',[-1 0]);
g(2,1).set_names('x','AA#','y','Δ FRET Ratio', 'color', 'midi');
g(2,1).set_order_options('x',[2 1 3 4 5 6]);

g.set_color_options('map','brewer1')
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(1,2).update();
g(1,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g(2,1).update();
g(2,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();

%% Motifs with Known Distances from chimera

BalDataDistance = BALData(BALData.newMidi == "1303" | BALData.newMidi == "1145" | BALData.newMidi == "1300" | ...
    BALData.newMidi == "1304" | BALData.newMidi == "970" | BALData.newMidi == "998" | BALData.newMidi == "1148" | ...
    BALData.newMidi == "1301" ,:);

BalDataDistance = sortrows(BalDataDistance, "AA");
BalDataDistance.midi = categorical(BalDataDistance.midi);
figure()
clear g

g(1,1) = gramm('x',BalDataDistance.AA,'y',BalDataDistance.RawRatio_Rel, color = BalDataDistance.vec);
g(1,1).set_title("Known Distances -RawRatioRel")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','AA#','y','Δ FRET Ratio', 'color', 'vec');
g(1,1).set_order_options('x',[2 3 1 4 5]);
g.set_color_options('map','brewer1')
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g.draw();


%% trunc without GS compared to trunc with GS

BalDataTrunc = BALData(BALData.vec == "trunc-G4SmTq2" | BALData.vec == "trunc-mTq2" & isundefined(BALData.midiCo),:);

g(1,1) = gramm('x',BalDataTrunc.AA,'y',BalDataTrunc.RawRatio_Rel, color = BalDataTrunc.vec);
g(1,1).set_title("Truncated vs Truncated with G4S Linker")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','AA#','y','Δ FRET Ratio', 'color', 'vec');
g(1,1).set_order_options('x',[2 3 1 4 5]);
g.set_color_options('map','brewer1')
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g.draw();

%% G Protein with Flash Tag 

BalDataGProt = BALData(BALData.locFlAsH == "op" | BALData.locFlAsH == "ut",:);

g(1,1) = gramm('x',BalDataGProt.midi,'y',BalDataGProt.RawRatio_Rel, color = BalDataGProt.vec);
g(1,1).set_title("No Flash Motif vs Flash Motif in G-Protein")
g(1,1).no_legend();
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','Vector#','y','Δ FRET Ratio', 'color', 'vec');
g(1,1).set_order_options('x',[1 4 2 3], 'color',[1 3 4 2]);
g.set_color_options('map','brewer1')
g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g.draw();


%% Compare Receptor with G Protein

 BalDataGProtRec =  BALData(BALData.vec == "fl-mTq2-P2A-GNA11" |BALData.vec == "fl-mTq2-P2A-GNAq" | BALData.vec == "fl-mTq2-P2A-GNA1" |...
     BALData.vec == 'cpmTq2-fl-P2A-GNA1'| BALData.vec == "cpmTq2-fl-P2A-GNA11" | BALData.vec == "cpmTq2-fl-P2A-GNAq" | BALData.vec == "cpmTq2-fl-P2A-GNA2"...
    | BALData.midi == "1148" |BALData.midi == "740"| BALData.midi == "1300",:);


BalDataGProtRec740 = BalDataGProtRec(BalDataGProtRec.midi == "740" | BalDataGProtRec.midi == "1387" |BalDataGProtRec.midi == "1390" |BalDataGProtRec.midi == "1456",:);
BalDataGProtRec1148 = BalDataGProtRec(BalDataGProtRec.midi == "1148" | BalDataGProtRec.midi == "1388" |BalDataGProtRec.midi == "1391",:);
BalDataGProtRec1300 = BalDataGProtRec(BalDataGProtRec.midi == "1300" | BalDataGProtRec.midi == "1389" |BalDataGProtRec.midi == "1392" |BalDataGProtRec.midi == "1458" |BalDataGProtRec.midi == "1461" ,:);

g(1,1) = gramm('x',BalDataGProtRec740.newMidi,'y',BalDataGProtRec740.RawRatio_Rel, color = BalDataGProtRec740.vec);
g(1,1).set_title("C5-G689-R690insCCPGCC-mTq2")
g(1,1).no_legend();
g(1,1).set_order_options('x',[4 6 3 5 2 1], 'color',[1 3 4 2]);
g(1,1).stat_boxplot('width',0.15);
g(1,1).axe_property('YLim',[-1 0]);
g(1,1).set_names('x','Midi#','y','Δ FRET Ratio', 'color', 'Vector');
g.set_color_options('map','brewer1')

g(1,2) = gramm('x',BalDataGProtRec1148.newMidi,'y',BalDataGProtRec1148.RawRatio_Rel, color = BalDataGProtRec1148.vec);
g(1,2).set_title("cpmTq2-C5_R24-S25insCCPGCC")
g(1,2).no_legend();
g(1,2).set_order_options('x',[1 3 2 5 4], 'color',[1 2 3]);
g(1,2).stat_boxplot('width',0.15);
g(1,2).axe_property('YLim',[-1 0]);
g(1,2).set_names('x','Midi#','y','Δ FRET Ratio', 'color', 'Vector');
g.set_color_options('map','brewer1')

g(2,1) = gramm('x',BalDataGProtRec1300.newMidi,'y',BalDataGProtRec1300.RawRatio_Rel, color = BalDataGProtRec1300.vec);
g(2,1).set_title("cpmTq2-C5_G689-R690insCCPGCC")
g(2,1).no_legend();
g(2,1).set_order_options('x',[1 3 6 7 2 5 4], 'color',[1 3 5 2 4]);
g(2,1).stat_boxplot('width',0.15);
g(2,1).axe_property('YLim',[-1 0]);
g(2,1).set_names('x','Midi#','y','Δ FRET Ratio', 'color', 'Vector');
g.set_color_options('map','brewer1')


g.draw();

g(1,1).update();
g(1,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g(1,2).update();
g(1,2).geom_jitter('dodge',0.7, 'alpha',0.7);
g(1,2).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g(2,1).update();
g(2,1).geom_jitter('dodge',0.7, 'alpha',0.7);
g(2,1).set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );

g.draw();



