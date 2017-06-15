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
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96";
libname snfout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=======================================================================================================================;
%MACRO MGETS2S3;

proc sort data=snfout.hospsnf_s2s3_1996_2010 out=s2s3data;
 by prov_id cost_yr;
run;

data s2s3data;
set s2s3data;
 by prov_id;

*if prov_id in("462003" "010044" "393037");

medicaredays=S3_01500_0400;
medicaiddays=S3_01500_0500;
totaldays=S3_01500_0600;

if medicaredays=. then medicaredays=0;
if medicaiddays=. then medicaiddays=0;
if totaldays=. then totaldays=0;

prev_medicaredays=lag(S3_01500_0400);
prev_medicaiddays=lag(S3_01500_0500);
prev_totaldays=lag(S3_01500_0600);

if prev_medicaredays=. then prev_medicaredays=0;
if prev_medicaiddays=. then prev_medicaiddays=0;
if prev_totaldays=. then prev_totaldays=0;

if first.prov_id then do;
   prev_medicaredays=.;
   prev_medicaiddays=.;
   prev_totaldays=.;
end;

if totaldays > 0 then do;
   pct_medicare_days = medicaredays / totaldays;
   pct_medicaid_days = medicaiddays / totaldays;
end;

if prev_totaldays > 0 then do;
   prev_pct_medicare_days = prev_medicaredays / prev_totaldays;
   prev_pct_medicaid_days = prev_medicaiddays / prev_totaldays;
end;

if S2_01800_0100 in(1 2) then control_catg=1;				*non-profit;
else if S2_01800_0100 in(3 4 5 6) then control_catg=2;			*for-profit;
else if S2_01800_0100 in(7 8 9 10 11 12 13) then control_catg=3;	*govt;
format control_catg catcntl_.
       S2_01900_0100 htype_.;

proc sort;
 by rec_num;
run;

%MEND MGETS2S3;

*=======================================================================================================================;
%MACRO MGETNMRC(yyear);

data s2_&yyear;
set s2s3data;
if cost_yr=&yyear;

data D1nmrc D4nmrc;
set hospsrc.hosp&yyear.nmrc;

**C indicates SNF and 18 indicates Medicare;

**Worksheet D1-Parts I and II;
if nwksht="D10C181" then do;
   output D1nmrc;
end;

**Worksheet D4;
if nwksht="D40C180" then do;
   output D4nmrc;
end;

data D1nmrc(keep=rec_num nline nlinecol nitem );
merge D1nmrc(in=ind1) 
      s2_&yyear.(in=keep);
 by rec_num;
if ind1 and keep;

if ncol="0100" and nline in("02100" "02700" "02800" "03100" "04800");

length nlinecol $10.;
nlinecol=nline || "_" || ncol;

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

length nlinecol $10.;
nlinecol=nline || "_" || ncol;

*line 101= Total of ancillary, outpatient and other reimbursable cost centers;
*line 102= Less PBP clinic lab, line 45;
*lone 103= Net total of ancillary, outpatient and other reimbursable cost centers;
*col 2= charges;
*col 3= costs;

if ncol in("0200" "0300") then do;
      if nline in("10100" "10300") then output D4nmrc;
end;

proc transpose data=d4nmrc
     	       prefix=d4_
     	       out=td4nmrc(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

*=======================================================================================================================;
**merge D1 nmrc file with D4 nmrc files and merge with full s2 file;

data D1D4nmrc_&yyear.;
merge td1nmrc td4nmrc s2_&yyear.;
 by rec_num;

rename 
    d1_02700_0100       =Inptrtn_Cost
    d1_02800_0100       =Inptrtn_Charge
    d4_10100_0300       =Anc_Outpt_Oth_Cost
    d4_10300_0200       =Anc_Outpt_Oth_Charge
    ;

*   d1_02100_0100       =Inptrtn_withSwing_Cost
    d1_03100_0100       =_InptRtn_CCR
    d4_10100_0200       =Anc_Outpt_Oth_WithPBP_Charge;

if d4_10300_0200 > 0 and d4_10100_0300 ne . then do;
   Anc_Outpt_Oth_CCR = d4_10100_0300 / d4_10300_0200;
   Anc_Outpt_Oth_CCR = round(Anc_Outpt_Oth_CCR,0.00001);
   if d1_02700_0100 ne . and d1_02800_0100 ne . then do;
      Total_CCR = (d1_02700_0100 + d4_10100_0300) / (d1_02800_0100 + d4_10300_0200);
      Total_CCR = round(Total_CCR,0.00001);
   end;
end;
if d1_02800_0100 > 0 and d1_02700_0100 ne . then do;
   Inptrtn_CCR = d1_02700_0100 / d1_02800_0100;
   Inptrtn_CCR = round(Inptrtn_CCR,0.00001);
end;
if InptRtn_CCR=. and d1_03100_0100 ne . then do;
   InptRtn_CCR=d1_03100_0100;
   Inptrtn_CCR = round(Inptrtn_CCR,0.00001);
end;

***Note: Inptrtn_withSwing_Cost always equals Inptrtn_Cost
***Note: Anc_Outpt_Oth_WithPBP_Charge always equals Anc_Outpt_Oth_Charge
***so drop Inptrtn_withSwing_Cost Anc_Outpt_Oth_WithPBP_Charge;

****Note: d1_03100_0100 not always present, so use computed value Inptrtn_CCR;
****when d1_03100_0100 is present, it is the same as the computed value Inptrtn_CCR;
****if InptRtn_CCR not present and d1_03100_0100 present, use d1_03100_0100;

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
     d1d4nmrc_1996(in=in1996) d1d4nmrc_1997(in=in1997) d1d4nmrc_1998(in=in1998) d1d4nmrc_1999(in=in1999)
     d1d4nmrc_2000(in=in2000) d1d4nmrc_2001(in=in2001) d1d4nmrc_2002(in=in2002) d1d4nmrc_2003(in=in2003) d1d4nmrc_2004(in=in2004) 
     d1d4nmrc_2005(in=in2005) d1d4nmrc_2006(in=in2006) d1d4nmrc_2007(in=in2007) d1d4nmrc_2008(in=in2008) d1d4nmrc_2009(in=in2009)
	 d1d4nmrc_2010(in=in2010); 
 by rec_num;

%MEND MMERGEYEARS;
*====================================================================================================================================;
%MACRO MACCALENDAR;

data snf;
set hospsnf_ccr;

if (fy_bgndt<=mdy(01,01,1996)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1996)<=fy_enddt) then do; w=1996; output snf; end;
if (fy_bgndt<=mdy(01,01,1997)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1997)<=fy_enddt) then do; w=1997; output snf; end;
if (fy_bgndt<=mdy(01,01,1998)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1998)<=fy_enddt) then do; w=1998; output snf; end;
if (fy_bgndt<=mdy(01,01,1999)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1999)<=fy_enddt) then do; w=1999; output snf; end;
if (fy_bgndt<=mdy(01,01,2000)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2000)<=fy_enddt) then do; w=2000; output snf; end;
if (fy_bgndt<=mdy(01,01,2001)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2001)<=fy_enddt) then do; w=2001; output snf; end;
if (fy_bgndt<=mdy(01,01,2002)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2002)<=fy_enddt) then do; w=2002; output snf; end;
if (fy_bgndt<=mdy(01,01,2003)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2003)<=fy_enddt) then do; w=2003; output snf; end;
if (fy_bgndt<=mdy(01,01,2004)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2004)<=fy_enddt) then do; w=2004; output snf; end;
if (fy_bgndt<=mdy(01,01,2005)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2005)<=fy_enddt) then do; w=2005; output snf; end;
if (fy_bgndt<=mdy(01,01,2006)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2006)<=fy_enddt) then do; w=2006; output snf; end;
if (fy_bgndt<=mdy(01,01,2007)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2007)<=fy_enddt) then do; w=2007; output snf; end;
if (fy_bgndt<=mdy(01,01,2008)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2008)<=fy_enddt) then do; w=2008; output snf; end;
if (fy_bgndt<=mdy(01,01,2009)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2009)<=fy_enddt) then do; w=2009; output snf; end;
if (fy_bgndt<=mdy(01,01,2010)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2010)<=fy_enddt) then do; w=2010; output snf; end;

data snf;
set snf;
jan1996=mdy(01,01,1996);
jan1997=mdy(01,01,1997);
jan1998=mdy(01,01,1998);
jan1999=mdy(01,01,1999);
jan2000=mdy(01,01,2000);
jan2001=mdy(01,01,2001);
jan2002=mdy(01,01,2002);
jan2003=mdy(01,01,2003);
jan2004=mdy(01,01,2004);
jan2005=mdy(01,01,2005);
jan2006=mdy(01,01,2006);
jan2007=mdy(01,01,2007);
jan2008=mdy(01,01,2008);
jan2009=mdy(01,01,2009);
jan2010=mdy(01,01,2010);

dec1996=mdy(12,31,1996);
dec1997=mdy(12,31,1997);
dec1998=mdy(12,31,1998);
dec1999=mdy(12,31,1999);
dec2000=mdy(12,31,2000);
dec2001=mdy(12,31,2001);
dec2002=mdy(12,31,2002);
dec2003=mdy(12,31,2003);
dec2004=mdy(12,31,2004);
dec2005=mdy(12,31,2005);
dec2006=mdy(12,31,2006);
dec2007=mdy(12,31,2007);
dec2008=mdy(12,31,2008);
dec2009=mdy(12,31,2009);
dec2010=mdy(12,31,2010);

j=w-1995;
prov_id_w=prov_id || w;

proc sort; 
 by prov_id_w;
run;

data snf;
set snf;

array ajan{15}
      jan1996 - jan2010;

array adec{15}
      dec1996 - dec2010;

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
    jan1996-jan2010
    dec1996-dec2010
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

proc sort data=lastprov_id_w out=snfout.hospsnf_ccr_1996_2010;
 by prov_id cal_yr fy_bgndt;
run;

*proc print data=snfout.hospsnf_ccr_1996_2009(obs=500);
* title 'snfout.hospsnf_ccr_1996_2009';
* var prov_id cost_yr fy_bgndt fy_enddt cal_yr
    part_rtncost
    part_rtncharge
    part_rtnccr
    cal_Inptrtn_Cost
    cal_Inptrtn_Charge
    cal_Inptrtn_CCR
    cal_Anc_Outpt_Oth_Cost
    cal_Anc_Outpt_Oth_Charge
    cal_Anc_Outpt_Oth_CCR
    cal_Total_CCR

    prev_medicaredays
    prev_medicaiddays
    prev_totaldays
    prev_pct_medicare_days
    prev_pct_medicaid_days;
*run;

*proc print data=snfout.hospsnf_ccr_1996_2009;
* var prov_id fy_bgndt fy_enddt cal_yr

        cal_Inptrtn_Cost
        cal_Inptrtn_Charge
        cal_Inptrtn_Cost
        cal_Inptrtn_Charge
        cal_Inptrtn_CCR 
	cal_Anc_Outpt_Oth_Cost
	cal_Anc_Outpt_Oth_Charge
	cal_Anc_Outpt_Oth_CCR
        cal_Total_CCR

	pct_medicare_days
	cal_pct_medicare_days
	pct_medicaid_days
	cal_pct_medicaid_days

	prev_pct_medicare_days
	cal_prev_pct_medicare_days
	prev_pct_medicaid_days
	cal_prev_pct_medicaid_days;
*run;

proc means data=snfout.hospsnf_ccr_1996_2010;
 title 'Hospital-Based SNFs';
 class cal_yr;
 var 
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

proc contents data=snfout.hospsnf_ccr_1996_2010 varnum;
run;

%MEND MACCALENDAR;

*=================================================================================================================================;
%MACRO MSTATAFL;
***CREATE STATA FILE***;
         proc export data=snfout.hospsnf_ccr_1996_2009
            outfile='/data/postacute/RAND/SNF/outdata/hospsnf_ccr_1996_2010'
            dbms=dta
	    replace;
         run;

%MEND MSTATAFL;
*=================================================================================================================================;

%mgets2s3;

%mgetnmrc(1996);
%mgetnmrc(1997);
%mgetnmrc(1998);
%mgetnmrc(1999);
%mgetnmrc(2000);
%mgetnmrc(2001);
%mgetnmrc(2002);
%mgetnmrc(2003);
%mgetnmrc(2004);
%mgetnmrc(2005);
%mgetnmrc(2006);
%mgetnmrc(2007);
%mgetnmrc(2008);
%mgetnmrc(2009);
%mgetnmrc(2010);

%mmergeyears;
%maccalendar;
*mstatafl;
*=======================================================================================================================;
