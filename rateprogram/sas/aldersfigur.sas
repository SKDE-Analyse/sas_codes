
%macro aldersfigur(data =, aarstall =);
/*!
Makro for å lage aldersstruktur-figur over utvalget.

For å lett kunne se om alderssammensetningen gir mening.
*/
%local data;
%local fontst;
%local soylebredde;
%local aarstall;
%local yformat;
%local yvalues;
%local verdinavn;

%let soylebredde = 0.8;
%let fontst = 11;
%let yformat = nlnum8.0;
%let yvalues = ;
%let xvalues = ;
%let verdinavn = Antall;

PROC SQL;
   CREATE TABLE tmp_aldersfig AS
   SELECT DISTINCT aar,Alder,ErMann,(SUM(RV)) AS RV
      FROM &data
      GROUP BY aar, Alder, ErMann;	  
QUIT;

%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;
%if &silent=0 %then %do;
proc sgplot data=tmp_aldersfig noautolegend noborder sganno=anno pad=(Bottom=4% );
styleattrs datacolors=(CX00509E CX95BDE6) DATACONTRASTCOLORS=(CX00509E);
	vbar alder / response=RV stat=mean group=ermann groupdisplay=cluster name="Vbar";
	keylegend "Vbar" / location=outside position=topright noborder titleattrs=(size=&fontst);
    yaxis &yvalues label="&verdinavn" 
		labelattrs=(size=&fontst)  valuesformat=&yformat. valueattrs=(size=&fontst);
	xaxis &xvalues fitpolicy=thin offsetmin=0.035 label='Alder' labelattrs=(size=&fontst) valuesformat=&yformat. valueattrs=(size=&fontst);
run;
%end;

proc datasets nolist;
delete tmp_aldersfig;
run;


%mend;