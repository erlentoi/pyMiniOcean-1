
T_000=ncread('init_000_test.nc','E');
T_000= T_000(:,:,1,1);

%E_000_pert=ncread('init_000.nc','E');

%E_000_pert= E_000_pert(:,:,1);

T_std_read = ncread('stateAvgStd.nc','T_std');







