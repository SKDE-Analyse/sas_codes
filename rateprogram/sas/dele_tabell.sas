/* When running rateprogram with ut_sett=1, it creates a large table that contains unadjusted rates, sex/age adjusted rates, and indirect adjusted rates.
   This macro takes it (&forbruksmal._S_BOHF) and the national average (&forbruksmal._NORGE) and creates 3 tables for each of the rates.
   It is to be used as the last step of rateberegninger, and before forholdstall.

   INN: &forbruksmal._S_BOHF
        &forbruksmal._NORGE
   OUT: &forbruksmal._JUST._BOHF  (sex/age adjusted)
        &forbruksmal._UJUST._BOHF (unadjusted)
        &forbruksmal._IJUST._BOHF (indirect adjusted)
*/

%macro dele_tabell;

%macro dele(just=);
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


data &forbruksmal._tmp&�r1 (drop=rate&�r2. rate&�r3. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r2 (drop=rate&�r1. rate&�r3. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&�r3 (drop=rate&�r1. rate&�r2. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&�r1. rate&�r2. rate&�r3.)  ;
set &forbruksmal._s_bohf(in=a) &forbruksmal._NORGE(in=b);

if b then bohf=8888;

if aar=&�r1 then rate&�r1=&rv_var;
else if aar=&�r2 then rate&�r2=&rv_var;
else if aar=&�r3 then rate&�r3=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if bohf=8888 then SnittRate=RateSnitt;

if aar=&�r1 then output &forbruksmal._tmp&�r1.;
else if aar=&�r2 then output &forbruksmal._tmp&�r2.;
else if aar=&�r3 then output &forbruksmal._tmp&�r3.;
else output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._BOHF as
  select d.bohf, Rate&�r1, Rate&�r2, Rate&�r3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&�r1,Rate&�r2,Rate&�r3) as min, max(Rate&�r1,Rate&�r2,Rate&�r3) as max
  from &forbruksmal._tmp&�r1 a, &forbruksmal._tmp&�r2 b, &forbruksmal._tmp&�r3 c, &forbruksmal._tmpSN d
  where a.bohf=b.bohf=c.bohf=d.bohf
  order by Ratesnitt2 desc;
quit;

%mend dele;

%dele(just=just);
%dele(just=ijust);
%dele(just=ujust);




proc delete data=&forbruksmal._tmp&�r1 &forbruksmal._tmp&�r2 &forbruksmal._tmp&�r3 &forbruksmal._tmpSN;
run;

%mend dele_tabell;