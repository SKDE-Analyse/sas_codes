
/*Makroen lager datasett med oversikt over de løpenr som er assosiert med mer enn ett kjønn/fødselsår, */
/*enten fordi det er flere kjønn/fødselsår registrert i dataene eller fordi det ikke er samsvar mellom populasjonsdata og aktivitetsdata*/
/*Må sette datasettnavn. Kan også angi løpenummervariabelnavn og dato for populasjonsdata, hvis dette er en del av variabelnavnene for popdatavariablene*/
%macro lnr_flere_kjonn_fodeaar(dsn=,lopenr=lopenr,dato_freg=19062018);

%Merge_persondata(innDataSett=&dsn, utDataSett=&dsn._merged, pid=&lopenr);

/*Sorterer slik at dersom ett lnr er assosiert med mer enn ett kjønn eller ett fødselsår i dataene vil disse lnr få opptre i to eller flere rader, alle andre får en rad pr lnr*/
Proc sort data=&dsn._merged out=&dsn._dup nodupkey /*dupout=Duplicate*/;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;   
Run;

/*Teller antall ganger et lnr opptrer i datasettet*/
proc sql;
   create table &dsn._dup as 
   select *, count(&lopenr) as antall
   from &dsn._dup
   group by &lopenr;
quit;

/*Fjerner alle lnr som opptrer mer enn en gang, og som dermed har registrert mer enn ett kjønn og/eller mer enn ett fødeår*/
data &dsn._flere;
set &dsn._dup;
keep &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg antall aar;
where antall>1;
run;

/*Sorterer på nytt*/
proc sort data=&dsn._flere;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;
quit;

/*Lager oversiktsdatasett*/
PROC SQL;
   CREATE TABLE &dsn._oversikt AS 
   SELECT DISTINCT &lopenr,
MAX(kjonn) AS KJ_Max,
MIN(kjonn) AS KJ_Min,
MAX(kjonn_ident&dato_freg) AS KJ_Max_Id,
MIN(kjonn_ident&dato_freg) AS KJ_Min_Id, 
MAX(fodselsar) AS Faar_Max,
MIN(fodselsar) AS Faar_Min,            
MAX(fodselsAar_ident&dato_freg) AS Faar_Max_Id,
MIN(fodselsAar_ident&dato_freg) AS Faar_Min_Id
      FROM &dsn._DUP
      GROUP BY &lopenr;
QUIT;

data &dsn._oversikt;
set &dsn._oversikt; 
if KJ_Max ne KJ_Min then Kj_ulik=1;
if KJ_Max_Id ne KJ_Min_Id then Kj_id_ulik=1;
if Faar_Max ne Faar_Min then Faar_ulik=1;
if Faar_Max_Id ne Faar_Min_Id then Faar_id_ulik=1;
if KJ_Min_Id ne Kj_min then Kj_ulik_rapp_id=1;
if KJ_Max_Id ne Kj_max then Kj_ulik_rapp_id=1;
if Faar_min_id ne Faar_min then Faar_ulik_rapp_id=1;
if Faar_max_id ne Faar_max then Faar_ulik_rapp_id=1;
run;

/*Datasett med de som har mer enn ett kjønn/fødselsår registrert i populasjonsdataene*/
data &dsn._flere_popdata;
set &dsn._oversikt; 
where Kj_id_ulik=1 or Faar_id_ulik=1;
run;

proc sort data=&dsn._flere_popdata;
by &lopenr;
run;

/*Datasett med de hvor kjønn/fødselsår er ulikt i populasjonsdata og aktivitetsdata*/
data &dsn._ulik_popdata_adata;
set &dsn._oversikt;
where Kj_ulik_rapp_id=1 or Faar_ulik_rapp_id=1;
run;

proc sort data=&dsn._ulik_popdata_adata;
by &lopenr;
run;

%mend lnr_flere_kjonn_fodeaar;