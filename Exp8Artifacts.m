% Load ECG data (Replace with your own data file)
data = load('100m.mat');
ecg_signal = data.val(1, :); 
fs = 250; 
% Time vector
N = length(ecg_signal); 
t = (0:N-1) / fs; 
% Plot the original ECG signal
figure;
subplot(3, 2, 1);
plot(t, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% --- 1. Remove Baseline Wander (High-pass filter) ---
fc_baseline = 0.5; % Cutoff frequency for baseline wander in Hz
[b_high, a_high] = butter(2, fc_baseline / (fs / 2), 'high');
ecg_no_baseline = filtfilt(b_high, a_high, ecg_signal);

% Plot the ECG after baseline wander removal
subplot(3, 2, 2);
plot(t, ecg_no_baseline);
title('ECG After Baseline Wander Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% --- 2. Remove High-frequency Noise (Low-pass filter) ---
fc_noise = 40; % Cutoff frequency for high-frequency noise in Hz
[b_low, a_low] = butter(4, fc_noise / (fs / 2), 'low');
ecg_filtered = filtfilt(b_low, a_low, ecg_no_baseline);

% -- 3. Plot the ECG after high-frequency noise removal
subplot(3, 2, 3);
plot(t, ecg_filtered);
title('ECG After High-Frequency Noise Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% --- 4. Remove Motion Artifacts (Band-pass filter) ---
fc_low = 0.5; % Low cutoff frequency for ECG signal
fc_high = 50; % High cutoff frequency for ECG signal
[b_bandpass, a_bandpass] = butter(4, [fc_low / (fs / 2), fc_high / (fs / 2)], 'bandpass');
ecg_bandpass_filtered = filtfilt(b_bandpass, a_bandpass, ecg_filtered);


% Plot the ECG after motion artifact removal
subplot(3, 2, 5);
plot(t, ecg_bandpass_filtered);
title('ECG After Motion Artifact Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% Powerline Interference (50 Hz)
fc_line = 50; % Powerline frequency (50 Hz)
Q_factor = 35; % Quality factor (higher Q gives a narrower notch)
% Normalized frequency (W0) for the notch filter
W0 = fc_line / (fs / 2); % W0 is normalized by Nyquist frequency
BW = W0 / Q_factor; % BW is related to Q-factor
[b_notch, a_notch] = iirnotch(W0, BW); 
ecg_no_interference = filtfilt(b_notch, a_notch, ecg_filtered);
% Plot the ECG after powerline interference removal
subplot(3,2,4)
plot(t, ecg_no_interference);
title('ECG After Powerline Interference Removal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;
