function [protocolName, protocolTable] = getProtocolData(fileName, seperator, index, settingsPath)
            try
            fileNameSplit = split(fileName, seperator);
            protocolName = fileNameSplit{length(fileNameSplit) - index};
            protocolTable = readtable(fullfile(settingsPath, append(protocolName, ".xlsx")));
            catch
                    disp('No protocol found')
                    protocolName = "No";
                    protocolTable = table();
                end
end
