%macro forholdstall;

data &forbruksmal._bohf;
set &forbruksmal._bohf;
antall=&forbruksmal+0;
if bohf ne 8888 then do;
	d=(max-min)/max;
	dnum=1;
end;
run;

proc sql;
   create table &forbruksmal._bohf as 
   select *, max(ratesnitt) as maks, min(ratesnitt) as minimum, sum(d) as dsum, sum(dnum) as dnumsum, count(bohf) as rader
   from &forbruksmal._bohf;
   quit;

data &forbruksmal._bohf;
set &forbruksmal._bohf;
ratesnitt2=ratesnitt;
Delta=dsum/dnumsum;
FT=round((maks/minimum),0.01);
/*IAnr=&ia_nr+&pluss;*/
length Utvalg $ 32;
Utvalg="&forbruksmal";
drop maks minimum dsum d dnum dnumsum;
run;

proc sort data=&forbruksmal._bohf;
by ratesnitt;
run;

data &forbruksmal._bohf;
set &forbruksmal._bohf;
rank+1;
run;

data &forbruksmal._bohf;
set &forbruksmal._bohf;
if rank=2 then min2=ratesnitt;
if rank=rader-1 then max2=ratesnitt;
if rank=3 then min3=ratesnitt;
if rank=rader-1 then max3=ratesnitt;
run;

proc sql;
   create table &forbruksmal._bohf as 
   select *, max(min2) as mmin2, max(max2) as mmax2, max(min3) as mmin3, max(max3) as mmax3
   from &forbruksmal._bohf;
quit;

data &forbruksmal._bohf;
set &forbruksmal._bohf;
FT2=round((mmax2/mmin2),0.01);
FT3=round((mmax3/mmin3),0.01);
drop min2 min3 max2 max3 mm:;
run;

%tabell;
%mend forholdstall;