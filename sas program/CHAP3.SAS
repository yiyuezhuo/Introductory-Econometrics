/*******Chapter3: Multiple Regression Analysis: Estimation******/

data ceosal2;
infile 'c:\hong\teach\wooldridge\data\CEOSAL2.RAW';
input salary    age       college   grad      comten    ceoten    sales     profits  
mktval    lsalary   lsales    lmktval   comtensq  ceotensq  profmarg;
run;

*proc print data=ceosal2; run;

title1 'Example of elasticity and multicollinearity';
title2 'Problem 3.15 (i): elasticity';  
proc model data=ceosal2;
lsalary=a+b*lsales+c*lmktval;
fit lsalary/ols;
run;

title2 'Problem 3.15 (ii) ';  
proc model data=ceosal2;
lsalary=a+b*lsales+c*lmktval+d*profits;
fit lsalary/ols;
run;
/*Examine the values of porfits in CEOSAL2.RAW.
we cannot include profits in logarithmic form because profits 
are negative for nine of the companies in the sample*/

title2 'Problem 3.15 (iii)';  
proc model data=ceosal2;
lsalary=a+b*lsales+c*lmktval+d*profits+e*ceoten;
fit lsalary/ols;
run;
/*****One more year as CEO increases predicted salary by about 1.2%*******/
  

title2 'Problem 3.15 (iv)';
/*Correlations between log(mktval) and profits*/
proc corr data=ceosal2;
var lmktval profits;
run;

/*.78 correlation is fairly high. This causes no bias but OLS 
estimates variances will be large. Profits adds nothing to model
because of its correlation with mkdval*/

/******



  Obs:   660

  1. id                       respondent identifier
  2. educ                     years schooling
  3. date                     date:  month/day/year
  4. state                    home state
  5. regprc                   price of regular apples
  6. ecoprc                   price of ecolabeled apples
  7. inseason                 =1 if interviewed in Nov.
  8. hhsize                   household size
  9. male                     =1 if male
 10. faminc                   family income, thousands
 11. age                      in years
 12. reglbs                   quantity regular apples, pounds
 13. ecolbs                   quantity ecolabeled apples, lbs
 14. numlt5                   # in household younger than 5
 15. num5_17                  # in household 5 to 17
 16. num18_64                 # in household 18 to 64
 17. numgt64                  # in household older than 64
****/
data apple;
infile  'c:\hong\teach\wooldridge\data\apple.RAW';
input id        educ      date      state     regprc    ecoprc    inseason  hhsize   
male      faminc    age       reglbs    ecolbs    numlt5    num5_17   
num18_64 numgt64;
run; 
title1 'Example of Omitted Exogenous variabels';
proc model data=apple;
ecolbs=a+b*ecoprc;
fit ecolbs/ols;
run;


proc model data=apple;
ecolbs=a+b*ecoprc+c*regprc;
fit ecolbs/ols;
run;

proc model data=apple;
regprc=b0+b1*ecoprc;
fit regprc/ols;
run;

/*regprc and ecoprc are positively correlated, 
so omitting regprc causes b estmate to be positively
biased*/

