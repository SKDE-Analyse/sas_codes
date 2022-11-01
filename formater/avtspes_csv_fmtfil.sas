/* Opprettet 31.03.2022 Tove J */

/* Makro for å sette på formater for avtalespesialister - fungerer kun når vi ser på avtspes data separat. 
    Variabel institusjonID inneholder orgnr i somatikk-fil, her er det reshID-er. */
/* Husk å definere filbane før makro kjøres */

/* Navn på formatene:

*/

/* Bruk av formater i datasteg */
        /*  
        data utdata;
        set inndata;
        format institusjonID avtspes_fmt.  ;
        run; 
        */

/* Det gjøres en kontroll etter innlasting av CSV for å sjekke for duplikate verdier */
/* Hvis det er duplikate verdier slettes datasettet behandler og det kommer en melding om ABORT i SAS-logg */



data avt;
  infile "&filbane/formater/avtalespesialister.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format orgnr 10.;
  format org_navn $100.;
  format kommentar $400.;

  input	
   orgnr
   org_navn $
   kommentar $
	;
run;
     
/* --------------------------------------------------------------- */
/*  Kontroll at det ikke er duplikate organisasjonsnummer i filen  */  
/* --------------------------------------------------------------- */
/* Sortere etter organisasjonsnummer først */
proc sort data=avt;
by orgnr;
run;

/* Hvis duplikat blir makro-variabel duplikat = 1 */
/* SAS gjør i tillegg en ABORT */
data avt;
set avt;
by orgnr;
if first.orgnr = 0 or last.orgnr = 0 then do;
 CALL SYMPUTX('duplikat', 1);
abort;
end;
else CALL SYMPUTX('duplikat',0);
run;

/* Hvis det er duplikate orgnr slettes filen */
%if &duplikat = 1 %then %do;
proc delete data=avt;
run;
%end;

/* --------- */
/*  AVTSPES  */  
/* --------- */                                                                           
/* Remove duplicate values */
proc sort data=avt nodupkey out=avt_fmt(keep=orgnr org_navn);                                                                                                        
   by orgnr;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_avtspes(rename=(orgnr=start) keep=orgnr fmtname label);                                                                                    
   retain fmtname 'avtspes_fmt';                                                                                                 
   length org_navn $60.;                                                                                                                    
   set avt_fmt; 
   label = cat(orgnr,"",org_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_avtspes; run;

proc datasets nolist;
delete avt avt_fmt ;
run;