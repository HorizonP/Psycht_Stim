sca;close all;clearvars;
Screen('Preference', 'VisualDebuglevel', 3);
Screen('Preference', 'SkipSyncTests', 2);
%  Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

screens = Screen('Screens');
screenNumber = max(screens);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 0); % black window
refresh = Screen('GetFlipInterval', window);
white = WhiteIndex(screenNumber);
umTopix=0.3484;

pixSzInReal=20;%um
magnify=pixSzInReal*umTopix;
times=50;
ActualRect=windowRect;
MaxIntensity=white;
level=2;


pixNum=round([ActualRect(4)/magnify ActualRect(3)/magnify]);
lptwrite(57600, 0);
imArrSize=[pixNum(1),pixNum(2)*times]
imArr=MaxIntensity/(level-1)*randi([0,level-1],imArrSize);

vbl = Screen('Flip', window);
for i=1:times
    im=imArr(:,pixNum(2)*(i-1)+1:pixNum(2)*i);
    aTexInd=Screen('MakeTexture',window,im);
    Screen('DrawTexture',window,aTexInd,[],ActualRect,[],0);
    lptwrite(57600, 0);
    vbl = Screen('Flip', window);
    lptwrite(57600, 1);
    WaitSecs(0.1); 
end 
%KbStrokeWait;
lptwrite(57600, 0);
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));
sca; 
