 /*Working with time series
SAS date. For example, SAS reads the value '17OCT1991'D the same as 11612, the SAS date value for 17 October 1991. Thus, the following SAS statements 
print DATE=11612.*/
 *options yearcutoff=1920;
   data _null_; 
     date = '17oct1991'd; 
	 date1='18oct1991'd;
     put date=; 
	 put date1=;
   run;
 title1 'Storing Time-series Data';
     data usprice; 
	  informat date monyy7.;
      input date cpi ppi; 
	  format date monyy5.;
	        label cpi = "Consumer Price Index" 
            ppi = "Producer Price Index"; 
   datalines; 
   jun1990 129.9 114.3 
   jul1990 130.4 114.5 
   aug1990 131.6 116.5 
   sep1990 132.7 118.4 
   oct1990 133.5 120.8 
   nov1990 133.8 120.1 
   dec1990 133.8 118.7 
   jan1991 134.6 119.0 
   feb1991 134.8 117.2 
   mar1991 135.0 116.2 
   apr1991 135.2 116.0 
   may1991 135.6 116.5 
   jun1991 136.0 116.3 
   jul1991 136.2 116.0 
   ; 
run;    
   proc print data=usprice; 
   run;

   title1 'Subsetting and merging';
 /*
data subset; 
      set full; 
      if date >= '1jan1970'd & state = 'NC'; 
      keep date x y; 
   run;

proc arima data=full; 
      where '31dec1993'd < day < '26mar1994'd; 
      identify var=close; 
   run;
*/
data uscpi(keep=date cpi) 
        usppi(keep=date ppi); 
      set usprice; 
      *if date >= '1aug1990'd then output uscpi; 
      *if date <= '1jun1991'd then output usppi; 
   run;
   proc print data=uscpi; run;

 proc gplot data=uscpi; 
      symbol i=spline v=circle h=2; 
      plot cpi * date; 
   run;

   title1 'Lag and Dif';
      data uscpi; 
      set uscpi; 
      cpilag = lag( cpi ); 
      cpidif = dif( cpi ); 
   run; 
    
   proc print data=uscpi; 
   run;
 
   title "Where Data Set"; 
   proc print data=uscpi; 
      where date >= '1oct1990'd & date <= '1mar1991'd; 
   run; 

   title1 'Original forecast data';
proc forecast data=usprice interval=month lead=12 
                 out=foreout outfull outresid; 
      var cpi ppi; 
      id date; 
   run; 
   proc print data=foreout; 
   run;

   proc transpose data=foreout out=trans; 
      *var cpi;
	  var cpi ppi;
	  id _type_;
      by date; 
      *where date > '1may1991'd & date < '1oct1991'd; 
   run; 
    
title1 "Transposed Data Set"; 
   proc print data=trans; 
   run;

