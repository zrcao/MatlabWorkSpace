function res = maxsize(varargin)
% DESCRIPTION res = maxsize(a,b,c,...)
%  Takes any number of inputs and 
%  leaves the maximum size for all of them.
% INPUT
%  a,b,c -- an argument list with variables of different sizes
% OUTPUT
%  res --  A vector indicating the maximum size needed
%          in order to contain any of the inputs.
% TRY
%  maxsize(ones(1,2,3), ones(2,1,3,4))
% SEE ALSO
%  sizem, sizes

% by Magnus Almgren 970527 revised 031118

res = max(sizes(varargin{:}),[],1);

% $Id: maxsize.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
