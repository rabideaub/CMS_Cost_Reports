/*************************************************************************************************************************
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	hosp.ccr.sas
#
#	Date Written:	June 10, 2011		
#
#	Purpose:	Gets Cost and Charges values for Hospital-Based SNFs
#			Joins these data with S2 and S3worksheet dataset from hosp.s2s3wkshts.sas 
#
#	Reads:		hosp_s2s3_1996_2009.sas7bdat		(from hosp.s2s3wkshts.sas)
#			hosp(year)nmrc.sas7bdat	   		(year=1996-2010, from inputhosp.sas)
#			hosp(year)rollup.sas7bdat  		(year=1996-2010, from inputhosp.sas)
#
#	Writes:		hosp_ccr_1996_2009.sas7bdat



	UPDATES: 
			1) BR 5/31/16: In 2010 some values have changed in the NMRC file. These are crosswalked and documented throughout
			2) BR 5/31/16: The rollup file is non-existent or unusable for some hosptypes from 2012 onwards. It seems possible
			   to make the cost-to-charge ratio without it, so for now it is just commented out.
			3) BR 9/6/16: Added new measures to estimate costs - Updated cost-to-charge ratio (CCR) using worksheet C due to
			   missing values in the D worksheets, and cost-per-diem (CPD) using the sum of inpatient and ancillary CPD variables.

**************************************************************************************************************************/

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname hospout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname out "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=======================================================================================================================;
data test_wksht;
	set hospsrc.hosp2010nmrc;
	if substr(nwksht,1,1)="C" |
	   substr(nwksht,1,2)="D1" |
	   substr(nwksht,1,2)="D3";
run;
proc freq data=test_wksht;
	tables nwksht;
run;

%MACRO MGETS2S3;

data s2s3irf
     s2s3ltch
     s2s3ach;
set hospout.hosp_s2s3_2010_2014;

format prov_type ho_sub1_prov_type ho_sub2_prov_type htype_.;

length sub 3.;
format sub sub_.;

**provider type=5: irf;
if prov_type=5 then do;
    sub=0;
    output s2s3irf;
end;
else if ho_sub1_prov_type=5 then do;
    sub=1;
    output s2s3irf;
end;
else if ho_sub2_prov_type=5 then do;
    sub=2;
    output s2s3irf;
end;

**provider type=2: general long term;
if prov_type=2 then do;
    sub=0;
    output s2s3ltch;
end;
else if ho_sub1_prov_type=2 then do;
    sub=1;
    output s2s3ltch;
end;
else if ho_sub2_prov_type=2 then do;
    sub=2;
    output s2s3ltch;
end;

**provider type=1: general short term;
if prov_type=1 then do;
    sub=0;
    output s2s3ach;
end;
else if ho_sub1_prov_type=1 then do;
    sub=1;
    output s2s3ach;
end;
else if ho_sub2_prov_type=1 then do;
    sub=2;
    output s2s3ach;
end;

/*Count IRFs*/
data test;
	set s2s3irf;
run;

proc sort data=test; by prov_id cost_yr; run;

data test;
	set test;
	by prov_id cost_yr;
	if first.cost_yr then counter=1;
run;

proc freq data=test;
 title 's2 irf';
 tables sub 
	prov_type
	ho_sub1_prov_type
	ho_sub2_prov_type
	counter
	counter*cost_yr;
run;
title;



*proc freq data=s2s3ltch;
* title 's2 ltch';
* tables prov_type;
*run;
*proc freq data=s2s3ach;
* title 's2 ach';
* tables prov_type;
*run;

%MEND MGETS2S3;

*=======================================================================================================================;
%MACRO MGETD1D4(yyear,hosptype);

/*Check subprovider worksheets*/
data test;
	set hospsrc.hosp&yyear.nmrc;
	if nwksht in ("D10C181","D12C181","D10C182","D12C182","D30C180","D32C180");
run;
title "Check Subprovider Worksheets";
proc freq data=test;
	tables nwksht;
run;
title;

data s2s3&hosptype._&yyear(keep=rec_num cost_yr fy_bgndt fy_enddt sub prov_type prev_pct_medicaredays prev_pct_medicaiddays);
	set s2s3&hosptype;
	if cost_yr=&yyear;
run;

data D1nmrc D4nmrc C1nmrc;
	set hospsrc.hosp&yyear.nmrc;

	**A indicates Hospital and 18 indicates Medicare;
	**1B indicates first subprovider and 2B indicates second subprovider;

	**Worksheet D1-Parts I and II;
	**Get Main provider and up to 2 subproviders;

	length sub 3.;

	if nwksht="D10A181" then do; 
	   sub=0;
	   output D1nmrc;
	end;
	else if nwksht="D10C181" then do; /* Changed from B to C for IRF subproviders BR 9/28/16*/
	   sub=2;
	   output D1nmrc;
	end;

	else if nwksht="D10A182" then do;
	   sub=0;
	   output D1nmrc;
	end;
	else if nwksht="D10C182" then do;  /*Changed from B to C for IRF subproviders BR 9/28/16*/
	   sub=2;
	   output D1nmrc;
	end;



	**Worksheet D4;
	**Get Main provider and up to 2 subproviders;

	/*BR 5/31/16: For 2010+ the codebook says: 
	wksht: D40A180=D30A180 
	line: 02700=03200, 02800=03300, 03100=04000-04200, 03800=05100*/

	if nwksht=/*"D40A180"*/ "D30A180" then do; /*BR 5/31/16*/
	   sub=0;
	   output D4nmrc;
	end;
	else if nwksht=/*"D41B180"*/ "D30C180" then do; /*I suspect these have changed as well but I can't find documentation BR 5/31/16. Changed from B to C for IRF subproviders BR 9/28/16*/
	   sub=2;
	   output D4nmrc;
	end;

	/*Worksheet C1*/ 							/*C1 worksheet added in 8/22/16. BR.*/
	/*Get Main provider*/
	if nwksht="C000001" & nline="03000" then do; /*Line 30 in sheet C1 is main provider. 11-18-16 BR.*/
	   sub=0;
	   output C1nmrc;
	end;
	if nwksht="C000001" & nline="04100" then do; /*Line 41 in sheet C1 is IRF subprovider. 11-18-16 BR.*/
	   sub=2;
	   output C1nmrc;
	end;

	%if "&hosptype."="irf" %then %do;
		title "Check the D3 IRF subprovider";
		proc print data=D4nmrc (obs=50);
			where nwksht in("D30C180") & nline in("20000");
		run;
		title;
		title "Check the C1 IRF subprovider";
		proc print data=C1nmrc (obs=50);
			where nwksht in("C000001") & nline in("04100");
		run;
		title;
	%end;
run;






/*WORKSHEET D1 - TRANSPOSE*/

/*Test merge values*/
data test;
	set d1nmrc;
	if rec_num=. then miss_rec=1;
run;
data test2;
	set s2s3&hosptype._&yyear.;
	if rec_num=. then miss_rec=1;
run;
proc freq data=test;
	tables miss_rec sub;
run;
proc freq data=test2;
	tables miss_rec sub;
run;


data D1nmrc(keep=rec_num prov_id sub fy_bgndt fy_enddt nlinecol nitem );
	merge D1nmrc(in=ind1) 
	      s2s3&hosptype._&yyear.(in=keep);
	 by rec_num sub;
	if ind1 and keep;

	length nlinecol $11.;
	nlinecol=nline || "_" || ncol;

	if ncol="00100" and nline in("02100" "02700" "02800" "03100" "03800" "00900" "00200"); 
run;


data
     dfydt(keep=rec_num prov_id sub fy_bgndt fy_enddt) 
     ditem(keep=rec_num nlinecol nitem);
set D1nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

proc transpose data=ditem 
     prefix=D1_
     out=titem(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

title "Cost and Charge Missing Check for &hosptype.";
proc means data=titem;
	var d1_02800_00100 d1_02700_00100;
run;
title;

proc print data=titem (obs=50); run;
	

data D1nmrc;
merge dfydt titem;
 by rec_num;

title "Check D1nmrc";
proc contents data=D1nmrc;
proc print data=D1nmrc (obs=100);
title;

/*WORKSHEET D4 - TRANSPOSE*/
data D4nmrc(keep=rec_num prov_id sub fy_bgndt fy_enddt nlinecol nitem );
merge D4nmrc(in=ind4) 
      s2s3&hosptype._&yyear.(in=keep);
 by rec_num sub;
if ind4 and keep;

*line 101= Total of ancillary, outpatient and other reimbursable cost centers;
*line 102= Less PBP clinic lab, line 45;
*lone 103= Net total of ancillary, outpatient and other reimbursable cost centers;
*col 2= Charges;
*col 3= costs;

if ncol in("00200" "00300") and nline in(/*"10100" "10300" "05700"*/"20000" "20200" "07400");

length nlinecol $11.;
nlinecol=nline || "_" || ncol;

data
     dfydt(keep=rec_num prov_id sub fy_bgndt fy_enddt) 
     ditem(keep=rec_num nlinecol nitem);
set D4nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

*proc contents data=ditem;

proc transpose data=ditem 
     prefix=D4_
     out=titem(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

data D4nmrc;
merge dfydt titem;
 by rec_num;

title "Check D4nmrc";
proc contents data=D4nmrc;
proc print data=D4nmrc (obs=100);
title;



/*WORKSHEET C1 - TRANSPOSE*/
title "Check C1 Merge";
data C1nmrc(keep=rec_num prov_id sub fy_bgndt fy_enddt nlinecol nitem );
	merge C1nmrc(in=inc1) 
	      s2s3&hosptype._&yyear.(in=keep);
	 by rec_num sub;
	if inc1 and keep;

	if ncol in("00500" "00800") and nline in("03000","04100"); /*03000 is main provider, 04100 is IRF subprovider*/

	length nlinecol $11.;
	nlinecol=nline || "_" || ncol;
run;
title;

data
     dfydt(keep=rec_num prov_id sub fy_bgndt fy_enddt) 
     ditem(keep=rec_num nlinecol nitem);
set C1nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

*proc contents data=ditem;

proc transpose data=ditem 
     prefix=C1_
     out=titem(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

data C1nmrc;
merge dfydt titem;
 by rec_num;

title "Check C1nmrc";
proc contents data=C1nmrc;
proc print data=C1nmrc (obs=100);
title;

*=======================================================================================================================;
**merge D1 nmrc file with D4 nmrc and D4 rollup files;

**note: D1 Line 28 does not equal D4 Line 25 or Line 31;

data D1d4_&yyear.;
merge D1nmrc D4nmrc C1nmrc/*d4rollup*/;	/*Try without rollup file for now. BR 5/31/16*/
 by rec_num;

**need to add line 57=renal dialysis to D4 rollup values for ancillary costs and Charges, line 57 is not in the rollup file;
Ancil_Charges = sum(of Ancil_Charges D4_05700_00200);
Ancil_Costs = sum(of Ancil_Costs D4_05700_00300);

if Ancil_Charges > 0 and Ancil_Costs ne . then do;
   Ancil_CCR = Ancil_Costs / Ancil_Charges;
   Ancil_CCR=round(Ancil_CCR,0.00001);
end;



%MEND MGETD1D4;

*=======================================================================================================================;
%MACRO MMERGEYEARS(hosptype);

data D&hosptype;
	merge 
	 d1d4_2010(in=in2010) d1d4_2011(in=in2011) d1d4_2012(in=in2012) d1d4_2013(in=in2013) d1d4_2014(in=in2014); 
	 by rec_num;

	 if in2010 then cost_yr=2010;
	 if in2011 then cost_yr=2011;
	 if in2012 then cost_yr=2012;
	 if in2013 then cost_yr=2013;
	 if in2014 then cost_yr=2014;


	/*In this section, d4 represents a worksheet in the nmrc workbook. It is added on as a prefix in a transpose statment above.
	  The 5 digit number is the line number from the nmrc for the corresponding wooksheet. The 4 digit number is the column number.
	  Changes have been made for line numbers for 2010+, and I've attempted to map the new values ONLY HERE because they are relevant for CCR calculations.
	  BR 5/31/16*/

	if /*d4_10300_0200*/ d4_20200_00200 > 0 and /*d4_10100_0300*/d4_20000_00300 ne . then do; /*It appears the codebook has changed, this is the new mapping. BR 5/31/16*/
	   Ancil_Outpt_Oth_CCR = /*d4_10100_0300*/d4_20000_00300 / /*d4_10300_0200*/ d4_20200_00200;
	   Ancil_Outpt_Oth_CCR = round(Ancil_Outpt_Oth_CCR,0.00001);
	end;
	if d1_02800_00100 >0 and d1_02700_00100 ne . then do;
	      Total_Charges = sum(of d1_02800_00100 /*d4_10100_0200*/ d4_20000_00200); /*It appears the codebook has changed, this is the new mapping. BR 5/31/16*/
	      Total_Costs = sum(of d1_02700_00100 /*d4_10100_0300*/d4_20000_00300); /*It appears the codebook has changed, this is the new mapping. BR 5/31/16*/
	      Total_CCR = sum(of d1_02700_00100 /*d4_10100_0300*/d4_20000_00300) / sum(of d1_02800_00100 /*d4_10100_0200*/ d4_20000_00200); /*It appears the codebook has changed, this is the new mapping. BR 5/31/16*/
	      Total_CCR = round(Total_CCR,0.00001);
	      InptRtn_Ancil_Charges = sum(of d1_02800_00100 ancil_Charges);
	      InptRtn_Ancil_Costs = sum(of d1_02700_00100 Ancil_Costs);
	      InptRtn_Ancil_CCR = sum(of d1_02700_00100 Ancil_Costs) / sum(of d1_02800_00100 ancil_Charges);
	      InptRtn_Ancil_CCR = round(InptRtn_Ancil_CCR,0.00001);
	end;

	/*Test the CCR from the C1 sheets of the cost-reports. Hopefully less missing raw data*/
	if sub=0 & c1_03000_00600>0 & c1_03000_00500~=. then do;
		Total_CCR_c=sum(c1_03000_00500,d4_20000_00300) / sum(c1_03000_00600,d4_20000_00200);
		Total_CCR_c=round(Total_CCR_c,0.00001);
	end;
	if sub=2 & c1_04100_00800>0 & c1_04100_00500~=. then do;
		Total_CCR_c=sum(c1_04100_00500,d4_20000_00300) / sum(c1_04100_00600,d4_20000_00200);
		Total_CCR_c=round(Total_CCR_c,0.00001);
	end;

	/*Create a Cost-Per-Diem variable summing the CPD of inpatient and ancillary services*/
	if d1_03800_00100>0 & d4_20000_00300>0 & d1_00200_00100>0 then do;
		inpatient_cpd=d1_03800_00100;
		ancillary_cpd=d4_20000_00300/d1_00200_00100; /*total ancillary costs/total inpatient days*/
		total_cpd=inpatient_cpd + ancillary_cpd;
	end;

	/*Inpatient Routine Service CCR*/
	if inptrtn_ccr=. then do;
	   if d1_02800_00100 > 0 and d1_02700_00100 > 0 then do;
	      inptrtn_ccr = d1_02700_00100  / d1_02800_00100;
	      inptrtn_ccr=round(inptrtn_ccr,0.00001);
	   end;
	end;    

	***trim outlying CCR values;
	***first restrict values to < 10 and > 0.1;
	***then restrict to within 4 std devs of mean value of CCR for given year;

	if not(0.1<InptRtn_CCR<=10) then InptRtn_CCR =.;
	if not(10<=InptRtn_CPD<=20000) then InptRtn_CPD=.;
	if not(0.1<Ancil_CCR<=10) then Ancil_CCR =.;
	if not(0.1<Ancil_Outpt_Oth_CCR<=10) then Ancil_Outpt_Oth_CCR =.;
	if not(0.1<InptRtn_Ancil_CCR<=10) then InptRtn_Ancil_CCR =.;
	*if not(0.1<Total_CCR<=10) then Total_CCR =.;

run;

/*Winsorize within 4 standard deviations of the mean*/
proc print data=D&hosptype. (obs=50); run;

proc means data=D&hosptype noprint;
 var InptRtn_CCR;
 output out=omeans1 stddev=stddev1 mean=mean1;
 class cost_yr;
run;
proc means data=D&hosptype noprint;
 var InptRtn_CPD;
 output out=omeans2 stddev=stddev2 mean=mean2;
 class cost_yr;
run;
proc means data=D&hosptype noprint;
 var Ancil_CCR;
 output out=omeans3 stddev=stddev3 mean=mean3;
 class cost_yr;
run;
proc means data=D&hosptype noprint;
 var Ancil_Outpt_Oth_CCR;
 output out=omeans4 stddev=stddev4 mean=mean4;
 class cost_yr;
run;
proc means data=D&hosptype noprint;
 var InptRtn_Ancil_CCR;
 output out=omeans5 stddev=stddev5 mean=mean5;
 class cost_yr;
run;
proc means data=D&hosptype noprint;
 var Total_CCR;
 output out=omeans6 stddev=stddev6 mean=mean6;
 class cost_yr;
run;

proc sort data=D&hosptype;
 by cost_yr;
run;

data D&hosptype(drop=
     pos4sd_1 - pos4sd_6
     neg4sd_1 - neg4sd_6
     _TYPE_
     _FREQ_
     mean1 - mean6
     stddev1 - stddev6);

	merge D&hosptype 
	      omeans1
	      omeans2
	      omeans3
	      omeans4
	      omeans5
	      omeans6;
	 by cost_yr;

	pos4sd_1		=mean1 +		(4 * stddev1);
	pos4sd_2		=mean2 +		(4 * stddev2);
	pos4sd_3		=mean3 +		(4 * stddev3);
	pos4sd_4		=mean4 +		(4 * stddev4);
	pos4sd_5		=mean5 +		(4 * stddev5);
	pos4sd_6		=mean6 +		(4 * stddev6);

	neg4sd_1		=mean1 -		(4 * stddev1);
	neg4sd_2		=mean2 -		(4 * stddev2);
	neg4sd_3		=mean3 -		(4 * stddev3);
	neg4sd_4		=mean4 -		(4 * stddev4);
	neg4sd_5		=mean5 -		(4 * stddev5);
	neg4sd_6		=mean6 -		(4 * stddev6);

	if not(neg4sd_1 <= InptRtn_CCR <= pos4sd_1)			then InptRtn_CCR = .;
	else if InptRtn_CCR < 0 then InptRtn_CCR =.;

	if not(neg4sd_2 <= InptRtn_CPD <= pos4sd_2)			then InptRtn_CPD = .;
	else if InptRtn_CPD < 0 then InptRtn_CPD =.;

	if not(neg4sd_3 <= Ancil_CCR <= pos4sd_3)			then Ancil_CCR = .;
	else if Ancil_CCR < 0 then Ancil_CCR =.;

	if not(neg4sd_4 <= Ancil_Outpt_Oth_CCR <= pos4sd_4)		then Ancil_Outpt_Oth_CCR = .;
	else if Ancil_Outpt_Oth_CCR < 0 then Ancil_Outpt_Oth_CCR =.;

	if not(neg4sd_5 <= InptRtn_Ancil_CCR <= pos4sd_5)		then InptRtn_Ancil_CCR = .;
	else if InptRtn_Ancil_CCR < 0 then InptRtn_Ancil_CCR =.;

	/*if not(neg4sd_6 <= Total_CCR <= pos4sd_6)			then Total_CCR = .;
	else if Total_CCR < 0 then Total_CCR =.;*/
run;

title "CHECKPOINT1 &hosptype.";
proc means data=D&hosptype.;
	class cost_yr;
	var d1_02800_00100 d1_02700_00100 d1_03100_00100 d1_03800_00100 c1_03000_00500 c1_03000_00800;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d4_20200_00200 / missing;
	where d4_20200_00200=. | d4_20200_00200<=0;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d4_20000_00300 / missing;
	where d4_20000_00300=. | d4_20000_00300<=0;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d1_02800_00100 / missing;
	where d1_02800_00100=. | d1_02800_00100<=0;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d1_02700_00100 / missing;
	where d1_02700_00100=.;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d1_03100_00100 / missing;
	where d1_03100_00100=.;
run;

proc freq data=D&hosptype.;
	tables cost_yr*d1_03800_00100 / missing;
	where d1_03800_00100=.;
run;

proc freq data=D&hosptype.;
	tables cost_yr*c1_03000_00500 / missing;
	where c1_03000_00500=.;
run;

proc freq data=D&hosptype.;
	tables cost_yr*c1_03000_00800 / missing;
	where c1_03000_00800=.;
run;

proc freq data=D&hosptype.;
	tables cost_yr*Total_CCR_c / missing;
	where Total_CCR_c=.;
run;

proc means data=D&hosptype.;
	var total_ccr Total_CCR_c;
run;
title;

%MEND MMERGEYEARS;
*=======================================================================================================================;

%MACRO MACCALENDAR(hosptype);

data D&hosptype;
set D&hosptype;

length w 3.;

if (fy_bgndt<=mdy(01,01,2010)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2010)<=fy_enddt) then do; w=2010; output D&hosptype; end;
if (fy_bgndt<=mdy(01,01,2011)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2011)<=fy_enddt) then do; w=2011; output D&hosptype; end;
if (fy_bgndt<=mdy(01,01,2012)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2012)<=fy_enddt) then do; w=2012; output D&hosptype; end;
if (fy_bgndt<=mdy(01,01,2013)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2013)<=fy_enddt) then do; w=2013; output D&hosptype; end;
if (fy_bgndt<=mdy(01,01,2014)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2014)<=fy_enddt) then do; w=2014; output D&hosptype; end;

data D&hosptype;
set D&hosptype;

jan2010=mdy(01,01,2010);
jan2011=mdy(01,01,2011);
jan2012=mdy(01,01,2012);
jan2013=mdy(01,01,2013);
jan2014=mdy(01,01,2014);

dec2010=mdy(12,31,2010);
dec2011=mdy(12,31,2011);
dec2012=mdy(12,31,2012);
dec2013=mdy(12,31,2013);
dec2014=mdy(12,31,2014);

j=w-2009; /*was 1995. BR 5/31/16*/
prov_id_w=prov_id || w;

proc sort data=D&hosptype; 
 by prov_id_w;
run;

data D&hosptype;
set D&hosptype;
 by prov_id_w;
retain totcaldays;

array ajan{5} /*Was 14 BR 5/31/16*/
      jan2010 - jan2014; /*Was jan and dec1996. BR 5/31/16*/

array adec{5}
      dec2010 - dec2014;

jan=ajan{j};
dec=adec{j};

wbegin=max(of fy_bgndt jan);
wend=min(of fy_enddt dec);

wreportdays=(wend - wbegin) + 1;

if first.prov_id_w then do;
   totcaldays=0;
end;
totcaldays=totcaldays + wreportdays;

data L&hosptype(keep=prov_id_w totcaldays);
set D&hosptype;
 by prov_id_w;

if last.prov_id_w then output L&hosptype;

data L&hosptype/*(drop=
    w
	jan2010
	jan2011
	jan2012
	jan2013

	dec2010
	dec2011
	dec2012
	dec2013
    j
    jan
    dec
    wbegin
    wend
    wreportdays
    propw
    rccr
    rcpd
    accr
    aooccr
    iaccr
    totccr
    _medicaid
    _medicare
    part_rtnccr
    part_rtncpd
    part_accr
    part_aooccr
    part_iaccr
    part_totccr
    part_medicare
    part_medicaid)*/;

merge L&hosptype
    D&hosptype(rename =(
    d1_02100_00100       =InptRtn_withSwing_Cost
    d1_02700_00100       =InptRtn_Costs
    d1_02800_00100       =InptRtn_Charges

    /*d4_10100_00200*/  /*d4_20000_00200       =Ancil_Outpt_Oth_WithPBP_Charges*/ /*BR 5/31/16*/
    /*d4_10100_00300*/d4_20000_00300       =Ancil_Outpt_Oth_Costs /*BR 5/31/16*/
    /*d4_10300_00200*/d4_20200_00200       =Ancil_Outpt_Oth_Charges)); /*BR 5/31/16*/

 by prov_id_w;

length year 3.;
retain
     cal_InptRtn_CCR 
     cal_InptRtn_CPD 
     cal_Ancil_CCR 
     Cal_Ancil_Outpt_Oth_CCR 
     cal_InptRtn_Ancil_CCR 
     cal_Total_CCR 
	 cal_Total_CCR_c
	 cal_Total_CPD

     prev_cal_pct_medicaredays 
     prev_cal_pct_medicaiddays 

     part_rtnccr 
     part_rtncpd 
     part_accr
     part_aooccr
     part_iaccr
     part_totccr 
	 part_totccrc
	 part_totcpd
     part_medicare 
     part_medicaid;

if first.prov_id_w then do;
     cal_InptRtn_CCR=.; 
     cal_InptRtn_CPD=.;  
     cal_Ancil_CCR=.;  
     Cal_Ancil_Outpt_Oth_CCR=.;  
     cal_InptRtn_Ancil_CCR=.;  
     cal_Total_CCR=.; 
	 cal_Total_CCR_c=.;
	 cal_Total_CPD=.; 

     prev_cal_pct_medicaredays=.;  
     prev_cal_pct_medicaiddays=.;  

     part_rtnccr=.;  
     part_rtncpd=.;  
     part_accr=.;
     part_aooccr=.;
     part_iaccr=.;
     part_totccr=.;  
	 part_totccrc=.;
	 part_totcpd=.;
     part_medicare=.;  
     part_medicaid=.; 
end;

if totcaldays>0 then propw=wreportdays / totcaldays;

if InptRtn_CCR ne . then do;
   rccr=InptRtn_CCR * propw; 
   part_rtnccr=sum(of part_rtnccr propw);
end; 
if InptRtn_CPD ne . then do;
   rcpd=InptRtn_CPD * propw; 
   part_rtncpd=sum(of part_rtncpd propw);
end;
if Ancil_CCR ne . then do;
   accr=Ancil_CCR * propw; 
   part_accr=sum(of part_accr propw);
end;
if Ancil_Outpt_Oth_CCR ne . then do;
   aooccr=Ancil_Outpt_Oth_CCR * propw; 
   part_aooccr=sum(of part_aooccr propw);
end;
if InptRtn_Ancil_CCR ne . then do;
   iaccr=InptRtn_Ancil_CCR * propw; 
   part_iaccr=sum(of part_iaccr propw);
end;
if Total_CCR ne . then do;
   totccr=Total_CCR * propw; 
   part_totccr=sum(of part_totccr propw);
end;
if Total_CCR_c ne . then do;
   totccrc=Total_CCR_c * propw; 
   part_totccrc=sum(of part_totccrc propw);
end;
if Total_CPD ne . then do;
   totcpd=Total_CPD * propw; 
   part_totcpd=sum(of part_totcpd propw);
end;
if prev_pct_medicaiddays ne . then do;
   _medicaid=prev_pct_medicaiddays * propw;
   part_medicaid=sum(of part_medicaid propw);
end;
if prev_pct_medicaredays ne . then do;
   _medicare=prev_pct_medicaredays * propw;
   part_medicare=sum(of part_medicare propw);
end;

cal_InptRtn_CCR		=sum(of cal_InptRtn_CCR rccr);
cal_InptRtn_CPD		=sum(of cal_InptRtn_CPD rcpd);
cal_Ancil_CCR		=sum(of cal_Ancil_CCR accr);
Cal_Ancil_Outpt_Oth_CCR	=sum(of Cal_Ancil_Outpt_Oth_CCR aooccr);
cal_InptRtn_Ancil_CCR	=sum(of cal_InptRtn_Ancil_CCR iaccr);
cal_Total_CCR		=sum(of cal_Total_CCR totccr);
cal_Total_CCR_c		=sum(of cal_Total_CCR_c totccrc);
cal_Total_CPD		=sum(of cal_Total_CPD totcpd);

prev_cal_pct_medicaredays	=sum(of prev_cal_pct_medicaredays _medicare);
prev_cal_pct_medicaiddays	=sum(of prev_cal_pct_medicaiddays _medicaid);

if last.prov_id_w then do;
	if part_rtnccr>0 then cal_InptRtn_CCR			=cal_InptRtn_CCR		* (1 / part_rtnccr);
	if part_rtncpd>0 then cal_InptRtn_CPD			=cal_InptRtn_CPD		* (1 / part_rtncpd);
	if part_accr>0 then cal_Ancil_CCR			=cal_Ancil_CCR			* (1 / part_accr);

	if part_aooccr>0 then cal_Ancil_Outpt_Oth_CCR		=cal_Ancil_Outpt_Oth_CCR	* (1 / part_aooccr);
	if part_iaccr>0 then cal_InptRtn_Ancil_CCR		=cal_InptRtn_Ancil_CCR		* (1 / part_iaccr);


	if part_totccr>0 then cal_Total_CCR			=cal_Total_CCR			* (1 / part_totccr);
	if part_totccrc>0 then cal_Total_CCR_c		=cal_Total_CCR_c		* (1 / part_totccrc);
	if part_totcpd>0 then cal_Total_CPD			=cal_Total_CPD			* (1 / part_totcpd);

	if part_medicare>0 then prev_cal_pct_medicaredays	=prev_cal_pct_medicaredays	* (1 / part_medicare);
	if part_medicaid>0 then prev_cal_pct_medicaiddays	=prev_cal_pct_medicaiddays	* (1 / part_medicaid);
	year=w;
	output L&hosptype;
end;

proc sort data=L&hosptype;
 by rec_num;
run;

**merge with full s2s3 data set;

data out.&hosptype._ccr_2010_2014;
merge
  s2s3&hosptype
  L&hosptype(in=inlast);
 by rec_num;
 if inlast;

label
    prov_id				="Provider ID"
    rec_num                  		="Rec Num"

    InptRtn_withSwing_Cost		="D1-L21-C1: Inpt Rtn Svc Costs"
    InptRtn_Costs			="D1-L27-C1: Inpt Rtn Svc Costs Net Swing-Beds"
    InptRtn_Charges			="D1-L28-C1: Inpt Rtn Svc Charges Net Swing-Beds"
    InptRtn_CCR				="D1-L31-C1: Inpt Rtn Svc CCR"
    InptRtn_CPD				="D1-L38-C1: Inpt Rtn Svc CPD"

    Ancil_Outpt_Oth_WithPBP_Charges	="D4-L101-C2: Ancil +Outpt +Oth +PBP Charges"
    Ancil_Outpt_Oth_Costs		="D4-L101-C3: Ancil +Outpt +Oth Costs"
    Ancil_Outpt_Oth_Charges		="D4-L103-C2: Ancil +Outpt +Oth Charges"

    Ancil_Outpt_Oth_CCR	     		="Ancillary + Outpt + Other CCR"
    Ancil_Charges	     		="Ancillary Charges"
    Ancil_Costs		     		="Ancillary Costs"
    Ancil_CCR		     		="Ancillary CCR"

    Total_CCR		     		="Inpt + Ancil + Outpt + Other CCR"
    Total_Charges	     		="Inpt + Ancil + Outpt + Other Charges"
    Total_Costs		     		="Inpt + Ancil + Outpt + Other Costs"
    InptRtn_Ancil_Charges    		="Inpt + Ancillary Charges" 
    InptRtn_Ancil_Costs	     		="Inpt + Ancillary Costs" 
    InptRtn_Ancil_CCR	     		="Inpt + Ancillary CCR" 

    cal_InptRtn_CCR			="&hosptype Cal Yr Inpt Routine CCR"
    cal_InptRtn_CPD			="&hosptype Cal Yr Inpt Routine CPD"
    cal_Ancil_CCR			="&hosptype Cal Yr Ancillary CCR"
    cal_Ancil_Outpt_Oth_CCR		="&hosptype Cal Yr Ancillary+Outpt+Oth CCR"
    cal_InptRtn_Ancil_CCR		="&hosptype Cal Yr Inpt Rtn+Ancillary CCR"
    cal_Total_CCR			="&hosptype Cal Yr Inpt Rtn+Ancil+Outpt+Oth CCR"

    prev_cal_pct_medicaredays    	="&hosptype Prev Cal Yr % Medicare Days"
    prev_cal_pct_medicaiddays    	="&hosptype Prev Cal Yr % Medicaid Days"

    prev_medicaredays			="&hosptype Prev Medicare Days"
    prev_medicaiddays			="&hosptype Prev Medicaid Days"

    pct_medicaredays			="&hosptype % Medicare Days"
    pct_medicaiddays			="&hosptype % Medicaid Days"

    prev_pct_medicaredays		="&hosptype Prev % Medicare Days"
    prev_pct_medicaiddays		="&hosptype Prev % Medicaid Days"
    ;

proc contents varnum;
run;

%MEND MACCALENDAR;

*=======================================================================================================================;
%mgets2s3;

%mgetd1d4(2010,irf);
%mgetd1d4(2011,irf);
%mgetd1d4(2012,irf);
%mgetd1d4(2013,irf);
%mgetd1d4(2014,irf);

%mmergeyears(irf);
%maccalendar(irf);

*=======================================================================================================================;
%mgetd1d4(2010,ltch);
%mgetd1d4(2011,ltch);
%mgetd1d4(2012,ltch);
%mgetd1d4(2013,ltch);
%mgetd1d4(2014,ltch);

%mmergeyears(ltch);
%maccalendar(ltch);

*=======================================================================================================================;
%mgetd1d4(2010,ach);
%mgetd1d4(2011,ach);
%mgetd1d4(2012,ach);
%mgetd1d4(2013,ach);
%mgetd1d4(2014,ach);

%mmergeyears(ach);
%maccalendar(ach);

*=======================================================================================================================;
