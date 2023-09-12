%macro kpr_min_maks_dato;
    title color=darkblue height=5 '3a: enkeltregning fila min og maks: år og dato';
    proc sql;  
    select 	min(aar) 					as minaar, 
            max(aar) 					as maxaar, 
            min(dato) 				as mindato format yymmdd10., 
            max(dato) 				as maxdato format yymmdd10.
    from &inn;
    quit;
    
    title color=darkblue height=5 '3b: takst fila min og maks år';
    proc sql;  
    select 	min(aar) 					as minaar, 
            max(aar) 					as maxaar
    from &inn_takst;
    quit;

    title color=darkblue height=5 '3c: diagnose fila min og maks år';
    proc sql;  
    select 	min(aar) 					as minaar, 
            max(aar) 					as maxaar
    from &inn_diag;
    quit;
    
   
%mend kpr_min_maks_dato;
    
    