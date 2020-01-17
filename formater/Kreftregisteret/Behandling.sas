/* Opprettet 27.11.2019 - Frank Olsen
Hentet fra Beate Hauglann*/

proc format;
value kirurgi
/*Diagnostiske inngrep*/
00 = 'Intet inngrep (gammel kode)'
01 = 'Biopsi uten kirurgisk inngrep/eksplorasjon (Diagnostisk inngrep)' /* (basis 70, 72, 74, 75 eller 76) Solide svulster: Biopsi rettet mot primaersvulst uten kirurgisk eksplorasjon Non-solide svulster: Biopsi av enhver type (lymfeknutebiopsi, ekstirpasjon 
av overfladisk lymfeknute i diagnostisk oeyemed, benmargsbiopsi, annen organbiopsi)*/
02 = 'Kirurgisk aapning/eksplorasjon (Diagnostisk inngrep)' /*(f.eks. kraniotomi, torakotomi, laparotomi, osteotomi) med eller uten biopsi*/
07 = 'Vaktpostlymfeknute (sentinel node) (Diagnostisk inngrep)' /*Uttak av én eller flere lymfeknuter etter injeksjon av fargestoff eller radioaktiv isotop [For C50 Brystkreft i bruk f.o.m. 22.11.2001] 
[For C44 Malignt melanom i bruk f.o.m. 24.03.2003]*/
95 = 'Biopsi fra metastase (BASIS 60), lokalt residiv (BASIS 57), svulst som verken kan klassifiseres som primaersvulst eller metastase (BASIS 79) eller biopsi uten svulstvev (BASIS 98) paa histologisk melding. (Diagnostisk inngrep)' 
/*Klinisk melding krever BASIS 72 (benyttes bare for solide svulster) 
[Gyldig for svulster med diagnosedato f.o.m. 01.01.2001, tatt i bruk i 2003]*/
96 = 'Cytologisk proeve (Diagnostisk inngrep)(celleundersoekelse ved aspirasjon av svulstceller, blodutstryk, benmargsutstryk og kroppsvaeskeundersoekelser).' 
/*[I bruk f.o.m. 01.02.2002]*/
99 = 'Mangelfulle opplysninger om kirurgisk inngrep (Diagnostisk inngrep)'
/*Terapeutiske inngrep*/
/*01 = 'Denne koden har spesiell betydning for brystkreft*'*/
09 = 'Lokal ablativ terapi av primaersvulst (behandling som oedelegger svulsten) med eller uten tidligere/samtidig diagnostisk biopsi.' /*Omfatter
laserbehandling (men ikke laserkniv), fotodynamisk behandling (PDT), kryokirurgi, radiofrekvensablasjon (RFA), fulgurasjon o.a. Tatt i bruk i 2003*/
10 = 'Kirurgisk fjernelse av primaersvulst sammen med deler av eller hele organet (evt. med lymfadenektomi)'
/*('10' ved C61: Radikal prostatektomi) */
/*('10' ved C44: Fjernelse av svulst i hud */
/*('10' ved C50: Benyttes for kvinner ikke etter 01.01.1993*/ 
/*('10' ved C53: Trakelektomi*/
11 = 'Kirurgisk fjernelse av primaersvulst (ev. med lymfadenektomi)' 
/*For C50-svulster benyttes KIRURGI 11 for kvinner bare for aberrant brystkjertel (C50.9/170.8) etter 01.01.1993*/
12 = 'Lymfadenektomi (systematisk dissikering av lymfeknuter) (partielt eller totalt)'
13 = 'Prostatektomi, transvesikal (suprapubisk)'
/*Transvesikal reseksjon av blaeresvulst (cystectomi kodes KIRURGI 10, 
transvesikal biopsi kodes KIRURGI 02)*/
14 = 'C50: Mastektomi uten lymfadenektomi C61: Cystoprostatektomi. 
C67: Cystoprostatektomi.  
C73: Hemithyreoidectomi.'
15 = 'Mastektomi med lymfadenektomi' /*(KIRURGI 10 t.o.m. 31.12.92)*/
16 = 'Mastektomi, lymfadenektomi ikke spesifisert' /*(KIRURGI 10 t.o.m. 31.12.92)*/
17 = 'Brystbevarende kirurgi (lumpektomi, kvadrantektomi) uten lymfadenektomi, biopsi i betydningen fjernelse av hele svulsten i terapeutisk oeyemed)'
/*(KIRURGI 11 t.o.m. 31.12.92)*/
18 = 'Brystbevarende kirurgi (lumpektomi, kvadrantektomi) med lymfadenektomi'
/*(KIRURGI 11 t.o.m. 31.12.92)*/
19 = 'Brystbevarende kirurgi, lymfadenektomi ikke spesifisert'
/*(KIRURGI 11 t.o.m. 31.12.92)*/
20 = 'Transurethral reseksjon (TUR), Konisering (inkl. laser) og amputasjon av livmorhals'
/*(transurethral biopsi kodes KIRURGI 01)*/
/*Gammel koding: bronkoskopi+laser ved lungecancer (brukt paa DNR-meldinger)*/
/*Gammel koding: Reseksjon av hjernetumores (unntatt inngrep paa meningiomer, nevrinomer og hypofyseadenomer som kan kodes 11)*/
21 = 'Terapeutisk inngrep mot metastase' /*Historisk kode. (OBS: lymfadenektomi kodet KIRURGI 12)*/
25 = 'Mastektomi med uttak av vaktpostlymfeknute' /*(Tatt i bruk i 2003)*/
26 = 'Mastektomi med uttak av vaktpostlymfeknute og lymfadenektomi'
/*[Kan benyttes fra 01.01.1993, tatt i bruk i 2004, bare for kvinner]*/
28 = 'Brystbevarende kirurgi (lumpektomi, kvadrantektomi) med uttak av vaktpostlymfeknute' /*(Tatt i bruk i 2003)*/
29 = 'Brystbevarende kirurgi (lumpektomi, kvadrantektomi) med uttak av vaktpostlymfeknute og lymfadenektomi'
/*[Kan benyttes fra 01.01.1993, tatt i bruk i 2004, bare for kvinner]*/
30 = 'Anastomose- og drenasjoeoperasjoner som etablerer ny passasje utenom tumor uten aa fjerne denne.'
/*Herunder: Ventriculostomi (i hjernen), Tracheostomi, Gastrostomi, Gastro-enterostomi, Colostomi,*/ 
/*Coecostomi, Transversostomi, Sigmoideostomi, Cholecysto-duodenostomi, Cystostomi, Nephrostomi (gammel kode)*/
35 = 'Utvidet eksisjon (re-eksisjon) etter tidligere eksisjon av primaersvulst' /*(Tatt i bruk i 2003)*/
40 = 'Andre rent palliative inngrep, ikke direkte rettet mot tumor eller met.'
/*Herunder: Splenectomi, Cordotomi, Denervasjon (gammel kode)*/
50 = 'Prostata resesert transurethralt (gammel kode)'
97 = 'Terapeutisk inngrep rettet mot residiv eller metastase (lymfadenektomi kodes KIRURGI 12), avlastende/palliativ kirurgisk behandling 
med eller uten reseksjon av primaersvulst eller metastase, annet terapeutisk inngrep som ikke er rettet mot primaersvulst, residiv eller metatase.'
/*Unntak: TUR av residiv i urinblaere og blaerehalskjertel kodes KIRURGI 20*/
98 = 'Historisk kode - Operert uns';
run;

