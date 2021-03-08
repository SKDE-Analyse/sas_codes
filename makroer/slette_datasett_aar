/*Macro for å gå gjennom alle datasett i en angitt mappe og slette 
alle datasett som inneholder rader med data fra et angitt år 
(dvs. som har rader der variabelen "aar" er lik et angitt årstall)

EKSEMPEL:

%slette_datasett_aar(lib=MINMAPPE, aar=2014);

Macroen går gjennom alle datasett i mappa MINMAPPE 
og sletter alle datasett som har en eller flere rader 
der variabelen "aar" er lik 2014.

*/

%macro slette_datasett_aar(lib, aar);

/*Macro som sletter et datasett dersom det inneholder rader med data fra et angitt år*/
%MACRO DELETE_IF(mappe, DS, yr);

		/*Lager macro-variabel DEL og setter til 0*/
		%Let DEL=0;
		%put &del;

	/* 1) Sjekk om datasettet inneholder observasjoner med aktuelt år,
		i så fall settes makrovariabelen DEL til 1 */
        DATA _NULL_;
        SET &mappe..&DS.;
		if aar=&yr. then CALL SYMPUTX('DEL', 1);
        RUN;

		%put &del;
 
	/* 2) DELETE DATASET IF DEL=1 */
	%IF &DEL. = 1 %THEN %DO;
	%put &del;
		proc datasets nolist lib=&mappe.;
 			delete &DS. ;
		quit;
	%END;
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

/*Kjører macroen DELETE_IF for alle datasettene i mappa*/
%do i=1 %to &count;
%DELETE_IF(mappe=&lib, DS=&dsname&i, yr=&aar);
%end;
%mend; 
