% Load EEG data
data = load('chb01_02_edfm.mat'); 

eeg_signal = data.val;

% Get the number of channels in the EEG data
num_channels = size(eeg_signal, 1);

% Determine appropriate grid size
rows = ceil(sqrt(num_channels));  % Adjust rows dynamically
cols = ceil(num_channels / rows); % Adjust columns dynamically

% Plot each channel
figure;
for channel = 1:num_channels
    subplot(rows, cols, channel); % Create subplot
    plot(eeg_signal(channel, :)); % Plot the signal for the current channel
    title(['EEG Channel ' num2str(channel)], 'FontSize', 10); 
    xlabel('Sample Number', 'FontSize', 10); 
    ylabel('Amplitude (μV)', 'FontSize', 10); 
    grid on; 
end

% Add a global title to the figure
sgtitle('EEG Signals for All Channels', 'FontSize', 16);
