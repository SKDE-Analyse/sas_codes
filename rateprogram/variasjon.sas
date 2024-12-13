
/*Utdata med variasjonsmål*/
/*
Opprettet 13/12-24, Frank Olsen
Bruker følgende datasett fra standard_rate-programmet:
deleteme_ratedata
deleteme_pop_in_region 
deleteme_summed_vars
*/

%macro variasjon_tabell(bo=, ratevar=, std_year=, antvar=);  

/*CV*/
data xyz_cvN;
set deleteme_ratedata;
keep aar &ratevar;
where &bo = 8888;
run;

proc sql;
create table xyz_tmp_cv as
select *,
count(&bo) as ant_i,
&ratevar-(sum(&ratevar)/count(&bo)) as teller,
sum(&ratevar) as ratesum
from deleteme_ratedata
where &bo ne 8888
group by aar;
quit;

proc sql;
create table xyz_cv as
select distinct
aar,ant_i,
100*(sqrt(sum(teller**2)/(ant_i-1)) / (ratesum/ant_i)) as CV
from xyz_tmp_cv
group by aar;
quit;

/*Forholdstall*/
/* Step 1: Rank the rates within each year */
proc rank data=xyz_tmp_cv out=xyz_ranked_test ties=low descending;
    by aar;
    var &ratevar;
    ranks rank_rate;
run;

/* Step 2: Rank the rates within each year in ascending order */
proc rank data=xyz_tmp_cv out=xyz_ranked_asc_test ties=low;
    by aar;
    var &ratevar;
    ranks rank_rate_asc;
run;

/* Step 3: Combine the ranked datasets and calculate the required values */
proc sql;
create table xyz_test_ft as
select 
    a.aar,
	max(a.&ratevar)/min(a.&ratevar) as FT1,
	b.&ratevar / c.&ratevar as FT2,
	d.&ratevar / e.&ratevar as FT3,
    max(a.&ratevar) as maksrate,
    min(a.&ratevar) as minrate,
    put((select &bo from xyz_tmp_cv as b where b.aar = a.aar and b.&ratevar = (select max(&ratevar) from xyz_tmp_cv where aar = a.aar)), &bo._fmt.) as maxbo,
    put((select &bo from xyz_tmp_cv as c where c.aar = a.aar and c.&ratevar = (select min(&ratevar) from xyz_tmp_cv where aar = a.aar)), &bo._fmt.) as minbo,
    b.&ratevar as max2rate,
    c.&ratevar as min2rate,
	put(b.&bo, &bo._fmt.) as max2bo,
    put(c.&bo, &bo._fmt.) as min2bo,	
	d.&ratevar as max3rate,
    e.&ratevar as min3rate,    
	put(d.&bo, &bo._fmt.) as max3bo,
    put(e.&bo, &bo._fmt.) as min3bo  
from xyz_tmp_cv as a
left join xyz_ranked_test as b on a.aar = b.aar and b.rank_rate = 2
left join xyz_ranked_asc_test as c on a.aar = c.aar and c.rank_rate_asc = 2
left join xyz_ranked_test as d on a.aar = d.aar and d.rank_rate = 3
left join xyz_ranked_asc_test as e on a.aar = e.aar and e.rank_rate_asc = 3
group by a.aar;
quit;

proc sql;
create table xyz_test_ft as
select distinct *
from xyz_test_ft;
quit;

/*SCV*/
proc sort data=deleteme_pop_in_region;
by aar bohf age_group ermann;
run;
proc sort data=deleteme_summed_vars;
by aar bohf age_group ermann;
run;

data xyz_ratedata;
merge deleteme_pop_in_region deleteme_summed_vars;
by aar bohf age_group ermann;
run; 

proc sql;
create table xyz_tmp_scv0 as 
select age_group, ermann,
sum(&antvar)/sum(population) as rjk
from xyz_ratedata
where &bo ne 8888 and aar=&std_year
group by age_group, ermann;
quit;

proc sql;
create table xyz_tmp_scv1 as 
select aar, &bo, age_group, ermann,
sum(population) as pop,
sum(&antvar) as antall
from xyz_ratedata 
where &bo ne 8888
group by aar, &bo, age_group, ermann;
quit;

proc sql;
create table xyz_tmp_scv as
select a.*, b.rjk
from xyz_tmp_scv1 as a
left join xyz_tmp_scv0 as b
on a.age_group=b.age_group and a.ermann=b.ermann;
quit;

proc sql;
create table xyz_scv as 
select aar, &bo,
sum(antall) as y_i,
sum(pop) as n_i,
sum(pop*rjk) as e_i
from xyz_tmp_scv
group by aar, &bo;
quit;

proc sql;
create table xyz_scv as 
select *,
count(&bo) as ant_i,
sum(y_i) as events,
sum(n_i) as population
from xyz_scv
group by aar;
quit;

proc sql;
create table xyz_scv_aar as 
select distinct
aar, events, population,
(1/ant_i) * ( sum(((y_i-e_i)**2)/(e_i**2)) - (sum(1/e_i)))*100 as SCV,
sum(e_i) as expected
from xyz_scv
group by aar;
quit;

data tmp_variasjon_&var;
merge xyz_cvN xyz_cv xyz_scv_aar xyz_test_ft;
by aar;
run;

data tmp_variasjon_&var;
set tmp_variasjon_&var;
ratevar="&var";
rename &ratevar=rate;
run;

data tmp_variasjon_&var;
    retain aar ratevar rate ant_i population events expected;
set tmp_variasjon_&var;
run;

proc datasets nolist; delete xyz_:; run;

%mend variasjon_tabell;

%macro run_variasjons_tabell;
%do std_i=1 %to &std_numvars;
    %let var = %scan(&std_varlist, &std_i);
    %variasjon_tabell(bo=&region, ratevar=&var._rate, std_year=&std_year, antvar=&var); 
%end;
%mend run_variasjons_tabell;

%run_variasjons_tabell;

/*stable tabellene*/
data variasjon;
    set tmp_variasjon:;
run;    

/*slett datasett*/
proc datasets nolist; delete tmp_:; run;  