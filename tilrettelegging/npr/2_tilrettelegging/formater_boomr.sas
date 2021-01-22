
/* hente inn CSV-fil med definerte opptaksområder pr 01.01.2020 */
data bo;
  infile "&databane\boomr_2020.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format bohf 2.;
  format bohf_navn $60.;
  format boshhn 2.;
  format boshhn_navn $15.;
  format kommentar $400.;
 
  input	
  	komnr
  	komnr_navn $
	bydel 
	bydel_navn $
	bohf
	bohf_navn $
    boshhn
    boshhn_navn $
	kommentar $
	  ;
  run;
