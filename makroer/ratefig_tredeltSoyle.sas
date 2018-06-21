* this macro takes 3 output files from the rateprogram;
* each of them will form each of the 3 PARTS in the figure (not the total!);
* the files need to have names that end with "_dp_tot_bohf" (dp stands for diagnose, prosedyre);

%macro ratefig_tredeltSoyle(del1= ,del2=, del3=);
/*********************************************************/
/* Lag tredelt figur for tilstandskoder (diagnosegruppe) */
/*********************************************************/




data &tema._&del1._dp_bohf2;
set &tema._&del1._dp_tot_bohf;
RateSnitt&del1.=RateSnitt;
rate&del1.2014=rate2014;
rate&del1.2015=rate2015;
rate&del1.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del1.=RateSnitt;
end;

keep BoHF RateSnitt&del1. RateSnittN&del1. &tema._&del1._dp_tot Innbyggere rate&del1.2014 rate&del1.2015 rate&del1.2016;

run;

data &tema._&del2._dp_bohf2;
set &tema._&del2._dp_tot_bohf;
RateSnitt&del2.=RateSnitt;
rate&del2.2014=rate2014;
rate&del2.2015=rate2015;
rate&del2.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del2.=RateSnitt;
end;

keep BoHF RateSnitt&del2. RateSnittN&del2. &tema._&del2._dp_tot Innbyggere rate&del2.2014 rate&del2.2015 rate&del2.2016;

run;

data &tema._&del3._dp_bohf2;
set &tema._&del3._dp_tot_bohf;
RateSnitt&del3.=RateSnitt;
rate&del3.2014=rate2014;
rate&del3.2015=rate2015;
rate&del3.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del3.=RateSnitt;
end;

keep BoHF RateSnitt&del3. RateSnittN&del3. &tema._&del3._dp_tot Innbyggere rate&del3.2014 rate&del3.2015 rate&del3.2016;

run;

proc sort data=&tema._&del1._dp_bohf2;
by bohf;
quit;

proc sort data=&tema._&del2._dp_bohf2;
by bohf;
quit;

proc sort data=&tema._&del3._dp_bohf2;
by bohf;
quit;


data &tema._dp_BOHF;
merge &tema._&del1._dp_bohf2 &tema._&del2._dp_bohf2 &tema._&del3._dp_bohf2;
by BoHF;
RateSnitt_tot = RateSnitt&del1. + RateSnitt&del2. + RateSnitt&del3.;
RateSnitt_&del1.&del2. = RateSnitt&del1. + RateSnitt&del2.;

Rate2014_tot = rate&del1.2014 + rate&del2.2014 + rate&del3.2014;
Rate2015_tot = rate&del1.2015 + rate&del2.2015 + rate&del3.2015;
Rate2016_tot = rate&del1.2016 + rate&del2.2016 + rate&del3.2016;

Andel&del1.=RateSnitt&del1./RateSnitt_tot;
Andel&del2.=RateSnitt&del2./RateSnitt_tot;
Andel&del3.=RateSnitt&del3./RateSnitt_tot;

pros_plass= + 0.01;/* avstand fra x=0, eventuelt RateSnitt_tot -0.02 hvis ETTER søylen */;
if bohf=8888 then do;
RateSnittN_tot = RateSnittN&del1. + RateSnittN&del2. + RateSnittN&del3.;
RateSnittN_&del1.&del2. = RateSnittN&del1. + RateSnittN&del2.;

end;
max=max(of rate201:);
min=min(of rate201:);
run;

proc sort data=&tema._dp_BOHF;
by descending RateSnitt_tot;
run;

/*Lager rankingtabell*/
data rank_&tema._dp;
set &tema._dp_BOHF;
where BoHF ne 8888;
&tema._dp_rank+1;
keep &tema._dp_rank BoHF;
run;






* yaxistable antall;
*%let tabellvar1=&tema._&del1._dp_tot;/*fra forbruksmal*/
*%let tabellvar2=&tema._&del2._dp_tot;/*fra forbruksmal*/
*%let tabellvar3=&tema._&del3._dp_tot;/*fra forbruksmal*/

* yaxistable andel;
%let tabellvar1=Andel&del1.;/*fra forbruksmal*/
%let tabellvar2=Andel&del2.;/*fra forbruksmal*/
%let tabellvar3=Andel&del3.;/*fra forbruksmal*/



%let tabellvar4=Innbyggere;

%let tabellvariable= &tabellvar1 &tabellvar2 &tabellvar3 &tabellvar4;
%let labeltabell=&tabellvar1="&del1." &tabellvar2="&del2." &tabellvar3="&del3." &tabellvar4="Innbyggere";
%let dsn_fig=&tema._dp_BOHF;
%let skala=/*values=(0 to 1.5 by 0.5)*/;

*ODS Graphics ON /reset=All imagename="&tema._&type._tredelt_&fignavn" imagefmt=png border=off ;
ODS Graphics ON /reset=All imagename="&tema._&type._tredelt_&fignavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&dsn_fig noborder noautolegend sganno=&anno pad=(Bottom=5%);
hbarparm category=bohf response=RateSnitt_tot / fillattrs=(color=CX95BDE6) outlineattrs=(color=black) missing name="hp1" legendlabel="&del3.";
hbarparm category=bohf response=RateSnitt_&del1.&del2. / fillattrs=(color=CX568BBF) outlineattrs=(color=black) missing name="hp2" legendlabel="&del2.";
hbarparm category=bohf response=RateSnitt&del1. / fillattrs=(color=CX00509E) outlineattrs=(color=black) missing name="hp3" legendlabel="&del1." ; 

hbarparm category=bohf response=RateSnittN_tot / fillattrs=(color=CXC3C3C3) outlineattrs=(color=black); 
hbarparm category=bohf response=RateSnittN_&del1.&del2. / fillattrs=(color=CX969696) outlineattrs=(color=black);
hbarparm category=bohf response=RateSnittN&del1. / fillattrs=(color=CX4C4C4C) outlineattrs=(color=black);

*scatter x=pros_plass y=bohf /datalabel=Andel&del1. datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=white weight=bold size=8);

/*	scatter x=rate2014_tot y=Bohf / markerattrs=(symbol=squarefilled color=black) legendlabel="2014";*/
/*	scatter x=rate2015_tot y=Bohf / markerattrs=(symbol=circlefilled color=black) legendlabel="2015";*/
/*	scatter x=rate2016_tot y=Bohf / markerattrs=(symbol=trianglefilled color=black)legendlabel="2016";*/
/*	Highlow Y=Bohf low=min high=max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);*/
/*	inset (*/
/*                "(*ESC*){unicode'25a0'x}"="   2014"  */
/*                "(*ESC*){unicode'25cf'x}"="   2015"*/
/*                "(*ESC*){unicode'25b2'x}"="   2016")*/
/*	/ position=bottomright textattrs=(size=7);*/

	keylegend "hp3" "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=7 weight=bold);
	 Yaxistable &tabellvariable/Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis /*display=(nolabel)*/
	 offsetmin=0.02 &skala valueattrs=(size=7) label="&xlabel" labelattrs=(size=7 weight=bold);
		Label &labeltabell;
		Format Andel&del1. Andel&del2. Andel&del3. nlpct8.0;

run;
Title; 
ods listing close;
%mend;


