%macro fremskrive_boomr(
inndata=,
utdata=,
frem_var=,
bovar=boHF,
int=10,
alder_min=0,
alder_maks=105,
overste_agr=90,
min_aar=0,
max_aar=0,	
ekskludert_aar=9999,
frem_slutt=2040,
frem_fil=innbygg.beffremskriv_2024,
where_bo= &bovar. ne .,
bildesti=,
ylabel=Antall,
bildeformat=pdf,
bildenavn=,
debug=0
);

/*!

#Sist oppdatert
Sist oppdatert 7 november 2025 av Hanne Sigrun Byhring


# VARIABLER SOM BRUKES I MAKROEN (MÅ FINNES I DATA) 


- alder
- ermann
- aar
- komnr
- BoRHF

#TELLE PR SYKEHUSOPPHOLD ELLER PR PASIENT?

**Dersom sykehusoppholdsmakro er kjørt** 
og du skal bruke **sho_alder** og **sho_aar** må disse navnes om til **alder** og **aar**. 

**Hvis du skal telle kun en rad pr sykehusopphold eller en rad pr pasient** 
må du først redusere datasettet slik at det kun inneholder en rad pr sykehusopphold/pasient. 
Makroen summerer/aggregerer fremskrivningsvariabelen over alle rader i datasettet.

# FORKLARING TIL INPUT 

##Variabler for inndata:
- **inndata**=navn på inndatasett
- **utdata**=navn på utdatasett
- **frem_var**=variabel i inndatasett som skal fremskrives
- **bovar**=boområdevariabel, eks. BoHF eller BoShHN

##Variabler for aldersgruppeinndeling:
- **int**=aldersintervall (eks 5 for 5-årige aldersgrupper), default er 10
- **alder_min**=laveste alder, default er null
- **alder_maks**=høyeste alder, default er 105
- **overste_agr**=laveste alder i øverste aldersgruppe (eks. 90 for å slå sammen alle over 90)

##Variabler for basisperiode for fremskrivningsperiode:
Basisperioden må angis som periode med min og max år, men du kan ekskludere ETT år i perioden (eks 2020).
- **min_aar**=første år, settes lik data_start om den ikke angis
- **max_aar**=siste år, settes lik data_slutt om den ikke angis
- **ekskludert_aar**= År som skal ekskluderes fra basisperiode - eks lik 2020 hvis 2020 skal ekskluderes
- **frem_slutt**= sluttår for fremskrivingsperiode (eks. 2030, 2040 eller 2050)
- **frem_fil**= fil med fremskrevne innbyggertall

##Input for figur:
- **where_bo**= Hvilke boområder skal det plottes for? eks: bohf in (1:4);
- **bildesti**=sti for bildelagring
- **ylabel**=Tekst på y-akse
- **bildeformat**=pdf eller png
- **bildenavn**=ekstra streng som skal inn i bildefilnavnet

##Debugge?
- **debug**=sett lik en for å unngå sletting av midlertidige datasett, default=0

*/


%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
%include "&filbane/makroer/boomraader.sas";
%include "&filbane/makroer/forny_komnr.sas";


/*Regner ut antall aldersgrupper*/
%global ant_gr;
%let ant_gr=%sysevalf(((&overste_agr-&alder_min)/&int)+1);

/*Hvis det ikke er angitt verdi for øverste aldersgruppe 
beregnes den ut fra max alder og intervallstørrelse*/
%if &overste_agr=0 %then %do;
%let overste_agr=%sysevalf(&alder_maks-&int);
%end;

/*Finne startår og sluttår i data*/
proc sql;
create table inndata_aar as
select distinct min(aar) as min_aar, max(aar) as max_aar
from &inndata;
quit; 

data _null_;
set inndata_aar;
call symputx("data_start",min_aar);
call symputx("data_slutt",max_aar);
run;

%put &=data_start;
%put &=data_slutt;

/*Hvis verdier ikke er angitt for basisperiode 
settes basisperiode basert på data_start og data_slutt*/
%if &min_aar=0 %then %do;
%let min_aar=&data_start;
%end;

%if &max_aar=0 %then %do;
%let max_aar=&data_slutt;
%end;

/*Startår for fremskrivning er lik sluttår for basisperiode + 1*/
%let startaar_fremskr=%sysevalf(&max_aar+1);
%put &=startaar_fremskr;

/*Hvis ett år skal ekskluderes fra 
basisperioden lages makrovariabelen ant_aar
som brukes i beregning av snitt for basisperioden*/
%let ekskludere=0;		/*Nullstiller variabelene før if-statement*/
%let ant_aar=.;

%put &=ekskludere;
%put &=ant_aar;
%put &=ekskludert_aar;

%if &ekskludert_aar ne 9999 %then %do;
	%let ekskludere=1;
	%let ant_aar=%sysevalf(&startaar_fremskr-&min_aar-1);
%end;

%put &=ant_aar;
%put &=ekskludere;




/*******************************************************************/
/*** STEG 1: LAGE INNBYGGERFIL MED RIKTIG ALDERSGRUPPEINNDELING ****/
/*******************************************************************/
data innb_xyz;
set innbygg.INNB_SKDE_BYDEL;
where aar in (&data_start:&data_slutt) 
		and alder ge &alder_min
		and alder le &alder_maks;


/*Lage aldersinndeling basert på aldersinput*/
if alder lt &overste_agr then do;
	do i=1 to &ant_gr-1;
		if ( alder ge (&alder_min+((i-1)*&int)) 
			and alder lt (&alder_min+(i*&int)) ) 
			then alder_grp=i;
	end;
end;
else if alder ge &overste_agr then alder_grp=&ant_gr;

drop i;

run;

%boomraader(inndata=innb_xyz, indreOslo = 0, bydel = 0);


proc sql;
   create table innb_xy as 
   select distinct &bovar., aar, ermann, alder_grp, SUM(Innbyggere) as Innbygg
   from innb_xyz
   group by  &bovar., aar, ermann, alder_grp;
quit;


/****************************************/
/*Framskrevne innbyggertall 2022-2040****/
/* Legge til aldersgrupper, transponere,*/
/* legge til bovar og aggregere         */
/****************************************/

/*Fornyer kommunenummer i fil med fremskrevne innbyggertall*/
data innb_frem_abc;
set &frem_fil.;
run;

%forny_komnr(inndata=innb_frem_abc, kommune_nr=komnr);

/*Lager aldersinndeling*/
Data innb_frem_xyz;
set innb_frem_abc;
drop Komnrnavn;
where  alder ge &alder_min
		and alder le &alder_maks;

/*Lage aldersinndeling basert på aldersinput*/
if alder lt &overste_agr then do;
	do i=1 to &ant_gr-1;
		if ( alder ge (&alder_min+((i-1)*&int)) 
			and alder lt (&alder_min+(i*&int)) ) 
			then alder_grp=i;
	end;
end;
else if alder ge &overste_agr then alder_grp=&ant_gr;

drop i;


If Alternativ=-1 then Alt="Lav";
else if Alternativ=0 Then Alt="Mid";
else if Alternativ=1 then Alt="Hoy";
drop ALternativ;
run;


/*Proc tranpose - alternativer for fremskriving*/
proc sort data=innb_frem_xyz;
by komnr ermann alder aar alder_grp ;
run;

proc transpose data=innb_frem_xyz out=Frem_alt prefix=Alt;
by komnr ermann alder aar alder_grp ;
var innbyggere; id alt;
run;

/*Legge på bovar og aggregere på &bovar.*/
%boomraader(inndata=Frem_alt, indreOslo = 0, bydel = 0);

proc sql;
   create table Bo_FS as 
   select distinct aar, ermann, &bovar., alder_grp, sum(AltLav) as Lav_vekst,sum(AltMid) as Mid_vekst, 
   sum(AltHoy) as Hoy_vekst
   from Frem_alt
   where aar in (&startaar_fremskr:&frem_slutt)
   group by aar, ermann, &bovar., alder_grp;
quit;

/*********************************************************/
/*Samle reelle innbyggertall og framskrevne innbyggertall*/
/*********************************************************/

proc sql;
create table Bo_bef as
select Bo_FS.*, innbygg
from Bo_FS left join innb_xy
on Bo_FS.aar=innb_xy.aar and Bo_FS.&bovar.=innb_xy.&bovar. and Bo_FS.ermann=innb_xy.ermann and 
 Bo_FS.alder_grp=innb_xy.alder_grp;
quit; 


Data Bo_Bef;
set Bo_bef Innb_xy;
format &bovar. &bovar._fmt.;
run;


/*******************************************************************/
/*** STEG 2: FREMSKRIVING AV AKTIVITETSTALL ************************/
/*******************************************************************/

data inndata_grp;
set &inndata;
where &frem_var. ne 0 and &frem_var. ne . 
and ermann ne . 
and alder ge &alder_min 
and alder le &alder_maks 
and BoRHF in (1:4)
and aar ge &data_start 
and aar le &data_slutt;

drop &bovar.;

/*Lage aldersinndeling basert på aldersinput*/
if alder lt &overste_agr then do;
	do i=1 to &ant_gr-1;
		if ( alder ge (&alder_min+((i-1)*&int)) 
			and alder lt (&alder_min+(i*&int)) ) 
			then alder_grp=i;
	end;
end;
else if alder ge &overste_agr then alder_grp=&ant_gr;



drop i;

run;

/*Legge på &bovar. på nytt aggregere på &bovar.*/
/*Dette må gjøres pga at befolkningstall for fremskrivning ikke har bydel*/
%boomraader(inndata=inndata_grp, indreOslo = 0, bydel = 0);


/*Aggregere på kjønn, alder og &bovar.*/
proc sql;
   create table inndata_agg as 
   select distinct aar, ermann, alder_grp, &bovar., SUM(&frem_var) as &frem_var
      from inndata_grp
	  /*Her settes basisperiode*/
	  where aar ge &min_aar and aar le &max_aar	
   group by aar, ermann, alder_grp, &bovar.;
quit;


/*Beregne gjennomsnittlig antall inngrep pr. år*/
%if &ekskludere=1 %then %do;
Proc sql;
	create table inndata_snitt as 
   select distinct ermann, alder_grp, &bovar., 
	SUM(&frem_var) as tot_&frem_var,
	(calculated tot_&frem_var)/&ant_aar as snitt_&frem_var
      from inndata_agg
	  /*Ekskludere år hvis aktuelt*/
	  where aar ne &ekskludert_aar
   group by ermann, alder_grp, &bovar.;
quit;
%end;
%else %if &ekskludere ne 1 %then %do;
Proc sql;
	create table inndata_snitt as 
   select distinct ermann, alder_grp, &bovar., 
	SUM(&frem_var) as tot_&frem_var,
	(calculated tot_&frem_var)/(&startaar_fremskr-&min_aar) as snitt_&frem_var
      from inndata_agg
   group by ermann, alder_grp, &bovar.;
quit;
%end;


/*Beregne gjennomsnittlig antall innbyggere pr. år*/
%if &ekskludere=1 %then %do;
Proc sql;
	create table innbygg_snitt as 
   select distinct ermann, alder_grp, &bovar., 
	SUM(Innbygg) as tot_Innbygg,
	(calculated tot_Innbygg)/&ant_aar as snitt_Innbygg
   from Bo_Bef
   /*Begrense antall år til basisperioden OG ekskludere år hvis aktuelt*/
	where aar ge &min_aar and aar le &max_aar and aar ne &ekskludert_aar
   group by ermann, alder_grp, &bovar.;
quit;
%end;
%else %if &ekskludere ne 1 %then %do;
Proc sql;
	create table innbygg_snitt as 
   select distinct ermann, alder_grp, &bovar., 
	SUM(Innbygg) as tot_Innbygg,
	(calculated tot_Innbygg)/(&startaar_fremskr-&min_aar) as snitt_Innbygg
   from Bo_Bef  
   /*Begrense antall år til basisperioden*/
	where aar ge &min_aar and aar le &max_aar
   group by ermann, alder_grp, &bovar.;
quit;
%end;

/*Samle snittantall prosedyrer og snitt for innbyggertall */
proc sql;
create table inn_samle as
select distinct innbygg_snitt.*, snitt_&frem_var
from innbygg_snitt left join inndata_snitt
on innbygg_snitt.&bovar.=inndata_snitt.&bovar. and innbygg_snitt.ermann=inndata_snitt.ermann and 
 innbygg_snitt.alder_grp=inndata_snitt.alder_grp;
quit; 

/*Lage andeler pr innbygger i &bovar., alder_grp og kjønn*/
Data inn_andeler;
set inn_samle;
if snitt_&frem_var=. then snitt_&frem_var=0;
Ant_pr_innb=(snitt_&frem_var/snitt_Innbygg);
run;

/*Merge inn andeler som grunnlag for fremskriving*/
proc sql;
create table Fremskriv_base as
select distinct Bo_Bef.*, 
snitt_&frem_var, 
snitt_innbygg, 
Ant_pr_innb
from Bo_Bef left join inn_andeler
on Bo_Bef.&bovar.=inn_andeler.&bovar. and Bo_Bef.ermann=inn_andeler.ermann and 
 Bo_Bef.alder_grp=inn_andeler.alder_grp;
quit; 


/***********************************************/
/*Fremskrive inngrep pr. aar				   */
/*Antall inngrep pr. kjønn og aldersgruppe	   */
/*Basert på fremskrevne innbyggertall 			*/
/***********************************************/
Data Fremskriv;
set Fremskriv_base;
if aar in (&data_start:&data_slutt) then do;
	FS_Lav=round(Ant_pr_innb*Innbygg,1);
	FS_Mid=round(Ant_pr_innb*Innbygg,1);
	FS_Hoy=round(Ant_pr_innb*Innbygg,1);
end;
else if aar not in (&data_start:&data_slutt) then do;
	FS_Lav=round(Ant_pr_innb*Lav_Vekst,1);
	FS_Mid=round(Ant_pr_innb*Mid_vekst,1);
	FS_Hoy=round(Ant_pr_innb*Hoy_Vekst,1);
end;
run;

/*Aggregere fremskrevne tall på aar og &bovar.*/
proc sql;
   create table Frem as 
   select distinct aar, &bovar., SUM(FS_Lav) as Lav, 
	Sum(FS_Mid) as Mid,
   	SUM(FS_Hoy) as Hoy
   from Fremskriv
   group by &bovar., aar;
quit;


/*Aggregere reelle tall på år og &bovar.*/
proc sql;
   create table inndata_agg_&bovar. as 
   select distinct aar, &bovar., SUM(&frem_var) as &frem_var
      from inndata_grp
   group by &bovar., aar;
quit;

/*Samle fremskrevne og reelle tall*/
data &utdata;
merge Frem inndata_agg_&bovar.;
by &bovar. aar;
where &bovar. ne .;
%if &ekskludere eq 1 %then %do;	
/*To nye variabler for plotting*/
&frem_var._ekskl=.;
&frem_var._inkl=.;
if aar eq &ekskludert_aar then &frem_var._ekskl=&frem_var;
if aar ne &ekskludert_aar then &frem_var._inkl=&frem_var;
%end;
run;



/*******************************************************************/
/*** STEG 3: PLOTTE AKTIVITETSTALL OG FREMSKREVNE TALL *************/
/*******************************************************************/

/*Figur med reelle og fremskrevne tall*/
%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";
ODS graphics on /Border=off height=600 reset=All imagename="Frem_&frem_var.&min_aar._&max_aar._&bildenavn" imagefmt=&bildeformat;
ODS Listing Image_dpi=300 GPATH="&bildesti";
Proc sgplot data=&utdata sganno=Anno pad=(Bottom=10%) noautolegend noborder ;
/*styleattrs datacontrastcolors=(CX00509E CX568BBF CX95BDE6 CX969696) */
/*datacolors=(CX00509E CX568BBF CX95BDE6 CX969696);*/
where &where_bo;

series X=Aar y=&frem_var / legendlabel="Observert antall" name="relle" Group=&bovar.  lineattrs=(Pattern=21 thickness=1) break ;
series X=Aar y=Mid / legendlabel="Fremskrevet antall" name="&bovar." Group=&bovar.  lineattrs=(Pattern=1 thickness=2);

%if &ekskludere ne 1 %then %do; 
scatter x=aar y=&frem_var / markerattrs=(symbol=circlefilled);
%end;

%if &ekskludere eq 1 %then %do; 
scatter x=aar y=&frem_var._inkl / legendlabel="Inkluderte år"  name="inkluderte" markerattrs=(symbol=circlefilled);
scatter x=aar y=&frem_var._ekskl / legendlabel="Ekskluderte år"  name="ekskluderte" markerattrs=(symbol=circle);
%end;

Keylegend "reelle" "&bovar." "inkluderte" "ekskluderte" / title="Opptaksområder:" location=outside position=bottom noborder ;
band x=Aar lower=Lav UPPER=Hoy /Fill Outline lineattrs=(Pattern=1 thickness=2)
	group=&bovar. transparency=0.6;
yaxis /*Values=(0 to 2500 by 250)*/ label="&ylabel" min=0;
xaxis label=' ' values=(&min_aar to &frem_slutt by 1);
run;
ODS Graphics Off;

%if &debug ne 1 %then %do;
proc datasets nolist;
delete inn: frem: bo_fs anno;
quit;
%end;


%mend fremskrive_boomr;