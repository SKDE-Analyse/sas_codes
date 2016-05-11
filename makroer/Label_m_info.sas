%macro Label_m_info(inn_data=, Label_variabel=, Info_variabel=, Info_variabel_tekst= );

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