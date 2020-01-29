Proc format;
/*NUS Nivå - første siffer i NUS-koden*/
value nus1_9niva_fmt
0='Ingen utdanning og førskoleutdanning Under skoleplikt'
1='Barneskoleutdanning 1.-7. klassetrinn'
2='Ungdomsskoleutdanning 8-10. klassetrinn'
3='Videregående, grunnutdanning 11.-12. klassetrinn'
4='Videregående, avsluttende utdanning 13. klassetrinn +'
5='Påbygging til videregående utdanning 14. klassetrinn +'
6='Universitets- og høgskoleutdanning, lavere nivå 14. -17. klassetrinn'
7='Universitets- og høgskoleutdanning, høyere nivå 18.-19. klassetrinn'
8='Forskerutdanning 20. klassetrinn +'
9='Uoppgitt';
value nus1_9niva_kort_fmt
0='Ingen utdanning og førskoleutdanning'
1='Barneskoleutdanning'
2='Ungdomsskoleutdanning'
3='Videregående, grunnutdanning'
4='Videregående, avsluttende utdanning'
5='Påbygging til videregående utdanning'
6='Universitets- og høgskoleutdanning, lavere nivå'
7='Universitets- og høgskoleutdanning, høyere nivå'
8='Forskerutdanning'
9='Uoppgitt';
value nus1_3niva_mlf  (multilabel notsorted) 
0='Under skoleplikt'
1-2='Obligatorisk utdanning'
3-5='Mellomutdanning'
6-8='Universitets- og høgskoleutdanning'
9='Uoppgitt';
value nus1_3niva_fmt 
0='Under skoleplikt'
1='Obligatorisk utdanning'
2='Mellomutdanning'
3='Universitets- og høgskoleutdanning'
9='Uoppgitt';
/*NUS Fagfelt - andre siffer i NUS-koden*/
value nus2_9fag_fmt
0='Allmenne fag'
1='Humanistiske og estetiske fag'
2='Lærerutdanninger og utdanninger i pedagogikk'
3='Samfunnsfag og juridiske fag'
4='Økonomiske og administrative fag'
5='Naturvitenskapelige fag, håndverksfag og tekniske fag'
6='Helse-, sosial- og idrettsfag'
7='Primærnæringsfag'
8='Samferdsels- og sikkerhetsfag og andre servicefag'
9='Uoppgitt fagfelt';
value sivilstatus_fmt
1='Ugift'	
2='Gift'	
3='Samboer'
4='Skilt/separert'	
5='Enke/enkemann';
/* TS: Tettsted størrelse https://www.ssb.no/a/metadata/codelist/datadok/1078075/no */
value ts_stor_fmt
11='<= 199 bosatte (Ikke tettsted)'	
12='Tettsted med 200 - 499 bosatte'	
13='Tettsted med 500 - 999 bosatte'	
14='Tettsted med 1 000 - 1 999 bosatte'	
15='Tettsted med 2 000 - 19 999 bosatte'	
16='Tettsted med 20 000 - 99 999 bosatte'	
17='Tettsted med 100 000 eller flere bosatte'	
99='Uoppgitt';
 /* TS: https://www.ssb.no/a/metadata/codelist/datadok/1517386/no - dette må sjekkes ytterligere */
/* value ts_kode_fmt
s='person ikke bosatt i tettsted'	
t='person bosatt i tettsted'	
u='person uplassert på tett/spredt, pga manglende koordinat'; */
value ts_kode_num_fmt
1='person ikke bosatt i tettsted'	
2='person bosatt i tettsted'	
3='person uplassert på tett/spredt, pga manglende koordinat';
value hushold_type				
111 = 'Aleneboende under 30 år'
112 = 'Aleneboende 30-44 år'				
113 = 'Aleneboende 45-66 år'				
114 = 'Aleneboende 67 år og over'							
121 = 'Par uten barn, eldste person under 30 år'			
122 = 'Par uten barn, eldste person 30-44 år'				
123 = 'Par uten barn, eldste person 45-66 år'				
124 = 'Par uten barn, eldste person 67 år og over'								
131 ='Gifte par med små barn (yngste barn 0-5 år)'				
132 = 'Samboerpar med små barn (yngste barn 0-5 år)'								
141 = 'Gifte par med store barn (yngste barn 6-17 år)'				
142 = 'Samboerpar med store barn (yngste barn 6-17 år)'							
151 = 'Mor med små barn (yngste barn 0-5 år)'				
152 = 'Far med små barn (yngste barn 0-5 år)'								
161 = 'Mor med store barn (yngste barn 6-17 år)'				
162 = 'Far med store barn (yngste barn 6-17 år)'								
171 = 'Gifte par med voksne barn (yngste barn 18 år og over)'				
172 = 'Samboerpar med voksne barn (yngste barn 18 år og over)'				
173 = 'Mor med voksne barn (yngste barn 18 år og over)'				
174 = 'Far med voksne barn (yngste barn 18 år og over)'												
211 = 'Husholdninger med to eller flere enpersonfamilier'				
212 = 'Andre flerfamiliehusholdninger uten barn 0-17 år'								
220 = 'Flerfamiliehusholdninger med små barn (yngste barn under 0-5 år)'								
230 = 'Flerfamiliehusholdninger med store barn (yngste barn 6-17 år)';
run;