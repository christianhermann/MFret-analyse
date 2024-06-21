function differentEntries = findDifferentRows(data1, data2, column1)
    %FINDDIFFERENTROWS Find entries in two structs or tables with differing values in specified column
    %   differentEntries = findDifferentRows(data1, data2, column1) compares the values
    %   in the specified column of data1 and data2, which can be either structs or tables.
    %   It returns a struct array differentEntries containing the entries from data1
    %   where the column values differ from those in data2. The column name is specified by column1.
    %   If column1 is not provided, it defaults to 'name'.
    %
    %   Example:
    %   struct1 = struct('name', 'John', 'age', 25, 'city', 'New York');
    %   struct2 = struct('city', 'Los Angeles', 'age', 30, 'name', 'Alice', 'extra', 'data');
    %   differentEntries = findDifferentRows(struct1, struct2, 'name');
    %
    %   See also TABLE, STRUCT2TABLE, UNIQUE.

    % Set default values for column1 and column2
    if nargin < 3
        column1 = 'name';
    end

    % Determine the type of input data (struct or table)
    if isstruct(data1) && isstruct(data2)
        % Get the values of column1 for each struct
        col1_data1 = {data1.(column1)};
        col1_data2 = {data2.(column1)};
    elseif istable(data1) && istable(data2)
        % Get the values of column1 for each table
        col1_data1 = data1.(column1);
        col1_data2 = data2.(column1);
    else
        error('Input data types must be either both structs or both tables.');
    end

    % Initialize an empty array to store differing entries
    differentEntries = [];

    % Iterate over each value in col1_data1
    for i = 1:numel(col1_data1)
        % Check if the value in col1_data1 differs from any value in col1_data2
        if ~any(strcmp(col1_data2, col1_data1{i}))
            % Append the differing entry to the result
            if isstruct(data1)
                differentEntries = [differentEntries; data1(i)];
            else
                differentEntries = [differentEntries; data1(i,:)];
            end
        end
    end
    
    if ~isempty(differentEntries)
        % Convert the result to a table for easy filtering
        if isstruct(differentEntries)
            dataTable = struct2table(differentEntries);
        else
            dataTable = differentEntries;
        end

        % Use the unique function to get unique rows
        uniqueData = unique(dataTable, 'rows');

        % Convert the table back to a struct or table
        if isstruct(differentEntries)
            differentEntries = table2struct(uniqueData);
        else
            differentEntries = uniqueData;
        end
    end
end