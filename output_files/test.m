
U_000=ncread('init_000.nc','U');
U_000= U_000(1:end-1,:,:,:);


U_000_1_1=U_000(1,1,:,:);

U_000_1_1 = reshape(U_000_1_1, [38,1]);

m= mean(U_000_1_1);

U_avg_read=ncread('stateAvgStd.nc', 'U_avg');

