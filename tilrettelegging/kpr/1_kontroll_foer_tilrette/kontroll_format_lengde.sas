/*************************************************/
/*lik lengde og format på tvers av år i lik kilde*/
/*************************************************/

%macro kontroll_format_lengde;

/* hente ut lengde, format og type med proc content */
proc contents data=&mappe..&prefix._&sektor._2017_&suffix. noprint out=&sektor.17(keep=name length format type);run;
proc contents data=&mappe..&prefix._&sektor._2018_&suffix. noprint out=&sektor.18(keep=name length format type);run;
proc contents data=&mappe..&prefix._&sektor._2019_&suffix. noprint out=&sektor.19(keep=name length format type);run;
proc contents data=&mappe..&prefix._&sektor._2020_&suffix. noprint out=&sektor.20(keep=name length format type);run;
proc contents data=&mappe..&prefix._&sektor._2021_&suffix. noprint out=&sektor.21(keep=name length format type);run;

/*stable datasettene*/
data stable_&sektor. (keep=name);
set &sektor.17 &sektor.18 &sektor.19 &sektor.20 &sektor.21;
run;

/*ta ut unike navn*/
proc sort data=stable_&sektor. nodupkey out=unike_navn_&sektor.;
by name;
run;

/*koble på lengde, format, type fra de ulike årene*/
proc sql;
	create table felles_lengde_&sektor. as 
	select a.name, 
					b.length as length17, b.format as format17, b.type as type17,
                    c.length as length18, c.format as format18, c.type as type18,
                    d.length as length19, d.format as format19, d.type as type19,
                    e.length as length20, e.format as format20, e.type as type20,
                    f.length as length21, f.format as format21, f.type as type21,
		case when   length17 eq length18 and 
                    length17 eq length19 and 
                    length17 eq length20 and 
                    length17 eq length21 then 1 end as lik_lengde,
		case when   format17 eq format18 and 
                    format17 eq format19 and 
                    format17 eq format20 and 
                    format17 eq format21 then 1 end as lik_format,
        case when   type17 eq type18 and
                    type17 eq type19 and
                    type17 eq type20 and 
                    type17 eq type21 then 1 end as lik_type
	from unike_navn_&sektor. a
	left join &sektor.17 b
	on a.name= b.name
	left join &sektor.18 c
	on a.name=c.name
	left join &sektor.19 d
	on a.name=d.name
	left join &sektor.20 e
	on a.name=e.name
    left join &sektor.21 f
    on a.name=f.name
	;
quit;
/* slette datasettene */
proc delete data=&sektor.17 &sektor.18 &sektor.19 &sektor.20 &sektor.21 stable_&sektor. unike_navn_&sektor.;run;
/* lage datasett med avvikene */
proc sql;
    create table avvik_&sektor. as
    select *
    from felles_lengde_&sektor.
    where lik_lengde ne 1 or lik_format ne 1 or lik_type ne 1
%mend kontroll_format_lengde;
