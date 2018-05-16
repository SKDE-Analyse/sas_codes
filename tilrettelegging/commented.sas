
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
 - Venter p� tilbakemelding fra Lars R�nningen i SAMDATA/FIOA som skal ha en ny runde med Helse Vest RHF ang�ende opptaksomr�der i Bergen (per 04.10.2016)
**************************************************/
/*GEOGRAFISK SEKTORISERING AV BERGEN LOKALSYKEHUSOMR�DE. SEKTORISERING INDREMEDISIN IVERKSETTES 1. JANUAR 1999
F�lgende sektorisering er vedtatt:

Haraldsplass Diakonale sykehus (HDS);
**********************************************
Bergen kommune, bydelene: Sentrum, Sandviken, Eidsv�g-Salhus, �sane, Arna (gammel informasjon)
Kommunene: Lind�s, Meland, Rad�y, Austrheim, Fedje, Masfjorden, Samnanger, Oster�y (gammel informasjon)

Informasjon fra Haraldsplass Diakonale Sykehus ved P�l Asle Reiersgaars 29.09.2106:
Basert p� de ulike avtaler som foreligger er HDS sitt geografiske �H-opptaksomr�de som f�lger:
 
-          Nordhordland:   Lind�s, Meland, Oster�y, Rad�y, Austrheim, Modalen, Fedje, Masfjorden 
-          Gulen (offisielt fra 01.09.2016)
-          Samnanger: kommunen betaler HDS for drift av en �HD-seng
-          Bergen kommune: bydelene Arna. Bergenhus  og �sane
 
N�r det gjelder kirurgi og ortopedi har vi en �H-avtale med HUS/HBE. Den fungere slik:
 
-          FCF (l�rhalsbrudd): hver 3. til HDS
-          5 f�rste kirurgiske og/eller ortopedisk �H g�r til HDS
-          �n ekstra operasjonsklar ortopedisk pasient mottas daglig ved HDS etter innleggelse
og klarering ved HUS. En av disse pasientene per uke kan v�re FCF (l�rhalsbrudd)

Linda: "Fram til n� har vi gruppert alle bosatte i f�lgende kommuner til Helse Bergen HF: 1201,1233,1234,1235,1238,1241,1242,1243,1244,1245,1246,
1247,1251,1252,1253,1256,1259,1260,1263,1264,1265,1266. Ut ifra det du skriver under kan det h�res ut som at dette ikke er helt riktig. 
Hva mener du?" 
P�l: "Ja dette blir feil, vi har en klar fordeling i Bergen p� hvilke kommuner og bydeler som h�rer til de to sykehusene." 



Haukeland Universitetssykehus (HUS);
************************************
Bergen kommune, bydelene: Land�s, L�vstakken, Fana, Ytrebygda, Fyllingsdalen, Loddefjord, laksev�g
Kommunene: Os, Fusa, Sund, Fjell, �ygarden og Ask�y*/


