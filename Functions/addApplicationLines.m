function [fig] = addApplicationLines(fig,appTime, appName, appColor, sepLines)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

uniqueStrings = unique(appName);
% Initialize an empty cell array to store the indices
firstOccurrenceIndices = cell(size(uniqueStrings));
% Iterate over each unique string
for i = 1:numel(uniqueStrings)
    % Find the index of the first occurrence of the current string
    firstOccurrenceIndices{i} = find(strcmp(appName, uniqueStrings{i}), 1);
end


for i = 1:numel(fig.Children.Children)
    yRange(i) = diff(fig.Children.Children(i).YLim);
    yStep(i) = yRange(i) / 100;
    maxY(i) = max(fig.Children.Children(i).Children.YData);
    lineY(i) = maxY(i) + yStep(i) * 5;
end
for j = 1:numel(appName)

    for i = 1:numel(fig.Children.Children)
        l = line(fig.Children.Children(i), appTime(j,:), [lineY(i) lineY(i)], 'color', appColor{j}, 'LineWidth', 1);
            if sepLines == true
                xl = xline(fig.Children.Children(i), appTime(j,1),'--', 'LineWidth', 0.3, 'Color', '#AAAAAA');
                xl.Annotation.LegendInformation.IconDisplayStyle = "off";
            end

        if (ismember(j, [firstOccurrenceIndices{:}]))
            l.DisplayName = appName{j};
        else
            l.Annotation.LegendInformation.IconDisplayStyle = "off";
        end
        txt = text(fig.Children.Children(i), mean(appTime(j,:)), lineY(i)+ yStep(i)*15, ...
            appName(j),'color', appColor{j}, 'FontSize',5, 'FontWeight', 'normal', ...
            'HorizontalAlignment', 'center');
        ext = get(txt,'Extent');
        upperPosition = sum(ext(:,[2,4]),2);                       % Step 2
        fig.Children.Children(i).YLim = ([min(fig.Children.Children(i).YLim()),max(max(fig.Children.Children(i).YLim()),max(upperPosition))]);

    end
end