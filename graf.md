
# Dokumentasjon for filen *rateprogram/graf.sas*

# One %graf() to rule them all!

Den viktigste delen av %graf() er de fire variablene bars, lines, table og variation. For alle disse variablene kan
man sende inn en eller flere variabler, fra ett eller flere datasett/tabeller, fra ett eller flere bibliotek/library.
%graf() vil da legge sammen disse variablene en etter en, i kronologisk rekkefølge, og lage et n-delt søylediagram
(hvis man bruker bars=), en tabell med n kolonner (hvis man bruker table=), et linjediagram med n linjer (hvis man
bruker lines=), eller prikker og linjer for årsvariasjon (hvis man bruker variation=).

Man kan bruke alle disse 4 graf-typene samtidig, slik at man kan lage et 3-delt søylediagram med en tabell med 2
kolonner, samt et linjediagram på toppen av alt det, for eksempel. Man kan også spesifisere hvilket format disse variablene
skal ha, og en label for variablene slik at de får en beskrivelse i output-grafen.

## Definisjon av <dataspecifier>

Bars, lines, table og variation tar alle en <dataspecifier> som input, som defineres slik:

```
<dataspecifier>: (<library>.)<datasets>/<variables>(/<format-1> ... <format-n>) (+ <dataspecifier>) (#<label-1> ... #<label-n>)
```

Det som er i parentes er valgfritt, så man trenger egentlig bare <datasets>/<variables>. Både <datasets> og <variables> er hva
SAS kaller for Variable Lists, og er derfor veldig fleksible.

## Eksempler

Den beste måten å lære hvordan man bruker %graf() på er med eksempler; jeg har derfor laget flere eksempler nedenfor.

### Enkelt søylediagram

Hvis man vil laget et helt enkelt søylediagram uten noe visvas, spesifiserer man helt enkelt et datasett og en variabel slik som dette:

```sas
%graf(bars=datasett/Ratesnitt,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example1.png)

Man må alltid spesifisere en kategorivariabel (category=) når man bruker %graf(), og denne variabelen må være den samme
for alle datasett man sender inn i makroen. Man kan også velge å formatere kategorivariabelen; i eksempelet ovenfor er
kategorivariabelen bohf, og formatet til bohf er "bohf_fmt.".

### Todelt søylediagram

Hva gjør man hvis man vil lage et todelt søylediagram med to variabler (Ratesnitt1 og Ratesnitt2) i datasettet? Det gjør man slik:

```sas
%graf(bars=datasett/Ratesnitt1 Ratesnitt2,
      category=bohf/bohf_fmt.
)
```
![img](/sas_codes/bilder/graf_example2.png)

Den totale verdien av den sammensatte søyla er summen av alle variablene (i dette tilfellet Ratesnitt1 + Ratesnitt2).

### Todelt søylediagram med data fra to forskjellige datasett

Hva hvis man har to forskjellige datasett (datasett1 og datasett2) med samme variabel (Ratesnitt), og man vil lage et todelt
søylediagram med de? Det er bare en liten forandring i koden som må til:

```sas
%graf(bars=datasett1 datasett2/Ratesnitt,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example3.png)

I eksempelet ovenfor vil datasett1/Ratesnitt bli den første søyla, og datasett2/Ratesnitt vil bli den andre. Hvis man har
både mer en ett datasett og mer enn en variabel, vil alle mulige kombinasjoner av de to listene bli sin egen søyle
(i den mest logiske rekkefølgen).

### Tabell og format

Hva gjør man hvis man har lyst til å legge til en tabell med 3 kolonner på høyre side? Det er en lett sak:

```sas
%graf(bars=datasett1 datasett2/Ratesnitt,
      table=datasett3/tabvar1-tabvar3,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example4.png)

"tabvar1-tabvar3" er en Variable List, så %graf() forstår at man vil ma med de tre variablene tabvar1, tabvar2 og tabvar3. Hva
hvis vil bruke et format på disse tabellvariablene? Det gjør man slik:

```sas
%graf(bars=datasett1 datasett2/Ratesnitt,
      table=datasett3/tabvar1-tabvar3/comma10.1 . dollar10.,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example5.png)

I eksempelet ovenfor blir tabvar1 formatert med comma10.1, tabvar2 blir uendret siden det bare var et punktum, og tabvar3
blir formatert med dollar10.2. %graf() leser alle formatene fra venstre til høyre og bruker de på de respektive variablene.
Det er derfor tabvar2 bare får et punktum i eksempelet; vi er egentlig bare interessert i å formatere tabvar3, så vi bruker
et punktum for å "hoppe over" tabvar2 uten å endre formatet.

### Label

Hva hvis vi også har lyst til å gi tabvar2 og tabvar3 (ikke tabvar1) en label, altså en kort beskrivelse av kolonnen i
tabellen? Det gjør man helt på slutten med å bruke emneknagg (#). La oss i samme slengen gi en kort beskrivelse av de
to søylene i den todelte grafen:

```sas
%graf(bars=datasett1 datasett2/Ratesnitt #Offentlig #Privat,
      table=datasett3/tabvar1-tabvar3/comma10.1 . dollar10.2 #. #Uformatert tabellvariabel #"Dette, er tekst",
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example6.png)
   
Det er to ting som er verdt å notere seg med eksempelet ovenfor:
   1) På samme måte som vi "hoppet over" formatet til tabvar2 med et punktum, "hopper vi over" tabvar1 med å bruke "#.".
      Dette er fordi vi bare har lyst til å gi en label til tabvar2 og tabvar3.
   2) Teksten til tabvar3 inneholder et komma, og må derfor være i anførselstegn.

### Plusse sammen <dataspecifier>s

Av og til vil det ikke være mulig å bruke en enkelt <dataspecifier> slik som ovenfor. Det man kan gjøre da er simpelten
å "plusse" sammen flere <dataspecifier>s slik som dette:

```sas
%graf(bars=datasett1/Ratesnitt1 + datasett2/Ratesnitt2 #Offentlig #Privat,
      lines=datasett1/Ratesnitt4 #En linje på toppen av søylediagrammet,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example7.png)

Resultatet av det vil være en todeltelt graf; den første søyla vil være datasett1/Ratesnitt1, den andre søyla datasett2/Ratensnitt2.
Det var nødvendig å "plusse" i dette tilfellet både fordi variablene (Ratesnitt1 og Ratesnitt2) er ulike i de to datasettene. Det
vil også være nødvendig å "plusse" hvis man kombinerer datasett fra forskjellige SAS-bibliotek. I eksempelet ovenfor la jeg også
til en linje på toppen av søylediagrammet med en egen label, noe som er veldig enkelt, og jeg la i tillegg til en beskrivelse av
grafen (description=).

### Avansert eksempel (lagring av bilde, logo og kilde, etc.)

La oss se på et mer avansert eksempel hvor vi vrir grafen 90 grader (direction=vertical), legger til logo og kildehenvisning,
og lagrer bildet som en .png fil. La oss i tillegg endre på special_categories for å si at helseforetakene i Helse Nord skal
bli grå, i stedet for Norge. På toppen av alt det gjør vi grafen mye større med width= og height=:

```sas
%let lagreplass=/sas_smb/skde_analyse/Brukere/Skybert/bilder;

%graf(bars=datasett1/Ratesnitt1 + datasett2/Ratesnitt2 #Offentlig #Privat,
      lines=datasett1/Ratesnitt4 #En linje på toppen av søylediagrammet,
      table=datasett3/tabvar1/10. #Tall:,
      direction=vertical,
      category=bohf/bohf_fmt.,
      special_categories=1 2 3 4,
      width=1500, height=800,
      logo=skde,
      source=Kilde: HELFO,
      save="&lagreplass/bildenavn.png"
)
```

![img](/sas_codes/bilder/graf_example8.png)

### Årsvariasjon

En graf med årsvariasjon lager man enkelt med å legge til en <dataspecifier> for variation=, slik som dette:

```sas
%graf(bars=datasett/Ratesnitt,
      variation=datasett/rate2020-rate2022,
      category=bohf/bohf_fmt.
)
```

![img](/sas_codes/bilder/graf_example9.png)

Når variabel-navnene har format rate<yyyy> slik som i dette eksempelet forstår %graf at vi vil bruke årstallet i varabelnavnet
som en label. Man kan overstyre dette med å sende inn sin egen label med #<label>.

### bar_grouping=cluster (of forskjellen med det og bar_grouping=stack)

Hvis man istedenfor å lage et n-delt søylediagram vil lage en liten søyle for hver variabel man sender inn, kan man
gjøre det slik:

```sas
%graf(bars=test_shorter/Ratesnitt1-Ratesnitt3 #Offentlig #Privat #Noe annet?,
      direction=vertical, bar_grouping=cluster,
      category=borhf/borhf_fmt.
)
```

![img](/sas_codes/bilder/graf_example10.png)

I dette eksempelet er grafen snudd i vertikal retning (fordi det ser litt bedre ut), og kategorien er i dette tilfellet
rorhf (istedenfor bohf). Hvis man ikke hadde satt bar_grouping=cluster ville grafen sett slik ut:

![img](/sas_codes/bilder/graf_example11.png)

### panelby

Hvis man har data for mange små minigrafer i et datasett, og hver av disse minigrafene har sin egen verdi av en variabel
som skiller den fra de andre grafene, kan man bruke denne variabelen med panelby= slik som dette:

```sas
%graf(bars=panel_test/ratesnitt1-ratesnitt2 #Offentlig #Privat,
      lines=panel_test/ratesnitt1 #"En linje, hvorfor ikke",
      table=panel_test/tabvar1/10. #Info,
      category=borhf/borhf_fmt.,
      panelby=panel,
      logo=skde
)
```

![img](/sas_codes/bilder/graf_example12.png)

I dette tilfellet vil ikke %graf() blande seg inn i rekkefølgen på dataene, så input-datasettet må være ferdig sortert
i den rekkefølgen man vil ha det. Man kan bruke panelby= i kombinasjon med bars=, lines=, table= og variation=.

### Endre utseendet

Det er ganske mange variabler for å endre på utseendet til grafen. For eksempel kan man bruke variablene bar_colors
og special_bar_colors for å endre utseendet til søylediagrammet:

```sas
%graf(bars=datasett/Ratesnitt1-Ratesnitt2,
      category=bohf/bohf_fmt.,
      bar_colors=darkred pink, special_bar_colors=green CXC0FF81 
)
```

![img](/sas_codes/bilder/graf_example13.png)


## Makro `assert`


## Makro `assert_member`


## Makro `expand_varlist`


## Makro `remove_quotes`


## Makro `parse_dataspecifier`


## Makro `parse_dataspecifiers`

