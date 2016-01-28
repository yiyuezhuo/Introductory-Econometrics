/************Chapter 13 Simple Panel Data Methods*********************/
data crime2;
infile 'c:\hong\teach\wooldridge\data\CRIME2.RAW' lrecl=500;
input
pop       crimes    unem      officers  pcinc     west      nrtheast  south    
year      area      d87       popden    crmrte    offarea   lawexpc   polpc    
lpop      loffic    lpcinc    llawexpc  lpopden   lcrimes   larea     lcrmrte  
clcrimes  clpop     clcrmrte  lpolpc    clpolpc   cllawexp  cunem     
clpopden lcrmrt_1  ccrmrte;
run;

 title2 "With one year data";
proc model data=crime2(where=(d87=1));
crmrte=a+b*unem;
fit crmrte/ols;
run;
 
title2 "Equation13.16: With two year data";
proc model data=crime2;
crmrte=a+b*d87+c*unem;
fit crmrte/ols;
run;

title2 'Equation 13.18: With Differenced Data';
proc model data=crime2(where=(d87=1));
ccrmrte=a+c*cunem;
fit ccrmrte/ols;
run;

  /********Crime4: NC Crime Rates*********************  
  3. crmrte                   crimes committed per person
  4. prbarr                   'probability' of arrest
  5. prbconv                  'probability' of conviction
  6. prbpris                  'probability' of prison sentenc
  7. avgsen                   avg. sentence, days
  8. polpc                    police per capita
  9. density                  people per sq. mile
 10. taxpc                    tax revenue per capita

 52. clcrmrte                 lcrmrte - lcrmrte[t-1]
 53. clprbarr                 lprbarr - lprbarr[t-1]
 54. clprbcon                 lprbconv - lprbconv[t-1]
 55. clprbpri                 lprbpri - lprbpri[t-1]
 56. clavgsen                 lavgsen - lavgsen[t-1]
 57. clpolpc                  lpolpc - lpolpc[t-1]
 58. cltaxpc                  ltaxpc - ltaxpc[t-1]
 59. clmix                    lmix - lmix[t-1]
  ************************************************/
  data crime4;
  infile 'c:\hong\teach\wooldridge\data\CRIME4.RAW' lrecl=1000;
  input county    year      crmrte    prbarr    prbconv   prbpris   avgsen    polpc    
density   taxpc     west      central   urban     pctmin80  wcon      wtuc     
wtrd      wfir      wser      wmfg      wfed      wsta      wloc      mix      
pctymle   d82       d83       d84       d85       d86       d87       lcrmrte  
lprbarr   lprbconv  lprbpris  lavgsen   lpolpc    ldensity  ltaxpc    lwcon    
lwtuc     lwtrd     lwfir     lwser     lwmfg     lwfed     lwsta     lwloc    
lmix      lpctymle  lpctmin   clcrmrte  clprbarr  clprbcon  clprbpri  
clavgsen  clpolpc   cltaxpc   clmix;
run;
 title2 'Example 13.9: Multiyear data';
proc model data=crime4;
parm b0-b10;
clcrmrte=b0+b1*d83+b2*d84+b3*d85+b4*d86+b5*d87
         +b6*clprbarr+b7*clprbcon+b8*clprbpri+b9*clavgsen+b10*clpolpc;
fit clcrmrte/ols ;
run;
          

