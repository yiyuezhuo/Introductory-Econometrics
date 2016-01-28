
/*Chapter 4 Multitiple Regression Analysis: Inference*/
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
lowstat   lprice    lnox      lproptax  ;
run;

*proc print data=hprice2; run;
proc contents data=hprice2; run;

data hprice2;
set hprice2;
lprice=log(price);
lnox=log(nox);
ldist=log(dist);

title1 "T Test, P value, F statistic";
title2 'Example 4.5: Housing prices and Air Pollution';
proc syslin data=hprice2;
model lprice=lnox ldist rooms stratio;
test lnox=-1; /*F-test for Single Equation F=t*/
test lnox=ldist;/* Testing Linear Combinaton*/
test lnox=-1, lnox=ldist; /*Testing multiple linear restrictions*/
run;



Title2 'Equation 4.31: F test multiple restrictions';

data mlb1;
infile 'c:\hong\teach\wooldridge\data\MLB1.RAW' lrecl=600;
input
salary    teamsal   nl        years     games     atbats    runs      hits     
doubles   triples   hruns     rbis      bavg      bb        so        sbases   
fldperc   frstbase  scndbase  shrtstop  thrdbase  outfield  catcher   
yrsallst  hispan    black     whitepop  blackpop  hisppop   pcinc     gamesyr   
hrunsyr   atbatsyr  allstar   slugavg   rbisyr    sbasesyr  runsyr    percwhte  
percblck  perchisp  blckpb    hispph    whtepw    blckph    hisppb    lsalary   
;
run;

proc syslin data=mlb1;
ods select 
model lsalary= years gamesyr bavg hrunsyr rbisyr;
test bavg =0, hrunsyr=0, rbisyr=0;
run;

