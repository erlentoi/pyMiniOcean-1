

file= 'init_000.nc';

[U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getStatesCol(file,1,1);

U_avg=ncread('stateAvgStd.nc','U_avg');

U_std=ncread('stateAvgStd.nc','U_std');


ggggg=(U_0(2)-U_avg(1,2,1))/U_std(1,2,1);