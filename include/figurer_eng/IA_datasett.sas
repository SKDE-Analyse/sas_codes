


/*	Lager Norgesett	*/

data &varnavn._IA_NO;
set &varnavn._norge;
where aar = 9999;
keep bohf Rate Antall innbyggere ; 
Rate = rv_just_rate;
Antall = ant_opphold;
Innbyggere = ant_innbyggere;
bohf = 8888;
run;


/* Lager BOHF-datasett	*/

data &varnavn._IA_BOHF;
set &varnavn._S_BOHF;
where aar = 9999;
keep bohf Rate Antall innbyggere KI_N_J KI_O_J ll ul bohf_org;
Rate = rv_just_rate;
Antall = ant_opphold;
Innbyggere = ant_innbyggere;
ll = KI_N_J;
ul = KI_O_J;
run;


/* Setter sammen datasett	*/

proc sort data=&varnavn._IA_BOHF;
by BoHf;
run;

data IA_&varnavn;
merge &varnavn._IA_BOHF &varnavn._IA_NO;
length BoHF_navn $ 20.;
by BoHf;
drop aar norge KI_N_J KI_o_J;;
BoHF_Navn=vvalue(BoHF);
bohf_org = bohf;
run;

/*Endrer variabelnavn og lager nye variable */


data IA_&varnavn;
set IA_&varnavn;
format bohf ;
If BoHf_navn = ' ' then BoHf_navn = 'Norge';
Gruppe = "&gruppe";
Niva = "&niva";
numeric = "numeric";
Tom_rad = "tom";
Tom_rute = "tom";
if antall lt 30 then do;
	rate=.;
	ll=.;
	ul=.;
end;
run;


data skde_pet.IA_&varnavn;
set IA_&varnavn;
if bohf_org in (1:4) then bohf = bohf_org;
if bohf_org = 6 then bohf = 5;
if bohf_org = 7 then bohf = 6;
if bohf_org = 8 then bohf = 7;
if bohf_org = 10 then bohf = 8;
if bohf_org = 11 then bohf = 9;
if bohf_org = 12 then bohf = 10;
if bohf_org = 13 then bohf = 11;
if bohf_org = 14 then bohf = 12;
if bohf_org = 15 then bohf = 13;
if bohf_org = 16 then bohf = 14;
if bohf_org = 19 then bohf = 15;
if bohf_org = 20 then bohf = 16;
if bohf_org = 21 then bohf = 17;
if bohf_org = 22 then bohf = 18;
if bohf_org = 23 then bohf = 19;
if bohf_org = 31 then bohf = 20;
if bohf_org = 8888 then bohf = 21;
run;


/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._IA_NO  &varnavn._IA_BOHF IA_&varnavn;
run;