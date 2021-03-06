file_0='init_000.nc'; %Antar vi alltid har minst 1 fil
fileVector = [];
fileVector= [fileVector file_0];
file_indx = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%ONLY RUN WITH ONE FILE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Lagrer alle filnavn i mappen i en vektor
while isfile("init_" + num2str(file_indx+1,'%03.f') + ".nc")
    file_indx = file_indx + 1;
    fileVector = [fileVector "init_" + num2str(file_indx,'%03.f') + ".nc"];
end


nRuns = length(ncread("init_000.nc",'run')); %alle filer har samme antall runs

%%
ncid = netcdf.open('init_000.nc','NC_NOWRITE');
[~, xc] = netcdf.inqDim(ncid,0);
[~, yc] = netcdf.inqDim(ncid,1);
[~, zc] = netcdf.inqDim(ncid,2);
[~, nTimeSamples] = netcdf.inqDim(ncid,3);
[~,xc_b] = netcdf.inqDim(ncid,5);
[~,yc_b] = netcdf.inqDim(ncid,6);
[~,ec_b] = netcdf.inqDim(ncid,7);
netcdf.close(ncid)
%%

nFiles = length(fileVector);

%nCols = nRuns*nFiles*nTimeSamples;

%%
U=[];
V=[];

T=[];
S=[];
E=[];

windU=[];
windV=[];

U_b=[];
V_b=[];
E_b=[];

%%
%f_indx = 0;

if fileVector == file_0  %done because else matlab treats the vector like a string and iterates over the chars
    file = file_0;  
    for run = 1 : nRuns
        for t_sample = 1 : nTimeSamples
           [U_t,V_t,T_t,S_t,E_t,windU_t,windV_t,U_b_t,V_b_t,E_b_t] =  getInputVars(file,run,t_sample);
           U=[U, U_t];
           V=[V, V_t];
           T=[T, T_t];
           S=[S, S_t];
           E=[E, E_t];
           windU=[windU, windU_t];
           windV=[windV, windV_t];
           U_b=[U_b, U_b_t];
           V_b=[V_b, V_b_t];
           E_b=[E_b,E_b_t];
        end
        %if run == nRuns
           % f_indx = f_indx + run;
       % end
    
    end
    


else
    for file = fileVector
   
    
        for run = 1 : nRuns
            for t_sample = 1 : nTimeSamples
            %[U(:,f_indx+run+t_sample),V(:,f_indx+run+t_sample),T(:,f_indx+run+t_sample),...
              %  S(:,f_indx+run+t_sample),E(:,f_indx+run+t_sample),windU(:,f_indx+run+t_sample),...
              %   windV(:,f_indx+run+t_sample),U_b(:,f_indx+run+t_sample),V_b(:,f_indx+run+t_sample),...
               % E_b(:,f_indx+run+t_sample)]= getInputVars(file,run,t_sample);
            
            
            
            [U_t,V_t,T_t,S_t,E_t,windU_t,windV_t,U_b_t,V_b_t,E_b_t] =  getInputVars(file,run,t_sample);
            U=[U, U_t];
            V=[V, V_t];
            T=[T, T_t];
            S=[S, S_t];
            E=[E, E_t];
            windU=[windU, windU_t];
            windV=[windV, windV_t];
            U_b=[U_b, U_b_t];
            V_b=[V_b, V_b_t];
            E_b=[E_b,E_b_t];
            end
           % if run == nRuns
              %  f_indx = f_indx + run;
            %end
    
        end
    end
end

%%
%creating dimensions
filename = 'stateAvgStd.nc';
ncid = netcdf.create('stateAvgStd.nc','CLOBBER');

netcdf.defDim(ncid,'xc',xc);
netcdf.defDim(ncid,'yc',yc);
netcdf.defDim(ncid,'zc',zc);

netcdf.defDim(ncid,'U_xc',xc-1);
netcdf.defDim(ncid,'V_yc',yc-1);


netcdf.defDim(ncid,'xc_b',xc_b);
netcdf.defDim(ncid,'yc_b',yc_b);
netcdf.defDim(ncid,'ec_b',ec_b);


netcdf.close(ncid)
%%
%creating variables
nccreate(filename,'U_avg','Datatype','double','Dimensions',{'yc','U_xc','zc'})
nccreate(filename,'U_std','Datatype','double','Dimensions',{'yc','U_xc','zc'})
nccreate(filename,'V_avg','Datatype','double','Dimensions',{'V_yc','xc','zc'})
nccreate(filename,'V_std','Datatype','double','Dimensions',{'V_yc','xc','zc'})

nccreate(filename,'T_avg','Datatype','double','Dimensions',{'yc','xc','zc'})
nccreate(filename,'T_std','Datatype','double','Dimensions',{'yc','xc','zc'})

nccreate(filename,'S_avg','Datatype','double','Dimensions',{'yc','xc','zc'})
nccreate(filename,'S_std','Datatype','double','Dimensions',{'yc','xc','zc'})

nccreate(filename,'E_avg','Datatype','double','Dimensions',{'yc','xc'})
nccreate(filename,'E_std','Datatype','double','Dimensions',{'yc','xc'})


nccreate(filename,'windU_avg','Datatype','double','Dimensions',{'yc','U_xc'})
nccreate(filename,'windU_std','Datatype','double','Dimensions',{'yc','U_xc'})

nccreate(filename,'windV_avg','Datatype','double','Dimensions',{'V_yc','xc',})
nccreate(filename,'windV_std','Datatype','double','Dimensions',{'V_yc','xc',})

nccreate(filename,'U_b_avg','Datatype','double','Dimensions',{'xc_b','zc'})
nccreate(filename,'U_b_std','Datatype','double','Dimensions',{'xc_b','zc'})
nccreate(filename,'V_b_avg','Datatype','double','Dimensions',{'yc_b','zc'})
nccreate(filename,'V_b_std','Datatype','double','Dimensions',{'yc_b','zc'})
nccreate(filename,'E_b_avg','Datatype','double','Dimensions',{'ec_b'})
nccreate(filename,'E_b_std','Datatype','double','Dimensions',{'ec_b'})
%%
%finding averages/std and writing to file



U_avg=mean(transpose(U));


V_avg = mean(transpose(V));



T_avg = mean(transpose(T));
S_avg = mean(transpose(S));
E_avg = mean(transpose(E));

windU_avg = mean(transpose(windU));
windV_avg = mean(transpose(windV));

U_b_avg = mean(transpose(U_b));
V_b_avg = mean(transpose(V_b));
E_b_avg = mean(transpose(E_b));

U_std=std(transpose(U));
V_std = std(transpose(V));

T_std = std(transpose(T));
S_std = std(transpose(S));
E_std = std(transpose(E));

windU_std = std(transpose(windU));
windV_std = std(transpose(windV));

U_b_std = std(transpose(U_b));
V_b_std = std(transpose(V_b));
E_b_std = std(transpose(E_b));
%%
%mean
ncwrite('stateAvgStd.nc','U_avg',reshape(U_avg,[yc,xc-1,zc]))
ncwrite('stateAvgStd.nc','V_avg',reshape(V_avg,[yc-1,xc,zc]))

ncwrite('stateAvgStd.nc','T_avg',reshape(T_avg,[yc,xc,zc]))
ncwrite('stateAvgStd.nc','S_avg',reshape(S_avg,[yc,xc,zc]))
ncwrite('stateAvgStd.nc','E_avg',reshape(E_avg,[yc,xc]))

ncwrite('stateAvgStd.nc','windU_avg',reshape(windU_avg,[yc,xc-1]))
ncwrite('stateAvgStd.nc','windV_avg',reshape(windV_avg,[yc-1,xc]))

ncwrite('stateAvgStd.nc','U_b_avg',reshape(U_b_avg,[xc_b,zc]))
ncwrite('stateAvgStd.nc','V_b_avg',reshape(V_b_avg,[yc_b,zc]))
ncwrite('stateAvgStd.nc','E_b_avg',E_b_avg)


%%
%std
ncwrite('stateAvgStd.nc','U_std',reshape(U_std,[yc,xc-1,zc]))
ncwrite('stateAvgStd.nc','V_std',reshape(V_std,[yc-1,xc,zc]))

ncwrite('stateAvgStd.nc','T_std',reshape(T_std,[yc,xc,zc]))
ncwrite('stateAvgStd.nc','S_std',reshape(S_std,[yc,xc,zc]))
ncwrite('stateAvgStd.nc','E_std',reshape(E_std,[yc,xc]))

ncwrite('stateAvgStd.nc','windU_std',reshape(windU_std,[yc,xc-1]))
ncwrite('stateAvgStd.nc','windV_std',reshape(windV_std,[yc-1,xc]))

ncwrite('stateAvgStd.nc','U_b_std',reshape(U_b_std,[xc_b,zc]))
ncwrite('stateAvgStd.nc','V_b_std',reshape(V_b_std,[yc_b,zc]))
ncwrite('stateAvgStd.nc','E_b_std',E_b_std)










