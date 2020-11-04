V_000_r=ncread('init_000.nc','V');
V_000=V_000_r(:,1:end-1,1,:);

V_000_col=reshape(V_000(1,1,:,:),[19,1]);


V_000_meandd = mean(V_000_col);


V_avg_readdd=ncread('stateAvgStd.nc','V_avg');
%%
U_b_000_r=ncread('init_000.nc','U_b');

U_b_000=U_b_000_r(1,2,:,1);

U_b_000_mean=mean(U_b_000);

U_b_avg_read = ncread('stateAvgStd.nc','U_b_avg');


