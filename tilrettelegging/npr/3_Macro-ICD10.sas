%Macro ICD (innDataSett=, utDataSett=);

/*!**********************************************************************************************
************************************************************************************************
MACRO FOR ICD-KAPITTEL, KATEGORIBLOKK OG HOVEDDIAGNOSE P� TRE TEGN

Innhold i syntaxen:
3.1		ICD10KAP
3.2 	ICD10KATBLOKK
3.3		HDIAG3TEGN
************************************************************************************************
***********************************************************************************************/





Data &Utdatasett;
Set &Inndatasett;

/*
************************************************************************************************
3.1	ICD10KAP
************************************************************************************************
/*Definerer hoveddiagnosekap for ICD10 (1 tegn) ut fra oppgitt hoveddiagnose (4 tegn).*/;

/* Disse kodene er ikke oppdatert siden 2014 - vi m� finne/be e-helsedir og lister for hvert �r */

if substr(Hdiag,1,1) ='A' then ICD10Kap=1; /*Visse infeksjonssykd og parasittsykd*/
else if substr(Hdiag,1,1)='B' then ICD10Kap=1; /*Visse infeksjonssykd og parasittsykd*/
else if substr(Hdiag,1,1)='C' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,1)='E' then ICD10Kap=4; /*Endokrine sykd,ern�ringssykd*/
else if substr(Hdiag,1,1)='F' then ICD10Kap=5;/*Psyk lidelser og atferdsforstyrrelser*/
else if substr(Hdiag,1,1)='G' then ICD10Kap=6;/*Sykd i nervesystemet*/
else if substr(Hdiag,1,1)='I' then ICD10Kap=9;/*Sykd i sirkulasjonssystemet*/
else if substr(Hdiag,1,1)='J' then ICD10Kap=10;/*Sykd i �ndedrettssystemet*/
else if substr(Hdiag,1,1)='K' then ICD10Kap=11;/*Sykd i ford�yelsessystemet*/
else if substr(Hdiag,1,1)='L' then ICD10Kap=12;/*Sykd i hud og underhud*/
else if substr(Hdiag,1,1)='M' then ICD10Kap=13;/*Sykd i muskel- skjellettsyst og bindevev*/
else if substr(Hdiag,1,1)='N' then ICD10Kap=14;/*Sykd i urin- og kj�nnsorganer*/
else if substr(Hdiag,1,1)='O' then ICD10Kap=15;/*Svangerskap,f�dsel og barseltid*/
else if substr(Hdiag,1,1)='P' then ICD10Kap=16;/*Visse tilstander i perinatalperioden*/
else if substr(Hdiag,1,1)='Q' then ICD10Kap=17;/*Misdann.,deformiteter og kromosomavvik*/
else if substr(Hdiag,1,1)='R' then ICD10Kap=18;/*Symptom,tegn,lab.funn,annet*/
else if substr(Hdiag,1,1)='S' then ICD10Kap=19;/*Skader,forgiftninger*/
else if substr(Hdiag,1,1)='T' then ICD10Kap=19;/*Skader,forgiftninger*/
else if substr(Hdiag,1,1)='V' then ICD10Kap=20;/*Ytre �rsaker til sykd,skader og d�d,V0n-Y98*/
else if substr(Hdiag,1,1)='W' then ICD10Kap=20;/*Ytre �rsaker til sykd,skader og d�d,V0n-Y98*/
else if substr(Hdiag,1,1)='X' then ICD10Kap=20;/*Ytre �rsaker til sykd,skader og d�d,V0n-Y98*/
else if substr(Hdiag,1,1)='Y' then ICD10Kap=20;/*Ytre �rsaker til sykd,skader og d�d,V0n-Y98*/
else if substr(Hdiag,1,1)='Z' then ICD10Kap=21;/*Faktorer som p�virker helsetilstand*/
else if substr(Hdiag,1,1)='U' then ICD10Kap=22;/*Koder for spesielle form�l*/

else if substr(Hdiag,1,2)='D0' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,2)='D1' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,2)='D2' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,2)='D3' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,2)='D4' then ICD10Kap=2; /*Svulster*/
else if substr(Hdiag,1,2)='D5' then ICD10Kap=3;/*Sykd i blod og bloddannende organer,D50-D89*/
else if substr(Hdiag,1,2)='D6' then ICD10Kap=3;/*Sykd i blod og bloddannende organer,D50-D89*/
else if substr(Hdiag,1,2)='D6' then ICD10Kap=3;/*Sykd i blod og bloddannende organer,D50-D89*/
else if substr(Hdiag,1,2)='D7' then ICD10Kap=3;/*Sykd i blod og bloddannende organer,D50-D89*/
else if substr(Hdiag,1,2)='D8' then ICD10Kap=3;/*Sykd i blod og bloddannende organer,D50-D89*/
else if substr(Hdiag,1,2)='H0' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H1' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H2' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H3' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H4' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H5' then ICD10Kap=7; /*Sykd i �yet og �yets omgivelser,H00-H59*/
else if substr(Hdiag,1,2)='H6' then ICD10Kap=8; /*Sykd i �re og �rebensknute,H60-H95*/
else if substr(Hdiag,1,2)='H7' then ICD10Kap=8; /*Sykd i �re og �rebensknute,H60-H95*/
else if substr(Hdiag,1,2)='H8' then ICD10Kap=8; /*Sykd i �re og �rebensknute,H60-H95*/
else if substr(Hdiag,1,2)='H9' then ICD10Kap=8; /*Sykd i �re og �rebensknute,H60-H95*/
else ICD10Kap=23; /*Ukjent eller manglende diagnose*/

/*
************************************************************************************************
3.2 	ICD10KATBLOKK
************************************************************************************************
/*Definerer ICD10 kategoriblokker*/
if substr(Hdiag,1,2) ='A0' then ICD10KatBlokk=1 /* A00-A09 Infeksi�se tarmsykdommer */;
else if substr(Hdiag,1,2)='A1' then ICD10KatBlokk=2 /* A15-A19 Tuberkulose */;
else if substr(Hdiag,1,2)='A2' then ICD10KatBlokk=3 /* A20-A28 Visse bakterielle zoonoser */;
else if substr(Hdiag,1,2) in ('A3','A4') then ICD10KatBlokk=4 /* A30-A49 Andre bakteriesykdommer */;
else if substr(Hdiag,1,2)='A5' or substr(Hdiag,1,3) in ('A60','A61','A62','A63','A64') then ICD10KatBlokk=5 /* A50-A64 Hovedsakelig seksuelt overf�rbare infeksjoner */;
else if substr(Hdiag,1,3) in ('A65','A66','A67','A68','A69') then ICD10KatBlokk=6 /* A65-A69 Andre spiroketsykdommer */;
else if substr(Hdiag,1,3) in ('A70','A71','A72','A73','A74') then ICD10KatBlokk=7 /* A70-A74 Andre sykdommer for�rsaket av klamydia */;
else if substr(Hdiag,1,3) in ('A75','A76','A77','A78','A79') then ICD10KatBlokk=8 /* A75-A79 Rickettsioser */;
else if substr(Hdiag,1,2)='A8' then ICD10KatBlokk=9 /* A80-A89 Virusinfeksjoner i sentralnervesystemet */;
else if substr(Hdiag,1,2)='A9' then ICD10KatBlokk=10 /* A90-A99 Virussykdommer overf�rt ved artropoder og viral hemoragisk feber */;
else if substr(Hdiag,1,2)='B0' then ICD10KatBlokk=11 /* B00-B09 Virusinfeksjoner kjennetegnet ved hud- og slimhinnelesjoner */;
else if substr(Hdiag,1,2)='B1' then ICD10KatBlokk=12 /* B15-B19 Virushepatitt */;
else if substr(Hdiag,1,3) in ('B20','B21','B22','B23','B24') then ICD10KatBlokk=13 /* B20-B24 Humant immunsviktvirus-sykdom */;
else if substr(Hdiag,1,3) in ('B25','B26','B27','B28','B29','B30','B31','B32','B33','B34') then ICD10KatBlokk=14 /* B25-B34 Andre virussykdommer */;
else if substr(Hdiag,1,3) in ('B35','B36','B37','B38','B39') then ICD10KatBlokk=15 /* B35-B49 Soppsykdommer */;
else if substr(Hdiag,1,2)='B4' then ICD10KatBlokk=15 /* B35-B49 Soppsykdommer */;
else if substr(Hdiag,1,3) in ('B50','B51','B52','B53','B54','B55','B56','B57','B58','B59','B60','B61','B62','B63','B64') then ICD10KatBlokk=16 /* B50-B64 Protozosykdommer */;
else if substr(Hdiag,1,3) in ('B65','B66','B67','B68','B69','B70','B71','B72','B73','B74','B75','B76','B77','B78','B79','B80','B81','B82','B83') then ICD10KatBlokk=17 /* B65-B83 Helmintoser */;
else if substr(Hdiag,1,3) in ('B85','B86','B87','B88','B89') then ICD10KatBlokk=18 /* B85-B89 Infestasjon av lus,midd og andre ektoparasitter */;
else if substr(Hdiag,1,3) in ('B90','B91','B92','B93','B94') then ICD10KatBlokk=19 /* B90-B94 F�lgetilstander etter infeksjonssykdommer og parasittsykdommer */;
else if substr(Hdiag,1,3) in ('B95','B96','B97','B98') then ICD10KatBlokk=20 /* B95-B98 Bakterier,virus og andre infeksjonsfremkallende mikroorganismer */;
else if substr(Hdiag,1,3) ='B99' then ICD10KatBlokk=21 /* B99 Andre infeksjonssykdommer */;
*else if substr(Hdiag,1,2) in ('C0','C1','C2','C3','C4','C5','C6','C7','C8','C9') then ICD10KatBlokk=22 /* C00-C97 Ondartede svulster */;
else if substr(Hdiag,1,2) ='C0' then ICD10KatBlokk=22 /*C00-C14	Ondartede svulster p� leppe,i munnhule og i svelg*/;
else if substr(Hdiag,1,3) in ('C10','C11','C12','C13','C14') then ICD10KatBlokk=22 /*C00-C14	Ondartede svulster p� leppe,i munnhule og i svelg*/;
else if substr(Hdiag,1,2) in ('C1','C2') then ICD10KatBlokk=23 /*C15-C26	Ondartede svulster i ford�yelsesorganer*/;
else if substr(Hdiag,1,2) ='C3' then ICD10KatBlokk=24 /*C30-C39	Ondartede svulster i �ndedrettsorganer og intratorakale organer*/;
else if substr(Hdiag,1,3) in ('C40','C41') then ICD10KatBlokk=25 /*C40-C41	Ondartede svulster i knokler og leddbrusk*/;
else if substr(Hdiag,1,3) in ('C43','C44') then ICD10KatBlokk=26 /*C43-C44	Malignt melanom og andre ondartede svulster i hud*/;
else if substr(Hdiag,1,3) in ('C45','C46','C47','C48','C49') then ICD10KatBlokk=27 /*C45-C49	Ondartede svulster i mesotel og bl�tvev*/;
else if substr(Hdiag,1,3) ='C50' then ICD10KatBlokk=28 /*C50	Ondartet svulst i bryst*/;
else if substr(Hdiag,1,3) in ('C51','C52','C53','C54','C55','C56','C57','C58') then ICD10KatBlokk=29 /*C51-C58	Ondartede svulster i kvinnelige kj�nnsorganer*/;
else if substr(Hdiag,1,3) in ('C60','C61','C62','C63') then ICD10KatBlokk=30 /*C60-C63	Ondartede svulster i mannlige kj�nnsorganer*/;
else if substr(Hdiag,1,3) in ('C64','C65','C66','C67','C68') then ICD10KatBlokk=31 /*C64-C68	Ondartede svulster i urinveier*/;
else if substr(Hdiag,1,3) in ('C69','C70','C71','C72') then ICD10KatBlokk=32 /*C69-C72	Ondartede svulster i �ye,hjerne og andre deler av sentralnervesystemet*/;
else if substr(Hdiag,1,3) in ('C73','C74','C75') then ICD10KatBlokk=33 /*C73-C75	Ondartede svulster i skjoldbruskkjertel og andre endokrine kjertler*/;
else if substr(Hdiag,1,3) in ('C76','C77','C78','C79','C80') then ICD10KatBlokk=34 /*C76-C80	Ondartede svulster med ufullstendig angitte eller uspesifiserte utgangspunkter og metastaser*/;
else if substr(Hdiag,1,3) in ('C81','C82','C83','C84','C85','C86','C87','C88','C89','C90','C91','C92','C93','C94','C95','C96') then ICD10KatBlokk=35 /*C81-C96	Ondartede svulster i lymfoid,hematopoetisk eller beslektet vev*/;
else if substr(Hdiag,1,3) ='C97' then ICD10KatBlokk=36 /*Multiple prim�re ondartede svulster med forskjellige utgangspunkter*/;
else if substr(Hdiag,1,2)='D0' then ICD10KatBlokk=37 /* D00-D09 In situ (preinvasive) svulster */;
else if substr(Hdiag,1,2) in ('D1','D2') then ICD10KatBlokk=38 /* D10-D36 Godartede svulster */;
else if substr(Hdiag,1,3) in ('D30','D31','D32','D33','D34','D35','D36') then ICD10KatBlokk=38 /* D10-D36 Godartede svulster */;
else if substr(Hdiag,1,3) in ('D37','D38','D39') then ICD10KatBlokk=39 /* D37-D48 Svulster med usikkert eller ukjent malignitetspotensial [se merknad foran D37] */;
else if substr(Hdiag,1,2)='D4' then ICD10KatBlokk=39 /* D37-D48 Svulster med usikkert eller ukjent malignitetspotensial [se merknad foran D37] */;
else if substr(Hdiag,1,3) in ('D50','D51','D52','D53') then ICD10KatBlokk=40 /* D50-D53 Mangelanemier */;
else if substr(Hdiag,1,3) in ('D55','D56','D57','D58','D59') then ICD10KatBlokk=41 /* D55-D59 Hemolytiske anemier */;
else if substr(Hdiag,1,3) in ('D60','D61','D62','D63','D64') then ICD10KatBlokk=42 /* D60-D64 Aplastiske og andre anemier */;
else if substr(Hdiag,1,3) in ('D65','D66','D67','D68','D69') then ICD10KatBlokk=43 /* D65-D69 Koagulasjonsdefekter,purpura og andre bl�dningstilstander */;
else if substr(Hdiag,1,2)='D7' then ICD10KatBlokk=44 /* D70-D77 Andre tilstander i blod og bloddannende organer */;
else if substr(Hdiag,1,2)='D8' then ICD10KatBlokk=45 /* D80-D89 Visse tilstander som ang�r immunsystemet */;
else if substr(Hdiag,1,2)='E0' then ICD10KatBlokk=46 /* E00-E07 Forstyrrelser i skjoldbruskkjertelfunksjon */;
else if substr(Hdiag,1,3) in ('E10','E11','E12','E13','E14') then ICD10KatBlokk=47 /* E10-E14 Diabetes mellitus */;
else if substr(Hdiag,1,3) in ('E15','E16') then ICD10KatBlokk=48 /* E15-E16 Andre forstyrrelser i glukoseregulering og bukspyttkjertelens hormonsekresjon */;
else if substr(Hdiag,1,2) in ('E2','E3') then ICD10KatBlokk=49 /* E20-E35 Forstyrrelser i andre endokrine kjertler */;
else if substr(Hdiag,1,2)='E4' then ICD10KatBlokk=50 /* E40-E46 Underern�ring og feilern�ring */;
else if substr(Hdiag,1,2)='E5' then ICD10KatBlokk=51 /* E50-E64 Andre mangelsykdommer */;
else if substr(Hdiag,1,3) in ('E60','E61','E62','E63','E64') then ICD10KatBlokk=51 /* E50-E64 Andre mangelsykdommer */;
else if substr(Hdiag,1,3) in ('E65','E66','E67','E68') then ICD10KatBlokk=52 /* E65-E68 Fedme og annen overern�ring eller hyperalimentasjon */;
else if substr(Hdiag,1,2) in ('E7','E8','E9') then ICD10KatBlokk=53 /* E70-E90 Metabolske forstyrrelser */;
else if substr(Hdiag,1,2)='F0' then ICD10KatBlokk=54 /* F00-F09 Organiske,inklusive symptomatiske,psykiske lidelser */;
else if substr(Hdiag,1,2)='F1' then ICD10KatBlokk=55 /* F10-F19 Psykiske lidelser og atferdsforstyrrelser som skyldes bruk av psykoaktive stoffer */;
else if substr(Hdiag,1,2)='F2' then ICD10KatBlokk=56 /* F20-F29 Schizofreni,schizotyp lidelse og paranoide lidelser */;
else if substr(Hdiag,1,2)='F3' then ICD10KatBlokk=57 /* F30-F39 Affektive lidelser */;
else if substr(Hdiag,1,2)='F4' then ICD10KatBlokk=58 /* F40-F48 Nevrotiske,belastningsrelaterte og somatoforme lidelser */;
else if substr(Hdiag,1,2)='F5' then ICD10KatBlokk=59 /* F50-F59 Atferdssyndromer forbundet med fysiologiske forstyrrelser og fysiske faktorer */;
else if substr(Hdiag,1,2)='F6' then ICD10KatBlokk=60 /* F60-F69 Personlighets- og atferdsforstyrrelser hos voksne */;
else if substr(Hdiag,1,2)='F7' then ICD10KatBlokk=61 /* F70-F79 Psykisk utviklingshemming */;
else if substr(Hdiag,1,2)='F8' then ICD10KatBlokk=62 /* F80-F89 Utviklingsforstyrrelser */;
else if substr(Hdiag,1,3) in ('F90','F91','F92','F93','F94','F95','F96','F97','F98') then ICD10KatBlokk=63 /* F90-F98 Atferdsforstyrrelser og f�lelsesmessige forstyrrelser som vanligvis oppst�r i barne- og ungdomsalder */;
else if substr(Hdiag,1,3)='F99' then ICD10KatBlokk=64 /* F99 Uspesifisert psykisk lidelse */;
else if substr(Hdiag,1,2)='G0' then ICD10KatBlokk=65 /* G00-G09 Betennelsessykdommer i sentralnervesystemet */;
else if substr(Hdiag,1,2)='G1' then ICD10KatBlokk=66 /* G10-G14 Systemiske atrofier som prim�rt rammer sentralnervesystemet */;
else if substr(Hdiag,1,2)='G2' then ICD10KatBlokk=67 /* G20-G26 Ekstrapyramidale tilstander og bevegelsesforstyrrelser */;
else if substr(Hdiag,1,3) in ('G30','G31','G32') then ICD10KatBlokk=68 /* G30-G32 Andre degenerative sykdommer i sentralnervesystemet */;
else if substr(Hdiag,1,3) in ('G35','G36','G37') then ICD10KatBlokk=69 /* G35-G37 Demyeliniserende sykdommer i sentralnervesystemet */;
else if substr(Hdiag,1,2)='G4' then ICD10KatBlokk=70 /* G40-G47 Episodiske tilstander og anfallsvise forstyrrelser */;
else if substr(Hdiag,1,2)='G5' then ICD10KatBlokk=71 /* G50-G59 Sykdommer i nerver,nerver�tter og nervepleksus */;
else if substr(Hdiag,1,2)='G6' then ICD10KatBlokk=72 /* G60-G64 Polynevropatier og andre sykdommer i det perifere nervesystemet */;
else if substr(Hdiag,1,2)='G7' then ICD10KatBlokk=73 /* G70-G73 Sykdommer i nevromuskul�r overgang og muskler */;
else if substr(Hdiag,1,2)='G8' then ICD10KatBlokk=74 /* G80-G83 Cerebral parese og andre syndromer med lammelse */;
else if substr(Hdiag,1,2)='G9' then ICD10KatBlokk=75 /* G90-G99 Andre sykdommer og tilstander i nervesystemet */;
else if substr(Hdiag,1,2)='H0' then ICD10KatBlokk=76 /* H00-H06 Sykdommer i �yelokk,t�reapparat og �yehule */;
else if substr(Hdiag,1,3) in ('H10','H11','H12','H13') then ICD10KatBlokk=77 /* H10-H13 Sykdommer i conjunctiva */;
else if substr(Hdiag,1,3) in ('H15','H16','H17','H18','H19','H20','H21','H22') then ICD10KatBlokk=78 /* H15-H22 Sykdommer i senehinne,hornhinne,regnbuehinne og str�lelegeme */;
else if substr(Hdiag,1,3) in ('H25','H26','H27','H28') then ICD10KatBlokk=79 /* H25-H28 Sykdommer i linse */;
else if substr(Hdiag,1,2)='H3' then ICD10KatBlokk=80 /* H30-H36 Sykdommer i �rehinne og netthinne */;
else if substr(Hdiag,1,3) in ('H40','H41','H42') then ICD10KatBlokk=81 /* H40-H42 Glaukom */;
else if substr(Hdiag,1,3) in ('H43','H44','H45') then ICD10KatBlokk=82 /* H43-H45 Sykdommer i glasslegeme og �yeeple */;
else if substr(Hdiag,1,3) in ('H46','H47','H48') then ICD10KatBlokk=83 /* H46-H48 Sykdommer i nervus opticus og synsbaner */;
else if substr(Hdiag,1,3) in ('H49','H50','H51','H52') then ICD10KatBlokk=84 /* H49-H52 �yemuskelsykdommer og forstyrrelser i binokul�rfunksjon,akkomodasjon og brytning */;
else if substr(Hdiag,1,3) in ('H53','H54') then ICD10KatBlokk=85 /* H53-H54 Synsforstyrrelser og blindhet */;
else if substr(Hdiag,1,3) in ('H55','H56','H57','H58','H59') then ICD10KatBlokk=86 /* H55-H59 Andre sykdommer i �yet og �yets omgivelser */;
else if substr(Hdiag,1,3) in ('H60','H61','H62') then ICD10KatBlokk=87 /* H60-H62 Sykdommer i ytre �re */;
else if substr(Hdiag,1,3) in ('H65','H66','H67','H68','H69') then ICD10KatBlokk=88 /* H65-H75 Sykdommer i mellom�re og �rebensknute */;
else if substr(Hdiag,1,2)='H7' then ICD10KatBlokk=88 /* H65-H75 Sykdommer i mellom�re og �rebensknute */;
else if substr(Hdiag,1,2)='H8' then ICD10KatBlokk=89 /* H80-H83 Sykdommer i indre �re */;
else if substr(Hdiag,1,2)='H9' then ICD10KatBlokk=90 /* H90-H95 Andre lidelser i �re */;
else if substr(Hdiag,1,3) in ('I00','I01','I02') then ICD10KatBlokk=91 /* I00-I02 Akutt reumatisk feber */;
else if substr(Hdiag,1,3) in ('I05','I06','I07','I08','I09') then ICD10KatBlokk=92 /* I05-I09 Kroniske reumatiske hjertesykdommer */;
else if substr(Hdiag,1,2)='I1' then ICD10KatBlokk=93 /* I10-I15 Hypertensjon */;
else if substr(Hdiag,1,3) in ('I20','I21','I22','I23','I24','I25') then ICD10KatBlokk=94 /* I20-I25 Iskemiske hjertesykdommer */;
else if substr(Hdiag,1,3) in ('I26','I27','I28') then ICD10KatBlokk=95 /* I26-I28 Pulmonal hjertesykdom og sykdommer i lungekretsl�pet */;
else if substr(Hdiag,1,2) in ('I3','I4','I5') then ICD10KatBlokk=96 /* I30-I52 Andre typer hjertesykdommer */;
else if substr(Hdiag,1,2)='I6' then ICD10KatBlokk=97 /* I60-I69 Hjernekarsykdommer */;
else if substr(Hdiag,1,2)='I7' then ICD10KatBlokk=98 /* I70-I79 Sykdommer i arterier,arterioler og kapill�rer */;
else if substr(Hdiag,1,2)='I8' then ICD10KatBlokk=99 /* I80-I89 Sykdommer i vener,lymfekar og lymfeknuter,ikke klassifisert annet sted */;
else if substr(Hdiag,1,2)='I9' then ICD10KatBlokk=100 /* I95-I99 Andre og uspesifiserte forstyrrelser i sirkulasjonssystemet */;
else if substr(Hdiag,1,3) in ('J00','J01','J02','J03','J04','J05','J06') then ICD10KatBlokk=101 /* J00-J06 Akutte infeksjoner i �vre luftveier */;
else if substr(Hdiag,1,3)='J09' then ICD10KatBlokk=102 /* J09-J18 Influensa og pneumoni */;
else if substr(Hdiag,1,2)='J1' then ICD10KatBlokk=102 /* J09-J18 Influensa og pneumoni */;
else if substr(Hdiag,1,2)='J2' then ICD10KatBlokk=103 /* J20-J22 Andre akutte infeksjoner i nedre luftveier */;
else if substr(Hdiag,1,2)='J3' then ICD10KatBlokk=104 /* J30-J39 Andre sykdommer i �vre luftveier */;
else if substr(Hdiag,1,2)='J4' then ICD10KatBlokk=105 /* J40-J47 Kroniske sykdommer i nedre luftveier */;
else if substr(Hdiag,1,2) in ('J6','J7') then ICD10KatBlokk=106 /* J60-J70 Lungesykdommer som skyldes ytre stoffer */;
else if substr(Hdiag,1,3) in ('J80','J81','J82','J83','J84') then ICD10KatBlokk=107 /* J80-J84 Andre luftveissykdommer med prim�r innvirkning p� interstitium */;
else if substr(Hdiag,1,3) in ('J85','J86') then ICD10KatBlokk=108 /* J85-J86 Purulente og nekrotiske tilstander i nedre luftveier */;
else if substr(Hdiag,1,3) in ('J90','J91','J92','J93','J94') then ICD10KatBlokk=109 /* J90-J94 Andre sykdommer i brysthinne */;
else if substr(Hdiag,1,3) in ('J95','J96','J97','J98','J99') then ICD10KatBlokk=110 /* J95-J99 Andre sykdommer i �ndedrettssystemet */;
else if substr(Hdiag,1,2) in ('K0','K1') then ICD10KatBlokk=111 /* K00-K14 Sykdommer i munnhule,spyttkjertler og kjever */;
else if substr(Hdiag,1,2) in ('K2') or Substr(Hdiag,1,3) in ('K30','K31') then ICD10KatBlokk=112 /* K20-K31 Sykdommer i spiser�r,magesekk og tolvfingertarm */;
else if substr(Hdiag,1,3)in ('K35','K36','K37','K38') then ICD10KatBlokk=113 /* K35-K38 Sykdommer i blindtarmsvedheng (appendix vermiformis) */;
else if substr(Hdiag,1,2)='K4' then ICD10KatBlokk=114 /* K40-K46 Brokk */;
else if substr(Hdiag,1,3) in ('K50','K51','K52') then ICD10KatBlokk=115 /* K50-K52 Ikke-infeksi�s enteritt og kolitt */;
else if substr(Hdiag,1,3) in ('K55','K56','K57','K58','K59','K60','K61','K62','K63','K64') then ICD10KatBlokk=116 /* K55-K63 Andre tarmsykdommer */;
else if substr(Hdiag,1,3) in ('K65','K66','K67') then ICD10KatBlokk=117 /* K65-K67 Sykdommer i bukhinne */;
else if substr(Hdiag,1,2)='K7' then ICD10KatBlokk=118 /* K70-K77 Sykdommer i lever */;
else if substr(Hdiag,1,2)='K8' then ICD10KatBlokk=119 /* K80-K87 Forstyrrelser i gallebl�re,galleveier og bukspyttkjertel */;
else if substr(Hdiag,1,2)='K9' then ICD10KatBlokk=120 /* K90-K93 Andre sykdommer i ford�yelsessystemet */;
else if substr(Hdiag,1,2)='L0' then ICD10KatBlokk=121 /* L00-L08 Infeksjoner i hud og underhud */;
else if substr(Hdiag,1,2)='L1' then ICD10KatBlokk=122 /* L10-L14 Bull�se lidelser */;
else if substr(Hdiag,1,2) in ('L2','L3') then ICD10KatBlokk=123 /* L20-L30 Dermatitt og eksem */;
else if substr(Hdiag,1,2)='L4' then ICD10KatBlokk=124 /* L40-L45 Papuloskvam�se lidelser */;
else if substr(Hdiag,1,3) in ('L50','L51','L52','L53','L54') then ICD10KatBlokk=125 /* L50-L54 Urticaria og erytem */;
else if substr(Hdiag,1,3) in ('L55','L56','L57','L58','L59') then ICD10KatBlokk=126 /* L55-L59 Str�lingsrelaterte lidelser i hud og underhud */;
else if substr(Hdiag,1,2) in ('L6','L7') then ICD10KatBlokk=127 /* L60-L75 Lidelser i negler,h�r og hudens kjertler */;
else if substr(Hdiag,1,2) in ('L8','L9') then ICD10KatBlokk=128 /* L80-L99 Andre lidelser i hud og underhud */;
else if substr(Hdiag,1,2) in ('M0','M1','M2') then ICD10KatBlokk=129 /* M00-M25 Leddlidelser */;
else if substr(Hdiag,1,2)='M3' then ICD10KatBlokk=130 /* M30-M36 Systemiske bindevevssykdommer */;
else if substr(Hdiag,1,2) in ('M4','M5') then ICD10KatBlokk=131 /* M40-M54 Rygglidelser */;
else if substr(Hdiag,1,2) in ('M6','M7') then ICD10KatBlokk=132 /* M60-M79 Bl�tvevssykdommer */;
else if substr(Hdiag,1,2) in ('M8') or substr(Hdiag,1,3) in ('M90','M91','M92','M93','M94') then ICD10KatBlokk=133 /* M80-M94 Ben- og brusklidelser */;
else if substr(Hdiag,1,3) in ('M95','M96','M97','M98','M99') then ICD10KatBlokk=134 /* M95-M99 Andre lidelser i muskel-skjelettsystemet og bindevev */;
else if substr(Hdiag,1,2)='N0' then ICD10KatBlokk=135 /* N00-N08 Glomerul�re sykdommer */;
else if substr(Hdiag,1,3) in ('N10','N11','N12','N13','N14','N15','N16') then ICD10KatBlokk=136 /* N10-N16 Tubulointerstitielle nyresykdommer */;
else if substr(Hdiag,1,3) in ('N17','N18','N19') then ICD10KatBlokk=137 /* N17-N19 Nyresvikt */;
else if substr(Hdiag,1,3) in ('N20','N21','N22','N23') then ICD10KatBlokk=138 /* N20-N23 Urolithiasis */;
else if substr(Hdiag,1,3) in ('N25','N26','N27','N28','N29') then ICD10KatBlokk=139 /* N25-N29 Andre forstyrrelser i nyre og urinleder */;
else if substr(Hdiag,1,2)='N3' then ICD10KatBlokk=140 /* N30-N39 Andre forstyrrelser i urinsystemet */;
else if substr(Hdiag,1,2) in ('N4','N5') then ICD10KatBlokk=141 /* N40-N51 Sykdommer i mannlige kj�nnsorganer */;
else if substr(Hdiag,1,2)='N6' then ICD10KatBlokk=142 /* N60-N64 Lidelser i bryst */;
else if substr(Hdiag,1,2)='N7' then ICD10KatBlokk=143 /* N70-N77 Infeksjonssykdommer og andre betennelsestilstander i kvinnelige bekkenorganer */;
else if substr(Hdiag,1,2)='N8' then ICD10KatBlokk=144 /* N80-N98 Ikke-inflammatoriske tilstander i kvinnelige kj�nnsorganer */;
else if substr(Hdiag,1,3) in ('N90','N91','N92','N93','N94','N95','N96','N97','N98') then ICD10KatBlokk=144 /* N80-N98 Ikke-inflammatoriske tilstander i kvinnelige kj�nnsorganer */;
else if substr(Hdiag,1,3)='N99' then ICD10KatBlokk=145 /* N99 Andre forstyrrelser i urinveier og kj�nnsorganer */;
else if substr(Hdiag,1,2)='O0' then ICD10KatBlokk=146 /* O00-O08 Svangerskap med ufullendt utfall */;
else if substr(Hdiag,1,2)='O1' then ICD10KatBlokk=147 /* O10-O16 �dem,proteinuri og komplikasjoner som f�lge av hypertensive lidelser under svangerskap,f�dsel og barseltid */;
else if substr(Hdiag,1,2)='O2' then ICD10KatBlokk=148 /* O20-O29 Andre tilstander hos mor,hovedsakelig knyttet til svangerskap */;
else if substr(Hdiag,1,2) in ('O3','O4') then ICD10KatBlokk=149 /* O30-O48 Omsorg for og behandling av mor ved tilstander hos foster,i amnionhule og mulige f�dselsproblemer */;
else if substr(Hdiag,1,2) in ('O6','O7') then ICD10KatBlokk=150 /* O60-O75 Komplikasjoner under f�dsel og forl�sning */;
else if substr(Hdiag,1,3) in ('O80','O81','O82','O83','O84') then ICD10KatBlokk=151 /* O80-O84 Forl�sning */;
else if substr(Hdiag,1,3) in ('O85','O86','O87','O88','O89','O90','O91','O92') then ICD10KatBlokk=152 /* O85-O92 Komplikasjoner hovedsakelig i barseltid */;
else if substr(Hdiag,1,3) in ('O94','O95','O96','O97','O98','O99') then ICD10KatBlokk=153 /* O94-O99 Andre obstetriske tilstander,ikke klassifisert annet sted */;
else if substr(Hdiag,1,3) in ('P00','P01','P02','P03','P04') then ICD10KatBlokk=154 /* P00-P04 Foster og nyf�dt p�virket av faktorer hos mor og av komplikasjoner under svangerskap,f�dsel og forl�sning */;
else if substr(Hdiag,1,3) in ('P05','P06','P07','P08') then ICD10KatBlokk=155 /* P05-P08 Tilstander knyttet til svangerskapslengde og fostervekst */;
else if substr(Hdiag,1,2)='P1' then ICD10KatBlokk=156 /* P10-P15 F�dselsskader */;
else if substr(Hdiag,1,2)='P2' then ICD10KatBlokk=157 /* P20-P29 Respiratoriske og kardiovaskul�re forstyrrelser spesifikke for perinatalperioden */;
else if substr(Hdiag,1,2)='P3' then ICD10KatBlokk=158 /* P35-P39 Infeksjoner spesifikke for perinatalperioden */;
else if substr(Hdiag,1,2) in ('P5','P6') then ICD10KatBlokk=159 /* P50-P61 Bl�dnings- og blodforstyrrelser hos foster og nyf�dt */;
else if substr(Hdiag,1,3) in ('P70','P71','P72','P73','P74') then ICD10KatBlokk=160 /* P70-P74 Forbig�ende endokrine sykdommer og metabolske forstyrrelser spesifikke for foster og nyf�dt */;
else if substr(Hdiag,1,3) in ('P75','P76','P77','P78') then ICD10KatBlokk=161 /* P75-P78 Forstyrrelser i ford�yelsessystemet hos foster og nyf�dt */;
else if substr(Hdiag,1,2)='P8' then ICD10KatBlokk=162 /* P80-P83 Tilstander som ang�r hud og temperaturregulering hos foster og nyf�dt */;
else if substr(Hdiag,1,2)='P9' then ICD10KatBlokk=163 /* P90-P96 Andre forstyrrelser som oppst�r i perinatalperioden */;
else if substr(Hdiag,1,2)='Q0' then ICD10KatBlokk=164 /* Q00-Q07 Medf�dte misdannelser i nervesystemet */;
else if substr(Hdiag,1,2)='Q1' then ICD10KatBlokk=165 /* Q10-Q18 Medf�dte misdannelser i �ye,�re,ansikt og hals */;
else if substr(Hdiag,1,2)='Q2' then ICD10KatBlokk=166 /* Q20-Q28 Medf�dte misdannelser i sirkulasjonssystemet */;
else if substr(Hdiag,1,3) in ('Q30','Q31','Q32','Q33','Q34') then ICD10KatBlokk=167 /* Q30-Q34 Medf�dte misdannelser i �ndedrettssystemet */;
else if substr(Hdiag,1,3) in ('Q35','Q36','Q37') then ICD10KatBlokk=168 /* Q35-Q37 Leppespalte og ganespalte */;
else if substr(Hdiag,1,3) in ('Q38','Q39') then ICD10KatBlokk=169 /* Q38-Q45 Andre medf�dte misdannelser i ford�yelsessystemet */;
else if substr(Hdiag,1,2)='Q4' then ICD10KatBlokk=169 /* Q38-Q45 Andre medf�dte misdannelser i ford�yelsessystemet */;
else if substr(Hdiag,1,2)='Q5' then ICD10KatBlokk=170 /* Q50-Q56 Medf�dte misdannelser i kj�nnsorganer */;
else if substr(Hdiag,1,3) in ('Q60','Q61','Q62','Q63','Q64') then ICD10KatBlokk=171 /* Q60-Q64 Medf�dte misdannelser i urinsystemet */;
else if substr(Hdiag,1,3) in ('Q65','Q66','Q67','Q68','Q69') then ICD10KatBlokk=172 /* Q65-Q79 Medf�dte misdannelser og deformiteter i muskel-skjelettsystemet */;
else if substr(Hdiag,1,2) ='Q7' then ICD10KatBlokk=172 /* Q65-Q79 Medf�dte misdannelser og deformiteter i muskel-skjelettsystemet */;
else if substr(Hdiag,1,2)='Q8' then ICD10KatBlokk=173 /* Q80-Q89 Andre medf�dte misdannelser */;
else if substr(Hdiag,1,2)='Q9' then ICD10KatBlokk=174 /* Q90-Q99 Kromosomavvik,ikke klassifisert annet sted */;
else if substr(Hdiag,1,2)='R0' then ICD10KatBlokk=175 /* R00-R09 Symptomer og tegn med tilknytning til sirkulasjons- og �ndedrettssystemet */;
else if substr(Hdiag,1,2)='R1' then ICD10KatBlokk=176 /* R10-R19 Symptomer og tegn med tilknytning til ford�yelsessystemet og buken */;
else if substr(Hdiag,1,3) in ('R20','R21','R22','R23') then ICD10KatBlokk=177 /* R20-R23 Symptomer og tegn med tilknytning til hud og underhudsvev */;
else if substr(Hdiag,1,3) in ('R25','R26','R27','R28','R29') then ICD10KatBlokk=178 /* R25-R29 Symptomer og tegn med tilknytning til nervesystemet og muskel-skjelettsystemet */;
else if substr(Hdiag,1,2)='R3' then ICD10KatBlokk=179 /* R30-R39 Symptomer og tegn med tilknytning til urinveiene */;
else if substr(Hdiag,1,3) in ('R40','R41','R42','R43','R44','R45','R46') then ICD10KatBlokk=180 /* R40-R46 Symptomer og tegn med tilknytning til kognisjon,persepsjon,emosjonell tilstand og atferd */;
else if substr(Hdiag,1,3) in ('R47','R48','R49') then ICD10KatBlokk=181 /* R47-R49 Symptomer og tegn med tilknytning til tale og stemme */;
else if substr(Hdiag,1,2) in ('R5','R6') then ICD10KatBlokk=182 /* R50-R69 Generelle symptomer og tegn */;
else if substr(Hdiag,1,2)='R7' then ICD10KatBlokk=183 /* R70-R79 Unormale funn ved blodunders�kelser,uten diagnose */;
else if substr(Hdiag,1,3) in ('R80','R81','R82') then ICD10KatBlokk=184 /* R80-R82 Unormale funn ved urinunders�kelse,uten diagnose */;
else if substr(Hdiag,1,3) in ('R83','R84','R85','R86','R87','R88','R89') then ICD10KatBlokk=185 /* R83-R89 Unormale funn ved unders�kelse av andre kroppsv�sker,stoffer og vev,uten diagnose */;
else if substr(Hdiag,1,3) in ('R90','R91','R92','R93','R94') then ICD10KatBlokk=186 /* R90-R94 Unormale funn ved diagnostisk avbildning og ved funksjonsstudier,uten diagnose */;
else if substr(Hdiag,1,3) in ('R95','R96','R97','R98','R99') then ICD10KatBlokk=187 /* R95-R99 D�rlig definerte og ukjente d�ds�rsaker */;
else if substr(Hdiag,1,2)='S0' then ICD10KatBlokk=188 /* S00-S09 Hodeskader */;
else if substr(Hdiag,1,2)='S1' then ICD10KatBlokk=189 /* S10-S19 Skader p� hals */;
else if substr(Hdiag,1,2)='S2' then ICD10KatBlokk=190 /* S20-S29 Skader i brystregionen */;
else if substr(Hdiag,1,2)='S3' then ICD10KatBlokk=191 /* S30-S39 Skader i bukregionen,nedre del av rygg,lumbalkolumna og bekken */;
else if substr(Hdiag,1,2)='S4' then ICD10KatBlokk=192 /* S40-S49 Skader i skulder og overarm */;
else if substr(Hdiag,1,2)='S5' then ICD10KatBlokk=193 /* S50-S59 Skader i albue og underarm */;
else if substr(Hdiag,1,2)='S6' then ICD10KatBlokk=194 /* S60-S69 Skader p� h�ndledd og h�nd */;
else if substr(Hdiag,1,2)='S7' then ICD10KatBlokk=195 /* S70-S79 Skader i hofte og l�r */;
else if substr(Hdiag,1,2)='S8' then ICD10KatBlokk=196 /* S80-S89 Skader i kne og legg */;
else if substr(Hdiag,1,2)='S9' then ICD10KatBlokk=197 /* S90-S99 Skader i ankel og fot */;
else if substr(Hdiag,1,3) in ('T00','T01','T02','T03','T04','T05','T06','T07') then ICD10KatBlokk=198 /* T00-T07 Skader som omfatter flere kroppsregioner */;
else if substr(Hdiag,1,3) in ('T08','T09','T10','T11','T12','T13','T14') then ICD10KatBlokk=199 /* T08-T14 Skader i uspesifisert del av trunkus,ekstremitet eller kroppsregion */;
else if substr(Hdiag,1,3) in ('T15','T16','T17','T18','T19') then ICD10KatBlokk=200 /* T15-T19 Virkninger av fremmedlegeme som har trengt inn gjennom naturlig �pning */;
else if substr(Hdiag,1,2)='T2' then ICD10KatBlokk=201 /* T20-T32 Brannskader og etseskader */;
else if substr(Hdiag,1,3) in ('T30','T31','T32') then ICD10KatBlokk=201 /* T20-T32 Brannskader og etseskader */;
else if substr(Hdiag,1,3) in ('T33','T34','T35') then ICD10KatBlokk=202 /* T33-T35 Frostskader */;
else if substr(Hdiag,1,2)='T4' then ICD10KatBlokk=203 /* T4n-T50 Forgiftning med legemidler og biologiske substanser */;
else if substr(Hdiag,1,3)='T50' then ICD10KatBlokk=203 /* T4n-T50 Forgiftning med legemidler og biologiske substanser*/;
else if substr(Hdiag,1,3) in ('T51','T52','T53','T54','T55','T56','T57','T58','T59','T60','T61','T62','T63','T64','T65') then ICD10KatBlokk=204 /* T51-T65 Toksiske virkninger av substanser med hovedsakelig ikke-medisinsk anvendelse */;
else if substr(Hdiag,1,3) in ('T66','T67','T68','T69','T70','T71','T72','T73','T74','T75','T76','T77','T78') then ICD10KatBlokk=205 /* T66-T78 Andre og uspesifiserte virkninger av ytre �rsaker */;
else if substr(Hdiag,1,3)='T79' then ICD10KatBlokk=206 /* T79 Visse tidlige komplikasjoner til traume */;
else if substr(Hdiag,1,2)='T8' then ICD10KatBlokk=207 /* T80-T88 Komplikasjoner til kirurgisk og medisinsk behandling,ikke klassifisert annet sted */;
else if substr(Hdiag,1,2)='T9' then ICD10KatBlokk=208 /* T90-T98 F�lgetilstander etter skader,forgiftninger og andre konsekvenser av ytre �rsaker */;
else if substr(Hdiag,1,1) in ('V','W') then ICD10KatBlokk=209 /* V0n-X59 Ulykker */;
else if substr(Hdiag,1,2) in ('X0','X1','X2','X3','X4','X5') then ICD10KatBlokk=209 /* V0n-X59 Ulykker */;
else if substr(Hdiag,1,2) in ('X6','X7','X8','X9','Y1','Y2','Y3') then ICD10KatBlokk=210 /* X6n-Y3n Andre skadetyper */;
else if substr(Hdiag,1,2) in ('Y4','Y5','Y6','Y7') then ICD10KatBlokk=211 /* Y4n-Y84 Komplikasjoner ved medisinsk og kirurgisk behandling */;
else if substr(Hdiag,1,3) in ('Y80','Y81','Y82','Y83','Y84') then ICD10KatBlokk=211 /* Y4n-Y84 Komplikasjoner ved medisinsk og kirurgisk behandling */;
else if substr(Hdiag,1,3) in ('Y85','Y86','Y87','Y88','Y89') then ICD10KatBlokk=212 /* Y85-Y89 Sekvele og f�lgetilstand etter skade og annen ytre �rsak til sykdom eller d�d */;
else if substr(Hdiag,1,2)='Y9' then ICD10KatBlokk=213 /* Y90-Y98 Tilleggsinformasjon om andre faktorer som kan v�re medvirkende til sykdom eller d�d klassifisert annet sted */;
else if substr(Hdiag,1,2) in ('Z0','Z1') then ICD10KatBlokk=214 /* Z00-Z13 Kontakt med helsetjenesten for unders�kelse og utredning */;
else if substr(Hdiag,1,2)='Z2' then ICD10KatBlokk=215 /* Z20-Z29 Kontakt med helsetjenesten p� grunn av potensiell helserisiko i forbindelse med smittsom sykdom */;
else if substr(Hdiag,1,2)='Z3' then ICD10KatBlokk=216 /* Z30-Z39 Kontakt med helsetjenesten i forbindelse med reproduksjonssp�rsm�l */;
else if substr(Hdiag,1,2)='Z4' then ICD10KatBlokk=217 /* Z40-Z54 Kontakt med helsetjenesten i forbindelse med spesielle tiltak og behandlingsopplegg */;
else if substr(Hdiag,1,3) in ('Z50','Z51','Z52','Z53','Z54') then ICD10KatBlokk=217 /* Z40-Z54 Kontakt med helsetjenesten i forbindelse med spesielle tiltak og behandlingsopplegg */;
else if substr(Hdiag,1,3) in ('Z55','Z56','Z57','Z58','Z59') then ICD10KatBlokk=219 /* Z55-Z65 Kontakt med helsetjenesten p� grunn av potensiell helserisiko i forbindelse med sosio�konomiske og psykososiale forhold */;
else if substr(Hdiag,1,2)='Z6' then ICD10KatBlokk=219 /* Z55-Z65 Kontakt med helsetjenesten p� grunn av potensiell helserisiko i forbindelse med sosio�konomiske og psykososiale forhold */;
else if substr(Hdiag,1,2)='Z7' then ICD10KatBlokk=221 /* Z70-Z76 Kontakt med helsetjenesten under andre omstendigheter */;
else if substr(Hdiag,1,2) in ('Z8','Z9') then ICD10KatBlokk=222 /* Z80-Z99 Kontakt med helsetjenesten ved opplysninger om potensiell helserisiko i familiens og egen sykehistorie,og opplysninger om visse forhold som har betydning for helsetilstanden */;
else if substr(Hdiag,1,2) in ('U0','U1','U2','U3','U4') then ICD10KatBlokk=223 /* U00-U49 Midlertidig tilordning av nye sykdommer med usikker etiologi */;
else if substr(Hdiag,1,2) in ('U8','U9') then ICD10KatBlokk=224 /* U80-U99 Bakterier resistente mot antibiotika */;
else if substr(Hdiag,1,2) in (' ','Ugyldig') then ICD10KatBlokk=.;
else ICD10KatBlokk=.;
/*
************************************************************************************************
3.3		Hdiag_3tegn	
************************************************************************************************
/*Definerer hoveddiagnose p� 3-tegnsniv�*/;

Hdiag3tegn=substr(Hdiag,1,3);


/*
************************************************************************************************
3.7	FAG_SKDE
************************************************************************************************
/*Lager ny harmonisert variabel fra FAG og FAGLOGG. */

%if &avtspes ne 0 %then %do;
if aar in (2012:2014) then do;

/***	2011 - 2014		***/

if Fag = 1 then Fag_SKDE = 1;
if Fag = 2 then Fag_SKDE = 2;
if Fag = 3 then Fag_SKDE = 3;
if Fag = 4 then Fag_SKDE = 4;
if Fag = 5 then Fag_SKDE = 5;
if Fag in (6:10,24,25) then Fag_SKDE = 6;
if Fag in (11:14) then Fag_SKDE = 11;
if Fag = 15 then Fag_SKDE = 15;
if Fag = 16 then Fag_SKDE = 16;
if Fag = 17 then Fag_SKDE = 17;
if Fag = 18 then Fag_SKDE = 18;
if Fag = 19 then Fag_SKDE = 19;
if Fag = 20 then Fag_SKDE = 20;
if Fag = 21 then Fag_SKDE = 21;
if Fag = 22 then Fag_SKDE = 22;
if Fag = 23 then Fag_SKDE = 23;
if Fag = 30 then Fag_SKDE = 30;
if Fag = 31 then Fag_SKDE = 31;

end;

/***	2015og 2016	***/

if aar in  (2015:2016) then do;

if fagLogg = "anestesi" then Fag_SKDE = 1;
if fagLogg = "barn" then Fag_SKDE = 2;
if fagLogg = "fys med" then Fag_SKDE = 3;
if fagLogg = "gyn" then Fag_SKDE = 4;
if fagLogg = "hud" then Fag_SKDE = 5;
if substr(fagLogg,1,5)= 'indre' then Fag_SKDE = 6;
if substr(fagLogg,1,3)= 'kir' then Fag_SKDE = 11;
if fagLogg = "nevrologi" then Fag_SKDE = 15;
if fagLogg = "ortopedi" then Fag_SKDE = 16;
if fagLogg = "plastkir" then Fag_SKDE = 17;
if fagLogg = "radiologi" then Fag_SKDE = 18;
if fagLogg = "revma" then Fag_SKDE = 19;
if fagLogg = "urologi" then Fag_SKDE = 20;
if fagLogg = "�nh" then Fag_SKDE = 21;
if fagLogg = "�ye" then Fag_SKDE = 22;
if fagLogg = "onkologi" then Fag_SKDE = 23;
if fagLogg = "psykiatri" then Fag_SKDE = 30;
if fagLogg = "psykologi" then Fag_SKDE = 31;

end;

tell_Normaltariff = tell_takst;
AvtSpes=1;
drop tell_takst;
%end;

run;

%Mend ICD;