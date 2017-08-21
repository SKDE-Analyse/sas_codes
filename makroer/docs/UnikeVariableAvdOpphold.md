[Ta meg tilbake.](./)

# UnikeVariableAvdOpphold

Unike variabler avd opphold Makro - Opprettet 24/2-16 av Frank Olsen
For Ã¥ finne unike prosedyrer/diagnoser o.l. pr pasient pr sykehusopphold i avdelingsoppholdsfila
UnikeVariableAvdOpphold(variabler=, dsn=, prefix=, extrawhere=)
Parametre:
1. variabler: variablene man utfÃ¸rer analysen pÃ¥, feks nc: eller ncsp: eller hdiag:
2. dsn: datasettnavn - datasettet man utfÃ¸rer analysen pÃ¥
3. prefix: Prefix pÃ¥ variablene som telles/lages
4. extrawhere: dersom man Ã¸nsker noe mer i where-statement, feks alder in (50:60),
extrawhere mÃ¥ starte med and
Eksempel: UnikeVariableAvdOpphold(variabler=ncsp:, dsn=tarzan2014_avd, prefix=ncsp_pros, extrawhere=and alder in (10:15))
Det lages et nytt datasett med pid, AgrshoppId, de nye variablene og en antallsvariabel som teller antall pr avdelingsopphold
Dette datasettet kan merges med sykehusoppholdsfila
