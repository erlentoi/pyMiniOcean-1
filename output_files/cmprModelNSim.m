[X_0t,Y_0t] = getInOutOneHour(0); %time 0 - hour 1


[X_1t,Y_1t] = getInOutOneHour(1); %hour 1-2


%[X_2,Y_2] = getInOutOneHour(2); %hour 2-3

%ncomp = 12;



%[XL_0, YL_0, XS_0, YS_0, BETA_0, pcctvar_0, mse_0, stats_0] = plsregress(X_0,Y_0,ncomp);







%[XL_1, YL_1, XS_1, YS_1, BETA_1, pctvar_1, mse_1, stats_1] = plsregress(X_1,Y_1,ncomp);

%[XL_2, YL_2, XS_2, YS_2, BETA_2, pctvar_2, mse_2, stats_2] = plsregress(X_2,Y_2,ncomp);
