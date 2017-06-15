**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	snfccr.sas
#
#	Must follow:	inputsnf.sas
#	     		snf.s2s3wkshts.sas
#
#	Date Written:	May 12, 2011		
#
#	Purpose:	Gathers Cost variables from worksheets and uses them to compute cost outcomes
#
#	Reads:		/data/postacute/RAND/SNF/srcdata/snfYEARnmrc.sas7bdat		(YEAR=1996-2009)
#			/data/postacute/RAND/SNF/outdata/snfs2s3_1996_2009.sas7bdat
#
#	Writes:		/data/postacute/RAND.SNF/outdata/snf_ccr_1996_2009.sas7bdat
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname snfsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname snfout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname out "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=================================================================================================================================================;
*Program gets these items and computes these sums:

*=================================================================================================================================================;
**B-PartI NMRC:
  Col 18 Line 16=SNF Total Cost
  Col 18 Line 18=NF Total Cost

**B-Part I ROLLUP:
  Col 18 Line 18=NF Total Cost
  Col 18 Lines 21-33=Ancillary Total Cost

b_sum_ancil_cost (sum of ancillary costs) = sum of:
  Col 18 Lines 21-33=Ancillary Total Cost

*=================================================================================================================================================;
**C ROLLUP:
  Col 2 Line 21=Radiology Charges
  Col 2 Line 22=Laboratory Charges
  Col 2 Line 23=IV Therapy Charges
  Col 2 Line 24=Oxygen Therapy Charges
  Col 2 Line 25=Physical Therapy Charges
  Col 2 Line 26=Occupational Therapy Charges
  Col 2 Line 27=Speech Pathology Charges
  Col 2 Line 28=Electrocardiology Charges
  Col 2 Line 29=Medicdal Supplies Charged Charges
  Col 2 Line 30=Drugs Charged to Patients Charges
  Col 2 Line 31=Dental Care Title 19 only Charges
  Col 2 Line 32=Support Surfaces Charges
  Col 2 Line 33=Other Ancillary Service Cost Charges

c_sum_ancil_chrg (sum of ancillary charges) = sum of:
  Col 2 Line 21=Radiology Charges
  Col 2 Line 22=Laboratory Charges
  Col 2 Line 23=IV Therapy Charges
  Col 2 Line 24=Oxygen Therapy Charges
  Col 2 Line 25=Physical Therapy Charges
  Col 2 Line 26=Occupational Therapy Charges
  Col 2 Line 27=Speech Pathology Charges
  Col 2 Line 28=Electrocardiology Charges
  Col 2 Line 29=Medicdal Supplies Charged Charges
  Col 2 Line 30=Drugs Charged to Patients Charges
  Col 2 Line 31=Dental Care Title 19 only Charges
  Col 2 Line 32=Support Surfaces Charges
  Col 2 Line 33=Other Ancillary Service Cost Charges

*=================================================================================================================================================;
**G2-PartI NMRC: 
  Col 1 Line 1=SNF Inpatient Revenue
  Col 1 Line 5=Total general inpatient care services Inpatient Revenue
  Col 1 Line 6=Ancillary services Inpatient Revenue
  Col 1 Line 14=Total patient revenues (sum of Lines 5-13) Inpatient Revenue

  Col 1 Line 6=Ancillary services Outpatient Revenue
  Col 1 Line 14=Total patient revenues (sum of Lines 5-13) Outpatient Revenue

  Col 3 Line 14=Total patient revenues (sum of Lines 5-13) Inpatient + Outpatient Revenue

g2_sum_ancil_rev (sum of ancillary revenue) = sum of:
  Col 1 Line 6=Ancillary services Inpatient Revenue
  Col 1 Line 6=Ancillary services Outpatient Revenue

**G2-Part I ROLLUP: Col 1: Lines 1,3

*=================================================================================================================================================;
proc freq data=snfout.snf_s2s3_2010_2014;
	tables bgn_yr;
run;


%MACRO MGETS2(YYEAR);

data s2s3_&yyear.;
set snfout.snf_s2s3_2010_2014;

if bgn_yr=&yyear.;

%MEND MGETS2;

*=================================================================================================================================;
%MACRO MGETNMRC(YYEAR);

**use B part I, not D1 part I, which is sometimes missing;

data bnmrc /*b0nmrc*/ g2nmrc cnmrc;
set snfsrc.snf&yyear.nmrc;

     if nwksht="B000001" then output bnmrc;
*else if nwksht="B000001" then output b0nmrc; /*Added to remove rollup variables. BR 6-23-16*/
else if nwksht="G200001" then output g2nmrc;
else if nwksht="C000000" then output cnmrc;

*=================================================================================================================================;
data Bnmrc(keep=rec_num nline nlinecol nitem);
	merge Bnmrc(in=inb)
	      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id S3_00100_0700);
	 by rec_num;
	if inb and keep;

	**B Part I col 18, line 16=SNF cost allocation (general service costs), line 75=Total cost allocation (general service costs);
	%if &yyear.<2011 %then %do;
		if ncol="1800" and nline in("03000" "10000" "03100"); /*The lines used to be 01600 and 07500 pre-xwalk. BR 6-23-16*/
	%end;

	%if &yyear.>=2011 %then %do;
		if ncol="01800" and nline in("03000" "10000" "03100"); /*The lines used to be 01600 and 07500 pre-xwalk. BR 6-23-16*/
	%end;
	/*03100 originally came from the rollup before it was discontinued. B_1_C18_18 for v96, xwalked to B_1_C18_31 in v10*/

	%if &yyear.<2011 %then %do;
		length nlinecol $9.;
	%end;

	%if &yyear.>=2011 %then %do;
		length nlinecol $10.;
	%end;
	nlinecol=nline || ncol;
run;

title "Checkpoint 1 &yyear.";
proc freq data=bnmrc;
	tables nline nlinecol;
run;

proc means data=bnmrc;
	var nitem;
	where nlinecol='100001800' | nlinecol='1000001800';
run;
title;

*=================================================================================================================================;
data Cnmrc(keep=rec_num nline nlinecol nitem);
merge Cnmrc(in=inb)
      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id);
 by rec_num;
if inb and keep;

**C col 1, line 75=ancillary and outpatient cost centers total costs
**C col 2, line 75=ancillary and outpatient cost centers total charges;

%if &yyear.<2011 %then %do;
	if ncol in("0100" "0200") and nline="10000"; /*Used to be line 07500 (columns are the same for C). BR 6-23-16*/
%end;

%if &yyear.>=2011 %then %do;
	if ncol in("00100" "00200") and nline="10000"; /*Used to be line 07500 (columns are the same for C). BR 6-23-16*/
%end;

%if &yyear.<2011 %then %do;
	length nlinecol $9.;
%end;

%if &yyear.>=2011 %then %do;
	length nlinecol $10.;
%end;

nlinecol=nline || ncol;

*=================================================================================================================================;
data G2nmrc(keep=rec_num nline nlinecol nitem );
merge G2nmrc(in=ing)
      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id);
 by rec_num;
if ing and keep;
    
%if &yyear.<2011 %then %do; 
	length nlinecol $9.;
%end;

%if &yyear.>=2011 %then %do;
	length nlinecol $10.;
%end;

nlinecol=nline || ncol;

**get G2 line 1 col 1 from rollup;
**get ancillary values and total values here;

%if &yyear.<2011 %then %do; 
if ncol="0100" then do;
   if nline="00600" then output g2nmrc;
   else if nline="01400" then output g2nmrc;
   else if nline="00100" then output g2nmrc; /*Added to replace rollup variable. BR 6-24-16*/
   else if nline="00200" then output g2nmrc; /*Added to replace rollup variable. BR 6-24-16*/
end;
else if ncol="0200" then do;
   if nline="00600" then output g2nmrc;
   else if nline="01400" then output g2nmrc;
end;
else if ncol="0300" then do;
   if nline="01400" then output g2nmrc;
end;
%end;

%if &yyear.>=2011 %then %do; 
if ncol="00100" then do;
   if nline="00600" then output g2nmrc;
   else if nline="01400" then output g2nmrc;
   else if nline="00100" then output g2nmrc; /*Added to replace rollup variable. BR 6-24-16*/
   else if nline="00200" then output g2nmrc; /*Added to replace rollup variable. BR 6-24-16*/
end;
else if ncol="00200" then do;
   if nline="00600" then output g2nmrc;
   else if nline="01400" then output g2nmrc;
end;
else if ncol="00300" then do;
   if nline="01400" then output g2nmrc;
end;
%end;

*=================================================================================================================================;

proc transpose data=bnmrc
     	       prefix=b_cost_
     	       out=tbnmrc(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

proc transpose data=cnmrc
     	       prefix=c_
     	       out=tcnmrc(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

proc transpose data=g2nmrc
     	       prefix=g2_rev_
     	       out=tg2nmrc(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

title "Check Costs &yyear.";
proc means data=tbnmrc;
	var b_cost_0310001800 b_cost_1000001800;
run;
title;

*=================================================================================================================================;
**merge B-PartI, G2-PartI nmrc files;

data BCGnmrc;
merge tbnmrc tcnmrc tg2nmrc;
 by rec_num;

%MEND MGETNMRC;

*=================================================================================================================================;
%MACRO MGETROLLUP(YYEAR);

/*data G2rollup(keep=rec_num rolabel roitem) 
     Brollup(keep=rec_num rolabel roitem) 
     Crollup(keep=rec_num rolabel roitem);
set snfsrc.snf&yyear.rollup;

*B Part I rollup=Costs, C rollup=Charges, G2 Part I=Revenue;

if ROLABEL  in("G2_1_C1_1" "G2_1_C1_3") then output G2rollup;
else if ROLABEL in(
	"B_1_C18_18"
	"B_1_C18_21"
	"B_1_C18_22"
	"B_1_C18_23"
	"B_1_C18_24"
	"B_1_C18_25"
	"B_1_C18_26"
	"B_1_C18_27"
	"B_1_C18_28"
	"B_1_C18_29"
	"B_1_C18_30"
	"B_1_C18_31"
	"B_1_C18_32"
	"B_1_C18_33") then output Brollup;			*SNF, NF, Ancillary costs;
else if ROLABEL in(
	"C_C2_21"
	"C_C2_22"
	"C_C2_23"
	"C_C2_24"
	"C_C2_25"
	"C_C2_26"
	"C_C2_27"
	"C_C2_28"
	"C_C2_29"
	"C_C2_30"
	"C_C2_31"
	"C_C2_32"
	"C_C2_33") then output Crollup;				*Ancillary charges;

data Brollup;
merge brollup(in=inb)
      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id);
 by rec_num;
 if inb and keep;

data Crollup;
merge crollup(in=inc)
      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id);
 by rec_num;
 if inc and keep;

data G2rollup;
merge g2rollup(in=ing)
      s2s3_&yyear.(in=keep keep=rec_num prov_id snf_prov_id);
 by rec_num;
 if ing and keep;

data BCGrollup;
merge Brollup Crollup G2rollup;
 by rec_num rolabel;

proc transpose data=BCGrollup
          out=TBCGrollup(drop= _NAME_);
 id rolabel;
 by rec_num;
run;

data TBCGrollup;
set TBCGrollup;

b_sum_ancil_cost	=sum(of 
	B_1_C18_21
	B_1_C18_22
	B_1_C18_23
	B_1_C18_24
	B_1_C18_25
	B_1_C18_26
	B_1_C18_27
	B_1_C18_28
	B_1_C18_29
	B_1_C18_30
	B_1_C18_31
	B_1_C18_32
	B_1_C18_33);

c_sum_ancil_chrg	=sum(of
	C_C2_21
	C_C2_22
	C_C2_23
	C_C2_24
	C_C2_25
	C_C2_26
	C_C2_27
	C_C2_28
	C_C2_29
	C_C2_30
	C_C2_31
	C_C2_32
	C_C2_33);*/

%if &yyear.>=2011 %then %do; /*Standardize the names here so that it matches with the line/col lengths from pre-2011*/
data BCGnmrc;
	set BCGnmrc;
	rename b_cost_0310001800=b_cost_031001800
		   g2_rev_0020000100=g2_rev_002000100
		   b_cost_0300001800=b_cost_030001800
		   g2_rev_0010000100=g2_rev_001000100
		   b_cost_1000001800=b_cost_100001800
		   g2_rev_0140000300=g2_rev_014000300; /*Removed the leading 0 from the col section of the line_col name (6th digit)*/
run;
%end;
		   
	
data snfccr_&yyear.;
	merge BCGnmrc(in=innmrc) /*TBCGrollup*/ s2s3_&yyear.;
	 by rec_num;

	g2_sum_ancil_rev		=sum(of g2_rev_006000100 g2_rev_006000200);

	if g2_rev_002000100 > 0 then do;
	   nf_ccr     =b_cost_031001800/g2_rev_002000100;     /*Was previously B_1_C18_18 / G2_1_C1_3 using the rollup vars from v96*/
	   nf_ccr=round(nf_ccr,0.00001);
	end;

	if g2_rev_001000100 >0 then do;
	   snf_ccr     = b_cost_030001800/g2_rev_001000100;		/*Was previously b_cost_016001800   / G2_1_C1_1 using the rollup vars from v96*/
	   snf_ccr = round(snf_ccr,0.00001);
	end;

	if g2_rev_014000300>0 then do;
	   total_ccr = b_cost_100001800/g2_rev_014000300;		/*Was previously b_cost_075001800 / g2_rev_014000300 using the vars from v96*/
	   total_ccr = round(total_ccr,0.00001);
	end;

	if s3_00100_0700>0 then do;								/*Calculate a SNF cost per day variable. BR 4-12-17*/
		snf_cpd=b_cost_030001800/S3_00100_0700;
		snf_cpd=round(snf_cpd,0.01);
	end;


	/*if c_sum_ancil_chrg > 0 then do;
	   ancil_ccr = b_sum_ancil_cost / c_sum_ancil_chrg;
	   ancil_ccr=round(ancil_ccr,0.00001);
	end;*/

	label
	    rec_num                  ="Rec Num"
	    snf_ccr                  ="SNF CCR"
	    nf_ccr		     ="NF CCR"
	    total_ccr                ="TOTAL CCR"
	    ancil_ccr		     ="Ancillary CCR"

	    b_cost_03001800        ="B-PartI L16-C18: SNF cost allocation: Total"
	    b_cost_100001800        ="B-PartI L75-C18: TOTAL cost allocation: Total"

	    b0_cost_0310001800               ="B-PartI L18-C18: NF Cost: Total"

	    B_1_C18_21               ="B-PartI L21-C18: Ancil Radiology Cost: Total"
	    B_1_C18_22               ="B-PartI L22-C18: Ancil Laboratory Cost: Total"
	    B_1_C18_23               ="B-PartI L23-C18: Ancil IV Therapy Cost: Total"
	    B_1_C18_24               ="B-PartI L24-C18: Ancil Oxygen Therapy Cost: Total"
	    B_1_C18_25               ="B-PartI L25-C18: Ancil PT Cost: Total"
	    B_1_C18_26               ="B-PartI L26-C18: Ancil OT Cost: Total"
	    B_1_C18_27               ="B-PartI L27-C18: Ancil Speech Path Cost: Total"
	    B_1_C18_28               ="B-PartI L28-C18: Ancil Electrocardiology Cost: Total"
	    B_1_C18_29               ="B-PartI L29-C18: Ancil Med Supplies Pt-Charge Cost: Total"
	    B_1_C18_30               ="B-PartI L30-C18: Ancil Drugs Pt-Charge Cost: Total"
	    B_1_C18_31               ="B-PartI L31-C18: Ancil Dental (Title 19) Cost: Total"
	    B_1_C18_32               ="B-PartI L32-C18: Ancil Support Surfaces Cost: Total"
	    B_1_C18_33               ="B-PartI L33-C18: Ancil Other Cost: Total"
	    b_sum_ancil_cost         ="B-PartI: Sum of Ancillary Costs"

	    C_C2_21                  ="C: Ancil Radiology Charges"
	    C_C2_22                  ="C: Ancil laboratory Charges"
	    C_C2_23                  ="C: Ancil IV Therapy Charges"
	    C_C2_24                  ="C: Ancil Oxygen Therapy Charges" 
	    C_C2_25                  ="C: Ancil PT Charges"
	    C_C2_26                  ="C: Ancil OT Charges"
	    C_C2_27                  ="C: Ancil Speech Path Charges"
	    C_C2_28                  ="C: Ancil Electrocardiology Charges"
	    C_C2_29                  ="C: Ancil Medical Supplies Pt-Charge Charges"
	    C_C2_30                  ="C: Ancil Drugs Pt-Charge Charges"
	    C_C2_31                  ="C: Ancil Dental (Title 19) Charges"
	    C_C2_32                  ="C: Ancil Support Surfaces Charges"
	    C_C2_33                  ="C: Ancil Other Charges"
	    c_sum_ancil_chrg         ="C: Sum of Ancillary Charges"
	    c_075000100		     ="C: Ancil + Outpatient Costs"
	    c_075000200		     ="C: Ancil + Outpatient Charges"

	    G2_1_C1_1                ="G2-PartI L1-C1: SNF Inpatient Revenue (rollup)"
	    G2_1_C1_3                ="G2-PartI L3-C1: NF Inpatient Revenue (rollup)"
	    g2_rev_006000100         ="G2-PartI L6-C1: Ancillary Inpatient Revenue"
	    g2_rev_006000200         ="G2-PartI L6-C2: Ancillary Outpatient Revenue"
	    g2_rev_014000100         ="G2-PartI L14-C1: TOTAL Inpatient Revenue"
	    g2_rev_014000200         ="G2-PartI L14-C2: TOTAL Outpatient Revenue"
	    g2_rev_014000300         ="G2-PartI L14-C3: TOTAL Inpt+Outpt Revenue"
	    g2_sum_ancil_rev         ="G2-PartI L6-C1+C2: Inpt+Outpt Ancil Revenue"
	    costyear		     ="Cost Year"
	    ;
run;


title "Check ccr";
proc means data=snfccr_&yyear.;
	var snf_cpd snf_ccr nf_ccr total_ccr g2_rev_002000100 g2_rev_001000100 g2_rev_014000300 b_cost_031001800 b_cost_030001800 b_cost_100001800 S3_00100_0700;
run;
title;

proc means data=snfccr_&yyear.;
	var snf_cpd snf_ccr nf_ccr total_ccr S3_00100_0700;
run;



%MEND MGETROLLUP;

*=================================================================================================================================;
%MACRO MMERGEYEARS;

data out.snf_ccr_2010_2014;
	merge /*snfccr_2010(in=in2010)*/ snfccr_2011(in=in2011) snfccr_2012(in=in2012) snfccr_2013(in=in2013) snfccr_2014(in=in2014); 
	 by rec_num;

	length costyear 3.;
		 if in2010 then costyear=2010;
	else if in2011 then costyear=2011;
	else if in2012 then costyear=2012;
	else if in2013 then costyear=2013;
	else if in2014 then costyear=2014;

	length bgn_yr end_yr 3.;

		 if mdy(01,01,2010)<=fy_bgndt<mdy(01,01,2011) then bgn_yr=2010;
	else if mdy(01,01,2011)<=fy_bgndt<mdy(01,01,2012) then bgn_yr=2011;
	else if mdy(01,01,2012)<=fy_bgndt<mdy(01,01,2013) then bgn_yr=2012;
	else if mdy(01,01,2013)<=fy_bgndt<mdy(01,01,2014) then bgn_yr=2013;
	else if mdy(01,01,2014)<=fy_bgndt<mdy(01,01,2015) then bgn_yr=2014;

		 if mdy(01,01,2010)<=fy_enddt<mdy(01,01,2011) then end_yr=2010;
	else if mdy(01,01,2011)<=fy_enddt<mdy(01,01,2012) then end_yr=2011;
	else if mdy(01,01,2012)<=fy_enddt<mdy(01,01,2013) then end_yr=2012;
	else if mdy(01,01,2013)<=fy_enddt<mdy(01,01,2014) then end_yr=2013;
	else if mdy(01,01,2014)<=fy_enddt<mdy(01,01,2015) then end_yr=2014;
run;

proc contents varnum;
run;

proc print data=out.snf_ccr_2010_2014 (obs=50); run;

proc freq data=out.snf_ccr_2010_2014;
	tables costyear;
run;

proc means data=out.snf_ccr_2010_2014;
	class costyear;
	var snf_ccr nf_ccr total_ccr;
run;

proc univariate data=out.snf_ccr_2010_2014;
	class costyear;
	var snf_ccr nf_ccr total_ccr;
	output out=univariate q1= median= q3= p99=;
run;

proc print data=univariate; run;


%MEND MMERGEYEARS;

*=================================================================================================================================;
*=================================================================================================================================;

*%mgets2(2010);
*%mgetnmrc(2010);
*%mgetrollup(2010);

%mgets2(2011);
%mgetnmrc(2011);
%mgetrollup(2011);

%mgets2(2012);
%mgetnmrc(2012);
%mgetrollup(2012);

%mgets2(2013);
%mgetnmrc(2013);
%mgetrollup(2013);

%mgets2(2014);
%mgetnmrc(2014);
%mgetrollup(2014);

%mmergeyears;
