function LiveFFT(audioFile)

    [audioData, sampleRate] = audioread(audioFile);

    mainChannel = audioData(:,1);

    ap = audioplayer(audioData, sampleRate);
    ap.TimerFcn = @showSeconds;
    ap.TimerPeriod = 0.002;

    playblocking(ap);
        
    function showSeconds(ap, event)
        
        takebackS = 0.05;
        
        if ap.CurrentSample > takebackS * sampleRate + 1 && ap.CurrentSample < length(mainChannel)
            
            audioTransform = fft(mainChannel(ap.CurrentSample-1 - takebackS * sampleRate:ap.CurrentSample-1,1));
            finalValues = 2/length(audioTransform) * abs(audioTransform(1:floor(length(audioTransform)/2)));
            
            clf;
            ylim([-200,0]); hold on;
            xlim([0,sampleRate/2]);
            plot(linspace(0,sampleRate/2,length(finalValues)), mag2db(finalValues));
        end
    end

end