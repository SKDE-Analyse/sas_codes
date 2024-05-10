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
	create table SKDE20.lab_nlkkkoder_inkl_&aar.(drop=inndato nr_id) as
	select a.*
	from Z_tmp5_long a
	left join SKDE20.LAB_KODEVERK_2018_2023 b
	on a.nlk=b.kode
	where dato_id <= inndato< dato_slutt and MB eq "MB" and off_priv eq ref_kat;
quit;

/* ekskluderte nlkkoder, som ikke er gyldig MB i angitt tidsrom */
proc sql;
create table SKDE20.LAB_nlkkkoder_ekskl_&aar.(drop=inndato nr_id) as
select * from Z_tmp5_long
EXCEPT ALL
select * from SKDE20.lab_nlkkkoder_inkl_&aar.;
quit;

/* kontrolltelling - hva ble ekskludert */
title"&aar. - antall rader totalt, inkl og ekskl";
proc sql;
select distinct (select count(*) from Z_TMP5_LONG) AS totalNLK,
		(select count(*) from  SKDE20.lab_nlkkkoder_inkl_&aar.) as inklNLK,
    (select count(*) from  SKDE20.LAB_nlkkkoder_ekskl_&aar.) as eksklNLK,
		calculated eksklNLK / calculated totalNLK as andel_eksklNLK format nlpct8.0
from Z_TMP5_LONG;
quit;
title;

/*slette datasettene i work*/
proc datasets nolist;
delete 
Z_tmp1-Z_tmp6 Z_tmp5_long  ;
run;

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

%mend tilrette_lab;