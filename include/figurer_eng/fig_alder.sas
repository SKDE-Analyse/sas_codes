/*
Årsvariasjonfigur
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=&data noautolegend noborder sganno=anno pad=(Bottom=4% );
styleattrs datacolors=(CX00509E CX95BDE6) DATACONTRASTCOLORS=(CX00509E);
	vbar alder_gr / response=&verdi /*stat=sum*/ group=ermann groupdisplay=cluster name="Vbar";
	keylegend "Vbar" / location=outside position=topright noborder titleattrs=(size=&fontst);
    yaxis &yvalues label="&verdinavn" 
		labelattrs=(size=&fontst)  valuesformat=&yformat. valueattrs=(size=&fontst);
	xaxis fitpolicy=rotate offsetmin=0.035 label='Age' labelattrs=(size=&fontst) valuesformat=&yformat. valueattrs=(size=&fontst);
run;
ods graphics off;

