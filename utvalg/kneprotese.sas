/* BESKRIVELSE

Definerer opp kneprotese-operasjoner
NB! Definerer både helproteser og delproteser, primær- og sekundærproteser

Koden stammer fra rehab-prosjektet (2019/2020).

Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/kneprotese.sas";
run;
*/

array pros {*} ncmp: ncrp: ncsp:;
     do j=1 to dim(pros);

/* primær kneprotese - inkl delprotese */
                     if substr(pros{j},1,4) in ('NGB0', 'NGB1')                      then del_kne_prim = 1;
                     if substr(pros{j},1,5) in ('NGB20', 'NGB30', 'NGB40', 'NGB99')  then tot_kne_prim = 1;

/* sekundære kneprotese - inkl delprotese */
                      if substr(pros{j},1,4) in ('NGC0','NGC1')                  then del_kne_sek = 1;
                      if substr(pros{j},1,4) in  ('NGC2','NGC3','NGC4')          then tot_kne_sek = 1;
                      if substr(pros{j},1,5) in ('NGC99')                        then tot_kne_sek = 1;
     end;

     drop j;