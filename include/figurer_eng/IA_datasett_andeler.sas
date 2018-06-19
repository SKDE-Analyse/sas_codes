


data &varnavn._andeler_IA;
set &varnavn._andeler;
bohf_org = bohf;
run;

data &varnavn._andeler_IA;
set &varnavn._andeler_IA;
where en_ant ne .;
length BoHF_navn $ 20.;
keep andel en_ant tot_ant bohf bohf_navn bohf_org;
BoHF_Navn=vvalue(BoHF);
run;

data &varnavn._andeler_IA;
set &varnavn._andeler_IA;
If BoHf_navn = ' ' then BoHf_navn = 'Norge';
Gruppe = "&gruppe";
Niva = "&niva";
numeric = "numeric";
Tom_rad = "tom";
Tom_rute = "tom";
antall = en_ant;
rate = andel*100;
innbyggere = tot_ant;
format bohf ;
run;

data skde_pet.IA_&varnavn._andeler;
set &varnavn._andeler_IA;
drop ant_to;
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
delete &varnavn._andeler_IA ;
run;