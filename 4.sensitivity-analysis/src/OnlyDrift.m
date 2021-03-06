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
muvec=[];
resolution=0.01;
for i=1:200,
    mu=0+i*resolution;
    [A,B]=blsprice(Start,Strike,mu,time,sigma,yield);
    ValueCall(end+1)=A;
    ValuePut(end+1)=B;
    muvec(end+1)=mu;
end
subplot(2,2,1)
plot(muvec,ValueCall,'LineWidth',3)
xlabel('Drift rate per year','FontSize', 15)
ylabel('Call Option value (�)','FontSize', 15)
set(gca,'FontSize',13)

subplot(2,2,2)
plot(muvec,ValuePut,'LineWidth',3)
xlabel('Drift rate per year','FontSize', 15)
ylabel('Put Option value (�)','FontSize', 15)
set(gca,'FontSize',13)

subplot(2,2,3)
plot(muvec(2:end),diff(ValueCall)/resolution,'LineWidth',3)
xlabel('Drift rate per year','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)

subplot(2,2,4)
plot(muvec(2:end),diff(ValuePut)/resolution,'LineWidth',3)
xlabel('Drift rate per year','FontSize', 15)
ylabel('Change Value Call option','FontSize', 15)
set(gca,'FontSize',13)