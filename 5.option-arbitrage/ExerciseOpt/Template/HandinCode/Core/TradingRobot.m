classdef TradingRobot < AutoTrader
    properties
        %TradeTimes
        TradeTimes
        DifferencesU
        DifferencesL
        PutBuys
        PutSells
        CallSells
        CallBuys
        StockShifts
        
        %Saving Spots
        SpotHistory
        AskHistory
        BidHistory
        CallDeltaPos
        
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
        Call1000OptionVec
        Call1000OptionVecV
        
        %Savings for plotting
        TotalStock
        DeltaPositionAft
        DeltaPositionBef
        
        StartDeltas
        DeltaConstantG
        Gammas
        myStrikeVec
        
        CallDeltas
        PutDeltas
        CallGammas
        PutGammas
        CallVegas
        PutVegas
    end

    methods
        function HandleDepthUpdate(aBot, ~, aDepth)
            if length(aBot.Time)==0,
                aBot.Time(1)=1;
            end
            TimePoint=aBot.Time(end);  
            aBot.myStrikeVec=[8,9,9.5,9.75,10,10.25,10.5,11,12,14];
            
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
            
            % Storing Stock depths to determine spot changes
            aBot.BidHistory(TimePoint)=NaN;
            if isempty(aBot.StockDepth.bidLimitPrice)==0,
                aBot.BidHistory(TimePoint)=aBot.StockDepth.bidLimitPrice(1);
            end
            
            aBot.AskHistory(TimePoint)=NaN;
            if isempty(aBot.StockDepth.askLimitPrice)==0,
                aBot.AskHistory(TimePoint)=aBot.StockDepth.askLimitPrice(1);
            end
            
            aBot.SpotHistory(TimePoint)=NaN;
            if isempty(aBot.StockDepth.bidLimitPrice)==0 && isempty(aBot.StockDepth.askLimitPrice)==0,
                aBot.SpotHistory(TimePoint)=(aBot.StockDepth.bidLimitPrice(1)+aBot.StockDepth.askLimitPrice(1))/2;
            end
            %myStrikeVector=[8,9,9.5,9.75,10,10.25,10.5,11,12,14];
                        
            
            
            

            % 1) Delta Hedging  
%             aBot.myStrikeVec=[8,9,9.5,9.75,10,10.25,10.5,11,12,14];
%             myInitialAmount=round(1000/length(aBot.myStrikeVec));
%             aBot.DeltaConstantG(TimePoint,:)=zeros(length(aBot.myStrikeVec),1);     
%             for i=1:length(aBot.myStrikeVec),
%                 myStrike=aBot.myStrikeVec(i);
%                 if isempty(OptionDepth(aBot,myStrike,1))==0;
%                     myOptionDepth=OptionDepth(aBot,myStrike,1);
%                     aBot.StartDeltas(TimePoint,i)=DeltaStart(aBot,myStrike,TimePoint,1);
%                     aBot.DeltaConstantG(TimePoint,i)=NaN;
%                     aBot.Gammas(TimePoint,i)=Gamma(aBot,myStrike,TimePoint,1);
% 
%                     if isempty(aBot.StockDepth.bidVolume)==0 && isempty(aBot.StockDepth.askVolume)==0,
%                         if sum(strcmp(aBot.ownTrades.ISIN,myOptionDepth.ISIN))==0 && length(aBot.ownTrades.price)<=16,
%                             StartHedge2(aBot,TimePoint,myStrike,myInitialAmount,1)
%                         end
%                     end
%                 end
%             end
%             aBot.DeltaPositionBef(TimePoint)=0;
%             aBot.DeltaPositionAft(TimePoint)=0;
%             if isempty(aBot.StockDepth.bidVolume)==0 && isempty(aBot.StockDepth.askVolume)==0,
%                 if length(aBot.ownTrades.price)>16,
%                     for i=1:length(aBot.myStrikeVec),
%                         myStrike=aBot.myStrikeVec(i);
%                         aBot.DeltaConstantG(TimePoint,i)=Delta_CGamma(aBot,myStrike,1);
%                     end
%                     aBot.DeltaPositionBef(TimePoint)=DeltaPosition(aBot,aBot.myStrikeVec);
%                     RehedgerStocks2(aBot,TimePoint,aBot.myStrikeVec);
%                     aBot.DeltaPositionAft(TimePoint)=DeltaPosition(aBot,aBot.myStrikeVec);
%                 end
%             end
%             
%             for i=1:10
%                 myStrike=myStrikeVector(i);
%                 aBot.CallDeltas(TimePoint,i)=DeltaStart(aBot,myStrike,TimePoint,1);
%                 aBot.CallGammas(TimePoint,i)=Gamma(aBot,myStrike,TimePoint,1);
%                 aBot.CallVegas(TimePoint,i)=Vega_disc(aBot,myStrike,TimePoint,1);
%                 aBot.PutDeltas(TimePoint,i)=DeltaStart(aBot,myStrike,TimePoint,0);
%                 aBot.PutGammas(TimePoint,i)=Gamma(aBot,myStrike,TimePoint,0);
%                 aBot.PutVegas(TimePoint,i)=Vega_disc(aBot,myStrike,TimePoint,0);
%             end


            % 2) Call-Put Parity, 3) Unwinding
            for i=1:length(aBot.myStrikeVec),
                myStrike=aBot.myStrikeVec(i);
                CallPut(aBot,myStrike);
                Unwind(aBot,myStrike,TimePoint);
            end
            
            
            
            
            % End
            aBot.Time(length(aBot.Time)+1)=length(aBot.Time)+2;
            if sum(TimePoint/100 == linspace(0,100000,100001))==1,
                TimePoint
            end
        end
    end
end
