function v = vec(len,dim,value)
% DESCRIPTION v = vec(len,dim,value)
%  Creates a vector of length len in dimension dim vith values val.
% INPUT
%  len --  length of the resultin vectora non negative integer
%  dim    -- dimension, a postive integer
%  value  -- content of the vector
%    
% OUTPUT 
%  v -- a vector vith only one nonsingleton dimension
% TRY
%  vec(10,3,inf)
%  vec(3,2,true)
% SEE ALSO 
%  zeros, ones, infs

% by Magnus Almgren 050817
setifnotexist('value',0);
setifnotexist('dim',1);

% create a proper size vector
siz(1:dim-1) = 1; % for all dimensions up to dim
siz(dim) = len;
siz(dim+1) = 1; % in the case dim == 1

v = repmat(value,siz); % repeat to according to siz
