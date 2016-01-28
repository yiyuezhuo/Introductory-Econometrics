 /*Reading data and descriptive statistics*/
data ceosal1;
infile "c:\hong\teach\wooldridge\data\CEOSAL1.RAW" ;
input salary    pcsalary  sales     roe       pcroe     ros       indus     finance  
consprod  utility   lsalary   lsales;
run;

data example;
input x1 x2;
cards;
6.0  1.3 
3.0  6.1
7.5  9.2
;
run;


*print data set;
title1 "CEOSAL1";
proc print data=ceosal1;
run;
title2 "Data Example";
proc print data=example;
run;
*summarize the content of the data set;
proc contents data=ceosal1;
run;

*descriptive statistics;
proc univariate data=ceosal1;
var salary;
run;

/*How to input a file with long records*/
title1"Records Truncated";
data crime2;
infile "c:\hong\teach\wooldridge\data\CRIME2.RAW" ;
input pop    crimes    unem      officers  pcinc     west      nrtheast  south    
year      area      d87       popden    crmrte    offarea   lawexpc   polpc    
lpop      loffic    lpcinc    llawexpc  lpopden   lcrimes   larea     lcrmrte  
clcrimes  clpop     clcrmrte  lpolpc    clpolpc   cllawexp  cunem     
clpopden lcrmrt_1  ccrmrte;
run;

proc print data=crime2 (obs=20);
run;

title1 "LRECL= option for long records" ;
data crime2;
infile "c:\hong\teach\wooldridge\data\CRIME2.RAW"  lrecl=500;
input
pop       crimes    unem      officers  pcinc     west      nrtheast  south    
year      area      d87       popden    crmrte    offarea   lawexpc   polpc    
lpop      loffic    lpcinc    llawexpc  lpopden   lcrimes   larea     lcrmrte  
clcrimes  clpop     clcrmrte  lpolpc    clpolpc   cllawexp  cunem     
clpopden lcrmrt_1  ccrmrte;
run;

proc print data=crime2 (obs=20);
run;

 /*******Create a new library and view data************/
data mylib.crime2;
set crime2;
run;

title1;
/******Home work

Use the data set CORN.RAW under WOOLDRIDGE and the data set in sashelp library. 
Do the following:

1. View and print the content of the data.
2. Find the mean, minimum, and maximum value of the third variable.
****************/                        

