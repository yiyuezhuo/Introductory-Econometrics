
/*Chapter 5 OLS Asymptotic Properties*/


/*******************************************************
  
 Obs:   506

  1. price                    median housing price, $
  2. crime                    crimes committed per capita
  3. nox                      nitrous oxide, parts per 100 mill.
  4. rooms                    avg number of rooms per house
  5. dist                     weighted dist. to 5 employ centers
  6. radial                   accessibiliy index to radial hghwys
  7. proptax                  property tax per $1000
  8. stratio                  average student-teacher ratio
  9. lowstat                  % of people 'lower status'
 10. lprice                   log(price)
 11. lnox                     log(nox)
 12. lproptax                 log(proptax)
 **********************************************************/

data hprice2;
infile 'c:\hong\teach\wooldridge\data\HPRICE2.RAW';
input price     crime     nox       rooms     dist      radial    proptax   stratio  
lowstat   lprice    lnox      lproptax  ;
run;

*proc print data=hprice2; run;
proc contents data=hprice2; run;

data hprice2;
set hprice2;
lprice=log(price);
lnox=log(nox);
ldist=log(dist);

title1 'Viewing Distribution';
proc univariate data=hprice2;
var price lprice;
histogram price lprice;
run;

title1 "Compare F test and LM test";

title2 'Example 4.5: Housing prices and Air Pollution';
proc syslin data=hprice2;
model lprice=lnox ldist rooms stratio;
test lnox=-1; /*F-test for Single Equation F=t*/
run;

title2 'Chapter 5: LM Compare with example 4.5';
proc model data=hprice2;
lprice=b0+b1*lnox+b2*ldist+b3*rooms+b4*stratio;
fit lprice/ols;
test "Single test" b1=-1,/lm;   
run;

title2 'Example 5.3: Crime';
data crime1;
infile 'c:\hong\teach\wooldridge\data\CRIME1.RAW';
input narr86    nfarr86   nparr86   pcnv      avgsen    
tottime   ptime86   qemp86   inc86     durat     black     
hispan    born60    pcnvsq    pt86sq    inc86sq;  
run;

proc model data=crime1;
parm b0-b5;
narr86=b0+b1*pcnv+b2*avgsen+b3*tottime+b4*ptime86+b5*qemp86;
fit narr86/ols;
test "For 2 exclusion restrictions" b2=0, b3=0,/all;  
run;



