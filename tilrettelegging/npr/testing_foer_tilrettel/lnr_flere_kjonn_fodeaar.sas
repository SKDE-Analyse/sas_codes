
/*Makroen lager datasett med oversikt over de l�penr som er assosiert med mer enn ett kj�nn/f�dsels�r, */
/*enten fordi det er flere kj�nn/f�dsels�r registrert i dataene eller fordi det ikke er samsvar mellom populasjonsdata og aktivitetsdata*/
/*M� sette datasettnavn. Kan ogs� angi l�penummervariabelnavn og dato for populasjonsdata, hvis dette er en del av variabelnavnene for popdatavariablene*/
%macro lnr_flere_kjonn_fodeaar(mappe=NPR18.,dsn=, rot=, lopenr=PID,dato_freg=19062018);


data &rot;
set &mappe.&dsn;
PID=lopenr+0;
Keep PID kjonn fodselsar;
run;

%Merge_persondata(innDataSett=&rot, utDataSett=&rot._merged);


/*Sorterer slik at dersom ett lnr er assosiert med mer enn ett kj�nn eller ett f�dsels�r i dataene vil disse lnr f� opptre i to eller flere rader, alle andre f�r en rad pr lnr*/
Proc sort data=&rot._merged out=&rot._dup nodupkey /*dupout=Duplicate*/;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;   
Run;


/*Teller antall ganger et lnr opptrer i datasettet*/
proc sql;
   create table &rot._dup as 
   select *, count(&lopenr) as antall
   from &rot._dup
   group by &lopenr;
quit;

/*Sorterer p� nytt*/
proc sort data=&rot._dup;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;
quit;

/*Beholder bare lnr som opptrer mer enn en gang, og som dermed har registrert 
mer enn ett kj�nn og/eller mer enn ett f�de�r i aktivitetsdata eller i populasjonsdata*/
data &rot._flere;
set &rot._dup;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;
where antall>1;
run;

/*Sorterer p� nytt*/
proc sort data=&rot._dup;
by &lopenr kjonn kjonn_ident&dato_freg fodselsar fodselsaar_ident&dato_freg;
quit;

proc sort data=&rot._dup;
by PID;
quit;

data &rot._dup;
set &rot._dup;
by PID;
if first.pid=1 then unik=1;
run;

/*Lager oversiktsdatasett*/
PROC SQL;
   CREATE TABLE &rot._oversikt AS 
   SELECT DISTINCT &lopenr, unik, 
MAX(kjonn) AS KJ_Max,
MIN(kjonn) AS KJ_Min,
MAX(kjonn_ident&dato_freg) AS KJ_Max_Id,
MIN(kjonn_ident&dato_freg) AS KJ_Min_Id, 
MAX(fodselsar) AS Faar_Max,
MIN(fodselsar) AS Faar_Min,            
MAX(fodselsAar_ident&dato_freg) AS Faar_Max_Id,
MIN(fodselsAar_ident&dato_freg) AS Faar_Min_Id
      FROM &rot._DUP
      GROUP BY &lopenr;
QUIT;

data &rot._oversikt;
set &rot._oversikt; 
if KJ_Max ne KJ_Min then Kj_ulik=1;
if KJ_Max_Id ne KJ_Min_Id then Kj_id_ulik=1;
if Faar_Max ne Faar_Min then Faar_ulik=1;
if Faar_Max_Id ne Faar_Min_Id then Faar_id_ulik=1;
if KJ_Min_Id ne Kj_min then Kj_ulik_rapp_id=1;
if KJ_Max_Id ne Kj_max then Kj_ulik_rapp_id=1;
if Faar_min_id ne Faar_min then Faar_ulik_rapp_id=1;
if Faar_max_id ne Faar_max then Faar_ulik_rapp_id=1;
run;

/*Datasett med de som har mer enn ett kj�nn/f�dsels�r registrert i populasjonsdataene*/
data &rot._flere_popdata;
set &rot._oversikt; 
where Kj_id_ulik=1 or Faar_id_ulik=1;
run;

proc sort data=&rot._flere_popdata;
by &lopenr;
run;

/*Datasett med de hvor kj�nn/f�dsels�r er ulikt i populasjonsdata og aktivitetsdata*/
data &rot._ulik_popdata_adata;
set &rot._oversikt;
where Kj_ulik_rapp_id=1 or Faar_ulik_rapp_id=1;
run;

proc sort data=&rot._ulik_popdata_adata;
by &lopenr;
run;

title "&rot";
PROC TABULATE
DATA=&rot._OVERSIKT;
	
VAR Faar_ulik Faar_id_ulik Kj_ulik_rapp_id Faar_ulik_rapp_id Kj_ulik Kj_id_ulik unik;
TABLE /* Row Dimension */
Faar_ulik_rapp_id ={LABEL="Ulikt f�dsels�r i persondata og aktivitetsdata"}
Kj_ulik_rapp_id ={LABEL="Ulikt kj�nn i persondata og aktivitetsdata"}
Faar_id_ulik ={LABEL="Mer enn ett f�dsels�r i persondata"}
Kj_id_ulik ={LABEL="Mer enn ett kj�nn i persondata"}
Faar_ulik ={LABEL="Mer enn ett f�dsels�r i aktivitetsdata"} 
Kj_ulik ={LABEL="Mer enn ett kj�nn i aktivitetsdata"}
unik ={LABEL="Unike PID i aktivitetsdata"} ,
/* Column Dimension */
N ={LABEL="Antall"} 		;
	;

RUN;
title;


%mend lnr_flere_kjonn_fodeaar;

/* Makro som gir frekvenser for NPRId_reg, kj�nn og f�dsels�r i aktivitetsdata og persondata */

%macro freq_akt(rot=, dsn=);
title "&rot";
proc freq data=NPR18.&dsn;
table nprId_reg kjonn fodselsar;
run;
title;
%mend freq_akt;

%macro freq_pers(rot=, dsn=, dato_freg=19062018);
title "&rot";
proc freq data=NPR18.&dsn;
table kjonn_ident&dato_freg fodselsAar_ident&dato_freg;
run;
title;
%mend freq_pers;