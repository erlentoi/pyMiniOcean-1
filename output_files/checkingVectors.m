[X_0,Y_1hour] = getInOutOneHour(0);
[X_1hour,Y_2hour] = getInOutOneHour(1);


U_t4 = ncread('init_000.nc','U');
U_t4=U_t4(1:end-1,:,1,4,1);