function holdstate = sethold(state)
% DESCRIPTION holdstate = sethold(state)
%  Controls hold on and off for plots.
%  outputs the current holdstate. Then a new state is set.
%  Without argument it leaves the corrent state
% INPUT 
%  state -- the new state to be used 1 <=> hold on, 0 <=> hold off.
% OUTPUT
%  holdstate --  The state before change.
% SEE ALSO 
%  plotnh, ploth, ishold, hold
% TRY
%  sethold(1), sethold(0), sethold

% by Magnus Allmgren 010220
holdstate = ishold;
if nargin >0
 if state 
  hold('on')
 else
  hold('off')
 end
end
% $Id: sethold.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
