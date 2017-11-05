sca;close all;clearvars;
Screen('Preference', 'VisualDebuglevel', 3);
Screen('Preference', 'SkipSyncTests', 2);
screens = Screen('Screens');
screenNumber = max(screens);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 0); % black window
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); 


outerDiameter=150;
thickness=25;
spotsDia=outerDiameter-thickness*2;
xCen=880;
yCen=536;
%RectCenter(windowRect)


sin_hz=@(a) (sin(2*pi*a*(0:3/a*60-1)/60-pi/2)+1)/2;
intensity=cell2mat([arrayfun(sin_hz,2:2:10,'UniformOutput',false) arrayfun(sin_hz,10:-2:2,'UniformOutput',false) 0]);
intensity=255*intensity;
%TTL=islocalmax(intensity);
[~,ind]=findpeaks(intensity);TTL=zeros([1,length(intensity)]);TTL(ind)=1;
TTL(1:3)=1;
vbl0 = Screen('Flip', window);
t=[];
lptwrite(57600, 0);
bts=1;
for i=intensity
    lptwrite(57600, 0);
    Screen('FrameOval', window ,255-i,[xCen-0.5*outerDiameter yCen-0.5*outerDiameter xCen+0.5*outerDiameter yCen+0.5*outerDiameter] ,thickness);
    Screen('FillOval', window, i,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    lptwrite(57600, TTL(bts));
    vbl = Screen('Flip', window);
    %logt=[logt tmp-vbl];
    t=[t vbl-vbl0];
    bts=bts+1;
%     WaitSecs(0.2);  
end 

%KbStrokeWait;
lptwrite(57600, 0);
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));
subplot(2,1,1);
plot(t,intensity);
subplot(2,1,2);
plot(t,TTL);
sca; 
