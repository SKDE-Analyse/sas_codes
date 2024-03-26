%macro inkontinens(datasett =);

/*
BESKRIVELSE:
Definerer opp inkontinensoperasjoner for kvinner (variabelen Inkontinens_dp)

Koden stammer fra gynatlaset, prosedyrekoder er ihht inkontinensregisteret - se lenke til dekningsgradsrapport under.

Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/inkontinens.sas";
run;
*/

/*
Rapport fra dekningsgradsanalyse 2022 (https://www.kvalitetsregistre.no/sites/default/files/2023-05/Validert%20dekningsgradsanalyse%20av%20NKIR%202022.pdf):
Følgende operasjonskoder kvalifiserer for deltagelse i registeret: 
LEG00, LEG10, LEG13, LEG20, LEG96, KDG00, KDG01, KDG10, KDG20, KDG21, KDG30, KDG31, KDG40, KDG43,
KDG50, KDG60, KDG96, KDG97, KDV20, KDV22

Uendret siden 2016.
*/


array diagnose {*} Hdiag: Bdiag:;
	do i=1 to dim(diagnose);
		if diagnose{i} in ('N393','N394')  then Inkontinens_d=1; /*Stressinkontinens/Annen spesifisert urininkontinens*/  
		if diagnose{i} in ('N393')  then S_Inkontinens_d=1;
		if diagnose{i} in ('N394')  then A_Inkontinens_d=1;
	end;

array Prosedyre {*} NC:;
    	do i=1 to dim(prosedyre); 
			/*Prosedyrer i hht Inkontinensregisteret side 20, Årsrapporten 2016*. Der stilles ikke krav om tilstandskode.*/
			if prosedyre{i} in 	('LEG00','LEG10','LEG13','LEG20','LEG96',
						'KDG00','KDG01','KDG10','KDG20','KDG21',
						'KDG30','KDG31','KDG40','KDG43','KDG50','KDG60','KDG96','KDG97',
						'KDV20','KDV22') 
			then Inkontinens_p=1;	
	end;

if Inkontinens_d=1 and Inkontinens_p=1 then Inkontinens_dp=1;


%mend inkontinens;


