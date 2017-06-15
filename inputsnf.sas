**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	inputsnf.sas
#
#	Date Written:	May 12, 2011		
#
#	Must precede:	snf.s2s3wkshts.sas
#	Must precede:	snfccr.sas
#
#	Purpose:	Reads Medicare Cost Report SNF ascii csv files downloaded from CMS public website 
#			and saves as SAS data sets.
#			Puts some variables from RPT data sets into ALPHA, NMRC and ROLLUP data sets.
#			Rec_num is common key and is unique to each facility-cost-period.
#
#	Reads:		snf_year_RPT.CSV	(year=1995-2010)
#			snf_year_ALPHA.CSV	(year=1995-2010)
#			snf_year_NMRCCSV	(year=1995-2010)
#			snf_year_ROLLUP.CSV	(year=1995-2010)
#
#	Writes:		snfyearrpt.sas7bdat	(year=1995-2010)
#			snfyearalpha.sas7bdat	(year=1995-2010)
#			snfyearnmrc.sas7bdat	(year=1995-2010)
#			snfyearrollup.sas7bdat	(year=1995-2010)
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs"; 
libname hhasrc  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports"; 
libname hhaout  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports"; 
libname snfsrc  "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports"; 


options pagesize=1500 linesize=180 replace mprint symbolgen spool
	sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library);

*=======================================================================================================================================================================;
%macro mgetrpt;
    data snf&yyear.rpt;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10/snf_&yyear._RPT.CSV" MISSOVER DSD;

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
    data snf&yyear.alpha;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10/snf_&yyear._ALPHA.CSV" MISSOVER DSD;

    informat
           rec_num 8. 
           awksht $7. 
           aline $5. 

		 %if &yyear.<2011 %then %do;  /*In v10, which is 2011+, col is 5 characters, whereas before it is 4*/
	     	acol    $4.
		 %end;
		 %else %if &yyear.>=2011 %then %do;
		 	acol $5.
		 %end;
           aitem $40.;

    format 
       	   rec_num 8.
           awksht $7.
           aline $5.

		 %if &yyear.<2011 %then %do;  /*In v10, which is 2011+, col is 5 characters, whereas before it is 4*/
	     	acol    $4.
		 %end;
		 %else %if &yyear.>=2011 %then %do;
		 	acol $5.
		 %end;
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
    data snf&yyear.nmrc;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

    infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10/snf_&yyear._NMRC.CSV" MISSOVER DSD;

    informat 
    	     rec_num 8.
    	     nwksht  $7.
	     nline   $5.

		 %if &yyear.<2011 %then %do; /*In v10, which is 2012+, col is 5 characters, whereas before it is 4*/
	     	ncol    $4.
		 %end;
		 %else %if &yyear.>=2011 %then %do;
		 	ncol $5.
		 %end;

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

    data snf&yyear.rollup;
    %let _EFIERR_ = 0;     /* clear ERROR detection macro variable */

     infile "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10/snf_&yyear._ROLLUP.CSV" MISSOVER DSD;

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

proc sort	data=snf&yyear.rpt	out=snfsrc.snf&yyear.rpt;
 by rec_num;
run;
proc sort	data=snf&yyear.alpha;
 by rec_num;
run;
proc sort	data=snf&yyear.nmrc;
 by rec_num;
run;
/*proc sort	data=snf&yyear.rollup;
 by rec_num;
run;*/

%if &yyear.=2011 | &yyear.=2012 %then %do;
	title "PRINT CHECK &YYEAR.";
	proc print data=snf&yyear.alpha (obs=20); run;
	proc print data=snf&yyear.rpt (obs=20); run;
	proc print data=snf&yyear.nmrc (obs=20); run;
	title;
%end;

data snfsrc.snf&yyear.alpha;
merge snfsrc.snf&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      snf&yyear.alpha(in=ina); 
 by rec_num;
if inrpt and ina;

data snfsrc.snf&yyear.nmrc;
merge snfsrc.snf&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      snf&yyear.nmrc(in=inn); 
 by rec_num;
if inrpt and inn;

/*data snfsrc.snf&yyear.rollup;
merge snfsrc.snf&yyear.rpt(in=inrpt keep=rec_num prov_id fy_bgndt fy_enddt)
      snf&yyear.rollup(in=inr); 
 by rec_num;
if inrpt and inr;*/

%mend maddrpt;

*=======================================================================================================================================================================;
%macro mprint;
proc contents data=snfsrc.snf&yyear.rpt varnum;
run;

*proc print data=snfsrc.snf&yyear.rpt (obs=50);
*run;

proc contents data=snfsrc.snf&yyear.alpha varnum;
title ' ';
run;

*proc print data=snfsrc.snf&yyear.alpha (obs=20);
*title ' ';
*run;

proc contents data=snfsrc.snf&yyear.nmrc varnum;
run;

*proc print data=snfsrc.snf&yyear.nmrc (obs=20) noobs;
*run;

/*proc contents data=snfsrc.snf&yyear.rollup varnum;
title ' ';
run;*/

*proc print data=snfsrc.snf&yyear.rollup (obs=20);
*title ' ';
*run;
%mend mprint;

*=======================================================================================================================================================================;
%macro mexecute(yyear);
  %mgetrpt;
  %mgetalpha;
  %mgetnmrc;
  *%mgetrollup;
  %maddrpt;
  %mprint;
%mend mexecute;

*=======================================================================================================================================================================;
/*%mexecute(yyear=1995);
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
%mexecute(yyear=2010);*/
%mexecute(yyear=2011);
%mexecute(yyear=2012);
%mexecute(yyear=2013);
%mexecute(yyear=2014);
