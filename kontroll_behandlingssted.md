
# Dokumentasjon for filen *tilrettelegging/npr/1_kontroll_foer_tilrette/kontroll_behandlingssted.sas*

### Beskrivelse

Makro for å kontrollere om variabel 'behandlingsstedkode' eller 'behandlingssted2' i somatikk-data og 'institusjonid' i avtspes-data har en kjent verdi.
Kontrollen gjennomføres ved at mottatte verdier sjekkes mot CSV-filer som inneholder organisasjonsnummer for somatikk-data og reshid for avtalespesialist-data. 

Ukjente verdier (fra datasettet error_liste_'aar') kontrolleres mot brønnøysundregisteret eller reshid-registeret.
Hvis verdien i error_listen er et gyldig organisasjonsnummer eller reshid så skal CSV-fil oppdateres.
Hvis ikke korrigeres ugyldig verdi i tilretteleggingen steg 2.

Eksempel på bruk:
Somatikk:           %kontroll_behandlingssted(inndata=hnmot.SOM_2022_M22T1, aar=2022);
Avtalespesialist:   %kontroll_behandlingssted(inndata=HNMOT.ASPES_2022_M22T1, aar=2022,beh=institusjonid , sektor=avtspes);


### Input 
- inndata: Filen med behandlingssted-variabel som skal kontrolleres, f.eks hnmot.m20t3_som_2020.
- aar: Brukes for å gi unike navn til output-errorfiler.
- beh: Organisasjonsnummer eller reshid som skal kontrolleres, default er 'behandlingsstedkode' for RHF-data. Hvis kontroll av SKDE-data endres det til 'behandlingssted2', eller ved kontroll av reshid i avtalespesialist-data endres det til 'institusjonid'.
- sektor: Default er 'som' for somatikk-data, det velges 'aspes' hvis avtalespesialist-data. 

### Output 
- ett datasett
 - error_liste_'aar': mottatte verdier fra kontrollert variabel som ikke gjenfinnes i CSV-filen. 
- resultat fra proc freq
 - viser andel av radene med gyldig og ugyldig verdi av kontrollert variabel.

### Endringslogg
- 2020 Opprettet av Janice og Tove
- September 2021, Tove, dokumentasjon markdown
