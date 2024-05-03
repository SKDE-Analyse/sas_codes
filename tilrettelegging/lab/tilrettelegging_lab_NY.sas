%macro tilrettelegging_lab_ny(inndata=, aar=);
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
          - LAB_&aar.
          - 
    
    ### Endringslogg:
        - Opprettet juli 2023, Tove J
        - Justert mai 2024, Tove J
     */



     /* PLAN FOR TILRETTELEGGING 
     
     1) lage variabel prove_id
     2) splitte nlk-koder
      a) lage langt datasett
      b) kun behold MB-nlkkoder
     3) demografi pr prove_id
      a) omkode komnr/bydel -> Lage bo-variabler
      b) off/priv pr nlk, evnt refusjon pr nlk

     4) omkode behandler komnr?

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
%if &aar=2023 %then %do; %let start = 60000000; %end;
      
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
data skde20.LAB_&aar.; 
set lab_&aar._8;
run; 


/* slette */
proc datasets nolist;
delete lab: tmp pid_alder mapping to_transpose keepnbr 
        results: transposed: subset: joined_subset: ref:;
run;
%mend tilrettelegging_lab_ny;