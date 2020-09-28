/* When running rateprogram with ut_sett=1, it creates a large table that contains unadjusted rates, sex/age adjusted rates, and indirect adjusted rates.
   This macro takes it (&forbruksmal._S_BOHF) and the national average (&forbruksmal._NORGE) and creates 3 tables for each of the rates.
   It is to be used as the last step of rateberegninger, and before forholdstall.

   INN: &forbruksmal._S_BOHF
        &forbruksmal._NORGE
   OUT: &forbruksmal._JUST._BOHF  (sex/age adjusted)
        &forbruksmal._UJUST._BOHF (unadjusted)
        &forbruksmal._IJUST._BOHF (indirect adjusted)

update: 03/02/2020 JS - change the input argument niva for macro dele from hardcoding 'bohf' to using the dynamic bo nivå '&bo' that gets passed in from the main program

update: 28/09/2020 JS - use left join rather than inner join to create ijust, ujust, and just files so that all område with snitt present in all the tables
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

data &forbruksmal._tmp&År1 (drop=           ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&År1 then rate&År1=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&År1, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1) as min, max(Rate&År1) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmpSN d
  where a.&niva=d.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=3 %then %do;

data &forbruksmal._tmp&År1 (drop=          rate&År2.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År2 (drop=rate&År1.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1. rate&År2.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&År1 then rate&År1=&rv_var;
else if aar=&År2 then rate&År2=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=&År2 then output &forbruksmal._tmp&År2.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&År1, Rate&År2, Rate&År3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3) as min, max(Rate&År1,Rate&År2,Rate&År3) as max
  from &forbruksmal._tmpSN d 
  
  left join &forbruksmal._tmp&År1 a
  on d.&niva=a.&niva

  left join &forbruksmal._tmp&År2 b
  on d.&niva=b.&niva

  left join &forbruksmal._tmp&År3 c
  on d.&niva=c.&niva

  order by Ratesnitt2 desc;
quit;

%end;

%if &antall_aar=4 %then %do;

data &forbruksmal._tmp&År1 (drop=          rate&År2. rate&År3.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År2 (drop=rate&År1.           rate&År3.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År3 (drop=rate&År1. rate&År2.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1. rate&År2. rate&År3.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&År1 then rate&År1=&rv_var;
else if aar=&År2 then rate&År2=&rv_var;
else if aar=&År3 then rate&År3=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=&År2 then output &forbruksmal._tmp&År2.;
else if aar=&År3 then output &forbruksmal._tmp&År3.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&År1, Rate&År2, Rate&År3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3) as min, max(Rate&År1,Rate&År2,Rate&År3) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmp&År2 b, &forbruksmal._tmp&År3 c, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=5 %then %do;


data &forbruksmal._tmp&År1 (drop=          rate&År2. rate&År3. rate&År4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År2 (drop=rate&År1.           rate&År3. rate&År4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År3 (drop=rate&År1. rate&År2.           rate&År4.  ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År4 (drop=rate&År1. rate&År2. rate&År3.            ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1. rate&År2. rate&År3. rate&År4.  )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&År1 then rate&År1=&rv_var;
else if aar=&År2 then rate&År2=&rv_var;
else if aar=&År3 then rate&År3=&rv_var;
else if aar=&År4 then rate&År4=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=&År2 then output &forbruksmal._tmp&År2.;
else if aar=&År3 then output &forbruksmal._tmp&År3.;
else if aar=&År4 then output &forbruksmal._tmp&År4.;
else if aar=9999 then output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&År1, Rate&År2, Rate&År3, Rate&År4, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3, Rate&År4) as min, max(Rate&År1,Rate&År2,Rate&År3, Rate&År4) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmp&År2 b, &forbruksmal._tmp&År3 c, &forbruksmal._tmp&År4 e, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva=e.&niva
  order by Ratesnitt2 desc;
quit;
%end;

%if &antall_aar=6 %then %do;


data &forbruksmal._tmp&År1 (drop=          rate&År2. rate&År3. rate&År4. rate&År5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År2 (drop=rate&År1.           rate&År3. rate&År4. rate&År5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År3 (drop=rate&År1. rate&År2.           rate&År4. rate&År5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År4 (drop=rate&År1. rate&År2. rate&År3.           rate&År5. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År5 (drop=rate&År1. rate&År2. rate&År3. rate&År4.           ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1. rate&År2. rate&År3. rate&År4. rate&År5. )  ;
set &forbruksmal._s_&niva(in=a) &forbruksmal._NORGE(in=b);

if b then &niva=8888;

if aar=&År1 then rate&År1=&rv_var;
else if aar=&År2 then rate&År2=&rv_var;
else if aar=&År3 then rate&År3=&rv_var;
else if aar=&År4 then rate&År4=&rv_var;
else if aar=&År5 then rate&År5=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if &niva=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=&År2 then output &forbruksmal._tmp&År2.;
else if aar=&År3 then output &forbruksmal._tmp&År3.;
else if aar=&År4 then output &forbruksmal._tmp&År4.;
else if aar=&År5 then output &forbruksmal._tmp&År5.;
else if aar=9999 then output &forbruksmal._tmpSN;

format Innbyggere NLnum12.0 &forbruksmal NLnum12.0;
run;

proc sql;
  create table  &forbruksmal._&just._&niva as
  select d.&niva, Rate&År1, Rate&År2, Rate&År3, Rate&År4, Rate&År5, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3, Rate&År4, Rate&År5) as min, max(Rate&År1,Rate&År2,Rate&År3, Rate&År4, Rate&År5) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmp&År2 b, &forbruksmal._tmp&År3 c, &forbruksmal._tmp&År4 e, &forbruksmal._tmp&År5 f, &forbruksmal._tmpSN d
  where a.&niva=b.&niva=c.&niva=d.&niva=e.&niva=f.&niva
  order by Ratesnitt2 desc;
quit;
%end;
/*if anything else, then take the first 3 years */
/*
%else %do;  
proc sql;
  create table  &forbruksmal._&just._BOHF as
  select d.bohf, Rate&År1, Rate&År2, Rate&År3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3) as min, max(Rate&År1,Rate&År2,Rate&År3) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmp&År2 b, &forbruksmal._tmp&År3 c, &forbruksmal._tmpSN d
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