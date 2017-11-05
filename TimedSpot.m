%present one spot for a certain interval of time
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
r=300;%um
spotsDia=2*r*umTopix;
flipSecs = 10;

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


Screen('FillOval', window, white  ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
vbl0 = Screen('Flip', window);
lptwrite(57600, 1);
vbl = Screen('Flip', window, vbl0 + (waitframes - 0.5) * ifi); %
lptwrite(57600, 0);


time=vbl-vbl0
sca;

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));