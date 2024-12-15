% Load the ECG data
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

% --- Filtering the ECG Signal ---
% Remove baseline wander using a high-pass filter (cutoff frequency 0.5 Hz)
fc_baseline = 0.5; % Cutoff frequency for baseline wander in Hz
[b_high, a_high] = butter(2, fc_baseline / (fs / 2), 'high');
ecg_filtered = filtfilt(b_high, a_high, ecg_signal);

% Remove high-frequency noise using a low-pass filter (cutoff frequency 40 Hz)
fc_noise = 40; % Cutoff frequency for high-frequency noise in Hz
[b_low, a_low] = butter(4, fc_noise / (fs / 2), 'low');
ecg_filtered = filtfilt(b_low, a_low, ecg_filtered);

% Plot the filtered ECG signal
subplot(3, 2, 2);
plot(t, ecg_filtered);
title('Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% --- Compute FFT for Original ECG (Including Negative Frequencies) ---
ecg_fft = fft(ecg_signal); 
frequencies = (-N/2:N/2-1) * (fs / N); % Generate frequency vector (including negative frequencies)
ecg_fft_magnitude = fftshift(abs(ecg_fft / N)); % Shift zero frequency to center
ecg_fft_magnitude_clipped = min(ecg_fft_magnitude, 10); 

% Plot FFT of Original ECG Signal (Magnitude Limited)
subplot(3, 2, 3);
plot(frequencies, ecg_fft_magnitude_clipped);
title('FFT of Original ECG Signal (Magnitude Limited to 30)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% --- Compute FFT for Filtered ECG (Including Negative Frequencies) ---
ecg_filtered_fft = fft(ecg_filtered); % FFT of filtered signal
ecg_filtered_fft_magnitude = fftshift(abs(ecg_filtered_fft / N)); % Shift zero frequency to center

% Plot FFT of Filtered ECG Signal (Full Spectrum)
subplot(3, 2, 4);
plot(frequencies, ecg_filtered_fft_magnitude);
title('FFT of Filtered ECG Signal (Full Spectrum)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
