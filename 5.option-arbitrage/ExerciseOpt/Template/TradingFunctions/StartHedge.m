function StartHedge(aBot,aTime)
%First consider only strikes of 10
myStrike=10;
myExpiry=((169000-aTime)+3600*24*daysact('10-jun-2016',  '16-sep-2016'))/(3600*24*252);
myCallDelta=Delta3(aBot,myStrike,aTime,1);
myPutDelta=Delta3(aBot,myStrike,aTime,1);
CountPut=0;

if isempty(aBot.StockDepth)==0,
    %Buy call options and sell stock
    if isempty(aBot.Call1000Depth)==0 && isempty(aBot.StockDepth.bidVolume)==0,
        if isempty(aBot.Call1000Depth.askVolume)==0,
            myBidStockV=aBot.StockDepth.bidVolume(1);
            myBidStockP=aBot.StockDepth.bidLimitPrice(1);
            myPreOptionAmount=aBot.Call1000Depth.askVolume(1);
            if round(myBidStockV/myCallDelta)<=myPreOptionAmount && myBidStockV>0 && myPreOptionAmount>=round(myBidStockV/myCallDelta),
                
                %Calculate how many call options we should buy
                myOptionAmount=round(myBidStockV/myCallDelta);
                myOptionPrice=aBot.Call1000Depth.askLimitPrice;

                %Send buy/sell orders
                if myBidStockP>mean(aBot.BidHistory(1:end))+std(aBot.BidHistory(1:end)) && myOptionPrice<10.0,
                    aBot.Call1000Depth.askVolume = aBot.Call1000Depth.askVolume  - myOptionAmount;
                    aBot.SendNewOrder(myOptionPrice, myOptionAmount,  1, {aBot.Call1000Depth.ISIN}, {'IMMEDIATE'}, aTime);

                    aBot.StockDepth.bidVolume(1) = aBot.StockDepth.bidVolume(1) - myBidStockV;
                    aBot.SendNewOrder(myBidStockP, myBidStockV,  -1, {'ING'}, {'IMMEDIATE'}, aTime);
                end
                
%             elseif round(myBidStockV/myCallDelta)>myPreOptionAmount,
%                 myBidStockVNew=round(myPreOptionAmount*myCallDelta);
%                 
%                 %Calculate how many call options we should buy
%                 myOptionAmount=myPreOptionAmount;
%                 myOptionPrice=aBot.Call1000Depth.askLimitPrice(1);
% 
%                 %Send buy/sell orders
%                 aBot.Call1000Depth.askVolume = aBot.Call1000Depth.askVolume  - myOptionAmount;
%                 aBot.SendNewOrder(myOptionPrice, myOptionAmount,  1, {aBot.Call1000Depth.ISIN}, {'IMMEDIATE'}, 3);
% 
%                 aBot.StockDepth.bidVolume(1) = aBot.StockDepth.bidVolume(1) - myBidStockVNew;
%                 aBot.SendNewOrder(myBidStockP, myBidStockVNew,  -1, {'ING'}, {'IMMEDIATE'}, 4);
            end
        end
    end
end

