function recep_handle=wrapper_handle_WNdata(resD,stimD,detrend_level,sign)
name=resD(1:end-4);
if ~endsWith(resD,'.mat')
    name=resD;
    resD=[resD '.mat'];

end
if ~endsWith(stimD,'.mat')
    resD=[stimD '.mat'];
end

load(stimD,'mosaicMat','ActualRect','mosaicSzInReal');

load(resD,'data','datastart','dataend','tickrate');
%necessary labchart data preprocessing for whitenoise with grey at two ends
%range for analysis is from the onset of 1st TTL to offset to last TTL

chan5_TTL=data(datastart(5):dataend(5));
chan5_TTL(chan5_TTL<0.5)=0;
chan5_TTL(chan5_TTL>=0.5)=1;

ana_rang=find(chan5_TTL==1,1):find(chan5_TTL==1,1,'last');
chan5=chan5_TTL(ana_rang);

chan2=data(datastart(2):dataend(2));
chan2=chan2(ana_rang);
chan2=detrend(chan2)*10e12;%pA

clear data;

response=sign*response;
T=(0:length(chan2)-1)/tickrate; %T start from 0
%find all the ascending edge off TTL (indices)
ascendT=find([1 chan5(1:end-1)]==0&chan5==1); %skipped the first TTL block
stimT=[ascendT(1:end-1);ascendT(2:end)-1]'; % (/tickrate) the interval(onset and offset) of each frame in the stimulus set

chan2=chan2-polyval(polyfit(T,chan2,detrend_level),T);
recep_handle=@(tau,res_interval,frameN) receptiveField_kernel(mosaicMat,chan2,tickrate,stimT,tau,res_interval,frameN);

%example plot
tau=0.1;
res_interval=0.2;
frameN=1:length(stimT);
final = receptiveField_kernel(mosaicMat,chan2,tickrate,stimT,tau,res_interval,frameN);
imagesc([ActualRect(1) ActualRect(3)],[ActualRect(4) ActualRect(2)],final)
axis equal
title(name,'Interpreter', 'none')
xlabel(['size of mosaic= ',num2str(mosaicSzInReal),'um'])

end
