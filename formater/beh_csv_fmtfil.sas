/* Endringslogg: Sist endret av Janice 17.06.2021 */

/* Makro for å sette på formater for behsh, behhf, behrhf */
/* Husk å definere filbane før makro kjøres */

/* Navn på formatene:
   behsh_fmt
   behhf_fmt
   behhfkort_fmt
   behrhf_fmt
   rhfkort_fmt
   rhfkortest_fmt
   orgnr_fmt
*/

/* Bruk av formater i datasteg */
        /*  
        data utdata;
        set inndata;
        format behsh behsh_fmt. behhf behhf_fmt. behrhf behrhf_fmt. ;
        run; 
        */

/* Det gjøres en kontroll etter innlasting av CSV for å sjekke for duplikate verdier */
/* Hvis det er duplikate verdier slettes datasettet behandler og det kommer en melding om ABORT i SAS-logg */


data behandler;
  infile "&filbane/formater/behandler.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format orgnr 10.;
  format org_navn $100.;
  format behsh 3.;
  format behsh_navn $60.;
  format behhf 3.;
  format behhf_navn $60.;
  format behhf_navnkort $60.;
  format behrhf 1.;
  format behrhf_navn $60.;
  format behrhf_navnkort $60.;
  format behrhf_navnkortest $10.;
  format kommentar $400.;

  input	
   orgnr
   org_navn $
	behsh 
	behsh_navn $
	behhf
	behhf_navn $
	behhf_navnkort $
	behrhf 
	behrhf_navn $
	behrhf_navnkort $
	behrhf_navnkortest $
	kommentar $
	;
run;
     
/* --------------------------------------------------------------- */
/*  Kontroll at det ikke er duplikate organisasjonsnummer i filen  */  
/* --------------------------------------------------------------- */
/* Sortere etter organisasjonsnummer først */
proc sort data=behandler;
by orgnr;
run;

/* Hvis duplikat blir makro-variabel duplikat = 1 */
/* SAS gjør i tillegg en ABORT */
data behandler;
set behandler;
by orgnr;
if first.orgnr = 0 or last.orgnr = 0 then do;
 CALL SYMPUTX('duplikat', 1);
abort;
end;
else CALL SYMPUTX('duplikat',0);
run;

/* Hvis det er duplikate orgnr slettes filen */
%if &duplikat = 1 %then %do;
proc delete data=behandler;
run;
%end;


/* ------- */
/*  BEHSH  */  
/* ------- */                                                                           
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behsh_fmt(keep=behsh behsh_navn);                                                                                                        
   by behsh;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_behsh(rename=(behsh=start) keep=behsh fmtname label);                                                                                    
   retain fmtname 'behsh_fmt';                                                                                                 
   length behsh_navn $60.;                                                                                                                    
   set behsh_fmt; 
   label = cat(behsh_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_behsh; run;

/* ------- */
/*  BEHHF  */  
/* ------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behhf_fmt(keep=behhf behhf_navn);                                                                                                        
   by behhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_behhf(rename=(behhf=start) keep=behhf fmtname label);                                                                                    
   retain fmtname 'behhf_fmt';                                                                                                 
   length behhf_navn $60.;                                                                                                                    
   set behhf_fmt; 
   label = cat(behhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_behhf; run;


/* ---------------- */
/*  BEHHF_navnkort  */  
/* ---------------- */ 
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behhfkort_fmt(keep=behhf behhf_navnkort);                                                                                                        
   by behhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_behhfkort(rename=(behhf=start) keep=behhf fmtname label);                                                                                    
   retain fmtname 'behhfkort_fmt';                                                                                                 
   length behhf_navn $60.;                                                                                                                    
   set behhfkort_fmt; 
   label = cat(behhf_navnkort); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_behhfkort; run;



/* -------- */
/*  BEHRHF  */  
/* -------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhf_fmt(keep=behrhf behrhf_navn);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_behrhf(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhf_fmt';                                                                                                 
   length behrhf_navn $60.;                                                                                                                    
   set behrhf_fmt; 
   label = cat(behrhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_behrhf; run;


/* ----------------- */
/*  BEHRHF_navnkort  */  
/* ----------------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhfnavnkort_fmt(keep=behrhf behrhf_navnkort);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_rhfkort(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhfkort_fmt';                                                                                                 
   length behrhf_navn $60.;                                                                                                                    
   set behrhfnavnkort_fmt; 
   label = cat(behrhf_navnkort); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_rhfkort; run;


/* -------------------- */
/*  BEHRHF_navnkortest  */  
/* -------------------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhfnavnkortest_fmt(keep=behrhf behrhf_navnkortest);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_rhfkortest(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhfkortest_fmt';                                                                                                 
   length behrhf_navnkortest $60.;                                                                                                                    
   set behrhfnavnkortest_fmt; 
   label = cat(behrhf_navnkortest); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_rhfkortest; run;



/* --- */
/*ORGNR*/  
/* --- */

/* Remove duplicate values */
proc sort data=behandler nodupkey out=orgnr_fmt(keep=orgnr org_navn);                                                                                                        
   by orgnr;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_orgnr(rename=(orgnr=start) keep=orgnr fmtname label);                                                                                    
   retain fmtname 'org_fmt';                                                                                                 
   length org_navn $100.;                                                                                                                    
   set orgnr_fmt; 
   label = cat(org_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_orgnr; run;


proc datasets nolist;
delete beh: orgnr_fmt ;
run;