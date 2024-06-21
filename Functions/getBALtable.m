function [BALTable] = getBALtable(filepath)
%getBALtable Helper function to import the BALtable
%   Imports BALtable. If no xlsx can be found a new table will be created
fullFilePath = fullfile(filepath, "BALTable.xlsx");
if exist(fullFilePath, 'file') == 2
   BALTable = readtable(fullFilePath,  "UseExcel", false);
else 
    variableNames = {'name','midi','midiCo','dateMeas','quality', 'timeBef','timeAft'};
    variableTypes = {'string', 'double', 'double', 'string', 'double', 'double', 'double'};
    BALTable = table('Size', [0 numel(variableNames)], 'VariableNames', variableNames, 'VariableTypes', variableTypes);
end