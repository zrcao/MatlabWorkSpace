%% Fragment Mapping
% Row represents different numbers of segments, they are
%     [ 2 (33/34); 
%       4 (17, 16, 16, 18); 
%       8 (9, 8, 8, 8, ..., 8, 10);
%      13 (6, 5, 5, 5, ......, 5, 6);] 
% Columns represents space between different segments, they are
%     [ 2 channels, 6 channels, 13 channels, 26 channels, 52, 129 ]
%       500kHz      2MHz        5MHz         10 MHz       20,  50 MHz
mappings = cell(4, 6);

sig_pos = [-33:-1 0:33]';
sig_pos = sort(sig_pos + (sig_pos<0)*256)+1;
%% 2 segments {33 34}
% 2 channel spacing
bin_pos = flatten(mplus((0:1)'*35+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-35;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 1} = [sig_pos bin_pos];

% 6 channel spacing
bin_pos = flatten(mplus((0:1)'*39+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-37;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 2} = [sig_pos bin_pos];

% 13 channel spacing
bin_pos = flatten(mplus((0:1)'*46+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-41;

bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 3} = [sig_pos bin_pos];

% 26 channel spacing
bin_pos = flatten(mplus((0:1)'*59+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-47;

bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 4} = [sig_pos bin_pos];

% 52 channel spacing
bin_pos = flatten(mplus((0:1)'*85+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-60;

bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 5} = [sig_pos bin_pos];

% 129 channel spacing
bin_pos = flatten(mplus((0:1)'*162+1, 0:32)');
bin_pos = [bin_pos; max(bin_pos)+1]-99;

bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{1, 6} = [sig_pos bin_pos];

%% 4 segments {16, 17, 17, 17}
% 2 channel spacing
bin_pos = flatten(mplus((0:3)'*(17+2), 0:16)');
bin_pos = bin_pos(2:end) -37;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{2, 1} = [sig_pos bin_pos];

% 6 channel spacing
bin_pos = flatten(mplus((0:3)'*(17+6), 0:16)');
bin_pos = bin_pos(2:end) - 23;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{2, 2} = [sig_pos bin_pos];

% 13 channel spacing
bin_pos = flatten(mplus((0:3)'*(17+13), 0:16)');
bin_pos = bin_pos(2:end) - 53;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{2, 3} = [sig_pos bin_pos];

% 26 channel spacing
bin_pos = flatten(mplus((0:3)'*(17+26), 0:16)');
bin_pos = bin_pos(2:end) - 73;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{2, 4} = [sig_pos bin_pos];

% 52 channel spacing
bin_pos = flatten(mplus((0:3)'*(17+52), 0:16)');
bin_pos = bin_pos(2:end) - 112;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{2, 5} = [sig_pos bin_pos];


% figure(9);
% stem(bin_pos, ones(length(bin_pos), 1));
% axis([-128, 127, -0.1, 2]);


%% 8 segments {9 8 8 8 8 8 8 10}
% 2 channel spacing
bin_pos = flatten(mplus((0:7)'*(8+2), 0:7)');
bin_pos = [-1; bin_pos; max(bin_pos)+(1:2)'] - 39;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{3, 1} = [sig_pos bin_pos];

% 6 channel spacing
bin_pos = flatten(mplus((0:7)'*(8+6), 0:7)');
bin_pos = [-1; bin_pos; max(bin_pos)+(1:2)'] - 53;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{3, 2} = [sig_pos bin_pos];

% 13 channel spacing
bin_pos = flatten(mplus((0:7)'*(8+13), 0:7)');
bin_pos = [-1; bin_pos; max(bin_pos)+(1:2)'] - 77;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{3, 3} = [sig_pos bin_pos];

% 26 channel spacing
bin_pos = flatten(mplus((0:7)'*(8+26), 0:7)');
bin_pos = [-1; bin_pos; max(bin_pos)+(1:2)'] - 123;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{3, 4} = [sig_pos bin_pos];


%% 13 segments { 6 5 5 5 5 5 5 5 5 5 5 5 6}
sig_pos = flatten(mplus((-32:5:32)', 0:4)');
sig_pos = [-33; sig_pos; 33;];
sig_pos = sort(sig_pos + (sig_pos<0)*256)+1;

% 2 channel spacing
bin_pos = flatten(mplus((0:12)'*7+1, 0:4)');
bin_pos = [0; bin_pos; max(bin_pos)+1;]-45;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{4, 1} = [sig_pos bin_pos];

% 6 channel spacing
bin_pos = flatten(mplus((0:12)'*11+1, 0:4)');
bin_pos = [0; bin_pos; max(bin_pos)+1;]-69;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{4, 2} = [sig_pos bin_pos];

% 13 channel spacing
bin_pos = flatten(mplus((0:12)'*18+1, 0:4)');
bin_pos = [0; bin_pos; max(bin_pos)+1;]-111;
bin_pos = sort(bin_pos + (bin_pos<0)*256)+1;
mappings{4, 3} = [sig_pos bin_pos];




