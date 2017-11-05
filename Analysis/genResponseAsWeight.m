function res=genResponseAsWeight(ana_chan2,tickrate,stimInterval)
res=@weights;
    function wL=weights(tau)
        frameN=length(stimInterval);
        tautick=round(tau*tickrate);
        totalMean=mean(ana_chan2(stimInterval(1,1)+tautick:stimInterval(end,2)+tautick));
            wL=[];
            for i=1:frameN
                wL=[wL mean(ana_chan2(stimInterval(i,1)+tautick:stimInterval(i,2)+tautick))-totalMean];
            end
    end
end