file = 'init_000.nc';
tEnd=length(ncread('init_000.nc','time'));


[U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0]=getStatesCol('init_000.nc',1,1);

X=[U_0; V_0; T_0; S_0; E_0; windU_0; windV_0; U_b_0; V_b_0; E_b_0];


[U_t_cen,V_t_cen,T_t_cen,S_t_cen,E_t_cen,~,~,~,~,~] = getStatesCol(file,tEnd,1);

Y = [U_t_cen;V_t_cen;T_t_cen;S_t_cen;E_t_cen];


Y = transpose(Y);

Y_fit=[1 transpose(X)]*BETA;




figure(1)
plot([Y;Y_fit]');




xlabel('Predictor, x')
ylabel('Response variable, y')
grid on





