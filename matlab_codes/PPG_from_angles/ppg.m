%{
This code is MIT licensed.

Description:
This code uses thoracic angle and abdominal angle to reconstruct PPG
signals.

The process is refered from "Wireless Respiratory Monitoring and Coughing
Detection Using a Wearable Patch Sensor Network".

The parameters are choosen to give best result for my hardware setup.

This code is written by Veerendra S Devaraddi
%}

%% reading the data
clear;
angles = csvread("angle_part6.csv");
angles = angles(10:end,:);
thoracic_angle = angles(:,2);
abdominal_angle = angles(:,3);
fs = length(angles)*1000/(angles(end,1)-angles(1,1));
disp("Data rate: "+fs)

%% calculating ventral body cavity angle
ventral_angle = (thoracic_angle + abdominal_angle)/2;
figure(1);
t = (angles(:,1) - angles(1,1)+1)./1000;
plot(t,ventral_angle);
title("ventral cavity angle");
xlabel("t in s");
ylabel("angle in deg")
axis([-inf inf 65 90]);
length(ventral_angle);
grid on;

%%removing body movements
window = floor(3 * fs); %3 seconds
ratio = floor(length(ventral_angle)/window);
for i = 1:window:ratio*window
    m = mean(ventral_angle(i+1:i+window-1)-ventral_angle(i:i+window-2));
    ventral_angle(i:i+window-1) = ventral_angle(i:i+window-1)-m;
end
ventral_angle(ratio*window+1:end) = ventral_angle(ratio*window+1:end)-mean(ventral_angle(ratio*window+1:end));
figure(2)
plot(t(1:end-500),ventral_angle(1:end-500));
title("ventral angle after removing body movements");
xlabel("t in s");
ylabel("angle in deg")
axis([-inf inf 65 90]);
grid on;
grid minor;

%%Low pass filter
Hd = low_pass_filter(fs,4);
ventral_angle_filtered = filter(Hd,ventral_angle);
figure(3)
plot(t(100:end-500),ventral_angle_filtered(100:end-500));
title("processed PPG signals");
axis([-inf inf -inf inf]);
xlabel("t in s");
grid on;
grid minor;

figure(4);
f  = -fs/2:fs/length(ventral_angle_filtered) :fs/2 - fs/length(ventral_angle_filtered);
plot(f,abs(fftshift(fft(ventral_angle_filtered)/length(ventral_angle_filtered))));
axis([-8 8 -inf inf])