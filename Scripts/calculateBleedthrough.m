% Load background data from the specified backgroundPath
bgData = getBackground(backgroundPath);

% List subdirectories in the bleedthroughPath
subDirs = dir(bleedthroughPath);
subDirs = subDirs([subDirs.isdir]);
subDirs = string({subDirs(3:end).name});

% Iterate through each subdirectory
for folder = subDirs
    % Construct the path to the current subdirectory
    folderBt = append(bleedthroughPath, folder);
    
    % Calculate bleedthrough using the bleedthroughFunction
    [bleedthrough intensities] = bleedthroughFunction(folderBt, bgData);
    
    % Calculate the mean of bleedthrough values
    meanBleedthrough = varfun(@mean, bleedthrough);
    
    % Calculate the standard deviation of bleedthrough values
    sdBleedthrough = varfun(@std, bleedthrough);
    
    % Calculate the relative standard deviation of bleedthrough values
    sdBleedthroughRel = 100 * (sdBleedthrough{:,:} ./ meanBleedthrough{:,:});
    
    % Create a structure containing bleedthrough data and related statistics
    bleedthrough = struct('bleedthrough',bleedthrough,'mean', meanBleedthrough, 'sd', sdBleedthrough, 'sdRel', sdBleedthroughRel, 'intensitiy', intensities);
    
    % Save the bleedthrough structure to a .mat file in the current subdirectory
    save(fullfile(bleedthroughPath, append(folder, '.mat')), 'bleedthrough');
    disp(folder);
    disp("Bleedthrough calculated and saved unter:");
    disp(fullfile(bleedthroughPath, append(folder, '.mat')));
    disp('--------------------------------------------------------')
end


