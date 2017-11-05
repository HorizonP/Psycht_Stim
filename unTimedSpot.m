sca;
close all;
clearvars;
lptwrite(57600, 0);

Screen('Preference', 'SkipSyncTests', 2); % to avoid sync failure error
Screen('Preference', 'VisualDebuglevel', 3); 

screens = Screen('Screens');
screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
xCen=880;
yCen=536;
umTopix=0.3484;
r=12.5;%um
spotsDia=2*r*umTopix;

%ifi = Screen('GetFlipInterval', window);

% Retreive the maximum priority number and set max priority
% topPriorityLevel = MaxPriority(window);
% Priority(topPriorityLevel);

% Flip outside of the loop to get a time stamp
vbl0 = Screen('Flip', window);

% Run until a key is pressed
while ~KbCheck

    % Color the screen a random color
    Screen('FillOval', window, white  ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);

    % Flip to the screen
    vbl = Screen('Flip', window);
    
    lptwrite(57600, 1);
end

lptwrite(57600, 0);
time=vbl-vbl0
sca;