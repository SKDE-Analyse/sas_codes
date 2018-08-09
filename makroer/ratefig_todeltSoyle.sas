
/*Ratefigur med todelt s�yle, eks andel off/privat eller andel kreft/ikke kreft*/

/* Need to run the 'merge' macro first before running this one.  The output from 'merge' is the input for this */
/* creates a figure so that first column is rate from dataset1, and second column from dataset2 */

%macro ratefig_todeltSoyle(datasett=);
proc sort data=&datasett;
by tot_rate;
run;

data &datasett;
set &datasett;
drop tot_raterank;
run;

data &datasett;
set &datasett;
tot_raterank+1;
run;

data &datasett;
set &datasett;
if tot_raterank=2 then min2=tot_rate;
if tot_raterank=rader-1 then max2=tot_rate;
if tot_raterank=3 then min3=tot_rate;
if tot_raterank=rader-1 then max3=tot_rate;
run;

proc sql;
   create table &datasett as 
   select *, max(tot_rate) as mmax1, min(tot_rate) as mmin1, max(min2) as mmin2, max(max2) as mmax2, max(min3) as mmin3, max(max3) as mmax3,
   max(ntot_rate) as Norge_tot_rate
from &datasett;
quit;

data &datasett;
set &datasett;
Length Mistextrate $ 10;
FTr1=round((mmax1/mmin1),0.01);
FTr2=round((mmax2/mmin2),0.01);
FTr3=round((mmax3/mmin3),0.01);
tot_rate2=tot_rate;
drop max1 min1 min2 min3 max2 max3 mm:;
plass_rate=Norge_tot_rate/100;
if tot_antall<&nkrav then do;
	tot_rate=.;
	rate_1=.;
	rate_2=.;
	rate_3=.;
	Misstextrate="N<&nkrav";
end;
run;

data &datasett;
set &datasett;
tot_min=tot_rate_2014;
if tot_rate_2015 lt tot_min then tot_min = tot_rate_2015;
if tot_rate_2016 lt tot_min then tot_min = tot_rate_2016;

tot_max=tot_rate_2014;
if tot_rate_2015 gt tot_max then tot_max = tot_rate_2015;
if tot_rate_2016 gt tot_max then tot_max = tot_rate_2016;
run;

Data _null_;
set &datasett;
call symput('FTr1', trim(left(put(FTr1,8.2))));
call symput('FTr2', trim(left(put(FTr2,8.2))));
call symput('FTr3', trim(left(put(FTr3,8.2))));
run;

proc sort data=&datasett;
by descending tot_rate;
run;

ODS Graphics ON /reset=All imagename="&tema._&type._todelt_&fignavn" imagefmt=png border=off ;
*DS Graphics ON /reset=All imagename="&tema._&type._todelt_&fignavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=bohf response=tot_rate / fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_2"; 
hbarparm category=bohf response=Ntot_rate / fillattrs=(color=CXC3C3C3);
hbarparm category=bohf response=rate_1 / fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_1"; 
hbarparm category=bohf response=nrate_1 / fillattrs=(color=CX4C4C4C);
	scatter x=plass_rate y=bohf /datalabel=Misstextrate datalabelpos=right markerattrs=(size=0) ;
	scatter x=plass_rate y=bohf /datalabel=andel_rate1 datalabelpos=right markerattrs=(size=0) 
        datalabelattrs=(color=white weight=bold size=8);
		keylegend "hp2" "hp1"/ location=inside position=bottomright down=2 noborder titleattrs=(size=6);
	 Yaxistable &tabellvariable /Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Opptaksomr�de' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis /*display=(nolabel)*/ offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=7) label="&xlabel" labelattrs=(size=7 weight=bold);
	 	%if &vis_ft=1 %then %do;
			inset "FT1=&FTr1" "FT2=&FTr2" "FT3=&FTr3" / position=right textattrs=(size=10);
		%end;
		%if &vis_aarsvar=1 %then %do;
			%if &ratestart=2014 %then %do;
			scatter x=tot_rate_2014 y=Bohf / markerattrs=(symbol=squarefilled color=black);
			scatter x=tot_rate_2015 y=Bohf / markerattrs=(symbol=circlefilled color=black); 
			scatter x=tot_rate_2016 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			%end;
			%if &ratestart=2015 %then %do;
			scatter x=tot_rate_2015 y=Bohf / markerattrs=(symbol=circlefilled color=black); 
			scatter x=tot_rate_2016 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			%end;
			%if &ratestart=2016 %then %do;
			scatter x=tot_rate_2016 y=Bohf / markerattrs=(symbol=trianglefilled color=black); 
			Highlow Y=Bohf low=tot_Min high=tot_Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 
			%end;
		%end;
		Label &labeltabell;
		Format &formattabell andel_rate1 nandel_rate1 nlpct8.1;
run;Title; ods listing close;
proc datasets nolist;
delete dsn:;
run;
%mend ratefig_todeltSoyle;