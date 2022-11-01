/* Opprettet 27.11.2019 - Frank Olsen
Hentet fra Beate Hauglann*/

/*Metastase - koder fra 'Dokumentasjon av Kreftregisterets variabler'*/

proc format;
value $metastase_fmt
'0' = 'Ingen direkte innvekst i omliggende vev/organ, lymfeknutemetastase eller organmetastase. Metastase innen samme organ som primærsvulsts utgangspunkt'
'A' = 'Regionale lymfeknutemetastaser (klinisk eller histologisk)'
'B' = 'Fjerne lymfeknutemetastaser eller organmetastaser' 
'C' = 'Metastase påvist, men ukjent hvor' 
'D' = 'Direkte innvekst i omliggende vev eller organ' 
'9' = 'Ukjent utbredelse på diagnosetidspunktet'

/*'0' = 'Ingen direkte innvekst i omliggende vev/organ, lymfeknutemetastase eller organmetastase. Metastase innen samme organ som primærsvulstens utgangspunkt' */
'1' = 'Lymfeknutemetastase til samme kroppsavsnitt'
'2' = 'Lymfeknutemetastase utenfor samme kroppsavsnitt'
'3' = 'Organmetastase til samme kroppsavsnitt'
'4' = 'Organmetastase utenfor samme kroppsavsnitt'
'5' = 'Mikroskopisk innvekst i nabostruktur'
'6' = 'Makroskopisk innvekst i nabostruktur' /*(alle typer undersøkelsesmetodikk)*/
'7' = 'Metastase påvist, men ukjent hvor'
'8' = 'Mikroinvasiv vekst, karsinom med begynnende infiltrasjon';
/*'9' = 'Ukjent utbredelse på diagnosetidspunktet';*/
run;




proc format;
value Stadium_gr_omk
1='Lokalisert'
2='Regional spredning'
3='Fjernmetastaser'
9='Annet/ukjent';
run;