/*

I TILLEGG TIL INPUT-VARIABLE SOM FOR RATEFIG ANGIS:

%let andel=andel_1_2;

*/

/*Enkel andelsfig*/
%macro andelsfig(datasett=);

/*Beregner forholdstall*/
proc sort data=&datasett;
by &andel;
run;

data &datasett;
set &datasett;
andel2=&andel;
drop andelrank;
run;

data &datasett;
set &datasett;
andelrank+1;
run;

data &datasett;
set &datasett;
if andelrank=2 then min2=&andel;
if andelrank=rader-1 then max2=&andel;
if andelrank=3 then min3=&andel;
if andelrank=rader-2 then max3=&andel;
if bohf=8888 then andel_norge=&andel;
run;

proc sql;
   create table &datasett as 
   select *, max(&andel) as mmax1, min(&andel) as mmin1, max(min2) as mmin2, max(max2) as mmax2, max(min3) as mmin3, max(max3) as mmax3,
   max(andel_norge) as andelN
from &datasett;
quit;

data &datasett;
set &datasett;
FTa1=round((mmax1/mmin1),0.01);
FTa2=round((mmax2/mmin2),0.01);
FTa3=round((mmax3/mmin3),0.01);
drop max1 min1 min2 min3 max2 max3 mm:;
plass=andelN/100;
run;

Data _null_;
set &datasett;
call symput('FTa1', trim(left(put(FTa1,8.2))));
call symput('FTa2', trim(left(put(FTa2,8.2))));
call symput('FTa3', trim(left(put(FTa3,8.2))));
run;

/*Tar vekk andelen for lav n*/
data &datasett;
set &datasett;
%if &vis_misstxt=1 %then %do;
if antall_1<&nkrav then do;
	&andel=.;
	Misstxt="N<&nkrav";
end;
%end;
run;

proc sort data=&datasett;
by descending &andel;
run;

ODS Graphics ON /reset=All imagename="&tema._&type._andel_&fignavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
title "&tittel";
proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=bohf response=&andel / fillattrs=(color=CX95BDE6) missing; 
hbarparm category=bohf response=andel_norge / fillattrs=(color=CXC3C3C3);
	%if &vis_misstxt=1 %then %do;
		scatter x=plass y=bohf /datalabel=Misstxt datalabelpos=right markerattrs=(size=0) ; 
	%end;
	scatter x=plass y=bohf /datalabel=&Andel datalabelpos=right markerattrs=(size=0) 
        datalabelattrs=(color=white weight=bold size=8);
		keylegend "hp1" "hp2"/ location=inside position=bottomright down=2 noborder titleattrs=(size=6);
	 Yaxistable &tabellvariable / Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis /*display=(nolabel)*/ offsetmin=0.02 offsetmax=0.02 &skala valueattrs=(size=7) label="&xlabel" labelattrs=(size=7 weight=bold);
	 	%if &vis_ft=1 %then %do; 
			inset "FTa1 = &FTA1" "FTa2 = &FTa2" "FTa3 = &FTa3" / position=right textattrs=(size=10);
		%end;
		Label &labeltabell;
		Format &formattabell &andel andel_norge &andelformat;
run;Title; ods listing close;


/*Lagrer dataene fra &datasett i &dsn1 slik at &dsn1 kan brukes til å lage IA*/
/*
data &datasett;
set &datasett;
keep bohf andel2 &innbyggvar fta:;
run;

proc sort data=&datasett;
by bohf;
quit;

proc sort data=&dsn1;
by bohf;
quit;

data &dsn1;
merge &dsn1 &datasett;
by bohf;
run;

data &dsn1;
set &dsn1;
rename andel2=andel &innbyggvar=Innbyggere_andel;
run;
*/

proc datasets nolist;
delete dsn:;
quit;
%mend andelsfig;