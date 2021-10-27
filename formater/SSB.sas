Proc format;
/*NUS Niv� - f�rste siffer i NUS-koden*/
value nus1_9niva_fmt
0='Ingen utdanning og f�rskoleutdanning Under skoleplikt'
1='Barneskoleutdanning 1.-7. klassetrinn'
2='Ungdomsskoleutdanning 8-10. klassetrinn'
3='Videreg�ende, grunnutdanning 11.-12. klassetrinn'
4='Videreg�ende, avsluttende utdanning 13. klassetrinn +'
5='P�bygging til videreg�ende utdanning 14. klassetrinn +'
6='Universitets- og h�gskoleutdanning, lavere niv� 14. -17. klassetrinn'
7='Universitets- og h�gskoleutdanning, h�yere niv� 18.-19. klassetrinn'
8='Forskerutdanning 20. klassetrinn +'
9='Uoppgitt';
value nus1_9niva_kort_fmt
0='Ingen utdanning og f�rskoleutdanning'
1='Barneskoleutdanning'
2='Ungdomsskoleutdanning'
3='Videreg�ende, grunnutdanning'
4='Videreg�ende, avsluttende utdanning'
5='P�bygging til videreg�ende utdanning'
6='Universitets- og h�gskoleutdanning, lavere niv�'
7='Universitets- og h�gskoleutdanning, h�yere niv�'
8='Forskerutdanning'
9='Uoppgitt';
value nus1_3niva_mlf  (multilabel notsorted) 
0='Under skoleplikt'
1-2='Obligatorisk utdanning'
3-5='Mellomutdanning'
6-8='Universitets- og h�gskoleutdanning'
9='Uoppgitt';
value nus1_3niva_fmt 
0='Under skoleplikt'
1='Obligatorisk utdanning'
2='Mellomutdanning'
3='Universitets- og h�gskoleutdanning'
9='Uoppgitt';
/*NUS Fagfelt - andre siffer i NUS-koden*/
value nus2_9fag_fmt
0='Allmenne fag'
1='Humanistiske og estetiske fag'
2='L�rerutdanninger og utdanninger i pedagogikk'
3='Samfunnsfag og juridiske fag'
4='�konomiske og administrative fag'
5='Naturvitenskapelige fag, h�ndverksfag og tekniske fag'
6='Helse-, sosial- og idrettsfag'
7='Prim�rn�ringsfag'
8='Samferdsels- og sikkerhetsfag og andre servicefag'
9='Uoppgitt fagfelt';
value sivilstatus_fmt
1='Ugift'	
2='Gift'	
3='Samboer'
4='Skilt/separert'	
5='Enke/enkemann';
/* TS: Tettsted st�rrelse https://www.ssb.no/a/metadata/codelist/datadok/1078075/no */
value ts_stor_fmt
11='<= 199 bosatte (Ikke tettsted)'	
12='Tettsted med 200 - 499 bosatte'	
13='Tettsted med 500 - 999 bosatte'	
14='Tettsted med 1 000 - 1 999 bosatte'	
15='Tettsted med 2 000 - 19 999 bosatte'	
16='Tettsted med 20 000 - 99 999 bosatte'	
17='Tettsted med 100 000 eller flere bosatte'	
99='Uoppgitt';
 /* TS: https://www.ssb.no/a/metadata/codelist/datadok/1517386/no - dette m� sjekkes ytterligere */
/* value ts_kode_fmt
s='person ikke bosatt i tettsted'	
t='person bosatt i tettsted'	
u='person uplassert p� tett/spredt, pga manglende koordinat'; */
value ts_kode_num_fmt
1='person ikke bosatt i tettsted'	
2='person bosatt i tettsted'	
3='person uplassert p� tett/spredt, pga manglende koordinat';
value hushold_type				
111 = 'Aleneboende under 30 �r'
112 = 'Aleneboende 30-44 �r'				
113 = 'Aleneboende 45-66 �r'				
114 = 'Aleneboende 67 �r og over'							
121 = 'Par uten barn, eldste person under 30 �r'			
122 = 'Par uten barn, eldste person 30-44 �r'				
123 = 'Par uten barn, eldste person 45-66 �r'				
124 = 'Par uten barn, eldste person 67 �r og over'								
131 ='Gifte par med sm� barn (yngste barn 0-5 �r)'				
132 = 'Samboerpar med sm� barn (yngste barn 0-5 �r)'								
141 = 'Gifte par med store barn (yngste barn 6-17 �r)'				
142 = 'Samboerpar med store barn (yngste barn 6-17 �r)'							
151 = 'Mor med sm� barn (yngste barn 0-5 �r)'				
152 = 'Far med sm� barn (yngste barn 0-5 �r)'								
161 = 'Mor med store barn (yngste barn 6-17 �r)'				
162 = 'Far med store barn (yngste barn 6-17 �r)'								
171 = 'Gifte par med voksne barn (yngste barn 18 �r og over)'				
172 = 'Samboerpar med voksne barn (yngste barn 18 �r og over)'				
173 = 'Mor med voksne barn (yngste barn 18 �r og over)'				
174 = 'Far med voksne barn (yngste barn 18 �r og over)'												
211 = 'Husholdninger med to eller flere enpersonfamilier'				
212 = 'Andre flerfamiliehusholdninger uten barn 0-17 �r'								
220 = 'Flerfamiliehusholdninger med sm� barn (yngste barn under 0-5 �r)'								
230 = 'Flerfamiliehusholdninger med store barn (yngste barn 6-17 �r)';
run;