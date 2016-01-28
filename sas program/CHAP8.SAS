
/************HRPICE1************************************
  Obs:    88

  1. price                    price, in dollars
  2. assess                   assessed value, in dollars
  3. bdrms                    number of bedrooms
  4. lotsize                  size of lot, square feet
  5. sqrft                    size of house, square feet
  6. colonial                 =1 if home is colonial style
  7. lprice                   log(price)
  8. lassess                  log(assess
  9. llotsize                 log(lotsize)
 10. lsqrft                   log(sqrft)

*******************************************************/

data hprice1;
infile 'HPRICE1.RAW';
input price     assess    bdrms     lotsize   sqrft     colonial  lprice    lassess  
llotsize  lsqrft;
run;

title1 'Heteroskedasticity';
title2 'Equation 8.17: LM and White Test';
proc model data=hprice1;
price=b0+b1*lotsize+b2*sqrft+b3*bdrms;
fit price/ols breusch=(1 lotsize sqrft bdrms) white;
run;   

title2 'Equation 8.18: Logged form often reduces heteroskedasticity';
proc model data=hprice1;
lprice=b0+b1*llotsize+b2*lsqrft+b3*bdrms;
fit lprice/ols breusch=(1 llotsize lsqrft bdrms) white;
run; 

title2 'Example 8.6: Weighted Least Squares (WLS) Estimation';
data saving;
infile 'SAVING.RAW';
input sav       inc       size      educ      age       black     cons;
run;
title3 'No Weight';
proc model data=saving;
sav=b0+b1*inc;
fit sav/ols;
run;

title3 'Weighted';
proc model data=saving;
sav=b0+b1*inc;
h=1/inc;
fit sav/ols;
weight h;
run;

 
title2 'Heteroscedasticity-Consistent Covariance Matrix Estimation';
data wage1;
infile 'WAGE1.RAW';
input wage      educ      exper     tenure    nonwhite  female    married   numdep   
smsa      northcen  south     west      construc  ndurman   trcommpu  trade    
services  profserv  profocc   clerocc   servocc   lwage     expersq   tenursq ;
run;

data wage;
set wage1;
marrmale=0;
marrfem=0;
singfem=0;
if female=0 and married=1 then marrmale=1;
if female=1 and married=1 then marrfem=1;
if female=1 and married=0 then singfem=1;
run;

title2 'Example 8.1';
%macro hcc(hcc);
title2 "Example 8.1 HCCME=&hcc"; 
proc model data=wage;
parm b0-b8;
lwage=b0+b1*marrmale+b2*marrfem+b3*singfem +b4*educ+b5*exper+b6*expersq
    +b7*tenure+b8*tenursq;
fit lwage/ols hccme=&hcc;      /*See Proc Model V9 document for HCCME= option*/
run;
%mend;

%hcc(no);
%hcc(0);
%hcc(1);

