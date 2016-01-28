/*Addition of Chapter 6*/
/****************
  Obs:   680

  1. attend                   classes attended out of 32
  2. termgpa                  GPA for term
  3. priGPA                   cumulative GPA prior to term
  4. ACT                      ACT score
  5. final                    final exam score
  6. atndrte                  percent classes attended
  7. hwrte                    percent homework turned in
  8. frosh                    =1 if freshman
  9. soph                     =1 if sophomore
 10. skipped                  number of classes skipped
 11. stndfnl                  (final - mean)/sd
*********/
data attend;
infile 'c:\hong\teach\wooldridge\data\ATTEND.RAW';
input attend   termgpa   priGPA    ACT  final  atndrte   hwrte     frosh    
soph   skipped   stndfnl;
run;
data attend;
set attend;
gpa_atn=prigpa*atndrte;
GPAsq=prigpa**2;
ACTsq=act**2;
run;
/*default variable names case-insensitive*/

/*Joint test should be conducted
when both interaction of variables
are included*/
ods select ParameterEstimates
      TestResults;
proc syslin data=attend;
model stndfnl=atndrte prigpa act 
                gpasq actsq gpa_atn;
test prigpa=0, gpasq=0;
run;
proc model data=attend;
stndfnl=b0+b1*atndrte+b2*prigpa
            +b3*act+b4*gpasq+b5*actsq
			+b6*gpa_atn;
fit stndfnl/ols;
test 'Joint test with model' 
      b2=0, b6=0,/all;
run;

/*More on predictions*/
data mylib.ceosal2;
infile 'c:\hong\teach\wooldridge\data\CEOSAL2.RAW';
input salary    age       college   grad      comten    ceoten    sales     profits  
mktval    lsalary   lsales    lmktval   comtensq  ceotensq  profmarg;  
run;
data ceoadd;
input sales mktval ceoten lsalary;
cards;
5000 10000 10 .
;
run;
data ceoadd;
set ceoadd;
lsales=log(sales);
lmktval=log(mktval);
run;
data new;
set mylib.ceosal2 ceoadd;
run;
proc print data=new(firstobs=178);
run;
proc model data=mylib.ceosal2;
lsalary=b0+b1*lsales+b2*lmktval+b3*ceoten;
fit lsalary/ols;
solve lsalary/data=new forecast 
                  out=predict;
run;
proc print data=predict(firstobs=178); 
run;



/*Chapter 7*/
/*******************WAGE1***********************

  Obs:   526

  1. wage                     average hourly earnings
  2. educ                     years of education
  3. exper                    years potential experience
  4. tenure                   years with current employer
  5. nonwhite                 =1 if nonwhite
  6. female                   =1 if female
  7. married                  =1 if married
  8. numdep                   number of dependents
  9. smsa                     =1 if live in SMSA
 10. northcen                 =1 if live in north central U.S
 11. south                    =1 if live in southern region
 12. west                     =1 if live in western region
 13. construc                 =1 if work in construc. indus.
 14. ndurman                  =1 if in nondur. manuf. indus.
 15. trcommpu                 =1 if in trans, commun, pub ut
 16. trade                    =1 if in wholesale or retail
 17. services                 =1 if in services indus.
 18. profserv                 =1 if in prof. serv. indus.
 19. profocc                  =1 if in profess. occupation
 20. clerocc                  =1 if in clerical occupation
 21. servocc                  =1 if in service occupation
 22. lwage                    log(wage)
 23. expersq                  exper^2
 24. tenursq                  tenure^2
*****************************************************************/
data wage1;
infile 'c:\hong\teach\wooldridge\data\WAGE1.RAW';
input wage      educ      exper     tenure    nonwhite  female    married   numdep   
smsa      northcen  south     west      construc  ndurman   trcommpu  trade    
services  profserv  profocc   clerocc   servocc   lwage     expersq   tenursq ;
run;

title1'Binary or Dummy variables: Wage and Female'; 
title2 'Equation 7.4'; 
proc model data=wage1;
parm b0-b4;
wage=b0+b1*female+b2*educ+b3*exper+b4*tenure;
fit wage/ols;
run;

title2 'Equation 7.17: log(wage)'; 
proc model data=wage1;
parm b0-b6;
lwage=b0+b1*female+b2*educ+b3*exper+b4*expersq
    +b5*tenure+b6*tenursq;
fit lwage/ols;
run;


title2 'Equation 7.18: Interactions involving dummies';
title3 'Different Slopes';
 /*Muticollinearity between female and female*educ makes the coefficient
   for female much less precisely estimated*/
proc model data=wage1;
parm b0-b7;
lwage=b0+b1*female+b2*educ+b3*female*educ+b4*exper+b5*expersq
    +b6*tenure+b7*tenursq;
fit lwage/ols;
run;

title1;
title2;
title3;

/*Example of Chow test in Model*/
 
      data exp; 
         x=0; 
         do time=1 to 100; 
            if time=50 then x=1; 
            y = 35 * exp( 0.01 * time ) + rannor( 123 ) + x * 5; 
            output; 
         end; 
      run; 
    
      proc model data=exp; 
         parm zo 35 b; 
            dert.z = b * z; 
            y=z; 
         fit y init=(z=zo) / chow =(40 50 60) pchow=90; 
      run;


