 /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 16: Simultaneous Equations Models
 *             
 *****************************************************************/
/*********
data mroz;   /*  Obs:   753*/
infile 'c:\hong\teach\wooldridge\data\MROZ.RAW';
input 
inlf      hours     kidslt6   kidsge6   age       educ      wage      repwage  
hushrs    husage    huseduc   huswage   faminc    mtr       motheduc  
fatheduc  unem      city      exper     nwifeinc  lwage     expersq;
run;********/

 title1 '2SLS: Example 16.5';
 title2 'Labor Supply of married Working Women';
 proc model data= mylib.mroz
(where=(inlf=1));
 parm a0-a5 b0-b4;
 endogenous hours lwage;
 hours=a0+a1*lwage+a2*educ+a3*age+a4*kidslt6+a5*nwifeinc;
 lwage=b0+b1*hours+b2*educ+b3*exper+b4*expersq;
 fit hours lwage/2sls outest=est1;
 instrument educ age kidslt6 nwifeinc exper expersq;
 run;
 proc model data= mylib.mroz
(where=(inlf=1));
 parm a0-a5 b0-b4;
 endogenous hours lwage;
 hours=a0+a1*lwage+a2*educ+a3*age+a4*kidslt6+a5*nwifeinc;
 lwage=b0+b1*hours+b2*educ+b3*exper+b4*expersq;
 fit hours lwage/2sls outest=est2;
 instrument _exog_;
 run;
proc compare data=est1 compare=est2;
run;

 /*SUR and 3SLS Estimation Methods*/
/*SUR may improve the efficiency of 
 parameter estimates when
 there is contemporaneous correlation 
 of errors across equations*/

   / * Zellner's Seemingly Unrelated Technique------------
    A. Zellner, An Efficient Method of Estimating Seemingly   | 
   | Unrelated Regressions and Tests for Aggregation Bias, | 
   | JASA 57(1962) pp.348-364                                   | 
   |                                                            | 
   | J.C.G. Boot, Investment Demand: an Empirical Contribution | 
   | to the Aggregation Problem, IER 1(1960) pp.3-30.          | 
   |                                                            | 
   | Y. Grunfeld, The Determinants of Corporate Investment,   | 
   | Unpublished thesis, Chicago, 1958                          | 
   ------------------------------------------------------------*/
    
   data grunfeld; 
      input year ge_i ge_f ge_c wh_i wh_f wh_c; 
      label ge_i = 'Gross Investment, GE' 
            ge_c = 'Capital Stock Lagged, GE' 
            ge_f = 'Value of Outstanding Shares Lagged, GE' 
            wh_i = 'Gross Investment, WH' 
            wh_c = 'Capital Stock Lagged, WH' 
            wh_f = 'Value of Outstanding Shares Lagged, WH'; 
      datalines; 
   1935     33.1      1170.6    97.8      12.93     191.5     1.8 
   1936     45.0      2015.8    104.4     25.90     516.0     .8 
   1937     77.2      2803.3    118.0     35.05     729.0     7.4 
   1938     44.6      2039.7    156.2     22.89     560.4     18.1 
   1939     48.1      2256.2    172.6     18.84     519.9     23.5 
   1940     74.4      2132.2    186.6     28.57     628.5     26.5 
   1941     113.0     1834.1    220.9     48.51     537.1     36.2 
   1942     91.9      1588.0    287.8     43.34     561.2     60.8 
   1943     61.3      1749.4    319.9     37.02     617.2     84.4 
   1944     56.8      1687.2    321.3     37.81     626.7     91.2 
   1945     93.6      2007.7    319.6     39.27     737.2     92.4 
   1946     159.9     2208.3    346.0     53.46     760.5     86.0 
   1947     147.2     1656.7    456.4     55.56     581.4     111.1 
   1948     146.3     1604.4    543.4     49.56     662.3     130.6 
   1949     98.3      1431.8    618.3     32.04     583.8     141.8 
   1950     93.5      1610.5    647.4     32.24     635.2     136.7 
   1951     135.2     1819.4    671.3     54.38     723.8     129.7 
   1952     157.3     2079.7    726.1     71.78     864.1     145.5 
   1953     179.5     2371.6    800.3     90.08     1193.5    174.8 
   1954     189.6     2759.9    888.9     68.60     1188.9    213.5 
   ;
run;

data test;
set grunfeld;
by=1;
if year>1945 then by=2;
run;
proc print data=test; run;

   proc syslin data=grunfeld sur; 
      ge:      model ge_i = ge_f ge_c; 
      westing: model wh_i = wh_f wh_c; 
   run;
quit;

title1 'Compare OLS SUR';
proc model data=test;
endogenous ge_i wh_i;
ge_i=a+a1*ge_f+a2*ge_c;
wh_i=b+b1*wh_f+b2*wh_c;
fit ge_i wh_i/ols sur;
*restrict a=30;
by by;
run;


 *title1 'With time series: ';
