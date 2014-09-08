function setifnotexistorempty(v,value)
% DESCRIPTION 
%  setifnotexistorempty(v,value)
%  sets variable v to value if it doesn't exist or is empty
% INPUT
%  v --   a string denoting the name of the variable
%  value -- a any variable or string that can be evaluated
% OUTPUT
%  none except the sideeffect
% SEE ALSO
%  setifnotexist, exist, evalin
% TRY
%  setifnotexistorempty('a',1)
%  setifnotexistorempty('b','2')
%  setifnotexistorempty('c','a+b')
%  setifnotexistorempty('d','[1 2 3]')
%  setifnotexistorempty('d', [1 2 3] )
%  setifnotexistorempty('d', [1; 2] ) % doesn't work though

% by Magnus ALmgren 031130
if ~isstr(value)
 value = ['[' num2str(value) ']'];
end
setstr = sprintf('if ~exist(''%s'',''var'') | isempty(%s), %s = %s; end',v,v,v,value);
% make setstr in caller space when v doesn't exist or isempty(v)
evalin('caller',setstr) 

% $Id: setifnotexistorempty.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
