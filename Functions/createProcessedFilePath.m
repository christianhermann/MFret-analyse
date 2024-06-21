function newFilePath = createProcessedFilePath(measurementsPath , filePath, folderFlag)

index = numel(measurementsPath);

additionalSubdirectory = 'Processed';
newFilePath = fullfile(measurementsPath, additionalSubdirectory, filePath(index+1:end));
[filepath,file,~] = fileparts(newFilePath);
newFilePath = filepath;
if folderFlag == true
    newFilePath = fullfile(newFilePath, file);
end
end