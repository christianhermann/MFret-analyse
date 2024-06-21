function [backgroundPath, bleedthroughPath, settingsPath, ...
    measurementsPath, EFactorPath, GFactorPath, imagesPath, tablePath, utilitiesPath] = getFolderPaths(basePath)
backgroundPath = append(basePath, "\Background\");
bleedthroughPath = append(basePath, "\BleedThrough\");
settingsPath = append(basePath, "\Settings");
measurementsPath = append(basePath, "\Measurements");
EFactorPath = append(basePath, "\E-Factor");
GFactorPath = append(basePath, "\G-Factor");
imagesPath = append(basePath, "\Measurements\Images");
tablePath = append(basePath, "\Tables");
utilitiesPath = append(basePath, "\Utilities");
end
