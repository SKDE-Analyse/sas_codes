   
    array diag {*} Hdiag: Bdiag: Tdiag:;
         do i=1 to dim(diag);
    
        if substr(diag{i},1,1) in ('C') then Kreft_d=1; 
        if substr(diag{i},1,4) in ('D060','D061','D067','D069','D070','D071','D072','D073') then Kreft_d=1; 

        if substr(diag{i},1,3) = 'N92' then blod_diag=1;
        if substr(diag{i},1,3) = 'D25' then myom_diag=1;

    end;
    
    /*Prosedyrekode for livmorkirurgi (hysterektomi)*/
    array pros {*} NC:;
        do i=1 to dim(pros);
     
        if pros{i} in ('LCD00','LCD30','LCD96','LCC10') then Hysterektomi_Aapen_p=1;
        if pros{i} in ('LCD10','LCD40','LEF13','LCC20') then Hysterektomi_Vaginal_p=1;
        if pros{i} in ('LCD01','LCD04','LCD11','LCD31','LCD97','LCC11') then Hysterektomi_Lap_p=1;
        if pros{i} in ('ZXC96') then RobotAssKirurgi=1;
    end;
    
    /*Utelukke diagnose (kreft) ved prosedyre for hysterektomi(åpen, vaginal og laparaskopisk), samt slå sammmen alt*/
        if Kreft_d ne 1 and Hysterektomi_Aapen_p= 1 then Hyster_Aapen_dp=1;
        else if Kreft_d ne 1  and Hysterektomi_Vaginal_p= 1 then Hyster_Vaginal_dp=1;
        else if Kreft_d ne 1  and Hysterektomi_Lap_p= 1 then Hyster_Lap_dp=1;
        
        if Hyster_Aapen_dp= 1 or Hyster_Vaginal_dp= 1 or Hyster_Lap_dp= 1 then Hysterektomi_dp=1;
    
        if hysterektomi_dp=1 then do;
         
            /*Lager variabler for å dele opp i ulike grupper ut fra hdiag - brukt i gynekologiatlas*/
            if hdiag3tegn='D25' then hyst_myom_dp=1;
            if hdiag3tegn='N92' then hyst_blod_dp=1;
            if hyst_myom_dp ne 1 and hyst_blod_dp ne 1 then hyst_annen_dp=1;
    
            /*Lager variabler for å dele opp i grupper etter diagnose (ikke kun hdiag) */
            if blod_diag eq 1 and myom_diag ne 1 then hyst_n92=1;
            if blod_diag eq 1 and myom_diag eq 1 then hyst_n92d25=1;
            if blod_diag ne 1 and myom_diag eq 1 then hyst_d25=1;
            if blod_diag ne 1 and myom_diag ne 1 then hyst_andre=1;

            /*Variabler for å skille ut robotkirurgi */
            if RobotAssKirurgi= 1 and Hyster_Lap_dp=1 then hyster_robot_dp=1; 
            else hyster_ikkerobot_dp=1;
    
         end;