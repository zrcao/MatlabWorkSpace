function res = plotdot(xyp, radius, color, ncorn, ratio)
% DESCRIPTION plotdot(xyp, r, c, ncorn, ratio)
%  Draws patches with radius 
%  and color. Also the form and number of corners can be altered.
%  All argument have default values except xyp.
%  Default a black dot with 16 corners.
%  Singleton are automatically expanded to match the other arguments.
% INPUT
%  xyp --    The complex position of each patch.
%  radius -- The complex radius to the corners of the patch.
%  color --  The color of each patch in the interval 0 to 1.
%            The scaling of colors then goes from black over red to white
%            If c is set to NaN a greyish color is used.
%  ncorn --  The number of corners in the patch.
%  ratio --  Determines the form of the patch.
% OUTPUT
%  res --    Handle to the figure
%  --        The plot itself
% SEE ALSO
%  cdfplothigh, ploth
% TRY
%  plotdot(irand(3), 0.1*rand(3), rand(3))
%  plotdot(irand(3),irand(3),rand(3),ceil(rand(3)*6),rand(3))
%  try also the virtual artist:
%  plotdot(mplus(1:5,i*(1:5)'), 0.5*rand(1,5), 0.5+2*rand(5,1),4)

% by Magnus Almgren 990225 fix for the empty case MA 050217

% Set color table with last color for NaNs.
colormap([hot(64); 0.9*ones(1,3)]);

% Clean up variables.
setifnotexistorempty('radius',1) % Default radius = 1
setifnotexistorempty('color' ,0) % Default color  = 0
setifnotexistorempty('ncorn',16) % Default number of corners = 16
setifnotexistorempty('ratio',1) % Default ratio = 1

% Adjust size of inputs.
[xyp, r, c, ncorn, rat] = ...
adjsiza(xyp, radius, color, ncorn, ratio);
if isempty(xyp) % just return if nothing there
 return
end

xyp = xyp(:).';  % make all variables point along 2nd dimension
r = r(:).';
c = c(:).';
ncorn = ncorn(:).';
rat = rat(:).';

ncornm = max(ncorn);
% set NaNs to 2 and give them the special nancolor later
nanind = isnan(c);
c = max(0,min(1,c));
c(nanind) = 2;

% make the patch shape 
% the number of rows is determined by the patch with most corners
cornv = mprod((0:ncornm-1)',1./ncorn); 
cornv(cornv>=1) = 0;  % reset all excessive vertices
% adjust so that radius is perp to one side of the patch
% cornv = mplus(cornv,0.5./ncorn); 

dot = exp(i*2*pi*cornv);
dot = mprod(real(dot),rat) + mprod(i*imag(dot),1./rat);

% make patchedges and colors in corners of patches
xy = mplus(xyp, mprod(r, dot));
cxy = adjsiza(c, dot);

% Make the plotting.
if size(xy,2)>0
  clf;
  h = patch(real(xy),imag(xy), cxy); % draw all objects
  set(h,'Edgecolor','none'); % take away edges
  axis('equal');  % isotropic view
  % set coloraxis to adjust for NaNcolor
  caxis([0 eps+1+1/(size(colormap,1)-1)]);
end
if nargout > 0 % deliver a handle if asked for
   res = h;
end

% $Id: plotdot.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
