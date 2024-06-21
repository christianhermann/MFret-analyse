function meanBackground = getBackground(filepath)
    filepath = fullfile(filepath,'background.mat');
    files = load(filepath);
    meanBackground = files.meanBackground;
end