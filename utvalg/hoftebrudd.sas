

/* BESKRIVELSE

Definerer opp hoftebrudd
Koden ble brukt i utvalgsprosjektet i 2022 (sykehusutalget og kvinnehelseutvalget)


Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/hoftebrudd.sas";
run;
*/


array hofte_hbd {*} Hdiag: Bdiag: ;
    do i=1 to dim(hofte_hbd);
        if substr(hofte_hbd{i},1,4) in ('S720','S721','S722')    	    then brudd = 1;
	end;

array hofte_pros {*} nc: ;
    do j=1 to dim(hofte_pros);

        /* osteosyntese*/
	    if substr(hofte_pros{j},1,3) in ("NFJ")							    then osteosyntese = 1;

       /* primær hofteprotese - DELprotese */
        if substr(hofte_pros{j},1,5) in ('NFB02', 'NFB12','NFB01', 'NFB11')   then del_hofte_prim = 1;

        /* primær hofteprotese - kun totalprotese */
        if substr(hofte_pros{j},1,5) in ('NFB20', 'NFB30', 'NFB40', 'NFB99')  then tot_hofte_prim = 1;

     end;

drop i j;

if brudd=1 then do;
	If osteosyntese = 1 or del_hofte_prim = 1 or tot_hofte_prim = 1 then hoftebrudd = 1;
end;
