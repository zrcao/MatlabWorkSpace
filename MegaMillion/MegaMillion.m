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
                obj.resultsCell{1,2} = datestr([year, month, day, 0, 0, 0]);
                obj.resultsCell{1,1} = datenum(obj.resultsCell{1, 2});
                obj.resultsCell{1,3} = sort(balls(:))';
                obj.resultsCell{1,4} = megaballs;
                obj.resultsCell{1,5} = megaplier;
            else
                zisdatestr = datestr([year, month, day, 0, 0, 0]);
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
        %%
        function 
    end
end