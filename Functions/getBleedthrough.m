function bleedthrough = getBleedthrough(path, filename)
    filename = fullfile(path,append(filename,'.mat'));
    
    files = load(filename);
    bleedthrough = files.bleedthrough;
end