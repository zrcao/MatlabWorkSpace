function varargout = adjsizabdim(varargin)
% DESCRIPTION [a,b,c,...] = adjsizabdim(dim,a,b,c,...) 
%  will extend singleton dimensions of
%  each input argument to match the other arguments except for the
%  dimensions dim where the sizes will remain the same as in the input arguments.
%  If dimensions are not singletons nor of the same size an error will occur.
% INPUT
%  dim      -- the dimensions along which no size expansion takes place
%  a,b,c... -- input matrices that will be expadned to match each other
% OUTPUT
%  a,b,c    -- matrices. Now all of the same size.
% TRY 
%  [a, b] = adjsizabdim(1,ones(2,1,3), ones(3,1,3))
% SEE ALSO
%  adjsiza, adjsiz

% by Magnus Almgren 030724 revised 040202 fix for the empty case MA 050127
% cosmetics MA 050429. Fix for only one input argument 050518 MA

s = sizes(varargin{2:end}); % the sizes of all inputs in one matrix

dim = varargin{1};
s(:,dim) = 1; % adjust size for dimensions dim only

s1 = s==1; % binary matrix pointing at all singletons
warning off
savg = repmat(sum(s.*~s1,1)./sum(~s1,1),size(s,1),1); % average over all non-singletons
resiz = 1./s.*savg; 
warning on

resiz(isnan(resiz))= 1; % fix division by zero
if ~all(all(savg==s | s1)); 
 error('Input arguments mismatch')
end
for j = 1:max(nargout,nargin>1)  % go through all arguments
 % an error if number of input matrices to repmat are less than number of outputs 
 varargout{j} = repmat(varargin{j+1}, round(resiz(j,:))); % expand size to maxs
end
