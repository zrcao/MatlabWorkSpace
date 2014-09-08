% RUNETOOLS - general purpose functions
%
% adjsiza       - Expands all inputs to the same size.
% adjsiz        - Expands all inputs to the same size. All inputs are stored in a cell array
% adjsizabdim   - Expands all inputs to the same size except for one selected dimension
% repelem       - Epxands every element into a matrix of a given size. Much like repmat 
% padsiz        - enlarges a matrix to a given size 
%
% sizem         - The size of a matrix for some given dimensions
% sizes         - Sizes of several matrices at the same time
% maxsize       - Maximum size over several matrices
% swdims        - Switch of one dimension into another
% flatten       - Aligns a matrix into one spcific dimension
%
% nans          - Generates a matrix with NaN
% infs          - Generates a matrix with Inf
% irand         - Generates a matrix with complex rectangular distributed random values 
% irandn        - Generates a matrix with complex normal distributed random values
%
% firstsing     - The first singleton dimension
% firstnonsing  - The first non singleton dimension
% lastnonsing   - The last non singleton dimension
%
% index         - A flat index into a matrix. As sub2ind but more general
% index1        - As above but for one specified dimension only
%
% sortind       - Index into a matrix in the ascending order of elements
% wrapind       - Wraps index into a given range 
% minind        - Index to the smallest element
% maxind        - Index to the largest element
% ismin         - Binary matrix pointing to the smallest element
% ismax         - Binary matrix pointing to the largest element
%
% clean         - cleans a vector from non finite elements. 
%
% db2lin        - Decibels to linear power. 10^(x/10)
% lin2db        - Linear power into Decibels  10*log10(x)
% linsum        - Linear sum of values expressed in decibels
% linmean       - Linear mean of values expressed in decibels 
% lincumsum     - Linear cumsum of values expressed in decibels
%
% mplus         - Addition of expanded matrices
% mprod         - Multiplication of expanded matrices
% mdiv          - Division of expanded matrices
% mexp          - Exponentiation of expanded matrices
%
% ncumsum       - Normalised version of cumsum
% norm1         - Vector norm of a matrix along a specified dimension
% percentile    - Percentile values of a matrix along a specified dimension
% binomial      - Binomial distribution
% poisson       - Poissson distribution
% qfunc         - Q-function
% qfuncinv      - Inverse Q-function
% erlang        - Erlang B distribution. Computes Blocking probabilities
% expfilt       - Exponential first order filter
%
% randpern      - Random integers. Related to randperm
% bindice       - Dice function for a given probability matrix
%
% sethold       - Control hold on, hold off for plotting
% setseed       - Control the seed in the random generators
% setifnotexist - Set a variable if it doesn't already exist
% setifnotexistorempty - Set a variable if it doesn't already exist or happens to be empty
%
% vsortind      - sorting index from values in one vector into another 
% rotate        - Rotation of elements in a matrix along a specified dimension
% interp1n      - Interpolation function
% histn         - N-dimensional histogram function
% histnw        - N-dimensional histogram function with a weight for each input
% 
% ploth         - Overlaid plot with hold on
% plotnh        - New plot with hold off
% plotnorm      - Plot where the yaxis is scaled such that the Q-function becomes a straight line
% cdfplotmed    - Cumultative distribution plot function
% cdfplothigh   - Cumultative distribution plot function that highlights the upper part
% cdfplotlow    - Cumultative distribution plot function that highlights the lower part
% plotdot       - Plot of i.e. hexagonal patches

% by Magnus Almgren 040218
% $Id: Contents.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $