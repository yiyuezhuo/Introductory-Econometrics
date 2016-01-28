  /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 15: Instrumental Vaiables Estimation and Two Stage 
 *              Least Squares
 *****************************************************************/
data mylib.mroz;   /*  Obs:   753*/
infile 'c:\hong\teach\wooldridge\data\MROZ.RAW';
input 
inlf      hours     kidslt6   kidsge6   age       educ      wage      repwage  
hushrs    husage    huseduc   huswage   faminc    mtr       motheduc  
fatheduc  unem      city      exper     nwifeinc  lwage     expersq;
run;

 title1 'Example 15.1: return to education 
 for married women';
 title2 'OLS';
 /*only married working women*/
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ;
 fit lwage/ols;
 run;
 *ods listing;
title2 'Check fatheduc and educ';
*ods select ParameterEstimates;
proc model data=mylib.mroz
(where=(inlf=1));
educ=b0+b1*fatheduc;
fit educ/ols;
run;

 title2 'Instrument';
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ;
 fit lwage/2sls;
 instrument fatheduc;
 run;

 /** Obs:   935**/
data mylib.wage2;
infile 'c:\hong\teach\wooldridge\data\WAGE2.RAW';
input wage      hours     IQ        KWW       educ      exper     tenure    age      
married   black     south     urban     sibs      brthord   meduc     feduc    
lwage;
run;
 title1 'Example 15.2: Return to Education for Men'; 
 title2 'OLS';
proc model data=mylib.wage2;
lwage=a+b*educ;
fit lwage/ols;
run;
 title2 'Instrument Variable in 2SLS';
proc model;
lwage=a+b*educ;
fit lwage/2sls;
instrument sibs; /*R square negative*/
run;
title1; title2;

/*Excercise Example 15.3: 
Consequence of bad instrument*/

title1 '2SLS: Example 15.5 Equation 15.40';
/*any linear combination of the exogenous 
variables is a valid IV*/
title2 'OLS';
proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ+c*exper+d*expersq;
 fit lwage/ols;
 test c=0, d=0,/all;
 run;

 title2 '2SLS';
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ+c*exper+d*expersq;
 fit lwage/2sls FSRSQ; 
 instrument  exper expersq motheduc fatheduc; 
/*An intercept is included as an instrument unless specified no*/
/*first test that motheduc and fatheduc
 are related to educ*/
 test c=0, d=0,/all; /*SSR from second stage used*/
run;
quit;
/*caution with multicollinearity
 between educhat and exogenous variables*/

 ods select HausmanTest;
 title1;
 title2;
 title1 'Hausman Test for Endogineity';
 /*If explanatory variables are exogenous,
 2sls is less efficient*/
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ+c*exper+d*expersq;
 fit lwage/ols 2sls hausman;  /*no significant difference found*/
 instrument  exper expersq motheduc fatheduc; 
 run; 
 /*large p value indicates no significant difference*/
quit;

 title1 'Test Heteroskedasticity';
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ+c*exper+d*expersq;
instrument  exper expersq motheduc fatheduc huseduc; 
fit lwage/ols 2sls outest=est2 outcov breusch=(1 exper expersq motheduc fatheduc huseduc);
run; 
quit;

title1 'After fit';
 proc model data=mylib.mroz
(where=(inlf=1));
 lwage=a+b*educ+c*exper+d*expersq;
fit lwage/ols 2sls outest=est1 outcov breusch=(1 exper expersq motheduc fatheduc huseduc);
instrument  exper expersq motheduc fatheduc huseduc; 
run; 
quit;
proc compare data=est2 compare=est1;
run;
 /*Exercise1: estimate Heteroskedasticity
   using IML with the method coverd in 
   Chapter 8.4*/ 

 /*Exercise2: repeat eg. 15.5 with IML
 Get estimates and standard errors*/
