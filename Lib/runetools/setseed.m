function oseed = setseed(val1, val2) % sets the seed to random generators
% DESCRIPTION oseed = setseed(val1, val2)
%  The seed is set to the MATLAB 5 generator 
%  and the old seed is delivered as matrix output . 
%  If no input the seed is not altered.
% INPUT 
%  val1 --   A seed value vector 35 by 1 for the rand generator.
%  val2 --   A seed value vector 2 by 1 for the randn generator 
% OUTPUT
%  oseed --  The current states for rand and randn as a cell array.
% TRY
%  oseed = setseed(3),
%  oseed = setseed(3,4), 
%  oseed = setseed
% SEE ALSO
%  rand('state'), randn('state')

% by Magnus Almgren 990301m modified by MA 050727  seed => state

oseed = {rand('state') randn('state')}; % get the old seed
if nargin == 0
elseif nargin==1 & iscell(val1)
 setseed(val1{1},val1{2}); % the struct case
elseif nargin ==1 & length(val1(:)) == 1 
 setseed(val1,val1); % the scalar case 
elseif nargin ==1 & length(val1(:)) == 2
 setseed(val1(1),val1(2)); % two scalars
elseif nargin == 2 
 rand('state', val1);  % size(val1,1) is either 1 or 35  
 randn('state', val2);  % size(val1,1) is either 1 or 2
else
 error('Inputs are in of incorrect size or number') 
end


% $Id: setseed.m,v 1.4 2005/08/15 10:29:21 eraalm Exp $
