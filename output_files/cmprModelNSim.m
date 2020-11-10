%%
%Creating a model for from input_0 to output_1hour and comparing with
%output in hour2

ncomp=55;
[X_0,Y_1hour] = getInOutOneHour(0); %time 0 - hour 1

%centering
[X_0,X_0_mu,X_0_sigma] = zscore(X_0);
%[Y_0,Ymu,Ysigma] = zscore(Y_0);

[XL_0, YL_0, XS_0, YS_0, BETA_0, pcctvar_0, mse_0, stats_0] = plsregress(X_0,Y_1hour,ncomp);

[X_1hour,Y_2hour] = getInOutOneHour(1); %hour 1-2

%Standardizing X_1hour before testing the model
X_1hour_stand = (X_1hour-X_0_mu)./X_0_sigma;

Y_2hour_fit = [ones(size(X_1hour_stand,1),1) X_1hour_stand]*BETA_0;

%%
figure(1)
plot(1:1240,Y_2hour,'o',1:1240,Y_2hour_fit,'*')%%%%%%%%%
legend('Model output hour 2','Fitted output hour 2');
xlabel('Predictor, x')
ylabel('Response variable, y')
grid on

% %%
% %Creating a model for from input_1hour to output_2hour and comparing with
% %output_hour3
% 
% [X_1hour,X_1_mu,X_1_sigma] = zscore(X_1hour);
% 
% [XL_1, YL_1, XS_1, YS_1, BETA_1, pcctvar_1, mse_1, stats_1] = plsregress(X_1hour,Y_2hour,ncomp);
% 
% [X_2hour,Y_3hour] = getInOutOneHour(2); %hour 2-3
% 
% 
% %Standardizing X_2hour before testing the model
% X_2hour_stand = (X_2hour-X_1_mu)./X_1_sigma;
% 
% 
% Y_3hour_fit = [ones(size(X_2hour_stand,1),1) X_2hour_stand]*BETA_1;
% 
% 
% figure(2)
% plot([Y_3hour;Y_3hour_fit]')%%%%%%%%%
% xlabel('Predictor, x')
% ylabel('Response variable, y')
% grid on


%ncomp = 12;



%[XL_0, YL_0, XS_0, YS_0, BETA_0, pcctvar_0, mse_0, stats_0] = plsregress(X_0,Y_0,ncomp);


%[XL_1, YL_1, XS_1, YS_1, BETA_1, pctvar_1, mse_1, stats_1] = plsregress(X_1,Y_1,ncomp);

%[XL_2, YL_2, XS_2, YS_2, BETA_2, pctvar_2, mse_2, stats_2] = plsregress(X_2,Y_2,ncomp);



%
%plotte strømninger: pcolor strømashiget (må velge zlag). hold on quiver for å få
%inn piler(tar inn to felt, u og v)
%tids utvikling: velge dybdgelag og noen få punkter og plotte i tid. evt
%avvik. for å sammenligne felt: kan trekke fra quiver.

