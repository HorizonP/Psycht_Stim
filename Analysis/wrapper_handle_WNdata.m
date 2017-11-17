function recep_handle=wrapper_handle_WNdata(D1,D2,detrend_level,sign)
if ~endsWith(D1,'.mat')
    D1=[D1 '.mat'];
end
if ~endsWith(D2,'.mat')
    D2=[D2 '.mat'];
end
try
    stimD=D1;
    resD=D2;
    load(stimD,'mosaicMat','ActualRect','mosaicSzInReal');
    load(resD,'data','datastart','dataend','tickrate');
    chan5_TTL=data(datastart(5):dataend(5));
catch err
    stimD=D2;
    resD=D1;
    load(stimD,'mosaicMat','ActualRect','mosaicSzInReal');
    load(resD,'data','datastart','dataend','tickrate');
    chan5_TTL=data(datastart(5):dataend(5));
end
name=resD(1:end-4);

% mosaicMat=mosaicMat;
% ActualRect=ActualRect;
% mosaicSzInReal=mosaicSzInReal;
% tickrate=tickrate;

%necessary labchart data preprocessing for whitenoise with grey at two ends
%range for analysis is from the onset of 1st TTL to offset to last TTL


chan5_TTL(chan5_TTL<0.5)=0;
chan5_TTL(chan5_TTL>=0.5)=1;

ana_rang=find(chan5_TTL==1,1):find(chan5_TTL==1,1,'last');
chan5=chan5_TTL(ana_rang);

chan2=data(datastart(2):dataend(2));
chan2=chan2(ana_rang);
chan2=detrend(chan2)*10e12;%pA

clear data;

chan2=sign*chan2;
T=(0:length(chan2)-1)/tickrate; %T start from 0
%find all the ascending edge off TTL (indices)
ascendT=find([1 chan5(1:end-1)]==0&chan5==1); %skipped the first TTL block
stimT=[ascendT(1:end-1);ascendT(2:end)-1]'; % (/tickrate) the interval(onset and offset) of each frame in the stimulus set

chan2=chan2-polyval(polyfit(T,chan2,detrend_level),T);
recep_handle=@calculate_recep_and_plot;
    function final=calculate_recep_and_plot(tau,res_interval,frameN)
        final=receptiveField_kernel(mosaicMat,chan2,tickrate,stimT,tau,res_interval,frameN);
        imagesc([ActualRect(1) ActualRect(3)],[ActualRect(4) ActualRect(2)],final)
        axis equal
        title(name,'Interpreter', 'none')
        xlabel({['size of mosaic= ',num2str(mosaicSzInReal),'um'];['tau=',num2str(tau)];['res_interval=',num2str(res_interval)]},'Interpreter', 'none')
    end

%example plot
tau=0.1;
res_interval=0.2;
frameN=1:length(stimT);
final = receptiveField_kernel(mosaicMat,chan2,tickrate,stimT,tau,res_interval,frameN);
imagesc([ActualRect(1) ActualRect(3)],[ActualRect(4) ActualRect(2)],final)
axis equal
title(name,'Interpreter', 'none')
xlabel({['size of mosaic= ',num2str(mosaicSzInReal),'um'];['tau=',num2str(tau)];['res_interval=',num2str(res_interval)]},'Interpreter', 'none')

end
