classdef FRETdata
    % FRETdata - A class for processing fluorescence resonance energy transfer (FRET) data.
    %
    %   The FRETdata class provides methods to correct FRET data for
    %   photobleaching, calculate FRET ratios, and normalize FRET ratios to one. The class
    %   also contains properties for storing the raw FRET data, the FRET data corrected for
    %   background fluorescence, the FRET data corrected for background fluorescence and
    %   photobleaching, the FRET ratio, the normalized FRET ratio, and the E-FRET value.
    %
    %   To create an instance of the FRETdata class, provide the following inputs:
    %       rawData - The raw FRET data.
    %       btData - Bleedthrough values.
    %       Gfactor - G-factor used for background correction.
    %       Efactor - E-factor used for background correction.
    %       fileName - The file name.
    %       filePath - The file path.
    %       savePath - The save path.
    %
    %   Example usage:
    %       data = load('myFRETdata.mat');
    %       myFRET = FRETdata(rawData, btData, Gfactor, Efactor, fileName, filePath, savePath);
    %       myFRET.correctIntensities(data);
    %       myFRET.correctBleaching(data, bandwidth);
    %       myFRET.calculateRatio(data);
    %       myFRET.calculateNFRET(data);
    %       myFRET.calculateEFRET(data);
    %       myFRET.calculateDFRET(data);
    %       myFRET.normFRETtoOne(data, setto1meanstart, setto1meanlength);
    %       myFRET.createFRETPlot(data);
    %       myFRET.createRawDataPlot();
    %       myFRET.saveXlsxTable();
    %       myFRET.saveMatFile();
    %
    % Properties:
    %   fileName - The name of the file.
    %   filePath - The path of the file.
    %   savePath - The path for saving the processed data.
    %   protocol - The protocol.
    %   protocolStartTime - The start time of the protocol.
    %   protocolStartTimeAC - the start time of the protocol after cutting
    %   rawData - The raw FRET data.
    %   bgData  - Background values for background correction
    %   btData - Bleedthrough values for bleedthrough correction.
    %   Gfactor - G-factor used for correction.
    %   Efactor - G-factor used for correction.
    %   origTime - The original time values.
    %   cutTime - The corrected time values after cutting the measurement.
    %   cutData - The FRET data with set start and end time points.
    %   btCorrectedData - The FRET data corrected for background fluorescence.
    %   btPbCorrectedData - The FRET data corrected for background fluorescence and photobleaching.
    %   normFRET - The FRET values (btPBCorrected) normalized to one.
    %   RawRatio - The FRET ratio calculated from the cutData.
    %   Ratio - The FRET ratio calculated from the btCorrectedData.
    %   pbCorRatio - The FRET ratio calculated from the bPbtCorrectedData.
    %   normRatio - The FRET ratio calculated from normalized btPbCorrectedData.
    %   NFRET - The normalized FRET ratio (Xia et al.).
    %   EFRET - The E-FRET value (Zal et al.).
    %   DFRET - The DFRET value (Hochreiter et al.).
    %   pbIndices - The chosen indices for the photobleaching correction.
    %   pbSlope - The slopes calculated for the photobleaching correction.
    %
    % Methods:
    %   cutMeasurement - Cuts the measurement based on the selected time points.
    %   correctIntensities - Corrects the intensities in the rawData property using
    %                        the background and direct acceptor/donor fluorescence measurements.
    %   correctBleaching - Corrects for photobleaching in the btCorrectedData property.
    %   calculateRatio - Calculates the FRET ratio from the btCorrectedData property.
    %   calculateNFRET - Calculates the normalized FRET ratio from the Ratio property.
    %   calculateEFRET - Calculates the E-FRET value from the cutData property.
    %   calculateDFRET - Calculates the DFRET value from the cutData property.
    %   normFRETtoOne - Normalizes the normFRET property to one.
    %   createFRETPlot - Creates a plot of the FRET data.
    %   createRawDataPlot - Creates a plot of the raw data.
    %   saveXlsxTable - Saves a Xlsx table containing the data.
    %   saveMatFile - Saves a .mat file containing the FRETdata object.
    %
    % See also:
    %   FRETdata/correctIntensities, FRETdata/correctBleaching, FRETdata/calculateRatio,
    %   FRETdata/calculateNFRET, FRETdata/calculateEFRET, FRETdata/calculateDFRET,
    %   FRETdata/normFRETtoOne, FRETdata/createFRETPlot, FRETdata/createRawDataPlot,
    %   FRETdata/saveXlsxTable, FRETdata/saveMatFile


    properties
        fileName
        filePath
        savePath
        protocol
        protocolStartTime
        protocolStartTimeAC
        protocolStructure
        rawData
        bgData
        btData
        Gfactor
        Efactor
        origTime
        cutTime
        cutData
        btCorrectedData
        btPbCorrectedData
        normFRET
        normPbCorrectedFRET
        RawRatio
        Ratio
        pbCorrectedRatio
        normRatio
        normPbCorrectedRatio
        NFRET
        EFRET
        DFRET
        pbIndices
        pbSlope
    end

    methods
        % Constructor
        function obj = FRETdata(rawData, bgData, btData, Gfactor, Efactor, fileName, filePath, savePath)
            % FRETdata Constructor creates an instance of the FRETdata class
            % withthe provided inputs.
            %
            % Syntax:
            %   fret = FRETdata(rawData, btData, Gfactor)
            %
            % Inputs:
            %   rawData     -original FRET data
            %   btData      -bleedthrough FRET data
            %   Gfactor     -G-factor used for background correction
            %   fileName    -the filename
            %   filePath    -the filepath

            obj.rawData = rawData;
            obj.btData = btData;
            obj.bgData = bgData;
            obj.Gfactor = Gfactor;
            obj.Efactor = Efactor;
            obj.fileName = fileName;
            obj.filePath = filePath;
            obj.savePath = savePath;
            obj.origTime = rawData.('time (s)');
        end

        function [newTable, protocolStartTimeAC, cutTimeLocal] = cutMeasurement(obj, data)
            % cutMeasurement Cuts the measurement based on the selected time points.
            % The cutData property will be updated with the cut FRET data.

            tableData = obj.(data);
            fig = figure;
            plot(tableData.('time (s)'), tableData.Donor,  '-o');
            title (append('Cut: ', obj.fileName), 'Interpreter', 'none');
            if ~isempty(obj.protocolStartTime)
                title (append('Cut', obj.fileName), num2str(obj.protocolStartTime),'Interpreter', 'none');
                xline(obj.protocolStartTime);
            end
            grid on
            grid minor
            fig.WindowState = 'maximized';


            shg
            dcm_obj = datacursormode(1);
            set(dcm_obj,'DisplayStyle','window',...
                'SnapToDataVertex','off','Enable','on')
            waitforbuttonpress
            c_info_start = getCursorInfo(dcm_obj);
            dataIndex_start = c_info_start.DataIndex;
            close;
            newTable = tableData(dataIndex_start(1):size(tableData,1),2:5);
            cutTimeLocal = obj.origTime(dataIndex_start(1):size(obj.origTime));
            protocolStartTimeAC = obj.protocolStartTime - cutTimeLocal(1);
            cutTimeLocal = cutTimeLocal - cutTimeLocal(1);
        
        end

        function newTable = correctIntensities(obj, data)
            % correctIntensities Corrects the intensities in the selected property using
            % the background and direct acceptor/donor fluorescence measurements.
            % The btCorrectedData property will be updated with the corrected FRET data.

            tableData = obj.(data);
            newTable = correctIntensities(tableData, obj.btData.btDF, obj.btData.btDA, obj.btData.btAD, ...
                obj.btData.btAF, obj.bgData.Donor, obj.bgData.FRET, obj.bgData.Acceptor);
        end

        function [pbIndicesLocal, pbSlopeLocal, newTable] = correctBleaching(obj, data, bandwith, oldDIwB1, oldDIwB2)
            % correctBleaching Corrects for photobleaching in the selected property.
            % The btPbCorrectedData property will be updated with the photobleaching-corrected FRET data.
            %
            % Inputs:
            % - obj: The object instance.
            % - data: The name of the property containing the intensity data.
            % - bandwith: The bandwith value for photobleaching correction.
            % - oldDIwB1 (optional): The previous DIwB1 values to be used instead of calculating new ones.
            % - oldDIwB2 (optional): The previous DIwB2 values to be used instead of calculating new ones.
            %
            % Output:
            % - obj: The updated object instance with corrected photobleaching indices.
            %
            % If the optional arguments oldDIwB1 and oldDIwB2 are provided, the function will skip the
            % calculation of new indices and use the provided values directly.

            if nargin > 3
                tableData = obj.(data);
                tableDataNames = ["Donor" "FRET" "Acceptor"];
                dIwB1 = oldDIwB1;
                dIwB2 = oldDIwB2;
                for i = 1:3
                    dataIndex(i,1) = median(oldDIwB1{i});
                    dataIndex(i,2) = median(oldDIwB2{i});
                end

            else
                tableData = obj.(data);
                tableDataNames = ["Donor" "FRET" "Acceptor"];
                dIwB1 = cell(1, 3);
                dIwB2 = cell(1, 3);
                dataIndex = zeros(3,2);
                c_info = cell(3,2);
                for k = 1:3
                    fig = figure;
                    plot(obj.cutTime(round(1:numel(tableData.(tableDataNames{k}))/3)) , ...
                        tableData.(tableDataNames{k})(round(1:numel(tableData.(tableDataNames{k}))/3)),  '-o');
                    title(append("Correct bleaching", tableDataNames{k}), obj.fileName, 'Interpreter', 'none');
                    if ~isempty(obj.protocolStartTimeAC)
                        xline(obj.protocolStartTimeAC);
                    end
                    grid on
                    grid minor
                    fig.WindowState = 'maximized';
                   
                    for j = 1:2
                        shg
                        dcm_obj = datacursormode(1);
                        set(dcm_obj, 'DisplayStyle', 'window',...
                            'SnapToDataVertex', 'off', 'Enable', 'on')
                        waitforbuttonpress
                        c_info{k,j} = getCursorInfo(dcm_obj);
                        dataIndex(k,j) = c_info{k,j}.DataIndex;
                    end
                    grid off;
                    close;

                    if (dataIndex(k,1) < bandwith)
                        dif = bandwith - dataIndex(1);
                        dataIndex(k,1) = bandwith + 1;
                        dataIndex(k,2) = dataIndex(k,2) + dif;
                    end

                    dIwB1{k} = indexWBandwith(dataIndex(k,1), bandwith);
                    dIwB2{k} = indexWBandwith(dataIndex(k,2), bandwith);
                end
            end

            pbIndicesLocal = [{"Donor" "FRET" "Acceptor"}; dIwB1; dIwB2];

            newTable = table();

            Acceptor = tableData.Acceptor;
            Donor = tableData.Donor;
            FRET = tableData.FRET;
            slopeDonor = (mean(Donor(dIwB1{1}))-mean(Donor(dIwB2{1}))) / ...
                (obj.cutTime(dataIndex(1,2)) - obj.cutTime(dataIndex(1,1)));
            slopeFRET = (mean(FRET(dIwB1{2}))-mean(FRET(dIwB2{2}))) / ...
                (obj.cutTime(dataIndex(2,2)) - obj.cutTime(dataIndex(2,1)));
            slopeAcceptor = (mean(Acceptor(dIwB1{3}))-mean(Acceptor(dIwB2{3}))) / ...
                (obj.cutTime(dataIndex(3,2)) - obj.cutTime(dataIndex(3,1)));

            pbSlopeLocal =  table(slopeDonor, slopeFRET, slopeAcceptor);


            DonorCorNormBleachCor = Donor + obj.cutTime * slopeDonor;
            newTable.Donor = DonorCorNormBleachCor;

            FRETCorNormBleachCor = FRET + obj.cutTime * slopeFRET;
            newTable.FRET = FRETCorNormBleachCor;

            AcceptorCorNormBleachCor = Acceptor + obj.cutTime * slopeAcceptor;

            newTable.Acceptor = AcceptorCorNormBleachCor;


        end

        function newTable = normFRETtoOne(obj, data, setto1meanstart, setto1meanlength)
            % calculateRatio Calculates the FRET ratio from the selected property.
            % The Ratio property will be updated with the calculated FRET ratio.
            tableData = obj.(data);
            range = setto1meanstart:setto1meanlength;
            newTable = table();
            DonorCorNorm = tableData.Donor ./ mean(tableData.Donor(range));
            newTable.Donor = DonorCorNorm;

            FRETCorNorm = tableData.FRET ./ mean(tableData.FRET(range));
            newTable.FRET = FRETCorNorm;

            AcceptorCorNorm = tableData.Acceptor ./ mean(tableData.Acceptor(range));
            newTable.Acceptor = AcceptorCorNorm;
        end

        function newTable = calculateRatio(obj, data)
            % calculateRatio Calculates the FRET ratio from the selected property.
            % The Ratio property will be updated with the calculated FRET ratio.
            tableData = obj.(data);
            RatioFRET = tableData.FRET ./ tableData.Donor;
            newTable = table();
            newTable.FRET = RatioFRET;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
        end

        function newTable = calculateNFRET(obj, data)
            % Calculates the normalized FRET (Xia et al) ratio from the
            % corrected FRET data
            tableData = obj.(data);
            newTable = table();
            FRETXia = tableData.FRET ./ sqrt(tableData.Donor .* tableData.Acceptor);
            newTable.FRET = FRETXia;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
        end

        function newTable = calculateEFRET(obj, data)
            % Calculates the E-FRET value from the cut data

            tableData = obj.(data);
            btDataLocal = obj.btData;
            a = btDataLocal.btAF;
            b = btDataLocal.btAD;
            c = btDataLocal.btDA;
            d = btDataLocal.btDF;
            G = obj.Gfactor;
            newTable = table();
            tableData.FRET = tableData.FRET - obj.bgData.FRET;
            tableData.Acceptor = tableData.Acceptor - obj.bgData.Acceptor;
            tableData.Donor = tableData.Donor - obj.bgData.Donor;

            Fc = tableData.FRET - a * (tableData.Acceptor -  c * tableData.Donor) - d * (tableData.Donor - b * tableData.Acceptor);
            % numerator = tableData.FRET - (a - b*d) * tableData.Acceptor - (d - a*c) * tableData.Donor;
            % denominator = tableData.FRET - (a - b*d) * tableData.Acceptor - (d - a*c - G) * tableData.Donor;
            % Eapp = numerator ./denominator;
            Eapp = Fc ./ (Fc + G * tableData.Donor);
            Ecorr = Eapp .* ((tableData.Acceptor(1) - c * tableData.Donor(1)) ./ (tableData.Acceptor - c * tableData.Donor));

            newTable.FRET = Ecorr;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
        end

        function newTable = calculateDFRET(obj, data)
            % Calculates the D-FRET value from the cut data
            tableData = obj.(data);
            btDataLocal = obj.btData;
            S2 = btDataLocal.btAF;
            S4 = btDataLocal.btAD;
            S3 = btDataLocal.btDA;
            S1 = btDataLocal.btDF;
            E = obj.Efactor;
            
            tableData.FRET = tableData.FRET - obj.bgData.FRET;
            tableData.Acceptor = tableData.Acceptor - obj.bgData.Acceptor;
            tableData.Donor = tableData.Donor - obj.bgData.Donor;

            Dcda = (tableData.Donor - S4 * tableData.Acceptor) / 1 - S3 * S4;
            Acda = (tableData.Acceptor - S3 * tableData.Donor) / 1 - S3 * S4;
            FRETc = tableData.FRET - Dcda * S1 - Acda * S2;

            C1 = FRETc - (E * FRETc) / E .* Dcda;
            DFRETLocal = FRETc ./ (C1 .* Dcda + FRETc);
            
            newTable = table();
            newTable.FRET = DFRETLocal;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;

        end

        function fig = createRawDataPlot(obj, varargin)
            % Creates a plot of the Raw data

            % Create input parser
            p = inputParser;

            % Define optional inputs and their default values
            addOptional(p, 'colors', ['b','b','g','g']);
            addOptional(p, 'OuterPosition', [0.25 0.25 10 10]);
            addOptional(p, 'Units', 'centimeters');
            addOptional(p, 'Xaxis', repelem("time (s)", 4));
            addOptional(p, 'Yaxis',  ["Donor" "Empty" "FRET" "Acceptor" ]);
            addOptional(p, 'textTitle',  ["Donor" "Empty" "FRET" "Akzeptor"]);
            addOptional(p, 'xlab', repelem("t (s)", 4));
            addOptional(p, 'ylab', ["Intensität (µA)" "Intensität (µA)" "Intensität (mV)" "Intensität (mV)"]);

            % Parse inputs
            parse(p,  varargin{:});
            % Retrieve input arguments
            OuterPosition = p.Results.OuterPosition;
            Units = p.Results.Units;
            colors = p.Results.colors;
            Xaxis = p.Results.Xaxis;
            YAxis = p.Results.Yaxis;
            textTitle = p.Results.textTitle;
            xlab = p.Results.xlab;
            ylab = p.Results.ylab;

            fig = figure();
            fig.Units = Units;
            fig.OuterPosition = OuterPosition;
            tableData = obj.rawData;
            tableData.Donor = tableData.Donor*10^6;
            tableData.Empty = tableData.Empty*10^6;
            tableData.FRET =  tableData.FRET*10^3;
            tableData.Acceptor =  tableData.Acceptor*10^3;
            for i = 1:numel(Xaxis)
                nexttile
                plot(tableData.(Xaxis(i)), tableData.(YAxis(i)),colors(i))
                title(textTitle(i))
                xlabel(xlab(i))
                ylabel(ylab(i))
                box off
            end
            sgtitle(sprintf(obj.fileName, '\n Raw'),'Interpreter', 'none', 'FontSize', 9)
        end

        function fig = createFRETPlot(obj, data, varargin)
            %createFRETPlot - Creates a plot of the FRET data.
            %
            % Syntax:
            %   fig = createFRETPlot(obj, data, varargin)
            %
            % Inputs:
            %   obj - An instance of the FRETdata class.
            %   data - The name of the data to be plotted.
            %
            % Optional Name-Value Pair Arguments:
            %   colors - A 1x3 character array containing the colors to use for each
            %            trace. Default is ['b','g','g'].
            %   OuterPosition - A 1x4 vector defining the outer position of the figure
            %                   in cm. Default is [0.25 0.25 10 10].
            %   Units - A string defining the units of the figure. Default is
            %           'centimeters'.
            %   Xaxis - A 1x3 cell array of character vectors defining the names of the
            %           columns to use for the x-axis of each subplot. Default is
            %           repelem("cutTime", 3).
            %   Yaxis - A 1x3 cell array of character vectors defining the names of the
            %           columns to use for the y-axis of each subplot. Default is
            %           ["Donor" "Acceptor" "FRET"].
            %   textTitle - A 1x3 cell array of character vectors defining the titles
            %               for each subplot. Default is ["Donor" "Akzeptor" "FRET"].
            %   xlab - A 1x3 cell array of character vectors defining the x-axis labels
            %          for each subplot. Default is repelem("t (s)", 3).
            %   ylab - A 1x3 cell array of character vectors defining the y-axis labels
            %          for each subplot. Default is ["Intensität (µA)" "Intensität (mV)" "Intensität (mV)"].
            %   changeUnitFRET - A scalar factor to change the units of the FRET column.
            %                    Default is 1.
            %   changeUnitAcceptor - A scalar factor to change the units of the Acceptor
            %                        column. Default is 1.
            %   changeUnitDonor - A scalar factor to change the units of the Donor
            %                     column. Default is 1.
            %
            % Outputs:
            %   fig - A MATLAB figure object containing the plot.

            % Create input parser
            p = inputParser;

            % Define optional inputs and their default values
            addOptional(p, 'colors', ['b','g','g']);
            addOptional(p, 'OuterPosition', [0.25 0.25 10 10]);
            addOptional(p, 'Units', 'centimeters');
            addOptional(p, 'Xaxis', repelem("cutTime", 3));
            addOptional(p, 'Yaxis',  ["Donor" "Acceptor" "FRET" ]);
            addOptional(p, 'textTitle',  ["Donor" "Akzeptor" "FRET"]);
            addOptional(p, 'xlab', repelem("t (s)", 3));
            addOptional(p, 'ylab', ["Intensität (A)" "Intensität (V)" "Intensität (V)"]);
            addOptional(p, 'changeUnitFRET', 1);
            addOptional(p, 'changeUnitAcceptor', 1);
            addOptional(p, 'changeUnitDonor', 1);

            % Parse inputs
            parse(p,  varargin{:});
            % Retrieve input arguments
            OuterPosition = p.Results.OuterPosition;
            Units = p.Results.Units;
            colors = p.Results.colors;
            Xaxis = p.Results.Xaxis;
            YAxis = p.Results.Yaxis;
            textTitle = p.Results.textTitle;
            xlab = p.Results.xlab;
            ylab = p.Results.ylab;
            changeUnitFRET = p.Results.changeUnitFRET;
            changeUnitDonor = p.Results.changeUnitDonor;
            changeUnitAcceptor = p.Results.changeUnitAcceptor;


            fig = figure();
            fig.Units = Units;
            fig.OuterPosition = OuterPosition;
            tableData = obj.(data);
            tableData.Donor =    tableData.Donor * changeUnitDonor;
            tableData.FRET =     tableData.FRET * changeUnitFRET;
            tableData.Acceptor = tableData.Acceptor * changeUnitAcceptor;

            for i = 1:numel(Xaxis)
                nexttile
                plot(obj.(Xaxis(i)), tableData.(YAxis(i)),colors(i))
                fig.Children.Children(1).Children.Annotation.LegendInformation.IconDisplayStyle = "off";

                % xlim([0 round(max(obj.(Xaxis(i))))])
                axis padded
                title(textTitle(i))
                xlabel(xlab(i))
                ylabel(ylab(i))
                box off
            end
            sgtitle(append(obj.fileName, " - ", data),'Interpreter', 'none', 'FontSize', 8)
        end

        function saveXlsxTable(obj)
            % Creates a Xlsx table containing the FRET data

            mkdir(fullfile(obj.savePath));
            fullsafeName = fullfile(obj.savePath, obj.fileName);
            compSaveName = append(fullsafeName,'.xlsx');
            writetable(obj.rawData, compSaveName, 'Sheet', 'Raw');
            writematrix(obj.origTime, compSaveName, 'Sheet', 'origTime(s)');
            writematrix(obj.cutTime, compSaveName, 'Sheet', 'cutTime(s)');
            writetable(obj.cutData, compSaveName, 'Sheet', 'cutData');
            writetable(obj.btCorrectedData, compSaveName, 'Sheet', 'btCorrectedData');
            writetable(obj.btPbCorrectedData, compSaveName, 'Sheet', 'btPbCorrectedData');
            writetable(obj.normFRET, compSaveName, 'Sheet', 'normFRET');
            writetable(obj.RawRatio, compSaveName, 'Sheet', 'normFRET');
            writetable(obj.Ratio, compSaveName, 'Sheet', 'Ratio');
            writetable(obj.normRatio, compSaveName, 'Sheet', 'normRatio');
            writetable(obj.NFRET, compSaveName, 'Sheet', 'NFRET');
            writetable(obj.EFRET, compSaveName, 'Sheet', 'EFRET');
        end

        function  saveMatFile(obj, measurementsPath)

            if nargin == 1
                mkdir(obj.savePath);
                fullsafeName = fullfile(obj.savePath, obj.fileName);
                compSaveName = append(fullsafeName,'.mat');
                save(compSaveName, "obj")
                return
            end

            splitPath = strsplit(obj.savePath, '\');
            savePath =  strjoin(splitPath(numel(splitPath)-3:numel(splitPath)), '/');
            savePath =   fullfile(measurementsPath,savePath);
            obj.savePath = savePath;
            mkdir(savePath);
            fullsafeName = fullfile(obj.savePath, obj.fileName);
            compSaveName = append(fullsafeName,'.mat');
            save(compSaveName, "obj")
        end

        function protocolTable = getProtocolData(~, protocolName, settingsPath)
            protocolTable = readtable(fullfile(settingsPath, append(protocolName, ".xlsx")));
        end

        function protocolTime = getProtocolTime(~, infoTable, fileName)
            protocolTime = infoTable.timeStart(find(contains (infoTable.name,fileName)));
        end

        function protocolName = getProtocolName(~, fileName, seperator, index)
            fileNameSplit = split(fileName, seperator);
            protocolName = fileNameSplit{length(fileNameSplit) + index};
        end

        function fig = addPharmakaToFig(obj, time, fig, protocolStartTime, protocolStructure, sepLines)
            if contains(obj.fileName, "BAL") ||  contains(obj.fileName, "BLEACH")  || contains(obj.protocol, "No") 
                return
            end
            protocolStructure.Time = protocolStructure.Time + protocolStartTime;
            for row = 1:height(protocolStructure)
                if row < height(protocolStructure)
                    protocolStructure.Times(row,:) = [protocolStructure.Time(row) protocolStructure.Time(row+1)];
                else
                    protocolStructure.Times(row,:) = [protocolStructure.Time(row) max(obj.(time))];
                end
            end

            fig = addApplicationLines(fig, protocolStructure.Times, protocolStructure.Solution, protocolStructure.Color, sepLines);
        end

    end
end