%macro Label_m_info(inn_data=, Label_variabel=, Info_variabel=, Info_variabel_tekst= );

/*!
### Beskrivelse

For � legge p� f.eks n=antall obs i label for boomr�der i s�ylediagram
```
%Label_m_info(inn_data=, Label_variabel=, Info_variabel=, Info_variabel_tekst=);
```

### Parametre

1. `Inn_data`: datasett man utf�rer analysen p�
2. `Label_variabel`: Variabelen man �nsker � legge ekstra informasjon p�
3. `Info_variabel`: Variabelen som har ekstra informasjonen man �nsker � legge p�
4. `Info_variabel_tekst`: Forklaringsteksten for ekstra informasjonen

### Forfatter

Opprettet 30/11-15 av Frank Olsen
*/

data &inn_data;
set &inn_data;
string1=vvalue(&Label_variabel);
num1=" (&Info_variabel_tekst.=";
num2=&Info_variabel;
num3=")";
num=cats(num1,num2,num3);
ny_label=catx(' ',string1,num);
run;

data &inn_data;
set &inn_data;
drop string1 num1 num2 num3 num;
run;

%mend Label_m_info;