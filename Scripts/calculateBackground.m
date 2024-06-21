%folder = uigetdir(); % replace with the actual path to the folder
folder = append(backgroundPath, "\Data\");
files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end

windowSize = 1;
downsampleFrequency = 1;

for i = 1:numel(data)
tableData{i} = downsampleMeasData(data{i}.measurementPlotData, windowSize, downsampleFrequency);
bgData(i,:) = [mean(tableData{i}.Donor) mean(tableData{i}.Empty) mean(tableData{i}.FRET) mean(tableData{i}.Acceptor)];
end

meanBackground = array2table(mean(bgData), 'VariableNames',{'Donor','Empty','FRET', 'Acceptor'});
SDBackground = array2table(std(bgData), 'VariableNames',{'Donor','Empty','FRET', 'Acceptor'});

folderSplit = regexp(folder, '\', 'split');
fileName = fullfile(backgroundPath,'background.mat');
save(fileName, "meanBackground", "SDBackground");
disp('Background intensity extracted and saved unter:')
disp(fileName)
disp('--------------------------------------------------------')