proc format;
    value avvikl_kode
        1 = "1: Helsehjelp er påbegynt"
        2 = "2: Pasienten ønsker ikke helsehjelp"
        3 = "3: Pasienten er henvist til et annet sykehus/institusjon (unntatt fritt behandlingsvalg)"
        4 = "4: Pasienten har valgt annet sykehus/institusjon"
        5 = "5: Pasienten mottar helsehjelp ved annet sykehus/institusjon rekvirert av HELFO"
        7 = "7: Pasienten er henvist til avtalespesialist"
        9 = "9: Annen årsak til ventetid slutt/helsehjelp uaktuelt"
       98 = "98: Henvperioden er avsluttet, men ventetid sluttdato mangler"
       99 = "99: Har ventetid sluttdato, mangler kode"
        ;

    value RAPPORTERTRETTTILHELSEHJELP
        3 = "3: PRett til nødvendig helsehjelp" /*i spesialisthelsethenesten*/
        5 = "5: Ikke behov for helsehjelp" /*i spesialisthelsethenesten*/
        6 = "6: Henvisningen er ikke aktuell for rettighetsvurdering"; /*i spesialisthelsethenesten*/


	value AV_KODE 
		1 =	"1: Ja"
		0 =	"0: Nei";

	value fortsatt_kode 
		1 =	"1: Ja"
		0 =	"0: Nei";

	value ny_henvist
		1 =	"1: Ja"
		0 =	"0: Nei";

	value fristbrudd
		1 =	"1: Ja"
		0 =	"0: Nei";

	value SLETTE_KODE /*slette_kode må være missing å beregne avviklede, ventende, nyhenviste, aviiklede fristbrudd, ventende fristbrudd*/
         0 = "0: Tilhører ventelistegrunnlag"
         1 = "1: Ventetid-sluttdato satt, ventetid-sluttkode mangler"
        11 = "11: Ventetid-sluttdato før periodeslutt"
         3 = "3: Ventetid-sluttdato satt, ventetid-sluttkode mangler"
         6 = "6: Avdelingskode første siffer 26 (fødeavd) og fagområde lik 360, 365, 370 (rus) eller Utfall av vurdering lik 6 (graviditet)"
         9 = "9: Ventetid-startdato mangler"
         7 = "7: Ventetid-startdato er etter periodeslutt"
        10 = "10: Pasienten har stått over 10 år på venteliste"
        31 = "31: Rett til helsehjelp lik 5 (dette er avviste)"
        12 = "12: Ventetid 0 eller 1 dag og ventetid-slutt før periodeslutt og ventetid-sluttkode ulik 3,4,5. Eller utfall av vurdering lik 4 (ø-hjelp)"
        20 = "20: Vurderingsdato mangler"
        21 = "21: Utfall av vurdering lik 3 (kontroll)"
        22 = "22: Ventetid-sluttdato lik vurderingsdato og ventetid-sluttkode ulik 3,4,5"
        23 = "23: Medisinsk serviceavdeling (første siffer 8) og fagområde lik 360,365, 370 (rus) eller radiologiavdeling (fagområde 852)"
        24 = "24: Andre serviceavdelinger (første siffer 9)"
        27 = "27: Utfall av vurdering lik 5 (nyfødt)"
        30 = "30: Helsehjelp startet ved annen enhet, men innen aktuelle periode Ventetid-sluttdato mindre enn mottaksdato og ventetid-sluttdato før periodeslutt"
        32 = "32: Duplikat"
        33 = "33: Rett til helsehjelp lik 6 (ikke aktuell for rettighetsvurd) eller utfall av vurdering lik 7 (opplæring/kurs/attester/rådgivn)"
        ;

    value HENV_TYPE
         1 = "1: Utredning"
         2 = "2: Behandling"
         3 = "3: Kontroll"
         4 = "4: Generert for Ø-hjelpspasient"
         5 = "5: Friskt nyfødt barn"
         6 = "6: Graviditet"
         7 = "7: Opplæring, kurs, attester og rådgivning"
         8 = "8: Utredning eller behandling (def fra HSØ), (eller Rehablitering (fra Johan / HDir)?)"
        10 = "10: Utredning/behandling"
        11 = "11: Råd til henviser"
        99 = "99: Øvrige henvisninger"
        ;

		value omsorgsniva
		1 = '1: Døgnopphold'  
      2 = '2: Dagbehandling'  
      3 = '3: Poliklinikk'  
      8 = '8: Poliklinisk kontakt for inneliggende pasient - for stråleterapi';

run;