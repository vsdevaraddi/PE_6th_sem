function Hd = iir_least_low_pass_filter(Fs,Fpass,Fstop)
%IIT_LEAST_LOW_PASS_FILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.8 and DSP System Toolbox 9.10.
% Generated on: 18-Feb-2021 21:01:28

% IIR Least P-th norm Lowpass filter designed using the IIRLPNORM function.

% All frequency values are in Hz.
%Fs = 512;  % Sampling Frequency

Nb    = 8;                     % Numerator Order
Na    = 8;                     % Denominator Order
%Fpass = 0.050000000000000003;  % Passband Frequency
%Fstop = 40;                    % Stopband Frequency
Wpass = 1;                     % Passband Weight
Wstop = 1;                     % Stopband Weight
P     = [2 128];               % P'th norm
dens  = 20;                    % Density Factor

F = [0 Fpass Fstop Fs/2]/(Fs/2);

% Calculate the coefficients using the IIRLPNORM function.
[b,a,err,sos_var,g] = iirlpnorm(Nb, Na, F, F, [1 1 0 0], [Wpass Wpass ...
                                Wstop Wstop], P, {dens});
Hd                  = dfilt.df2sos(sos_var, g);

% [EOF]
