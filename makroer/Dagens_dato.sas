%macro dagens_dato;
%put ERROR- Dagens_Dato: %sysfunc(date(), date.w);
%mend dagens_dato;