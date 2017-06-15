%MACRO MCALCONVERT(dataset,facility,nvar,vvar,avar,pvar,_var);

data &facility.data;
set &dataset;

length w $4. j period_yrdays 3.;

if (mdy(01,01,1996)<=fy_bgndt<=mdy(12,31,1996)) or (mdy(01,01,1996)<=fy_enddt<=mdy(12,31,1996)) then do; 
   w="1996"; j=1996; 
   if fy_bgndt<=mdy(02,29,1996)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,1997)<=fy_bgndt<=mdy(12,31,1997)) or (mdy(01,01,1997)<=fy_enddt<=mdy(12,31,1997)) then do; 
   w="1997"; j=1997; 
   if fy_bgndt<=mdy(02,29,1996)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,1998)<=fy_bgndt<=mdy(12,31,1998)) or (mdy(01,01,1998)<=fy_enddt<=mdy(12,31,1998)) then do; 
   w="1998"; j=1998; 
   if fy_bgndt<=mdy(02,29,1996)<=fy_enddt then period_yrdays=366;
   else if fy_bgndt<=mdy(02,29,2000)<=fy_enddt then period_yrdays=366; 
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,1999)<=fy_bgndt<=mdy(12,31,1999)) or (mdy(01,01,1999)<=fy_enddt<=mdy(12,31,1999)) then do; 
   w="1999"; j=1999; 
   if fy_bgndt<=mdy(02,29,2000)<=fy_enddt then period_yrdays=366; 
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2000)<=fy_bgndt<=mdy(12,31,2000)) or (mdy(01,01,2000)<=fy_enddt<=mdy(12,31,2000)) then do; 
   w="2000"; j=2000; 
   if fy_bgndt<=mdy(02,29,2000)<=fy_enddt then period_yrdays=366; 
   else period_yrdays=365;
   calyr_days=366;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2001)<=fy_bgndt<=mdy(12,31,2001)) or (mdy(01,01,2001)<=fy_enddt<=mdy(12,31,2001)) then do; 
   w="2001"; j=2001; 
   if fy_bgndt<=mdy(02,29,2000)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2002)<=fy_bgndt<=mdy(12,31,2002)) or (mdy(01,01,2002)<=fy_enddt<=mdy(12,31,2002)) then do; 
   w="2002"; j=2002; 
   if fy_bgndt<=mdy(02,29,2000)<=fy_enddt then period_yrdays=366;
   else if fy_bgndt<=mdy(02,29,2004)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2003)<=fy_bgndt<=mdy(12,31,2003)) or (mdy(01,01,2003)<=fy_enddt<=mdy(12,31,2003)) then do; 
   w="2003"; j=2003; 
   if fy_bgndt<=mdy(02,29,2004)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
    period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2004)<=fy_bgndt<=mdy(12,31,2004)) or (mdy(01,01,2004)<=fy_enddt<=mdy(12,31,2004)) then do; 
   w="2004"; j=2004; 
   if fy_bgndt<=mdy(02,29,2004)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=366;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2005)<=fy_bgndt<=mdy(12,31,2005)) or (mdy(01,01,2005)<=fy_enddt<=mdy(12,31,2005)) then do; 
   w="2005"; j=2005; 
   if fy_bgndt<=mdy(02,29,2004)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2006)<=fy_bgndt<=mdy(12,31,2006)) or (mdy(01,01,2006)<=fy_enddt<=mdy(12,31,2006)) then do; 
   w="2006"; j=2006; 
   if fy_bgndt<=mdy(02,29,2004)<=fy_enddt then period_yrdays=366;
   else if fy_bgndt<=mdy(02,29,2008)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2007)<=fy_bgndt<=mdy(12,31,2007)) or (mdy(01,01,2007)<=fy_enddt<=mdy(12,31,2007)) then do; 
   w="2007"; j=2007; 
   if fy_bgndt<=mdy(02,29,2008)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2008)<=fy_bgndt<=mdy(12,31,2008)) or (mdy(01,01,2008)<=fy_enddt<=mdy(12,31,2008)) then do; 
   w="2008"; j=2008; 
   if fy_bgndt<=mdy(02,29,2008)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=366;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;
if (mdy(01,01,2009)<=fy_bgndt<=mdy(12,31,2009)) or (mdy(01,01,2009)<=fy_enddt<=mdy(12,31,2009)) then do; 
   w="2009"; j=2009; 
   if fy_bgndt<=mdy(02,29,2008)<=fy_enddt then period_yrdays=366;
   else period_yrdays=365;
   calyr_days=365;
   period_actualdays=(fy_enddt-fy_bgndt) + 1;
   if period_actualdays>0 then do;
      period_adjuster=period_yrdays / period_actualdays;
   end;
   output &facility.data;
end;

data &facility.data;
set &facility.data;

format fy_bgndt fy_enddt date8.;
length &facility._prov_id_w $11.;

&facility._prov_id_w=&facility._prov_id || "_" || w;

length calyear 3.;
calyear=j;
j=j-1995;

if j=1 then do; jan=mdy(01,01,1996); dec=mdy(12,31,1996); end;
if j=2 then do; jan=mdy(01,01,1997); dec=mdy(12,31,1997); end;
if j=3 then do; jan=mdy(01,01,1998); dec=mdy(12,31,1998); end;
if j=4 then do; jan=mdy(01,01,1999); dec=mdy(12,31,1999); end;
if j=5 then do; jan=mdy(01,01,2000); dec=mdy(12,31,2000); end;
if j=6 then do; jan=mdy(01,01,2001); dec=mdy(12,31,2001); end;
if j=7 then do; jan=mdy(01,01,2002); dec=mdy(12,31,2002); end;
if j=8 then do; jan=mdy(01,01,2003); dec=mdy(12,31,2003); end;
if j=9 then do; jan=mdy(01,01,2004); dec=mdy(12,31,2004); end;
if j=10 then do; jan=mdy(01,01,2005); dec=mdy(12,31,2005); end;
if j=11 then do; jan=mdy(01,01,2006); dec=mdy(12,31,2006); end;
if j=12 then do; jan=mdy(01,01,2007); dec=mdy(12,31,2007); end;
if j=13 then do; jan=mdy(01,01,2008); dec=mdy(12,31,2008); end;
if j=14 then do; jan=mdy(01,01,2009); dec=mdy(12,31,2009); end;
format jan dec date8.;

yrbegin=max(of fy_bgndt jan);
yrend=min(of fy_enddt dec);
format yrbegin yrend jan dec date8.;

calyr_actualdays=(yrend - yrbegin) + 1;

**original data values, for cost period as is;
array v{&nvar}
      &vvar;

**data values adjusted by period-adjuster;
array adjv{&nvar}
      &avar;

**multiply values by ((number of days in the calendar year) / (actual number of days in the period));
**in order to convert value into what it would be if it covered a full calendar year;
**example: 365 days in the calendar year, 220 days in the period, period_adjuster = 365 / 220;

do i=1 to &nvar;
   if v{i} ne . then adjv{i} = period_adjuster * v{i};
   else adjv{i}=.;
end;

proc sort data=&facility.data;
 by &facility._prov_id_w fy_enddt;
run;

data lastrec_&facility.data;
set &facility.data;
 by &facility._prov_id_w;

retain calyr_bgndt;	

if first.&facility._prov_id_w then do;
   calyr_bgndt=yrbegin;   
   calyr_enddt=.;
end;

if last.&facility._prov_id_w then do;
   calyr_enddt=yrend;
   period_num_days=(calyr_enddt - calyr_bgndt) + 1;
end;
format calyr_bgndt calyr_enddt yrend date8.;

length missfirst1-missfirst&nvar 3.;

retain
	missfirst1-missfirst&nvar
	&_var
	calyr_sumprop
	;

array missfirst{&nvar}
      missfirst1-missfirst&nvar;

**original data values;
array v{&nvar}
      &vvar;

**data values adjusted by period-adjuster;
array adjv{&nvar}
      &avar;

**data values partial;
array partv{&nvar}
      &pvar;

**final data value, adjusted;
array yearv{&nvar}
      &_var;

propyr=calyr_actualdays / calyr_days;

if first.&facility._prov_id_w and last.&facility._prov_id_w then calyr_sumprop=1;
else do;
     if first.&facility._prov_id_w then calyr_sumprop=propyr;
     else calyr_sumprop = sum(of calyr_sumprop propyr);
end;

if first.&facility._prov_id_w and last.&facility._prov_id_w then do i=1 to &nvar;
   partv{i} = adjv{i};
   yearv{i} = partv{i};
end;
else do i=1 to &nvar;
  if adjv{i} ne . then do;
     if missfirst{i}=1 then do;
     	partv{i} = adjv{i} * calyr_sumprop;
	missfirst{i}=.;
     end;
     else partv{i} = adjv{i} * propyr;     
  end;
  if first.&facility._prov_id_w then do;
     yearv{i} = partv{i};
     if partv{i}=. then missfirst{i}=1; else missfirst{i}=.;
  end;
  else do;
     if partv{i} ne . then yearv{i} = sum(of yearv{i} partv{i});

  end; 
end;

if last.&facility._prov_id_w then output lastrec_&facility.data;

proc sort data=lastrec_&facility.data;
 by rec_num;
run;

%MEND MCALCONVERT;
