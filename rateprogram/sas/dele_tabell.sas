/* When running rateprogram with ut_sett=1, it creates a large table that contains unadjusted rates, sex/age adjusted rates, and indirect adjusted rates.
   This macro takes it (&forbruksmal._S_BOHF) and the national average (&forbruksmal._NORGE) and creates 3 tables for each of the rates.
   It is to be used as the last step of rateberegninger, and before forholdstall.

   INN: &forbruksmal._S_BOHF
        &forbruksmal._NORGE
   OUT: &forbruksmal._JUST._BOHF  (sex/age adjusted)
        &forbruksmal._UJUST._BOHF (unadjusted)
        &forbruksmal._IJUST._BOHF (indirect adjusted)

update: 03/02/2020 JS - change the input argument niva for macro dele from hardcoding 'bohf' to using the dynamic bo niv� '&bo' that gets passed in from the main program

update: 28/09/2020 JS - use left join rather than inner join to create ijust, ujust, and just files so that all omr�de with snitt present in all the tables
*/

%macro dele_tabell;

%macro dele(just=, niva=&bo);
/*LAGER DATASETT MED JUSTERTE RATER*/
%if &just=just %then %do;
%let rv_var=RV_just_rate;
%end;
%if &just=ujust %then %do;
%let rv_var=RV_rate;
%end;
%if &just=ijust %then %do;
%let rv_var=RV_ijust_rate;
%end;


%if &antall_aar=2 %then %do;

data &forbruksmal._tmp&�r1 (drop=           ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&�r1, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1) as min, max(Rate&�r1) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmpSN d
  where a.&niva=d.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=3 %then %do;

data &forbruksmal._tmp&�r1 (drop=          rate&�r2.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r2 (drop=rate&�r1.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1. rate&�r2.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else if aar=&�r2 then rate&�r2=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=&�r2 then output &forbruksmal._tmp&�r2.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&�r1, Rate&�r2, Rate&�r3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3) as min, max(Rate&�r1,Rate&�r2,Rate&�r3) as max
  from &forbruksmal._tmpSN d 
  
  left join &forbruksmal._tmp&�r1 a
  on d.&niva=a.&niva

  left join &forbruksmal._tmp&�r2 b
  on d.&niva=b.&niva

  left join &forbruksmal._tmp&�r3 c
  on d.&niva=c.&niva

  order by Ratesnitt2 desc;
quit;

%end;

%if &antall_aar=4 %then %do;

data &forbruksmal._tmp&�r1 (drop=          rate&�r2. rate&�r3.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r2 (drop=rate&�r1.           rate&�r3.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r3 (drop=rate&�r1. rate&�r2.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1. rate&�r2. rate&�r3.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else if aar=&�r2 then rate&�r2=&rv_var;
else if aar=&�r3 then rate&�r3=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=&�r2 then output &forbruksmal._tmp&�r2.;
else if aar=&�r3 then output &forbruksmal._tmp&�r3.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&�r1, Rate&�r2, Rate&�r3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3) as min, max(Rate&�r1,Rate&�r2,Rate&�r3) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmp&�r2 b, &forbruksmal._tmp&�r3 c, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=5 %then %do;


data &forbruksmal._tmp&�r1 (drop=          rate&�r2. rate&�r3. rate&�r4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r2 (drop=rate&�r1.           rate&�r3. rate&�r4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r3 (drop=rate&�r1. rate&�r2.           rate&�r4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r4 (drop=rate&�r1. rate&�r2. rate&�r3.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1. rate&�r2. rate&�r3. rate&�r4.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else if aar=&�r2 then rate&�r2=&rv_var;
else if aar=&�r3 then rate&�r3=&rv_var;
else if aar=&�r4 then rate&�r4=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=&�r2 then output &forbruksmal._tmp&�r2.;
else if aar=&�r3 then output &forbruksmal._tmp&�r3.;
else if aar=&�r4 then output &forbruksmal._tmp&�r4.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&�r1, Rate&�r2, Rate&�r3, Rate&�r4, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3, Rate&�r4) as min, max(Rate&�r1,Rate&�r2,Rate&�r3, Rate&�r4) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmp&�r2 b, &forbruksmal._tmp&�r3 c, &forbruksmal._tmp&�r4 e, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva=e.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=6 %then %do;


data &forbruksmal._tmp&�r1 (drop=          rate&�r2. rate&�r3. rate&�r4. rate&�r5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r2 (drop=rate&�r1.           rate&�r3. rate&�r4. rate&�r5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r3 (drop=rate&�r1. rate&�r2.           rate&�r4. rate&�r5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r4 (drop=rate&�r1. rate&�r2. rate&�r3.           rate&�r5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r5 (drop=rate&�r1. rate&�r2. rate&�r3. rate&�r4.           ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1. rate&�r2. rate&�r3. rate&�r4. rate&�r5. )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else if aar=&�r2 then rate&�r2=&rv_var;
else if aar=&�r3 then rate&�r3=&rv_var;
else if aar=&�r4 then rate&�r4=&rv_var;
else if aar=&�r5 then rate&�r5=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=&�r2 then output &forbruksmal._tmp&�r2.;
else if aar=&�r3 then output &forbruksmal._tmp&�r3.;
else if aar=&�r4 then output &forbruksmal._tmp&�r4.;
else if aar=&�r5 then output &forbruksmal._tmp&�r5.;
else if aar=9999 then output &forbruksmal._tmpSN;

format Innbyggere NLnum12.0 &forbruksmal NLnum12.0;
run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&�r1, Rate&�r2, Rate&�r3, Rate&�r4, Rate&�r5, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3, Rate&�r4, Rate&�r5) as min, max(Rate&�r1,Rate&�r2,Rate&�r3, Rate&�r4, Rate&�r5) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmp&�r2 b, &forbruksmal._tmp&�r3 c, &forbruksmal._tmp&�r4 e, &forbruksmal._tmp&�r5 f, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva=e.&niva=f.&niva
  order by Ratesnitt2 desc;
quit;
%end;
/*if anything else, then take the first 3 years */
/*
%else %do;  
proc sql;
  create table  &forbruksmal._&just._BOHF as
  select d.bohf, Rate&�r1, Rate&�r2, Rate&�r3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3) as min, max(Rate&�r1,Rate&�r2,Rate&�r3) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmp&�r2 b, &forbruksmal._tmp&�r3 c, &forbruksmal._tmpSN d
  where a.bohf=b.bohf=c.bohf=d.bohf
  order by Ratesnitt2 desc;
quit;
%end;
*/
%mend dele;

%dele(just=just);
%dele(just=ijust);
%dele(just=ujust);


proc datasets lib=work nolist;
  delete &forbruksmal._tmp:;
quit;

%mend dele_tabell;