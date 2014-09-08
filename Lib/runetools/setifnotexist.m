function setifnotexist(v,value)
% DESCRIPTION 
%  setifnotexist(v,value)
%  sets variable v to value if it doesn't exist
% INPUT
%  v --   a string denoting the name of the variable
%  value -- a any variable or string that can be evaluated
% OUTPUT
%  none except the sideeffect
% SEE ALSO
%  setifnotexistorempty, exist, evalin
% TRY
%  setifnotexist('a',1)
%  setifnotexist('b','2')
%  setifnotexist('c','a+b')
%  setifnotexist('d','[1 2 3]') % works
%  setifnotexist('d', [1 2 3] ) % doesn't work though

% by Magnus ALmgren 031130
if ~isstr(value)
 value = ['[' num2str(value) ']'];
end
setstr = sprintf('if ~exist(''%s'',''var''), %s = %s; end',v,v,value);
% evaluate setstr in caller space when v doesn't exist
evalin('caller',setstr) 

% $Id: setifnotexist.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
