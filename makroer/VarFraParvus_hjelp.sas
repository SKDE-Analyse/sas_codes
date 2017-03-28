%macro VarFraParvus_Hjelp;
options nomlogic nomprint;
%put =============================================================================================================================;
%put Hente variable fra Parvus til Magnus - Opprettet 5/10-16 av Petter Otterdal;
%put For å finne unike prosedyrer/diagnoser o.l. pr pasient pr sykehusopphold i avdelingsoppholdsfila;
%put NOTE: VarFraParvus(dsnMagnus=,var_som=,var_avtspes=);
%put Parametre:;
%put 1. dsnMagnus: Datasettet du vil koble variable til. Kan være avdelingsoppholdsfil, sykehusoppholdsfil, avtalespesialistfil eller 
kombinasjoner av disse;
%put 2. var_som: Variable som skal kobles fra avdelingsopphold- eller sykehusoppholdsfil ;
%put 3. var_avtspes: Variable som skal kobles fra avtalespesialistfil.;
%put Eksempel: VarFraParvus(dsnMagnus=radiusfrakturer,var_som=cyto: komnrhjem2 opphold_ID, var_avtspes=fagLogg komnrhjem2);
%put -------------------------------------------------------------------------------------------------------------------------------;
%put De varible du har valgt hentes fra aktuelle filer, kobles med variabelen KoblingsID og legges til inndatasettet ;
%put Start gjerne med et ferdig utvalg om det er mulig, da vil makroen kjøre raskere og kreve mindre ressurser;
%put ================================================================================================================================;
%mend VarFraParvus_hjelp;