% Clear the workspace and the screen
sca;
close all;
clearvars;

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



x=1:1000;
x=2*(0.05*x).^1.6;
intensity=255*(sin(x)+1)/2;
%TTL=islocalmax(intensity);
[~,ind]=findpeaks(intensity);TTL=zeros([1,length(intensity)]);TTL(ind)=1;
vbl0 = Screen('Flip', window);
t=[];
lptwrite(57600, 0);
bts=1;
for i=intensity
    Screen('FrameOval', window ,255-i,[xCen-0.5*outerDiameter yCen-0.5*outerDiameter xCen+0.5*outerDiameter yCen+0.5*outerDiameter] ,thickness);
    Screen('FillOval', window, i,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    lptwrite(57600, 0);
    vbl = Screen('Flip', window);
    %logt=[logt tmp-vbl];
    t=[t vbl-vbl0];
    lptwrite(57600, TTL(bts));
    bts=bts+1;
%   WaitSecs(0.2);  
end; 

%KbStrokeWait;
lptwrite(57600, 0);
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));
subplot(2,1,1);
plot(t,intensity);
subplot(2,1,2);
plot(t,x./(2*pi*t));

sca; 
