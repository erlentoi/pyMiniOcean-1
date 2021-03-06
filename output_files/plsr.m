%%initializing
file_0='init_000.nc'; %Antar vi alltid har minst 1 fil
fileVector = [file_0];
file_indx = 0;

tEnd=length(ncread('init_000.nc','time'));


%Lagrer alle filnavn i mappen i en vektor
while isfile("init_" + num2str(file_indx+1,'%03.f') + ".nc")
    file_indx = file_indx + 1;
    fileVector = [fileVector, "init_" + num2str(file_indx,'%03.f') + ".nc"];
end
nRuns = length(ncread("init_000.nc",'run')); %alle filer har samme antall runs

if fileVector == file_0
    nFiles = 1;
else
    nFiles = length(fileVector);
end
%%
%preallocating output and input matrices
U_size = ncinfo('init_000.nc','U').Size([1:3]);
U_size(1) = U_size(1)-1;
V_size = ncinfo('init_000.nc','V').Size([1:3]);
V_size(2) = V_size(2)-1;
T_size = ncinfo('init_000.nc','T').Size([1:3]);
S_size = ncinfo('init_000.nc','S').Size([1:3]);
E_size = ncinfo('init_000.nc','E').Size([1:2]);

windU_size = ncinfo('init_000.nc','windU').Size([1:2]);
windU_size(1) = windU_size(1)-1;
windV_size = ncinfo('init_000.nc','windV').Size([1:2]);
windV_size(2) = windV_size(2)-1;
U_b_size = ncinfo('init_000.nc','U_b').Size([1:2]);
V_b_size = ncinfo('init_000.nc','V_b').Size([1:2]);
E_b_size = ncinfo('init_000.nc','E_b').Size([1]);

nTimeSteps = ncinfo('init_000.nc','time').Size;

NINPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size)...
    +prod(windU_size)+prod(windV_size);%+prod(U_b_size)+prod(V_b_size)+ prod(E_b_size);

NOUTPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size); %number of output variables per run per time sample

X = zeros(nRuns*nFiles, NINPUT);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = zeros(nRuns*nFiles, NOUTPUT); %%%%%%%%%%%%%%%%%% more time steps as outout???? must increase this then
%%
f_indx = 0;
if fileVector == file_0  %done because else matlab treats the vector like a string and iterates over the chars
    file = file_0;  
        for run = 1 : nRuns
            [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,~,~,~] = getStatesCol(file,1,run);
      
            [U_t,V_t,T_t,S_t,E_t,~,~,~,~,~] = getStatesCol(file,tEnd,run); %%%specify time step here
            
            X(run,:) = [U_0; V_0; T_0; S_0; E_0;...
                windU_0; windV_0];
                    
            Y(run,:) =[ U_t;V_t; T_t;S_t; E_t];
           

        end
   
else
    for file = fileVector
        for run = 1 : nRuns

            file
            [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,~,~,~] = getStatesCol(file,1,run);
            
            [U_t,V_t,T_t,S_t,E_t,~,~,~,~,~] = getStatesCol(file,tEnd,run); %%%specify time step here

            X(run + f_indx,:) = [U_0; V_0; T_0; S_0; E_0;...
                windU_0; windV_0];% U_b_0; V_b_0; E_b_0
            
            Y(run + f_indx,:) =[U_t;V_t;T_t;S_t;E_t];
            if run == nRuns%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                f_indx = run+f_indx;
            end

        end

    end
end


%%
% MÅ SENTERES NÅR ALLE VARIABLER HAR BLITT FUNNET FOR ALLE RUNS.
% means og std!!!!!! ta vare på slik at jeg kan skalere tilbake og bruke
% når modellen skal brukes!!


%%
%centering
[X_z,Xmu,Xsigma] = zscore(X);
[Y_z,Ymu,Ysigma] = zscore(Y);

ncomp = 280; %%%%%%%%%ncomp of our new model, with model rank A, with A ≥0 and A ≤ min(K,N − 1)

[XL, YL, XS, YS, BETA, pctvar, mse, stats] = plsregress(X,Y,ncomp);


%%
%plotting

 figure(1)
 plot(1:ncomp,cumsum(pctvar(2,:)),'-bo');
 xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');
 grid on
% 
% figure(2)
% plot(0:ncomp,mse(2,:),'b-o')
% xlabel('Number of components');
% ylabel('Estimated Mean Squared Prediction Error');
% grid on
% 
% 


%Y_fit  = [1 X(10,:)]*BETA;

%Y_simulated = Y(1,:);


%figure(4)
%plot(1:NOUTPUT, Y_fit,'o',1:NOUTPUT,Y_simulated,'*')
%grid on

%Y_diff=Y_fit-Y_simulated;
%
%plotte strømninger: pcolor strømashiget (må velge zlag). hold on quiver for å få
%inn piler(tar inn to felt, u og v)
%tids utvikling: velge dybdgelag og noen få punkter og plotte i tid. evt
%avvik. for å sammenligne felt: kan trekke fra quiver.




