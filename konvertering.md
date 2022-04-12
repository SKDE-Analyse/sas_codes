
# Dokumentasjon for filen *tilrettelegging/npr/2_tilrettelegging/konvertering.sas*


MACRO FOR KONVERTERING AV STRINGER TIL NUMERISK, DATO OG TID

### Innhold
0. Fjerner (dropper) variabler som vi ikke trenger. 
1. Omkoding av stringer med tall til numeriske variable.
2. Konvertering av stringer til dato- og tidsvariable
3. Fjerner blanke felt og punktum i stringvariable, samt ny navngiving
4. Lager Hdiag / Bdiag
### Omkoding av stringer med tall til numeriske variable
- Lager `pid` fra `LNr` (løpenummer) og sletter `LNr`
- Generere `bydel_org` fra `bydel` og `bydel2_org` fra `bydel2`. Dropper så `bydel` slik at den ikke ligger på fila når ny variabel kalt `bydel` skal genereres i neste makro
### Konvertering av stringer til dato- og tidsvariable
###	Fjerner blanke felt og punktum i stringvariable, samt ny navngiving. For 2014 navnes dup_tilstand til Tdiag.
- Fjerner blanke felt i DRG-koden og justerer til stor bokstav (upcase)
- Fjerner punktum, space, og komma i diagnosekoder. (OUS har rapportert enkelte diagnosekoder med punktum, eks. `C50.9`) Navner om til hdiag/bdiag.
- Fjerner blanke felt i prosedyrevariable, og fjerner underscore (_) i variabelnavn
	- Fjerner blanke felt i takstvariable, og navner om til Normaltariff1-15
