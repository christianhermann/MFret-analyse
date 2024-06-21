function [infoTable] = getInfotable(filepath)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
fullFilePath = fullfile(filepath, "InfoTable.xlsx");
variableNames = {'name', 'midi', 'date', 'BAL', 'protocol', 'type', 'timeStart', 'Ok_'};
variableTypes = {'string', 'string', 'string', 'double', 'string', 'string', 'double', 'double'};

if exist(fullFilePath, 'file') == 2
    opts = detectImportOptions(fullFilePath);
    opts.VariableNames = variableNames;
    opts.VariableTypes = variableTypes;
    infoTable = readtable(fullFilePath, opts, "UseExcel", false);
else
    infoTable = table('Size', [0 numel(variableNames)], 'VariableNames', variableNames, 'VariableTypes', variableTypes);
end