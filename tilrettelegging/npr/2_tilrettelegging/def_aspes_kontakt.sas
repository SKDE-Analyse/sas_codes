%macro def_aspes_kontakt(inndata=, utdata=);
Data &utdata;
	Set &inndata(drop=kontakt);

	/*
 *****************************************************************************************************************
	1. Definere kontakttype for å kunne utelate alt annet enn definerte spesialistkontakter
	- Definisjoner av andre rapporterte opphold fra Vedlegg 1 i "Aktivitetsdata for 
	  avtalespesialister 2012", Norsk pasientregister/Helsedirektoratet.
	- Konsultasjoner som kun inneholder enkle kontakter
	- Allmennlegetakster (Normaltariff 2ad-2hd og 11ad-11id)
	- Konsultasjoner som kun inneholder laboratorieundersøkelser og prøver (Normaltariff 701a-743b)
	- Kontakter som kun inneholder radiologitakster (Normaltariff 801-899)
	- Kontakter som kun inneholder legeerklæringstakst (L120)
	- Kontakter som tolkes som dubletter, det vil si kontakter med samme pasient-ID, 
	  kontaktdato og hovedtilstand
	
	NB! SKDE kommer ut med noen flere spesialistkontakter enn hva som fremgår av NPR-rapporten
	    "Aktivitetsdata for avtalespesialister 2012" (1 409). Dette skyldes at vi har noen flere
	    kontakter i utgangspunktet (supplert fil som inkluderer etterrapporterte data?)

	All kode er basert på syntaks fra NPR v/Ertsgaard "Kontakttype", mottatt 11.10.2012 
	******************************************************************************************************************
	 */

	/*
	Lage variabelen kontakt med verdiene:
	 0 'Rapporterte kontakter uten konsultasjonstakst'
	 1 'Enkle kontakter' 
 	 2 'Allm.legekonsult./-sykebesøk'
 	 3 'Kun spesialisterklæring med undersøkelse'
	 4 'Spesialistkonsultasjoner'
	 5 'Lysbehandling'.
	*/

	*initialize variable;
	kontakt_def=0;

	Array Normaltariff (*) takst_: ;

	do i=1 to dim(Normaltariff);
	  Normaltariff(i)=lowcase(Normaltariff(i));
	end;

	/*
	A - Enkle kontakter, kontakt_def=1
	*/
		do i=1 to dim(Normaltariff);
			if Substr(Normaltariff{i},1,1) in ('1') and Substr(Normaltariff{i},2,2) in 
			('ad','ak','bd','be','bk','c','d','e','f','g','h','i') then kontakt_def=1;
		end;


	/*
	B - Allm.legekons. og -sykebesøk, kontakt = 2.
	*/
		do i=1 to dim(Normaltariff);
		IF SUBSTR(Normaltariff{i},1,2) in ('11') and SUBSTR(Normaltariff{i},3,2)in 
		('ad','ak','bd','cd','ck','dd','dk','e','f','gd','hd','id') then kontakt_def=2;
		ELSE IF SUBSTR(Normaltariff{i},1,1) in ('2') and SUBSTR(Normaltariff{i},2,2) in 
		('ad','ak','bd','cd','ck','dd','dk','ed','fk','gd','hd','p') then kontakt_def=2;
		end;


	/* 
	B - Spesialisterklæring med undersøkelse, kontakt = 3.
	*/
	  do i=1 to dim(Normaltariff);
		IF Normaltariff{i} in ('L120','l120') then kontakt_def=3;

	 	/* Legeerklæring for viktig legemidler (H-resept).*/
		IF Normaltariff{i} in ('H1','h1') then kontakt_def= 3;
		end;


	/*
	B - Spesialistkonsultasjoner. For spesialister er det bare to aktuelle takter 3ad Konsultasjon dagtid og 12ad Sykebesøk dagtid. 
		Tillegg for ekstratidsbruk tas ikke med ettersom det forutsetter allerede bruk av en av de to nevnte.
	*/
	/* Tove 04.04.2022: lagt til nye kode for e-konsultasjon fra Normaltariffen 2021-2022 */
		do i=1 to dim(Normaltariff);
		IF Normaltariff{i} in ('3ad','12ad','3ae'/*,'3bd','3c'*/) /*or SUBSTR(Normaltariff{i},1,1) in ('4') and 
		SUBSTR(Normaltariff{i},2,2) in ('a1','a2','b1','b2','c1','c2','da','db')*/ then kontakt_def= 4;

		else do;
/* new code added 10.04.2021 , based on normaltariffen 2020-2021 */
IF Normaltariff{i} in ('3bd','3c','12bd','12cd','107c','157','207c','217d','254','255a','255b','258','510a','720','722','731a','734a','741','743b','744') or
   SUBSTR(Normaltariff{i},1,3) in ('4a1','4b1','4c1','4c2','4da','4db') or 
   SUBSTR(Normaltariff{i},1,2) in ('4e') 
then kontakt_def= 4;



	/*
	B - Sykebesøk av spesialist.
	*/
		/*do i=1 to 15;
		IF SUBSTR(Normaltariff{i},1,1) in ('1') and SUBSTR(Normaltariff{i},2,3) in ('2ad','2bd','2cd','3d') 
		then kontakt_def= 4;
		end;*/

	/*
	B - Besøksrunde.
	*/
		/*do i=1 to 15;
		IF SUBSTR(Normaltariff{i},1,1) in ('1') and SUBSTR(Normaltariff{i},2,3) in ('4','4d') then kontakt_def= 4;
		end;*/



   	/* Avsnitt E. Prosedyretakster*/

	/*E - Særskilte kirurgitakster .
	*/
		IF SUBSTR(Normaltariff{i},1,1) in ('K','k') then kontakt_def= 4;


	/*
	E - Alminn Normaltariff.
	*/
		/*do i=1 to 15;
		IF Normaltariff{i} in ('100','101','102','103','104','105','106a','106b','107c','110') then 
		kontakt_def= 4;
		end;*/
    /*Utgår:Alminnelige prosedyrer takst 100-111.
	    	En takst som også kan tas av fastleger. */

 
	/*
	E - Gastroenterologi.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('11') and SUBSTR(Normaltariff{i},3,2) in 
		('2a','2b','4a','4c','5a','5b','6') then kontakt_def= 4;
		ELSE IF Normaltariff{i} in ('120'/*,'121a'*/) then kontakt_def= 4;
	 /*Utgår: 121a Karbohydratbelastning. En takst som også kan tas av alle fastleger. */

	/*
	E -  Indremedisin.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('12') and SUBSTR(Normaltariff{i},3,2) in 
		('4','5a','5b','6','7a','7b','7c','7d',/*'8a',*/'8c','9a','9c','9d','9e'/*,'9f','9g'*/,'9h','9i') then kontakt_def= 4;
	/*Tillegg av :126 Intravenøs cytostatika, 129h Pacemakerkontroll, 129i EKKO/Doppler*/
	/*Utgår: 128a, 129f og 129g,- takster som også kan tas av alle fastleger. */

	/*
	E - Kirurgi
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('13') and SUBSTR(Normaltariff{i},3,2) in 
		('0g','4a','4b','4e','4f','7e','9a','9b') then kontakt_def= 4;
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('14') and SUBSTR(Normaltariff{i},3,2) in 
		('0a','0b','0c','0d','0e','0f','0g','0h','0i','0j','0k','0l','1a',/*'1b',*/'1c',
		'1d','2c','3a','3c','3e','3f','3g',/*'4c',*/'5b'/*,'6b','7c','8'*/) then kontakt_def= 4;
	/*Utgår: 141b, 144c, 146B, 147c er alle takster som ikke finnes i Normaltariff e. 2014.
		Taksten 148 Nødvendig kollegial assistanse utført av lege ved operasjon per time, utgår. 
		En takst som kan tas av alle lege, er dessuten en tilleggstakst til annen kirurgisk prosedyre*/

	/* 
	E - Anestesiologi.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('14') and SUBSTR(Normaltariff{i},3,2) in (/*'9a',*/'9b'/*,'9g','9h'*/) 
		then kontakt_def= 4;
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('15') and SUBSTR(Normaltariff{i},3,2) in 
		('0','1a','1b','1c','2','3b','3d','3e','4a','4b','4c','5','6') then kontakt_def= 4; 	
	/*Tillegg av takst: 150 Tillegg til konsultasjon hos anestesilege tilknyttet multidisiplinær smerteklinikk og 
	                  	156 Vurdering og oppfølging av opioidbehandling ved smertebehandlig.*/
	/*Utgår: 149a,g,h Lokalbedøvelse og blokk-ledningsanestesi, takstene kan også tas av fastleger og i legevakt*/

	/* 
	E -  Allergologi.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('17') and SUBSTR(Normaltariff{i},3,2) in 
		('6',/*'7a','7b','7c',*/'7d','7k'/*,'7g'*/) then kontakt_def= 4; 	
	/*Tillegg av takst: 177d Hyposensibilisering og 177k Kostholdsprovokasjon.*/
	/*Utgår: 177a,c Perkutane allergiprøver, kan også tas av fastleger og i legevakt. 177b,g finnes i Normaltariff e. 2014*/

	/*  
	E - Gynekologi.
	*/
	/* Tove 04.04.2022: takst 206 er ny av 2021 */
		IF SUBSTR(Normaltariff{i},1,2) in ('20') and SUBSTR(Normaltariff{i},3,2) in 
		('5a','5b','6','7a','7b','8','9') then kontakt_def= 4;
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('21') and SUBSTR(Normaltariff{i},3,2) in 
		('0','1a','1b','1c','1d','1e','2a','2b','3'/*'4a','4b','4c','5',*/'6',/*'7a','7b','7c',*/'8'/*,'9'*/) 
		then kontakt_def= 4; /*Tillegg av takst: 213 Behandling av spontan abort. */
	/*Utgår: 214a,b,c Spiral, pessar, endometriebiopsi/cytologi, 215 Sterilisering-abortsaker, 217a,b,c gravidekontroll, kan også tas av fastleger.
		     206 og 219 finnes ikke i Normaltariffen e. 2014*/

	/* 
	E -  Hud- og veneriske sykdommer.
	-> HER ER LYSBEHANDLING, 254, 255a,b, DEFINERT TIL kontakt_def = 5 **.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('25') and SUBSTR(Normaltariff{i},3,2) in 
		('0','1','2','3','6a','6b','6c','6d','7','9') then kontakt_def= 4;

	/*
	E - Øre-nese-halssykdommer.
	*/
	/* Tove 04.04.2022: ny takst 259 */
		IF SUBSTR(Normaltariff{i},1,2) in ('30') and SUBSTR(Normaltariff{i},3,2) in ('1a','1b','1c','1d','2','3','6','7'/*,'8','9'*/) then kontakt_def= 4; 
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('31') and SUBSTR(Normaltariff{i},3,2) in (/*'0',*/'1a','1c','3','4',/*'5',*/'7b','8a','8b','9') then kontakt_def= 4;
	/*Tillegg av takst: Takst 302 og 307, og 319 Apne */
	/*Utgår: 310 Epistaxis, kan også tas av fastleger og i legevakt. Takst 308, 309 og 315 finnes i Normaltariffen e. 2014*/


	/*
	E -  Hørselsmåling.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('32') and SUBSTR(Normaltariff{i},3,2) in 
		('1',/*'2',*/'3','4a','4b','4c','4d','4e',/*'5',*/'6a','6b','8a') then kontakt_def= 4;
	/*Utgår: 322 Toneaudiometri m/luftledning, 325 Us av et el. begge ører, kan også tas av fastleger og i legevakt*/


	/* 
	E - Øyesykdommer.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('40') and SUBSTR(Normaltariff{i},3,2) in 
		('0',/*'2',*/'3a','3b','4a','4b','4c','5a','5b','6a','6b','7','8a','8b','8c','9') then 
		kontakt_def= 4;
		ELSE IF Normaltariff{i} in ('410','411','412') then kontakt_def= 4;
	/*Utgår: 402 Tonometri hos allmennlege, kan også tas av fastleger og i legevakt*/


	/*
	E -  Lungesykdommer.
	*/
		IF SUBSTR(Normaltariff{i},1,2) in ('50') and SUBSTR(Normaltariff{i},3,2) in 
		(/*'1',*/'2a','2b',/*'4','6','7c','7d',*/'8','9') then kontakt_def= 4;
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('51') and SUBSTR(Normaltariff{i},3,2) in 
		('0b',/*'0c','0d',*/'0e','0f') then kontakt_def= 4;
	/*Utgår: 501, 506, 507c,d, 510c,d, diagnostiske us av lungene, kan også (el. kun) tas av fastleger og i legevakt. Takst 504 finnes ikke i Normaltariff e. 2014*/

	/*
	E - Nervesykdommer og sinnslidelser.
	*/
	/* Tove 04.04.2022: ny takst 602 */
		IF Normaltariff{i} in ('600','601','602','605') then kontakt_def= 4; /*Taksten 601 Utredning av omfattende og alvorlig sykdom i sentralnervesystemet, som kun kan benyttes av nevrolog,- er lagt til*/
	/*	ELSE IF SUBSTR(Normaltariff{i},1,2) in ('61') and SUBSTR(Normaltariff{i},3,2) in 
		(/*'2a','2b','5','6','7','8'*//*) then kontakt_def= 4;*/
	/* Tove 04.04.2022: lagt til takst 620 */
		ELSE IF SUBSTR(Normaltariff{i},1,2) in ('62') and SUBSTR(Normaltariff{i},3,2)  in 
		('0','1a','1b','1c','1d','2a','2b','3a','3b','3c','3d','4a','4b','5a','5b','6') then kontakt_def=4;

	/* 
	E - Pediatri.
	*/
	/* Tove 04.04.2022: takst fra 2017 */
		IF Normaltariff{i} in ('651a','651b','652') then kontakt_def= 4;

	  end; 
	end; 

	/*
	Lysbehandling.
	*/
		do i=1 to dim(Normaltariff);
		IF SUBSTR(Normaltariff{i},1,2) in ('25') and SUBSTR(Normaltariff{i},3,2) in ('4','5a','5b','8') then 
		kontakt_def= 5;
		end;
	
		drop i;

rename kontakt_def = kontakt;	
run;
%mend;