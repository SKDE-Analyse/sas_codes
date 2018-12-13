%macro forholdstall (ds=&forbruksmal._bohf, nkrav=&nkrav);

/*Lager kopi av inndatasett, navner om variabel som gir antall obs*/
data &ds._to;
set &ds;
antall=&forbruksmal+0;
/*if bohf ne 8888 then do;
	d=(max-min)/max;
	dnum=1;
end;*/
run;

/*proc sql;
   create table &ds._to as 
   select *, count(bohf) as rader, max(ratesnitt) as maks, min(ratesnitt) as minimum, sum(d) as dsum, sum(dnum) as dnumsum
   from &ds._to;
   quit;*/

/*Lager ny variabel for ratesnitt så vi beholder verdiene for bohf med få observasjoner*/
data &ds._to;
set &ds._to;
ratesnitt2=ratesnitt;
*Delta=dsum/dnumsum;
*FT=round((maks/minimum),0.01);
length Utvalg $ 32;
Utvalg="&forbruksmal";
drop maks minimum;* dsum d dnum dnumsum;
run;

proc sort data=&ds._to;
by ratesnitt;
run;

/*Lager datasett hvor kun opptaksområder med antall obs som overstiger &nkrav er med*/
/*Lager rank variabel som angir bohf med høyeste/laveste rate*/
data &ds._FT;
set &ds._to;
where antall ge &nkrav;
rank+1;
run;

/*Teller antall rader i datasettet i ny variabel "rader"*/
proc sql;
   create table &ds._FT as 
   select *, count(bohf) as rader 
   from &ds._FT;
   quit;

/*Beregner forholdstall*/
data &ds._FT;
set &ds._FT;
if rank=1 then min1=ratesnitt;
if rank=rader then max1=ratesnitt;
if rank=2 then min2=ratesnitt;
if rank=rader-1 then max2=ratesnitt;
if rank=3 then min3=ratesnitt;
if rank=rader-2 then max3=ratesnitt;
run;

proc sql;
   create table &ds._FT as 
   select *, max(min1) as mmin1, max(max1) as mmax1, max(min2) as mmin2, max(max2) as mmax2, max(min3) as mmin3, max(max3) as mmax3
   from &ds._FT;
quit;

data &ds._FT;
set &ds._FT;
FT=round((mmax1/mmin1),0.01);
FT2=round((mmax2/mmin2),0.01);
FT3=round((mmax3/mmin3),0.01);
keep bohf FT FT2 FT3;
run;

/*Setter sammen modifisert inndatasett og datasett med forholdstall*/
proc sort data=&ds._FT;
by bohf;
quit;

proc sort data=&ds._to;
by bohf;
quit;

data &ds;
merge &ds._to &ds._FT;
by bohf;
run;

/*Sorterer etter antall for å fylle inn FT der hvor verdien mangler (BoHF med få obs)*/
proc sort data=&ds;
by descending antall;
quit;

data &ds;
set &ds;
retain prevFT prevFT2 prevFT3;

if FT ne . then prevFT=FT;
else FT=prevFT; 

if FT2 ne . then prevFT2=FT2;
else FT2=prevFT2; 

if FT3 ne . then prevFT3=FT3;
else FT3=prevFT3; 
run;

proc sort data=&ds;
by ratesnitt;
run;

proc datasets nolist;
delete &ds._to &ds._FT;
run;

%oversiktstabell_helseatlas;

%mend forholdstall;
