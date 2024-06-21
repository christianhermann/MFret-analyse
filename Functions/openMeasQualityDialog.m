function quality = openMeasQualityDialog(fileName)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    prompt = {'Is this a good measurement? 1 for yes! 0 for no!'};
    dlgtitle = fileName;
    dims = [1 40];
    definput = {'1'};
    quality = str2double(cell2mat(inputdlg(prompt,dlgtitle,dims,definput)));
end