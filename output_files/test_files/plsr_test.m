

file = 'test_run_different_area.nc';

avg_file='stateAvgStd_different_area.nc';


tEnd=length(ncread(file,'time'));
nRuns = length(ncread(file,'run')); %alle filer har samme antall runs



U_size = ncinfo(file,'U').Size([1:3]);
U_size(1) = U_size(1)-1;
V_size = ncinfo(file,'V').Size([1:3]);
V_size(2) = V_size(2)-1;
T_size = ncinfo(file,'T').Size([1:3]);
S_size = ncinfo(file,'S').Size([1:3]);
E_size = ncinfo(file,'E').Size([1:2]);

windU_size = ncinfo(file,'windU').Size([1:2]);
windU_size(1) = windU_size(1)-1;
windV_size = ncinfo(file,'windV').Size([1:2]);
windV_size(2) = windV_size(2)-1;
U_b_size = ncinfo(file,'U_b').Size([1:2]);
V_b_size = ncinfo(file,'V_b').Size([1:2]);
E_b_size = ncinfo(file,'E_b').Size([1]);

NINPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size)...
    +prod(windU_size)+prod(windV_size)+prod(U_b_size)+prod(V_b_size)+ prod(E_b_size);

NOUTPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size); %number of output variables per run per time sample

X_test = zeros(nRuns, NINPUT);
Y_test = zeros(nRuns, NOUTPUT); %%%%%%%%%%%%%%%%%% more time steps as outout???? must increase this then

U_avg = reshape(permute(ncread(avg_file,'U_avg'),[2 1 3]),[prod(U_size),1]);
U_std = reshape(permute(ncread(avg_file,'U_std'),[2 1 3]),[prod(U_size),1]);

V_avg = reshape(permute(ncread(avg_file,'V_avg'),[2 1 3]), [prod(V_size),1]);
V_std = reshape(permute(ncread(avg_file,'V_std'),[2 1 3]), [prod(V_size),1]);

T_avg = reshape(permute(ncread(avg_file,'T_avg'),[2 1 3]), [prod(T_size),1]);
T_std = reshape(permute(ncread(avg_file,'T_std'),[2 1 3]), [prod(T_size),1]);

S_avg = reshape(permute(ncread(avg_file,'S_avg'),[2 1 3]), [prod(S_size),1]);
S_std = reshape(permute(ncread(avg_file,'S_std'),[2 1 3]), [prod(S_size),1]);

E_avg = reshape(permute(ncread(avg_file,'E_avg'),[2 1 3]), [prod(E_size),1]);
E_std = reshape(permute(ncread(avg_file,'E_std'),[2 1 3]), [prod(E_size),1]);


windU_avg = reshape(permute(ncread(avg_file,'windU_avg'),[2 1]), [prod(windU_size),1]);
windU_std = reshape(permute(ncread(avg_file,'windU_std'),[2 1]), [prod(windU_size),1]);

windV_avg = reshape(permute(ncread(avg_file,'windV_avg'),[2 1]), [prod(windV_size),1]);
windV_std = reshape(permute(ncread(avg_file,'windV_std'),[2 1]), [prod(windV_size),1]);

U_b_avg = reshape(ncread(avg_file,'U_b_avg'),[prod(U_b_size),1]);
U_b_std = reshape(ncread(avg_file,'U_b_std'),[prod(U_b_size),1]);

V_b_avg = reshape( ncread(avg_file,'V_b_avg'),[prod(V_b_size),1]);
V_b_std = reshape(ncread(avg_file,'V_b_std'),[prod(V_b_size),1]);

E_b_avg = ncread(avg_file,'E_b_avg');
E_b_std = ncread(avg_file,'E_b_std');

 for run = 1 : nRuns
     
            [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getInputVars(file,run,1);
            
            U_0_cen = (U_0-U_avg)./U_std;
            V_0_cen = (V_0-V_avg)./V_std;
            
            T_0_cen = (T_0-T_avg)./T_std;
            S_0_cen = (S_0-S_avg)./S_std;
            E_0_cen = (E_0-E_avg)./E_std;
            
            windU_0_cen = (windU_0-windU_avg)./windU_std;
            windV_0_cen = (windV_0-windV_avg)./windV_std;
            
            U_b_0_cen = (U_b_0-U_b_avg)./U_b_std;
            V_b_0_cen = (V_b_0-V_b_avg)./V_b_std;
            E_b_0_cen = (E_b_0-E_b_avg)./E_b_std;
            
            
            [U_t,V_t,T_t,S_t,E_t] = createOutputColVector(file,tEnd,run); %%%specify time step here            
             
            U_t_cen = (U_t-U_avg)./U_std;
            V_t_cen = (V_t-V_avg)./V_std;
            
            T_t_cen = (T_t-T_avg)./T_std;
            S_t_cen = (S_t-S_avg)./S_std;
            E_t_cen = (E_t-E_avg)./E_std;
            
            
            X_test(run,:) = [U_0_cen; V_0_cen; T_0_cen; S_0_cen; E_0_cen;...
                windU_0_cen; windV_0_cen; U_b_0_cen; V_b_0_cen; E_b_0_cen];
            Y_test(run,:) =[U_t;V_t;T_t;S_t;E_t];
          

  end
   


%%

Y_fit  = [1 X_test(1,:)]*BETA;

Y_simulated = Y_test(1,:);


figure(4)
plot(1:NOUTPUT, Y_fit,'o',1:NOUTPUT,Y_simulated,'*')
legend('Y_{fit}','Y_{simulation}')
grid on

Y_diff=Y_fit-Y_simulated;

figure(5)
plot(1:NOUTPUT,Y_diff);
grid on
%
%plotte strømninger: pcolor strømashiget (må velge zlag). hold on quiver for å få
%inn piler(tar inn to felt, u og v)
%tids utvikling: velge dybdgelag og noen få punkter og plotte i tid. evt
%avvik. for å sammenligne felt: kan trekke fra quiver.
%%
length_of_output_vars=[prod(U_size) prod(V_size) prod(T_size) prod(S_size) prod(E_size)]

cum_length = cumsum(length_of_output_vars,2)
