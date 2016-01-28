
/*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 10: Basic With Time Series Data
 *****************************************************************/
 
/*Effects of Personal Exemption on Fertility Rates obs: 72*/

data mylib.fertil3;
infile 'c:\hong\teach\wooldridge\data\FERTIL3.RAW' lrecl=400;
input gfr       pe        year      t         tsq       pe_1      pe_2      pe_3     
pe_4      pill      ww2       tcu       cgfr      cpe       cpe_1     cpe_2    
cpe_3     cpe_4     gfr_1     cgfr_1    cgfr_2    cgfr_3    cgfr_4    gfr_2;
run;

title1 'OSL for Static Model';
title2 'Example 10.4 Equation 10.18';
proc autoreg data=mylib.fertil3;
model gfr=pe ww2 pill;
run;

title1 'FDL';
title2 'Equation 10.19';
proc pdlreg data=mylib.fertil3;
model gfr=pe(2) ww2 pill;
run;

title2;
title1 'Detrend to avoid spurious regression';
proc model data=mylib.fertil3;
gfr=a+ b*pe+ c*ww2+ d*pill+ e*t; 
fit gfr/ols;
run;
title2 'SQRT of T';
proc model data=mylib.fertil3;
gfr=a+ b*pe+ c*ww2+ d*pill
+ e*t+f*t**2; 
fit gfr/ols;
run;
/*goodness-of-fit is exagerated*/


