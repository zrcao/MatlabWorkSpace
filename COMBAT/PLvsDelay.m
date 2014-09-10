%% 
clear *;
h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

libpath = genpath('../Lib');
addpath(libpath);

%%
fontsz = 16;

%% Parameters
c = 3e8; % Speed of light, meters/second
f = 1200; % MHz

figure(1); % Short Distance (300m to 30km)
delay = (1:100); % micro seconds
dis = delay*1e-6*c;
l = freeSpacePathLoss(dis, f);
plot(delay, -l);
grid on;

figure(2); % Larger distance (30km to 1200km)
delay = 0.1:0.1:4; % millisecond
dis = delay*1e-3*c;
l = freeSpacePathLoss(dis, f);
plot(delay, -l);
grid on;
haxes2 = gca;
set(haxes2, 'YLim', [-158, -122]);
set(haxes2, 'YTick',[-158:6:-122]); 
ylabel(haxes2, 'Free Space Path Loss (dB)', 'FontSize', fontsz+4);
set(haxes2, 'XLim', [0, 4.5]);
xlabel(haxes2, 'Propagation Delay (ms)', 'FontSize', fontsz+4);

haxes2_pos = get(haxes2, 'Position');
haxes2a = axes('Position', haxes2_pos, ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right', ...
    'Color', 'none');
set(haxes2a, 'YTick', []);
set(haxes2a, 'XLim', [0 4.5]*1e-3*c);
set(haxes2a, 'XTick', [0.5:0.5:4]*1e-3*c)
set(haxes2a, 'XTickLabel', {'150', '300', '450', '600', '750', ...
    '900', '1050', '1200'}, 'FontSize', fontsz);
xlabel(haxes2a, 'Maximum Range (km)', 'FontSize', fontsz+4);


%% Throughput Gains
% Origin: 1 data unit every 1 transmission time plus 1 delay
% Cooperative: double the rate, double transmisson, two half delay so
%          2 data unit every 2 transmission time plus 1 delay

txLen = (0.5:0.5:3); % ms
propogation = (0.1:0.1:4)'; % ms
gain = mprod(propogation, 1./mplus(2*txLen, propogation));
figure(3);
plot(propogation, gain, '-o');
axis([0 4.5 0 0.9]);
grid on;
haxes3 = gca;
set(haxes3, 'YTickLabel', {'0', '10%', '20%', '30%', '40%', '50%', ...
    '60%', '70%', '80%', '90%'}, 'FontSize', fontsz);
ylabel(haxes3, 'Cooperative Throughput Gains', 'FontSize', fontsz+4);
xlabel(haxes3, 'Propagation Delays (ms)', 'FontSize', fontsz+4);
ll = legend('Slot Transmission Time 0.5 ms', ...
    'Slot Transmission Time   1 ms', ...
    'Slot Transmission Time 1.5 ms', 'Slot Transmission Time   2 ms', ...
    'Slot Transmission Time 2.5 ms', 'Slot Transmission Time   3 ms', ...
    'Location', 'NorthWest');
set(ll, 'FontSize', fontsz);

haxes3_pos = get(haxes3, 'Position');
haxes3a = axes('Position', haxes3_pos, ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right', ...
    'Color', 'none');
set(haxes3a, 'YTick', []);
set(haxes3a, 'XLim', [0 4.5]*1e-3*c);
set(haxes3a, 'XTick', [0.5:0.5:4]*1e-3*c)
set(haxes3a, 'XTickLabel', {'150', '300', '450', '600', '750', ...
    '900', '1050', '1200'}, 'FontSize', fontsz);
xlabel(haxes3a, 'Maximum Range (km)', 'FontSize', fontsz+4);

%% Remove path
% rmpath(libpath);