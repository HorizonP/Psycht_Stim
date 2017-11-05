% Clear the workspace and the screen
sca;
close all;
clearvars;

Screen('Preference', 'VisualDebuglevel', 3);
Screen('Preference', 'SkipSyncTests', 2);
%  Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

screens = Screen('Screens');
screenNumber = max(screens);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 0); % black window



vbl = Screen('Flip', window);
for i=1:5:255
    dotColor=i;
    Screen('DrawDots', window, [720 450], 20, dotColor, [], 2);
    vbl = Screen('Flip', window);
    WaitSecs(0.2);  
end; 
KbStrokeWait;

sca; 
