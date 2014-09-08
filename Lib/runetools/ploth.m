function h = ploth(varargin) 
% DESCRIPTION h = ploth(x,y,...)
%  The same as plot but the plot is held
%  to make overlaid plots. The hold state is restored
%  to it's original state afterwards
% INPUT 
%  x,y  --  A list of arguments similar to the function plot.
% OUTPUT
%  h --  The axis handle.
% SEE ALSO 
%  plotnh, plot
% TRY
%  plotnh(irandn(100),'b.'), ploth(irand(100),'r.')

% by Magnus Almgren 010220 revised 040202

holdstate = sethold(1); % set hold on
% do the plot and if command fails, restore holdstate
eval('handles = plot(varargin{:});','sethold(holdstate);')
if nargout == 1 % Deliver handle ?
 h = handles;
end
sethold(holdstate); % restore hold state
% $Id: ploth.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
