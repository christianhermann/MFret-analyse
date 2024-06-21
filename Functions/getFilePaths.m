function [matFiles] = getFilePaths(mainFolderPath)

% Get a list of subfolders in the main folder
subFolders = dir(mainFolderPath);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'})); % Remove '.' and '..'

% Initialize a cell array to store file paths
matFileNames = {};
matFilePaths = {};
subfolderNames = {};
subfolderPaths = {};
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

        % Find .mat files in the sub-subfolder
        matFilesInSubSubFolder = dir(fullfile(subSubFolderPath, '*.mat'));

        % Loop through each .mat file
        for k = 1:numel(matFilesInSubSubFolder)
            matFileName = matFilesInSubSubFolder(k).name;
            matFilePath = fullfile(subSubFolderPath, matFileName);

            % Store data in cell arrays
            matFileNames{end+1} = matFileName;
            matFilePaths{end+1} = matFilePath;
            subfolderPaths{end+1} = subSubFolderPath;
            subfolderNames{end+1} = subSubFolders(j).name;
        end
    end
end

% Create a table using the cell arrays
matFiles = table(matFileNames', matFilePaths', subfolderPaths', subfolderNames', ...
    'VariableNames', {'FileName', 'FilePath', 'FilePathFolder', 'Subfolder'});
end