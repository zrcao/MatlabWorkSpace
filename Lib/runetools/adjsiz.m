function v = adjsiz(varargin)
% DESCRIPTION cellarr = adjsiz(a,b,...) 
%  Will extend singleton dimensions on each input argument to match
%  the size of the other arguments. If dimensions are not singletons
%  nor of the same size as the rest of the inputs, an error will occur.
%  It is also an error if any argument is empty. The result is matrices
%  of the same size. The result is collected in a cellarray
% INPUT 
%  any number of matrices
% OUTPUT 
%  v --  A cellarray with one matrix for each input, 
%        all of the same size
% TRY 
%  a = adjsiz(ones(1,1,2,2), ones(1,2,2,1)) => size(a{1})==size(a{2})
% SEE ALSO
%  adjsiza, adjsizabdim, mplus, mprod

% by Magnus Almgren 990714 heavily revised 040202 by MA the mpty case 050127 MA

s = sizes(varargin{1:end}); % the sizes of all inputs in one matrix
s1 = s==1; % binary matrix pointing at all singletons
warning off % MATLAB:divideByZero
savg = repmat(sum(s.*~s1,1)./sum(~s1,1),size(s,1),1); % average over all non-singletons
resiz = 1./s.*savg; 
warning on % MATLAB:divideByZero
resiz(isnan(resiz))= 1; % fix division by zero
if ~all(all(savg==s | s1)); 
 error('Input arguments mismatch')
end
 for j = 1:max(1,nargin)  % go through all arguments
  % an error if number of input matrices to repmat
  % are less than number of outputs 
  v{j} = repmat(varargin{j}, resiz(j,:)); % expand size to resiz
 end
 
