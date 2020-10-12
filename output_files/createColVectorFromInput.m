function [x_0] = createColVectorFromInput(filename)
%Reading States
U=ncread(filename,'U');

[imax,jmax,kmax]=size(U);


V=ncread(filename,'V');
W=ncread(filename,'W');
T=ncread(filename,'T');
S=ncread(filename,'S');
E=ncread(filename,'E');


U=U(1:imax-1,:,:);   % 
V=V(:,1:jmax-1,:);
%U(:,:,1)
%V(:,:,1)

%%%boundary values
windU=ncread(filename,'windU');
windV=ncread(filename,'windV');
windU=windU(1:imax-1,:);
windV=windV(:,1:jmax-1);

windU
windV
%x_0=zeros(imax*jmax*kmax,1);


U_0=reshape(U,[(imax-1)*jmax*kmax,1]); %%%%%boundary values???????
V_0=reshape(V,[imax*(jmax-1)*kmax,1]);   %%%%%boundary values???????
%W_0=rehsape(W,[imax*jmax*kmax,1]);
T_0=reshape(T,[imax*jmax*kmax,1]);
S_0=reshape(S,[imax*jmax*kmax,1]);
E_0=reshape(E,[imax*jmax,1]);

windU_0=reshape(windU,[(imax-1)*jmax,1]);
windV_0=reshape(windV,[imax*(jmax-1),1]);



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
