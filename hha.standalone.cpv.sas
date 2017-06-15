**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	hha.standalone.cpv.sas
#
#	Must follow:	hha.input.sas
#	     		hha.s2s3wkshts.sas
#
#	Date Written:	August 1, 2011
#
#	Purpose:	Gets 6 cost-per-visit values from C1 worksheet. 
#			Converts cost period values to calendar year values.	
#			Merges S2 and S3 worksheet items with HHA cost-per-visit items in one file.
#
#	Reads:		/data/postacute/RAND/HHA/srcdata/hhaYEARnmrc.sas7bdat		(YEAR=1996-2009)
#			/data/postacute/RAND/HHA/outdata/hha_s2s3_1996_2009.sas7bdat
#
#	Writes:		/data/postacute/RAND/HHA/outdata/hha_cpd_1996_2009.sas7bdat
#
#	Calls:		mcalconvert.sas
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hhasrc  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname hhaout  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";


options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=================================================================================================================================================;

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=================================================================================================================================================;
*
	"7300" - "7399"	="Subunits of Nonprofit and Proprietary HHA's"
	"7400" - "7799"	="Continuation of HHA's (7000-7299 series)"
	"7800" - "7999"	="Subunits of State and Local Governmental HHA's"
	"8000" - "8499"	="Continuation of HHA's (7400-7799 series)"
	"9000" - "9799"	="Continuation of HHA's (8000-8499 series)"
;
*====================================================================================================================;

%MACRO MC1WKSHT(YYEAR);

*C000000 lines 1-6 cols 4-11
*C000000 line 7 cols 5-11
*C000000 lines 8-13 cols 4, 8-11
*C000000 line 14 cols 8-11
*C000000 line 15 cols 3-10
*C000000 line 15.01 cols 3-6, 8-9
*C000000 line 15.02 cols 3,4,6,9
*C000000 line 16 cols 3,4,6,7,9,10
*C000000 line 16.01 cols 3,4,6,7,9,10

*C000001 lines 1-6 col 4

*C000002 line 1 cols 5,6,8,9,10
*C000002 lines 2-4 cols 5,6,8,9,10,11
*C000002 line 5 cols 5,6,8,9,11

*C000003 line 15 cols 3-10
*C000003 line 15.01 cols 3,4,6,9
;

*years 1996-1998 have values in C000000 and in C000001;
*years 1999-2006 only have values in C000001;

*column 4=cost per visit
*lines:
1 	Skilled Nursing Care
2 	Physical Therapy
3 	Occupational Therapy
4 	Speech Pathology
5 	Medical Social Services
6 	Home Health Aide
7	Total (Sum of lines 1-6)	;

data c1nmrc;
set hhasrc.hha&yyear.nmrc;
 by rec_num;
if nwksht in("C000000" "C000001");

if nline in("00100" "00200" "00300" "00400" "00500" "00600") and ncol="0400";
**if prov_id in("017047" "017150" "017151" "017152" "037016" "057004");		***for testing only;

**merge with s2s3 to restrict data set to providers with S2 and S3 values;
proc sort data=hhaout.hha_s2s3_1996_2009 out=s2s3data;
 by rec_num;
run;

data c1nmrc(keep=rec_num prov_id fy_bgndt fy_enddt nwksht hha_prov_id)
     tempc1nmrc(keep=rec_num costline nitem);
merge c1nmrc(in=inc1) 
      s2s3data(in=inkeep keep=rec_num hha_prov_id);
 by rec_num;
 if inc1 and inkeep;
format fy_bgndt fy_enddt date8.;

if nline="00100" then costline=1;
else if nline="00200" then costline=2;
else if nline="00300" then costline=3;
else if nline="00400" then costline=4;
else if nline="00500" then costline=5;
else if nline="00600" then costline=6;

if last.rec_num then output c1nmrc;
output tempc1nmrc;

proc transpose data=tempc1nmrc
     	       prefix=avg_cpv_
	       out=transc1nmrc(drop=_NAME_);
 by rec_num;
 id costline;
run;

data c1_&yyear;
merge c1nmrc(in=inc1) 
      transc1nmrc;
 by rec_num;

%MEND MC1WKSHT;

*====================================================================================================================;
%MACRO MMERGEYEARS;

data c1_allyrs
     hha_cpv_costperiod(rename=(
	     avg_cpv_1	    =sn_avg_cpv
     	     avg_cpv_2	    =pt_avg_cpv
     	     avg_cpv_3	    =ot_avg_cpv
     	     avg_cpv_4	    =spchpath_avg_cpv
     	     avg_cpv_5	    =medsocial_avg_cpv
     	     avg_cpv_6	    =hhaide_avg_cpv));

merge						
      c1_1996 c1_1997 c1_1998 c1_1999
      c1_2000 c1_2001 c1_2002 c1_2003
      c1_2004 c1_2005 c1_2006 c1_2007
      c1_2008 c1_2009;
by rec_num;

output c1_allyrs;
output hha_cpv_costperiod;

***merge with full s2s3 data set, to get values from s2 and s3 worksheets;
data hha_cpv_costperiod;
merge hha_cpv_costperiod(in=ino)
      s2s3data(in=inkeep);
 by rec_num;
 if ino and inkeep;

proc sort data=hha_cpv_costperiod out=hhaout.hha_cpv_costperiod;
 by prov_id fy_bgndt;
run;

proc contents varnum;
run;

proc sort data=c1_allyrs;
 by prov_id fy_bgndt;
run;


%MEND MMERGEYEARS;

*====================================================================================================================;
***this is the calendar routine for variables that are values, not ratios;
***this is used to convert the S3 values from cost-period values to calendar-year values;
***which is necessary to compute the total_avg_cpv value;
***it contains the macro mcalconvert;

%include 'mcalconvert.sas';

*====================================================================================================================;
%MACRO MCALENDAR;

***these are cpv averages, so cannot sum like they are values;
***if 30 days = $50/visit and 90 days = $100/visit then avg = [30/(30+90) * $50] + [90/(30+90) * $100] = 1/4*$50 + 3/4*$100 = $12.50 + $75.00 = $87.50;
**numdaysinperiod / numactualdaysincalyr * cpv;
**do this for all parts of calendar year, then sum;

data c1_allyrs; 
set c1_allyrs;

length w $4. j 
       prov_id_w $10.;

**diy = days in year;
if (mdy(01,01,1996)<=fy_bgndt<=mdy(12,31,1996)) or (mdy(01,01,1996)<=fy_enddt<=mdy(12,31,1996)) then do; 
   w="1996"; j=1996; 
   diy=366;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,1997)<=fy_bgndt<=mdy(12,31,1997)) or (mdy(01,01,1997)<=fy_enddt<=mdy(12,31,1997)) then do; 
   w="1997"; j=1997; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,1998)<=fy_bgndt<=mdy(12,31,1998)) or (mdy(01,01,1998)<=fy_enddt<=mdy(12,31,1998)) then do; 
   w="1998"; j=1998; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,1999)<=fy_bgndt<=mdy(12,31,1999)) or (mdy(01,01,1999)<=fy_enddt<=mdy(12,31,1999)) then do; 
   w="1999"; j=1999; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2000)<=fy_bgndt<=mdy(12,31,2000)) or (mdy(01,01,2000)<=fy_enddt<=mdy(12,31,2000)) then do; 
   w="2000"; j=2000; 
   diy=366;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2001)<=fy_bgndt<=mdy(12,31,2001)) or (mdy(01,01,2001)<=fy_enddt<=mdy(12,31,2001)) then do; 
   w="2001"; j=2001; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2002)<=fy_bgndt<=mdy(12,31,2002)) or (mdy(01,01,2002)<=fy_enddt<=mdy(12,31,2002)) then do; 
   w="2002"; j=2002; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2003)<=fy_bgndt<=mdy(12,31,2003)) or (mdy(01,01,2003)<=fy_enddt<=mdy(12,31,2003)) then do; 
   w="2003"; j=2003; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2004)<=fy_bgndt<=mdy(12,31,2004)) or (mdy(01,01,2004)<=fy_enddt<=mdy(12,31,2004)) then do; 
   w="2004"; j=2004; 
   diy=366;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2005)<=fy_bgndt<=mdy(12,31,2005)) or (mdy(01,01,2005)<=fy_enddt<=mdy(12,31,2005)) then do; 
   w="2005"; j=2005; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2006)<=fy_bgndt<=mdy(12,31,2006)) or (mdy(01,01,2006)<=fy_enddt<=mdy(12,31,2006)) then do; 
   w="2006"; j=2006; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2007)<=fy_bgndt<=mdy(12,31,2007)) or (mdy(01,01,2007)<=fy_enddt<=mdy(12,31,2007)) then do; 
   w="2007"; j=2007; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2008)<=fy_bgndt<=mdy(12,31,2008)) or (mdy(01,01,2008)<=fy_enddt<=mdy(12,31,2008)) then do; 
   w="2008"; j=2008; 
   diy=366;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2009)<=fy_bgndt<=mdy(12,31,2009)) or (mdy(01,01,2009)<=fy_enddt<=mdy(12,31,2009)) then do; 
   w="2009"; j=2009; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;
if (mdy(01,01,2010)<=fy_bgndt<=mdy(12,31,2010)) or (mdy(01,01,2010)<=fy_enddt<=mdy(12,31,2010)) then do; 
   w="2010"; j=2010; 
   diy=365;
   prov_id_w=prov_id || w;
   output c1_allyrs;
end;

proc sort;
 by prov_id_w fy_bgndt;
run;

data c1_allyrs;
set c1_allyrs;

array v{6}
      avg_cpv_1 - avg_cpv_6;

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
if j=15 then do; jan=mdy(01,01,2010); dec=mdy(12,31,2010); end;
format jan dec date8.;

yrbegin=max(of fy_bgndt jan);
yrend=min(of fy_enddt dec);
format yrbegin yrend jan dec date8.;

actual_diy=(yrend - yrbegin) + 1;

format yrbegin yrend date8.;

data last_c1_allyrs(keep=prov_id_w sum_actual_diy)
     _c1_allyrs(drop=sum_actual_diy);
set c1_allyrs;
 by prov_id_w;

retain
      sum_actual_diy;

array v{6}
      avg_cpv_1 - avg_cpv_6;

array partv{6}
      pavg_cpv_1 - pavg_cpv_6;

propyr=actual_diy / diy;

if first.prov_id_w and last.prov_id_w then do;
   sum_actual_diy=actual_diy;
end;
else do;
     if first.prov_id_w then do;
   	sum_actual_diy=actual_diy;
     end;
     else do;
   	sum_actual_diy=sum_actual_diy + actual_diy;
     end;
end;

output _c1_allyrs;

if last.prov_id_w then output last_c1_allyrs;

**get sum_actual_diy value from last record in prov_id_w, in order to compute portion of actual calendar calyear for each prov_id_w record;

data _cal_c1_allyrs(keep=rec_num prov_id prov_id_w hha_prov_id calyear calyr_bgndt calyr_enddt period_num_days savg_cpv_1 - savg_cpv_6)
     _c1_allyrs;
merge _c1_allyrs last_c1_allyrs;
 by prov_id_w;
retain calyr_bgndt;

if first.prov_id_w then calyr_bgndt=yrbegin;
if last.prov_id_w then do;
   calyr_enddt=yrend;
   period_num_days=(calyr_enddt - calyr_bgndt) + 1;
end;
format calyr_bgndt calyr_enddt yrend date8.;

if sum_actual_diy> 0 then prop_calyractualdays = actual_diy / sum_actual_diy;

retain      savg_cpv_1 - savg_cpv_6;

array v{6}
      avg_cpv_1 - avg_cpv_6;

array partv{6}
      pavg_cpv_1 - pavg_cpv_6;

array sv{6}
      savg_cpv_1 - savg_cpv_6;

if first.prov_id_w then do i=1 to 6;
   sv{i}=0;
end;

do i=1 to 6;
   partv{i} = prop_calyractualdays * v{i};
   sv{i} = sv{i} + partv{i};
end;

if last.prov_id_w then output _cal_c1_allyrs;		*calendar year values;

proc sort data=_cal_c1_allyrs 
     out=hha_cpv_calyear(rename=(
	     savg_cpv_1	    =calyear_sn_avg_cpv
     	     savg_cpv_2	    =calyear_pt_avg_cpv
     	     savg_cpv_3	    =calyear_ot_avg_cpv
     	     savg_cpv_4	    =calyear_spchpath_avg_cpv
     	     savg_cpv_5	    =calyear_medsocial_avg_cpv
     	     savg_cpv_6	    =calyear_hhaide_avg_cpv));
 by calyear;
run;

%MEND MCALENDAR;

*====================================================================================================================;
%MACRO MSTDDEV(vvar);

data hha_cpv_calyear;
set hha_cpv_calyear; 

**if avg_cpv value is LT 10 or GE 8000, make it missing;
if not(10<calyear_sn_avg_cpv<8000) then calyear_sn_avg_cpv=.;
if not(10<calyear_pt_avg_cpv<8000) then calyear_pt_avg_cpv=.;
if not(10<calyear_ot_avg_cpv<8000) then calyear_ot_avg_cpv=.;
if not(10<calyear_spchpath_avg_cpv<8000) then calyear_spchpath_avg_cpv=.;
if not(10<calyear_medsocial_avg_cpv<8000) then calyear_medsocial_avg_cpv=.;
if not(10<calyear_hhaide_avg_cpv<8000) then calyear_hhaide_avg_cpv=.;

**identify outliers (>3 stddev from mean for each costline);
proc means data=hha_cpv_calyear noprint;
 class calyear;
 var &vvar;
 output out=dmeans_&vvar(drop=_TYPE_ _FREQ_) stddev=sd_&vvar mean=mean_&vvar;
run;

data dmeans_&vvar;
set dmeans_&vvar;

pos3sd_&vvar=mean_&vvar + (3*sd_&vvar);
neg3sd_&vvar=mean_&vvar - (3*sd_&vvar);

%MEND MSTDDEV;

*====================================================================================================================;
%MACRO MREMOVEOUTLIERS;

data hha_cpv_calyear;
merge hha_cpv_calyear(in=inkeep) 
      dmeans_calyear_sn_avg_cpv 
      dmeans_calyear_sn_avg_cpv
      dmeans_calyear_pt_avg_cpv
      dmeans_calyear_ot_avg_cpv
      dmeans_calyear_spchpath_avg_cpv
      dmeans_calyear_medsocial_avg_cpv
      dmeans_calyear_hhaide_avg_cpv;
 by calyear;
 if inkeep;

***make value missing if it is an outlier (3 stddev away from mean);

if calyear_sn_avg_cpv ne . and not(neg3sd_calyear_sn_avg_cpv < calyear_sn_avg_cpv < pos3sd_calyear_sn_avg_cpv) then do;
   outlier_flag_sn_avg_cpv=1;
   calyear_sn_avg_cpv=.;
end;   
if calyear_pt_avg_cpv ne . and not(neg3sd_calyear_pt_avg_cpv < calyear_pt_avg_cpv < pos3sd_calyear_pt_avg_cpv) then do;
   outlier_flag_pt_avg_cpv=1;
   calyear_pt_avg_cpv=.;
end;   
if calyear_ot_avg_cpv ne . and not(neg3sd_calyear_ot_avg_cpv < calyear_ot_avg_cpv < pos3sd_calyear_ot_avg_cpv) then do;
   outlier_flag_ot_avg_cpv=1;
   calyear_ot_avg_cpv=.;
end;   
if calyear_spchpath_avg_cpv ne . and not(neg3sd_calyear_spchpath_avg_cpv < calyear_spchpath_avg_cpv < pos3sd_calyear_spchpath_avg_cpv) then do;
   outlier_flag_spchpath_avg_cpv=1;
   calyear_spchpath_avg_cpv=.;
end;   
if calyear_medsocial_avg_cpv ne . and not(neg3sd_calyear_medsocial_avg_cpv < calyear_medsocial_avg_cpv < pos3sd_calyear_medsocial_avg_cpv) then do;
   outlier_flag_medsocial_avg_cpv=1;
   calyear_medsocial_avg_cpv=.;
end;   
if calyear_hhaide_avg_cpv ne . and not(neg3sd_calyear_hhaide_avg_cpv < calyear_hhaide_avg_cpv < pos3sd_calyear_hhaide_avg_cpv) then do;
   calyear_hhaide_cpv=.;
end;   

proc sort;
 by rec_num;
run;

%MEND MREMOVEOUTLIERS;

*====================================================================================================================;
%MACRO MWRITEFL;

%MCALCONVERT(
	dataset=hhaout.hha_s2s3_1996_2009,
	facility=hha,
	nvar=56,
	vvar=
    S3_00100_0100
    S3_00100_0200
    S3_00100_0300
    S3_00100_0400
    S3_00100_0500
    S3_00100_0600
    S3_00200_0100
    S3_00200_0200
    S3_00200_0300
    S3_00200_0400
    S3_00200_0500
    S3_00200_0600
    S3_00300_0100
    S3_00300_0200
    S3_00300_0300
    S3_00300_0400
    S3_00300_0500
    S3_00300_0600
    S3_00400_0100
    S3_00400_0200
    S3_00400_0300
    S3_00400_0400
    S3_00400_0500
    S3_00400_0600
    S3_00500_0100
    S3_00500_0200
    S3_00500_0300
    S3_00500_0400
    S3_00500_0500
    S3_00500_0600
    S3_00600_0100
    S3_00600_0200
    S3_00600_0300
    S3_00600_0400
    S3_00600_0500
    S3_00600_0600
    S3_00700_0300
    S3_00700_0400
    S3_00700_0500
    S3_00700_0600
    S3_00800_0100
    S3_00800_0300
    S3_00800_0500
    S3_00900_0100
    S3_00900_0300
    S3_00900_0500
    S3_01000_0000
    S3_01000_0200
    S3_01000_0400
    S3_01000_0600
    S3_01001_0200
    S3_01001_0400
    S3_01001_0600
    S3_01002_0200
    S3_01002_0400
    S3_01002_0600,
	avar=
    aS3_00100_0100
    aS3_00100_0200
    aS3_00100_0300
    aS3_00100_0400
    aS3_00100_0500
    aS3_00100_0600
    aS3_00200_0100
    aS3_00200_0200
    aS3_00200_0300
    aS3_00200_0400
    aS3_00200_0500
    aS3_00200_0600
    aS3_00300_0100
    aS3_00300_0200
    aS3_00300_0300
    aS3_00300_0400
    aS3_00300_0500
    aS3_00300_0600
    aS3_00400_0100
    aS3_00400_0200
    aS3_00400_0300
    aS3_00400_0400
    aS3_00400_0500
    aS3_00400_0600
    aS3_00500_0100
    aS3_00500_0200
    aS3_00500_0300
    aS3_00500_0400
    aS3_00500_0500
    aS3_00500_0600
    aS3_00600_0100
    aS3_00600_0200
    aS3_00600_0300
    aS3_00600_0400
    aS3_00600_0500
    aS3_00600_0600
    aS3_00700_0300
    aS3_00700_0400
    aS3_00700_0500
    aS3_00700_0600
    aS3_00800_0100
    aS3_00800_0300
    aS3_00800_0500
    aS3_00900_0100
    aS3_00900_0300
    aS3_00900_0500
    aS3_01000_0000
    aS3_01000_0200
    aS3_01000_0400
    aS3_01000_0600
    aS3_01001_0200
    aS3_01001_0400
    aS3_01001_0600
    aS3_01002_0200
    aS3_01002_0400
    aS3_01002_0600,
	pvar=
    pS3_00100_0100
    pS3_00100_0200
    pS3_00100_0300
    pS3_00100_0400
    pS3_00100_0500
    pS3_00100_0600
    pS3_00200_0100
    pS3_00200_0200
    pS3_00200_0300
    pS3_00200_0400
    pS3_00200_0500
    pS3_00200_0600
    pS3_00300_0100
    pS3_00300_0200
    pS3_00300_0300
    pS3_00300_0400
    pS3_00300_0500
    pS3_00300_0600
    pS3_00400_0100
    pS3_00400_0200
    pS3_00400_0300
    pS3_00400_0400
    pS3_00400_0500
    pS3_00400_0600
    pS3_00500_0100
    pS3_00500_0200
    pS3_00500_0300
    pS3_00500_0400
    pS3_00500_0500
    pS3_00500_0600
    pS3_00600_0100
    pS3_00600_0200
    pS3_00600_0300
    pS3_00600_0400
    pS3_00600_0500
    pS3_00600_0600
    pS3_00700_0300
    pS3_00700_0400
    pS3_00700_0500
    pS3_00700_0600
    pS3_00800_0100
    pS3_00800_0300
    pS3_00800_0500
    pS3_00900_0100
    pS3_00900_0300
    pS3_00900_0500
    pS3_01000_0000
    pS3_01000_0200
    pS3_01000_0400
    pS3_01000_0600
    pS3_01001_0200
    pS3_01001_0400
    pS3_01001_0600
    pS3_01002_0200
    pS3_01002_0400
    pS3_01002_0600,
	_var=
    yS3_00100_0100
    yS3_00100_0200
    yS3_00100_0300
    yS3_00100_0400
    yS3_00100_0500
    yS3_00100_0600
    yS3_00200_0100
    yS3_00200_0200
    yS3_00200_0300
    yS3_00200_0400
    yS3_00200_0500
    yS3_00200_0600
    yS3_00300_0100
    yS3_00300_0200
    yS3_00300_0300
    yS3_00300_0400
    yS3_00300_0500
    yS3_00300_0600
    yS3_00400_0100
    yS3_00400_0200
    yS3_00400_0300
    yS3_00400_0400
    yS3_00400_0500
    yS3_00400_0600
    yS3_00500_0100
    yS3_00500_0200
    yS3_00500_0300
    yS3_00500_0400
    yS3_00500_0500
    yS3_00500_0600
    yS3_00600_0100
    yS3_00600_0200
    yS3_00600_0300
    yS3_00600_0400
    yS3_00600_0500
    yS3_00600_0600
    yS3_00700_0300
    yS3_00700_0400
    yS3_00700_0500
    yS3_00700_0600
    yS3_00800_0100
    yS3_00800_0300
    yS3_00800_0500
    yS3_00900_0100
    yS3_00900_0300
    yS3_00900_0500
    yS3_01000_0000
    yS3_01000_0200
    yS3_01000_0400
    yS3_01000_0600
    yS3_01001_0200
    yS3_01001_0400
    yS3_01001_0600
    yS3_01002_0200
    yS3_01002_0400
    yS3_01002_0600);

data lastrec_hhadata(rename=(
	yS3_00100_0100		=S3_sn_18_visits
	yS3_00100_0200		=S3_sn_18_pts
	yS3_00100_0300		=S3_sn_oth_visits
	yS3_00100_0400		=S3_sn_oth_pts
	yS3_00100_0500		=S3_sn_tot_visits
	yS3_00100_0600		=S3_sn_tot_pts
	yS3_00200_0100		=S3_pt_18_visits
	yS3_00200_0200		=S3_pt_18_pts
	yS3_00200_0300		=S3_pt_oth_visits
	yS3_00200_0400		=S3_pt_oth_pts
	yS3_00200_0500		=S3_pt_tot_visits
	yS3_00200_0600		=S3_pt_tot_pts
	yS3_00300_0100		=S3_ot_18_visits
	yS3_00300_0200		=S3_ot_18_pts
	yS3_00300_0300		=S3_ot_oth_visits
	yS3_00300_0400		=S3_ot_oth_pts
	yS3_00300_0500		=S3_ot_tot_visits
	yS3_00300_0600		=S3_ot_tot_pts
	yS3_00400_0100		=S3_spchpath_18_visits
	yS3_00400_0200		=S3_spchpath_18_pts
	yS3_00400_0300		=S3_spchpath_oth_visits
	yS3_00400_0400		=S3_spchpath_oth_pts
	yS3_00400_0500		=S3_spchpath_tot_visits
	yS3_00400_0600		=S3_spchpath_tot_pts
	yS3_00500_0100		=S3_medsocial_18_visits
	yS3_00500_0200		=S3_medsocial_18_pts
	yS3_00500_0300		=S3_medsocial_oth_visits
	yS3_00500_0400		=S3_medsocial_oth_pts
	yS3_00500_0500		=S3_medsocial_tot_visits
	yS3_00500_0600		=S3_medsocial_tot_pts
	yS3_00600_0100		=S3_hhaide_18_visits
	yS3_00600_0200		=S3_hhaide_18_pts
	yS3_00600_0300		=S3_hhaide_oth_visits
	yS3_00600_0400		=S3_hhaide_oth_pts
	yS3_00600_0500		=S3_hhaide_tot_visits
	yS3_00600_0600		=S3_hhaide_tot_pts
	yS3_00700_0300		=S3_othsvc_oth_visits
	yS3_00700_0400		=S3_othsvc_oth_pts
	yS3_00700_0500		=S3_othsvc_tot_visits
	yS3_00700_0600		=S3_othsvc_tot_pts
	yS3_00800_0100		=S3_total_18_visits
	yS3_00800_0300		=S3_total_oth_visits
	yS3_00800_0500		=S3_total_tot_visits
	yS3_00900_0100		=S3_hhaide_18_hours
	yS3_00900_0300		=S3_hhaide_oth_hours
	yS3_00900_0500		=S3_hhaide_tot_hours

	yS3_01000_0000		=S3_line10_col0
	yS3_01000_0200		=S3_18_undup_census
	yS3_01000_0400		=S3_oth_undup_census
	yS3_01000_0600		=S3_tot_undup_census

	yS3_01001_0200		=S3_18_undup_census_pre10012000
	yS3_01001_0400		=S3_oth_undup_census_pre10012000
	yS3_01001_0600		=S3_tot_undup_census_pre10012000
	yS3_01002_0200		=S3_18_undup_census_post9302000
	yS3_01002_0400		=S3_oth_undup_census_post9302000
	yS3_01002_0600		=S3_tot_undup_census_post9302000)

	drop=
	aS3_00100_0100
	aS3_00100_0200
	aS3_00100_0300
	aS3_00100_0400
	aS3_00100_0500
	aS3_00100_0600
	aS3_00200_0100
	aS3_00200_0200
	aS3_00200_0300
	aS3_00200_0400
	aS3_00200_0500
	aS3_00200_0600
	aS3_00300_0100
	aS3_00300_0200
	aS3_00300_0300
	aS3_00300_0400
	aS3_00300_0500
	aS3_00300_0600
	aS3_00400_0100
	aS3_00400_0200
	aS3_00400_0300
	aS3_00400_0400
	aS3_00400_0500
	aS3_00400_0600
	aS3_00500_0100
	aS3_00500_0200
	aS3_00500_0300
	aS3_00500_0400
	aS3_00500_0500
	aS3_00500_0600
	aS3_00600_0100
	aS3_00600_0200
	aS3_00600_0300
	aS3_00600_0400
	aS3_00600_0500
	aS3_00600_0600
	aS3_00700_0300
	aS3_00700_0400
	aS3_00700_0500
	aS3_00700_0600
	aS3_00800_0100
	aS3_00800_0300
	aS3_00800_0500
	aS3_00900_0100
	aS3_00900_0300
	aS3_00900_0500
	aS3_01000_0000
	aS3_01000_0200
	aS3_01000_0400
	aS3_01000_0600
	aS3_01001_0200
	aS3_01001_0400
	aS3_01001_0600
	aS3_01002_0200
	aS3_01002_0400
	aS3_01002_0600

	pS3_00100_0100
	pS3_00100_0200
	pS3_00100_0300
	pS3_00100_0400
	pS3_00100_0500
	pS3_00100_0600
	pS3_00200_0100
	pS3_00200_0200
	pS3_00200_0300
	pS3_00200_0400
	pS3_00200_0500
	pS3_00200_0600
	pS3_00300_0100
	pS3_00300_0200
	pS3_00300_0300
	pS3_00300_0400
	pS3_00300_0500
	pS3_00300_0600
	pS3_00400_0100
	pS3_00400_0200
	pS3_00400_0300
	pS3_00400_0400
	pS3_00400_0500
	pS3_00400_0600
	pS3_00500_0100
	pS3_00500_0200
	pS3_00500_0300
	pS3_00500_0400
	pS3_00500_0500
	pS3_00500_0600
	pS3_00600_0100
	pS3_00600_0200
	pS3_00600_0300
	pS3_00600_0400
	pS3_00600_0500
	pS3_00600_0600
	pS3_00700_0300
	pS3_00700_0400
	pS3_00700_0500
	pS3_00700_0600
	pS3_00800_0100
	pS3_00800_0300
	pS3_00800_0500
	pS3_00900_0100
	pS3_00900_0300
	pS3_00900_0500
	pS3_01000_0000
	pS3_01000_0200
	pS3_01000_0400
	pS3_01000_0600
	pS3_01001_0200
	pS3_01001_0400
	pS3_01001_0600
	pS3_01002_0200
	pS3_01002_0400
	pS3_01002_0600
	w
	j
	period_yrdays
	calyr_days
	period_actualdays
	period_adjuster
	calyear
	jan
	dec
	yrbegin
	yrend
	calyr_actualdays
	i
	missfirst1 - missfirst56
	calyr_sumprop
	propyr);

set lastrec_hhadata;

**merge with full s2s3 data set;
**s2s3 data set was processed by mcalconvert.sas and is now called lastrec_hhadata;

data hha_cpv_calyear;
merge hha_cpv_calyear(in=inhha)
      lastrec_hhadata(in=ins2);
 by rec_num;
 if inhha and ins2;

**compute proportion of visits for each provider to the total number of visits;
**this will be the weight that is multiplied by the cost-per-visit for each provider to compute the overall cost-per-visit;

if s3_othsvc_tot_visits=. then s3_othsvc_tot_visits=0;
total_minus_othsvc_visits = s3_total_tot_visits - s3_othsvc_tot_visits;

if S3_total_tot_visits > 0 then do;
  _pct_sn_visits	=S3_sn_tot_visits		/ S3_total_tot_visits;
  _pct_pt_visits	=S3_pt_tot_visits 		/ S3_total_tot_visits;
  _pct_ot_visits	=S3_ot_tot_visits 		/ S3_total_tot_visits;
  _pct_spchpath_visits	=S3_spchpath_tot_visits 	/ S3_total_tot_visits;
  _pct_medsocial_visits	=S3_medsocial_tot_visits 	/ S3_total_tot_visits;
  _pct_hhaide_visits	=S3_hhaide_tot_visits 		/ S3_total_tot_visits;

  if _pct_sn_visits>1		then _pct_sn_visits=.;
  if _pct_pt_visits>1		then _pct_pt_visits=.;
  if _pct_ot_visits>1		then _pct_ot_visits=.;
  if _pct_spchpath_visits>1	then _pct_spchpath_visits=.;
  if _pct_medsocial_visits>1	then _pct_medsocial_visits=.;
  if _pct_hhaide_visits>1	then _pct_hhaide_visits=.;

  _sn_share		=calyear_sn_avg_cpv		*_pct_sn_visits;
  _pt_share		=calyear_pt_avg_cpv		*_pct_pt_visits;
  _ot_share		=calyear_ot_avg_cpv		*_pct_ot_visits;
  _spchpath_share	=calyear_spchpath_avg_cpv	*_pct_spchpath_visits;
  _medsocial_share	=calyear_medsocial_avg_cpv	*_pct_medsocial_visits;
  _hhaide_share		=calyear_hhaide_avg_cpv		*_pct_hhaide_visits;

  _calyear_total_cpv = sum(of _sn_share _pt_share _ot_share _spchpath_share _medsocial_share _hhaide_share);
  _calyear_total_cpv=round(_calyear_total_cpv,0.001);

  if not(10<_calyear_total_cpv<8000) then _calyear_total_cpv=.;

  **if any of the percents of individual items are GT 1, make the _calyear_total_cpv missing since there is a mistake in an individual item;
  if max(of _pct_sn_visits _pct_pt_visits _pct_ot_visits _pct_spchpath_visits _pct_medsocial_visits _pct_hhaide_visits) > 1 then _calyear_total_cpv=.;
end;

if total_minus_othsvc_visits > 0 then do;
  pct_sn_visits	=S3_sn_tot_visits			/ total_minus_othsvc_visits;
  pct_pt_visits		=S3_pt_tot_visits 		/ total_minus_othsvc_visits;
  pct_ot_visits		=S3_ot_tot_visits 		/ total_minus_othsvc_visits;
  pct_spchpath_visits	=S3_spchpath_tot_visits 	/ total_minus_othsvc_visits;
  pct_medsocial_visits	=S3_medsocial_tot_visits 	/ total_minus_othsvc_visits;
  pct_hhaide_visits	=S3_hhaide_tot_visits 		/ total_minus_othsvc_visits;

  if pct_sn_visits>1		then pct_sn_visits=.;
  if pct_pt_visits>1		then pct_pt_visits=.;
  if pct_ot_visits>1		then pct_ot_visits=.;
  if pct_spchpath_visits>1	then pct_spchpath_visits=.;
  if pct_medsocial_visits>1	then pct_medsocial_visits=.;
  if pct_hhaide_visits>1	then pct_hhaide_visits=.;

  sn_share		=calyear_sn_avg_cpv		*pct_sn_visits;
  pt_share		=calyear_pt_avg_cpv		*pct_pt_visits;
  ot_share		=calyear_ot_avg_cpv		*pct_ot_visits;
  spchpath_share	=calyear_spchpath_avg_cpv	*pct_spchpath_visits;
  medsocial_share	=calyear_medsocial_avg_cpv	*pct_medsocial_visits;
  hhaide_share		=calyear_hhaide_avg_cpv		*pct_hhaide_visits;

  calyear_total_cpv = sum(of sn_share pt_share ot_share spchpath_share medsocial_share hhaide_share);
  calyear_total_cpv=round(calyear_total_cpv,0.001);

  if not(10<calyear_total_cpv<8000) then calyear_total_cpv=.;

  **if any of the percents of individual items are GT 1, make the calyear_total_cpv missing since there is a mistake in an individual item;
  if max(of pct_sn_visits pct_pt_visits pct_ot_visits pct_spchpath_visits pct_medsocial_visits pct_hhaide_visits) > 1 then calyear_total_cpv=.;
end;

proc sort data=hha_cpv_calyear out=hhaout.hha_cpv_calyear;
 by prov_id calyr_bgndt;
run;

proc contents varnum;
run;

%MEND MWRITEFL;

*====================================================================================================================;

%MC1WKSHT(yyear=1996);
%MC1WKSHT(yyear=1997);
%MC1WKSHT(yyear=1998);
%MC1WKSHT(yyear=1999);
%MC1WKSHT(yyear=2000);
%MC1WKSHT(yyear=2001);
%MC1WKSHT(yyear=2002);
%MC1WKSHT(yyear=2003);
%MC1WKSHT(yyear=2004);
%MC1WKSHT(yyear=2005);
%MC1WKSHT(yyear=2006);
%MC1WKSHT(yyear=2007);
%MC1WKSHT(yyear=2008);
%MC1WKSHT(yyear=2009);

%MMERGEYEARS;
%MCALENDAR;

%MSTDDEV(vvar=calyear_sn_avg_cpv); 
%MSTDDEV(vvar=calyear_pt_avg_cpv);
%MSTDDEV(vvar=calyear_ot_avg_cpv);
%MSTDDEV(vvar=calyear_spchpath_avg_cpv);
%MSTDDEV(vvar=calyear_medsocial_avg_cpv);
%MSTDDEV(vvar=calyear_hhaide_avg_cpv);

%MREMOVEOUTLIERS;
%MWRITEFL;
*====================================================================================================================;
