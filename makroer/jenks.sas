%macro jenks(dsnin=, dsnout=, clusters=, breaks=, var=ratesnitt);

/*!
Makro for å lage Jenks natural breaks, til bruk i helseatlas-kart.

Bruker SAS-prosedyren [fastclus](https://support.sas.com/documentation/onlinedoc/stat/132/fastclus.pdf). Kjøres som
```sas
jenks(dsnin=<datasett inn>, dsnout=<datasett ut>, clusters=<antall clusters>, breaks=<antall brudd (clusters - 1)>, var=<variabel>);
```

Laget av Frank Olsen i forbindelse med Kroniker-atlaset.
*/

/*clusters=breaks+1*/
data jenks1;
set &dsnin;
keep bohf &var;
where bohf lt 999;  /* Ta ut Norge, som pleier å være 8888 eller lignende */
run;

proc sort data=jenks1;
by &var;
run;

proc fastclus data=jenks1 out=jenks2 maxclusters=&clusters noprint;
   var &var;
run;

proc sql;
create table jenks2a as
select *, 
	(select count(b.cluster) from jenks2 as b
		where b.&var<=a.&var and a.cluster=b.cluster)
	as kluster
from jenks2 as a
group by cluster
order by &var;
quit;

data jenks2a;
set jenks2a;
where kluster=1;
run;

proc sort data=jenks2a;
by &var;
run;

data jenks2a;
set jenks2a;
nr=_N_;
run;

proc sql;
create table jenks2b as
select a.bohf,a.&var,b.nr
from jenks2 as a left join jenks2a as b
on a.cluster=b.cluster;
quit;

data jenks2b;
set jenks2b;
rename nr=cluster;
run;

proc sort data=jenks2b;
by &var;
run;

proc means data=jenks2b noprint;
var &var;
class cluster;
output out=jenks3 max=max min=min;
run;

data jenks3;
set jenks3;
keep max min cluster;
where cluster ne .;
run;

proc sort data=jenks3;
by descending max;
run;

data jenks3;
set jenks3;
lag_min=lag(min);
grense=(max+lag_min)/2;
run;

proc sort data=jenks3;
by cluster;
run;

data &dsnout;
set jenks3;
where cluster in (1:&breaks);
run;

proc datasets nolist;
delete jenks:;
run;

%mend jenks;