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

ringsR=[0 25; 25 50; 50 100; 100 150; 150 200; 200 250; 250 300; 300 350; 350 400]; % in um, not pixel
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

workParam=[ringsR(:,2)*2,ringsR(:,2)-ringsR(:,1)]*umTopix % [outerDia thickness] in pixel
vbl = Screen('Flip', window);
for i=1:length(workParam)         
    outerDia=workParam(i,1);
    thickness=workParam(i,2);
    Screen('FrameOval', window ,white ,[xCen-0.5*outerDia yCen-0.5*outerDia xCen+0.5*outerDia yCen+0.5*outerDia],thickness);
    [secs, keyCode, deltaSecs]=KbWait;
    if keyCode(41)==1 || keyCode(27)==1     %ESC is pressed
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