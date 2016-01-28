 /******************************************** ********************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 14
 *****************************************************************/

data wagepan;    /*  Obs:  4360*/
infile  "WAGEPAN.RAW" lrecl=500;
input  nr        year      black     exper     hisp      hours     
married   occ1 occ2      occ3   occ4  occ5  occ6   occ7  occ8  occ9     
educ      union     lwage    
d81       d82       d83       d84       d85      
d86       d87       expersq;
run;

 /*data used for proc model*/
data wagepan2;
set wagepan;
ed81=educ*d81;   
ed82=educ*d82; 
ed83=educ*d83; 
ed84=educ*d84; 
ed85=educ*d85;
ed86=educ*d86;
ed87=educ*d87;
run;

*ods select ParameterEstimates;

title2 "Example 14.2";  
proc tscsreg data=woo.wagepan2;
id nr year; 
model lwage= expersq married union d81-d87 
             ed81-ed87/noint fixone;
test ed81-ed87=0;              
run;

title2 'Example 14.4';
title3 'Random effects';
proc tscsreg data=woo.wagepan;
model lwage=educ black hisp exper expersq  married union
             d81-d87/ranone;
id nr year;
run;
proc print data=est1; run;
title3 'Fixed effects';
proc tscsreg data=woo.wagepan;
model lwage=  expersq married union d81-d87/fixone noint;
run;
proc print data=est2; run;   

title3 "Extras";
 /***** two-way random fixed effects models****************/
proc tscsreg data=wagepan noprint outest=est3;
model lwage=  expersq married union
/rantwo fixtwo noint;
id nr year;
run;
proc print data=est3; run;   

proc model data=woo.wagepan;
lwage=b0+b1*educ+b2*black+b3*hisp+b4*exper+b5*expersq+b6*married+b7*union+b8*d81
+b9*d82+b10*d83+b11*d84+b12*d85+b13*d86+b14*d87;
fit lwage;
run;



