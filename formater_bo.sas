

/* Makro for � lage formater til boomr�der */


/* hente inn CSV-fil med definerte opptaksomr�der pr 01.01.2020 */
data bo;
  infile "&filbane\data\boomr.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format bohf 4.;
  format bohf_navn $60.;
  format boshhn 2.;
  format boshhn_navn $15.;
  format borhf 4.;
  format borhf_navn $60.;
  format kommentar $400.;
 
  input	
  	komnr komnr_navn $ bydel bydel_navn $ bohf bohf_navn $ boshhn boshhn_navn $ borhf borhf_navn $ kommentar $
	  ;
  run;


    
/* -------- */
/*  BOSHHN  */  
/* -------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=boshhn_fmt(keep=boshhn boshhn_navn);                                                                                                        
   by boshhn;  
   where boshhn is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data fmtfil_boshhn(rename=(boshhn=start) keep=boshhn fmtname label);                                                                                    
   retain fmtname 'boshhn_fmt';                                                                                                 
   length boshhn_navn $60.;                                                                                                                    
   set boshhn_fmt; 
   label = cat(boshhn_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_boshhn; run;


 
/* -------- */
/*   BOHF   */  
/* -------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bohf_fmt(keep=bohf bohf_navn);                                                                                                        
   by bohf;   
   where bohf is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data fmtfil_bohf(rename=(bohf=start) keep=bohf fmtname label);                                                                                    
   retain fmtname 'bohf_fmt';                                                                                                 
   length bohf_navn $60.;                                                                                                                    
   set bohf_fmt; 
   label = cat(bohf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_bohf; run;


/* --------- */
/*   BORHF   */  
/* --------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=borhf_fmt(keep=borhf borhf_navn);                                                                                                        
   by borhf;                                                                                                                                
   where  borhf is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data fmtfil_borhf(rename=(borhf=start) keep=borhf fmtname label);                                                                                    
   retain fmtname 'borhf_fmt';                                                                                                 
   length borhf_navn $60.;                                                                                                                    
   set borhf_fmt; 
   label = cat(borhf_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_borhf; run;


/* --------- */
/*   BYDEL   */  
/* --------- */                                                                           
/* Remove duplicate values */
proc sort data=bo nodupkey out=bydel_fmt(keep=bydel bydel_navn);                                                                                                        
   by bydel;                                                                                                                                
   where bydel is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data fmtfil_bydel(rename=(bydel=start) keep=bydel fmtname label);                                                                                    
   retain fmtname 'bydel_fmt';                                                                                                 
   length bydel_navn $60.;                                                                                                                    
   set bydel_fmt; 
   label = cat(bydel_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_bydel; run;


/* --------- */
/*   KOMNR   */  
/* --------- */    

data forny_kom;
  infile "&filbane\data\forny_komnr.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format aar 4.;
  format gml_komnr 4.;
  format gml_navn $30.;
  format ny_komnr 4.;
  format ny_navn $30.;
  format kommentar $350.;
  format kommentar2 $350.;

  input	
  	aar gml_komnr gml_navn $ ny_komnr ny_navn $ kommentar $ kommentar2 $
	;
run;

/* kun beholde gml komnr og navn fra forny_komnr-csv */
data komnr_fmt2(keep=komnr komnr_navn);
set forny_kom(rename=(gml_komnr=komnr gml_navn=komnr_navn));
run;

/* Remove duplicate values fra boomr�de-csv */
proc sort data=bo nodupkey out=komnr_fmt1(keep=komnr komnr_navn);                                                                                                        
   by komnr;                                                                                                                                
   where komnr is not missing;                                                                                                                              
run; 

data komnr_fmt;
set komnr_fmt1 komnr_fmt2;
run;

/* Build format data set */                                                                                                            
data fmtfil_komnr(rename=(komnr=start) keep=komnr fmtname label);                                                                                    
   retain fmtname 'komnr_fmt';                                                                                                 
   length komnr_navn $60.;                                                                                                                    
   set komnr_fmt; 
   label = cat(komnr_navn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_komnr; run;


