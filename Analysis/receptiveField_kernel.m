function final = receptiveField_kernel(mosaicMat,response,tickrate,stimInterval,tau,res_interval,frameN)
%return a computed receptive field at given delay tau
% mosaicMat(X,Y,T) : stimulus
% response(T) : sampled at 'tickrate' frequency
% stimInterval(N)' : column vector or Nx2 matrix, 1st column is onset time
% tau : the delay between stimulus and response
% res_interval : the length of a period of recording started from stimInterval(i,1) to serve as one response point
% frameN : the range of stimulus for calculate receptive field

%frameN=1:length(stimInterval);
mosaicNum=size(mosaicMat);
mosaicNum=mosaicNum(1:2);

tautick=round(tau*tickrate);
res_inter_tick=round(res_interval*tickrate);

%construct W vector
W=mean(response(tautick+stimInterval(frameN,1)+(0:res_inter_tick)),2);
W=W';

%select stimulus for calculation receptive field
mosaicM=reshape(mosaicMat,prod(mosaicNum),[]);
mosaicM=mosaicM(:,frameN);
mosaicM=double(mosaicM');

spatial_recep=W*mosaicM;

final=(reshape(spatial_recep,mosaicNum)-mean(W)*reshape(sum(mosaicM,1),mosaicNum))/length(frameN)/255*2; %normalization

end

