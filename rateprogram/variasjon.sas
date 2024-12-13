
/*Utdata med variasjonsmål*/
/*
Opprettet 13/12-24, Frank Olsen
Bruker følgende datasett fra standard_rate-programmet:
deleteme_ratedata
deleteme_pop_in_region 
deleteme_summed_vars
*/
%macro variasjon(ratedata, pop_in_region, summed_vars, varlist, region);

%macro variasjon_tabell(ratevar=, std_year=, variable=);  

/*CV*/
data xyz_cvN;
    set &ratedata;
    keep aar &ratevar;
    where &region = 8888;
run;

proc sql;
    create table xyz_tmp_cv as
    select *,
    count(&region) as ant_i,
    &ratevar-(sum(&ratevar)/count(&region)) as teller,
    sum(&ratevar) as ratesum
    from &ratedata
    where &region ne 8888
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
    put((select &region from xyz_tmp_cv as b where b.aar = a.aar and b.&ratevar = (select max(&ratevar) from xyz_tmp_cv where aar = a.aar)), &region._fmt.) as maxbo,
    put((select &region from xyz_tmp_cv as c where c.aar = a.aar and c.&ratevar = (select min(&ratevar) from xyz_tmp_cv where aar = a.aar)), &region._fmt.) as minbo,
    b.&ratevar as max2rate,
    c.&ratevar as min2rate,
	put(b.&region, &region._fmt.) as max2bo,
    put(c.&region, &region._fmt.) as min2bo,	
	d.&ratevar as max3rate,
    e.&ratevar as min3rate,    
	put(d.&region, &region._fmt.) as max3bo,
    put(e.&region, &region._fmt.) as min3bo  
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
proc sort data=&pop_in_region;
    by aar bohf age_group ermann;
run;
proc sort data=&summed_vars;
    by aar bohf age_group ermann;
run;

data xyz_ratedata;
    merge &pop_in_region &summed_vars;
    by aar bohf age_group ermann;
run; 

proc sql;
create table xyz_tmp_scv0 as 
    select age_group, ermann,
           sum(&variable)/sum(population) as rjk
    from xyz_ratedata
    where &region ne 8888 and aar=&std_year
    group by age_group, ermann;
quit;

proc sql;
create table xyz_tmp_scv1 as 
    select aar, &region, age_group, ermann,
    sum(population) as pop,
    sum(&variable) as antall
    from xyz_ratedata 
    where &region ne 8888
    group by aar, &region, age_group, ermann;
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
    select aar, &region,
    sum(antall) as y_i,
    sum(pop) as n_i,
    sum(pop*rjk) as e_i
    from xyz_tmp_scv
    group by aar, &region;
quit;

proc sql;
create table xyz_scv as 
    select *,
    count(&region) as ant_i,
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

data tmp_variasjon_&variable;
    merge xyz_cvN xyz_cv xyz_scv_aar xyz_test_ft;
    by aar;
run;

data tmp_variasjon_&variable;
    set tmp_variasjon_&variable;
    ratevar="&variable";
    rename &ratevar=rate;
run;

data tmp_variasjon_&variable;
    retain aar ratevar rate ant_i population events expected;
    set tmp_variasjon_&variable;
run;

proc datasets nolist; delete xyz_:; run;

%mend variasjon_tabell;

%do variasjon_i=1 %to %sysfunc(countw(&varlist));
    %variasjon_tabell(
        ratevar=&var._rate,
        std_year=&std_year,
        variable=%scan(&varlist, &variasjon_i)
    );
%end;

/*stable tabellene*/
data variasjon;
    set tmp_variasjon:;
run;    

/*slett datasett*/
proc datasets nolist; delete tmp_:; run;

%mend variasjon;