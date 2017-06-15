**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	hha.s2s3wkshts.sas
#
#	Date Written:	July 28, 2011
#
#	Must follow:	hha.input.sas
#	Must precede:	hha.standalone.cpd.sas
#
#	Purpose:	Creates SAS data sets from HHA S2 and S3 worksheets
#
#	Reads:		hhayearalpha.sas7bdat	(year=1996-2009)
#			hhayearnmrc.sas7bdat	(year=1996-2009)
#			hhayearrollup.sas7bdat	(year=1996-2009)
#
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hhasrc  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname hhaout  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=========================================================================================================================================;

%MACRO MGETS2(yyear);

****S2 ALPHA****;

data 
	 o1			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_street)
	 o2			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_po_box)
	 o3			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_po_box2)
	 o4			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_city)
	 o5			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_state)
	 o6			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_zipcode)
	 o7			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_name)
	 o8			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_prov_id)
	 o9			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_dt_certified)
	 o10			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_corf_name)
	 o11			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_corf_prov_id)
	 o12			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_corf_dt_certified)
	 o13			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice_name)
	 o14			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice_prov_id)
	 o15			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice_dt_certified)
	 o16			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice2_name)
	 o17			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice2_prov_id)
	 o18			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice2_dt_certified)
	 o19			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice3_name)
	 o20			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice3_prov_id)
	 o21			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_hospice3_dt_certified)
	 o22			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_cmhc_name)
	 o23			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_cmhc_prov_id)
	 o24			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_cmhc_dt_certified)
	 o25			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_rhc_name)
	 o26			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_rhc_prov_id)
	 o27			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_rhc_dt_certified)
	 o28			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc_name)
	 o29			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc_prov_id)
	 o30			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc_dt_certified)
	 o31			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc2_name)
	 o32			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc2_prov_id)
	 o33			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc2_dt_certified)
	 o34			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc3_name)
	 o35			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc3_prov_id)
	 o36			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc3_dt_certified)
	 o37			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc4_name)
	 o38			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc4_prov_id)
	 o39			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc4_dt_certified)
	 o40			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc5_name)
	 o41			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc5_prov_id)
	 o42			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc5_dt_certified)
	 o43			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc6_name)
	 o44			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc6_prov_id)
	 o45			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_fqhc6_dt_certified)
	 o46			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_period_from_dt)
	 o47			(keep=rec_num prov_id fy_bgndt fy_enddt 	hha_period_to_dt)
	 o48			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_00900_0100)
	 o49			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_01400_0100)
	 o50			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_01500_0100)
	 o51			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_01600_0100)
	 o52			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_01800_0100)
	 o53			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_01900_0100)
	 o54			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02000_0100)
	 o55			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02100_0100)
	 o56			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02200_0100)
	 o57			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02201_0100)
	 o58			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02202_0100)
	 o59			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02300_0100)
	 o60			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02300_0200)
	 o61			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02400_0200)
	 o62			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02500_0200)
	 o63			(keep=rec_num prov_id fy_bgndt fy_enddt 	S2_02800_0100)
	 ;

set hhasrc.hha&yyear.alpha;

if awksht="S200000";
if fy_bgndt<mdy(12,31,2009) and fy_enddt>mdy(01,01,1995);

length awlc $16.;
awlc=awksht || aline || acol;

length 
     hha_street                   $40.
     hha_po_box                   $28.
     hha_po_box2                  $28.
     hha_city                     $40.
     hha_state                    $2.
     hha_zipcode                  $10.
     hha_name                     $40.
     hha_prov_id                  $6.
     hha_corf_name                $40.
     hha_corf_prov_id             $6.
     hha_hospice_name             $40.
     hha_hospice_prov_id          $6.
     hha_hospice2_name            $40.
     hha_hospice2_prov_id         $6.
     hha_hospice3_name            $40.
     hha_hospice3_prov_id         $6.
     hha_cmhc_name                $40.
     hha_cmhc_prov_id             $6.
     hha_rhc_name                 $40.
     hha_rhc_prov_id              $6.
     hha_fqhc_name                $40.
     hha_fqhc_prov_id             $6.
     hha_fqhc2_name               $40.
     hha_fqhc2_prov_id            $6.
     hha_fqhc3_name               $40.
     hha_fqhc3_prov_id            $6.
     hha_fqhc4_name               $40.
     hha_fqhc4_prov_id            $6.
     hha_fqhc5_name               $40.
     hha_fqhc5_prov_id            $6.
     hha_fqhc6_name               $40.
     hha_fqhc6_prov_id            $6.
     S2_00900_0100                $1.
     S2_01400_0100                $1.
     S2_01500_0100                $1.
     S2_01600_0100                $1.
     S2_01800_0100                $1.
     S2_01900_0100                $1.
     S2_02000_0100                $1.
     S2_02100_0100                $1.
     S2_02200_0100                $1.
     S2_02201_0100                $1.
     S2_02202_0100                $1.
     S2_02300_0100                $1.
     S2_02300_0200                $1.
     S2_02400_0200                $1.
     S2_02500_0200                $1.
     S2_02800_0100                $1.
     ;

	if awlc			="S200000001000100"		then do;	hha_street			=aitem;	output o1; end;
	else if awlc		="S200000001000200"		then do;	hha_po_box			=aitem;	output o2; end;
	else if awlc		="S200000001000300"		then do;	hha_po_box2			=aitem;	output o3; end;
	else if awlc		="S200000001010100"		then do;	hha_city			=aitem;	output o4; end;
	else if awlc		="S200000001010200"		then do;	hha_state			=aitem;	output o5; end;
	else if awlc		="S200000001010300"		then do;	hha_zipcode			=aitem;	output o6; end;
	else if awlc		="S200000002000100"		then do;	hha_name			=aitem;	output o7; end;
	else if awlc		="S200000002000200"		then do;	hha_prov_id			=aitem;	output o8; end;
	else if awlc		="S200000002000300"		then do;	hha_dt_certified		=aitem;	output o9; end;

	else if awlc		="S200000003000100"		then do;	hha_corf_name			=aitem;	output o10; end;
	else if awlc		="S200000003000200"		then do;	hha_corf_prov_id		=aitem;	output o11; end;
	else if awlc		="S200000003000300"		then do;	hha_corf_dt_certified		=aitem;	output o12; end;
	else if awlc		="S200000003500100"		then do;	hha_hospice_name		=aitem;	output o13; end;
	else if awlc		="S200000003500200"		then do;	hha_hospice_prov_id		=aitem;	output o14; end;
	else if awlc		="S200000003500300"		then do;	hha_hospice_dt_certified	=aitem;	output o15; end;
	else if awlc		="S2000000035100100"		then do;	hha_hospice2_name		=aitem;	output o16; end;
	else if awlc		="S2000000035100200"		then do;	hha_hospice2_prov_id		=aitem;	output o17; end;
	else if awlc		="S2000000035100300"		then do;	hha_hospice2_dt_certified	=aitem;	output o18; end;
	else if awlc		="S2000000035200100"		then do;	hha_hospice3_name		=aitem;	output o19; end;
	else if awlc		="S2000000035200200"		then do;	hha_hospice3_prov_id		=aitem;	output o20; end;
	else if awlc		="S2000000035200300"		then do;	hha_hospice3_dt_certified	=aitem;	output o21; end;
	else if awlc		="S200000004000100"		then do;	hha_cmhc_name			=aitem;	output o22; end;
	else if awlc		="S200000004000200"		then do;	hha_cmhc_prov_id		=aitem;	output o23; end;
	else if awlc		="S200000004000300"		then do;	hha_cmhc_dt_certified		=aitem;	output o24; end;
	else if awlc		="S200000005000100"		then do;	hha_rhc_name			=aitem;	output o25; end;
	else if awlc		="S200000005000200"		then do;	hha_rhc_prov_id			=aitem;	output o26; end;
	else if awlc		="S200000005000300"		then do;	hha_rhc_dt_certified		=aitem;	output o27; end;
	else if awlc		="S200000006000100"		then do;	hha_fqhc_name			=aitem;	output o28; end;
	else if awlc		="S200000006000200"		then do;	hha_fqhc_prov_id		=aitem;	output o29; end;
	else if awlc		="S200000006000300"		then do;	hha_fqhc_dt_certified		=aitem;	output o30; end;
	else if awlc		="S200000006010100"		then do;	hha_fqhc2_name			=aitem;	output o31; end;
	else if awlc		="S200000006010200"		then do;	hha_fqhc2_prov_id		=aitem;	output o32; end;
	else if awlc		="S200000006010300"		then do;	hha_fqhc2_dt_certified		=aitem;	output o33; end;
	else if awlc		="S200000006020100"		then do;	hha_fqhc3_name			=aitem;	output o34; end;
	else if awlc		="S200000006020200"		then do;	hha_fqhc3_prov_id		=aitem;	output o35; end;
	else if awlc		="S200000006020300"		then do;	hha_fqhc3_dt_certified		=aitem;	output o36; end;
	else if awlc		="S200000006030100"		then do;	hha_fqhc4_name			=aitem;	output o37; end;
	else if awlc		="S200000006030200"		then do;	hha_fqhc4_prov_id		=aitem;	output o38; end;
	else if awlc		="S200000006030300"		then do;	hha_fqhc4_dt_certified		=aitem;	output o39; end;
	else if awlc		="S200000006040100"		then do;	hha_fqhc5_name			=aitem;	output o40; end;
	else if awlc		="S200000006040200"		then do;	hha_fqhc5_prov_id		=aitem;	output o41; end;
	else if awlc		="S200000006040300"		then do;	hha_fqhc5_dt_certified		=aitem;	output o42; end;
	else if awlc		="S200000006050100"		then do;	hha_fqhc6_name			=aitem;	output o43; end;
	else if awlc		="S200000006050200"		then do;	hha_fqhc6_prov_id		=aitem;	output o44; end;
	else if awlc		="S200000006050300"		then do;	hha_fqhc6_dt_certified		=aitem;	output o45; end;

	else if awlc		="S200000007000100"		then do;	hha_period_from_dt		=aitem;	output o46; end;
	else if awlc		="S200000007000200"		then do;	hha_period_to_dt		=aitem;	output o47; end;
	else if awlc		="S200000009000100"		then do;	S2_00900_0100			=aitem;	output o48; end;
	else if awlc		="S200000014000100"		then do;	S2_01400_0100			=aitem;	output o49; end;
	else if awlc		="S200000015000100"		then do;	S2_01500_0100			=aitem;	output o50; end;
	else if awlc		="S200000016000100"		then do;	S2_01600_0100			=aitem;	output o51; end;
	else if awlc		="S200000018000100"		then do;	S2_01800_0100			=aitem;	output o52; end;
	else if awlc		="S200000019000100"		then do;	S2_01900_0100			=aitem;	output o53; end;
	else if awlc		="S200000020000100"		then do;	S2_02000_0100			=aitem;	output o54; end;
	else if awlc		="S200000021000100"		then do;	S2_02100_0100			=aitem;	output o55; end;
	else if awlc		="S200000022000100"		then do;	S2_02200_0100			=aitem;	output o56; end;
	else if awlc		="S200000022010100"		then do;	S2_02201_0100			=aitem;	output o57; end;
	else if awlc		="S200000022020100"		then do;	S2_02202_0100			=aitem;	output o58; end;
	else if awlc		="S200000023000100"		then do;	S2_02300_0100			=aitem;	output o59; end;
	else if awlc		="S200000023000200"		then do;	S2_02300_0200			=aitem;	output o60; end;
	else if awlc		="S200000024000200"		then do;	S2_02400_0200			=aitem;	output o61; end;
	else if awlc		="S200000025000200"		then do;	S2_02500_0200			=aitem;	output o62; end;
	else if awlc		="S200000028000100"		then do;	S2_02800_0100			=aitem;	output o63; end;

****S2 and S3 NMRC****;

data s2nmrc s3nmrc;
set hhasrc.hha&yyear.nmrc;

if nwksht="S200000" then do;
   if fy_bgndt<mdy(12,31,2009) and fy_enddt>mdy(01,01,1995);
   length nlinecol $10.;
   nlinecol=nline || "_" || ncol;
   output s2nmrc;
end;
else if nwksht="S300000" then do;
   if fy_bgndt<mdy(12,31,2009) and fy_enddt>mdy(01,01,1995);
   if "00100"<=nline<="01002"; 	   *limit to Part I;
   length nlinecol $10.;
   nlinecol=nline || "_" || ncol;
   output s3nmrc;
end;

data
     dfydt(keep=rec_num prov_id fy_bgndt fy_enddt) 
     ditem(keep=rec_num nlinecol nitem);
set s2nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

proc transpose data=ditem out=titem(drop=_NAME_) prefix=S2_;
 by rec_num;
 id nlinecol;
run;

data s2nmrc;
merge dfydt titem;
 by rec_num;

**merge S2 alpha and nmrc data sets together;
data s2alphanmrc;
merge
      o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 
      o11 o12 o13 o14 o15 o16 o17 o18 o19 
      o20 o21 o22 o23 o24 o25 o26 o27 o28 o29 
      o30 o31 o32 o33 o34 o35 o36 o37 o38 o39 
      o40 o41 o42 o43 o44 o45 o46 o47 o48 o49
      o50 o51 o52 o53 o54 o55 o56 o57 o58 o59
      o60 o61 o62 o63
      s2nmrc;
 by rec_num;

**convert date fields to numeric, SAS mdy format;

data hha&yyear._S2;
set s2alphanmrc(rename=(
	hha_dt_certified		=c_hha_dt_certified
	hha_corf_dt_certified		=c_hha_corf_dt_certified
	hha_hospice_dt_certified	=c_hha_hospice_dt_certified
	hha_hospice2_dt_certified	=c_hha_hospice2_dt_certified
	hha_hospice3_dt_certified	=c_hha_hospice3_dt_certified
	hha_cmhc_dt_certified		=c_hha_cmhc_dt_certified
	hha_rhc_dt_certified		=c_hha_rhc_dt_certified
	hha_fqhc_dt_certified		=c_hha_fqhc_dt_certified
	hha_fqhc2_dt_certified		=c_hha_fqhc2_dt_certified
	hha_fqhc3_dt_certified		=c_hha_fqhc3_dt_certified
	hha_fqhc4_dt_certified		=c_hha_fqhc4_dt_certified
	hha_fqhc5_dt_certified		=c_hha_fqhc5_dt_certified
	hha_fqhc6_dt_certified		=c_hha_fqhc6_dt_certified
	hha_period_from_dt		=c_hha_period_from_dt
	hha_period_to_dt		=c_hha_period_to_dt));

**remove blanks, /, - from date values, they are sometimes present;

	c_hha_dt_certified 		=compress(c_hha_dt_certified		," (/-");
	c_hha_corf_dt_certified		=compress(c_hha_corf_dt_certified	," (/-");
	c_hha_hospice_dt_certified	=compress(c_hha_hospice_dt_certified	," (/-");
	c_hha_hospice2_dt_certified	=compress(c_hha_hospice2_dt_certified	," (/-");
	c_hha_hospice3_dt_certified	=compress(c_hha_hospice3_dt_certified	," (/-");
	c_hha_cmhc_dt_certified		=compress(c_hha_cmhc_dt_certified	," (/-");
	c_hha_rhc_dt_certified		=compress(c_hha_rhc_dt_certified	," (/-");
	c_hha_fqhc_dt_certified		=compress(c_hha_fqhc_dt_certified	," (/-");
	c_hha_fqhc2_dt_certified	=compress(c_hha_fqhc2_dt_certified	," (/-");
	c_hha_fqhc3_dt_certified	=compress(c_hha_fqhc3_dt_certified	," (/-");
	c_hha_fqhc4_dt_certified	=compress(c_hha_fqhc4_dt_certified	," (/-");
	c_hha_fqhc5_dt_certified	=compress(c_hha_fqhc5_dt_certified	," (/-");
	c_hha_fqhc6_dt_certified	=compress(c_hha_fqhc6_dt_certified	," (/-");
	c_hha_period_from_dt		=compress(c_hha_period_from_dt		," (/-");
	c_hha_period_to_dt		=compress(c_hha_period_to_dt		," (/-");

if c_hha_dt_certified ne " "			then	hha_dt_certified		=input(c_hha_dt_certified		,anydtdte9.);
if c_hha_corf_dt_certified ne " "		then	hha_corf_dt_certified		=input(c_hha_corf_dt_certified		,anydtdte9.);
if c_hha_hospice_dt_certified ne " "		then	hha_hospice_dt_certified	=input(c_hha_hospice_dt_certified	,anydtdte9.);
if c_hha_hospice2_dt_certified ne " "		then	hha_hospice2_dt_certified	=input(c_hha_hospice2_dt_certified	,anydtdte9.);
if c_hha_hospice3_dt_certified ne " "		then	hha_hospice3_dt_certified	=input(c_hha_hospice3_dt_certified	,anydtdte9.);
if c_hha_cmhc_dt_certified ne " "		then	hha_cmhc_dt_certified		=input(c_hha_cmhc_dt_certified		,anydtdte9.);
if c_hha_rhc_dt_certified ne " "		then	hha_rhc_dt_certified		=input(c_hha_rhc_dt_certified		,anydtdte9.);
if c_hha_fqhc_dt_certified ne " "		then	hha_fqhc_dt_certified		=input(c_hha_fqhc_dt_certified		,anydtdte9.);
if c_hha_fqhc2_dt_certified ne " "		then	hha_fqhc2_dt_certified		=input(c_hha_fqhc2_dt_certified		,anydtdte9.);
if c_hha_fqhc3_dt_certified ne " "		then	hha_fqhc3_dt_certified		=input(c_hha_fqhc3_dt_certified		,anydtdte9.);
if c_hha_fqhc4_dt_certified ne " "		then	hha_fqhc4_dt_certified		=input(c_hha_fqhc4_dt_certified		,anydtdte9.);
if c_hha_fqhc5_dt_certified ne " "		then	hha_fqhc5_dt_certified		=input(c_hha_fqhc5_dt_certified		,anydtdte9.);
if c_hha_fqhc6_dt_certified ne " "		then	hha_fqhc6_dt_certified		=input(c_hha_fqhc6_dt_certified		,anydtdte9.);
if c_hha_period_from_dt ne " " 	 		then	hha_period_from_dt		=input(c_hha_period_from_dt		,anydtdte9.);
if c_hha_period_to_dt ne " " 	 		then	hha_period_to_dt		=input(c_hha_period_to_dt		,anydtdte9.);

drop
 c_hha_dt_certified
 c_hha_corf_dt_certified
 c_hha_hospice_dt_certified
 c_hha_hospice2_dt_certified
 c_hha_hospice3_dt_certified
 c_hha_cmhc_dt_certified
 c_hha_rhc_dt_certified
 c_hha_fqhc_dt_certified
 c_hha_fqhc2_dt_certified
 c_hha_fqhc3_dt_certified
 c_hha_fqhc4_dt_certified
 c_hha_fqhc5_dt_certified
 c_hha_fqhc6_dt_certified
 c_hha_period_from_dt
 c_hha_period_to_dt;

format
	hha_dt_certified
	hha_corf_dt_certified
	hha_hospice_dt_certified
	hha_hospice2_dt_certified
	hha_hospice3_dt_certified
	hha_cmhc_dt_certified
	hha_rhc_dt_certified
	hha_fqhc_dt_certified
	hha_fqhc2_dt_certified
	hha_fqhc3_dt_certified
	hha_fqhc4_dt_certified
	hha_fqhc5_dt_certified
	hha_fqhc6_dt_certified
	hha_period_from_dt
	hha_period_to_dt		date8.;

label
	fy_bgndt                        ="FY Begin Dt"
	fy_enddt                        ="FY end Dt"
 	hha_street			="hha_street"
	hha_po_box			="hha_po_box"
	hha_po_box2			="hha_po_box2"
	hha_city			="hha_city"
	hha_state			="hha_state"
	hha_zipcode			="hha_zip_code"
	hha_name			="hha_name"
	hha_prov_id			="prov_id"
	hha_dt_certified		="hha_dt_certified"
	hha_corf_name			="hha_corf_name"
	hha_corf_prov_id		="hha_corf_prov_id"
	hha_corf_dt_certified		="hha_corf_dt_certified"
	hha_hospice_name		="hha_hospice_name"
	hha_hospice_prov_id		="hha_hospice_prov_id"
	hha_hospice_dt_certified	="hha_hospice_dt_certified"
	hha_hospice2_name		="hha_hospice2_name"
	hha_hospice2_prov_id		="hha_hospice2_prov_id"
	hha_hospice2_dt_certified	="hha_hospice2_dt_certified"
	hha_hospice3_name		="hha_hospice3_name"
	hha_hospice3_prov_id		="hha_hospice3_prov_id"
	hha_hospice3_dt_certified	="hha_hospice3_dt_certified"
	hha_cmhc_name			="hha_cmhc_name"
	hha_cmhc_prov_id		="hha_cmhc_prov_id"
	hha_cmhc_dt_certified		="hha_cmhc_dt_certified"
	hha_rhc_name			="hha_rhc_name"
	hha_rhc_prov_id			="hha_rhc_prov_id"
	hha_rhc_dt_certified		="hha_rhc_dt_certified"
	hha_fqhc_name			="hha_fqhc_name"
	hha_fqhc_prov_id		="hha_fqhc_prov_id"
	hha_fqhc_dt_certified		="hha_fqhc_dt_certified"
	hha_fqhc2_name			="hha_fqhc2_name"
	hha_fqhc2_prov_id		="hha_fqhc2_prov_id"
	hha_fqhc2_dt_certified		="hha_fqhc2_dt_certified"
	hha_fqhc3_name			="hha_fqhc3_name"
	hha_fqhc3_prov_id		="hha_fqhc3_prov_id"
	hha_fqhc3_dt_certified		="hha_fqhc3_dt_certified"
	hha_fqhc4_name			="hha_fqhc4_name"
	hha_fqhc4_prov_id		="hha_fqhc4_prov_id"
	hha_fqhc4_dt_certified		="hha_fqhc4_dt_certified"
	hha_fqhc5_name			="hha_fqhc5_name"
	hha_fqhc5_prov_id		="hha_fqhc5_prov_id"
	hha_fqhc5_dt_certified		="hha_fqhc5_dt_certified"
	hha_fqhc6_name			="hha_fqhc6_name"
	hha_fqhc6_prov_id		="hha_fqhc6_prov_id"
	hha_fqhc6_dt_certified		="hha_fqhc6_dt_certified"
	hha_period_from_dt		="hha_period_from_dt"
	hha_period_to_dt		="hha_period_to_dt"
        S2_00607_0300			="hha_fqhc6_dt_certified"
	S2_00800_0100                	="hha_type_of_control"
	S2_00900_0100			="hha_low_medicare_util"
	S2_01000_0100                   ="hha_depreciation_straight_line"
	S2_01100_0100                   ="hha_depreciation_declining_balance"
	S2_01200_0100                   ="hha_depreciation_sum_of_years_digits"
	S2_01300_0100                   ="hha_depreciation_sum_lines_10_11_12"
	S2_01400_0100			="hha_dispose_capital"
	S2_01500_0100			="hha_accel_depreciation"
	S2_01600_0100			="hha_accel_dep_post_08011970"
	S2_01700_0100                   ="hha_amt_funded_depreciation"
	S2_01800_0100			="hha_cease_participate_medicare"
	S2_01900_0100			="hha_less_insurance_allow_cost"
	S2_02000_0100			="hha_qualify_small_hha"
	S2_02100_0100			="hha_qualify_nominal_charge_provider"
	S2_02200_0100			="hha_contract_outside_pt_services"
	S2_02201_0100			="hha_contract_outside_ot_services"
	S2_02202_0100			="hha_contract_outside_st_services"
	S2_02300_0100			="hha_parta_exempt_lower_cost_charge"
	S2_02300_0200			="hha_partb_exempt_lower_cost_charge"
	S2_02400_0200			="hha_corf_partb_exempt_lower_cost_charge"
	S2_02500_0200			="hha_cmhc_partb_exempt_lower_cost_charge"
	S2_02600_0100                   ="hha_componentized_option"
        S2_02700_0100               	="hha_amt_malpractice_premiums_losses"
	S2_02701_0100                   ="hha_amt_malpractice_premiums"
	S2_02702_0100                   ="hha_amt_malpractice_paid_losses"
	S2_02703_0100                   ="hha_amt_self_insurance"
	S2_02800_0100			="hha_malpractice_expense_reported_elsewhere"
	;

*=========================================================================================================================================;
***zip_code edit***;

length hha_zipcode5 $5. hha_zipcode9 $10.;

hha_zipcode5=substr(hha_zipcode,1,5);
if substr(hha_zipcode,6,5)="-     " then hha_zipcode=substr(hha_zipcode,1,5);
else if "-0001"<=substr(hha_zipcode,6,5)<="-9999" then hha_zipcode9=hha_zipcode;

drop hha_zipcode;
label	hha_zipcode5	="HHA Zip Code-5 (hha_zipcode)"
	hha_zipcode9	="HHA Zip Code-9 (hha_zipcode)"
	;

*=========================================================================================================================================;
***name, street, po box edit***;

hha_name=strip(hha_name);
hha_name=upcase(hha_name);
hha_name=compress(hha_name, '(),');
hha_name=compbl(hha_name);
hha_name=tranwrd(hha_name, ' INC.',		', INC');
hha_name=tranwrd(hha_name, ',, INC.',		', INC');
hha_name=tranwrd(hha_name, ' AND ',		' & ');
hha_name=tranwrd(hha_name, ' - ',			'-');
hha_name=tranwrd(hha_name, ' L L C ',		' LLC ');
hha_name=tranwrd(hha_name, ' L.L.C. ',		' LLC ');
hha_name=tranwrd(hha_name, ',,',	  		',');

hha_name=tranwrd(hha_name, ' CONV. ',		' CONVALESCENT ');
hha_name=tranwrd(hha_name, ' CONV ',		' CONVALESCENT ');
hha_name=tranwrd(hha_name, ' CTR ',		' CENTER ');
hha_name=tranwrd(hha_name, ' CTR. ',		' CENTER ');
hha_name=tranwrd(hha_name, ' CTRE ',		' CENTER ');
hha_name=tranwrd(hha_name, ' CTRE. ',		' CENTER ');
hha_name=tranwrd(hha_name, ' CNTR ',		' CENTER ');
hha_name=tranwrd(hha_name, ' CNTR. ',		' CENTER ');
hha_name=tranwrd(hha_name, ' SAINT ',		' ST ');
hha_name=tranwrd(hha_name, ' ST. ',		' ST ');
hha_name=tranwrd(hha_name, ' HOSP ',		' HOSPITAL ');
hha_name=tranwrd(hha_name, ' HOSP. ',		' HOSPITAL ');
hha_name=tranwrd(hha_name, 'REHABILITATION',	'REHAB');
hha_name=tranwrd(hha_name, ' NURS ',		' NURSING ');
hha_name=tranwrd(hha_name, ' D/P ',		' DP ');
hha_name=tranwrd(hha_name, ' D P ',		' DP ');
hha_name=tranwrd(hha_name, ' ST. ',		' ST ');

hha_name=tranwrd(hha_name, 'REHABILITATION',	'REHAB');
hha_name=tranwrd(hha_name, 'REHABILITATIO ',	'REHAB ');
hha_name=tranwrd(hha_name, 'REHABILITATI ',	'REHAB ');
hha_name=tranwrd(hha_name, 'REHABILITAT ',	'REHAB ');
hha_name=tranwrd(hha_name, 'REHABILITA ',		'REHAB ');
hha_name=tranwrd(hha_name, 'REHABILIT ',		'REHAB ');
hha_name=tranwrd(hha_name, 'REHABILI ',		'REHAB ');
hha_name=tranwrd(hha_name, 'REHABIL ',		'REHAB ');
hha_name=tranwrd(hha_name, 'REHABI ',		'REHAB ');
hha_name=tranwrd(hha_name, 'CORPORATION',		'CORP');
hha_name=tranwrd(hha_name, 'CORPORATIO',		'CORP');
hha_name=tranwrd(hha_name, 'CORPORATI',		'CORP');
hha_name=tranwrd(hha_name, 'CORPORAT',		'CORP');
hha_name=tranwrd(hha_name, 'CORPORA',		'CORP');
hha_name=tranwrd(hha_name, 'CORPOR',		'CORP');
hha_name=tranwrd(hha_name, 'CORPO',		'CORP');

hha_name=tranwrd(hha_name, ' NRSG ',		' NURSING ');
hha_name=tranwrd(hha_name, ' NRSG. ',		' NURSING ');
hha_name=tranwrd(hha_name, ' NSG ',		' NURSING ');
hha_name=tranwrd(hha_name, ' NSG. ',		' NURSING ');
hha_name=tranwrd(hha_name, 'NURS ',		'NURSING ');
hha_name=tranwrd(hha_name, 'FACIL ',		'FACILITY ');
hha_name=tranwrd(hha_name, 'FACI ',		'FACILITY ');
hha_name=tranwrd(hha_name, 'FAC ',		'FACILITY ');
hha_name=tranwrd(hha_name, 'NURSING FACILITY',	'NF');
hha_name=tranwrd(hha_name, 'SKIL ',		'SKILLED ');
hha_name=tranwrd(hha_name, 'SKILLED NURSING',	'SNF');
hha_name=tranwrd(hha_name, 'SNFF',		'SNF');
hha_name=tranwrd(hha_name, 'SKILLED NF',		'SNF');
hha_name=tranwrd(hha_name, 'NURSING HOME',	'NH');
hha_name=tranwrd(hha_name, ' HC ' , 		' HEALTHCARE ');
hha_name=tranwrd(hha_name, ',THE' , 		' ');
*=========================================================================================================================================;

Hha_Street=strip(Hha_Street);
Hha_Street=upcase(Hha_Street);
Hha_Street=compress(Hha_Street, ".-(),");
Hha_Street=compbl(Hha_Street);
Hha_Street=tranwrd(Hha_Street, 'STREET',			'ST');
Hha_Street=tranwrd(Hha_Street, 'AVENUE',			'AVE');
Hha_Street=tranwrd(Hha_Street, 'HIGHWAY',			'HWY');
Hha_Street=tranwrd(Hha_Street, ' DRIVE ',			' DR ');
Hha_Street=tranwrd(Hha_Street, ' CTR ',			' CENTER ');
Hha_Street=tranwrd(Hha_Street, ' ROAD ',			' RD ');
Hha_Street=tranwrd(Hha_Street, ' LN ',			' LANE ');
Hha_Street=tranwrd(Hha_Street, 'BOULEVARD',		'BLVD');
Hha_Street=tranwrd(Hha_Street, 'PARKWAY',			'PKWY');
Hha_Street=tranwrd(Hha_Street, ' CIR ',			' CIRCLE ');
Hha_Street=tranwrd(Hha_Street, ' CTR ',			' CENTER ');

if substr(Hha_Street,1,3)='RR ' then Hha_Street=tranwrd(Hha_Street, 'RR ',		'RURAL ROUTE ');
Hha_Street=tranwrd(Hha_Street, ' RR ',		        ' RURAL ROUTE ');
Hha_Street=tranwrd(Hha_Street, ' RT ',			' ROUTE ');
Hha_Street=tranwrd(Hha_Street, ' RTE ',			' ROUTE ');

if substr(Hha_Street,1,4)='BOX ' then Hha_Street=tranwrd(Hha_Street, 'BOX ',		'PO BOX ');

Hha_Street=tranwrd(Hha_Street, ',P O ',			', P O ');
Hha_Street=tranwrd(Hha_Street, ', P O ',			' PO BOX ');
Hha_Street=tranwrd(Hha_Street, 'P O ',			'PO BOX ');
Hha_Street=tranwrd(Hha_Street, ' BOX ',		    	' PO BOX ');
Hha_Street=tranwrd(Hha_Street, 'PO ',		     	'PO BOX ');
Hha_Street=tranwrd(Hha_Street, ' BOX BOX ',		' BOX ');
Hha_Street=tranwrd(Hha_Street, ' PO PO ',			' PO ');
Hha_Street=tranwrd(Hha_Street, 'PO BOX PO BOX',		'PO BOX');
Hha_Street=tranwrd(Hha_Street, 'PO BOX DRAWER',		'PO BOX'); 
Hha_Street=tranwrd(Hha_Street, ' BOX BOX ',		' BOX ');

Hha_Street=tranwrd(Hha_Street, ' FIRST ',			' 1ST ');
Hha_Street=tranwrd(Hha_Street, ' SECOND ',		' 2ND ');
Hha_Street=tranwrd(Hha_Street, ' THIRD ',			' 3RD ');
Hha_Street=tranwrd(Hha_Street, ' FOURTH ',		' 4TH ');
Hha_Street=tranwrd(Hha_Street, ' FIFTH ',			' 5TH '); 
Hha_Street=tranwrd(Hha_Street, ' SIXTH ',			' 6TH ');
Hha_Street=tranwrd(Hha_Street, ' SEVENTH ',		' 7TH ');
Hha_Street=tranwrd(Hha_Street, ' EIGHTH ',		' 8TH ');
Hha_Street=tranwrd(Hha_Street, ' NINTH ',			' 9TH ');
Hha_Street=tranwrd(Hha_Street, ' TENTH ',			' 10TH ');
Hha_Street=tranwrd(Hha_Street, ' ELEVENTH ',		' 11TH ');
Hha_Street=tranwrd(Hha_Street, ' TWELFTH ',		' 12TH ');
Hha_Street=tranwrd(Hha_Street, ' THIRTEENTH ',		' 13TH ');
Hha_Street=tranwrd(Hha_Street, ' FOURTEENTH ',		' 14TH ');
Hha_Street=tranwrd(Hha_Street, ' FIFTEENTH ',		' 15TH ');
Hha_Street=tranwrd(Hha_Street, ' SIXTEENTH ',		' 16TH ');
Hha_Street=tranwrd(Hha_Street, ' SEVENTEENTH ',		' 17TH ');
Hha_Street=tranwrd(Hha_Street, ' EIGHTEENTH ',		' 18TH ');
Hha_Street=tranwrd(Hha_Street, ' NINETEENTH ',		' 19TH ');

Hha_Street=tranwrd(Hha_Street, ' AND ',			' & ');
Hha_Street=tranwrd(Hha_Street, ' NORTH ',			' N ');
Hha_Street=tranwrd(Hha_Street, ' NO ',			' N ');
Hha_Street=tranwrd(Hha_Street, ' SOUTH ',			' S ');
Hha_Street=tranwrd(Hha_Street, ' SO ',			' S ');

Hha_Street=tranwrd(Hha_Street, ' EAST ',			' E ');
Hha_Street=tranwrd(Hha_Street, ' WEST ',			' W ');
Hha_Street=tranwrd(Hha_Street, ' NORTHWEST ',		' NW ');
Hha_Street=tranwrd(Hha_Street, ' SOUTHWEST ',		' SW ');
Hha_Street=tranwrd(Hha_Street, ' NORTHEAST ',		' NE ');
Hha_Street=tranwrd(Hha_Street, ' SOUTHEAST ',		' SE ');

Hha_Street=tranwrd(Hha_Street, ' PLZ ',			' PLAZA ');
Hha_Street=tranwrd(Hha_Street, ' MOUNT ',			' MT ');

*=========================================================================================================================================;
if substr(Hha_Po_Box,1,3)='RR ' then Hha_Po_Box=tranwrd(Hha_Po_Box, 'RR ',		'RURAL ROUTE ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' RR ',		        ' RURAL ROUTE ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' RT ',			' ROUTE ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' RTE ',			' ROUTE ');

if substr(Hha_Po_Box,1,4)='BOX ' then Hha_Po_Box=tranwrd(Hha_Po_Box, 'BOX ',		'PO BOX ');

Hha_Po_Box=tranwrd(Hha_Po_Box, ',P O ',			', P O ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ', P O ',			' PO BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P O ',			'PO BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' BOX ',		    	' PO BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'PO ',		     	'PO BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' BOX BOX ',		' BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, ' PO PO ',			' PO ');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'PO BOX PO BOX',		'PO BOX');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'PO BOX DRAWER',		'PO BOX'); 
Hha_Po_Box=tranwrd(Hha_Po_Box, ' BOX BOX ',		' BOX ');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P.O. PO BOX',		'PO BOX');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P. O. PO BOX',		'PO BOX');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P.O.DRAWER',		'PO Drawer');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P.O. DRAWER',		'PO Drawer');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'P.O.BOX',			'PO Box');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'N/A',			'  ');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'PO BOX BX',		'PO BOX');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'POBOX',			'PO BOX');
Hha_Po_Box=tranwrd(Hha_Po_Box, 'POST PO BOX',		'PO BOX');
*=========================================================================================================================================;

%MEND MGETS2;

*=========================================================================================================================================;
***		S3 Worksheet		***;
*=========================================================================================================================================;
%MACRO MGETS3(yyear);

data
     dfydt(keep=rec_num prov_id fy_bgndt fy_enddt) 
     ditem(keep=rec_num nlinecol nitem);
set s3nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

proc transpose data=ditem out=titem(drop=_NAME_) prefix=S3_;
 by rec_num;
 id nlinecol;
run;

data hha&yyear._S3;
merge dfydt titem;
 by rec_num;

label
	prov_id			="Provider ID"
	S3_00100_0100		="hha_snf_18_visits"
	S3_00100_0200		="hha_snf_18_pts"
	S3_00100_0300		="hha_snf_oth_visits"
	S3_00100_0400		="hha_snf_oth_pts"
	S3_00100_0500		="hha_snf_tot_visits"
	S3_00100_0600		="hha_snf_tot_pts"
	S3_00200_0100		="hha_pt_18_visits"
	S3_00200_0200		="hha_pt_18_pts"
	S3_00200_0300		="hha_pt_oth_visits"
	S3_00200_0400		="hha_pt_oth_pts"
	S3_00200_0500		="hha_pt_tot_visits"
	S3_00200_0600		="hha_pt_tot_pts"
	S3_00300_0100		="hha_ot_18_visits"
	S3_00300_0200		="hha_ot_18_pts"
	S3_00300_0300		="hha_ot_oth_visits"
	S3_00300_0400		="hha_ot_oth_pts"
	S3_00300_0500		="hha_ot_tot_visits"
	S3_00300_0600		="hha_ot_tot_pts"
	S3_00400_0100		="hha_sp_18_visits"
	S3_00400_0200		="hha_sp_18_pts"
	S3_00400_0300		="hha_sp_oth_visits"
	S3_00400_0400		="hha_sp_oth_pts"
	S3_00400_0500		="hha_sp_tot_visits"
	S3_00400_0600		="hha_sp_tot_pts"
	S3_00500_0100		="hha_mss_18_visits"
	S3_00500_0200		="hha_mss_18_pts"
	S3_00500_0300		="hha_mss_oth_visits"
	S3_00500_0400		="hha_mss_oth_pts"
	S3_00500_0500		="hha_mss_tot_visits"
	S3_00500_0600		="hha_mss_tot_pts"
	S3_00600_0100		="hha_hhaide_18_visits"
	S3_00600_0200		="hha_hhaide_18_pts"
	S3_00600_0300		="hha_hhaide_oth_visits"
	S3_00600_0400		="hha_hhaide_oth_pts"
	S3_00600_0500		="hha_hhaide_tot_visits"
	S3_00600_0600		="hha_hhaide_tot_pts"
	S3_00601_0100		="hha_hhaide2_18_visits"
	S3_00601_0200		="hha_hhaide2_18_pts"
	S3_00601_0300		="hha_hhaide2_oth_visits"
	S3_00601_0400		="hha_hhaide2_oth_pts"
	S3_00601_0500		="hha_hhaide2_tot_visits"
	S3_00601_0600		="hha_hhaide2_tot_pts"
	S3_00700_0300		="hha_all_other_oth_visits"
	S3_00700_0400		="hha_all_other_oth_pts"
	S3_00700_0500		="hha_all_other_tot_visits"
	S3_00700_0600		="hha_all_other_tot_pts"
	S3_00800_0100		="hha_tot_visits_18_visits"
	S3_00800_0300		="hha_tot_visits_oth_visits"
	S3_00800_0500		="hha_tot_visits_tot_visits"
	S3_00900_0100		="hha_hhaide_18_pts"
	S3_00900_0300		="hha_hhaide_oth_pts"
	S3_00900_0500		="hha_hhaide_tot_pts"
	S3_01000_0000		="hha_hhaide_col0"
	S3_01000_0200		="hha_hhaide_18_pts"
	S3_01000_0400		="hha_hhaide_oth_pts"
	S3_01000_0600		="hha_hhaide_tot_pts"
	S3_01001_0200		="hha_undup_census_pre10012000_18_pts"
	S3_01001_0400		="hha_undup_census_pre10012000_oth_pts"
	S3_01001_0600		="hha_undup_census_pre10012000_tot_pts"
	S3_01002_0200		="hha_undup_census_post09302000_18_pts"
	S3_01002_0400		="hha_undup_census_post09302000_oth_pts"
	S3_01002_0600		="hha_undup_census_post09302000_tot_pts";

**	S3_01100_0000		="hha_wkly_hrs_admin_staff"
	S3_01100_0100		="hha_wkly_hrs_admin_contract"
	S3_01100_0200		="hha_wkly_hrs_admin_total"
	S3_01200_0000		="hha_wkly_hrs_director_staff"
	S3_01200_0100		="hha_wkly_hrs_director_contract"
	S3_01200_0200		="hha_wkly_hrs_director_total"
	S3_01300_0100		="hha_wkly_hrs_oth_admin_staff"
	S3_01300_0200		="hha_wkly_hrs_oth_admin_contract"
	S3_01400_0100		="hha_wkly_hrs_nursing_staff"
	S3_01400_0200		="hha_wkly_hrs_nursing_contract"
	S3_01500_0100		="hha_wkly_hrs_nursing_super_staff"
	S3_01500_0200		="hha_wkly_hrs_nursing_super_contract"
	S3_01600_0100		="hha_wkly_hrs_pt_staff"
	S3_01600_0200		="hha_wkly_hrs_pt_contract"
	S3_01700_0100		="hha_wkly_hrs_pt_super_staff"
	S3_01700_0200		="hha_wkly_hrs_pt_super_contract"
	S3_01800_0100		="hha_wkly_hrs_ot_super_staff"
	S3_01800_0200		="hha_wkly_hrs_ot_super_contract"
	S3_01900_0100		="hha_wkly_hrs_ot_super_staff"
	S3_01900_0200		="hha_wkly_hrs_ot_super_contract"
	S3_02000_0100		="hha_wkly_hrs_ot_spchpath_staff"
	S3_02000_0200		="hha_wkly_hrs_ot_spchpath_contract"
        S3_02000_0400           ="hha_wkly_hrs_ot_spchpath_col4"
	S3_02100_0100		="hha_wkly_hrs_ot_spchpath_super_staff"
	S3_02100_0200		="hha_wkly_hrs_ot_spchpath_super_contract"
	S3_02200_0100		="hha_wkly_hrs_ot_medsocsvc_staff"
	S3_02200_0200		="hha_wkly_hrs_ot_medsocsvc_contract"
	S3_02300_0100		="hha_wkly_hrs_ot_medsocsvc_super_staff"
	S3_02300_0200		="hha_wkly_hrs_ot_medsocsvc_super_contract"
	S3_02400_0100		="hha_wkly_hrs_ot_hhaide_staff"
	S3_02400_0200		="hha_wkly_hrs_ot_hhaide_contract"
	S3_02500_0100		="hha_wkly_hrs_ot_hhaide_super_staff"
	S3_02500_0200		="hha_wkly_hrs_ot_hhaide_super_contract"
	S3_02600_0100		="hha_wkly_hrs_line26_staff"
	S3_02600_0200		="hha_wkly_hrs_line26_contract"
	S3_02700_0100		="hha_wkly_hrs_line27_staff"
	S3_02700_0200		="hha_wkly_hrs_line27_contract"
	S3_02701_0100		="hha_wkly_hrs_line2701_staff"
        S3_02701_0200           ="hha_wkly_hrs_line2701_contract"
	S3_02702_0200		="hha_wkly_hrs_line2701_contract"
	S3_02800_0100		="hha_num_msas_mcare_provided"
	S3_02800_0101		="hha_num_cbsas_mcare_provided"
	S3_03000_0100		="hha_sn_full_episodes_no_outliers"
	S3_03000_0200		="hha_sn_full_episodes_with_outliers"
	S3_03000_0300		="hha_sn_lupa_episodes"
	S3_03000_0400		="hha_sn_pep_only_episodes"
	S3_03000_0500		="hha_sn_scic_in_pep_episodes"
	S3_03000_0600		="hha_sn_scic_only_episodes"
	S3_03100_0100		="hha_sn_charges_full_episodes_no_outliers"
	S3_03100_0200		="hha_sn_charges_full_episodes_with_outliers"
	S3_03100_0300		="hha_sn_charges_lupa_episodes"
	S3_03100_0400		="hha_sn_charges_pep_only_episodes"
	S3_03100_0500		="hha_sn_charges_scic_in_pep_episodes"
	S3_03100_0600		="hha_sn_charges_scic_only_episodes"
	S3_03200_0100		="hha_pt_full_episodes_no_outliers"
	S3_03200_0200		="hha_pt_full_episodes_with_outliers"
	S3_03200_0300		="hha_pt_lupa_episodes"
	S3_03200_0400		="hha_pt_pep_only_episodes"
	S3_03200_0500		="hha_pt_scic_in_pep_episodes"
	S3_03200_0600		="hha_pt_scic_only_episodes"
	S3_03300_0100		="hha_pt_charges_full_episodes_no_outliers"
	S3_03300_0200		="hha_pt_charges_full_episodes_with_outliers"
	S3_03300_0300		="hha_pt_charges_lupa_episodes"
	S3_03300_0400		="hha_pt_charges_pep_only_episodes"
	S3_03300_0500		="hha_pt_charges_scic_in_pep_episodes"
	S3_03300_0600		="hha_pt_charges_scic_only_episodes"
	S3_03400_0100		="hha_ot_full_episodes_no_outliers"
	S3_03400_0200		="hha_ot_full_episodes_with_outliers"
	S3_03400_0300		="hha_ot_lupa_episodes"
	S3_03400_0400		="hha_ot_pep_only_episodes"
	S3_03400_0500		="hha_ot_scic_in_pep_episodes"
	S3_03400_0600		="hha_ot_scic_only_episodes"
	S3_03500_0100		="hha_ot_charges_full_episodes_no_outliers"
	S3_03500_0200		="hha_ot_charges_full_episodes_with_outliers"
	S3_03500_0300		="hha_ot_charges_lupa_episodes"
	S3_03500_0400		="hha_ot_charges_pep_only_episodes"
	S3_03500_0500		="hha_ot_charges_scic_in_pep_episodes"
	S3_03500_0600		="hha_ot_charges_scic_only_episodes"
	S3_03600_0100		="hha_spchpath_full_episodes_no_outliers"
	S3_03600_0200		="hha_spchpath_full_episodes_with_outliers"
	S3_03600_0300		="hha_spchpath_lupa_episodes"
	S3_03600_0400		="hha_spchpath_pep_only_episodes"
	S3_03600_0500		="hha_spchpath_scic_in_pep_episodes"
	S3_03600_0600		="hha_spchpath_scic_only_episodes"
	S3_03700_0100		="hha_spchpath_charges_full_episodes_no_outliers"
	S3_03700_0200		="hha_spchpath_charges_full_episodes_with_outliers"
	S3_03700_0300		="hha_spchpath_charges_lupa_episodes"
	S3_03700_0400		="hha_spchpath_charges_pep_only_episodes"
	S3_03700_0500		="hha_spchpath_charges_scic_in_pep_episodes"
	S3_03700_0600		="hha_spchpath_charges_scic_only_episodes"
	S3_03800_0100		="hha_medsocsvc_full_episodes_no_outliers"
	S3_03800_0200		="hha_medsocsvc_full_episodes_with_outliers"
	S3_03800_0300		="hha_medsocsvc_lupa_episodes"
	S3_03800_0400		="hha_medsocsvc_pep_only_episodes"
	S3_03800_0500		="hha_medsocsvc_scic_in_pep_episodes"
	S3_03800_0600		="hha_medsocsvc_scic_only_episodes"
	S3_03900_0100		="hha_medsocsvc_charges_full_episodes_no_outliers"
	S3_03900_0200		="hha_medsocsvc_charges_full_episodes_with_outliers"
	S3_03900_0300		="hha_medsocsvc_charges_lupa_episodes"
	S3_03900_0400		="hha_medsocsvc_charges_pep_only_episodes"
	S3_03900_0500		="hha_medsocsvc_charges_scic_in_pep_episodes"
	S3_03900_0600		="hha_medsocsvc_charges_scic_only_episodes"
	S3_04000_0100		="hha_hhaide_full_episodes_no_outliers"
	S3_04000_0200		="hha_hhaide_full_episodes_with_outliers"
	S3_04000_0300		="hha_hhaide_lupa_episodes"
	S3_04000_0400		="hha_hhaide_pep_only_episodes"
	S3_04000_0500		="hha_hhaide_scic_in_pep_episodes"
	S3_04000_0600		="hha_hhaide_scic_only_episodes"
	S3_04100_0100		="hha_hhaide_charges_full_episodes_no_outliers"
	S3_04100_0200		="hha_hhaide_charges_full_episodes_with_outliers"
	S3_04100_0300		="hha_hhaide_charges_lupa_episodes"
	S3_04100_0400		="hha_hhaide_charges_pep_only_episodes"
	S3_04100_0500		="hha_hhaide_charges_scic_in_pep_episodes"
	S3_04100_0600		="hha_hhaide_charges_scic_only_episodes"
	S3_04200_0100		="hha_tot_visits_full_episodes_no_outliers"
	S3_04200_0200		="hha_tot_visits_full_episodes_with_outliers"
	S3_04200_0300		="hha_tot_visits_lupa_episodes"
	S3_04200_0400		="hha_tot_visits_pep_only_episodes"
	S3_04200_0500		="hha_tot_visits_scic_in_pep_episodes"
	S3_04200_0600		="hha_tot_visits_scic_only_episodes"
	S3_04300_0100		="hha_other_charges_full_episodes_no_outliers"
	S3_04300_0200		="hha_other_charges_full_episodes_with_outliers"
	S3_04300_0300		="hha_other_charges_lupa_episodes"
	S3_04300_0400		="hha_other_charges_pep_only_episodes"
	S3_04300_0500		="hha_other_charges_scic_in_pep_episodes"
	S3_04300_0600		="hha_other_charges_scic_only_episodes"
	S3_04400_0100		="hha_total_charges_full_episodes_no_outliers"
	S3_04400_0200		="hha_total_charges_full_episodes_with_outliers"
	S3_04400_0300		="hha_total_charges_lupa_episodes"
	S3_04400_0400		="hha_total_charges_pep_only_episodes"
	S3_04400_0500		="hha_total_charges_scic_in_pep_episodes"
	S3_04400_0600		="hha_total_charges_scic_only_episodes"
	S3_04500_0100		="hha_total_num_full_episodes_no_outliers"
	S3_04500_0200		="hha_total_num_full_episodes_with_outliers"
	S3_04500_0300		="hha_total_num_lupa_episodes"
	S3_04500_0400		="hha_total_num_pep_only_episodes"
	S3_04500_0500		="hha_total_num_scic_in_pep_episodes"
	S3_04500_0600		="hha_total_num_scic_only_episodes"
	S3_04600_0100		="hha_total_num_outlier_full_episodes_no_outliers"
	S3_04600_0200		="hha_total_num_outlier_full_episodes_with_outliers"
	S3_04600_0300		="hha_total_num_outlier_lupa_episodes"
	S3_04600_0400		="hha_total_num_outlier_pep_only_episodes"
	S3_04600_0500		="hha_total_num_outlier_scic_in_pep_episodes"
	S3_04600_0600		="hha_total_num_outlier_scic_only_episodes"
	S3_04700_0100		="hha_total_nonroutine_med_supply_charges_full_episodes_no_outliers"
	S3_04700_0200		="hha_total_nonroutine_med_supply_charges_full_episodes_with_outliers"
	S3_04700_0300		="hha_total_nonroutine_med_supply_charges_lupa_episodes"
	S3_04700_0400		="hha_total_nonroutine_med_supply_charges_pep_only_episodes"
	S3_04700_0500		="hha_total_nonroutine_med_supply_charges_scic_in_pep_episodes"
	S3_04700_0600		="hha_total_nonroutine_med_supply_charges_scic_only_episodes"
        S3_05000_0400           ="S3 Line 50 Col 4"
        S3_05100_0200           ="S3 Line 51 Col 2"
        S3_06000_0200           ="S3 Line 60 Col 2"
        S3_09000_0400           ="S3 Line 90 Col 4"
	;

%MEND MGETS3;

*=========================================================================================================================================;
%MACRO MMERGEALLS2S3;

data hha_S2;
merge 
      hha1996_S2
      hha1997_S2
      hha1998_S2
      hha1999_S2
      hha2000_S2
      hha2001_S2
      hha2002_S2
      hha2003_S2
      hha2004_S2
      hha2005_S2
      hha2006_S2
      hha2007_S2
      hha2008_S2
      hha2009_S2;
 by rec_num;

length bgn_yr end_yr 3.;

     if mdy(01,01,1995)<=fy_bgndt<mdy(01,01,1996) then bgn_yr=1995;
else if mdy(01,01,1996)<=fy_bgndt<mdy(01,01,1997) then bgn_yr=1996;
else if mdy(01,01,1997)<=fy_bgndt<mdy(01,01,1998) then bgn_yr=1997;
else if mdy(01,01,1998)<=fy_bgndt<mdy(01,01,1999) then bgn_yr=1998;
else if mdy(01,01,1999)<=fy_bgndt<mdy(01,01,2000) then bgn_yr=1999;
else if mdy(01,01,2000)<=fy_bgndt<mdy(01,01,2001) then bgn_yr=2000;
else if mdy(01,01,2001)<=fy_bgndt<mdy(01,01,2002) then bgn_yr=2001;
else if mdy(01,01,2002)<=fy_bgndt<mdy(01,01,2003) then bgn_yr=2002;
else if mdy(01,01,2003)<=fy_bgndt<mdy(01,01,2004) then bgn_yr=2003;
else if mdy(01,01,2004)<=fy_bgndt<mdy(01,01,2005) then bgn_yr=2004;
else if mdy(01,01,2005)<=fy_bgndt<mdy(01,01,2006) then bgn_yr=2005;
else if mdy(01,01,2006)<=fy_bgndt<mdy(01,01,2007) then bgn_yr=2006;
else if mdy(01,01,2007)<=fy_bgndt<mdy(01,01,2008) then bgn_yr=2007;
else if mdy(01,01,2008)<=fy_bgndt<mdy(01,01,2009) then bgn_yr=2008;
else if mdy(01,01,2009)<=fy_bgndt<mdy(01,01,2010) then bgn_yr=2009;

     if mdy(01,01,1995)<=fy_enddt<mdy(01,01,1996) then end_yr=1995;
else if mdy(01,01,1996)<=fy_enddt<mdy(01,01,1997) then end_yr=1996;
else if mdy(01,01,1997)<=fy_enddt<mdy(01,01,1998) then end_yr=1997;
else if mdy(01,01,1998)<=fy_enddt<mdy(01,01,1999) then end_yr=1998;
else if mdy(01,01,1999)<=fy_enddt<mdy(01,01,2000) then end_yr=1999;
else if mdy(01,01,2000)<=fy_enddt<mdy(01,01,2001) then end_yr=2000;
else if mdy(01,01,2001)<=fy_enddt<mdy(01,01,2002) then end_yr=2001;
else if mdy(01,01,2002)<=fy_enddt<mdy(01,01,2003) then end_yr=2002;
else if mdy(01,01,2003)<=fy_enddt<mdy(01,01,2004) then end_yr=2003;
else if mdy(01,01,2004)<=fy_enddt<mdy(01,01,2005) then end_yr=2004;
else if mdy(01,01,2005)<=fy_enddt<mdy(01,01,2006) then end_yr=2005;
else if mdy(01,01,2006)<=fy_enddt<mdy(01,01,2007) then end_yr=2006;
else if mdy(01,01,2007)<=fy_enddt<mdy(01,01,2008) then end_yr=2007;
else if mdy(01,01,2008)<=fy_enddt<mdy(01,01,2009) then end_yr=2008;
else if mdy(01,01,2009)<=fy_enddt<mdy(01,01,2010) then end_yr=2009;

data hha_S3;
merge 
      hha1996_S3
      hha1997_S3
      hha1998_S3
      hha1999_S3
      hha2000_S3
      hha2001_S3
      hha2002_S3
      hha2003_S3
      hha2004_S3
      hha2005_S3
      hha2006_S3
      hha2007_S3
      hha2008_S3
      hha2009_S3;
 by rec_num;

length bgn_yr end_yr 3.;

     if mdy(01,01,1995)<=fy_bgndt<mdy(01,01,1996) then bgn_yr=1995;
else if mdy(01,01,1996)<=fy_bgndt<mdy(01,01,1997) then bgn_yr=1996;
else if mdy(01,01,1997)<=fy_bgndt<mdy(01,01,1998) then bgn_yr=1997;
else if mdy(01,01,1998)<=fy_bgndt<mdy(01,01,1999) then bgn_yr=1998;
else if mdy(01,01,1999)<=fy_bgndt<mdy(01,01,2000) then bgn_yr=1999;
else if mdy(01,01,2000)<=fy_bgndt<mdy(01,01,2001) then bgn_yr=2000;
else if mdy(01,01,2001)<=fy_bgndt<mdy(01,01,2002) then bgn_yr=2001;
else if mdy(01,01,2002)<=fy_bgndt<mdy(01,01,2003) then bgn_yr=2002;
else if mdy(01,01,2003)<=fy_bgndt<mdy(01,01,2004) then bgn_yr=2003;
else if mdy(01,01,2004)<=fy_bgndt<mdy(01,01,2005) then bgn_yr=2004;
else if mdy(01,01,2005)<=fy_bgndt<mdy(01,01,2006) then bgn_yr=2005;
else if mdy(01,01,2006)<=fy_bgndt<mdy(01,01,2007) then bgn_yr=2006;
else if mdy(01,01,2007)<=fy_bgndt<mdy(01,01,2008) then bgn_yr=2007;
else if mdy(01,01,2008)<=fy_bgndt<mdy(01,01,2009) then bgn_yr=2008;
else if mdy(01,01,2009)<=fy_bgndt<mdy(01,01,2010) then bgn_yr=2009;

     if mdy(01,01,1995)<=fy_enddt<mdy(01,01,1996) then end_yr=1995;
else if mdy(01,01,1996)<=fy_enddt<mdy(01,01,1997) then end_yr=1996;
else if mdy(01,01,1997)<=fy_enddt<mdy(01,01,1998) then end_yr=1997;
else if mdy(01,01,1998)<=fy_enddt<mdy(01,01,1999) then end_yr=1998;
else if mdy(01,01,1999)<=fy_enddt<mdy(01,01,2000) then end_yr=1999;
else if mdy(01,01,2000)<=fy_enddt<mdy(01,01,2001) then end_yr=2000;
else if mdy(01,01,2001)<=fy_enddt<mdy(01,01,2002) then end_yr=2001;
else if mdy(01,01,2002)<=fy_enddt<mdy(01,01,2003) then end_yr=2002;
else if mdy(01,01,2003)<=fy_enddt<mdy(01,01,2004) then end_yr=2003;
else if mdy(01,01,2004)<=fy_enddt<mdy(01,01,2005) then end_yr=2004;
else if mdy(01,01,2005)<=fy_enddt<mdy(01,01,2006) then end_yr=2005;
else if mdy(01,01,2006)<=fy_enddt<mdy(01,01,2007) then end_yr=2006;
else if mdy(01,01,2007)<=fy_enddt<mdy(01,01,2008) then end_yr=2007;
else if mdy(01,01,2008)<=fy_enddt<mdy(01,01,2009) then end_yr=2008;
else if mdy(01,01,2009)<=fy_enddt<mdy(01,01,2010) then end_yr=2009;

data hhaout.hha_s2s3_1996_2009;
merge hha_s2(in=ins2)
      hha_s3;
 by rec_num;
 if ins2;

label 
      bgn_yr		="Begin Yr"
      end_yr		="End Yr"
      rec_num		="Record Num"
      ;

%MEND MMERGEALLS2S3;
*=================================================================================================================================;
%MACRO MSTATAFL;
***CREATE STATA FILE***;
         proc export data=hhaout.hha_s2s3_1996_2009
            outfile='/data/postacute/RAND/HHA/outdata/hha_s2s3_1996_2009'
            dbms=dta
	    replace;
         run;

%MEND MSTATAFL;
*=================================================================================================================================;

%mgets2(yyear=1996);
%mgets3(yyear=1996);

%mgets2(yyear=1997);
%mgets3(yyear=1997);

%mgets2(yyear=1998);
%mgets3(yyear=1998);

%mgets2(yyear=1999);
%mgets3(yyear=1999);

%mgets2(yyear=2000);
%mgets3(yyear=2000);

%mgets2(yyear=2001);
%mgets3(yyear=2001);

%mgets2(yyear=2002);
%mgets3(yyear=2002);

%mgets2(yyear=2003);
%mgets3(yyear=2003);

%mgets2(yyear=2004);
%mgets3(yyear=2004);

%mgets2(yyear=2005);
%mgets3(yyear=2005);

%mgets2(yyear=2006);
%mgets3(yyear=2006);

%mgets2(yyear=2007);
%mgets3(yyear=2007);

%mgets2(yyear=2008);
%mgets3(yyear=2008);

%mgets2(yyear=2009);
%mgets3(yyear=2009);

%mmergealls2s3;

*mstatafl;
