

file_0='init_000.nc'; %Antar vi alltid har minst 1 fil
fileVector = [file_0];
file_indx = 0;



%Lagrer alle filnavn i mappen i en vektor
while isfile("init_" + num2str(file_indx+1,'%03.f') + ".nc")
    file_indx = file_indx + 1;
    fileVector = [fileVector, "init_" + num2str(file_indx,'%03.f') + ".nc"];
end


nRuns = length(ncread("init_000.nc",'run')); %alle filer har samme antall runs
nFiles = length(fileVector);
NINPUT = 247; %number of input variables per run
NOUTPUT = 162; %number of output variables per run

X = zeros(nRuns*nFiles, NINPUT);
Y = zeros(nRuns*nFiles, NOUTPUT);

f_indx = 0;

for file = fileVector
    for run = 1 : nRuns
        x = createInputColVector(file,run);
        y = createOutputColVector(file,19,run); %%%specify time step here
        X(run + f_indx,:) = x;
        Y(run + f_indx,:) = y;
        if run == nRuns
            f_indx = run+f_indx;
        end
    
    end
end

% MÅ SENTERES NÅR ALLE VARIABLER HAR BLITT FUNNET FOR ALLE RUNS.
% means og std!!!!!! ta vare på slik at jeg kan skalere tilbake og bruke
% når modellen skal brukes!!
ncomp = 3;


[obs, vars] = size(X);

[obs, outs] = size(Y);

X_centered = zeros(nRuns*file_indx, NINPUT);
Y_centered = zeros(nRuns*file_indx, NOUTPUT);
 
for col = 1: vars
       X_centered(:,col)= (X(:,col) - mean(X(:,col)))/std(X(:,col));
end

for col = 1: outs
    Y_centered(:,col) = (Y(:,col)- mean(Y(:,col)))/std(Y(:,col));
end






%[XL, YL] = plsregress(X,Y,ncomp);

