proc format;
    value avvikl_kode
        1 = "Helsehjelp er påbegynt"
        2 = "Pasienten ønsker ikke helsehjelp"
        3 = "Pasienten er henvist til et annet sykehus/institusjon (unntatt fritt behandlingsvalg)"
        4 = "Pasienten har valgt annet sykehus/institusjon"
        5 = "Pasienten mottar helsehjelp ved annet sykehus/institusjon rekvirert av HELFO"
        7 = "Pasienten er henvist til avtalespesialist"
        9 = "Annen årsak til ventetid slutt/helsehjelp uaktuelt";

	value RAPPORTERTRETTTILHELSEHJELP
		3 = "Pasienten har rett til nødvendig helsehjelp i spesialisthelsetjenesten"
		5 = "Pasienten har ikke behov for helsehjelp i spesialisthelsetjenesten"
		6 = "Henvisningen er ikke aktuell for rettighetsvurdering";


	value AV_KODE 
		1 =	"Ja"
		2 =	"Nei";

	value fortsatt_kode 
		1 =	"Ja"
		2 =	"Nei";

	value ny_henvist
		1 =	"Ja"
		2 =	"Nei";

	value fritbrudd
		1 =	"Ja"
		2 =	"Nei";

	value SLETTE_KODE /*slette_kode må være missing å beregne avviklede, ventende, nyhenviste, aviiklede fristbrudd, ventende fristbrudd*/
		0 = "Tilhører ventelistegrunnlag" /*egentlig er missing i filene*/
		1 = "Ventetid-sluttdato satt, ventetid-sluttkode mangler"
		11 = "Ventetid-sluttdato før periodeslutt"
		3 = "Ventetid-sluttdato satt, ventetid-sluttkode mangler"
		6 = "Avdelingskode første siffer 26 (fødeavd) og fagområde lik 360, 365, 370 (rus) eller Utfall av vurdering lik 6 (graviditet)"
		9 = "Ventetid-startdato mangler"
		7 = "Ventetid-startdato er etter periodeslutt"
		10 = "Pasienten har stått over 10 år på venteliste"
		31 = "Rett til helsehjelp lik 5 (dette er avviste)"
		12 = "Ventetid 0 eller 1 dag og ventetid-slutt før periodeslutt og ventetid-sluttkode ulik 3,4,5. Eller utfall av vurdering lik 4 (ø-hjelp)"
		20 = "Vurderingsdato mangler"
		21 = "Utfall av vurdering lik 3 (kontroll)"
		22 = "Ventetid-sluttdato lik vurderingsdato og ventetid-sluttkode ulik 3,4,5"
		23 = "Medisinsk serviceavdeling (første siffer 8) og fagområde lik 360,365, 370 (rus) eller radiologiavdeling (fagområde 852)"
		24 = "Andre serviceavdelinger (første siffer 9)"
		27 = "Utfall av vurdering lik 5 (nyfødt)"
		30 = "Helsehjelp startet ved annen enhet, men innen aktuelle periode Ventetid-sluttdato mindre enn mottaksdato og ventetid-sluttdato før periodeslutt"
		32 = "Duplikat"
		33 = "Rett til helsehjelp lik 6 (ikke aktuell for rettighetsvurd) eller utfall av vurdering lik 7 (opplæring/kurs/attester/rådgivn)"
		;

run;