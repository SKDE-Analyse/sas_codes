%macro sykehus_beh_sh(dsn=);
data &dsn;
Set &dsn;	
	if Sykehus_ID=85 then BehSH=11; /*'Klinikk Kirkenes'*/
	else if Sykehus_ID=86 then BehSH=12; /*'Klinikk Hammerfest'*/
	else if Sykehus_ID=87 then BehSH=21; /*'UNN Tromsø'*/
	else if Sykehus_ID=88 then BehSH=22; /*'UNN Harstad'*/
	else if Sykehus_ID=89 then BehSH=23; /*'UNN Narvik'*/
	else if Sykehus_ID=91 then BehSH=31; /*'NLSH Vesterålen'*/
	else if Sykehus_ID=92 then BehSH=32; /*'NLSH Lofoten'*/
	else if Sykehus_ID=90 then BehSH=33; /*'NLSH Bodø'*/
	else if Sykehus_ID=93 then BehSH=41; /*'Helgelandssykehuset Mo i Rana'*/
	else if Sykehus_ID=94 then BehSH=42; /*'Helgelandssykehuset Mosjøen'*/
	else if Sykehus_ID=95 then BehSH=43; /*'Helgelandssykehuset Sandnessjøen'*/
	else if Sykehus_ID=72 then BehSH=51; /*'Sykehuset Namsos'*/
	else if Sykehus_ID=73 then BehSH=52; /*'Sykehuset Levanger'*/
	else if Sykehus_ID=77 then BehSH=61; /*'St. Olavs hospital, Trondheim'*/
	else if Sykehus_ID=80 then BehSH=62; /*'St. Olavs hospital, Orkdal'*/
	else if Sykehus_ID=79 then BehSH=63; /*'St. Olavs hospital, Røros'*/
	else if Sykehus_ID=70 then BehSH=71; /*'Molde sjukehus'*/
	else if Sykehus_ID=71 then BehSH=72; /*'Kristiansund sykehus'*/
	else if Sykehus_ID=74 then BehSH=73; /*'Ålesund sjukehus'*/
	else if Sykehus_ID=75 then BehSH=74; /*'Volda sjukehus'*/
	else if Sykehus_ID=76 then BehSH=75; /*'Mork Rehabiliteringssenter'*/
	else if Sykehus_ID=78 then BehSH=76; /*'Nevrohjemmet rehabiliteringssenter'*/
	else if Sykehus_ID=67 then BehSH=91; /*'Førde sjukehus'*/
	else if Sykehus_ID=68 then BehSH=92; /*'Nordfjord sjukehus'*/
	else if Sykehus_ID=69 then BehSH=93; /*'Lærdal sjukehus'*/
	else if Sykehus_ID=58 then BehSH=101; /*'Haukeland universitetssykehus'*/
	else if Sykehus_ID=59 then BehSH=103; /*'Voss sjukehus'*/
	else if Sykehus_ID=60 then BehSH=102; /*'Kysthospitalet i Hagevik'*/
	else if Sykehus_ID=66 then BehSH=111; /*'Odda sjukehus'*/
	else if Sykehus_ID=65 then BehSH=112; /*'Stord sjukehus'*/
	else if Sykehus_ID=64 then BehSH=113; /*'Haugesund sjukehus'*/
	else if Sykehus_ID=55 then BehSH=121; /*'Stavanger universitetssykehus'*/
	else if Sykehus_ID=63 then BehSH=131; /*'Betanien spesialistpoliklinikk Bergen'*/
	else if Sykehus_ID=62 then BehSH=132; /*'Haugesund sanitetsforenings revm.sykehus'*/
	else if Sykehus_ID=12 then BehSH=141; /*'Drammen sykehus'*/
	else if Sykehus_ID=33 then BehSH=142; /*'Bærum sykehus'*/
	else if Sykehus_ID=13 then BehSH=143; /*'Ringerike sykehus'*/
	else if Sykehus_ID=15 then BehSH=144; /*'Kongsberg sykehus'*/
	else if Sykehus_ID=7 then BehSH=151; /*'Sykehuset Telemark, Skien'*/
	else if Sykehus_ID=5 then BehSH=152; /*'Sykehuset Telemark, Kragerø'*/
	else if Sykehus_ID=16 then BehSH=153; /*'Sykehuset Telemark Notodden'*/
	else if Sykehus_ID=17 then BehSH=154; /*'Sykehuset Telemark Rjukan'*/
	else if Sykehus_ID=6 then BehSH=155; /*'Sykehuset Telemark, Porsgrunn'*/
	else if Sykehus_ID=30 then BehSH=160; /*'Akershus universitetssykehus HF'*/
	else if Sykehus_ID=40 then BehSH=171; /*'Sykehuset Innlandet, Elverum'*/
	else if Sykehus_ID=41 then BehSH=172; /*'Sykehuset Innlandet, Gjøvik'*/
	else if Sykehus_ID=39 then BehSH=173; /*'Sykehuset Innlandet, Lillehammer'*/
	else if Sykehus_ID=44 then BehSH=174; /*'Sykehuset Innlandet, Kongsvinger'*/
	else if Sykehus_ID=43 then BehSH=175; /*'Sykehuset Innlandet, Tynset'*/
	else if Sykehus_ID=45 then BehSH=176; /*'Sykehuset Innlandet, Granheim'*/
	else if Sykehus_ID=158 then BehSH=177; /*'Sykehuset Innlandet, Ottestad'*/
	else if Sykehus_ID=42 then BehSH=178; /*'Sykehuset Innlandet, Hamar'*/
	else if Sykehus_ID=19 then BehSH=181; /*'OUS, Rikshospitalet'*/
	else if Sykehus_ID=28 then BehSH=182;/*'OUS, Aker'*/
	else if Sykehus_ID=47 then BehSH=184; /*'OUS, Ullevål'*/
	else if Sykehus_ID=23 then BehSH=185; /*'OUS, Spesialsykehuset for epilepsi'*/
	else if Sykehus_ID=26 then BehSH=186; /*'OUS, Radiumhospitalet'*/
	else if Sykehus_ID=24 then BehSH=187; /*'OUS, Geilomo barnesykehus'*/
	else if Sykehus_ID=46 then BehSH=190; /*'Sunnaas sykehus'*/
	else if Sykehus_ID=34 then BehSH=201; /*'Sykehuset Østfold, Moss'*/
	else if Sykehus_ID=4 then BehSH=211; /*'Sørlandet sykehus, Kristiansand'*/
	else if Sykehus_ID=1 then BehSH=212; /*'Sørlandet sykehus, Arendal'*/
	else if Sykehus_ID=2 then BehSH=213; /*'Sørlandet sykehus, Flekkefjord (Lister)'*/
	else if Sykehus_ID=22 then BehSH=214; /*'Sørlandet sykehus, Spesialsykehuset for rehabilitering, Kristiansand'*/
	else if Sykehus_ID=159 then BehSH=214; /*'Sørlandet sykehus, Spesialsykehuset for rehabilitering, Kristiansand'*/
	else if Sykehus_ID=11 then BehSH=221; /*'Sykehuset i Vestfold, Tønsberg'*/
	else if Sykehus_ID=8 then BehSH=9999; /*'Sykehuset Vestfold, Larvik'*/
		

/*Frittstående ideelle private helseinstitusjoner*/
	
    else if Sykehus_ID=27 then BehSH=252; /*'Betanien Hospital Skien'*/
	else if Sykehus_ID=48 then BehSH=240; /*'Lovisenberg diakonale sykehus'*/
	else if Sykehus_ID=49 then BehSH=230; /*'Diakonhjemmet sykehus'*/
	else if Sykehus_ID=50 then BehSH=253; /*'Revmatismesykehuset Lillehammer'*/
	else if Sykehus_ID=51 then BehSH=251; /*'Martina Hansens Hospital'*/
   	else if Sykehus_ID=61 then BehSH=260; /*'Haraldsplass diakonale sykehus'*/
	


	 /*Storbylegevakter*/
    else if Sykehus_ID=160 then BehSH=104; /*'Bergen legevakt'*/
	else if Sykehus_ID=161 then BehSH=254; /*'Oslo kommunale legevakt, Observasjonsposten'*/

	/*Private sykehus*/
	else if Sykehus_ID=121 then BehSH=10000;/*'Drammen private sykehus, Drammen'*/
    else if Sykehus_ID=122 then BehSH=10001;/*'Rosenborg sportsklinikk/ Teres Rosenborg'*/
    else if Sykehus_ID=123 then BehSH=10002;/*'Bergen kirurgiske sykehus, Bergen'*/
    else if Sykehus_ID=124 then BehSH=10003;/*'Teres Sørlandsparken'*/
    else if Sykehus_ID=125 then BehSH=10004;/*'Teres Colosseum, Oslo'*/
    else if Sykehus_ID=126 then BehSH=10005;/*'Klinikk Stokkan, Trondheim'*/
    else if Sykehus_ID=127 then BehSH=10006;/*'Tromsø private sykehus/Teres Tromsø'*/
	else if Sykehus_ID=128 then BehSH=10007;/*'Teres Colosseum, Stavanger'*/
    else if Sykehus_ID=129 then BehSH=10008;/*'Teresklinikken, Bodø'*/
    else if Sykehus_ID=130 then BehSH=10020;/*'Aleris Helse, Oslo'*/
    else if Sykehus_ID=131 then BehSH=10021;/*'Aleris Helse Bergen'*/
    else if Sykehus_ID=132 then BehSH=10022;/*'Aleris Helse, Trondheim'*/
    else if Sykehus_ID=133 then BehSH=10023;/*'Aleris Helse, Tromsø'*/
    else if Sykehus_ID=134 then BehSH=10024;/*'Aleris Helse, Stavanger'*/
    else if Sykehus_ID=135 then BehSH=10030;/*'Medi 3 Ålesund'*/
    else if Sykehus_ID=136 then BehSH=10040;/*'Volvat medisinske senter, Oslo'*/
    else if Sykehus_ID=137 then BehSH=10041;/*'Volvat medisinske senter, Hamar'*/
    else if Sykehus_ID=138 then BehSH=10042;/*'Volvat medisinske senter, Fredrikstad'*/
    else if Sykehus_ID=139 then BehSH=10043;/*'Volvat medisinske senter, Vestskogen'*/
    else if Sykehus_ID=140 then BehSH=10044;/*'Volvat medisinske senter, Bergen'*/
    else if Sykehus_ID=141 then BehSH=10050;/*'Privatsykehuset Haugesund'*/
    else if Sykehus_ID=142 then BehSH=10060;/*'Ringvollklinikken, Askim'*/
    else if Sykehus_ID=143 then BehSH=10070;/*'Fana medisinske senter'*/
    else if Sykehus_ID=144 then BehSH=10080;/*'Scandinavian Venous Centre'*/
    else if Sykehus_ID=145 then BehSH=10090;/*'FysMed-klinikken', Trondheim'*/
    else if Sykehus_ID=146 then BehSH=10100;/*'Friskvernklinikken, Asker'*/
    else if Sykehus_ID=147 then BehSH=10110;/*'Feiringklinikken, Feiring'*/
	else if Sykehus_ID=148 then BehSH=10120;/*'Glittreklinikken, Hakadal'*/
    else if Sykehus_ID=149 then BehSH=10130;/*'Norsk diabetikersenter'*/
    else if Sykehus_ID=150 then BehSH=10140;/*'Bergen Spine Senter, Bergen'*/
    else if Sykehus_ID=151 then BehSH=10150;/*'Hjelp24 NIMI'*/
    else if Sykehus_ID=152 then BehSH=10160;/*'Mjøs-kirurgene, Gjøvik'*/
    else if Sykehus_ID=153 then BehSH=10170;/*'IbsenSykehuset'*/
    else if Sykehus_ID=154 then BehSH=10180;/*'Akademiklinikken Oslo AS'*/
    else if Sykehus_ID=155 then BehSH=10190;/*'NIMI AS Avd. Mini Ullevål'*/
    else if Sykehus_ID=156 then BehSH=10200;/*'Kolibri Medical AS'*/
    else if Sykehus_ID=157 then BehSH=10210;/*'Moxnessklinikken'*/
    
	/*Sykestuer Helse Nord*/
	else if Sykehus_ID=101 then BehSH=20101;/*'UNN,Kåfjord sykehjem'*/
	else if Sykehus_ID=102 then BehSH=20102;/*'UNN, Skjervøy sykehjem'*/
	else if Sykehus_ID=104 then BehSH=20104;/*'UNN,Kvænangen sykehjem'*/
	else if Sykehus_ID=105 then BehSH=20105;/*'FIN,Vardo Alders og sykehjem'*/	
    else if Sykehus_ID=106 then BehSH=20106;/*'FIN,Vadso Helsesenter'*/
    else if Sykehus_ID=107 then BehSH=20107;/*'FIN,Kautokeino Alders og sykehjem'*/
	else if Sykehus_ID=109 then BehSH=20109;/*'FIN,Oksfjord helsesenter_sykehjem'*/	
    else if Sykehus_ID=110 then BehSH=20110;/*'FIN,Hasvik Helsesenter'*/	
    else if Sykehus_ID=111 then BehSH=20111;/*'FIN,Havøysund Helsesenter'*/
    else if Sykehus_ID=112 then BehSH=20112;/*'FIN,Nordkapp Helsesenter'*/
    else if Sykehus_ID=113 then BehSH=20113;/*'FIN,Porsangr Helsetun'*/	
    else if Sykehus_ID=114 then BehSH=20114;/*'FIN,Karasjok Helsesenter'*/
    else if Sykehus_ID=115 then BehSH=20115;/*'FIN,Kjøllefjord Helsesenter'*/	
    else if Sykehus_ID=116 then BehSH=20116;/*'FIN,Mehamn helsesenter'*/	
    else if Sykehus_ID=117 then BehSH=20117;/*'FIN,Berlevag sykestue'*/	
    else if Sykehus_ID=118 then BehSH=20118;/*'FIN,Tana Helsesenter'*/
    else if Sykehus_ID=119 then BehSH=20119;/*'FIN,Nesseby Helsesenter'*/
	else if Sykehus_ID=120 then BehSH=20120;/*'FIN,Batsfjord Helsesenter'*/

	/*DMS Helse Nord */
	else if Sykehus_ID=99 then BehSH=30099;/*'UNN, Midt-Troms Fødestue'*/
	else if Sykehus_ID=100 then BehSH=30100;/*'UNN, Distriktsmedisinsk senter Midt-Troms'*/
	else if Sykehus_ID=103 then BehSH=30103;/*'UNN, Nord-Troms DMS'*/
	else if Sykehus_ID=96 then BehSH=30104;/*'HSYK, Spesialistpoliklinikken Brønnoysund'*/
	else if Sykehus_ID=97 then BehSH=30105;/*'HSYK, Bronnoy Fodestue'*/
	else if Sykehus_ID=108 then BehSH=30106;/*'FIN, Alta helsesenter'*/
	else if Sykehus_ID=98 then BehSH=30107;/*'NLSH, Steigen fodestue'*/

	
	/*Sykestuer  Rehabiliteringsinst, DMS , legevakt utenom Helse Nord,*/
    else if Sykehus_ID=14 then BehSH=30014;/*'Vestre Viken, Hallingdal sjukestugo'*/	
	else if Sykehus_ID=21 then BehSH=222;/*'Sh i Vestfold, Spes.sh for rehab. Stavern'*/
	/*else if Sykehus_ID=22 then BehSH=30022;/*'Sørlandet sh, Spesialsykehuset for rehabilitering, Kristiansand'*/
	else if Sykehus_ID=54 then BehSH=30054;/*'Innlandet, Nord-Gudbrandsdal LMS'*/
	/*else if Sykehus_ID=76 then BehSH=30076;/*'Helse Møre og Romsdal, Mork rehab.senter'*/
    /*else if Sykehus_ID=78 then BehSH=30078;/*'Helse Møre og Romsdal, Nevrohjemmet rehab.senter'*/
    else if Sykehus_ID=82 then BehSH=30082;/*'St.Olavs, Fosen Helse'*/
	else if Sykehus_ID=83 then BehSH=30083;/*'St.Olavs, Værnesregionen DMS'*/
	else if Sykehus_ID=84 then BehSH=30084;/*'St.Olavs, Munkvoll rehabilitering'*/
    /*else if Sykehus_ID=46 then BehSH=30190;/*'Sunnaas sh'*/
	
Else BehSH=9999;
/*If BehSH ='9999' then delete;*/
format behSH behSH. sykehus_id sykehus_id.;
run;

/*Sykehus_ID fra SSB*/
%macro sykehus_id(dsn=);
data &dsn;
set &dsn;
if Sykehus_ID=1 then BehSH=212; /*Sørlandet sykehus, Arendal*/
else if Sykehus_ID=2 then BehSH=213; /*Sørlandet sykehus, Flekkefjord (Lister)*/
else if Sykehus_ID=4 then BehSH=211; /*Sørlandet sykehus, Kristiansand*/
else if Sykehus_ID=5 then BehSH=152; /*Sykehuset Telemark, Kragerø*/
/*	else if Sykehus_ID=6 then BehSH=155; *//*Sykehuset Telemark, Porsgrunn*/
else if Sykehus_ID=7 then BehSH=151; /*Sykehuset Telemark, Skien*/
else if Sykehus_ID=8 then BehSH=9999; /*Sykehuset Vestfold, Larvik*/
else if Sykehus_ID=11 then BehSH=221; /*Sykehuset i Vestfold, Tønsberg*/
else if Sykehus_ID=12 then BehSH=141; /*Drammen sykehus*/
else if Sykehus_ID=13 then BehSH=143; /*Ringerike sykehus*/
else if Sykehus_ID=15 then BehSH=144; /*Kongsberg sykehus*/
else if Sykehus_ID=16 then BehSH=153; /*Sykehuset Telemark Notodden*/
else if Sykehus_ID=17 then BehSH=154; /*Sykehuset Telemark Rjukan*/
else if Sykehus_ID=19 then BehSH=181; /*OUS, Rikshospitalet*/
else if Sykehus_ID=22 then BehSH=214; /*Sørlandet sykehus, Spesialsykehuset for rehabilitering, Kristiansand*/
else if Sykehus_ID=23 then BehSH=185; /*OUS, Spesialsykehuset for epilepsi*/
else if Sykehus_ID=24 then BehSH=187; /*OUS, Geilomo barnesykehus*/
else if Sykehus_ID=26 then BehSH=186; /*OUS, Radiumhospitalet*/
else if Sykehus_ID=27 then BehSH=252; /*Betanien Hospital Skien*/
else if Sykehus_ID=28 then BehSH=182;/*OUS, Aker*/
else if Sykehus_ID=30 then BehSH=160; /*Akershus universitetssykehus HF*/
else if Sykehus_ID=33 then BehSH=142; /*Bærum sykehus*/
else if Sykehus_ID=34 then BehSH=201; /*Sykehuset Østfold, Moss*/
else if Sykehus_ID=36 then BehSH=202/*200*/; /*200 er Sykehuset Østfold, Fredrikstad - nå flyttet til Kalnes, bruker avstand til Fredrikstad foreløpig, men omkodes til 202*/
else if Sykehus_ID=39 then BehSH=173; /*Sykehuset Innlandet, Lillehammer*/
else if Sykehus_ID=40 then BehSH=171; /*Sykehuset Innlandet, Elverum*/
else if Sykehus_ID=41 then BehSH=172; /*Sykehuset Innlandet, Gjøvik*/
else if Sykehus_ID=42 then BehSH=178; /*Sykehuset Innlandet, Hamar*/
else if Sykehus_ID=43 then BehSH=175; /*Sykehuset Innlandet, Tynset*/
else if Sykehus_ID=44 then BehSH=174; /*Sykehuset Innlandet, Kongsvinger*/
else if Sykehus_ID=45 then BehSH=176; /*Sykehuset Innlandet, Granheim*/
else if Sykehus_ID=46 then BehSH=190; /*Sunnaas sykehus*/
else if Sykehus_ID=47 then BehSH=184; /*OUS, Ullevål*/
else if Sykehus_ID=48 then BehSH=240; /*Lovisenberg diakonale sykehus*/
else if Sykehus_ID=49 then BehSH=230; /*Diakonhjemmet sykehus*/
else if Sykehus_ID=50 then BehSH=253; /*Revmatismesykehuset Lillehammer*/
else if Sykehus_ID=51 then BehSH=251; /*Martina Hansens Hospital*/
else if Sykehus_ID=55 then BehSH=121; /*Stavanger universitetssykehus*/
else if Sykehus_ID=58 then BehSH=101; /*Haukeland universitetssykehus*/
else if Sykehus_ID=59 then BehSH=103; /*Voss sjukehus*/
else if Sykehus_ID=60 then BehSH=102; /*Kysthospitalet i Hagevik*/
else if Sykehus_ID=61 then BehSH=260; /*Haraldsplass diakonale sykehus*/
else if Sykehus_ID=62 then BehSH=132; /*Haugesund sanitetsforenings revm.sykehus*/
else if Sykehus_ID=63 then BehSH=131; /*Betanien spesialistpoliklinikk Bergen*/
else if Sykehus_ID=64 then BehSH=113; /*Haugesund sjukehus*/
else if Sykehus_ID=65 then BehSH=112; /*Stord sjukehus*/
else if Sykehus_ID=66 then BehSH=111; /*Odda sjukehus*/
else if Sykehus_ID=67 then BehSH=91; /*Førde sjukehus*/
else if Sykehus_ID=68 then BehSH=92; /*Nordfjord sjukehus*/
else if Sykehus_ID=69 then BehSH=93; /*Lærdal sjukehus*/
else if Sykehus_ID=70 then BehSH=71; /*Molde sjukehus*/
else if Sykehus_ID=71 then BehSH=72; /*Kristiansund sykehus*/
else if Sykehus_ID=72 then BehSH=51; /*Sykehuset Namsos*/
else if Sykehus_ID=73 then BehSH=52; /*Sykehuset Levanger*/
else if Sykehus_ID=74 then BehSH=73; /*Ålesund sjukehus*/
else if Sykehus_ID=75 then BehSH=74; /*Volda sjukehus*/
else if Sykehus_ID=76 then BehSH=75; /*Mork Rehabiliteringssenter*/
else if Sykehus_ID=77 then BehSH=61; /*St. Olavs hospital, Trondheim*/
else if Sykehus_ID=78 then BehSH=76; /*Nevrohjemmet rehabiliteringssenter*/
else if Sykehus_ID=79 then BehSH=63; /*St. Olavs hospital, Røros*/
else if Sykehus_ID=80 then BehSH=62; /*St. Olavs hospital, Orkdal*/
else if Sykehus_ID=85 then BehSH=11; /*Klinikk Kirkenes*/
else if Sykehus_ID=86 then BehSH=12; /*Klinikk Hammerfest*/
else if Sykehus_ID=87 then BehSH=21; /*UNN Tromsø*/
else if Sykehus_ID=88 then BehSH=22; /*UNN Harstad*/
else if Sykehus_ID=89 then BehSH=23; /*UNN Narvik*/
else if Sykehus_ID=90 then BehSH=33; /*NLSH Bodø*/
else if Sykehus_ID=91 then BehSH=31; /*NLSH Vesterålen*/
else if Sykehus_ID=92 then BehSH=32; /*NLSH Lofoten*/
else if Sykehus_ID=93 then BehSH=41; /*Helgelandssykehuset Mo i Rana*/
else if Sykehus_ID=94 then BehSH=42; /*Helgelandssykehuset Mosjøen*/
else if Sykehus_ID=95 then BehSH=43; /*Helgelandssykehuset Sandnessjøen*/
else if Sykehus_ID=158 then BehSH=177; /*Sykehuset Innlandet, Ottestad*/
else if Sykehus_ID=159 then BehSH=214; /*Sørlandet sykehus, Spesialsykehuset for rehabilitering, Kristiansand*/
run;