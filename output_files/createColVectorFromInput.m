function [x_0] = createColVectorFromInput(filename)
%Reading States
U=ncread(filename,'U');

[imax,jmax,kmax,tseries,runs]=size(U);

%%
%states
V=ncread(filename,'V');
W=ncread(filename,'W');
T=ncread(filename,'T');
S=ncread(filename,'S');
E=ncread(filename,'E');


U=U(1:imax-1,:,:);   %%%%%%%TIDSPUNKT? RUNS? Hva er input og output? initalverdier?????
V=V(:,1:jmax-1,:);

%%
%wind
windU=ncread(filename,'windU');
windV=ncread(filename,'windV');
windU=windU(1:imax-1,:);
windV=windV(:,1:jmax-1);
%%
%boundary values
U_b=ncread(filename,'U_b');
V_b=ncread(filename,'V_b');
E_b=ncread(filename,'E_b');


%%
%Shaping into column vectors

U_0=reshape(U,[(imax-1)*jmax*kmax,1]); 
V_0=reshape(V,[imax*(jmax-1)*kmax,1]);
%W_0=rehsape(W,[imax*jmax*kmax,1]);
T_0=reshape(T,[imax*jmax*kmax,1]);
S_0=reshape(S,[imax*jmax*kmax,1]);
E_0=reshape(E,[imax*jmax,1]);

windU_0=reshape(windU,[(imax-1)*jmax,1]);
windV_0=reshape(windV,[imax*(jmax-1),1]);

U_b_0= reshape(



%reshape maps my columns:
%    |        |      |       |
%    v        v      v       v
%+-------+-------+-------+---------+
%| (1,1) | (1,2) | (1,3) |   ..    |
%+-------+-------+-------+---------+
%| (2,1) | (2,2) | (2,3) |   ..    |
%+-------+-------+-------+---------+
%| (3,1) | (3,2) | (3,3) |   ..    |
%+-------+-------+-------+---------+
%|   ..  |  ..   |  ..   |   ..    |
%+-------+-------+-------+---------+

%x_0=[(1,1);(2,1);(3,1)....; (1,2)....]



%%%external input (wind, rivers etc)

x_0=vertcat(U_0,V_0,T_0,S_0,E_0,windU_0,windV_0);

end
