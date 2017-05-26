

DATA femti_&datasett;
set &dsn_femti._bohf;
	keep bohf rateSnitt &dsn_femti rate_femti;
	rate_femti = ratesnitt;
	drop ratesnitt;
run;


DATA syttifem_&datasett;
set &dsn_syttifem._bohf;
	keep bohf rateSnitt &dsn_syttifem rate_syttifem;
	rate_syttifem = ratesnitt;
	drop rateSnitt;
run;


proc sort data=femti_&datasett;
	by bohf;
run;


proc sort data=syttifem_&datasett;
	by bohf;
run;


data &datasett;
merge femti_&datasett syttifem_&datasett;
	by bohf;
	forh_tall = rate_syttifem/rate_femti;
run;

data &datasett;
set &datasett;
	if bohf = 8888 then forh_tall_no = forh_tall;
	prosent = forh_tall ;
	if bohf = 8888 then prosent_no = prosent;
	if prosent > 1 then do;
		pros_pos = prosent;
		if bohf = 8888 then pros_pos_no = prosent;
	end;
	if prosent < 1 then do;
		pros_neg = prosent;
		if bohf = 8888 then pros_neg_no = prosent;
	end;
	Length Mistext $ 10;
	if &dsn_syttifem lt 30 then do;
	 rate_syttifem =.;
	 pros_neg =.;
     Mistext="N<30";
     Plassering=&MisT_posisjon;
	 prosent=.;
end;
	label rate_femti="Rate 50-74" rate_syttifem="Rate 75+" str_tot_unik='Pasienter 75+' str50pluss_tot_unik='Pasienter 50-74' ; 
run;


proc sql;
   create table &datasett as 
   select *, max(rate_syttifem) as maks75, min(rate_syttifem) as min75, max(rate_femti) as maks50, min(rate_femti) as min50
   from &datasett;
   quit;

data &datasett; 
set &datasett;
FT_50=round((maks50/min50),0.1);
FT_75=round((maks75/min75),0.1);
drop maks: min50 min75;
run;

Data _null_;
set &datasett;
call symput('FT_50', trim(left(put(FT_50,8.1))));
call symput('FT_75', trim(left(put(FT_75,8.1))));
run;

proc sort data=&datasett;
	by descending prosent;
run;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=10%);
hbarparm category=bohf response=pros_neg / baseline=1 fillattrs=(color=CX00509E) missing name="h1" legendlabel="Høyere rate i aldersgruppen 50 - 74"; 
hbarparm category=bohf response=pros_neg_no / baseline=1 fillattrs=(color=CX4C4C4C);
hbarparm category=bohf response=pros_pos / baseline=1 fillattrs=(color=CX95BDE6) missing name="h2" legendlabel="Høyere rate i aldersgruppen 75+"; 
hbarparm category=bohf response=pros_pos_no / baseline=1 fillattrs=(color=CXC3C3C3);	
	  scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=center markerattrs=(size=0) 
          datalabelattrs=(color=black weight=bold);
     Yaxistable rate_femti rate_syttifem /Label location=inside  position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
   xaxis label="Forholdet mellom raten til aldersgruppen 50 - 74 og raten til aldersgruppen 75+ " type=linear labelattrs=(size=7 weight=bold) values=(0 to 2 by 0.1) offsetmin=0.05; 

  inset "    FT 75+ år    = &FT_75   " "    FT 50-74 år = &FT_50   "/ border position=&FT_posisjon textattrs=(size=8);
  	Keylegend 'h1' 'h2' / autoitemsize valueattrs=(size=7) noborder location=outside position=top;
     Format prosent prosent_no nlnum8.1 forh_tall_norm_no nlnum8.2 rate_syttifem rate_femti nlnum8.1 ;
		
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=10%);
hbarparm category=bohf response=pros_neg / baseline=1 fillattrs=(color=CX00509E) missing name="h1" legendlabel="Høyere rate i aldersgruppen 50 - 74"; 
hbarparm category=bohf response=pros_neg_no / baseline=1 fillattrs=(color=CX4C4C4C);
hbarparm category=bohf response=pros_pos / baseline=1 fillattrs=(color=CX95BDE6) missing name="h2" legendlabel="Høyere rate i aldersgruppen 75+"; 
hbarparm category=bohf response=pros_pos_no / baseline=1 fillattrs=(color=CXC3C3C3);
	
	  scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=center markerattrs=(size=0) 
          datalabelattrs=(color=black weight=bold);
     Yaxistable rate_femti rate_syttifem /Label location=inside  position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
   xaxis label="Forholdet mellom raten til aldersgruppen 50 - 74 og raten til aldersgruppen 75+ " type=linear labelattrs=(size=7 weight=bold) values=(0 to 2 by 0.1) offsetmin=0.05; 

  inset "    FT 75+ år    = &FT_75   " "    FT 50-74 år = &FT_50   "/ border position=&FT_posisjon textattrs=(size=8);
  	Keylegend 'h1' 'h2' / autoitemsize valueattrs=(size=7) noborder location=outside position=top;
     Format prosent prosent_no nlnum8.1 forh_tall_norm_no nlnum8.2 rate_syttifem rate_femti nlnum8.1 ;
		
run;Title; ods listing close; ods graphics off;


Proc datasets nolist;
delete femti: sytti:;
run;


