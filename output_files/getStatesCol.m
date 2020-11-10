function [U,V,T,S,E,windU,windV,U_b,V_b,E_b] = getCenteredStatesCol(filename,t_sample,run_sample)
%Reading States
U=ncread(filename,'U');
[imax,jmax,kmax,tseries,runs]=size(U);

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

U=reshape(U,[(imax-1)*jmax*kmax,1]); 
V=reshape(V,[imax*(jmax-1)*kmax,1]);
%W_0=rehsape(W,[imax*jmax*kmax,1]);
T=reshape(T,[imax*jmax*kmax,1]);
S=reshape(S,[imax*jmax*kmax,1]);
E=reshape(E,[imax*jmax,1]);

windU=reshape(windU,[(imax-1)*jmax,1]);
windV=reshape(windV,[imax*(jmax-1),1]);

U_b = reshape(U_b,[xc_b*kmax,1]);
V_b = reshape(V_b,[yc_b*kmax,1]);
E_b = reshape(E_b,[ec_b,1]);




end
