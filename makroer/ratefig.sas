/*INPUT TIL MAKRO:*/



/*OVERORDNET INPUT:

%let bildelagring=\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Helseatlas\Kols\Figurer\;

options locale=NB_no;
%let vis_ekskludering=0;
%let nkrav=40;
%let vis_misstxt=0;
%let vis_aarsvar=1;
%let vis_ft=0;

*/


/*
INPUT FOR HVER FIGUR:

%let dsn2=Episoder_&tema._bohf; %let rv2=Episoder_&tema;
%let dsn1=Personer_&tema._bohf; %let rv1=Personer_&tema;
%let dsn3=Episoder_tot_&tema._bohf; %let rv3=Episoder_tot_&tema;

%merge(ant_datasett=3, dsn_ut=Personer_&tema);

%let fignavn=Personer;
%let tittel=Antall personer i primærhelsetjenesten for kols. Kjønns- og aldersstandardiserte rater per 10 000 innbyggere. Gjennomsnitt per år i perioden 2013-15.;
%let xlabel= Personer med kols hos fastlege eller legevakt per 10 000 innbyggere;
%let tabellvar1=antall_1;
%let tabellvar2=antall_2_1;
%let tabellvar3=antall_3_1;
%let tabellvariable= &tabellvar1 &tabellvar2 &tabellvar3;
%let labeltabell=&tabellvar1="Personer" &tabellvar2="Konsult. per person for kols" &tabellvar3="Konsult. per person totalt";
%let formattabell=&tabellvar1 NLnum8.0 &tabellvar2 NLnum8.1 &tabellvar3 NLnum8.1;
%let skala=;


%ratefig(datasett=Personer_&tema);
*/


/*enkel ratefigur*/
%macro ratefig(datasett=, aar1=2015, aar2=2016, aar3=2017);

/*Setter aktuelle rater i datasettet til missing hvis antall observasjoner er under grensen (nkrav)*/
Data &datasett;
set &datasett;
Length Mistext $ 10;
if &rv1 lt &nkrav then do;
     ratesnitt=.;
	 rate&aar1=.; rate&aar2=.; rate&aar3=.; min=.; max=.;
     Mistext="N<&nkrav";
     Plassering=Norge/100;
end;
run;

/*Forholdstall som kan vises på figuren*/
Data _null_;
set &datasett;
call symput('FT1',trim(left(put(FT,8.2))));
call symput('FT2',trim(left(put(FT2,8.2))));
call symput('FT3',trim(left(put(FT3,8.2))));
run;


/*Hvilken rateSnitt-variabel som plottes avhenger av om vi vil vise alle rater uansett, eller om vi vil fjerne de med lav n*/
%if &vis_misstxt=1 %then %do;
proc sort data=&datasett;
by descending rateSnitt;
run;
%end;

/*Hvis vi vil fjerne rater med lav n bruker vi rateSnitt2*/
%if &vis_misstxt ne 1 %then %do;
proc sort data=&datasett;
by descending rateSnitt2;
run;
%end;

ODS Graphics ON /reset=All imagename="&tema._&type._rate_&fignavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=5%);
%if &vis_misstxt ne 1 %then %do;
hbarparm category=bohf response=Ratesnitt2 / fillattrs=(color=CX95BDE6) missing outlineattrs=(color=black);
%end; 
%if &vis_misstxt=1 %then %do;
hbarparm category=bohf response=RateSnitt / fillattrs=(color=CX95BDE6) missing outlineattrs=(color=black); /*BoHFene*/
%end; 
hbarparm category=bohf response=Snittrate / fillattrs=(color=CXC3C3C3) outlineattrs=(color=black);		/*Norge*/
%if &vis_misstxt=1 %then %do;
	scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0);
%end;
%if &vis_aarsvar=1 %then %do;
	%if &ratestart=&aar1 %then %do;
	scatter x=rate&aar1 y=Bohf / markerattrs=(symbol=squarefilled color=black);
	scatter x=rate&aar2 y=Bohf / markerattrs=(symbol=circlefilled color=black); 
	scatter x=rate&aar3 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	%end;
	%if &ratestart=&aar2 %then %do;
	scatter x=rate&aar2 y=Bohf / markerattrs=(symbol=circlefilled color=black); 
	scatter x=rate&aar3 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	%end;
	%if &ratestart=&aar3 %then %do;
	scatter x=rate&aar3 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	%end;
%end;
Yaxistable &tabellvariable /Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
xaxis display=(nolabel) offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=7);
xaxis label="&xlabel" labelattrs=(size=7 weight=bold);
%if &vis_aarsvar=1 %then %do;
	%if &ratestart=&aar1 %then %do;
	inset (
	"(*ESC*){unicode'25a0'x}"="   &aar1"   
 	"(*ESC*){unicode'25cf'x}"="   &aar2" 
 	"(*ESC*){unicode'25b2'x}"="   &aar3" 
	) 
    / position=bottomright textattrs=(size=7);
	%end;
	%if &ratestart=&aar2 %then %do;
	inset (
 	"(*ESC*){unicode'25cf'x}"="   &aar2" 
 	"(*ESC*){unicode'25b2'x}"="   &aar3" 
	) 
    / position=bottomright textattrs=(size=7);
	%end;
	%if &ratestart=&aar3 %then %do;
	inset (
 	"(*ESC*){unicode'25b2'x}"="   &aar3" 
	) 
    / position=bottomright textattrs=(size=7);
	%end;
%end;
%if &vis_ft=1 %then %do; 
	inset "FT1 = &FT1" "FT2 = &FT2" "FT3 = &FT3" / position=right textattrs=(size=9) valuealign=right; 
%end;
Label &labeltabell;
Format &formattabell;
run;Title; ods listing close;

%mend ratefig;