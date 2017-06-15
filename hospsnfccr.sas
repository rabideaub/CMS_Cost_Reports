**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	hospsnf.ccr.sas
#
#	Date Written:	June 20, 2011		
#
#	Purpose:	Gets Cost and Charge values for Hospital-Based SNFs
#			Joins these data with S2 and S3 worksheet dataset from hospsnf.s2s3wkshts.sas 
#
#	Reads:		hospsnf_s2s3_1996_2010.sas7bdat		(from hospsnf.s2s3wkshts.sas)
#			hosp(year)nmrc.sas7bdat	   		(year=1996-2010, from inputhosp.sas)
#
#	Writes:		hospsnf_ccr_1996_2010.sas7bdat
#			hospsnf_ccr_1996_2010.dta
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname snfout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=======================================================================================================================;
%MACRO MGETS2S3;

proc contents data=snfout.hospsnf_s2s3_2010_2014; run;

proc sort data=snfout.hospsnf_s2s3_2010_2014 out=s2s3data;
 	by prov_id cost_yr;
run;

proc sort data=s2s3data;
 	by rec_num;
run;

%MEND MGETS2S3;

*=======================================================================================================================;
%MACRO MGETNMRC(yyear);

data s2_&yyear;
	set s2s3data;
	if cost_yr=&yyear;
run;

data D1nmrc D4nmrc C1nmrc;
	set hospsrc.hosp&yyear.nmrc;

	**E indicates hosp-based SNF and 18 indicates Medicare in v10. BR 4-14-17;

	**Worksheet D1-Parts I and II;
	if nwksht="D10E181" then do;
	   output D1nmrc;
	end;

	**Worksheet D4;
	if nwksht="D30E180" then do; /*D4 is now called D3, but for consistency between v96 and v10 just name it D4 still. 4-14-17 BR*/
	   output D4nmrc;
	end;

	/*Add in the C-Worksheet*/
	if nwksht="C000001" & nline="04400" then do; /*Line 44 in sheet C1 is SNF subprovider in the v10 cost reports. 4-14-17 BR.*/
	   output C1nmrc;
	end;
run;

/*Transpose long to wide for each desired worksheet*/
*=======================================================================================================================;

data D1nmrc(keep=rec_num nline nlinecol nitem );
	merge D1nmrc(in=ind1) 
	      s2_&yyear.(in=keep);
	 by rec_num;
	if ind1 and keep;

	if ncol="00100" and nline in("02100" "02700" "02800" "03100" "04800");

	length nlinecol $11.;
	nlinecol=nline || "_" || ncol;
run;

proc transpose data=d1nmrc 
          prefix=d1_
     	  out=td1nmrc(drop=_NAME_);
	 by rec_num;
	 id nlinecol;
run;

*=======================================================================================================================;
data D4nmrc(keep=rec_num nline nlinecol nitem);
	merge D4nmrc(in=ind4) 
	      s2_&yyear.(in=good);
	 by rec_num;
	if ind4 and good;

	length nlinecol $11.;
	nlinecol=nline || "_" || ncol;

	*line 200= Total of ancillary, outpatient and other reimbursable cost centers;
	*line 201= Less PBP clinic lab, line 45;
	*lone 202= Net total of ancillary, outpatient and other reimbursable cost centers;
	*col 2= charges;
	*col 3= costs;

	if ncol in("00200" "00300") and nline in("20000" "20200");

run;

proc transpose data=d4nmrc
     	       prefix=d4_
     	       out=td4nmrc(drop=_NAME_);
	 by rec_num;
	 id nlinecol;
run;

*=======================================================================================================================;

data C1nmrc(keep=rec_num nline nlinecol nitem);
	merge C1nmrc(in=ind4) 
	      s2_&yyear.(in=good);
	 by rec_num;
	if ind4 and good;

	length nlinecol $11.;
	nlinecol=nline || "_" || ncol;

	if ncol in("00500" "00600") then do; /*Column 5 is total cost, 6 is total charge*/
	      if nline in("04400") then output C1nmrc; /*Line 44 is hopsital-based SNF*/
	end;
run;

proc transpose data=C1nmrc
     	       prefix=c1_
     	       out=tc1nmrc(drop=_NAME_);
	 by rec_num;
	 id nlinecol;
run;

*=======================================================================================================================;

**merge D1 nmrc file with D4 nmrc files and merge with full s2 file;

data D1D4nmrc_&yyear.;
merge td1nmrc td4nmrc tc1nmrc s2_&yyear.;
 by rec_num;


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
	if c1_04400_00600>0 & c1_04400_00500~=. then do;
		Total_CCR_c=sum(c1_04400_00500,d4_20000_00300) / sum(c1_04400_00600,d4_20000_00200);
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

label
    rec_num                  ="Rec Num"
    d1_02700_0100            ="D1-L27-C1: Inpt Rtn Svc Cost Net Swing-Beds"
    d1_02800_0100            ="D1-L28-C1: Inpt Rtn Svc Charge Net Swing-Beds"
    d4_10100_0300            ="D4-L101-C3: Ancillary + Outpt + Other Cost"
    d4_10300_0200            ="D4-L103-C2: Ancillary + Outpt + Other Charge Net PBP"
    Anc_Outpt_Oth_CCR	     ="Ancillary + Outpt + Other CCR"
    Total_CCR		     ="Total CCR"
    Inptrtn_CCR	     	     ="Inpt Rtn Svc CCR"
    ;

drop d1_02100_0100 d1_03100_0100 d4_10100_0200;

%MEND MGETNMRC;

*=======================================================================================================================;
%MACRO MMERGEYEARS;

data hospsnf_ccr;
merge 
	 d1d4nmrc_2010(in=in2010) d1d4nmrc_2011(in=in2011) d1d4nmrc_2012(in=in2012) 
	 d1d4nmrc_2013(in=in2013) d1d4nmrc_2014(in=in2014); 
 by rec_num;
 run;

%MEND MMERGEYEARS;
*====================================================================================================================================;
%MACRO MACCALENDAR;

data snf;
set hospsnf_ccr;

if (fy_bgndt<=mdy(01,01,2010)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2010)<=fy_enddt) then do; w=2010; output snf; end;
if (fy_bgndt<=mdy(01,01,2011)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2011)<=fy_enddt) then do; w=2011; output snf; end;
if (fy_bgndt<=mdy(01,01,2012)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2012)<=fy_enddt) then do; w=2012; output snf; end;
if (fy_bgndt<=mdy(01,01,2013)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2013)<=fy_enddt) then do; w=2013; output snf; end;
if (fy_bgndt<=mdy(01,01,2014)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2014)<=fy_enddt) then do; w=2014; output snf; end;

data snf;
set snf;

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

j=w-2009;
prov_id_w=prov_id || w;

proc sort; 
 by prov_id_w;
run;

data snf;
set snf;

array ajan{5}
      jan2010 - jan2014;

array adec{5}
      dec2010 - dec2014;

jan=ajan{j};
dec=adec{j};

wbegin=max(of fy_bgndt jan);
wend=min(of fy_enddt dec);

proc sort; 
 by prov_id_w wbegin;
run;

data snf;
set snf;
 by prov_id_w;
retain totcaldays;

wreportdays=(wend - wbegin) + 1;

if first.prov_id_w then do;
   totcaldays=0;
end;
totcaldays=totcaldays + wreportdays;

format wbegin wend date8.;

*proc print;
* title 'not last only';
* var rec_num prov_id_w cost_yr fy_bgndt fy_enddt wbegin wend wreportdays totcaldays inptrtn_cost inptrtn_charge inptrtn_ccr 

	pct_medicare_days
	pct_medicaid_days

	prev_pct_medicare_days
	prev_pct_medicaid_days;
*run;

data lastprov_id_w(keep=prov_id_w totcaldays);
set snf;
 by prov_id_w;

if last.prov_id_w then output lastprov_id_w;

data lastprov_id_w;
merge snf lastprov_id_w;
 by prov_id_w;

length cal_yr 3.;
retain
	cal_Inptrtn_Cost
	cal_Inptrtn_Charge
	cal_Inptrtn_CCR

	cal_Anc_Outpt_Oth_Cost
	cal_Anc_Outpt_Oth_Charge
	cal_Anc_Outpt_Oth_CCR

	cal_Total_CCR

	cal_pct_medicare_days
	cal_pct_medicaid_days

	cal_prev_pct_medicare_days
	cal_prev_pct_medicaid_days

	part_rtncost
	part_rtncharge
   	part_rtnccr

	part_anccost
	part_anccharge
   	part_ancccr

   	part_totccr

	part_medicare
	part_medicaid

	part_prev_medicare
	part_prev_medicaid

	;

if first.prov_id_w then do;
   cal_Inptrtn_Cost=.;
   cal_Inptrtn_Charge=.;
   cal_Inptrtn_CCR=.;

   cal_Anc_Outpt_Oth_Cost=.;
   cal_Anc_Outpt_Oth_Charge=.;
   cal_Anc_Outpt_Oth_CCR=.;

   cal_Total_CCR=.;

   cal_pct_medicare_days=.;
   cal_pct_medicaid_days=.;

   cal_prev_pct_medicare_days=.;
   cal_prev_pct_medicaid_days=.;

   part_rtncost=.;
   part_rtncharge=.;
   part_rtnccr=.;

   part_anccost=.;
   part_anccharge=.;
   part_ancccr=.;

   part_totccr=.;

   part_medicare=.;
   part_medicaid=.;

   part_prev_medicare=.;
   part_prev_medicaid=.;
end;

if totcaldays>0 then propw=wreportdays / totcaldays;

if Inptrtn_COST ne . then do;
   rCost=Inptrtn_COST * propw; 
   part_rtnCost=sum(of part_rtnCost propw);
end; 
if Inptrtn_Charge ne . then do;
   rCharge=Inptrtn_Charge * propw; 
   part_rtnCharge=sum(of part_rtnCharge propw);
end; 
if Inptrtn_CCR ne . then do;
   rccr=Inptrtn_CCR * propw; 
   part_rtnccr=sum(of part_rtnccr propw);
end; 

if Anc_Outpt_Oth_COST ne . then do;
   ancCost=Anc_Outpt_Oth_COST * propw; 
   part_ancCost=sum(of part_ancCost propw);
end;
if Anc_Outpt_Oth_CHARGE ne . then do;
   ancCharge=Anc_Outpt_Oth_CHARGE * propw; 
   part_ancCharge=sum(of part_ancCharge propw);
end;
if Anc_Outpt_Oth_CCR ne . then do;
   ancccr=Anc_Outpt_Oth_CCR * propw; 
   part_ancccr=sum(of part_ancccr propw);
end;

if Total_CCR ne . then do;
   totccr=Total_CCR * propw; 
   part_totccr=sum(of part_totccr propw);
end;

if pct_medicaid_days ne . then do;
   _medicaid=pct_medicaid_days * propw;
   part_medicaid=sum(of part_medicaid propw);
end;
if pct_medicare_days ne . then do;
   _medicare=pct_medicare_days * propw;
   part_medicare=sum(of part_medicare propw);
end;

if prev_pct_medicaid_days ne . then do;
   _prevmedicaid=prev_pct_medicaid_days * propw;
   part_prev_medicaid=sum(of part_prev_medicaid propw);
end;
if prev_pct_medicare_days ne . then do;
   _prevmedicare=prev_pct_medicare_days * propw;
   part_prev_medicare=sum(of part_prev_medicare propw);
end;

cal_Inptrtn_Cost		=sum(of cal_Inptrtn_Cost rcost);
cal_Inptrtn_Charge		=sum(of cal_Inptrtn_Charge rcharge);
cal_Inptrtn_CCR			=sum(of cal_Inptrtn_CCR rccr);

cal_Anc_Outpt_Oth_Cost		=sum(of cal_Anc_Outpt_Oth_Cost anccost);
cal_Anc_Outpt_Oth_Charge	=sum(of cal_Anc_Outpt_Oth_Charge anccharge);
cal_Anc_Outpt_Oth_CCR		=sum(of cal_Anc_Outpt_Oth_CCR ancccr);

cal_Total_CCR			=sum(of cal_Total_CCR totccr);

cal_pct_medicare_days		=sum(of cal_pct_medicare_days _medicare);
cal_pct_medicaid_days		=sum(of cal_pct_medicaid_days _medicaid);

cal_prev_pct_medicare_days	=sum(of cal_prev_pct_medicare_days _prevmedicare);
cal_prev_pct_medicaid_days	=sum(of cal_prev_pct_medicaid_days _prevmedicaid);


if last.prov_id_w then do;
	if part_rtncost>0 then cal_Inptrtn_COST				=cal_Inptrtn_COST		* (1 / part_rtncost);
	if part_rtncharge>0 then cal_Inptrtn_CHARGE			=cal_Inptrtn_CHARGE		* (1 / part_rtncharge);
	if part_rtnccr>0 then cal_Inptrtn_CCR				=cal_Inptrtn_CCR		* (1 / part_rtnccr);

	if part_anccost>0 then cal_Anc_Outpt_Oth_COST			=cal_Anc_Outpt_Oth_COST		* (1 / part_anccost);
	if part_anccharge>0 then cal_Anc_Outpt_Oth_CHARGE		=cal_Anc_Outpt_Oth_CHARGE	* (1 / part_anccharge);
	if part_ancccr>0 then cal_Anc_Outpt_Oth_CCR			=cal_Anc_Outpt_Oth_CCR		* (1 / part_ancccr);

	if part_totccr>0 then cal_Total_CCR				=cal_Total_CCR			* (1 / part_totccr);

	if part_medicare>0 then cal_pct_medicare_days			=cal_pct_medicare_days		* (1 / part_medicare);
	if part_medicaid>0 then cal_pct_medicaid_days			=cal_pct_medicaid_days		* (1 / part_medicaid);

	if part_prev_medicare>0 then cal_prev_pct_medicare_days		=cal_prev_pct_medicare_days	* (1 / part_prev_medicare);
	if part_prev_medicaid>0 then cal_prev_pct_medicaid_days		=cal_prev_pct_medicaid_days	* (1 / part_prev_medicaid);

	cal_yr=w;
	output lastprov_id_w;
end;

data lastprov_id_w;
set lastprov_id_w;
 by prov_id;

*****possible for first provider-year to have values in previous fields because of calendar year logic above, make these values missing;
if first.prov_id then do;
   prev_pct_medicare_days=.;
   prev_pct_medicaid_days=.;
   cal_prev_pct_medicare_days=.;
   cal_prev_pct_medicaid_days=.;
end;

drop
    w
    jan2010-jan2014
    dec2010-dec2014
    j
    prov_id_w
    jan dec
    wbegin wend
    totcaldays
    wreportdays
    part_rtncost
    part_rtncharge
    part_rtnccr
    part_anccost
    part_anccharge
    part_ancccr
    part_totccr
    part_medicare
    part_medicaid
    part_prev_medicare
    part_prev_medicaid
    propw
    rCost
    rCharge
    rccr
    ancCost
    ancCharge
    ancccr
    totccr
    _medicaid
    _medicare
    _prevmedicaid
    _prevmedicare;

label
	prov_id					="SNF Provider ID"
	cost_yr					="Cost Report File Year"
	cal_yr					="Calendar Year"
	state		 			="SNF State"
	control_catg				="Main Provider Control Category"

	cal_Inptrtn_Cost			="SNF Calendar Yr Routine Cost"
	cal_Inptrtn_Charge			="SNF Calendar Yr Routine Charge"
	cal_Inptrtn_CCR				="SNF Calendar Yr Routine CCR"

	cal_Anc_Outpt_Oth_Cost			="SNF Calendar Yr Ancillary Cost"
	cal_Anc_Outpt_Oth_Charge		="SNF Calendar Yr Ancillary Charge"
	cal_Anc_Outpt_Oth_CCR			="SNF Calendar Yr Ancillary CCR"

	cal_Total_CCR				="SNF Calendar Yr Total CCR"

	cal_pct_medicare_days    		="SNF Calendar Yr % Medicare Days"
	cal_pct_medicaid_days    		="SNF Calendar Yr % Medicaid Days"

	cal_prev_pct_medicare_days    		="SNF Prev Calendar Yr % Medicare Days"
	cal_prev_pct_medicaid_days    		="SNF Prev Calendar Yr % Medicaid Days"

	medicaredays				="SNF Cost Period Medicare Days"
	medicaiddays				="SNF Cost Period Medicaid Days"
	totaldays				="SNF Cost Period Total Days"
	prev_medicaredays			="SNF Prev Cost Period Medicare Days"
	prev_medicaiddays			="SNF Prev Cost Period Medicaid Days"
	prev_totaldays				="SNF Prev Cost Period Total Days"
	pct_medicare_days			="SNF Cost Period % Medicare Days"
	pct_medicaid_days			="SNF Cost Period % Medicaid Days"
	prev_pct_medicare_days			="SNF Prev Cost Period % Medicare Days"
	prev_pct_medicaid_days			="SNF Prev Cost Period % Medicaid Days"
	;

length state $2.;
state=substr(prov_id,1,2);
format state $fstate_.;

proc sort data=lastprov_id_w out=snfout.hospsnf_ccr_2010_2014;
 by prov_id cal_yr fy_bgndt;
run;

proc means data=snfout.hospsnf_ccr_2010_2014;
 title 'Hospital-Based SNFs';
 class cal_yr;
 var 
 		Total_CCR
		Total_CCR_c
		total_cpd
        cal_Inptrtn_Cost
        cal_Inptrtn_Charge
        cal_Inptrtn_Cost
        cal_Inptrtn_Charge
        cal_Inptrtn_CCR 
	cal_Anc_Outpt_Oth_Cost
	cal_Anc_Outpt_Oth_Charge
	cal_Anc_Outpt_Oth_CCR
        cal_Total_CCR

	cal_pct_medicare_days
	cal_pct_medicaid_days
	cal_prev_pct_medicare_days
	cal_prev_pct_medicaid_days;
run;

proc contents data=snfout.hospsnf_ccr_2010_2014 varnum;
run;

%MEND MACCALENDAR;

*=================================================================================================================================;
%MACRO MSTATAFL;
***CREATE STATA FILE***;
         proc export data=snfout.hospsnf_ccr_2010_2014
            outfile='/data/postacute/RAND/SNF/outdata/hospsnf_ccr_2010_2014'
            dbms=dta
	    replace;
         run;

%MEND MSTATAFL;
*=================================================================================================================================;

%mgets2s3;

%mgetnmrc(2010);
%mgetnmrc(2011);
%mgetnmrc(2012);
%mgetnmrc(2013);
%mgetnmrc(2014);

%mmergeyears;
%maccalendar;
*mstatafl;
*=======================================================================================================================;
