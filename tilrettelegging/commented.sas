
/*
**************************************
* Fra 2_ Macro - Bo og behandler.sas *
**************************************
*/

/* Fjerne dette hvis behandlingsstedKode2 er riktig for Glittre og Feiring */

/* NB! Sjekk om Glittre og Feiring er skilt i behandlingsstedKode2 i data fra og med 2015 */
/* Syntaks for sjekk og eventuell korrigering:*/
/*PROC TABULATE*/
/*DATA=GLITTRE_FEIRING;*/
/*	WHERE (behandlingsstedKode2 in (973144383, 974116561));*/
/*	CLASS aar /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetKode /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetLokal /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS behandlingsstedKode2 /	ORDER=UNFORMATTED MISSING;*/
/*	TABLE */
/*behandlingsstedKode2*tjenesteenhetKode*tjenesteenhetLokal*ALL={LABEL="Total"},*/
/*N*aar;*/
/*RUN;*/
/**/
/*data GLITTRE_FEIRING_korr;*/
/*set GLITTRE_FEIRING;*/
/*if behandlingsstedKode2 in (973144383, 974116561) and tjenesteenhetKode=3200 then behandlingsstedKode2=974116561;*/
/*run;*/
/**/
/*PROC TABULATE*/
/*DATA=GLITTRE_FEIRING_korr;*/
/*	WHERE (behandlingsstedKode2 in (973144383, 974116561));*/
/*	CLASS aar /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetKode /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetLokal /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS behandlingsstedKode2 /	ORDER=UNFORMATTED MISSING;*/
/*	TABLE */
/*behandlingsstedKode2*tjenesteenhetKode*tjenesteenhetLokal*ALL={LABEL="Total"},*/
/*N*aar;*/
/*RUN; */

/* 
**************************************************/
/*IKKE KODET OPP, MEN AKTUELT SENERE?:*/
/*Bosykehus Helse Bergen
 - Venter på tilbakemelding fra Lars Rønningen i SAMDATA/FIOA som skal ha en ny runde med Helse Vest RHF angående opptaksområder i Bergen (per 04.10.2016)
**************************************************/
/*GEOGRAFISK SEKTORISERING AV BERGEN LOKALSYKEHUSOMRÅDE. SEKTORISERING INDREMEDISIN IVERKSETTES 1. JANUAR 1999
Følgende sektorisering er vedtatt:

Haraldsplass Diakonale sykehus (HDS);
**********************************************
Bergen kommune, bydelene: Sentrum, Sandviken, Eidsvåg-Salhus, Åsane, Arna (gammel informasjon)
Kommunene: Lindås, Meland, Radøy, Austrheim, Fedje, Masfjorden, Samnanger, Osterøy (gammel informasjon)

Informasjon fra Haraldsplass Diakonale Sykehus ved Pål Asle Reiersgaars 29.09.2106:
Basert på de ulike avtaler som foreligger er HDS sitt geografiske ØH-opptaksområde som følger:
 
-          Nordhordland:   Lindås, Meland, Osterøy, Radøy, Austrheim, Modalen, Fedje, Masfjorden 
-          Gulen (offisielt fra 01.09.2016)
-          Samnanger: kommunen betaler HDS for drift av en ØHD-seng
-          Bergen kommune: bydelene Arna. Bergenhus  og Åsane
 
Når det gjelder kirurgi og ortopedi har vi en ØH-avtale med HUS/HBE. Den fungere slik:
 
-          FCF (lårhalsbrudd): hver 3. til HDS
-          5 første kirurgiske og/eller ortopedisk ØH går til HDS
-          Én ekstra operasjonsklar ortopedisk pasient mottas daglig ved HDS etter innleggelse
og klarering ved HUS. En av disse pasientene per uke kan være FCF (lårhalsbrudd)

Linda: "Fram til nå har vi gruppert alle bosatte i følgende kommuner til Helse Bergen HF: 1201,1233,1234,1235,1238,1241,1242,1243,1244,1245,1246,
1247,1251,1252,1253,1256,1259,1260,1263,1264,1265,1266. Ut ifra det du skriver under kan det høres ut som at dette ikke er helt riktig. 
Hva mener du?" 
Pål: "Ja dette blir feil, vi har en klar fordeling i Bergen på hvilke kommuner og bydeler som hører til de to sykehusene." 



Haukeland Universitetssykehus (HUS);
************************************
Bergen kommune, bydelene: Landås, Løvstakken, Fana, Ytrebygda, Fyllingsdalen, Loddefjord, laksevåg
Kommunene: Os, Fusa, Sund, Fjell, Øygarden og Askøy*/


