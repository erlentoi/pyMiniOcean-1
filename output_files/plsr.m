%file_0='init_000.nc';
%file_1='init_001.nc';
%file_2='init_002.nc';
%file_3='init_003.nc';
%file_4='init_004.nc';
%file_5='init_005.nc';



file_0='init_000.nc'; %Antar vi alltid har minst 1 fil
fileVector = [file_0];
file_indx = 0;



%Lagrer alle filnavn i mappen i en vektor
while isfile("init_" + num2str(file_indx+1,'%03.f') + ".nc")
    file_indx = file_indx + 1;
    fileVector = [fileVector, "init_" + num2str(file_indx,'%03.f') + ".nc"];
end


nRuns = length(ncread("init_000.nc",'run')); %alle filer har samme antall runs

NINPUT = 247; %number of input variables per run
NOUTPUT = 162; %number of output variables per run

X = zeros(nRuns, NINPUT);
Y = zeros(nRuns, NOUTPUT);



for file = fileVector
    for run = 1 : nRuns
        x = createInputColVector(file,run);
        y = createOutputColVector(file,19,run); %%%specify time step here
        X(run,:) = x;
        Y(run,:) = y;
    end
end


[XL, YL] = plsregress(X,Y,3);

