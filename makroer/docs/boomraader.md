[Ta meg tilbake.](./)


# boomraader

%macro boomraader_hjelp;

%put NOTE: Boomraade-makro;
%put NOTE: Definerer boområder ut fra komnr og bydel;
%put NOTE: Boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1);
%put ;
%put Hvis haraldsplass ne 0: del Bergen i Haraldsplass og Bergen;
%put Hvis indreOslo ne 0: Slå sammen Diakonhjemmet og Lovisenberg;
%put Hvis bydel = 0: Vi mangler bydel og må bruke gammel boomr.-struktur ;
%put        (bydel 030110, 030111, 030112 går ikke til Ahus men til Oslo);
%put Følgende variabler nulles ut i begynnelsen av makroen, og lages av makroen:;
%put - BoShHN;
%put - VertskommHN;
%put - BoHF;
%put - BoRHF;
%put - Fylke;

%mend;

