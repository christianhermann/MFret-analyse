function fig = makePrettyPlot(obj, data)
%MAKEPRETTYPLOT Create a pretty plot based on the provided data
%   fig = makePrettyPlot(obj, data) creates a pretty plot based on the provided data using the FRETData
%   object `obj`. The plot style and axis labels are customized based on the `data` input.
%
%   Inputs:
%   - obj: The FRETData object.
%   - data: The type of data to be plotted. Supported values are "cutData", "btCorrectedData",
%           "btPbCorrectedData", "rawRatio","Ratio", "NFRET", "EFRET", "normFRET", "normRatio".
%
%   Output:
%   - fig: The generated plot figure.
%
%   Example:
%   fig = makePrettyPlot(obj, "btCorrectedData");
%
%   See also CREATEFRETPLOT.

switch data
    case "cutData"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (mV)"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3, 'changeUnitFRET', 10^3);
    case "btCorrectedData"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (mV)"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3, 'changeUnitFRET', 10^3);
    case "btPbCorrectedData"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (mV)"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3, 'changeUnitFRET', 10^3);
    case "Ratio"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Ratio (mV/µA)"];
        textTitle = ["Donor" "Akzeptor" "Ratio"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'textTitle', textTitle,'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3, 'changeUnitFRET', 10^-3);
    case "RawRatio"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Ratio (mV/µA)"];
        textTitle = ["Donor" "Akzeptor" "Ratio"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'textTitle', textTitle,'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3, 'changeUnitFRET', 10^-3);
    case "NFRET"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (arb. unit)"];
        textTitle = ["Donor" "Akzeptor" "NFRET"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'textTitle', textTitle, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3);
    case "EFRET"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (arb. unit)"];
        textTitle = ["Donor" "Akzeptor" "EFRET"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'textTitle', textTitle, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3);
    case "DFRET"
        ylab = ["Intensität (µA)" "Intensität (mV)" "Intensität (arb. unit)"];
        textTitle = ["Donor" "Akzeptor" "DFRET"];
        fig = obj.createFRETPlot(data, 'ylab', ylab, 'textTitle', textTitle, 'changeUnitDonor', 10^6, 'changeUnitAcceptor', 10^3);
    case "normFRET"
        ylab = ["Intensität_{norm}" "Intensität_{norm}" "Intensität_{norm}"];
        fig = obj.createFRETPlot(data, 'ylab', ylab);
    case "normRatio"
        ylab = ["Intensität_{norm}" "Intensität_{norm}" "Ratio_{norm}"];
        textTitle = ["Donor" "Akzeptor" "Ratio"];
        fig = obj.createFRETPlot(data, 'ylab', ylab,  'textTitle', textTitle);
    otherwise
        fig = figure();
end
end