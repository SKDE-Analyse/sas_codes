%macro tilrette_lab(dsn= );
    /*! 
    ### Beskrivelse
    
    Makro for å tilrettelegge LAB-data (NLK-filer).
    
    ```
    %tilrette_lab(dsn=);
    ```
    
    ### Input 
          - Inndata
    
    ### Output 
          - LAB_nlkkoder_long_&aar. (nlkkoder som er medisinsk biokjemi)
          - LAB_nlkkoder_ekskl_&aar. (ekskluderte nlkkoder)
          - LAB_demografi_&aar. (ermann, alder, komnr, bydel, komnr_aar, bydel_aar)
    
    ### Endringslogg:
        - Opprettet juli 2023, Tove J
        - Skrevet om, mai 2024, Tove J
        
     */

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

/*------------------------------------*/
/* 1) lese inn og lage pid og inndato */
/*------------------------------------*/
data Z_tmp1;
set &dsn.;

/* rename til PID */
rename pasientlopenummer = pid;

/* år, måned og inndato fra dato variabel */
aar = year(dato);
inndato = dato;
format inndato eurdfdd10.;
drop dato;
run;

/*lager makrovariabel som angir årstall - brukes til navning av data senere*/
data _null_;
  set Z_tmp1;
  call symputx("aar",aar);
run;

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

/*-----------------------------*/
/* 2) LAGE VARIABEL 'PROVE_ID' */
/*-----------------------------*/

/*sortere datasett*/
proc sort data=Z_tmp1; by pid inndato;run;

/*lage hjelpevariabel 'nbr', 
det er et unikt nummer til den enkelte pasient pr dag,
serien starter på 1 i aktuell årgang, dvs ikke unik på tvers av årene.
Pasient med to rader i datasettet på samme dato -> vil ha samme NBR,
pasient med to rader i datasettet på ulike datoer -> vil få to ulike NBR.*/
data Z_tmp2;
length nbr 8;
set Z_tmp1;
	retain nbr current_pid ;

 by pid inndato;
  if first.pid then current_pid=pid;
  if current_pid=pid and first.inndato then nbr+1; 
run;

/*lage startpunkt for unik telle_id på tvers av alle årene*/
%if &aar=2018 %then %do; %let start = 10000000; %end;
%if &aar=2019 %then %do; %let start = 20000000; %end;
%if &aar=2020 %then %do; %let start = 30000000; %end;
%if &aar=2021 %then %do; %let start = 40000000; %end;
%if &aar=2022 %then %do; %let start = 50000000; %end;
%if &aar=2023 %then %do; %let start = 60000000; %end;

/*generere variabel 'prove_id',
bruker variabel 'nbr' som er unik pr pasient/dag*/
data Z_tmp3;
  length prove_id 8. ;
set Z_tmp2;
prove_id=nbr+&start.;

/*drop hjelpevariabler*/
drop nbr current_pid; 
run;

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

/*----------------------------------------*/
/* 3) SPLITT UTLEVERT VARIABEL 'NLKKODER' */
/*----------------------------------------*/
data Z_tmp4;
set Z_tmp3;
           
/* dele nlkkode-variabel slik at en kode per celle */
/* Hvis kode er gjentatt flere ganger, angitt med x2 e.l, utvides det med flere kolonner */
i=1;  *read counter;
j=1;  *write counter;
  array nlk {*} $ 10 nlkkode1-nlkkode270 ; *set length to 10 otherwise it gets chopped at 8;
    do until (i>270);
      /* read */
      ith=scan(nlkkoder,i);     *the i-th string; 
      kode=scan(ith,1,"x");     *nlk code to be written; 
      ndup=scan(ith,2,"x")+0;   *value after x; 
      /* write */
      if ndup ne . then do; 
          do k=1 to ndup;         *repeat writing ndup times; 
          nlk{j}=kode;
            j+1;      *increase the write counter;
          end;
      end;
      else i=270;               *nothing to write, skip to the end of the loop;
      i+1;
    end;
drop i j k ith kode ndup ;
run;

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

/*----------------------------------*/
/* LAGE LANGT DATASETT MED NLKKODER */
/*----------------------------------*/

/* sortere */
proc sort data=Z_tmp4;by prove_id;run;
/* lage hjelpevariabel 'nr_id', angir antall regninger/rader i en prove_id */
data Z_tmp5;
set Z_tmp4;
by prove_id;
if first.prove_id then nr_id = 0;
nr_id+1;
/* lag variabel off_priv (1=off, 2=priv) */
if fagomraade_kode eq "PO" then off_priv = 1; /*offentlig*/
if fagomraade_kode eq "LR" then off_priv = 2; /*privat*/
drop fagomraade_kode;
run;

/* sortere */
proc sort data=Z_tmp5;by prove_id nr_id;run;

/* transponere */
proc transpose data=Z_tmp5 
				out=Z_tmp5_long(drop=_name_ 
								where=(not missing(NLK))
								rename=(col1=NLK)
								);
by prove_id nr_id inndato off_priv;
var nlkkode1-nlkkode270;
run;

/* lagre langt datasett som inneholder medisinsk biokjemi NLKKODER med refusjonsrett */
proc sql;
	create table SKDE20.lab_nlkkoder_inkl_&aar.(drop=inndato nr_id) as
	select a.*, b.refusjon, b.stjernekode
	from Z_tmp5_long a
	left join SKDE20.LAB_KODEVERK_2018_2023 b
	on a.nlk=b.kode
	where dato_id <= inndato< dato_slutt and MB eq "MB" and off_priv eq ref_kat;
quit;

/* lagre ekskluderte nlkkoder, som ikke er gyldig MB i angitt tidsrom */
proc sql;
create table SKDE20.LAB_nlkkoder_ekskl_&aar. as
select * from Z_tmp5_long(drop=inndato nr_id)
EXCEPT ALL
select * from SKDE20.lab_nlkkoder_inkl_&aar.(drop=refusjon);
quit;

/* kontrolltelling - hva ble ekskludert */
title"&aar. - antall rader totalt, inkl og ekskl";
proc sql;
select distinct (select count(*) from Z_TMP5_LONG) AS totalNLK format nlnum10.,
		(select count(*) from  SKDE20.lab_nlkkoder_inkl_&aar.) as inkl format nlnum10.,
    (select count(*) from  SKDE20.LAB_nlkkoder_ekskl_&aar.) as ekskl format nlnum10.,
		calculated ekskl / calculated totalNLK as andel_ekskl format nlpct8.0
from Z_TMP5_LONG;
quit;
title;

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

/*----------------------------------------------------------*/
/* startpunkt med unike PROVE_ID 
  - lage fil som angir ratevariabler (alder, kjønn, bosted) */
/*----------------------------------------------------------*/
proc sql;
	create table start_demografi as
	select distinct prove_id, pid
	from Z_tmp5;
quit;

/*-------------------------------------------------------------*/
/* fikse komnr/bydel 
	- kan ikke skifte bosted i en prove_id 
	- lage komnr_aar og bydel_aar som er unik bosted innad i år*/
/*-------------------------------------------------------------*/
proc sql;
	create table pid_bosted as
	select distinct prove_id, pid, pasient_kommune, inndato
	from Z_tmp5;
quit;
/* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
/* mottatte data har eget kodeverk for bydelskommuner, se mapping i csv-fil*/
%include "&filbane/tilrettelegging/lab/omkoding_komnr_bydel.sas";
%omkoding_komnr_bydel(inndata=pid_bosted, pas_komnr=pasient_kommune);
/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=pid_bosted, kommune_nr=komnr_mottatt);

/******************************************************/
/* sette siste bosted i året som unikt bosted det året*/
/******************************************************/
proc sort data=pid_bosted out=pid_bosted2(keep=pid komnr bydel inndato); by pid inndato; run;
data pid_bosted3;
set pid_bosted2;
by pid inndato;
if last.pid and last.inndato then do;
	komnr_unik = komnr;
	bydel_unik = bydel;
	end;
run;
proc sql;
	create table pid_bosted4 as
	select distinct pid, 
				max(komnr_unik) as komnr_aar,
				max(bydel_unik) as bydel_aar
	from pid_bosted3
	group by pid;
quit;
proc sql;
	create table demografi2 as
	select a.*, b.komnr_aar, b.bydel_aar
	from start_demografi a
	left join pid_bosted4 b
	on a.pid=b.pid;
quit;

/**************************/
/* unik bosted pr prove_id*/
/**************************/
proc sql;
	create table pid_bosted5 as
	select prove_id, min(komnr) as komnr_min,
				min(bydel) as bydel_min
	from pid_bosted
	group by prove_id;
quit;
proc sql;
	create table demografi3 as
	select a.*, b.komnr_min as komnr, b.bydel_min as bydel
	from demografi2 a
	left join pid_bosted5 b
	on a.prove_id=b.prove_id;
quit;

/*--------------------------------------------*/
/* fikse alder - settes til maks gjeldende år */
/*--------------------------------------------*/
proc sql;
    create table pid_alder as
    select pid, max(PASIENT_ALDER) as alder
    from Z_tmp5
    group by pid;
run;   
proc sql;
    create table demografi4 as
    select a.*, b.alder
    from demografi3 a
	left join pid_alder b
    on a.pid=b.pid;
quit;

/*-------------------------------------------------*/
/* fikse kjønn - settes til siste registrerte kjønn*/
/*-------------------------------------------------*/
proc sort data=Z_tmp5 out=pid_kjonn(keep=pid pasient_kjonn inndato); by pid inndato; run;
data pid_kjonn2;
set pid_kjonn;
by pid inndato;
if last.pid and last.inndato then kjonn = pasient_kjonn;
run;
proc sql;
	create table pid_kjonn3 as
	select distinct pid, 
				case when kjonn eq 1 then 1 
					when kjonn eq 2 then 0
					when kjonn not in (1,2) then . end as ermann
	from pid_kjonn2
	where kjonn ne .;
quit;

/* ------------------------------ */
/* lagre ferdig fil med demografi */
/* ------------------------------ */
proc sql;
	create table skde20.lab_demografi_&aar. as
	select a.*, b.ermann
	from demografi4 a
	left join pid_kjonn3 b
	on a.pid=b.pid;
quit;

/*slette datasettene i work*/
proc datasets nolist;
delete 
Z_tmp1-Z_tmp6 Z_tmp5_long pid_alder pid_kjonn: pid_bosted: start_demografi demografi: ;
run;
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
%mend tilrette_lab;