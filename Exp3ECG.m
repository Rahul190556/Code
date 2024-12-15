ecg_data = load('100m.mat'); % Load ECG data
ecg_signal = ecg_data.val(1, :); % Use the first channel of the loaded ECG signal

fs = 250; 


t = (0:length(ecg_signal)-1) / fs; % Time vector in seconds

% Plot the original ECG signal
figure;
subplot(3,1,1);
plot(t, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;


fc_baseline = 0.5; % Cutoff frequency for baseline wander in Hz
[b_high, a_high] = butter(2, fc_baseline / (fs / 2), 'high');
ecg_no_baseline = filtfilt(b_high, a_high, ecg_signal);


fc_noise = 40; % Cutoff frequency for high-frequency noise in Hz
[b_low, a_low] = butter(4, fc_noise / (fs / 2), 'low');
ecg_filtered = filtfilt(b_low, a_low, ecg_no_baseline);

% Plot the results
subplot(3,1,2);
plot(t, ecg_no_baseline);
title('After Baseline Wander Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

subplot(3,1,3);
plot(t, ecg_filtered);
title('After High-Frequency Noise Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;