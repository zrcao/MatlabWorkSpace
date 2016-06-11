%% Initialization Script for MegaMillion Number Processing
% MegaMillion numbers are stored in a two dimensional cell structure. The number
% of rows equals the number of stored draws. Each row has 5 cell elements,
% they are:
%   1. Date number of the drawing day
%   2. Date string of the drawing day
%   3. Ball numbers (size of [1 5] ordered from low to high
%   4. Mega Ball number
%   5. Mageplier number
% Before any number crunching, MegaMillionInit.m should be called, which
% loads previous stored Mega Million numbers (in the cell) into the workspace.

clear *;
megaMillionCell = MegaMillion();
%megaMillionCell.addNewDraw(2013, 11, 1, [32	35	49	62	67], 1, 5);
megaMillionCell.addNewDraw(2013, 11, 5, [2	11	42	64	74], 2, 5);
megaMillionCell.savedata();