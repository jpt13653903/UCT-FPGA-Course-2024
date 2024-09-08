close all;
clear all;
fclose all;
clc;

format compact
format long eng
%% -----------------------------------------------------------------------------

% % 440 Hz when played at 100 MSps
% fs = 100e6;
% t = (0:2^26-1)/fs;
% Data = sin(2*pi*440*t);
% Data = uint8(round((Data/2+0.5)*(2^8-1)));
% ExportData(Data, '440 Hz Sine (100 MSps)');
%
% % 60 kHz when played at 100 MSps
% fs = 100e6;
% t = (0:2^26-1)/fs;
% Data = sin(2*pi*60e3*t);
% Data = uint8(round((Data/2+0.5)*(2^8-1)));
% ExportData(Data, '60 kHz Sine (100 MSps)');

% 60 kHz square when played at 100 MSps
fs = 100e6;
t = (0:2^26-1)/fs;
Data = sin(2*pi*60e3*t);
Data = uint8(round((Data > 0) .* (2^8-1)));
ExportData(Data, '60 kHz Square (100 MSps)');

figure; plot(Data(1:10000)); grid on;
%% -----------------------------------------------------------------------------
