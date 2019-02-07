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
%macro ratefig(datasett=, aar1=2015, aar2=2016, aar3=2017, bildeformat=png, noxlabel=0, bohf_format=BoHF_kort,sprak=no);

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

*create 3 variables that look exactly like bohf;
*use them to draw scatter plot (årsvariasion) so that we can use the label for keylegend;
bohf&aar1=bohf;
bohf&aar2=bohf;
bohf&aar3=bohf;
label bohf&aar1="&aar1" bohf&aar2="&aar2" bohf&aar3="&aar3";
format bohf&aar1 bohf&aar2 bohf&aar3 &bohf_format..;

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

/*Hvis vi ikke vil fjerne rater med lav n bruker vi rateSnitt2*/
%if &vis_misstxt ne 1 %then %do;
proc sort data=&datasett;
by descending rateSnitt2;
run;
%end;

ODS Graphics ON /reset=All imagename="&tema._&type._rate_&fignavn" imagefmt=&bildeformat border=off height=500px;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";

proc sgplot data=&datasett noborder noautolegend sganno=&anno pad=(Bottom=5%);

%if &vis_misstxt=1 %then %do;
  hbarparm category=bohf response=RateSnitt / fillattrs=(color=CX95BDE6) missing outlineattrs=(color=grey); /*BoHFene*/
  scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) datalabelattrs=(size=8pt);
%end; 
%else %do;
  hbarparm category=bohf response=Ratesnitt2 / fillattrs=(color=CX95BDE6) missing outlineattrs=(color=grey);
%end; 

hbarparm category=bohf response=Snittrate / fillattrs=(color=CXC3C3C3) outlineattrs=(color=grey);		/*Norge*/


%if &vis_aarsvar=1 %then %do;
	%if &ratestart=&aar1 %then %do;
	scatter x=rate&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9pt) name="y3"; 
	scatter x=rate&aar2 y=Bohf&aar2 / markerattrs=(symbol=circlefilled color=grey  size=7pt) name="y2"; 
	scatter x=rate&aar1 y=bohf&aar1 / markerattrs=(symbol=circlefilled color=black size=5pt) name="y1";
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	keylegend "y1" "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7pt);
	%end;
	%if &ratestart=&aar2 %then %do;
	scatter x=rate&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9pt) name="y3"; 
	scatter x=rate&aar2 y=Bohf&aar2 / markerattrs=(symbol=circlefilled color=grey  size=7pt) name="y2"; 
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	keylegend "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7pt);
	%end;
	%if &ratestart=&aar3 %then %do;
	scatter x=rate&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9pt) name="y3"; 
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
	keylegend "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7pt);
	%end;
%end;

%if &noxlabel=1 %then %do;
	xaxis display=(nolabel) offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
%end;
%else %do;
	 xaxis offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
%end;

%if &vis_ft=1 %then %do; 
	inset "FT1 = &FT1" "FT2 = &FT2" "FT3 = &FT3" / position=right textattrs=(size=9) valuealign=right; 
%end;

Yaxistable &tabellvariable /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);

%if &sprak=no %then %do;
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
%end;
%else %if &sprak=en %then %do;
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
%end;

Label &labeltabell;
Format &formattabell;
run;Title; ods listing close;

%mend ratefig;
