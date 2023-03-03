
# Dokumentasjon for filen *tilrettelegging/npr/1_kontroll_foer_tilrette/kontroll_behandlingssted.sas*

### Beskrivelse

Makro for å kontrollere om variabel 'behandlingsstedkode' eller 'behandlingssted2' i somatikk-data og 'institusjonid' i avtspes-data har en kjent verdi.
Kontrollen gjennomføres ved at mottatte verdier sjekkes mot CSV-filer som inneholder organisasjonsnummer for somatikk-data og reshid for avtalespesialist-data. 

Ugyldige/ukjente verdier printes ut kontrolleres mot brønnøysundregisteret eller reshid-registeret.
Hvis verdien i error_listen er et gyldig organisasjonsnummer eller reshid så skal CSV-fil oppdateres.
Hvis ugyldig verdi gjør evnt manuell korrigering før tilrettelegging kjøres, f.eks erstatte ugyldig behandlingsstedkode med institusjonid.

Eksempel på bruk:
Somatikk:           %kontroll_behandlingssted(inndata=hnmot.SOM_2022_M22T1, aar=2022);
Avtalespesialist:   %kontroll_behandlingssted(inndata=HNMOT.ASPES_2022_M22T1, aar=2022,beh=institusjonid , sektor=avtspes);


### Input 
- inndata: Filen med behandlingssted-variabel som skal kontrolleres, f.eks hnmot.m20t3_som_2020.
- beh: Organisasjonsnummer eller reshid som skal kontrolleres, default er 'behandlingsstedkode' for RHF-data. Hvis kontroll av SKDE-data endres det til 'behandlingssted2', eller ved kontroll av reshid i avtalespesialist-data endres det til 'institusjonid'.

### Output 
- printes i result viewer

### Endringslogg
- 2020 Opprettet av Janice og Tove
- September 2021, Tove, dokumentasjon markdown
- Mars 2023, Tove, endret output
