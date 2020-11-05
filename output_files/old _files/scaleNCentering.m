U_avg = ncread('stateAvgStd.nc','U_avg');
U_std = ncread('stateAvgStd.nc','U_std');

V_avg = ncread('stateAvgStd.nc','V_avg');
V_std = ncread('stateAvgStd.nc','V_avg');

T_avg = ncread('stateAvgStd.nc','T_avg');
T_std = ncread('stateAvgStd.nc','T_avg');

S_avg = ncread('stateAvgStd.nc','S_avg');
S_std = ncread('stateAvgStd.nc','S_avg');

E_avg = ncread('stateAvgStd.nc','E_avg');
E_std = ncread('stateAvgStd.nc','E_avg');

windU_avg = ncread('stateAvgStd.nc','windU_avg');
windU_std = ncread('stateAvgStd.nc','windU_avg');

windV_avg = ncread('stateAvgStd.nc','windV_avg');
windV_std = ncread('stateAvgStd.nc','windV_avg');

U_b_avg = ncread('stateAvgStd.nc','U_b_avg');
U_b_std = ncread('stateAvgStd.nc','U_b_avg');

V_b_avg = ncread('stateAvgStd.nc','V_b_avg');
V_b_std = ncread('stateAvgStd.nc','V_b_avg');

E_b_avg = ncread('stateAvgStd.nc','E_b_avg');
E_b_std = ncread('stateAvgStd.nc','E_b_avg');

[nObs, nVars] = size(X);

[nObs, nOuts] = size(Y);

for obs = 1: nObs
    %for var = 1:nVars
     %   X(obs,var) = 
     X(obs,U_size) =   (X(obs,U_size) - mean(reshape(transpose(U_avg,[]))));
        
        
        
    %end
end