/*Ratefigur med todelt søyle, eks andel off/privat eller andel kreft/ikke kreft*/

/* Need to run the 'merge' macro first before running this one.  The output from 'merge' is the input for this */
/* creates a figure so that first column is rate from dataset1, and second column from dataset2 */

%macro ratefig_todeltSoyle(datasett=, aar1=2015, aar2=2016, aar3=2017, bildeformat=png, noxlabel=0, bohf_format=BoHF_kort, sprak=no);

proc sql;
   create table &datasett._to as 
   select *, max(ntot_rate) as Norge_tot_rate
from &datasett;
quit;

data &datasett._to;
set &datasett._to;
Length Mistextrate $ 10;
tot_rate2=tot_rate;
plass_rate=Norge_tot_rate/100;
run;

data &datasett._to;
set &datasett._to;
drop tot_raterank rader;
if tot_antall<&nkrav then do;
	tot_rate2=.;
	rate_1=.;
	rate_2=.;
	rate_3=.;
	andel_rate1=.;
	Misstextrate="N<&nkrav";
end;
run;

proc sort data=&datasett._to;
by tot_rate;
run;

data &datasett._FT;
set &datasett._to;
where tot_antall ge &nkrav;
tot_raterank+1;
run;

/*Teller antall rader i datasettet i ny variabel "rader"*/
proc sql;
   create table &datasett._FT as 
   select *, count(bohf) as rader 
   from &datasett._FT;
   quit;

/*Beregner forholdstall*/
data &datasett._FT;
set &datasett._FT;
if tot_raterank=1 then min1=tot_rate;
if tot_raterank=rader then max1=tot_rate;
if tot_raterank=2 then min2=tot_rate;
if tot_raterank=rader-1 then max2=tot_rate;
if tot_raterank=3 then min3=tot_rate;
if tot_raterank=rader-2 then max3=tot_rate;
run;

proc sql;
   create table &datasett._FT as 
   select *, max(min1) as mmin1, max(max1) as mmax1, max(min2) as mmin2, max(max2) as mmax2, max(min3) as mmin3, max(max3) as mmax3
   from &datasett._FT;
quit;

data &datasett._FT;
set &datasett._FT;
FTr1=round((mmax1/mmin1),0.01);
FTr2=round((mmax2/mmin2),0.01);
FTr3=round((mmax3/mmin3),0.01);
drop max1 min1 min2 min3 max2 max3 mm:;
keep bohf FTr1 FTr2 FTr3;
run;

/*Setter sammen modifisert inndatasett og datasett med forholdstall*/
proc sort data=&datasett._FT;
by bohf;
quit;

proc sort data=&datasett._to;
by bohf;
quit;

data &datasett;
merge &datasett._to &datasett._FT;
by bohf;
run;

data &datasett;
set &datasett;
tot_min=tot_rate_&aar1;
if tot_rate_&aar2 lt tot_min then tot_min = tot_rate_&aar2;
if tot_rate_&aar3 lt tot_min then tot_min = tot_rate_&aar3;

tot_max=tot_rate_&aar1;
if tot_rate_&aar2 gt tot_max then tot_max = tot_rate_&aar2;
if tot_rate_&aar3 gt tot_max then tot_max = tot_rate_&aar3;


*create 3 variables that look exactly like bohf;
*use them to draw scatter plot (årsvariasion) so that we can use the label for keylegend;
bohf&aar1=bohf;
bohf&aar2=bohf;
bohf&aar3=bohf;
label bohf&aar1="&aar1" bohf&aar2="&aar2" bohf&aar3="&aar3";
format bohf&aar1 bohf&aar2 bohf&aar3 &bohf_format..;

run;

Data _null_;
set &datasett;
call symput('FTr1', trim(left(put(FTr1,8.2))));
call symput('FTr2', trim(left(put(FTr2,8.2))));
call symput('FTr3', trim(left(put(FTr3,8.2))));
run;

proc sort data=&datasett;
by descending tot_rate2;
run;

%if &sprak=no %then %do;
	%let opptak_txt = 'Opptaksområde';
	%let format_percent = nlpct8.1;
%end;
%else %if &sprak=en %then %do;
	%let opptak_txt = 'Hospital referral area';
	%let format_percent = percent8.1;
%end;


ODS Graphics ON /reset=All imagename="&tema._&type._todelt_&fignavn" imagefmt=&bildeformat border=off height=500px;
*DS Graphics ON /reset=All imagename="&tema._&type._todelt_&fignavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&datasett noborder noautolegend sganno=&anno pad=(Bottom=5%);
hbarparm category=bohf response=tot_rate2 / fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_2" outlineattrs=(color=CX00509E); 
hbarparm category=bohf response=Ntot_rate / fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C);
hbarparm category=bohf response=rate_1 / fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_1" outlineattrs=(color=CX00509E); 
hbarparm category=bohf response=nrate_1 / fillattrs=(color=CX4C4C4C) outlineattrs=(color=CX4C4C4C);
	scatter x=plass_rate y=bohf /datalabel=Misstextrate datalabelpos=right markerattrs=(size=0) datalabelattrs=(size=8pt);
	scatter x=plass_rate y=bohf /datalabel=andel_rate1 datalabelpos=right markerattrs=(size=0) 
        datalabelattrs=(color=white weight=bold size=8);
		keylegend "hp2" "hp1"/ location=inside position=bottomright down=2 noborder titleattrs=(size=7);
	 Yaxistable &tabellvariable /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);

     yaxis display=(noticks noline) label=&opptak_txt labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);

	 %if &noxlabel=1 %then %do;
     xaxis display=(nolabel) offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	 %end;
	 %else %do;
	 xaxis offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	 %end;
	 	%if &vis_ft=1 %then %do;
			inset "FT1=&FTr1" "FT2=&FTr2" "FT3=&FTr3" / position=right textattrs=(size=10);
		%end;
		%if &vis_aarsvar_todelt=1 and &vis_misstxt ne 1 %then %do;
			%if &ratestart=&aar1 %then %do;
			scatter x=tot_rate_&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9) name="y3"; 
			scatter x=tot_rate_&aar2 y=Bohf&aar2 / markerattrs=(symbol=circlefilled color=grey  size=7) name="y2"; 
			scatter x=tot_rate_&aar1 y=bohf&aar1 / markerattrs=(symbol=circlefilled color=black size=5) name="y1";
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			*keylegend "y1" "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7);
			%end;
			%if &ratestart=&aar2 %then %do;
			scatter x=tot_rate_&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9) name="y3"; 
			scatter x=tot_rate_&aar2 y=Bohf&aar2 / markerattrs=(symbol=circlefilled color=grey  size=7) name="y2"; 
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			*keylegend "y1" "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7);
			%end;
			%if &ratestart=&aar3 %then %do;
			scatter x=tot_rate_&aar3 y=Bohf&aar3 / markerattrs=(symbol=circle       color=black size=9) name="y3"; 
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			*keylegend "y1" "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7);
			%end;
		%end;
		Label &labeltabell;
		Format &formattabell andel_rate1 nandel_rate1 &format_percent;
run;Title; ods listing close;
proc datasets nolist;
delete dsn: &datasett._to &datasett._FT;
run;
%mend ratefig_todeltSoyle;