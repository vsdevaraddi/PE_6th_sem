function Hd = equi_high_pass_filter(Fs,Fstop,Fpass)
%EQUI_HIGH_PASS_FILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.8 and DSP System Toolbox 9.10.
% Generated on: 18-Feb-2021 20:29:19

% Equiripple Highpass filter designed using the FIRPM function.

% All frequency values are in Hz.
%Fs = 512;  % Sampling Frequency

%Fstop = 0.05;            % Stopband Frequency
%Fpass = 0.5;             % Passband Frequency
Dstop = 0.0001;          % Stopband Attenuation
Dpass = 0.057501127785;  % Passband Ripple
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop, Fpass]/(Fs/2), [0 1], [Dstop, Dpass]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
