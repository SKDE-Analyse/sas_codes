
# Dokumentasjon for filen *makroer/expand_varlist.sas*


## Makro `expand_varlist`

    og konverteren den til en liste av variabler atskilt med mellomrom. Resultatet lagres i en
    makrovariabel med det navnet som er spesifisert i &macrovar. Eksempel:

    ```
    rate2020-rate2023 -> rate2020 rate2021 rate2022 rate2023
    abc23 abc1 abc4   -> abc23 abc1 abc4 (rekkefølgen beholdes, selv om den ikke er kronologisk)
    ```

    Etter at variabellisten er konvertert er det lettere å jobbe med den videre.
