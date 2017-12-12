sca; close all; clearvars;
Screen('Preference', 'SkipSyncTests', 2); % to avoid sync failure error
Screen('Preference', 'VisualDebuglevel', 3); 
screens = Screen('Screens');
screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[xCen,yCen]=retCenter();
umTopix=0.3484;

spotsR=[12.5 25 50 100 150 300 600]; % in um, not pixel
spotsDiaPix=spotsR*2*umTopix; % in pixel
flipSecs = 1;

lptwrite(57600, 0);

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);
% Retreive the maximum priority number and set max priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
% Here we use to a waitframes number greater then 1 to flip at a rate not
% equal to the monitors refreash rate. For this example, once per second,
% to the nearest frame
waitframes = round(flipSecs / ifi);


i=1;
vbl = Screen('Flip', window);
for i=1:length(spotsDiaPix)         
    spotsDia=spotsDiaPix(i);
    Screen('FillOval', window, white ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    [secs, keyCode, deltaSecs]=KbWait;
    if keyCode(41)==1 || keyCode(27)==1 %ESC is pressed
        break
    else
        vbl = Screen('Flip', window);
        lptwrite(57600, 1);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); %
        lptwrite(57600, 0);
        i=i+1;
    end
end

% time=vbl-vbl
sca;

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));