/*Makroen lager en tabell for å sjekke NPIdReg-variabelen mot personopplysningsdata*/

%Macro sjekk_NPRIdReg(mappe=, rot=);

data Test_&aar;
  set &mappe.&rot.&aar;
run;

%include "&filbane.\makroer\VarFraParvus.sas";
%VarFraParvus(dsnMagnus=Test_&aar, var_som=kjonn_ident19062018 fodselsaar_ident19062018,var_avtspes=);


proc format;
   value NPRID_REG
      1 = 'Fødselsnummer/ D-nummer er ok.'  
      2 = 'Ulikt kjønn i fødselsnummer/ D-nummer og i aktivitetsdata.'  
      3 = 'Ulikt fødselsår i fødselsnummer/ D-nummer og i aktivitetsdata.'  
      4 = 'Fødselsnummer/ D-nummer mangler.'  
      5 = 'Dødsdato i Det sentrale folkeregister er før inndato.' ;
quit;

data Test_&aar;
  Set Test_&aar;
  
  rename kjonn_ident19062018=kjonn_ident;
  rename fodselsaar_ident19062018=fodselsaar_ident;

  Tidsdiff=.;
  Dod_for_inndato=.;
  Tidsdiff=doddato-inndato;

  format NPRId_reg NPRId_reg.;

  If tidsdiff ne . then do;
    if Tidsdiff lt 0 then Dod_for_inndato=1;
  end;

run;

data Avd_&aar;
  Set Test_&aar;
 
  where aktivitetskategori3 ne .;
  
  if nprID_reg ne 4 then do;
           If ermann=.   and kjonn_ident not in (0,9) then ulikt_kjonn=1;
      else if Ermann = 0 and kjonn_ident ne 2         then ulikt_kjonn=1;
      else if ermann = 1 and kjonn_ident ne 1         then ulikt_kjonn=1;

      if fodselsar ne fodselsaar_ident then ulikt_fodtar=1;
  end;

run;

PROC FREQ DATA=Test_&aar ORDER=INTERNAL;
	TABLES NPRId_reg /  SCORES=TABLE;
	TABLES Dod_for_inndato /  SCORES=TABLE;
RUN;

PROC TABULATE DATA=AVD_&aar;
	CLASS NPRId_reg ulikt_kjonn ulikt_fodtar /	ORDER=UNFORMATTED MISSING;
	TABLE ulikt_kjonn ulikt_fodtar NPRId_reg,
	N 		;
RUN;

PROC TABULATE DATA=AVD_&aar;
	where kjonn_ident ne .;
	CLASS ulikt_kjonn  /	ORDER=UNFORMATTED MISSING;
	TABLE ulikt_kjonn ,
	N 		;
RUN;

PROC TABULATE DATA=AVD_&aar;
	where fodselsaar_ident ne .;
	CLASS ulikt_fodtar  /	ORDER=UNFORMATTED MISSING;
	TABLE ulikt_fodtar ,
	N 		;
RUN;

%Mend sjekk_NPRIdReg;