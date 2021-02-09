
/* Makro for å sette på formater for behsh, behhf, behrhf */
/* Kjør makro i prosjekt  - %fmt_behandler; */
/* Bruk formater i datasteg */
        /*  
        data utdata;
        set inndata;
        format behsh behsh_fmt. behhf behhf_fmt. behrhf behrhf_fmt. ;
        run; 
        */

/* Husk å definere csvbane hvor CSV-ligger lagret før makro kjøres */



data behandler;
  infile "&csvbane\behandler.csv"
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
     
/* ------- */
/*  BEHSH  */  
/* ------- */                                                                           
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behsh_fmt(keep=behsh behsh_navn);                                                                                                        
   by behsh;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_behsh(rename=(behsh=start) keep=behsh fmtname label);                                                                                    
   retain fmtname 'behsh_fmt';                                                                                                 
   length behsh_navn $60.;                                                                                                                    
   set behsh_fmt; 
   label = cat(behsh_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_behsh; run;

/* ------- */
/*  BEHHF  */  
/* ------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behhf_fmt(keep=behhf behhf_navn);                                                                                                        
   by behhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_behhf(rename=(behhf=start) keep=behhf fmtname label);                                                                                    
   retain fmtname 'behhf_fmt';                                                                                                 
   length behhf_navn $60.;                                                                                                                    
   set behhf_fmt; 
   label = cat(behhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_behhf; run;


/* ---------------- */
/*  BEHHF_navnkort  */  
/* ---------------- */ 
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behhfkort_fmt(keep=behhf behhf_navnkort);                                                                                                        
   by behhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_behhfkort(rename=(behhf=start) keep=behhf fmtname label);                                                                                    
   retain fmtname 'behhfkort_fmt';                                                                                                 
   length behhf_navn $60.;                                                                                                                    
   set behhfkort_fmt; 
   label = cat(behhf_navnkort); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_behhfkort; run;



/* -------- */
/*  BEHRHF  */  
/* -------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhf_fmt(keep=behrhf behrhf_navn);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_rhf(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhf_fmt';                                                                                                 
   length behrhf_navn $60.;                                                                                                                    
   set behrhf_fmt; 
   label = cat(behrhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_rhf; run;


/* ----------------- */
/*  BEHRHF_navnkort  */  
/* ----------------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhfnavnkort_fmt(keep=behrhf behrhf_navnkort);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_rhfkort(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhfkort_fmt';                                                                                                 
   length behrhf_navn $60.;                                                                                                                    
   set behrhfnavnkort_fmt; 
   label = cat(behrhf_navnkort); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_rhfkort; run;


/* -------------------- */
/*  BEHRHF_navnkortest  */  
/* -------------------- */
/* Remove duplicate values */
proc sort data=behandler nodupkey out=behrhfnavnkortest_fmt(keep=behrhf behrhf_navnkortest);                                                                                                        
   by behrhf;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_rhfkortest(rename=(behrhf=start) keep=behrhf fmtname label);                                                                                    
   retain fmtname 'behrhfkortest_fmt';                                                                                                 
   length behrhf_navnkortest $60.;                                                                                                                    
   set behrhfnavnkortest_fmt; 
   label = cat(behrhf_navnkortest); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_rhfkortest; run;




/*ORGNR*/  
/* Remove duplicate values */
proc sort data=behandler nodupkey out=orgnr_fmt(keep=orgnr org_navn);                                                                                                        
   by orgnr;                                                                                                                                
run; 
/* Build format data set */                                                                                                            
data fmtfil_orgnr(rename=(orgnr=start) keep=orgnr fmtname label);                                                                                    
   retain fmtname 'org_fmt';                                                                                                 
   length org_navn $100.;                                                                                                                    
   set orgnr_fmt; 
   label = cat(org_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_orgnr; run;


