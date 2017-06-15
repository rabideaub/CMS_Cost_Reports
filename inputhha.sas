**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	inputhha.sas
#
#	Date Written:	July 20, 2011
#
#	Must precede:	hha.s2s3wkshts.sas
#	Must precede:	hhaccr.sas
#
#	Purpose:	Reads Medicare Cost Report HHA ascii csv files downloaded from CMS public website 
#			and saves as SAS data sets.
#			Puts some variables from RPT data sets into ALPHA, NMRC and ROLLUP data sets.
#			Rec_num is common key and is unique to each facility-cost-period.
#
#	Reads:		hha_year_RPT.CSV	(year=1995-2010)
#			hha_year_ALPHA.CSV	(year=1995-2010)
#			hha_year_NMRCCSV	(year=1995-2010)
#			hha_year_ROLLUP.CSV	(year=1995-2010)
#
#	Writes:		hhayearrpt.sas7bdat	(year=1995-2010)
#			hhayearalpha.sas7bdat	(year=1995-2010)
#			hhayearnmrc.sas7bdat	(year=1995-2010)
#			hhayearrollup.sas7bdat	(year=1995-2010)
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hhasrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96";

options pagesize=1500 linesize=180 replace mprint symbolgen spool
	sasautos=macro mautosource nocenter nofmterr noovp fmtsearch=(costlib work library);

*=======================================================================================================================================================================;
%macro mgetrpt;
    data hha&yyear.rpt;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96/hha_&yyear._RPT.CSV" MISSOVER DSD;

    informat 
    	      rec_num 8. 
              prov_ctrl $2. 
              prov_id $6. 
              npi 10.
              rpt_stus $1.
              fy_bgndt mmddyy10. 
              fy_enddt mmddyy10. 
              proc_dt mmddyy10. 
              initl_rpt $1. 
              last_rpt $1. 
              trnsmtl $2. 
              fi_num  $5. 
              vendor  $1. 
              fi_crtdt mmddyy10. 
              util_cd $1.
              reimb_dt mmddyy10. 
              spec_ind $1.
              fi_recdt mmddyy10.;

    format
              rec_num 8. 
              prov_ctrl $2. 
              prov_id $6. 
              npi 10.
              rpt_stus $1.
              fy_bgndt mmddyy10. 
              fy_enddt mmddyy10. 
              proc_dt mmddyy10. 
              initl_rpt $1. 
              last_rpt $1. 
              trnsmtl $2. 
              fi_num  $5. 
              vendor  $1. 
              fi_crtdt mmddyy10. 
              util_cd $1.
              reimb_dt mmddyy10. 
              spec_ind $1.
              fi_recdt mmddyy10.;
       

    input
		rec_num
                prov_ctrl
                prov_id
		npi
		rpt_stus
                fy_bgndt	
                fy_enddt	
                proc_dt		
                initl_rpt
                last_rpt
                trnsmtl
		fi_num
                vendor
                fi_crtdt
		util_cd
		reimb_dt
                spec_ind
		fi_recdt;

    if  _n_ ge 1 then     /* starting record/number of records */
     do;
       output;
       if _ERROR_ then
          call symput('_EFIERR_',1);
     end;
    run;

%mend mgetrpt;

*=======================================================================================================================================================================;
%macro mgetalpha;
    data hha&yyear.alpha;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96/hha_&yyear._ALPHA.CSV" MISSOVER DSD;

    informat
           rec_num 8. 
           awksht $7. 
           aline $5. 
           acol $4.
           aitem $40.;

    format 
       	   rec_num 8.
           awksht $7.
           aline $5.
           acol $4.
           aitem $40.; 

    input  
    	   rec_num
           awksht
           aline
           acol
           aitem;

    If _ERROR_ then        /* ERROR detection */
       call symput('_EFIERR_',1);
    run;

%mend mgetalpha;

*=======================================================================================================================================================================;
%macro mgetnmrc;
    data hha&yyear.nmrc;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96/hha_&yyear._NMRC.CSV" MISSOVER DSD;

    informat 
    	     rec_num 8.
    	     nwksht  $7.
	     nline   $5.
	     ncol    $4.
	     nitem   13.;

    format   nitem 11.2;

    input  
	     rec_num
             nwksht
             nline
             ncol
             nitem;

    If _ERROR_ then        /* ERROR detection */
       call symput('_EFIERR_',1);
    run;

%mend mgetnmrc;

*=======================================================================================================================================================================;
%macro mgetrollup;

    data hha&yyear.rollup;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

     infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v96/hha_&yyear._ROLLUP.CSV" MISSOVER DSD;

    informat 
    	rec_num 8.
        rolabel $20.
       	roitem 8.;

    input
        rec_num		:8.
	rolabel 	:$20.
	roitem 		:8.;

    If _ERROR_ then        /* ERROR detection */
       call symput('_EFIERR_',1);
    run;

%mend mgetrollup;

*=======================================================================================================================================================================;
%macro maddrpt;

proc sort	data=hha&yyear.rpt	out=hhasrc.hha&yyear.rpt;
 by rec_num;
run;
proc sort	data=hha&yyear.alpha;
 by rec_num;
run;
proc sort	data=hha&yyear.nmrc;
 by rec_num;
run;
proc sort	data=hha&yyear.rollup;
 by rec_num;
run;

data hhasrc.hha&yyear.alpha;
merge hhasrc.hha&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      hha&yyear.alpha(in=ina); 
 by rec_num;
if inrpt and ina;

data hhasrc.hha&yyear.nmrc;
merge hhasrc.hha&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      hha&yyear.nmrc(in=inn); 
 by rec_num;
if inrpt and inn;

data hhasrc.hha&yyear.rollup;
merge hhasrc.hha&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      hha&yyear.rollup(in=inr); 
 by rec_num;
if inrpt and inr;

%mend maddrpt;

*=======================================================================================================================================================================;
%macro mprint;
proc contents data=hhasrc.hha&yyear.rpt varnum;
run;

*proc print data=hhasrc.hha&yyear.rpt (obs=50);
*run;

proc contents data=hhasrc.hha&yyear.alpha varnum;
title ' ';
run;

*proc print data=hhasrc.hha&yyear.alpha (obs=20);
*title ' ';
*run;

proc contents data=hhasrc.hha&yyear.nmrc varnum;
run;

*proc print data=hhasrc.hha&yyear.nmrc (obs=20) noobs;
*run;

proc contents data=hhasrc.hha&yyear.rollup varnum;
title ' ';
run;

*proc print data=hhasrc.hha&yyear.rollup (obs=20);
*title ' ';
*run;
%mend mprint;

*=======================================================================================================================================================================;
%macro mexecute(yyear);
  %mgetrpt;
  %mgetalpha;
  %mgetnmrc;
  %mgetrollup;
  %maddrpt;
  %mprint;
%mend mexecute;

*=======================================================================================================================================================================;

%mexecute(yyear=1995);
%mexecute(yyear=1996);
%mexecute(yyear=1997);
%mexecute(yyear=1998);
%mexecute(yyear=1999);
%mexecute(yyear=2000);
%mexecute(yyear=2001);
%mexecute(yyear=2002);
%mexecute(yyear=2003);
%mexecute(yyear=2004);
%mexecute(yyear=2005);
%mexecute(yyear=2006);
%mexecute(yyear=2007);
%mexecute(yyear=2008);
%mexecute(yyear=2009);
%mexecute(yyear=2010);
%mexecute(yyear=2011);
%mexecute(yyear=2012);
%mexecute(yyear=2013);
%mexecute(yyear=2014);
