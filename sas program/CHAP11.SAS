 /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 11: Further Issues in OLS With Time Series Data
 *****************************************************************/
 /*  Jan 1976-march 1989 Obs:   691*/
data mylib.nyse;
infile 'c:\hong\teach\wooldridge\data\NYSE.RAW';
input price     return    return_1     t     price_1   price_2   cprice    
cprice_1;
run;
title1 'Example 11.4: AR model';
title2 'OLS when weakly dependent';
proc model data=mylib.nyse;
return=a0+a1*return_1;
fit return/ols;
run;
title2 'ARIMA YW';
proc arima data=mylib.nyse;
identify var=return nlag=2;
estimate p=1;
estimate p=2;
run;

title1 'Highly persistent or strongly
dependent series';
title2 'Integration test';


proc model data=mylib.fertil3;
gfr=a+a1*gfr_1; 
pe=b+b1*pe_1;
fit gfr/ols;
fit pe/ols;
run;
title2 'Differencing';
proc model data=mylib.fertil3;
cgfr=b+b1*cpe;
fit cgfr/ols;
run;
proc model data=mylib.fertil3;
cgfr=b+b1*cpe+b2*dif(cpe)+b3*dif2(cpe);
fit cgfr/ols;
run;

/*SAS Macro in SAS/ETS*/
 /*Finite Distributed Lag (FDL) model*/
 /*%PDL ( pdlname, nlags, degree, 
 R=code, OUTEST=dataset )*/
/*
 proc model data=in list; 
      parms int pz; 
      %pdl(xpdl,5,2); /*First declare*/
      y = int + pz * z + %pdl(xpdl,x);  /*Then call*/
      %ar(y,2,M=ULS); 
      id i; 
   fit y / out=model1 outresid converge=1e-6; 
   run;

 /*AR(2) Model. You would write this 
 model as follows: */
   proc model data=in; 
      parms a b p1 p2; 
      y = a + b * x1 + p1 * zlag1(y - (a + b * x1)) +  
            p2 * zlag2(y - (a + b * x1)); 
      fit y; 
   run;

/*or equivalently using the %AR macro as */

   proc model data=in; 
      parms a b; 
      y = a + b * x1; 
      %ar( y, 2 ); 
      fit y; 
   run;
%DFTEST (in , y );

*/


  






