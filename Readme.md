# QT interval estimation using body angles 

**College**: [International Institute of Information Technology Bangalore](https://www.iiitb.ac.in/)

**Mentor professor**: [Professor Madhav Rao](https://www.iiitb.ac.in/faculty/madhav-rao)

**Student**: Veerendra S Devaraddi, Integrated BTech + MTech, 3rd year.

## Project overview
 This project aims to create a wearable portable patch sensor which can keep track of the QT interval. The patch sensor uses Thoracic and Abdominal angles to reconstruct PPG signals. Further, the PPG signals can be used to estimate QT interval.

---

## Software used in the project
1. Matlab
2. Arduino IDE

---  

## Hardware used in the project
1. Two IMUs; LSM6DSLTR([datasheet](https://www.st.com/resource/en/datasheet/lsm6dsl.pdf)) breakout board.
2. One Pulse Oximeter; Protocentral AFE4490([datasheet](https://www.ti.com/lit/ds/symlink/afe4490.pdf)) Arduino shield.
3. ECG sensor; Protocentral ADS1292R([datasheet](https://www.ti.com/lit/ds/symlink/ads1292r.pdf)) Arduino shield.

---

## Folder structure

<pre>.
|-- Readme.md
|-- arduino_codes
|   |-- angle_ppg_data_aquisition
|   |   `-- angle_ppg_data_aquisition.ino
|   `-- data_collection_single_arduino
|       `-- data_collection_single_arduino.ino
|-- data
|   |-- 6_day_samples
|   |   |-- day1
|   |   |   |-- angle_day1.csv
|   |   |   `-- ppg_day1.csv
|   |   |-- day2
|   |   |   |-- angle_day2.csv
|   |   |   `-- ppg_day2.csv
|   |   |-- day3
|   |   |   |-- angle_day3.csv
|   |   |   `-- ppg_day3.csv
|   |   |-- day4
|   |   |   |-- angle_day4.csv
|   |   |   `-- ppg_day4.csv
|   |   |-- day5
|   |   |   |-- angle_day5.csv
|   |   |   `-- ppg_day5.csv
|   |   `-- day6
|   |       |-- angle_day6.csv
|   |       `-- ppg_day6.csv
|   |-- ECG
|   |   |-- ecg_data_no_time.log
|   |   `-- ecg_data_time.log
|   `-- PPG
|       `-- ppg_data.log
`-- matlab_codes
    |-- PPG_from_angles
    |   |-- angle_part6.csv
    |   |-- low_pass_filter.m
    |   |-- ppg.m
    |   |-- ppg_part6.csv
    |   |-- reconstructed_ppg.jpg
    |   |-- ventral_cavity_angle.jpg
    |   `-- ventral_cavity_angle_remove_body_mov.jpg
    |-- QT_from_ECG
    |   |-- band_high_pass_filter.m
    |   |-- band_low_pass_filter.m
    |   |-- ecg_data_time.csv
    |   |-- equi_high_pass_filter.m
    |   |-- equi_low_pass_filter.m
    |   |-- equi_low_pass_filter100.m
    |   |-- iir_butter_low_pass_filter.m
    |   |-- iir_least_low_pass_filter.m
    |   |-- peaks.jpg
    |   `-- qt_ecg.m
    |-- QT_from_PPG
    |   |-- Freq_spectrum_ppg.jpg
    |   |-- QT_from_ppg.m
    |   |-- band_pass_filter.m
    |   |-- full_ppg.jpg
    |   |-- high_pass_filter.m
    |   |-- low_pass_filter.m
    |   |-- ppg_and_peak_detection.jpg
    |   `-- ppg_data.csv
    `-- respiration_rate_from_angles
        |-- angle_part6.csv
        |-- double_smoothened_peaks_detection.jpg
        |-- filtered_ventral_angles.jpg
        |-- high_pass_filter_window.m
        |-- low_pass_filter_window.m
        |-- resp_rate.m
        `-- smoothened_ventral_angles.jpg

18 directories, 50 files
</pre>

---

### **Folder**: arduino_codes
 This folder contains all the Arduino codes.

 **angle_ppg_data_aquisition:** This Arduino code will collect data from the AFE4490 shield(PPG signals) and one IMU sensor(angle), and send it to the serial monitor. The conclusion of this code is that it is heavy for an Arduino uno R3 to run, as a consequence, it does not read data with the required rate.
 ```
 Open the program in Arduino IDE and upload it into the Arduino uno
 Hardware connections are mentioned in the program. 
 ```
 **data_collection_single_arduino:** This Arduino code will collect data from two LSM6DS3 breakout boards, and send it to the serial monitor. 
 ```
 Open the program in Arduino IDE and upload it into the Arduino uno
 Hardware connections are mentioned in the program. 
 ```

---

 ### **Folder**: matlab_codes
 This folder contains all the Matlab codes.

 **PPG_from_angles:** This folder contains the required data and Matlab codes to reconstruct PPG signals from ventral cavity angles. 
 ```
 Run "ppg.m" in Matlab to generate plots and ppg signals
 ```
 **QT_from_ECG:** This folder contains the required data and Matlab codes to estimate QT interval (non-corrected) from ECG signals. 
 ```
 Run "qt_ecg.m" in Matlab to generate plots and output QT interval.
 ```
 
 **QT_from_PPG:** This folder contains the required data and Matlab codes to estimate QT interval (non-corrected) from PPG signals.
 ```
 Run "QT_from_ppg.m" in Matlab to generate plots and output QT interval.
 ```
 **respiration_rate_from_angles:** This folder contains the required data and Matlab codes to estimate respiration rate from ventral cavity angles.
 ```
 Run "resp_rate.m" in Matlab to generate plots and output respiration rate.
 ```
 ---
 ### **Folder**: data
 This folder contains all the data collected during the project.

 ---

## Results
1. QT interval was estimated on the reconstructed PPG signals using the ventral cavity angles, and also on the True(actual) PPG signals. Following are the estimations:
    
   |Day No | QT interval from angles (ms)| True QT interval (ms)|
   | :---: |:---:|:---:|
   |1|359.0923|314.5214|
   |2|343.6126|249.1533|
   |3|336.5588|237.8482|
   |4|238.9248|259.3827|
   |5|269.6592|228.3827|
   |6|200.04|237.5688|

2. QT interval estimation from PPG and ECG signals, are implemented successfully. 
 
---

## Conclusions

 The plots of reconstructed PPGs from ventral cavity angles, do not have the periodic patterns that true PPG signals have. This holds us back from defining a theoretical max error metric between the both.  

---

## References

1. T. Elfaramawy, C. Latyr Fall, M. Morissette, F. Lellouche and B. Gosselin, "Wireless respiratory monitoring and coughing detection using a wearable patch sensor network," 2017 15th IEEE International New Circuits and Systems Conference (NEWCAS), 2017, pp. 197-200, doi: 10.1109/NEWCAS.2017.8010139.
2. N. Mahri, K. B. Gan and M. A. M. Ali, "Extracting features similar to QT interval from second derivatives of photoplethysmography: A feasibility study," 2014 IEEE Conference on Biomedical Engineering and Sciences (IECBES), 2014, pp. 470-473, doi: 10.1109/IECBES.2014.7047544.

---

## Disclaimer

All the data collected during the project are not according to standards, so the data is provided "as is" without warranty of any kind.

---

## License
All the Matlab codes are [MIT](https://choosealicense.com/licenses/mit/) licensed.

---
---