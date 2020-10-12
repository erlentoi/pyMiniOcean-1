input_file='real_sub_area';
%output_file=

x_0=createColVectorFromInput('input_real_sub_area.nc');

%Y=createColVectorFromOutput('output_real_sub_area.nc');


%skalering av data . hver varaibel må sentreres rundt 0 kanskje for å være
%sammenlignbare. gjsnitt og std avvik av hver var, deretter sentrere. 

%legge til time og run dimensjoner (time henter vi variablene i de
%tidspunktene)..

%KAN AVGRENSE DATA TIL et visst antall lag, påse at det er dypt nok.

%må få inn DEPTH, definere kmax, fokusere på øvre del av vannsøyle ned til
%cutooff passe på å velge områder som ikke er grunnere enn det.

%kmm settes opp ved z inneholder indexen til nederste laget som er
%reperesntert som angir antall lag imax x jmax.sjekke område ved å sjekke
%kmm, hvis ikke dypt nok, gå videre. Kan bruke en uniform random.
%numpy.random.uniform.

%kanskje bygge om main: flere proesser kjører hele området og velger
%tilefeldig et subområde. koordinerering: passe på at de ikke skriver
%samtidig eller at alle proesser skriver til egen fil, og sette dem sammen
%etterpå(enkelt). eller bare sette sammen i matlab. angi rank i filnavnet:
%'init_[rank].nc'. n.zfill padder på 0'er, hvis dette, trenger ikke bruke
%mpi, hell