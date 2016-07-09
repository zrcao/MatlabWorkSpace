classdef MegaMillion < handle
    properties
        resultsCell
        filename = 'MegaMillionNumbers.mat';
    end
    methods
        %% Initialization function
        function obj = MegaMillion()
            if exist(obj.filename, 'file');
                load(obj.filename);
                obj.resultsCell = cell(size(dataCell));
                obj.resultsCell = dataCell;
            else
                obj.resultsCell = cell(1, 5);
            end
        end
        %% 
        function addNewDraw(obj, year, month, day, balls, megaballs, megaplier)
            if (size(obj.resultsCell, 1) == 1) && isempty(obj.resultsCell{1, 1})
                obj.resultsCell{1,2} = datestr(datevec(...
                    [num2str(month), '/', num2str(day), '/', num2str(year)]...
                    ));
                obj.resultsCell{1,1} = datenum(obj.resultsCell{1, 2});
                obj.resultsCell{1,3} = sort(balls(:))';
                obj.resultsCell{1,4} = megaballs;
                obj.resultsCell{1,5} = megaplier;
            else
                %zisdatestr = datestr([year, month, day, 0, 0, 0]);
                zisdatestr = datestr(...
                    datevec(...
                    [num2str(month), '/', num2str(day), '/', num2str(year)]...
                    ));
                zisdatenum = datenum(zisdatestr);
                % Check whether the result is already in the list
                datenumlist = cell2mat(obj.resultsCell(:, 1));
                [yes, idx] = ismember(zisdatenum, datenumlist);
                if ~yes % The result is new, increase the data cell
                    [row, col] = size(obj.resultsCell);
                    tmp = cell(row+1, col);
                    tmp(1:row, :) = obj.resultsCell;
                    obj.resultsCell = tmp;
                    obj.resultsCell{row+1,2} = zisdatestr;
                    obj.resultsCell{row+1,1} = zisdatenum;
                    obj.resultsCell{row+1,3} = sort(balls(:))';
                    obj.resultsCell{row+1,4} = megaballs;
                    obj.resultsCell{row+1,5} = megaplier;
                else
                    display(['The MegaMillion results on that date ' ...
                        'is already stored!\n']);
                    reply = input('Overwrite the current record? Y/N [Y]', 's');
                    if isempty(reply)
                        reply = 'Y';
                    end
                    if reply=='Y'
                        obj.resultsCell{idx,2} = zisdatestr;
                        obj.resultsCell{idx,1} = zisdatenum;
                        obj.resultsCell{idx,3} = sort(balls(:))';
                        obj.resultsCell{idx,4} = megaballs;
                        obj.resultsCell{idx,5} = megaplier;
                    end
                end
            end
            [tmp, order] = sort(cell2mat(obj.resultsCell(:, 1)));
            obj.resultsCell = obj.resultsCell(order, :);
        end
        %%
        function savedata(obj)
            dataCell = obj.resultsCell;
            var2str = @(x) inputname(1);
            save(obj.filename, var2str(dataCell));
        end
        
%% The 5-ball winning numbers can be divided into 3 sections:
%    [1:25] [26:50] [51:75]
%  Accordingly, we have the following patterns:
%   Group 1:  2 2 1 
%         11: [1 2 2], 12: [2 1 2], 13: [2 2 1]
%   Group 2:  3 1 1
%         21: [3 1 1], 22: [1 3 1], 23: [1 1 3]
%   Group 3:  3 2 0
%         31: [3 2 0], 32: [3 0 2]
%         33: [2 3 0], 34: [0 3 2]
%         35: [2 0 3], 36: [0 2 3]
%   Group 4:  4 1 0
%         41: [4 1 0], 42: [4 0 1]
%         43: [1 4 0], 44: [0 4 1]
%         45: [1 0 4], 46: [0 1 4]
%   Group 5:  5 0 0
%         51: [5 0 0], 52: [0 5 0], 53: [0 0 5]       
        function pattern_idx = categorize(obj)
            numberEntries = size(obj.resultsCell, 1);
            pattern_vec = zeros(numberEntries, 3);
            pattern_idx = zeros(numberEntries, 1);
            balls = cell2mat(obj.resultsCell(:, 3));
            
            pattern_vec(:, 1) = sum((balls<=25), 2);
            pattern_vec(:, 2) = sum((balls>25) & (balls<=50), 2);
            pattern_vec(:, 3) = sum((balls>50), 2);
            
            for ee = 1:numberEntries
                switch mat2str(pattern_vec(ee, :))
                    case '[1 2 2]'
                        pattern_idx(ee) = 11;
                    case '[2 1 2]'
                        pattern_idx(ee) = 12;
                    case '[2 2 1]'
                        pattern_idx(ee) = 13;
                    case '[3 1 1]'
                        pattern_idx(ee) = 21;
                    case '[1 3 1]'
                        pattern_idx(ee) = 22;
                    case '[1 1 3]'
                        pattern_idx(ee) = 23;
                    case '[3 2 0]'
                        pattern_idx(ee) = 31;
                    case '[3 0 2]'
                        pattern_idx(ee) = 32; 
                    case '[2 3 0]'
                        pattern_idx(ee) = 33;
                    case '[0 3 2]'
                        pattern_idx(ee) = 34;
                    case '[2 0 3]'
                        pattern_idx(ee) = 35;
                    case '[0 2 3]'
                        pattern_idx(ee) = 36;
                    case '[4 1 0]'
                        pattern_idx(ee) = 41;
                    case '[4 0 1]'
                        pattern_idx(ee) = 42;
                    case '[1 4 0]'
                        pattern_idx(ee) = 43;
                    case '[0 4 1]'
                        pattern_idx(ee) = 44;
                    case '[1 0 4]'
                        pattern_idx(ee) = 45;
                    case '[0 1 4]'
                        pattern_idx(ee) = 46;
                    case '[5 0 0]'
                        pattern_idx(ee) = 51;
                    case '[0 5 0]'
                        pattern_idx(ee) = 52;
                    case '[0 0 5]'
                        pattern_idx(ee) = 53;
                end
            end
        end
    end
end