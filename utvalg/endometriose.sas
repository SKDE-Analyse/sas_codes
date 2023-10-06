
/* BESKRIVELSE

Definerer opp endometriose-operasjoner (variabelen endo_kirbeh)

Koden stammer fra gynatlaset, oppdatert i 2021 ifm analyser til kronikeratlas.

Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/endometriose.sas";
run;
*/

array endo_diag {*} Hdiag: Bdiag: Tdiag:;
	do i=1 to dim(endo_diag);
		if substr(endo_diag{i},1,3) in ('N80')  then Endometriose_d=1; 

		if substr(endo_diag{i},1,4) in ('N941','N944','N945','N946')  then dysm_dysp_d=1; 
		if substr(endo_diag{i},1,4) in ('N944','N945','N946')  then dysmenore=1; 
		if substr(endo_diag{i},1,4) in ('N945')  then sek_dysmenore=1; 
		if substr(endo_diag{i},1,4) in ('N941')  then dyspareuni=1; 
	end;

array endo_Pros {*} NC:;
    do j=1 to dim(endo_Pros); 

	/*Hysterektomier*/
	if endo_Pros{j} in ('LCD00','LCD30','LCD96','LCD10','LCD40','LCD01','LCD04',
                        'LCD11','LCD31','LCD97','LCC10','LCC11','LCC20') then Endometriose_hyst_p=1;
	
	/*Andre inngrep*/		
	if endo_Pros{j} in ('JAL21','JAP00','JAP01','JAL20','JAL21','JAA10','JAA11',
						'LAC00','LAC01','LAC10','LAC11','LAC20','LAC21','LCF00',
						'LCF01','LAD00','LAD01','LAE10','LAE11','LAE20','LAE21',
						'LAF00','LAF01','LAF10','LAF11','LAF20','LAF30','LBD00',
						'LBD01','LBE00','LBE01',
                        'LCC00','LCC01','LCC05','LCC96','LCC97','LCF97','LCF96') then Endometriose_p=1;						
					
	end;

/*Hvert inngrep klassifiseres som enten hysterektomi eller andre inngrep*/
     if Endometriose_d=1 and (Endometriose_hyst_p=1 or Endometriose_p=1) then endom_dp=1;
else if dysm_dysp_d=1    and (Endometriose_hyst_p=1 or Endometriose_p=1) then dysm_dysp_dp=1;

if endom_dp or dysm_dysp_dp then endo_kirbeh=1;

if Endometriose_d or dysm_dysp_d then do; 
	endometriose=1;
end;

drop i j;
