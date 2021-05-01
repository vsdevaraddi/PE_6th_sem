%{
This code is MIT licensed.

Description:
This code uses ECG signals to estimate non-corrected QT interval by detecting Q
and T peaks. Assumption: Signal starts with R peak.

The process is refered from "Extracting Features Similar to QT Interval
from Second Derivativesof Photoplethysmography: A Feasibility Study".

The parameters are choosen to give best result for my hardware setup.

This code is written by Veerendra S Devaraddi
%}

clear;
%%reading the data
ecg_signal = csvread('ecg_data_time.csv');
ecg_signal(:,1) = (ecg_signal(:,1) - ecg_signal(1,1))/1000;
%plot(ecg_signal(:,1),ecg_signal(:,2));
axis([-inf inf -50 50]);
fs_original = length(ecg_signal(:,1))/ecg_signal(end,1);
ecg_signal1(:,1) = resample(ecg_signal(:,1),512,125);
ecg_signal1(:,2) = resample(ecg_signal(:,2),512,125);
fs = 512;

%%lets take a part of it to test processing
ecg = ecg_signal1(4500:6000,:);
figure(1)
plot(ecg(:,1),ecg(:,2)/10);

%%preprocessing
Hd =  equi_low_pass_filter(fs,0.05,40);
ecg(:,2) = filter(Hd,ecg(:,2));
Hd = band_high_pass_filter(fs,0.05,40);
ecg(:,2) = filter(Hd,ecg(:,2));
ecg(:,2) = ecg(:,2)/(max(max(ecg(:,2)),-min(ecg(:,2))));
%figure(2)
hold on
plot(ecg(:,1),ecg(:,2));
hold on
[pk,lc] = findpeaks(ecg(:,2),fs);
axis([-inf inf -3 3.5])
%plot(min(ecg(:,1))+lc,pk,'x');

%detecting R peaks
height_limit = mean(abs(ecg(:,2)));
[pk_r,lc_r] = findpeaks(ecg(:,2),fs,'MinPeakHeight',height_limit);
lc_r = lc_r + min(ecg(:,1));
hold on;
%plot(lc_r,pk_r,'o')
horizontal_limit = max(lc_r(2:2:end) - lc_r(1:2:end));
[pk_r,lc_r] = findpeaks(ecg(:,2),fs,'MinPeakHeight',height_limit,'MinPeakDistance',horizontal_limit);
lc_r = lc_r + min(ecg(:,1));
[pk_num_r,lc_num_r] = findpeaks(ecg(:,2),'MinPeakHeight',height_limit,'MinPeakDistance',fs*horizontal_limit);
plot(lc_r,pk_r,'^')

%detection of q peaks
[pk_q,lc_q] = q_detector(ecg(:,2),fs,lc_num_r);
lc_q = lc_q + min(ecg(:,1));
plot(lc_q,pk_q,'*');

%detection of t peaks
idx = ismember(ecg(:,1),lc_r);
height_limit = mean(abs(ecg(~idx,2)));
[pk_t,lc_t] = findpeaks(ecg(:,2),fs,'MinPeakHeight',height_limit);
lc_t = lc_t+min(ecg(:,1));
idx = ismember(lc_t,lc_r);
lc_t(idx) = [];
pk_t(idx) = [];
plot(lc_t,pk_t,'+');
title('ECG signal and its processed form with R, Q and T peak indications');
legend(["ECG","Processed ECG","R peak","Q peak","T peak"]);

qt = lc_t - lc_q;
rr = [lc_r(2:end) - lc_r(1:end-1)];
rr(end+1,:) = rr(end,:);

qts = qt./sqrt(rr);
mean_qt = mean(qts)*1000;
disp("Average QTc interval : "+mean_qt+" ms")

function [pk_q,lc_q] = q_detector(sig,fs,lc_r)
    lc_q=[];
    pk_q=[];
    for i= lc_r
        loc = i;
        j = loc;
        while sig(j-1) <= sig(j)
            j = j-1;
        end
        lc_q = [lc_q j];
        pk_q = [pk_q sig(j)];
    end
    lc_q = lc_q/fs;
end
    