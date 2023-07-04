%macro tilrettelegging_lab(inndata=, aar=);
    /*! 
    ### Beskrivelse
    
    Makro for å tilrettelegge LAB-data (NLK-filer).
    
    ```
    %tilrettelegging_lab(inndata=,aar=);
    ```
    
    ### Input 
          - Inndata: 
          - aar:
    
    ### Output 
          - LAB_&aar._T23
          - LAB_&aar._TRANSPONERT_T23 (hvor pasienter med flere rader på en dag er blitt transponert til en rad)
    
    ### Endringslogg:
        - Opprettet juli 2023, Tove J
     */

%include "&filbane/formater/SKDE_somatikk.sas";

data lab_&aar.;
set &inndata;
      /* -------------------------------------- */
      /* år, måned og inndato fra dato variabel */
      /* -------------------------------------- */
      aar = year(dato);
      inndato = dato;
      format inndato eurdfdd10.;
      drop dato;
      /* ----------------------------- */
      /* skille på offentlig og privat */
      /* ----------------------------- */
      if fagomraade_kode eq "PO" then off = 1;
      if fagomraade_kode eq "LR" then priv = 1;
      
      /* ------------------------------- */
      /* omkode pasient_kjonn til ermann */
      /* ------------------------------- */
      if pasient_kjonn eq 1     			then ermann=1; /* Mann */
      if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
      if pasient_kjonn not in  (1:2) 	then ermann=.;
      drop pasient_kjonn;
      format ermann ermann.;
      /* -------------- */
      /* rename til PID */
      /* -------------- */
      rename pasientlopenummer = pid;
run;
      
/* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
%include "&filbane/tilrettelegging/lab/omkoding_komnr_bydel.sas";
%omkoding_komnr_bydel(inndata=lab_&aar., pas_komnr=pasient_kommune);

/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=lab_&aar., kommune_nr=komnr_mottatt);
      
/* for å omkode behandler-komnr må komnr-bosted renames for å ikke overskrives */
data lab_&aar.;
set lab_&aar.;
  rename komnr = komnr_bosted; 
  drop nr komnr_inn komnr_mottatt;
run;
      
%forny_komnr(inndata=lab_&aar., kommune_nr=behandler_kommunenr);
      
data lab_&aar.;
set lab_&aar.;
  rename komnr = komnr_behandler komnr_bosted=komnr;
  drop nr komnr_inn behandler_kommunenr;
run;
      
/* boomraader */
%include "&filbane/makroer/boomraader.sas";
%boomraader(inndata=lab_&aar.);
      
/* fikse alder - settes til maks gjeldende år */
proc sql;
    create table pid_alder as
    select PASIENTLOPENUMMER, max(PASIENT_ALDER) as alder
    from &inndata.
    group by PASIENTLOPENUMMER;
run;
      
proc sql;
    create table lab_&aar._2 as
    select a.*, b.alder
    from lab_&aar. a, pid_alder b
    where a.pid=b.PASIENTLOPENUMMER;
quit;
      
/* identifisere rader hvor en pasient har flere rader på en dag */
proc sql;
  create table lab_&aar._3 as 
  select *,case when count(*) eq 1 	then 0
                    else 1 end as dup
  from lab_&aar._2
  group by pid, inndato;
quit;
      
/* sortere */
proc sort data=lab_&aar._3; by pid inndato tid; run;

/*lage nbr(id)*/
data lab_&aar._4;
length nbr 8;
set lab_&aar._3;
  retain nbr current_pid ;

  by pid inndato;
  if first.pid then current_pid=pid;
  if current_pid=pid and first.inndato then nbr+1; 
run;
      
/*lage startpunkt for unik telle_id på tvers av alle årene - telle unike prøve-dager*/
%if &aar=2018 %then %do; %let start = 10000000; %end;
%if &aar=2019 %then %do; %let start = 20000000; %end;
%if &aar=2020 %then %do; %let start = 30000000; %end;
%if &aar=2021 %then %do; %let start = 40000000; %end;
%if &aar=2022 %then %do; %let start = 50000000; %end;
      
/*lage prøve_id og sette lengde på variabler slik at alle datasett har variabler med lik lengde*/
data lab_&aar._5;
  length prove_id 8. nlkkoder $ 2000 diagnoser $ 27;
set lab_&aar._4;
prove_id=nbr+&start.;
run;

data lab_&aar._6;
set lab_&aar._5;
           
/* dele nlkkode-variabel slik at en kode per celle */
/* Hvis kode er gjentatt flere ganger, angitt med x2 e.l, utvides det med flere kolonner */
i=1;  *read counter;
j=1;  *write counter;
  array nlk {*} $ 10 nlkkode1-nlkkode267 ; *set length to 10 otherwise it gets chopped at 8;
    do until (i>267);
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
      else i=267;               *nothing to write, skip to the end of the loop;
      i+1;
    end;
drop i j k ith kode ndup current_pid;
run;
/* ----------------------------------------------------------- */
/* antall i de enkelte refusjonskategorier pr rad i datasettet */
/* ----------------------------------------------------------- */

/*lese inn fil*/
data ref;
  infile "&filbane/tilrettelegging/lab/alle_nlk_stat_priv_23052023_redusert.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format kode $8.;
  format norsk_bruksnavn $120.;
  format SEKUNDAERT_FAGOMRAADE $8.;
  format FAGOMRAADE_NLK $20.;
  format REFUSJONSKATEGORI $8.;
  format REFUSJON_stat $8.;
  format REFUSJON_privat $8.;
  format STJERNEKODE best8.;
  format REFUSJONSKATEGORI_ENDRET $8.;

  input	
   kode $
   norsk_bruksnavn $
   SEKUNDAERT_FAGOMRAADE $
   FAGOMRAADE_NLK $
   REFUSJONSKATEGORI $
   REFUSJON_stat $
   REFUSJON_privat $
   STJERNEKODE
   REFUSJONSKATEGORI_ENDRET $;
if kode eq "" then delete;
run;

proc sql;
	create table refkat as
	select kode, refusjonskategori
	from ref;
quit;

/*proc transpose for å gjøre datasett langt*/
proc sort data=lab_&aar._6;by prove_id;run;

data lab_&aar._7;
set lab_&aar._6;
by prove_id;
if first.prove_id then nr_id = 0;
nr_id+1;
run;

proc sort data=lab_&aar._7;by prove_id nr_id;run;
proc transpose data=lab_&aar._7 out=lab_&aar._7_long(drop=_name_ where=(not missing(col1)));
by prove_id nr_id;
var nlkkode1-nlkkode267;
run;
  
proc sql;
  create table refkat2 as
  select a.*,b.refusjonskategori
  from lab_&aar._7_long a
  left join refkat b
  on a.col1=b.kode;
quit;
  
  proc sql;
    create table refkat_sum as
    select prove_id, nr_id, refusjonskategori,
            case when refusjonskategori eq "" then "sum_koder_miss" 
              else refusjonskategori end as refusjonskat,
            count(*) as ant
    from refkat2
    group by prove_id,nr_id, refusjonskategori;
  quit;
  
proc transpose data=refkat_sum out=refkat_sum_wide(drop=_name_);
by prove_id nr_id;
id refusjonskat;
run;

data refkat_sum_wide2;
  set refkat_sum_wide;
   array n {*} _numeric_;
   sum_koder_tot=sum(of n[*]) -sum(prove_id,nr_id);
   sum_koder_refkat=sum(of n[*]) - sum(prove_id,sum_koder_miss,nr_id);
  run;
  
proc sql;
	create table lab_&aar._8(rename= nlk_refusjon=sum_ref) as
	select a.*, b.*
	from lab_&aar._7 a
	left join refkat_sum_wide2 b
	on a.prove_id=b.prove_id and a.nr_id=b.nr_id;
quit;

%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";
          
data lab_&aar._8;
retain 
pid 
aar 
prove_id
dup
inndato
ermann
alder
komnr
bydel
bohf
borhf
boshhn
off
priv
sum_ref
nlkkoder
sum_koder_tot
sum_koder_miss
sum_koder_refkat
nlkkode1-nlkkode267;
set lab_&aar._8;
/* sette på bo-formater */
format bohf bohf_fmt. borhf borhf_fmt. boshhn boshhn_fmt. bydel bydel_fmt.;
run;
          
/* sortere og fjerne unødvendige variabler*/
proc sort data=lab_&aar._8(drop=nbr pasient_alder bydel_kort praksis_refusjonsgrunnlag nr_id); by pid inndato; run;

/*-----------------------------*/
/* lagre tilrettelagt datasett */
/*-----------------------------*/
data skde20.LAB_&aar._T23; 
set lab_&aar._8;
run; 


/* ---------------------------------------------------- */
/* START DEL MED SUBSET (AGGREGERING PÅ DAG PR PASIENT) */
/* ---------------------------------------------------- */

/*nbr(id) på radene som skal transponeres - starter fra lab_aar_5*/
proc sort data=lab_&aar._5 nodupkey out=keepnbr(keep=nbr);
  by nbr;
  where dup eq 1;
run;

/* lage datasett med radene til transponering */
proc sql;
  create table to_transpose as 
  select nbr, nlkkoder, nlk_refusjon
  from lab_&aar._5
  where nbr in (select nbr from keepnbr);
quit;
      
title'antall rader som SKAL være i transponert datasett';
proc sql;
  select count(*) as ant_rader
  from keepnbr;
quit;
title;
      
/*transponere*/
proc transpose data=to_transpose out=results(drop=_name_) ; 
  by nbr;
  var nlkkoder;
run;
      
/*slå sammen transponerte variabler med alle nlkkoder fra en dag*/
data transposed;
  length allnlk $ 6230;  
  set results;

  allnlk="";
  array col  {*}  col: ;
  do i=1 to dim(col);
      allnlk=catx("/",allnlk,col{i}); /*catx strips leading and trailing blanks before concatenating, plus uses delimeter*/
  end;
transponert = 1;
drop i col:;
run;
      
/*splitt allnlk-variabel til en kode pr celle*/
data transposed2(rename= (allnlk=nlkkoder));
set transposed;
     
i=1;  *read counter;
j=1;  *write counter;
            array nlk2 {*} $ 10 nlkkode1-nlkkode566 ; *set length to 10 otherwise it gets chopped at 8;
              do until (i>566);
                /* read */
                           ith=scan(allnlk,i);     *the i-th string; 
                           kode=scan(ith,1,"x");     *nlk code to be written; 
                           ndup=scan(ith,2,"x")+0;   *value after x; 
                           /* write */
                           if ndup ne . then do; 
                             do k=1 to ndup;         *repeat writing ndup times; 
                               nlk2{j}=kode;
                                           j+1;      *increase the write counter;
                             end;
                           end;
                           else i=566;               *nothing to write, skip to the end of the loop;
    i+1;
              end;
drop i j k ith kode ndup;
run;

/*summere refusjon pr nbr(pr dag og pasient)*/
proc sql;	
	create table results2 as
	select nbr, sum(nlk_refusjon) as sum_ref
	from to_transpose
	group by nbr;
quit;

/* hente rader som skal kobles med transponerte variabler */
proc sql;
    create table subset as
    select distinct aar, pid, inndato, alder, ermann, bohf, borhf, boshhn, komnr, bydel, prove_id, nbr, dup
    from lab_&aar._5
    where dup eq 1;
quit;

/* noen har ulik komnr/bydel på prøve tatt samme dag, må derfor flagge en NBR pr dag */
proc sort data=subset; by nbr;run;
data subset2;
  set subset;
  by nbr;
    if first.nbr then nr = 1;
run;

/* kun ta unike rader ut - dvs velger en av radene uten hensyn til valg av komnr */
proc sql;
    create table subset3 as
    select *
    from subset2
    where nr eq 1;
quit;

/* sette sammen og lagre datasett hvor transponering er gjort */
proc sql;
  create table joined_subset as 
  select a.*, b.*,c.sum_ref
  from subset3 a
  left join transposed2 b
  on a.nbr=b.nbr
  left join results2 c
  on a.nbr=c.nbr;
quit;

title'antall rader som ER i transponert datasett';
proc sql;
  select count(*) as ant_rader
  from joined_subset;
quit;
title;

/* ---------------------------------------------------- */
/* telle opp antall koder i/utenfor refuasjonskategorier */
/* ---------------------------------------------------- */

/*proc transpose for å gjøre datasett langt*/
proc sort data=joined_subset;by prove_id;run;

data joined_subset2;
set joined_subset;
by prove_id;
if first.prove_id then nr_id = 0;
nr_id+1;
run;

proc sort data=joined_subset2;by prove_id nr_id;run;

proc transpose data=joined_subset2 out=joined_subset2_long(drop=_name_ where=(not missing(col1)));
by prove_id nr_id;
var nlkkode1-nlkkode566;
run;

proc sql;
	create table refkat2_runde2 as
	select a.*,b.refusjonskategori
	from joined_subset2_long a
	left join refkat b
	on a.col1=b.kode;
quit;

proc sql;
	create table refkat_sum_runde2 as
	select prove_id, nr_id, refusjonskategori,
					case when refusjonskategori eq "" then "sum_koder_miss" 
						else refusjonskategori end as refusjonskat,
					count(*) as ant
	from refkat2_runde2
	group by prove_id, nr_id, refusjonskategori;
quit;

proc transpose data=refkat_sum_runde2 out=refkat_sum_wide_runde2(drop=_name_);
by prove_id nr_id;
id refusjonskat;
run;

data refkat_sum_wide2_runde2;
  set refkat_sum_wide_runde2;
   array n {*} _numeric_;
   sum_koder_tot=sum(of n[*]) - sum(prove_id,nr_id);
   sum_koder_refkat=sum(of n[*]) - sum(prove_id,sum_koder_miss,nr_id);  
run;
  
proc sql;
	create table joined_subset3 as
	select a.*, b.*
	from joined_subset2 a
	left join refkat_sum_wide2_runde2 b
	on a.prove_id=b.prove_id and a.nr_id=b.nr_id;
quit;

  
%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";
    
data joined_subset3;
retain 
pid 
aar 
prove_id
dup
inndato
ermann
alder
komnr
bydel
bohf
borhf
boshhn
sum_ref
nlkkoder
sum_koder_tot
sum_koder_miss
sum_koder_refkat
nlkkode1-nlkkode566;
set joined_subset3;
/* sette på bo-formater */
format bohf bohf_fmt. borhf borhf_fmt. boshhn boshhn_fmt. bydel bydel_fmt.;
run;
          
/* sortere */
proc sort data=joined_subset3(drop=nbr nr nr_id);
by pid inndato;
run;

/* lagre tilrettelagt transponert datasett */
data skde20.LAB_&aar._transponert_T23; 
 set joined_subset3;
run; 

/* slette */
proc datasets nolist;
delete lab: tmp pid_alder mapping to_transpose keepnbr 
        results: transposed: subset: joined_subset: ref:;
run;
%mend tilrettelegging_lab;