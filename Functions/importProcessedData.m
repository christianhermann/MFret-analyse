function data = importProcessedData(filesStruct)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
f.Children(1).Title.Interpreter = 'none';
data = cell(1, numel(filesStruct));
for i = 1:numel(filesStruct)
    filename = fullfile(filesStruct(i).folder, filesStruct(i).name);
    waitbar(i/numel(filesStruct),f,append("Loading: ", filename), 'Interpreter', 'none');
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end
close(f)
end