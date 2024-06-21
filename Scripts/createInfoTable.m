infoTable = getInfotable(tablePath);
mainFolderPath = measurementsPath;

% Get a list of subfolders in the main folder
subFolders = dir(mainFolderPath);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..', 'Processed', 'Images'})); % Remove '.' and '..' and 'Prcessed and Images folders



% Loop through each subfolder
for i = 1:numel(subFolders)
    subFolderPath = fullfile(mainFolderPath, subFolders(i).name);

    % Get a list of sub-subfolders in the subfolder
    subSubFolders = dir(subFolderPath);
    subSubFolders = subSubFolders([subSubFolders.isdir]);
    subSubFolders = subSubFolders(~ismember({subSubFolders.name}, {'.', '..'})); % Remove '.' and '..'

    % Loop through each sub-subfolder
    for j = 1:numel(subSubFolders)
        subSubFolderPath = fullfile(subFolderPath, subSubFolders(j).name);
        subsubSubFolders = dir(subSubFolderPath);
        subsubSubFolders = subsubSubFolders([subsubSubFolders.isdir]);
        subsubSubFolders = subsubSubFolders(~ismember({subsubSubFolders.name}, {'.', '..'})); % Remove '.' and '..'

        for k = 1:numel(subsubSubFolders)
            subsubSubFolderPath = fullfile(subSubFolderPath, subsubSubFolders(k).name);
            matFiles = dir(fullfile(subsubSubFolderPath, '*.mat'));
            if isempty(matFiles) continue 
            end
            name = struct2table(matFiles).name;
            midi = string(repmat(subsubSubFolders(k).name ,size(struct2table(matFiles).name, 1),1));
            date = regexp(name, '\d{2}\.\d{2}\.\d{4}', 'match');
            BAL = contains(name, 'BAL');
            if class(name) == "cell"
                protocol = cellfun(@(x) regexp(x, '.*-(\d{3,4})-(.*?)(-\d+-\d+\w*)?\.mat', 'tokens'), name, 'UniformOutput', false);
                protocol = cellfun(@(x) x{1}{2}, protocol, 'UniformOutput', false);
            end
            if class(name) == "char"
                name = string(name);
                protocol = regexp(name, '.*-(\d{3,4})-(.*?)(-\d+-\d+\w*)?\.mat', 'tokens');
                protocol = protocol{1}{2};
                protocol = string(protocol);
            end

            type = regexp(struct2table(matFiles).folder, 'FRET\\(.*?)\\', 'tokens', 'once');

            newTable = table(name, midi, date, BAL, protocol, type);
            newTable.timeStart = zeros(size(newTable,1),1);
            newTable.Ok_ = NaN(size(newTable,1),1);

            name1 = infoTable.name;
            name2 = newTable.name;

            newNames = name2(~ismember(name2, name1));
            newTable = newTable(ismember(newTable.name, newNames), :);

            infoTable = [infoTable; newTable];
        end
    end
end
    writetable(infoTable, fullfile(tablePath, "InfoTable.xlsx"));
    disp("Infotable created and saved under:");
    disp(fullfile(basePath, "InfoTable.xlsx"));
    disp('--------------------------------------------------------')
    clear infoTable newNames newTable name1 name2 type name midi date BAL matFiles subsubSubFolderPath subsubSubFolders k subSubFolderPath j subSubFolders subFolderPath mainFolderPath subFolders  mainFolderPath;