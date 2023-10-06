

/* BESKRIVELSE

Definerer opp hofteprotese-operasjoner
NB! Definerer både helproteser og delproteser, primær- og sekundærproteser
Definerer også opp brudd og osteosyntese i tilfelle man vil ekskludere med disse variablene

Deler av koden ble brukt i utvalgsprosjektet i 2022 (sykehusutalget og kvinnehelseutvalget) 
for å definere primære hofteproteser. Definisjon av sekundære proteser stammer fra rehab-prosjektet (2019/2020)


Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/hofteprotese.sas";
run;
*/


/*DEFINISJON PÅ HOFTEBRUDD - I TILFELLE MAN VIL EKSKLUDERE DISSE */
array hofte_hbd {*} Hdiag: Bdiag: ;
    do i=1 to dim(hofte_hbd);
        if substr(hofte_hbd{i},1,4) in ('S720','S721','S722')    	    then brudd = 1;
	end;


array hofte_pros {*} nc: ;
    do j=1 to dim(hofte_pros);

        /* osteosyntese - AKTUELT FOR EVT. EKSKLUSJON*/
	    if substr(hofte_pros{j},1,3) in ("NFJ")							    then osteosyntese = 1;

       /* primær hofteprotese - DELprotese */
        if substr(hofte_pros{j},1,5) in ('NFB02', 'NFB12','NFB01', 'NFB11')   then del_hofte_prim = 1;

        /* primær hofteprotese - kun totalprotese */
        if substr(hofte_pros{j},1,5) in ('NFB20', 'NFB30', 'NFB40', 'NFB99')  then tot_hofte_prim = 1;

        /* sekundær hofteprotese */
           if substr(pros{j},1,4) in ('NFC0', 'NFC1')                       then del_hofte_sek = 1;

           if substr(pros{j},1,4) in ('NFC2', 'NFC3', 'NFC4')               then tot_hofte_sek = 1;
           if substr(pros{j},1,5) in ('NFC99')                              then tot_hofte_sek = 1;

     end;

drop i j;