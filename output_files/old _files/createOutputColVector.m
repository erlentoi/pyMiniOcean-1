function [U_t,V_t,T_t,S_t,E_t] = createOutputColVector(filename,t_sample,run_sample)
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
%Shaping into column vectors

U_t=reshape(U,[(imax-1)*jmax*kmax,1]); 
V_t=reshape(V,[imax*(jmax-1)*kmax,1]);
%W_0=rehsape(W,[imax*jmax*kmax,1]);
T_t=reshape(T,[imax*jmax*kmax,1]);
S_t=reshape(S,[imax*jmax*kmax,1]);
E_t=reshape(E,[imax*jmax,1]);

%reshape maps by columns:
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



%skalering av data . hver varaibel må sentreres rundt 0 kanskje for å være
%sammenlignbare. gjsnitt og std avvik av hver var, deretter sentrere. 

end
