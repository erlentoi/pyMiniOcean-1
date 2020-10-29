file_0='init_000.nc'; %Antar vi alltid har minst 1 fil
fileVector = [file_0];
file_indx = 0;


%Lagrer alle filnavn i mappen i en vektor
while isfile("init_" + num2str(file_indx+1,'%03.f') + ".nc")
    file_indx = file_indx + 1;
    fileVector = [fileVector, "init_" + num2str(file_indx,'%03.f') + ".nc"];
end

nRuns = length(ncread("init_000.nc",'run')); %alle filer har samme antall runs
if fileVector == file_0
    nFiles = 1;
end

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
%ignoring boundary values for now???

NINPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size)...
    +prod(windU_size)+prod(windV_size)+prod(U_b_size)+prod(V_b_size)+ prod(E_b_size);

NOUTPUT = prod(U_size)+prod(V_size)+prod(T_size)+prod(S_size)+prod(E_size); %number of output variables per run per time sample

X = zeros(nRuns*nFiles, NINPUT);
Y = zeros(nRuns*nFiles, NOUTPUT); %%%%%%%%%%%%%%%%%% more time steps as outout???? must increase this then
%%

U_avg = reshape(permute(ncread('stateAvgStd.nc','U_avg'),[2 1 3]),[prod(U_size),1]);
U_std = reshape(permute(ncread('stateAvgStd.nc','U_std'),[2 1 3]),[prod(U_size),1]);

V_avg = reshape(permute(ncread('stateAvgStd.nc','V_avg'),[2 1 3]), [prod(V_size),1]);
V_std = reshape(permute(ncread('stateAvgStd.nc','V_std'),[2 1 3]), [prod(V_size),1]);



T_avg = reshape(permute(ncread('stateAvgStd.nc','T_avg'),[2 1 3]), [prod(T_size),1]);
T_std = reshape(permute(ncread('stateAvgStd.nc','T_std'),[2 1 3]), [prod(T_size),1]);

S_avg = reshape(permute(ncread('stateAvgStd.nc','S_avg'),[2 1 3]), [prod(S_size),1]);
S_std = reshape(permute(ncread('stateAvgStd.nc','S_std'),[2 1 3]), [prod(S_size),1]);

E_avg = reshape(permute(ncread('stateAvgStd.nc','E_avg'),[2 1 3]), [prod(E_size),1]);
E_std = reshape(permute(ncread('stateAvgStd.nc','E_std'),[2 1 3]), [prod(E_size),1]);


windU_avg = reshape(permute(ncread('stateAvgStd.nc','windU_avg'),[2 1]), [prod(windU_size),1]);
windU_std = reshape(permute(ncread('stateAvgStd.nc','windU_std'),[2 1]), [prod(windU_size),1]);

windV_avg = reshape(permute(ncread('stateAvgStd.nc','windV_avg'),[2 1]), [prod(windV_size),1]);
windV_std = reshape(permute(ncread('stateAvgStd.nc','windV_std'),[2 1]), [prod(windV_size),1]);



U_b_avg = reshape(ncread('stateAvgStd.nc','U_b_avg'),[prod(U_b_size),1]);
U_b_std = reshape(ncread('stateAvgStd.nc','U_b_std'),[prod(U_b_size),1]);

V_b_avg = reshape( ncread('stateAvgStd.nc','V_b_avg'),[prod(V_b_size),1]);
V_b_std = reshape(ncread('stateAvgStd.nc','V_b_std'),[prod(V_b_size),1]);

E_b_avg = ncread('stateAvgStd.nc','E_b_avg');
E_b_std = ncread('stateAvgStd.nc','E_b_std');



%%
f_indx = 0;
if fileVector == file_0  %done because else matlab treats the vector like a string and iterates over the chars
    file = file_0;  
        for run = 1 : nRuns
           
            [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getInputVars(file,run,1);
            
            U_cen = (U_0-U_avg)./U_std;
            V_cen = (V_0-V_avg)./V_std;
            
            T_cen = (T_0-T_avg)./T_std;
            S_cen = (S_0-S_avg)./S_std;
            E_cen = (E_0-E_avg)./E_std;
            
            windU_cen = (windU_0-windU_avg)./windU_std;
            windV_cen = (windV_0-windV_avg)./windV_std;
            
            U_b_cen = (U_b_0-U_b_avg)./U_b_std;
            V_b_cen = (V_b_0-V_b_avg)./V_b_std;
            E_b_cen = (E_b_0-E_b_avg)./E_b_std;
            
            
            y = createOutputColVector(file,19,run); %%%specify time step here

            X(run + f_indx,:) = [U_cen; V_cen; T_cen; S_cen; E_cen;...
                windU_cen; windV_cen; U_b_cen; V_b_cen; E_b_cen];
            Y(run + f_indx,:) = y;
            if run == nRuns
                f_indx = run+f_indx;
            end

        end
   
else
    for file = fileVector
        for run = 1 : nRuns
            [U_0,V_0,T_0,S_0,E_0,windU_0,windV_0,U_b_0,V_b_0,E_b_0] = getInputVars(file,run,1);
            
            U_cen= (U_0-U_avg)/U_std;
            V_cen= (V_0-V_avg)/V_std;
            T_cen= (T_0-T_avg)/T_std;

            
            y = createOutputColVector(file,19,run); %%%specify time step here
            
            
            
            
            X(run + f_indx,:) = x;
            Y(run + f_indx,:) = y;
            if run == nRuns
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

ncomp = 3;

%[XL, YL] = plsregress(X,Y,ncomp);

