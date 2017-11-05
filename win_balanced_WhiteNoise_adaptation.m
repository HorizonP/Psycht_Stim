%This version features two grey frame at the begining and end of WhiteNoise
sca;close all;clearvars;
Screen('Preference', 'VisualDebuglevel', 3);
Screen('Preference', 'SkipSyncTests', 2);
%  Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white/2); % grey window
ifi = Screen('GetFlipInterval', window);
umTopix=0.3484;
lptwrite(57600, 0);
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

mosaicSzInReal=20;%um
freq=5;%Hz
t=300 ;%s
t_grey=5;%s for intensity adaptation

xCen=880;
yCen=536;
r=150;%pix
ActualRect=[xCen-r,yCen-r,xCen+r,yCen+r];
MaxIntensity=white;

%pre-calculate white noise
waitframes = round(1/(ifi*freq));
times=round(freq*t);
magnify=mosaicSzInReal*umTopix;
mosaicNum=round([ActualRect(4)/magnify ActualRect(3)/magnify]);
mosaicTArr=uint8([zeros(1,times/2),ones(1,times/2)]); 
mosaicMat=zeros([mosaicNum times],'uint8');
%================================


%grey for adaptation
frames_grey = round(t_grey / ifi);
vbl = Screen('Flip', window);
lptwrite(57600, 1);

for i=1:mosaicNum(1)
    for j=1:mosaicNum(2)
        mosaicMat(i,j,:)=255*mosaicTArr(randperm(length(mosaicTArr)));
    end
end

vbl = Screen('Flip', window, vbl + (frames_grey - 0.5) * ifi);
lptwrite(57600, 0);
vbl0=vbl;

logt=[];
% vbl0 = Screen('Flip', window);
% vbl=vbl0;
i=1;
while (~KbCheck)&&(i<=times)
    im=mosaicMat(:,:,i);
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
lptwrite(57600, 1);

logt=logt-vbl0;
% aver=squeeze(sum(sum(mosaicMat/255,2),1))'/prod(mosaicNum); %per frame


Screen('Flip', window, vbl + (frames_grey - 0.5) * ifi);
sca;
lptwrite(57600, 0);


% subplot(2,1,1);plot(logt,logt-[0 logt(1:end-1)]);
% subplot(2,1,2);histogram(aver);

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));

