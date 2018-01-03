/*!------------------------------------------------------------------------------------------------
- Opprettet 28/11-17 - Frank Olsen
- Redigert 30/11-17 - Frank olsen

```
%CoMorbIndex(dsn_index=,dsn_alle=,periode=365,alle=1);
```

### Variable:

1. `dsn_index` - datasett med indexopphold
2. `dsn_alle` - datasett med alle opphold (d�gn, dag og poli) for alle aktuelle pasienter
3. `periode` - hvor mange dager bakover vi leter (standard er 365 dager)
4. `alle` - lik 1 --> leter i b�de hoved- og bi-diagnoser (default), ulik 1 --> let kun i hdiag

Makroen produserer tre komorbiditetsindekser:
1. `CCI` - Charlson - kan endres ved � endre vekting
2. `PRI` - Pasient Register Index - kan endres ved � endre vekting
3. `CoMorb` - egendefinert index - kan endres ved � endre vekting

Diagnosekoder er hentet fra *Quan 2005*, Vekting er hentet fra *Nilssen 2014*
-------------------------------------------------------------------------------------------------*/
%macro CoMorbIndex(dsn_index=,dsn_alle=,periode=365,alle=1);
data &dsn_index;
set &dsn_index (rename=(Inndato=Inn_index));
drop cci pri comorb;
run;

data comorb (keep=pid inndato hdiag hdiag2 bdiag:);
set &dsn_alle;
run;

data comorb;
set comorb;
tmp_1=0; tmp_2=0; tmp_3=0; tmp_4=0; tmp_5=0; tmp_6=0; tmp_6=0; tmp_7=0; tmp_8=0;
tmp_9=0; tmp_10=0; tmp_11=0; tmp_12=0; tmp_13=0; tmp_14=0; tmp_15=0; tmp_16=0; tmp_17=0;
array diagnose {21} hdiag hdiag2 bdiag:;
%if &alle=1 %then %do;
do i=1 to 21;
	if substr(diagnose{i},1,3) in ("I21","I22")  
		or substr(diagnose{i},1,4) in ("I252") then tmp_1=1;
	if substr(diagnose{i},1,3) in ("I43","I50")  
		or substr(diagnose{i},1,4) in ("I099","I110","I130","I132","I125","I420","I425","I426","I427","I428","I429","P290") then tmp_2=1;
	if substr(diagnose{i},1,3) in ("I70","I71")  
		or substr(diagnose{i},1,4) in ("I731","I738","I739","I771","I790","I792","K551","K558","K559","Z958","Z959") then tmp_3=1;
	if substr(diagnose{i},1,3) in ("G45","G46","I60","I61","I62","I63","I64","I65","I66","I67","I68","I69")  
		or substr(diagnose{i},1,4) in ("H340") then tmp_4=1;
	if substr(diagnose{i},1,3) in ("F00","F01","F02","F03","G30")  
		or substr(diagnose{i},1,4) in ("F051","G311") then tmp_5=1;
	if substr(diagnose{i},1,3) in ("J40","J41","J42","J43","J44","J45","J46","J60","J61","J62","J63","J64","J65","J66","J67")  
		or substr(diagnose{i},1,4) in ("I278","I279","J684","J701","J703") then tmp_6=1;
	if substr(diagnose{i},1,3) in ("M05","M06","M32","M33","M34")  
		or substr(diagnose{i},1,4) in ("M315","M351","M353","M360") then tmp_7=1;
	if substr(diagnose{i},1,3) in ("B18","K73","K74")  
		or substr(diagnose{i},1,4) in ("K700","K701","K702","K703","K709","K713","K714","K715","K717","K760","K762","K763","K764","K768","K769","Z944") then tmp_9=1;
	if substr(diagnose{i},1,3) in ("G81","G82")  
		or substr(diagnose{i},1,4) in ("G041","G114","G801","G802","G830","G831","G832","G834","G839") then tmp_12=1;
	if substr(diagnose{i},1,3) in ("N18","N19")  
		or substr(diagnose{i},1,4) in ("I120","I131","N032","N033","N034","N035","N036","N037","N052","N053","N054","N055","N056","N057","N250","Z490","Z491","Z492","Z940","Z992") then tmp_13=1;
	if substr(diagnose{i},1,3) in ("K25","K26","K27","K28") then tmp_8=1;
	if substr(diagnose{i},1,4) in ("E100","E101","E106","E108","E109","E110","E111","E116","E118","E119","E120","E121","E126","E128","E129","E130","E131","E136","E138","E139",
		"E140","E141","E146","E148","E149") then tmp_10=1;
	if substr(diagnose{i},1,4) in ("E102","E103","E104","E105","E107","E112","E113","E114","E115","E117","E122","E123","E124","E125","E127","E132","E133","E134","E135","E137",
		"E142","E143","E144","E145","E147") then tmp_11=1;
	if substr(diagnose{i},1,3) in ("C00","C01","C02","C03","C04","C05","C06","C07","C08","C09","C10","C11","C12","C13","C14","C15","C16","C17","C18","C19","C20","C21","C22",
		"C23","C24","C25","C26","C30","C31","C32","C33","C34","C37","C38","C39","C40","C41","C43","C45","C46","C47","C48","C49","C50","C51","C52","C53","C54","C55","C56","C57",
		"C58","C60","C61","C62","C63","C64","C65","C66","C67","C68","C69","C70","C71","C72","C73","C74","C75","C76","C81","C82","C83","C84","C84","C88","C90","C91","C92","C93",
		"C94","C95","C96","C97") then tmp_14=1;
	if substr(diagnose{i},1,4) in ("I850","I859","I864","I982","K704","K711","K721","K729","K765","K766","K767") then tmp_15=1;
	if substr(diagnose{i},1,3) in ("C77","C78","C79","C80") then tmp_16=1;
	if substr(diagnose{i},1,3) in ("B20","B21","B22","B24") then tmp_17=1;
end;
%end;
%if &alle ne 1 %then %do;
	if substr(hdiag,1,3) in ("I21","I22")  
		or substr(hdiag,1,4) in ("I252") then tmp_1=1;
	if substr(hdiag,1,3) in ("I43","I50")  
		or substr(hdiag,1,4) in ("I099","I110","I130","I132","I125","I420","I425","I426","I427","I428","I429","P290") then tmp_2=1;
	if substr(hdiag,1,3) in ("I70","I71")  
		or substr(hdiag,1,4) in ("I731","I738","I739","I771","I790","I792","K551","K558","K559","Z958","Z959") then tmp_3=1;
	if substr(hdiag,1,3) in ("G45","G46","I60","I61","I62","I63","I64","I65","I66","I67","I68","I69")  
		or substr(hdiag,1,4) in ("H340") then tmp_4=1;
	if substr(hdiag,1,3) in ("F00","F01","F02","F03","G30")  
		or substr(hdiag,1,4) in ("F051","G311") then tmp_5=1;
	if substr(hdiag,1,3) in ("J40","J41","J42","J43","J44","J45","J46","J60","J61","J62","J63","J64","J65","J66","J67")  
		or substr(hdiag,1,4) in ("I278","I279","J684","J701","J703") then tmp_6=1;
	if substr(hdiag,1,3) in ("M05","M06","M32","M33","M34")  
		or substr(hdiag,1,4) in ("M315","M351","M353","M360") then tmp_7=1;
	if substr(hdiag,1,3) in ("B18","K73","K74")  
		or substr(hdiag,1,4) in ("K700","K701","K702","K703","K709","K713","K714","K715","K717","K760","K762","K763","K764","K768","K769","Z944") then tmp_9=1;
	if substr(hdiag,1,3) in ("G81","G82")  
		or substr(hdiag,1,4) in ("G041","G114","G801","G802","G830","G831","G832","G834","G839") then tmp_12=1;
	if substr(hdiag,1,3) in ("N18","N19")  
		or substr(hdiag,1,4) in ("I120","I131","N032","N033","N034","N035","N036","N037","N052","N053","N054","N055","N056","N057","N250","Z490","Z491","Z492","Z940","Z992") then tmp_13=1;
	if substr(hdiag,1,3) in ("K25","K26","K27","K28") then tmp_8=1;
	if substr(hdiag,1,4) in ("E100","E101","E106","E108","E109","E110","E111","E116","E118","E119","E120","E121","E126","E128","E129","E130","E131","E136","E138","E139",
		"E140","E141","E146","E148","E149") then tmp_10=1;
	if substr(hdiag,1,4) in ("E102","E103","E104","E105","E107","E112","E113","E114","E115","E117","E122","E123","E124","E125","E127","E132","E133","E134","E135","E137",
		"E142","E143","E144","E145","E147") then tmp_11=1;
	if substr(hdiag,1,3) in ("C00","C01","C02","C03","C04","C05","C06","C07","C08","C09","C10","C11","C12","C13","C14","C15","C16","C17","C18","C19","C20","C21","C22",
		"C23","C24","C25","C26","C30","C31","C32","C33","C34","C37","C38","C39","C40","C41","C43","C45","C46","C47","C48","C49","C50","C51","C52","C53","C54","C55","C56","C57",
		"C58","C60","C61","C62","C63","C64","C65","C66","C67","C68","C69","C70","C71","C72","C73","C74","C75","C76","C81","C82","C83","C84","C84","C88","C90","C91","C92","C93",
		"C94","C95","C96","C97") then tmp_14=1;
	if substr(hdiag,1,4) in ("I850","I859","I864","I982","K704","K711","K721","K729","K765","K766","K767") then tmp_15=1;
	if substr(hdiag,1,3) in ("C77","C78","C79","C80") then tmp_16=1;
	if substr(hdiag,1,3) in ("B20","B21","B22","B24") then tmp_17=1;
%end;
drop i hdiag hdiag2 bdiag:;
run;

proc sql;
create table wcm as
select *
from &dsn_index A left join comorb B
on A.pid=B.pid;
quit;

data wcm;
set wcm;
if inndato>inn_index then fjern=1;
if inndato<(inn_index-&periode) then fjern=2;
run;

data wcm;
set wcm;
where fjern=.;
if inndato=inn_index then do;
tmp_1=0; tmp_2=0; tmp_3=0; tmp_4=0; tmp_5=0; tmp_6=0; tmp_6=0; tmp_7=0; tmp_8=0;
tmp_9=0; tmp_10=0; tmp_11=0; tmp_12=0; tmp_13=0; tmp_14=0; tmp_15=0; tmp_16=0; tmp_17=0;
end;
run;

proc sql;
   create table wcm as 
   select *, max(tmp_1) as c1,max(tmp_2) as c2,max(tmp_3) as c3,max(tmp_4) as c4,max(tmp_5) as c5,
   max(tmp_6) as c6,max(tmp_7) as c7,max(tmp_8) as c8,max(tmp_9) as c9,max(tmp_10) as c10,max(tmp_11) as c11,
   max(tmp_12) as c12,max(tmp_13) as c13,max(tmp_14) as c14,max(tmp_15) as c15,max(tmp_16) as c16,max(tmp_17) as c17
from wcm
   group by pid;
quit;

data wcm;
set wcm;
keep pid koblingsID inn_index c1-c17;
run;

proc sql;
   create table wcm as 
   select distinct *
   from wcm;
quit;

data wcm;
set wcm;
CCI=&CCI_vekting;
PRI=&PRI_vekting;
CoMorb=&Egen_vekting;
drop c1-c17 inn_index;
run;

proc sql;
create table &dsn_index as
select *
from &dsn_index A left join wcm B
on A.pid=B.pid and A.koblingsID=B.koblingsID;
quit;

data &dsn_index;
set &dsn_index (rename=(Inn_index=Inndato));
run;

proc datasets nolist;
delete comorb wcm;
run;
%mend CoMorbIndex;