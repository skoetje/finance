clear myExchange;
clear myFeedPublisher;
clear myOptionsQuoter;
clear myTradingRobot;

load('ING1.mat');

myExchange = CreateExchangeOpt();

myFeedPublisher = FeedPublisher();
myExchange.RegisterAutoTrader(myFeedPublisher);
myFeedPublisher.StartAutoTrader(myExchange);

myOptionsQuoter = OptionsQuoter();
myExchange.RegisterAutoTrader(myOptionsQuoter);
myOptionsQuoter.StartAutoTrader(myExchange, myFeedPublisher);

myTradingRobot = AnalysisRobot_Strike800();
myExchange.RegisterAutoTrader(myTradingRobot);
myTradingRobot.StartAutoTrader(myExchange);

myFeedPublisher.StartVeryShortFeed(myFeed);

Report(myTradingRobot.ownTrades, 10);