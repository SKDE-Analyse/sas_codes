# Rateprogrammet

## Hvordan bruke rateprogrammet


## Beskrivelse av rateprogrammet

### Utvikling og stabile versjoner

- Branchen (mappen) 'master' er vår stabile versjon.
- For hver ny oppdatering i master oppdateres versjonnummeret.
  - Versionnummer følger, så godt det lar seg gjøre, [Semantic Versioning](semver.org) -- 1.0.0 ... 1.0.1 osv.
  - I korte trekk betyr det
    - så lenge første tall er likt, skal programmet være mulig å kjøre på samme måte som tidligere
    - hvis en endring fører til at rateprogrammet ikke kan kjøres på samme måte som tidligere, økes første tall
    - midterste tall økes hvis nye egenskaper legges inn i programmet
    - siste tall økes ved små endringer
  - Ny versjon får en tag, og eventuelt en egen mappe. Da får man kontroll på hvilke versjoner av rateprogrammet som er brukt til ulike prosjekter.
- All ny-utvikling skal skje i branchen (mappen) 'develop' eller i egen branch (mappe).
  - Kun når denne utviklingen er trygg/stabil og kvalitetssikret kan den legges i 'master'.
  - Hver branch får sin egen mappe
- All versjon-kontroll og opprettelse av nye versjoner gjøres foreløpig kun av Arnfinn.



