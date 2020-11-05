function [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getStatesCol(filename,t_sample,run_sample)
%Reading States
U=ncread(filename,'U');

[imax,jmax,kmax,tseries,runs]=size(U);
%%%%%%%%%%%%%%%%%%%%%%%%% x,y,z,time,run %%%%%%%%%%%%%%%%%%%%%%%%%


%%
%states
V=ncread(filename,'V');
W=ncread(filename,'W');
W=W(:,:,:, t_sample,run_sample);
T=ncread(filename,'T');
T=T(:,:,:, t_sample,run_sample);
S=ncread(filename,'S');
S=S(:,:,:, t_sample,run_sample);
E=ncread(filename,'E');
E=E(:,:, t_sample,run_sample);



%%
%Slicing uninitialized values
U=U(1:imax-1,:,:,t_sample, run_sample);
V=V(:,1:jmax-1,:,t_sample,run_sample);

%%
%wind
windU=ncread(filename,'windU');
windV=ncread(filename,'windV');

%Slicing unitialized values
windU=windU(1:imax-1,:,t_sample,run_sample);
windV=windV(:,1:jmax-1,t_sample,run_sample);
%%
%boundary values
U_b=ncread(filename,'U_b');
V_b=ncread(filename,'V_b');
E_b=ncread(filename,'E_b');

[xc_b,kmax,tseries,runs]=size(U_b);
[yc_b,kmax,tseries,runs]=size(V_b);
[ec_b,tseries,runs]=size(E_b);


U_b = U_b(:,:,t_sample,run_sample);
V_b = V_b(:,:,t_sample,run_sample);
E_b = E_b(:,t_sample,run_sample);


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

U_b_0 = reshape(U_b,[xc_b*kmax,1]);
V_b_0 = reshape(V_b,[yc_b*kmax,1]);
E_b_0 = reshape(E_b,[ec_b,1]);




end
