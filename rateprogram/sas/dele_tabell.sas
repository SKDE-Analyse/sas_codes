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


data &forbruksmal._tmp&År1 (drop=rate&År2. rate&År3. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År2 (drop=rate&År1. rate&År3. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmp&År3 (drop=rate&År1. rate&År2. ratesnitt ratesnitt2 snittrate)
     &forbruksmal._tmpSN    (drop=rate&År1. rate&År2. rate&År3.)  ;
set &forbruksmal._s_bohf(in=a) &forbruksmal._NORGE(in=b);

if b then bohf=8888;

if aar=&År1 then rate&År1=&rv_var;
else if aar=&År2 then rate&År2=&rv_var;
else if aar=&År3 then rate&År3=&rv_var;
else RateSnitt=&rv_var;

RateSnitt2=RateSnitt;
Innbyggere=Ant_Innbyggere;
&forbruksmal=Ant_Opphold;

if bohf=8888 then SnittRate=RateSnitt;

if aar=&År1 then output &forbruksmal._tmp&År1.;
else if aar=&År2 then output &forbruksmal._tmp&År2.;
else if aar=&År3 then output &forbruksmal._tmp&År3.;
else output &forbruksmal._tmpSN;

run;

proc sql;
  create table  &forbruksmal._&just._BOHF as
  select d.bohf, Rate&År1, Rate&År2, Rate&År3, Ratesnitt, Ratesnitt2, d.Innbyggere, d.&forbruksmal, SnittRate,
         min(Rate&År1,Rate&År2,Rate&År3) as min, max(Rate&År1,Rate&År2,Rate&År3) as max
  from &forbruksmal._tmp&År1 a, &forbruksmal._tmp&År2 b, &forbruksmal._tmp&År3 c, &forbruksmal._tmpSN d
  where a.bohf=b.bohf=c.bohf=d.bohf
  order by Ratesnitt2 desc;
quit;

%mend dele;

%dele(just=just);
%dele(just=ijust);
%dele(just=ujust);




proc delete data=&forbruksmal._tmp&År1 &forbruksmal._tmp&År2 &forbruksmal._tmp&År3 &forbruksmal._tmpSN;
run;

%mend dele_tabell;