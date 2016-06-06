classdef TradingRobot < AutoTrader
    properties
        %Depths to be loaded in
        StockDepth
        
        Call800Depth
        Call900Depth
        Call950Depth
        Call975Depth
        Call1000Depth
        Call1025Depth
        Call1050Depth
        Call1100Depth
        Call1200Depth
        Call1400Depth
        
        Put800Depth
        Put900Depth
        Put950Depth
        Put975Depth
        Put1000Depth
        Put1025Depth
        Put1050Depth
        Put1100Depth
        Put1200Depth
        Put1400Depth
        
        %Time for the unwind function
        Time
        
        %Savings for plotting
        TotalStock
        CallDeltaVec
        PutDeltaVec
        CallGammaVec
        PutGammaVec
    end

    methods
        function HandleDepthUpdate(aBot, ~, aDepth)
            aBot.Time(length(aBot.Time)+1)=length(aBot.Time)+1;
            TimePoint=aBot.Time(end);
            %Switch between whether the depth concerns option or stock
            switch aDepth.ISIN
                case 'ING'; aBot.StockDepth = aDepth;
                case 'ING20160916PUT800'; aBot.Put800Depth = aDepth;
                case 'ING20160916CALL800'; aBot.Call800Depth = aDepth;
                case 'ING20160916PUT900'; aBot.Put900Depth = aDepth;
                case 'ING20160916CALL900'; aBot.Call900Depth = aDepth;
                case 'ING20160916PUT950'; aBot.Put950Depth = aDepth;
                case 'ING20160916CALL950'; aBot.Call950Depth = aDepth;
                case 'ING20160916PUT975'; aBot.Put975Depth = aDepth;
                case 'ING20160916CALL975'; aBot.Call975Depth = aDepth;
                case 'ING20160916PUT1000'; aBot.Put1000Depth = aDepth;
                case 'ING20160916CALL1000'; aBot.Call1000Depth = aDepth;
                case 'ING20160916PUT1025'; aBot.Put1025Depth = aDepth;
                case 'ING20160916CALL1025'; aBot.Call1025Depth = aDepth;
                case 'ING20160916PUT1050'; aBot.Put1050Depth = aDepth;
                case 'ING20160916CALL1050'; aBot.Call1050Depth = aDepth;
                case 'ING20160916PUT1100'; aBot.Put1100Depth = aDepth;
                case 'ING20160916CALL1100'; aBot.Call1100Depth = aDepth;
                case 'ING20160916PUT1200'; aBot.Put1200Depth = aDepth;
                case 'ING20160916CALL1200'; aBot.Call1200Depth = aDepth;
                case 'ING20160916PUT1400'; aBot.Put1400Depth = aDepth;
                case 'ING20160916CALL1400'; aBot.Call1400Depth = aDepth;
            end
            
            CallPutParityCheck(aBot);
            aBot.CallDeltaVec(TimePoint)=Delta(aBot,10,TimePoint,1);
            aBot.PutDeltaVec(TimePoint)=Delta(aBot,10,TimePoint,0);
            aBot.CallGammaVec(TimePoint)=Gamma(aBot,10,TimePoint,1);
            aBot.PutGammaVec(TimePoint)=Gamma(aBot,10,TimePoint,0);
            %TryArbitrage(aBot);
            %aBot.DeltaHedge();
            %aBot.GammaHedge();
            %aBot.VegaHedge();
            %aBot.Unwind();
        end
    end
end