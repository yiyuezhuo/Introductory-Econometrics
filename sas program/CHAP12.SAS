 /*****************************************************************
 *  Examples for Introductory Econometrics: A Modern Approach, 2e
 *  Jeffrey M Wooldridge 2003
 *  Chapter 12 and 18:  More on Time Series 
 *****************************************************************/

data phillips;
infile 'c:\hong\teach\wooldridge\data\PHILLIPS.RAW';
input year      unem      inf       unem_1    inf_1     unem_2    inf_2     cunem    
cinf      cunem_1   cinf_1 ;
run;

data phillips;
set phillips;
dinf=dif(inf);
run;

title1 'Testing for Serial Correlation: Durbin-Watson Test';
title2 'Example 12.1';
proc autoreg data=phillips;
model inf=unem/dw=1;
model dinf=unem/dw=1;  /*serial correlation reduced by differencing*/
run;   

title2 'Example 12.5: Cochrane-Orcutt or Yule-Walker';
proc autoreg data=phillips;
model inf=unem/NLAG=1 method=YW;
run;

data barium;
infile 'c:\hong\teach\wooldridge\data\BARIUM.RAW' lrecl=400;
input  chnimp    bchlimp   befile6   affile6   afdec6    befile12  affile12  afdec12  
chempi    gas       rtwex     spr       sum       fall      lchnimp   lgas     
lrtwex    lchempi   t         feb       mar       apr       may       jun      
jul       aug       sep       oct       nov       dec       percchn ;
run;
title1 'Hiher Order Serial Correlation';
title2 'Example 12.3: AR(3)';
proc autoreg data=barium;
model lchnimp=lchempi lgas lrtwex befile6 affile6 afdec6/
              dw=3 dwprob godfrey=3 nlag=3;
run;
title2 'Seasonal Autocorrelation';
proc autoreg data=barium;
model lchnimp=lchempi lgas lrtwex befile6 affile6 afdec6/
              method=YW nlag=(12);
run;

/*The default estimation method is Yule-Yalker (YW) estimation 
  or Prais-Winsten estimation when nlag is specified.
  When Nlag is not given, OLS is estimated.*/


title1 'Heteroskedasticity';                                       
title2 'Example 11.4 & Example 12.8'; 
/*  Jan 1976-march 1989 Obs:   691*/
data mylib.nyse;
infile 'c:\hong\teach\wooldridge\data\NYSE.RAW';
input price     return    return_1     t     price_1   price_2   cprice    
cprice_1;
run;

/*Example 12.9: Using IML Matrix Language*/
proc iml;
use mylib.nyse;
read all var{return} into y;
read all var{return_1} into y_1;
n=nrow(y_1);
x=J(n-2,1,1)||y_1[3:n];
y=y[3:n];
beta=inv(x`*x)*x`*y; 
print 'OLS Estimate' beta;
u=y-x*beta;
uu=u#u;
rho1=inv(x`*x)*x`*uu;     /*Exmaple 12.8*/
print 'H Estimate' rho1;
/*Example 12.9*/
nu=nrow(u);
u_1=u[1:nu-1];
uu=uu[2:nu];
uu_1=j(nu-1,1,1)||(u_1 # u_1); /*include intercept*/
rho2=inv(uu_1`*uu_1)*uu_1`*uu;
print 'ARCH testing' rho2;
quit;

title2 'H testing in autoreg'; 
proc autoreg data=mylib.nyse;
model return=return_1;
hetero price/link=linear test=LM;      /*can not be combined with AR model*/
run;

title2 'Example ARCH model';
proc autoreg data=mylib.nyse;
model return=return_1/garch=(q=1);
run;

data nile;
         input level @@;
         year = intnx( 'year', '1jan1871'd, _n_-1 ); 
         format year year4.; 
         datalines;
      1120  1160  963  1210  1160  1160  813  1230   1370  1140
      995   935   1110 994   1020  960   1180 799    958   1140
      1100  1210  1150 1250  1260  1220  1030 1100   774   840
      874   694   940  833   701   916   692  1020   1050  969
      831   726   456  824   702   1120  1100 832    764   821
      768   845   864  862   698   845   744  796    1040  759
      781   865   845  944   984   897   822  1010   771   676
      649   846   812  742   801   1040  860  874    848   890
      744   749   838  1050  918   986   797  923    975   815
      1020  906   901  1170  912   746   919  718    714   740
      ;
      run;
proc print data=nile(obs=3); run;
title1 'Outlier Detection';
proc arima data=nile;
      identify var= level(1) noprint;
      estimate q = 1 noint method= ml plot;
      outlier maxnum= 5 id=year;
   run;
