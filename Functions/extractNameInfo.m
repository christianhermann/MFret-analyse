function nameInfoTable = extractNameInfo(fileName, varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;
% Define required input
%addRequired(p, 'measurementPlotData', 'savefolder', 'saveName');
% Define optional inputs and their default values
addOptional(p, 'midiLoc', 0);
addOptional(p, 'midiCoLoc', 0);
% Parse inputs
parse(p,  varargin{:});

% Retrieve input arguments
midiLoc = p.Results.midiLoc;
midiCoLoc = p.Results.midiCoLoc;


name = string(fileName);
splitName = split(fileName, '-');
if midiLoc ~= 0
    midi = str2double(splitName{midiLoc});
else
    midi = NaN;
end

if midiCoLoc ~= 0
    midiCo = str2double(splitName{midiCoLoc});
else
    midiCo = NaN;
end

dateMeas = string(splitName{1});
nameInfoTable = table(name, midi, midiCo, dateMeas);
end