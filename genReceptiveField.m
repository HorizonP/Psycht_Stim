function rece_f=genReceptiveField(mosaicMat,ana_chan2,tickrate,stimInterval)
rece_f=@receptive_fleid;
    function final=receptive_fleid(tau)
        tmp=size(mosaicMat);
        mosaicNum=tmp(1:2);
        frameN=tmp(3);
            final=zeros(mosaicNum);
            for i=1:frameN
                tautick=round(tau*tickrate);
                final=final+mean(ana_chan2(stimInterval(i,1)+tautick:stimInterval(i,2)+tautick))*double(mosaicMat(:,:,i));
            end
            final=final/frameN/mean(ana_chan2(stimInterval(1,1)+tautick:stimInterval(end,2)+tautick))/255*2;
    end
end