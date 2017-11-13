function rece_f=genReceptiveField(mosaicMat,response,tickrate,stimInterval)
%return a function to compute final receptive field by given delay time tau
%The mosaicMat is a 3D(x,y,t) matrix of stimulus, response is from cell's
%recording, the corresponding time of each point is calculated by tickrate.
%stimInterval is a T*2 matrix, ith row is the start and end time of ith
%stimulus.
rece_f=@receptive_fleid;
    function final=receptive_fleid(tau)
        tautick=round(tau*tickrate);
        tmp=size(mosaicMat);
        mosaicNum=tmp(1:2);
        frameN=min([tmp(3) length(stimInterval)]);
        total_Mean=mean(response(stimInterval(1,1)+tautick:stimInterval(frameN,2)+tautick));
<<<<<<< HEAD
            final=zeros(mosaicNum);
            for i=1:frameN
                
                final=final+(mean(response(stimInterval(i,1)+tautick:stimInterval(i,2)+tautick))-total_Mean)*double(mosaicMat(:,:,i));
            end
            final=final/frameN/255*2;
=======
        final=zeros(mosaicNum);
        
        for i=1:frameN

            final=final+(mean(response(stimInterval(i,1)+tautick:stimInterval(i,2)+tautick))-total_Mean)*double(mosaicMat(:,:,i));
        end
        final=final/frameN/255*2;
>>>>>>> a2175040b8072eaa080567315e481e4f2e96b2e4
    end
end