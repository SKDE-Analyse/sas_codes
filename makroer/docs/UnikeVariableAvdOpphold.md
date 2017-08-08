[Ta meg tilbake.](./)


# UnikeVariableAvdOpphold

Unike variabler avd opphold Makro - Opprettet 24/2-16 av Frank Olsen
For å finne unike prosedyrer/diagnoser o.l. pr pasient pr sykehusopphold i avdelingsoppholdsfila
UnikeVariableAvdOpphold(variabler=, dsn=, prefix=, extrawhere=)
Parametre:
1. variabler: variablene man utfører analysen på, feks nc: eller ncsp: eller hdiag:
2. dsn: datasettnavn - datasettet man utfører analysen på
3. prefix: Prefix på variablene som telles/lages
4. extrawhere: dersom man ønsker noe mer i where-statement, feks alder in (50:60),
extrawhere må starte med and
Eksempel: UnikeVariableAvdOpphold(variabler=ncsp:, dsn=tarzan2014_avd, prefix=ncsp_pros, extrawhere=and alder in (10:15))
Det lages et nytt datasett med pid, AgrshoppId, de nye variablene og en antallsvariabel som teller antall pr avdelingsopphold
Dette datasettet kan merges med sykehusoppholdsfila
