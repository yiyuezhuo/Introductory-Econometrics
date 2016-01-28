 /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 17: Limited Dependent Variable
 *             
 *****************************************************************/
 

%macro lim(d);
title1 "Example 17.1: method=&d";
proc qlim data=mylib.mroz;
endogenous inlf~discrete(d=logit);
model inlf=nwifeinc educ exper expersq
age kidslt6 kidsge6;
run;
%mend lim;
 
%lim(logit);
%lim(normal); /*probit*/
