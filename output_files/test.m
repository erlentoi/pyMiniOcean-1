
U_000=ncread('init_000_uten_pert.nc','U');
U_000= U_000(:,:,1,1);

U_000_pert= ncread('init_000.nc','U');
U_000_pert = U_000_pert(:,:,1,1);

U_std= ncread('stateAvgStd.nc','U_std');
U_std = U_std(:,:,1);

%%
E_000=ncread('init_000_uten_pert.nc','E');
E_000= E_000(:,:,1,1);

E_000_pert= ncread('init_000.nc','E');
E_000_pert = E_000_pert(:,:,1,1);

E_std= ncread('stateAvgStd.nc','E_std');
E_std = E_std(:,:,1);

%%
V_000=ncread('init_000_uten_pert.nc','V');
V_000= V_000(:,:,1,1);

V_000_pert= ncread('init_000.nc','V');
V_000_pert = V_000_pert(:,:,1,1);

V_std= ncread('stateAvgStd.nc','V_std');
V_std = V_std(:,:,1);
%%
windU_000=ncread('init_000_uten_pert.nc','windU');
windU_000= windU_000(:,:,1,1);

windU_000_pert= ncread('init_000.nc','windU');
windU_000_pert = windU_000_pert(:,:,1,1);

windU_std= ncread('stateAvgStd.nc','windU_std');
windU_std = windU_std(:,:,1);
%%
windV_000=ncread('init_000_uten_pert.nc','windV');
windV_000= windV_000(:,:,1,1);

windV_000_pert= ncread('init_000.nc','windV');
windV_000_pert = windV_000_pert(:,:,1,1);

windV_std= ncread('stateAvgStd.nc','windV_std');
windV_std = windV_std(:,:,1);







