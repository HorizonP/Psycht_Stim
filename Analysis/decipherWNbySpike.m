function decipherWNbySpike(labchartData,stimData,reverse_chan2)    
load(labchartData,'data','datastart','dataend','tickrate');
response=detrend(data(datastart(2):dataend(2)))*10e10;
chan3_spk=zeros(1,length(response)); % chan3_spk=data(datastart(3):dataend(3));
chan5_TTL=data(datastart(5):dataend(5));
clear data;
%%
%labChart data pre-processing
if ~isempty(reverse_chan2)
    response=-response;
end
T=(0:length(response)-1)/tickrate;
chan5_TTL(chan5_TTL<0.5)=0; chan5_TTL(chan5_TTL>=0.5)=1;
%%
%view of labChart data
figure
plot(T,response);
%%
[pks_posi,locs_posi,w_posi,p_posi]=findpeaks(response,'MinPeakProminence',2,'MinPeakDistance',5e-3/tickrate,'MinPeakHeight',0);
[pks_nega,locs_nega,w_nega,p_nega]=findpeaks(-response,'MinPeakProminence',2,'MinPeakDistance',5e-3/tickrate,'MinPeakHeight',0.5);
chan3_spk(locs_posi)=1;
chan3_spk(locs_nega)=1;
%%
load(stimData,'imArr','imArrSize','logt','pixNum','pixSzInReal','t_grey','ActualRect');
stim=mat2cell(imArr,[pixNum(1)],[ones([1,imArrSize(2)/pixNum(2)])*pixNum(2)]); %split stimulus into frame(cell) 
%%
%to frame the analysis range
ana_rang=find(chan5_TTL==1,1):find(chan5_TTL==1,1,'last'); %range for analysis is from the onset of 1st grey to offset to 2nd grey
ana_T=T(ana_rang);
ana_chan2=response(ana_rang);
ana_spk=logical(chan3_spk(ana_rang));
ana_TTL=chan5_TTL(ana_rang);
C=ana_chan2(ana_spk); %define the weight of each spike as the hight of spike
C=interp1([min(C),max(C)],[0,1],C); %mapping C to the new range of [0,1]
spkT=T(ana_spk); %relative to ana_rang
%%
ascendT=find([1 ana_TTL(1:end-1)]==0&ana_TTL==1); %find all the ascending edge off TTL (indices)
stimT=[ascendT(1:end-1);ascendT(2:end)]'/tickrate; %the onset time of each frame in the stimulus set
%%
% figure
% plot(spkT,C,ana_T-ana_T(1),ana_chan2)
%%
%tau=0.1; %the delay of response relavant to stimulus
 
%sArrInd is coresponding to C
    
arrayfun(@compute_final,[-0.1:0.02:0.4],'UniformOutput',false)

        
%%
brightP=[128 78];
ran_x=round([brightP(1)-1 brightP(1)]/pixNum(2)*(ActualRect(4)-ActualRect(2)));
ran_y=round([brightP(2)-1 brightP(2)]/pixNum(1)*(ActualRect(3)-ActualRect(1)));
%%
    function final=compute_final(tau)
        sArrInd=arrayfun(@(t) find(stimT(:,1)<=t&stimT(:,2)>t),spkT-tau,'UniformOutput',false); %coresponding stimulus of the ith spike
        final=zeros(pixNum);
        n=0;
        for i=1:length(sArrInd)
            if ~isempty(sArrInd{i})
                n=n+1;
                final=final+C(i)^2*stim{sArrInd{i}};
            end
        end
        final=final/n;
        figure
        imshow(final,[min(min(final)) max(max(final))],'InitialMagnification',300)
    end
end