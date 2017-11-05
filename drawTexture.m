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
refresh = Screen('GetFlipInterval', window);

aim=imread('59909649_p0_master1200.jpg');
bim=imread('60929232_p0_master1200.jpg');
aTexInd=Screen('MakeTexture', window, aim);
bTexInd=Screen('MakeTexture', window, bim);


vbl = Screen('Flip', window);
Screen('DrawTexture',window,aTexInd);
Screen('Flip',window); 
WaitSecs(0.01);
Screen('DrawTexture',window,bTexInd);
Screen('Flip',window); 

KbStrokeWait;

sca; 
