/*Macro for å gå gjennom alle datasett i en angitt mappe og liste ut 
alle datasett som inneholder rader med data fra et angitt år 
(dvs. som har rader der variabelen "aar" er lik et angitt årstall), 
samt alle datasett som ikke inneholder variabelen aar

EKSEMPEL:

%liste_datasett_aar(lib=MINMAPPE, aar=2014);

*/

%macro liste_datasett_aar(lib, aar);


%MACRO LIST_IF(mappe, DS, yr);

		/*Lager macro-variabel DEL og setter til 0*/
		%Let DEL=0;
		
		/*Sjekker om aar-variabelen finnes i &DS. Hvis ikke blir chk=0.*/
		%let dsid = %sysfunc(open(&mappe..&DS,i));
		%let chk = %sysfunc(varnum(&dsid, aar));
		%let rc = %sysfunc(close(&dsid));
		/*Hvis aar-variabelen ikke finnes i &DS blir en rad lagt til i 
		datasettet mangler_aar_liste bestående av datasettnavnet &DS*/
		%if &chk = 0 %then %do;
			data mangler_aar_liste;
			set mangler_aar_liste end=eof;
			output;
				if eof then do;
					navn=%upcase("&mappe..&DS");
					output;
				end;
			run;
		%end;
		/*Hvis aar-variabelen finnes i &DS: Sjekk om &DS inneholder 
		observasjoner med aktuelt år, i så fall settes makrovariabelen DEL til 1*/
		%else %do;
		DATA _NULL_;
        SET &mappe..&DS.;
		if aar=&yr. then CALL SYMPUTX('DEL', 1);
        RUN;
	
		%end;

		/*Hvis makrovariabelen del er lik 1 så legges det til en rad i 
		datasettet slette_liste bestående av datasettnavnet &DS*/
		%if &del=1 %then %do;
			data slette_liste;
			set slette_liste end=eof;
			output;
				if eof then do;
					navn=%upcase("&mappe..&DS");
					output;
				end;
			run;
		%end;

%MEND;

/*Teller antall datasett og legger det i makrovariabelen count(?)*/
proc sql noprint;
 select count(*) into :count
 from dictionary.tables
 where libname=%upcase("&lib");
 quit;

 /*Legger alle datasettnavnene inn i macrovariablene dsname1, dsname2, dsname3 osv....*/
 proc sql noprint;
 select memname into :dsname1 - :dsname%TRIM(%LEFT(&count))
 from dictionary.tables
 where libname=%upcase("&lib");
quit;

/*Lager to nye datasett som inneholder navnene til
datasett som skal slettes eller som ikke inneholder variabelen aar*/
data slette_liste;
length navn $30;
run;

data mangler_aar_liste;
length navn $30;
run;

/*Kjører macroen LIST_IF for alle datasettene i mappa*/
%do i=1 %to &count;
%LIST_IF(mappe=&lib, DS=&dsname&i, yr=&aar);
%end;
%mend; 
