/* 
- Lage egen variabel som heter icpc2_hdiag, icpc2_kap, icpc2_type
    - gjelder for de med kodeverk 1 og 2 (icpc2 og icpc2 beriket)
    - flertallet bruker icpc2, slik at icpc2 beriket gis ogs� en vanlig icpc2-kode
 */

%macro kpr_icpc2(inndata=, utdata=);

data icpc2_data icpc2b_data rest;
  set &inndata;
  drop icpc2: ; /*slette gamle icpc2_*variabler hvis makro kj�res to ganger p� samme datasett*/
  if 		kodeverk_kpr eq 1 then output icpc2_data;
  else if 	kodeverk_kpr eq 2 then output icpc2b_data;
  else output rest;
  run;

/*-----------------*/
/* ICPC2-diagnoser */
/*-----------------*/

data icpc2_data2;
length icpc2_hdiag $20;
set icpc2_data;

/*hent ut f�rste tegn*/
forste_tegn_tmp = substr(hdiag_kpr,1,1);
/*hent ut tegn to og tre*/
type_tmp = substr(hdiag_kpr,2,2);

/*gyldige organkapittel (og bindestrek) for ICPC2-diagnoser*/
if forste_tegn_tmp in ("-","A","B","D","F","H","K","L","N","P","R","S","T","U","W","X","Y","Z") then do;

	if forste_tegn_tmp ne "-" then do; /*for alle unntatt bindestrek*/
		icpc2_hdiag = hdiag_kpr; 
		icpc2_kap = forste_tegn_tmp;
		if type_tmp in (01:29) then icpc2_type = 1; /*sympt./plager*/
		if type_tmp in (30:69) then icpc2_type = 3; /*prosesskode*/
		if type_tmp in (70:99) then icpc2_type = 2; /*diag./sykdom*/
	end;

	if forste_tegn_tmp eq "-" and type_tmp in (30:69) then do; /*bindestrek - mangler organkapittel*/
		icpc2_hdiag = type_tmp;
		icpc2_type = 3;
	end;

end;
drop forste_tegn_tmp type_tmp;
run;

/*-------------------------*/
/* ICPC2-beriket diagnoser */
/*-------------------------*/
data icpc2b_data2;
length icpc2_hdiag $20;
set icpc2b_data;

/*hent ut f�rste tegn*/
forste_tegn_tmp = substr(hdiag_kpr,1,1);
/*fjerne fire siste tegn som utgj�r beriket*/
type_tmp = substr(hdiag_kpr,2, length(hdiag_kpr)-5);

/*-------------------------------------------------*/
/*gyldige organkapittel for ICPC2-beriket diagnoser*/
/*-------------------------------------------------*/
if forste_tegn_tmp in ("A","B","D","F","H","K","L","N","P","R","S","T","U","W","X","Y","Z") then do;
		icpc2_hdiag = compress(cat(forste_tegn_tmp,type_tmp)); 
		icpc2_kap = forste_tegn_tmp;
		if type_tmp in (01:29) then icpc2_type = 1; /*sympt./plager*/
		if type_tmp in (30:69) then icpc2_type = 3; /*prosesskode*/
		if type_tmp in (70:99) then icpc2_type = 2; /*diag./sykdom*/
end;
drop forste_tegn_tmp type_tmp;
run;

/* Sette sammen datasettene */
data &utdata;
set icpc2_data2 icpc2b_data2 rest;
run;
/* slette datasett */
proc datasets nolist;
delete icpc2_data icpc2_data2 icpc2b_data icpc2b_data2 rest;
run;
%mend kpr_icpc2;