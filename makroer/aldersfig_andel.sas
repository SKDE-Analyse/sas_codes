/* Lager aldersfigur for andel befolkningen i alderen
   opprettet av Frank Olsen 2023
   redigert av Janice Shu 2024
   Lagt til main mai 2024 */

%macro aldersfig_andel(
dsn=,
rate_var=,
slutt=2022,
start=2018,
bo=bohf,
innbygg_dsn=innbygg.INNB_SKDE_BYDEL,
alder_min=0,
alder_max=95,
kunermann=,
bodef_indreoslo=0,
bodef_bydel=1,
utfig=,
json=0 /*skriv ut til helseatl mappe for å lage json fil*/,
pos=topright,
test=0
);

proc sql;
	create table xyz_ald_agg as
	select aar, bohf, ermann, alder, 
			count(case when &rate_var eq 1 then 1 end) as antall, 
		    count(distinct(case when &rate_var then pid end)) as unik
	from &dsn
	where &bo ne . and alder in (&alder_min:&alder_max)
	group by aar, &bo, ermann, alder;
quit;

/*For gjennomsnitt i perioden - over bo, alder og kjønn. Aar=9999*/
proc sql;
	create table xyz_alder_agg as
	select &bo, alder, ermann,
		sum(antall) as antall,
		sum(unik)   as unik
	from xyz_ald_agg
	group by &bo, alder, ermann;
quit;
data xyz_alder_agg;
set xyz_alder_agg;
aar=9999;
antall=antall/(&slutt-&start+1);
unik  =unik  /(&slutt-&start+1);
run;

/*Hent inn innbyggertall*/
/*****Hent inn innbyggerdata*****/
data xyz_pop;
set &innbygg_dsn;
where aar in (&start:&slutt) and alder in (&alder_min:&alder_max);
run;
%boomraader(inndata=xyz_pop, indreOslo=&bodef_indreoslo, bydel=&bodef_bydel);

proc sql;
	create table xyz_popn as
	select &bo, alder, ermann,
		sum(innbyggere) as innbyggere
	from xyz_pop
	group by &bo, alder, ermann;
quit;
data xyz_popn;
set xyz_popn;
aar=9999;
innbyggere=innbyggere/(&slutt-&start+1);
run;

/*slå sammen*/
proc sql;
create table xyz_alder as
select a.*,b.unik
from xyz_popn as a left join xyz_alder_agg as b
on a.&bo=b.&bo and a.aar=b.aar and a.alder=b.alder and a.ermann=b.ermann;
run;

data xyz_alder;
set xyz_alder;
if unik=. then unik=0;
run;

proc sql;
	create table xyz_aldern as
	select alder, ermann,
		sum(innbyggere) as innbyggere, sum(unik) as unik
	from xyz_alder
	group by alder, ermann;
quit;

data xyz_aldern;
set xyz_aldern;
andel=(unik/innbyggere)*100;
if andel=. then andel=0;
run;

data xyz_alder_menn xyz_alder_kvinner;
set xyz_aldern;
if ermann=1 then output xyz_alder_menn;
if ermann=0 then output xyz_alder_kvinner;
run;

data xyz_alder_kvinner;
set xyz_alder_kvinner;
andel_kvinner=andel;
innb_kvinner=innbyggere;
run;

data xyz_alder_menn;
set xyz_alder_menn;
andel_menn=andel;
innb_menn=innbyggere;
run;

%if &kunermann=1 %then %do;
data xyz_alder_fig;
set xyz_alder_menn;
run;
%end;

%if &kunermann=0 %then %do;
data xyz_alder_fig;
set xyz_alder_kvinner;
run;
%end;

%if %sysevalf(%superq(kunermann)=,boolean) %then %do;
proc sql;
create table xyz_alder_fig as
select a.innb_kvinner,a.alder, a.andel_kvinner,b.andel_menn,b.innb_menn
from xyz_alder_kvinner as a left join xyz_alder_menn as b
on a.alder=b.alder;
run;
%end;

%let bildeformat=png;

%if &utfig=1 %then %do;
ODS Graphics ON /reset=All imagename="&rate_var._alder_andel" imagefmt=&bildeformat border=off height=500px /*HEIGHT=&hoyde width=&bredde*/;
ODS Listing style=stil_figur Image_dpi=300 GPATH="&bildesti";
%end;

%if &kunermann=1 %then %do;
	proc sgplot data=xyz_alder_menn noautolegend noborder sganno=anno pad=(Bottom=5% );
		where alder<=95;
		vline alder / response=andel_Menn stat=mean name="Menn" lineattrs=(color=CX95BDE6 pattern=1) NOSTATLABEl;
		keylegend "Menn" / location=inside position=&pos noborder across=1;
		yaxis label="Andel av befolkningen med &rate_var undersøkelser" labelpos=top LABELATTRS=(Weight=Bold);
		xaxis fitpolicy=thin offsetmin=0.035 label='Alder, ett-årig';
	run;
%end;
%if &kunermann=0 %then %do;
	proc sgplot data=xyz_alder_kvinner noautolegend noborder sganno=anno pad=(Bottom=5% );
		where alder<=95;
		vline alder / response=andel_Kvinner stat=mean name="Kvinner" lineattrs=(color=CX00509E pattern=1) NOSTATLABEl;
		keylegend "Kvinner"/ location=inside position=&pos noborder across=1;
		yaxis label="Andel av befolkningen med &rate_var undersøkelser" labelpos=top LABELATTRS=(Weight=Bold);
		xaxis fitpolicy=thin offsetmin=0.035 label='Alder, ett-årig';
	run;
%end;
%if %sysevalf(%superq(kunermann)=,boolean) %then %do;
	proc sgplot data=xyz_alder_fig noautolegend noborder sganno=anno pad=(Bottom=5% );
		where alder<=95;
		vline alder / response=andel_Kvinner stat=mean name="Kvinner" lineattrs=(color=CX00509E pattern=1) NOSTATLABEl;
		vline alder / response=andel_Menn stat=mean name="Menn" lineattrs=(color=CX95BDE6 pattern=1) NOSTATLABEl;
		keylegend "Kvinner" "Menn" / location=inside position=&pos noborder across=1;
		yaxis label="Andel av befolkningen med &rate_var undersøkelser" labelpos=top LABELATTRS=(Weight=Bold);
		xaxis fitpolicy=thin offsetmin=0.035 label='Alder, ett-årig';
	run;
%end;

%if &utfig=1 %then %do;
ods listing close; ods graphics off;
%end;

/*til json*/
%if &json=1 %then %do;
data helseatl.&atlas._tmp_aldta_&flag1;
set xyz_alder_fig;
run;	
%end;

%if &test ne 1 %then %do;
proc datasets nolist;
delete xyz_:;
run;
%end;

%mend;
