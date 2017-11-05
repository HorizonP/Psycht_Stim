%generate whitenoise by certain frequency and interval
sca;close all;clearvars;
Screen('Preference', 'VisualDebuglevel', 3);
Screen('Preference', 'SkipSyncTests', 2);
%  Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
screens = Screen('Screens');
screenNumber = max(screens);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 0); % black window
ifi = Screen('GetFlipInterval', window);
white = WhiteIndex(screenNumber);
umTopix=0.3484;

pixSzInReal=30;%um
freq=5;%Hz
t=1 ;%s

ActualRect=windowRect;
MaxIntensity=white;
level=2;

waitframes = round(1/(ifi*freq));
times=freq*t;
magnify=pixSzInReal*umTopix;
pixNum=round([ActualRect(4)/magnify ActualRect(3)/magnify]);
lptwrite(57600, 0);
imArrSize=[pixNum(1),pixNum(2)*times]
imArr=MaxIntensity/(level-1)*randi([0,level-1],imArrSize); %pre-calculate white noise

topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

logt=[];
vbl0 = Screen('Flip', window);
vbl=vbl0;
i=1;
while (~KbCheck)&&(i<=times)
    im=imArr(:,pixNum(2)*(i-1)+1:pixNum(2)*i);
    aTexInd=Screen('MakeTexture',window,im);
    Screen('DrawTexture',window,aTexInd,[],ActualRect,[],0);
    lptwrite(57600, 0);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    lptwrite(57600, 1);
    logt=[logt vbl];
    i=i+1;
end
lptwrite(57600, 0);
Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

sca;


logt=logt-vbl0;
tmp=mat2cell(imArr,[imArrSize(1)],ones([1,times])*imArrSize(2)/times);
aver=cellfun(@mean2,tmp)/MaxIntensity;

subplot(2,1,1);plot(logt,logt-[0 logt(1:end-1)]);
subplot(2,1,2);histogram(aver);

[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));

