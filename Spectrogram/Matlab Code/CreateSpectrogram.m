function CreateSpectrogram(audioFile)


[audioData, sampleRate] = audioread(audioFile);
% audioData is an Mx2 matrix, with one side being left channel, other
% being the right. For simplicity, we only consider the first channel

mainChannel = audioData(:,1);

%mainChannel = sin(2 * pi * 3 * sort(rand(100000, 1)));
%mainChannel = mainChannel + 2 * sin(2 * pi * 11 * sort(rand(100000, 1)));

time = linspace(0, length(mainChannel)/sampleRate, length(mainChannel));

% Compute fourier series using fft
audioTransform = fft(mainChannel);

% Create the spectrogram
windowMS = 10; % The length of each window portion in MS
overlapMS = windowMS * (1-0.5); % The offset of each window

% Calculate the window length and window difference in terms of samples
windowLength = floor(0.001 * windowMS * sampleRate);
windowDiff = floor(0.001 * overlapMS * sampleRate);

spec = [];

for i = 1:windowDiff:length(audioTransform) - windowLength
    
    % Calculate the fft for the current time window, and weighting the
    % window
    curWindowFrequencies = fft(mainChannel(i:i+windowLength-1,1) .* hann(windowLength));
    finalWindowFrequencies = 2/length(curWindowFrequencies) * abs(curWindowFrequencies(1:floor(length(curWindowFrequencies)/2)));
    
    % Add the frequencies to the spec
    spec(:,end+1) = finalWindowFrequencies;
    
end

% Convert the spec to dB
spec = mag2db(abs(spec));

% Plot the general waveform
figure;
plot(time, mainChannel);

% Plot the fourier transform of the whole wave
figure;
finalValues = mag2db(2/length(audioTransform) * abs(audioTransform(1:length(audioTransform)/2)));
%finalValues = 2/length(audioTransform) * abs(audioTransform(1:length(audioTransform)/2));
plot(linspace(0,length(finalValues),length(finalValues)),finalValues);

% Plot the spectrogram
figure;
imagesc([1,length(mainChannel)/sampleRate],[0,sampleRate/2],spec)
c = colorbar;
c.Ruler.TickLabelFormat = '%g dB';
xlabel('Time (s)');
ylabel('Frequency');
set(gca,'YDir','normal')

end