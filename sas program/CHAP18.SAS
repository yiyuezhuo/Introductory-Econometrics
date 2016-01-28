 /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 18: Advanced Time Series Topics
 *             
 *****************************************************************/
 

data intqrt;
infile 'c:\hong\teach\wooldridge\data\INTQRT.RAW';
input r3        r6        r12       p3        p6        hy6       hy3       spr63    
hy3_1     hy6_1     spr63_1   hy6hy3_1  cr3       r3_1      chy6      chy3     
chy6_1    chy3_1    cr6       cr6_1     cr3_1     r6_1      cspr63    
;
run;


title1 'UNIT ROOT TEST - using proc ARIMA';
title2 'Example 18.2'; 
ods select StationarityTests(persist);
proc arima data=intqrt; 
  identify var=r3 stationarity=(dickey=0); 
run;  

             
proc arima data=mydata.intqrt; 
  identify var=r6 stationarity=(dickey=0); 
run; 


data phillips;
infile 'c:\hong\teach\wooldridge\data\PHILLIPS.RAW';
input year      unem      inf       unem_1    inf_1     unem_2    inf_2     cunem    
cinf      cunem_1   cinf_1;
run;

title2 'Example 18.3: Augmented Sickey-Fuller test';
proc arima data=phillips;
identify var=inf stationarity=(dickey=1); /*allowing for one lag of cinf*/
run;    

title1 '18.4 Cointegration Test';
title2 'With known cointegration parameter --I(0) process'; 
proc arima data=intqrt; 
  identify var=spr63 stationarity=(dickey=0); /*no lag*/
run; 

 /*
 proc autoreg data=intqrt; 
  model spr63= /noint stationarity=(PHILLIPS ); 
run;
 */ 
 /*These test statistics have the same limiting distributions 
   as the corresponding Dickey-Fuller tests*/

ods select all;
title2 'Example 18.5';

data fertil3;
infile 'c:\hong\teach\wooldridge\data\FERTIL3.RAW';
input gfr       pe        year      t         tsq       pe_1      pe_2      pe_3     
pe_4      pill      ww2       tcu       cgfr      cpe       cpe_1     cpe_2    
cpe_3     cpe_4     gfr_1     cgfr_1    cgfr_2    cgfr_3    cgfr_4    gfr_2;
run;

title3 'Get the residuals first';
proc autoreg data=fertil3;
model gfr=t pe ;
output out=out r=resid;
run;
title3 'DF Test of the residuals';
proc arima data=out; 
ods select StationarityTests;
identify var=resid stationarity=(dickey=1); /*allowing for one lag of change of resid*/
run;   

title3 'Example with VARMAX Cointtest'; 
proc varmax data=fertil3;                                                  
*ods trace output;
ods select TraceTestOnDrift;
model gfr pe / cointtest=(johansen=(normalize=gfr)); /*shows no cointegration*/
run;

title3;
title2 'Exmaple 18.6'; 
proc varmax data=intqrt;
model r6 r3/cointtest=(johansen=(normalize=r6)) ecm=(rank=1); 
run;
/*rank 1 with restriction case 2 confirmed. shows I(0)*/

title1 'Error Correction Models';
title2 'Exampe 18.7';
proc varmax data=intqrt;
model hy6 hy3/p=2 cointtest=(johansen=(normalize=hy6));
cointeg rank=1 exogeneity;
run;


title1 'Forecasting';
proc varmax data=phillips;     /*results different from text?*/
model unem=inf /p=1;
output out=forecast;
run;

proc print data=forecast; run;






                                                                    
