/*
Forholdstall mellom ung og gammel
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=&datasett noborder noautolegend sganno=anno pad=(Bottom=4%);
hbarparm category=bohf response=pros_neg / baseline=1 fillattrs=(color=CX00509E) missing name="h1" legendlabel="Høyere rate i aldersgruppen 50 - 74" barwidth=&soylebredde; 
hbarparm category=bohf response=pros_neg_no / baseline=1 fillattrs=(color=CX4C4C4C) barwidth=&soylebredde;
hbarparm category=bohf response=pros_pos / baseline=1 fillattrs=(color=CX95BDE6) missing name="h2" legendlabel="Høyere rate i aldersgruppen 75+" barwidth=&soylebredde; 
hbarparm category=bohf response=pros_pos_no / baseline=1 fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;	
	  scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=center markerattrs=(size=0) datalabelattrs=(color=black size=7);
     Yaxistable rate_femti rate_syttifem /Label location=inside  position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst ) type=discrete discreteorder=data valueattrs=(size=&fontst);
   xaxis label="Forholdet mellom raten til aldersgruppen 50 - 74 og raten til aldersgruppen 75+ " type=linear labelattrs=(size=&fontst ) values=(0 to 2 by 0.1) offsetmin=0.05; 

     Format prosent prosent_no nlnum8.1 forh_tall_norm_no nlnum8.2 rate_syttifem rate_femti nlnum8.1 ;
		
run;Title; ods listing close; ods graphics off;
