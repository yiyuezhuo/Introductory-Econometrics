/*Wooldrige Chapter 2 */

data ceosal1;
infile 'c:\hong\teach\wooldridge\data\CEOSAL1.RAW';
input salary    pcsalary  sales     roe       pcroe     ros       indus     finance  
consprod  utility   lsalary   lsales;
run;

proc print data=ceosal1;
run;

title1 'Example 2.3';
proc model data=ceosal1;
parm a b;
salary=a+b*roe;
fit salary/ols;
run;


title1 'Example 2.11';
 title2 'Elasticity between CEO salary and sales in logs';
proc model data=ceosal1;
lsalary=a+b*lsales;
fit lsalary/ols; 
run;

title2 'Use SYSLIN';
proc syslin data=ceosal1; 
model lsalary=lsales;
run;  
title1;
title2;

title1 'Example 2.3 Using IML Matrix Language';
proc iml;
use ceosal1;
read all var{salary} into y;
read all var{roe} into x;
n=nrow(y);
/*include intercept as regressor*/
x=J(n,1,1)||x;
/*OLS estimate of Slope*/
beta=inv(x`*x)*x`*y; 
print 'OLS Estimate' beta;
/*Residuals*/
u=y-x*beta;
sigmasq=u`*u;
/*Variance-Covariance Matrix*/
varbeta=sigmasq*inv(x`*x)/(n-2);
print 'Variance Matrix' varbeta;
std=sqrt(vecdiag(varbeta));
print 'Standard errors of beta' std;
quit;
