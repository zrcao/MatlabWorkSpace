function [ms] = channel(d, mp, ms)
% DESCRIPTION
%  outsig = channel(d, mp, insig) -- implementing digital signal
%  processing tasks, upsampling and digitial IF upconversion, which are
%  usually put right before DAC.
% INPUT
%  d.tm -- the dimention in which time domain signals are placed.
%  d.tau -- the channel delay spread dimension
%  mp.txfilt -- DAC oversampling rate
%  mp.usDac -- oversampling rate for DAC
%  mp.fadingch -- using fading channel or AWGN channel
%  mp.pathSz -- number of path given the DAC sampling rate
%  mp.chSeed -- Seeds for generate the channel
%  mp.chnpw -- normalized channel power
%  mp.pwdecay -- channel power decay profile (amplitude)
%  insig -- the input signal matrix
%  
% OUTPUT
%  outsig -- output signal with samples on d.samp

% by Zhongren Cao 2007.02.10 
%% #############################################################################
%% INITIALIZATION

%% #############################################################################
%% FUNCTION CODE

% generate and apply channel if using fading channel
if mp.chFading
    % This method normalises the power. No variation!!!!!
    oldseed = setseed(mp.chSeed);  % save seed and restore seed after use of random generator 
    ms.ch = mprod(flatten(randn(mp.pathSz, 2)*[1;j], d.tau), mp.pwdecay);
    setseed(oldseed);
    % signal go through the channel
    ms.BbsigCh = filter(ms.ch, 1, ms.txBbwGain, [], d.tm);
    % power adjustment
    ms.init_pw = lin2db(mean(abs(ms.BbsigCh(((16*mp.os+1):mp.spSz*mp.os)...
        + mp.usDac*(mp.frmGapPreUsIdl+mp.frmGapPreSgUsIdl))).^2))+30;
    ms.chg_pw = ms.txpower_dBm + mp.chnpwdB - ms.init_pw;
    ms.BbsigCh = ms.BbsigCh*sqrt(db2lin(ms.chg_pw));
else
    ms.ch = sqrt(mp.chnpw);
    ms.BbsigCh = ms.ch*ms.txBbwGain;
end
