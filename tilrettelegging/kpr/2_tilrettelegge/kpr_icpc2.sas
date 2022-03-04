/* 
- Lage egen variabel som heter icpc2_hdiag, icpc2_kap, icpc2_type
    - gjelder for de med kodeverk 1 og 2 (icpc2 og icpc2 beriket)
    - flertallet bruker icpc2, slik at icpc2 beriket gis også en vanlig icpc2-kode
    - sette på format på icpc2_hdiag
 */

%macro kpr_icpc2(inndata=, utdata=);

data icpc2_data icpc2b_data rest;
  set &inndata;
  drop icpc2: ; /*slette gamle icpc2_*variabler som er i datasett*/
  if kodeverk eq 1 then output icpc2_data;
  else if kodeverk eq 2 then output icpc2b_data;
  else output rest;
  run;

/*-----------------*/
/* ICPC2-diagnoser */
/*-----------------*/

data icpc2_data2;
set icpc2_data;

/*hent ut første tegn*/
forste_tegn = upcase(substr(hoveddiagnoseKode,1,1));
/*hent ut tegn to og tre*/
type_tmp = substr(hoveddiagnosekode,2,2);

/*gyldige organkapittel (og bindestrek) for ICPC2-diagnoser*/
if forste_tegn in ("-","A","B","D","F","H","K","L","N","P","R","S","T","U","W","X","Y","Z") then do;

	if forste_tegn ne "-" then do; /*for alle unntatt bindestrek*/
		icpc2_hdiag = hoveddiagnoseKode; 
		icpc2_kap = forste_tegn;
		if type_tmp in (01:29) then icpc2_type = 1; /*sympt./plager*/
		if type_tmp in (70:99) then icpc2_type = 2; /*diag./sykdom*/
	end;

	if type_tmp in (30:69) then do; 
		icpc2_hdiag = type_tmp;
		icpc2_type = 3;
	end;

end;
drop forste_tegn type_tmp;
format icpc2_hdiag $icpc2_fmt.;
run;

/*-------------------------*/
/* ICPC2-beriket diagnoser */
/*-------------------------*/
data icpc2b_data2;
set icpc2b_data;

/*hent ut første tegn*/
forste_tegn = upcase(substr(hoveddiagnoseKode,1,1));
/*fjerne fire siste tegn som utgjør beriket*/
type_tmp = substr(hoveddiagnosekode,2, length(hoveddiagnosekode)-5);

/*-------------------------------------------------*/
/*gyldige organkapittel for ICPC2-beriket diagnoser*/
/*-------------------------------------------------*/
if forste_tegn in ("A","B","D","F","H","K","L","N","P","R","S","T","U","W","X","Y","Z") then do;

		icpc2_hdiag = compress(cat(forste_tegn,type_tmp)); 
		icpc2_kap = forste_tegn;
		if type_tmp in (01:29) then icpc2_type = 1; /*sympt./plager*/
		if type_tmp in (70:99) then icpc2_type = 2; /*diag./sykdom*/
end;
drop forste_tegn type_tmp;
format icpc2_hdiag $icpc2_fmt.;
run;

/* Sette sammen datasettene */
data &utdata;
set icpc2_data2 icpc2b_data2 rest;
format icpc2_kap $icpc2_kap. icpc2_type icpc2_type. icpc2_hdiag $icpc2_fmt.  ;
run;

proc delete data= icpc2_data icpc2_data2 icpc2b_data icpc2b_data2 rest ;
run;
%mend;