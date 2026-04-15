/* Endringslogg: 
-Janice 17.06.2021 
-Tove 15.04.2026, endrer hvordan CSV-filen leses inn, og tar ut 'boshhn'
*/

/* Makro for å lage formater til boområder */
/* Husk å definere filbane før makro kjøres */

/* Input: tre CSV-filer:
            boomr.csv
            forny_komnr.csv
*/
/* Output formater:
      Navn på formatene:
         bosh_fmt
         bohf_fmt
         borhf_fmt
         bodps_fmt
         bydel_fmt
         komnr_fmt
*/
/* Formatene kan blant annet brukes i et datasteg:

   Data utdata;
   Set inndata;
   Format bohf bohf_fmt. ;
   Run;

 */


/* hente inn CSV-fil med definerte opptaksområder */
proc import 
	datafile="&filbane/formater/boomr.csv"
    out=bo
    dbms=csv
    replace;
    delimiter=';';
    getnames=yes;      /* Use first row as variable names */
    datarow=3;         /* Data starts on line 3 */
    guessingrows=1000;
run;

/* ---------------------- */
/*  Lagre filen på HNREF  */  
/* ---------------------- */ 
data hnref.boomr;
   set bo;
run;


/* -------- */
/*  BOSH  */  
/* -------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bosh_fmt(keep=bosh bosh_navn);                                                                                                        
   by bosh;  
   where bosh is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_bosh_2025(rename=(bosh=start) keep=bosh fmtname label);                                                                                    
   retain fmtname 'bosh_fmt';                                                                                                 
   length bosh_navn $60.;                                                                                                                    
   set bosh_fmt; 
   label = cat(bosh_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_bosh_2025; run;

 
/* -------- */
/*   BOHF   */  
/* -------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bohf_fmt(keep=bohf bohf_navn);                                                                                                        
   by bohf;   
   where bohf is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_bohf(rename=(bohf=start) keep=bohf fmtname label);                                                                                    
   retain fmtname 'bohf_fmt';                                                                                                 
   length bohf_navn $60.;                                                                                                                    
   set bohf_fmt; 
   label = cat(bohf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_bohf; run;


/* --------- */
/*   BORHF   */  
/* --------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=borhf_fmt(keep=borhf borhf_navn);                                                                                                        
   by borhf;                                                                                                                                
   where  borhf is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_borhf(rename=(borhf=start) keep=borhf fmtname label);                                                                                    
   retain fmtname 'borhf_fmt';                                                                                                 
   length borhf_navn $60.;                                                                                                                    
   set borhf_fmt; 
   label = cat(borhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_borhf; run;


/* --------- */
/*   BYDEL   */  
/* --------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bydel_fmt(keep=bydel bydel_navn);                                                                                                        
   by bydel;                                                                                                                                
   where bydel is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_bydel(rename=(bydel=start) keep=bydel fmtname label);                                                                                    
   retain fmtname 'bydel_fmt';                                                                                                 
   length bydel_navn $60.;                                                                                                                    
   set bydel_fmt; 
   label = cat(bydel,"", substr(bydel_navn,4)); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_bydel; run;


/* --------- */
/*   KOMNR   */  
/* --------- */  

proc import 
	datafile="&filbane/formater/forny_komnr.csv"
    out=forny_kom
    dbms=csv
    replace;
    delimiter=';';
    getnames=yes;      /* Use first row as variable names */
    datarow=3;         /* Data starts on line 3 */
    guessingrows=1000;
run;

/* kun beholde gml komnr og navn fra forny_komnr-csv */
data komnr_fmt2(keep=komnr komnr_navn);
set forny_kom(rename=(gml_komnr=komnr gml_navn=komnr_navn));
run;

/* Remove duplicate values fra boområde-csv */
proc sort data=bo nodupkey out=komnr_fmt1(keep=komnr komnr_navn);                                                                                                        
   by komnr;                                                                                                                                
   where komnr is not missing;                                                                                                                              
run; 

data komnr_fmt;
set komnr_fmt1 komnr_fmt2;
run;

/* Build format data set */                                                                                                            
data hnref.fmtfil_komnr(rename=(komnr=start) keep=komnr fmtname label);                                                                                    
   retain fmtname 'komnr_fmt';                                                                                                 
   length komnr_navn $60.;                                                                                                                    
   set komnr_fmt; 
   label = cat(komnr_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_komnr; run;


/* ------- */
/*   DPS   */  
/* ------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bodps_fmt(keep=bodps bodps_navn);                                                                                                        
   by bodps;   
   where bodps is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data hnref.fmtfil_bodps(rename=(bodps=start) keep=bodps fmtname label);                                                                                    
   retain fmtname 'bodps_fmt';                                                                                                 
   length bodps_navn $60.;                                                                                                                    
   set bodps_fmt; 
   label = cat(bodps_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_bodps; run;

proc datasets nolist;
delete bo: bydel_fmt forny_kom komnr: bodps_fmt; 
run;