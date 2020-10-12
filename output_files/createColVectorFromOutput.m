function [Y] = createColVectorFromOutput(filename)
U=ncread(filename,'U');
V=ncread(filename,'V');
W=ncread(filename,'W');
T=ncread(filename,'T');
S=ncread(filename,'S');
E=ncread(filename,'E');

[imax,jmax,kmax]=size(U);
%x_0=zeros(imax*jmax*kmax,1);


U_end=reshape(U,[imax*jmax*kmax,1]);
V_end=reshape(V,[imax*jmax*kmax,1]);  
%W_0=rehsape(W,[imax*jmax*kmax,1]);
T_end=reshape(T,[imax*jmax*kmax,1]);
S_end=reshape(S,[imax*jmax*kmax,1]);
E_end=reshape(E,[imax*jmax,1]);

%Hva er X i filen???


%reshape maps my columns:
%    |        |      |       |
%    v        v      v       v
%+-------+-------+-------+---------+
%| (1,1) | (1,2) | (1,3) |   ..    |
%+-------+-------+-------+---------+
%|  (2,1)| (2,2) | (2,3) |   ..    |
%+-------+-------+-------+---------+
%| (3,1) | (3,2) | (3,3) |   ..    |
%+-------+-------+-------+---------+
%|   ..  |  ..   |  ..   |   ..    |
%+-------+-------+-------+---------+

%x_0=[(1,1);(2,1);(3,1)....; (1,2)....]


Y=vertcat(U_end,V_end,T_end,S_end,E_end);
end
