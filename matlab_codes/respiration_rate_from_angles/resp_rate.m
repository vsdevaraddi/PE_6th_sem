%{
This code is MIT licensed.

Description:
This code uses ventral cavity angle to estimate respiration rate.

The process is refered from "Wireless Respiratory Monitoring and Coughing
Detection Using a Wearable Patch Sensor Network".

The parameters are choosen to give best result for my hardware setup.

This code is written by Veerendra S Devaraddi
%}

clear;
%% reading the data
angles = csvread("angle_part6.csv");
length(angles);
angles = angles(1:end,:);
thoracic_angle = angles(:,2);
abdominal_angle = angles(:,3);
angles(:,1) = angles(:,1)/1000; %ms to s
fs = length(angles)/(angles(end,1)-angles(1,1))


%% calculating ventral body cavity angle
ventral_angle = (thoracic_angle + abdominal_angle)/2;

%% decimating frequencies above 5Hz
Hd = low_pass_filter_window(fs,5);
ventral_angle_filtered = filter(Hd,ventral_angle);

%% first order filter at 0.01Hz
Hd = high_pass_filter_window(fs,0.01);
ventral_angle_filtered = filter(Hd,ventral_angle_filtered);

%% Savitzky-Golay smoothing filter,
%below parameters need tuning
order = 3;
frame_length = 71;
smoothened = sgolayfilt(ventral_angle_filtered,order,frame_length);

smoothened = smoothened(100:end);
ventral_angle_filtered = ventral_angle_filtered(100:end);
time = angles(100:end,1); 

figure(1)
plot(time,smoothened);
title("Smoothened waveform of filtered ventral angle waveform")
xlabel("t(s)");
grid on;
%hold on
figure(3)
plot(time,ventral_angle_filtered);
title("Filtered ventral angle waveform")
xlabel("t(s)");
grid on;
%hold off


figure(2)
order = 2;
frame_length = 101;
double_smoothened = sgolayfilt(smoothened,order,frame_length);
[pks,loc] = findpeaks(double_smoothened,time,'MinPeakDistance',0.3,'MinPeakProminence',0.001);
plot(time,double_smoothened);
hold on
plot(loc,pks,'*');
%plot(time,ventral_angle_filtered);
hold off
title("double smoothened ventral cavity angle")
xlabel("t(s)");
legend(["double smoothened","peak detections"]);
grid on;

interval = loc(2:end) - loc(1:end-1);
breath_interval_mean = mean(interval);
breath_rate = 1/breath_interval_mean;
disp("Respiration rate= "+breath_rate);

