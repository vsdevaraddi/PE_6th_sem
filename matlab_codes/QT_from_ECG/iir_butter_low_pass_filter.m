function Hd = iir_butter_low_pass_filter(Fs,Fpass,Fstop)
%IIR_BUTTER_LOW_PASS_FILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.8 and DSP System Toolbox 9.10.
% Generated on: 18-Feb-2021 21:07:02

% Butterworth Lowpass filter designed using FDESIGN.LOWPASS.

% All frequency values are in Hz.
%Fs = 512;  % Sampling Frequency

%Fpass = 0.05;        % Passband Frequency
%Fstop = 40;          % Stopband Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 80;          % Stopband Attenuation (dB)
match = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% [EOF]
