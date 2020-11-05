

file= 'init_000.nc';

[U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getStatesCol(file,1,1);


[U_t,V_t,T_t,S_t,E_t] =get(file,1,1); %%%specify time step here            


V_read=ncread('init_000.nc','V');
V_read_sliced=V_read(:,1:end-1,:,1,1);
