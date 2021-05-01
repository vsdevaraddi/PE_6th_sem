%{
This code is MIT licensed.

Description:
This code uses PPG signals to estimate non-corrected QT interval by detecting A
and B peaks of second derivative of ppg signals.

The process is refered from "Extracting Features Similar to QT Interval
from Second Derivativesof Photoplethysmography: A Feasibility Study".

The parameters are choosen to give best result for my hardware setup.

This code is written by Veerendra S Devaraddi
%}

clear;
%% reading data
ppg_signal = csvread('ppg_data.csv');
ppg_signal= ppg_signal(1:end-1,:);
ppg_signal(:,1) = (ppg_signal(:,1) - ppg_signal(1,1))/1000;

figure(4)
fs = length(ppg_signal(:,2))/ppg_signal(end,1);
f  = -fs/2:fs/length(ppg_signal) :fs/2 - fs/length(ppg_signal);
plot(f,abs(fftshift(fft(ppg_signal)/length(ppg_signal))));
axis([-8 8 -inf 5000]);
title("Frequency spectrum of ppg signals");
xlabel("f (Hz)")

%% resampling the data
figure(1)
fs = length(ppg_signal(:,2))/ppg_signal(end,1);
plot(ppg_signal(:,1),ppg_signal(:,2));
%Hd = band_pass_filter(fs,0,0.6,14.4,15);
Hd = high_pass_filter(fs,0,0.6);
ppg_signal(:,2) = filter(Hd,ppg_signal(:,2));
ppg_signal = ppg_signal(2000:end,:);
ppg_signal(:,2) = ppg_signal(:,2) - min(ppg_signal(:,2));
ppg_signal(:,2) = ppg_signal(:,2)/max(ppg_signal(:,2));
ppg_signal = resample(ppg_signal,4000,4005);
plot(ppg_signal(:,1),ppg_signal(:,2));
title("Full PPG signal")
xlabel("t(s)")

%% take a sample
ppg = ppg_signal(1000:5000,:);

fs  = 400;

ppg(1001,:) = []; %to make time domain strictly increaseing
%% second derivative
ppg_first_deri = gradient(ppg(:,2))./gradient(ppg(:,1));
sdppg = gradient(ppg_first_deri)./gradient(ppg(:,1));

%ppg1(:,1) = min(ppg(:,1)):1/fs:max(ppg(:,1))-1/fs; 
figure(2)
plot(ppg(:,1),ppg(:,2));
hold on
%sdppg = resample(sdppg,2,4);
%sdppg_time = resample(ppg(1:end,1),2,4);
Hd = low_pass_filter(fs,10,30);
sdppg = filter(Hd,sdppg);
factor_plot = 250;
ppg_time = min(ppg(:,1)) : 1/fs : max(ppg(:,1))-1/fs;
plot(ppg(:,1),sdppg/factor_plot);


%% detecting peak point in second derivative
height_constrain = mean(abs(sdppg));
[pk,loc] = findpeaks(sdppg,ppg(:,1),'MinPeakHeight',height_constrain);
plot(loc,pk/factor_plot,'*');

%% detection of A peak
A = [];
span_A_precentage = 0.15;
for i = 1:length(loc)-1
    rr_interval = loc(i+1) - loc(i);
    span_A = span_A_precentage * rr_interval;
    [~,from] = min(abs(ppg(:,1)-loc(i)));
    [~,to] = min(abs(ppg(:,1)-(loc(i)+span_A)));
    [a_val, a_loc] = min(sdppg(from:to)/factor_plot);
    a_loc = from + a_loc;
    A = [A a_loc];
end

%% detection of B peaks
B = [];
span_B_percentage = 0.40;
for i = 2 : length(loc)
    rr_interval = loc(i) - loc(i-1);
    span_B = span_B_percentage*rr_interval;
    [~,from] = min(abs(ppg(:,1) - (loc(i)-span_B)));
    [~,to] = min(abs(ppg(:,1)-loc(i)));
    [b_val,b_loc] = max(sdppg(from:to-20)/factor_plot);
    b_loc = from + b_loc; 
    B = [B b_loc];
end
hold on;
plot(ppg(A,1),sdppg(A)/factor_plot,'>');
hold on;
plot(ppg(B,1),sdppg(B)/factor_plot,'<');
legend(["PPG","SDPPG","Uni peaks","A peak","B peak"])
title("SDPPF and PPG signals with A and B peaks");
xlabel("t (s)");
axis([-inf inf -1.5 2])
qt = (ppg(A(2),1) - ppg(B(1),1))*1000;
disp("QT interval = "+qt);
