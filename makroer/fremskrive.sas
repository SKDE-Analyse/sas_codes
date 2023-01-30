%macro fremskrive(
inndata=,
utdata=,
frem_var=,
sho=0,
int=10,
alder_min=0,
alder_maks=105,
overste_agr=0,
min_aar=0,
max_aar=0,	
ekskludert_aar=9999,
frem_slutt=2040,
where_bohf= bohf in (1:4),
bildesti=,
ylabel=Antall,
bildeformat=pdf,
bildenavn=
);



/*******************************************************************/
/*** FORKLARING TIL INPUT ******************************************/
/*******************************************************************/
/*

Variabler for inndata:
inndata=navn på inndatasett
utdata=navn på utdatasett
frem_var=variabel i inndatasett som skal fremskrives
sho=1 hvis sykehusoppholdsmakro kjørt på dataene, ellers 0

Variabler for aldersgruppeinndeling:
int=aldersintervall (eks 5 for 5-årige aldersgrupper), default er 10
alder_min=laveste alder, default er null
alder_maks=høyeste alder, default er 105
overste_agr=laveste alder i øverste aldersgruppe (eks. 90 for å slå sammen alle over 90)

Variabler for basisperiode for fremskrivningsperiode:
Basisperioden må angis som periode med min og max år, men du kan ekskludere ETT år i perioden (eks 2020).
min_aar=første år, settes lik data_start om den ikke angis
max_aar=siste år, settes lik data_slutt om den ikke angis
ekskludert_aar= År som skal ekskluderes fra basisperiode - eks lik 2020 hvis 2020 skal ekskluderes
frem_slutt= sluttår for fremskrivingsperiode (eks. 2030, 2040 eller 2050)

Input for figur:
where_bohf= Hvilke bohf skal det plottes for? eks: bohf in (1:4);
bildesti=sti for bildelagring
ylabel=Tekst på y-akse
bildeformat=pdf eller png
bildenavn=ekstra streng som skal inn i bildefilnavnet
*/

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

/*Hvis ett år skal ekskluderes fra 
basisperioden lages makrovariabelen ant_aar
som brukes i beregning av snitt for basisperioden*/
%if ekskludert_aar ne 9999 %then %do;
%let ekskludere=1;
data _null_;
set &inndata;
where aar ge &min_aar and aar le &max_aar and aar ne &ekskludert_aar;
nobs+1;
call symputx("ant_aar",nobs);
run;

%put &=n_aar;
%end;




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
   select distinct bohf, aar, ermann, alder_grp, SUM(Innbyggere) as Innbygg
   from innb_xyz
   group by  bohf, aar, ermann, alder_grp;
quit;


/****************************************/
/*Framskrevne innbyggertall 2022-2040****/
/* Legge til aldersgrupper, transponere,*/
/* legge til bovar og aggregere         */
/****************************************/

Data innb_frem_xyz;
set innbygg.beffremskriv_2022;
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

/*Legge på bovar of aggregere på BOHF*/
%boomraader(inndata=Frem_alt, indreOslo = 0, bydel = 0);

proc sql;
   create table Bo_FS as 
   select distinct aar, ermann, BoHF, alder_grp, sum(AltLav) as Lav_vekst,sum(AltMid) as Mid_vekst, 
   sum(AltHoy) as Hoy_vekst
   from Frem_alt
   where aar in (2022:&frem_slutt)
   group by aar, ermann, BoHF, alder_grp;
quit;

/*********************************************************/
/*Samle reelle innbyggertall og framskrevne innbyggertall*/
/*********************************************************/

proc sql;
create table Bo_bef as
select Bo_FS.*, innbygg
from Bo_FS left join innb_xy
on Bo_FS.aar=innb_xy.aar and Bo_FS.BoHF=innb_xy.BoHF and Bo_FS.ermann=innb_xy.ermann and 
 Bo_FS.alder_grp=innb_xy.alder_grp;
quit; 


Data Bo_Bef;
set Bo_bef Innb_xy;
format bohf bohf_fmt.;
run;


/*******************************************************************/
/*** STEG 2: FREMSKRIVING AV AKTIVITETSTALL ************************/
/*******************************************************************/

data inndata_grp;
set &inndata;
where &frem_var=1 
and ermann ne . 
and alder ge &alder_min 
and alder le &alder_maks 
and BoRHF in (1:4)
and aar ge &data_start 
and aar le &data_slutt;

/*Lage aldersinndeling basert på aldersinput*/
%if &sho=1 %then %do;		/*Bruke sho_alder hvis relevant*/
if sho_alder lt &overste_agr then do;
	do i=1 to &ant_gr-1;
		if ( sho_alder ge (&alder_min+((i-1)*&int)) 
			and sho_alder lt (&alder_min+(i*&int)) ) 
			then alder_grp=i;
	end;
end;
else if sho_alder ge &overste_agr then alder_grp=&ant_gr;
%end;
%else %if &sho ne 1 %then %do;
if alder lt &overste_agr then do;
	do i=1 to &ant_gr-1;
		if ( alder ge (&alder_min+((i-1)*&int)) 
			and alder lt (&alder_min+(i*&int)) ) 
			then alder_grp=i;
	end;
end;
else if alder ge &overste_agr then alder_grp=&ant_gr;
%end;



drop i;

run;


/*Aggregere på kjønn, alder og bohf*/
%if &sho=1 %then %do;	/*Telle kun en gang per sho_id*/
proc sql;
   create table inndata_agg as 
   select sho_aar as aar, ermann, alder_grp, BoHF, count(distinct(case when &frem_var=1 then sho_id end)) as &frem_var
      from inndata_grp
	  /*Her settes basisperiode*/
	  where sho_aar ge &min_aar and sho_aar le &max_aar	
   group by sho_aar, ermann, alder_grp, BoHF;
quit;
%end;
%else %if &sho ne 1 %then %do;	/*Teller alle rader (eks v data fra SHO-filer)*/
proc sql;
   create table inndata_agg as 
   select distinct aar, ermann, alder_grp, BoHF, SUM(&frem_var) as &frem_var
      from inndata_grp
	  /*Her settes basisperiode*/
	  where aar ge &min_aar and aar le &max_aar	
   group by aar, ermann, alder_grp, BoHF;
quit;
%end;


/*Beregne gjennomsnittlig antall inngrep pr. år*/
%if &ekskludere=1 %then %do;
Proc sql;
	create table inndata_snitt as 
   select distinct ermann, alder_grp, BoHF, 
	SUM(&frem_var) as tot_&frem_var,
	(calculated tot_&frem_var)/&ant_aar as snitt_&frem_var
      from inndata_agg
	  /*Ekskludere år hvis aktuelt*/
	  where aar ne &ekskludert_aar
   group by ermann, alder_grp, BoHF;
quit;
%end;
%else %if &ekskludere ne 1 %then %do;
Proc sql;
	create table inndata_snitt as 
   select distinct ermann, alder_grp, BoHF, 
	SUM(&frem_var) as tot_&frem_var,
	(calculated tot_&frem_var)/(&max_aar-&min_aar) as snitt_&frem_var
      from inndata_agg
   group by ermann, alder_grp, BoHF;
quit;
%end;


/*Beregne gjennomsnittlig antall innbyggere pr. år*/
%if &ekskludere=1 %then %do;
Proc sql;
	create table innbygg_snitt as 
   select distinct ermann, alder_grp, BoHF, 
	SUM(Innbygg) as tot_Innbygg,
	(calculated tot_Innbygg)/&ant_aar as snitt_Innbygg
   from Bo_Bef
   /*Begrense antall år til basisperioden OG ekskludere år hvis aktuelt*/
	where aar ge &min_aar and aar le &max_aar and aar ne &ekskludert_aar
   group by ermann, alder_grp, BoHF;
quit;
%end;
%else %if &ekskludere ne 1 %then %do;
Proc sql;
	create table innbygg_snitt as 
   select distinct ermann, alder_grp, BoHF, 
	SUM(Innbygg) as tot_Innbygg,
	(calculated tot_Innbygg)/(&max_aar-&min_aar) as snitt_Innbygg
   from Bo_Bef  
   /*Begrense antall år til basisperioden*/
	where aar ge &min_aar and aar le &max_aar
   group by ermann, alder_grp, BoHF;
quit;
%end;

/*Samle snittantall prosedyrer og snitt for innbyggertall */
proc sql;
create table inn_samle as
select distinct innbygg_snitt.*, snitt_&frem_var
from innbygg_snitt left join inndata_snitt
on innbygg_snitt.BoHF=inndata_snitt.BoHF and innbygg_snitt.ermann=inndata_snitt.ermann and 
 innbygg_snitt.alder_grp=inndata_snitt.alder_grp;
quit; 

/*Lage andeler pr innbygger i boHF, alder_grp og kjønn*/
Data inn_andeler;
set inn_samle;
if snitt_&frem_var=. then snitt_&frem_var=0;
Kir_innb=(snitt_&frem_var/snitt_Innbygg);
run;

/*Merge inn andeler som grunnlag for fremskriving*/
proc sql;
create table Fremskriv_base as
select distinct Bo_Bef.*, 
snitt_&frem_var, 
snitt_innbygg, 
kir_innb
from Bo_Bef left join inn_andeler
on Bo_Bef.bohf=inn_andeler.bohf and Bo_Bef.ermann=inn_andeler.ermann and 
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
	FS_Lav=round(Kir_innb*Innbygg,1);
	FS_Mid=round(Kir_innb*Innbygg,1);
	FS_Hoy=round(Kir_innb*Innbygg,1);
end;
else if aar not in (&data_start:&data_slutt) then do;
	FS_Lav=round(Kir_innb*Lav_Vekst,1);
	FS_Mid=round(Kir_innb*Mid_vekst,1);
	FS_Hoy=round(Kir_innb*Hoy_Vekst,1);
end;
run;

/*Aggregere fremskrevne tall på aar og bohf*/
proc sql;
   create table Frem as 
   select distinct aar, BoHF, SUM(FS_Lav) as Lav, 
	Sum(FS_Mid) as Mid,
   	SUM(FS_Hoy) as Hoy
   from Fremskriv
   group by BoHF, aar;
quit;


/*Aggregere reelle tall på år og bohf*/
proc sql;
   create table inndata_agg_bohf as 
   select distinct aar, BoHF, SUM(&frem_var) as &frem_var
      from inndata_grp
   group by BoHF, aar;
quit;

/*Samle fremskrevne og reelle tall*/
data &utdata;
merge Frem inndata_agg_bohf;
by bohf aar;
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
where &where_bohf;
series X=Aar y=&frem_var / name="relle" Group=BoHF  lineattrs=(Pattern=21 thickness=1) break ;
series X=Aar y=Mid / name="BOHF" Group=BoHF  lineattrs=(Pattern=1 thickness=2);
Keylegend / title="Opptaksområder:" location=outside position=bottom noborder ;
band x=Aar lower=Lav UPPER=Hoy /Fill Outline lineattrs=(Pattern=1 thickness=2)
	group=BoHF transparency=0.6;
yaxis /*Values=(0 to 2500 by 250)*/ label="&ylabel" ;
xaxis label=' ' values=(&min_aar to &frem_slutt by 1);
run;
ODS Graphics Off;

proc datasets nolist;
delete inn: frem: bo_fs anno;
quit;

%mend;

