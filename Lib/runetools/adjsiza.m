function varargout = adjsiza(varargin)
% DESCRIPTION [a,b,...] = adjsiza(a,b,...) 
%  Will extend singleton dimensions on each input argument to match
%  the size of the other arguments. If dimensions are not singletons
%  nor of the same size as the rest of the inputs, an error will occur.
%  It is not an error if any argument is empty. The result is matrices
%  of the same size.
% INPUT
%  any number of matrices
% OUTPUT
%  one matrix for each input all of the same size
% TRY 
%  [a, b] = adjsiza(ones(1,1,2,2), ones(1,2,2,1))
%  [a, b] = adjsiza(ones(1,1,2,2), ones(0,2,2,1))
% SEE ALSO
%  adjsiz, adjsizabdim

% by Magnus Almgren 050127 fix for the empty case MA 050127 
% bugfix savg./s MA 050530
 
s = sizes(varargin{1:end}); % the sizes of all inputs in one matrix

s1 = s==1; % binary matrix pointing at all singletons
warning off % MATLAB:divideByZero
savg = repmat(sum(s.*~s1,1)./sum(~s1,1),size(s,1),1); % average over all non-singletons
resiz = savg./s; 
warning on % MATLAB:divideByZero

resiz(isnan(resiz))= 1; % fix division by zero
if ~all(all(savg==s | s1)); 
 error('Input arguments mismatch')
end
 for j = 1:max(nargout,nargin>0)  % go through all arguments
  % an error if number of input matrices to reshape are less than number of outputs 
  varargout{j} = repmat(varargin{j}, resiz(j,:)); % expand size to maxs
 end
 
