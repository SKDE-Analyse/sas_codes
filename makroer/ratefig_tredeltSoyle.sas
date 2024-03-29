﻿* this macro takes 3 output files from the rateprogram;
* each of them will form each of the 3 PARTS in the figure (not the total!);
* the files need to have names that end with "_dp_tot_bohf" (dp stands for diagnose, prosedyre);

%macro ratefig_tredeltSoyle(del1=, del2=, del3=, bildeformat=png, noxlabel=0,sprak=no);
/*********************************************************/
/* Lag tredelt figur for tilstandskoder (diagnosegruppe) */
/*********************************************************/




data &del1._bohf2;
set &del1._bohf;
RateSnitt&del1.=RateSnitt;
rate&del1.2017=rate2017;
rate&del1.2015=rate2015;
rate&del1.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del1.=RateSnitt;
end;

keep BoHF RateSnitt&del1. RateSnittN&del1. &del1. Innbyggere rate&del1.2017 rate&del1.2015 rate&del1.2016;

run;

data &del2._bohf2;
set &del2._bohf;
RateSnitt&del2.=RateSnitt;
rate&del2.2017=rate2017;
rate&del2.2015=rate2015;
rate&del2.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del2.=RateSnitt;
end;

keep BoHF RateSnitt&del2. RateSnittN&del2. &del2. Innbyggere rate&del2.2017 rate&del2.2015 rate&del2.2016;

run;

data &del3._bohf2;
set &del3._bohf;
RateSnitt&del3.=RateSnitt;
rate&del3.2017=rate2017;
rate&del3.2015=rate2015;
rate&del3.2016=rate2016;
if bohf=8888 then do;
RateSnittN&del3.=RateSnitt;
end;

keep BoHF RateSnitt&del3. RateSnittN&del3. &del3. Innbyggere rate&del3.2017 rate&del3.2015 rate&del3.2016;

run;

proc sort data=&del1._bohf2;
by bohf;
quit;

proc sort data=&del2._bohf2;
by bohf;
quit;

proc sort data=&del3._bohf2;
by bohf;
quit;


data &tema._BOHF;
merge &del1._bohf2 &del2._bohf2 &del3._bohf2;
by BoHF;
RateSnitt_tot = RateSnitt&del1. + RateSnitt&del2. + RateSnitt&del3.;
RateSnitt_12 = RateSnitt&del1. + RateSnitt&del2.;

Rate2017_tot = rate&del1.2017 + rate&del2.2017 + rate&del3.2017;
Rate2015_tot = rate&del1.2015 + rate&del2.2015 + rate&del3.2015;
Rate2016_tot = rate&del1.2016 + rate&del2.2016 + rate&del3.2016;

Andel&del1.=RateSnitt&del1./RateSnitt_tot;
Andel&del2.=RateSnitt&del2./RateSnitt_tot;
Andel&del3.=RateSnitt&del3./RateSnitt_tot;

tot_antall=&del1 + &del2 + &del3;

pros_plass= + 0.01;/* avstand fra x=0, eventuelt RateSnitt_tot -0.02 hvis ETTER søylen */;
if bohf=8888 then do;
RateSnittN_tot = RateSnittN&del1. + RateSnittN&del2. + RateSnittN&del3.;
RateSnittN_12 = RateSnittN&del1. + RateSnittN&del2.;

end;
max=max(of rate201:);
min=min(of rate201:);
run;

proc sort data=&tema._BOHF;
by descending RateSnitt_tot;
run;

/*Lager rankingtabell*/
data rank_&tema;
set &tema._BOHF;
where BoHF ne 8888;
&tema._rank+1;
keep &tema._rank BoHF;
run;


%let dsn_fig=&tema._BOHF;
%let skala=/*values=(0 to 1.5 by 0.5)*/;


%if &sprak=no %then %do;
	%let opptak_txt = 'Bosatte i opptaksområdene';
	%let format_percent = nlpct8.0;
	%let format_num = nlnum8.0;
%end;
%else %if &sprak=en %then %do;
	%let opptak_txt = 'Hospital referral area';
	%let format_percent = percent8.0;
	%let format_num = comma8.0;
%end;

*ODS Graphics ON /reset=All imagename="&tema._&type._tredelt_&fignavn" imagefmt=png border=off ;
ODS Graphics ON /reset=All imagename="&tema._&type._tredelt_&fignavn" imagefmt=&bildeformat border=off height=500px;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&dsn_fig noborder noautolegend sganno=&anno pad=(Bottom=5%);
hbarparm category=bohf response=RateSnitt_tot / fillattrs=(color=CX95BDE6) outlineattrs=(color=CX00509E) missing name="hp1" legendlabel="&label_3";
hbarparm category=bohf response=RateSnitt_12 / fillattrs=(color=CX568BBF) outlineattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_2";
hbarparm category=bohf response=RateSnitt&del1. / fillattrs=(color=CX00509E) outlineattrs=(color=CX00509E) missing name="hp3" legendlabel="&label_1" ; 

hbarparm category=bohf response=RateSnittN_tot / fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C); 
hbarparm category=bohf response=RateSnittN_12 / fillattrs=(color=CX969696) outlineattrs=(color=CX4C4C4C);
hbarparm category=bohf response=RateSnittN&del1. / fillattrs=(color=CX4C4C4C) outlineattrs=(color=CX4C4C4C);

	keylegend "hp3" "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=7 weight=bold);
	 Yaxistable &tabellvariable/Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
    

    yaxis display=(noticks noline) label=&opptak_txt labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);

     %if &noxlabel=1 %then %do;
	 xaxis display=(nolabel) offsetmin=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	 %end;
	 %else %do;
	 xaxis /*display=(nolabel)*/ offsetmin=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	 %end;
		Label &labeltabell;
		Format Andel&del1. Andel&del2. Andel&del3. &format_percent tot_antall &format_num  &formattabell;

run;
Title; 
ods listing close;
%mend;


