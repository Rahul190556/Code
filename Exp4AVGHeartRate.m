% Load ECG Data
ecg_data = load('100m.mat'); 
ecg_signal = ecg_data.val(1, :);
fs = 250; % Sampling frequency in Hz
t = (0:length(ecg_signal)-1) / fs; % Time vector in seconds

% Plot the ECG Signal
figure;
plot(t, ecg_signal);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('ECG Signal');
grid on;

% Detect R-peaks
% Using MATLAB's findpeaks function
[~, r_peaks] = findpeaks(ecg_signal, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6*fs);

% Mark R-peaks on the ECG signal
hold on;
plot(r_peaks / fs, ecg_signal(r_peaks), 'ro');
legend('ECG Signal', 'R-peaks');

% Calculate RR Intervals
rr_intervals = diff(r_peaks) / fs; % RR intervals in seconds
heart_rate = 60 ./ rr_intervals; % Heart rate in bpm

% Average Heart Rate
avg_heart_rate = mean(heart_rate);

% Display Results
disp('Heart Rate Analysis:');
disp(['RR Intervals (s): ', num2str(rr_intervals)]);
disp(['Instantaneous Heart Rates (bpm): ', num2str(heart_rate)]);
disp(['Average Heart Rate (bpm): ', num2str(avg_heart_rate)]);

 % Annotate the graph for easier understanding
for i = 1:length(r_peaks)-1
    xline(r_peaks(i) / fs, '--g', 'LineWidth', 1); % Mark RR intervals
    text((r_peaks(i)+r_peaks(i+1))/(2*fs), max(ecg_signal)*0.9, ...
        ['RR = ', num2str(rr_intervals(i), '%.2f'), ' s'], ...
        'HorizontalAlignment', 'center');
end