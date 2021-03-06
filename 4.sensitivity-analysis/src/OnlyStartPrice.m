%% Preambule
mu=0.02;
sigma=0.2;
time=82/252;
yield=0;
Strike=12;
Start=11;

%% 1D Plots
ValueCall=[];
ValuePut=[];
Startvec=[];
resolution=0.01;

for i=1:1000,
    Start=8+i*resolution;
    [A,B]=blsprice(Start,Strike,mu,time,sigma,yield);
    ValueCall(end+1)=A;
    ValuePut(end+1)=B;
    Startvec(end+1)=Start;
end
subplot(3,2,1)
hold on
plot(Startvec,ValueCall,'LineWidth',3)
plot([12,12],[0 8],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Call Option value (�)','FontSize', 15)
set(gca,'FontSize',13)

subplot(3,2,2)
hold on
plot(Startvec,ValuePut,'LineWidth',3)
plot([12,12],[0 4],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Put Option value (�)','FontSize', 15)
set(gca,'FontSize',13)

subplot(3,2,3)
hold on
plot(Startvec(2:end),diff(ValueCall)/resolution,'LineWidth',3)
plot([12,12],[0 1],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)

subplot(3,2,4)
hold on
plot(Startvec(2:end),diff(ValuePut)/resolution,'LineWidth',3)
plot([12,12],[-1 0],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)

subplot(3,2,5)
hold on
plot(Startvec,gradient(gradient(ValueCall))/resolution,'LineWidth',3)
plot([12,12],[0 0.003],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)

subplot(3,2,6)
hold on
plot(Startvec,gradient(gradient(ValuePut))/resolution,'LineWidth',3)
plot([12,12],[0 0.003],'LineWidth',3)
hold off
xlabel('Starting Stock Price','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)