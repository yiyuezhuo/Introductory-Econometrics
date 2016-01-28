/*Chapter 6 Further Issues in Mutiple Regression*/


data gpa2;
infile 'c:\hong\teach\wooldridge\data\GPA2.RAW';
input
sat       tothrs    colgpa    athlete   verbmath  hsize     hsrank    hsperc
female    white     black     hsizesq ;
run;

/*create new variables*/
data gpanew;
set gpa2;
sat0=sat-1200;
hsperc0=hsperc-30;
hsize0=hsize-5;
hsizesq0=hsizesq-25;
run;


*proc print data=gpanew(firstobs=4130); run;

title1 'Example 6.5 Confidence Interval of Predictions';
proc model data=gpanew;
colgpa=b0+b1*sat0+b2*hsperc0+b3*hsize0+b4*hsizesq0;
fit colgpa/ols out=outm outs=s;
run;

