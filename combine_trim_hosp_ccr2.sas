/*The purpose of this program is to calculate calendar year CCRs for achs. One issue is that
  there is a disjoint in the cost reports from 2010 to 2011, but to calculate calendar year CCRs
  it is necessary to look at 2 fiscal years worth of data, weight them by days reported in the FY,
  and combine them into a single calendar year cost-to-charge ratio.

  This program also outputs a winsorized dataset where CCRs are trimmed if they are outside 4 standard
  deviations of the yearly CCR average. Only applies to calendar year CCRs at the moment*/

libname in "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
options compress=yes nofmterr;


%macro calconvert(fac);
	data &fac._ccr_all (keep=prov_id cost_yr Total_CCR Total_CCR_c fy_enddt fy_bgndt %if "&fac."="hospsnf" %then %do; snf_prov_id %end;);
		set in.&fac._ccr_1996_2010
			in.&fac._ccr_2010_2014;
	run;

	/*Make a calendar year CCR for &fac.s*/
	data D&fac.;
		set &fac._ccr_all;

		length w 3.;

		if (fy_bgndt<=mdy(01,01,1996)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1996)<=fy_enddt) then do; w=1996; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,1997)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1997)<=fy_enddt) then do; w=1997; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,1998)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1998)<=fy_enddt) then do; w=1998; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,1999)<=fy_enddt) or (fy_bgndt<=mdy(12,31,1999)<=fy_enddt) then do; w=1999; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2000)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2000)<=fy_enddt) then do; w=2000; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2001)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2001)<=fy_enddt) then do; w=2001; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2002)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2002)<=fy_enddt) then do; w=2002; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2003)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2003)<=fy_enddt) then do; w=2003; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2004)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2004)<=fy_enddt) then do; w=2004; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2005)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2005)<=fy_enddt) then do; w=2005; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2006)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2006)<=fy_enddt) then do; w=2006; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2007)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2007)<=fy_enddt) then do; w=2007; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2008)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2008)<=fy_enddt) then do; w=2008; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2009)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2009)<=fy_enddt) then do; w=2009; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2010)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2010)<=fy_enddt) then do; w=2010; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2011)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2011)<=fy_enddt) then do; w=2011; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2012)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2012)<=fy_enddt) then do; w=2012; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2013)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2013)<=fy_enddt) then do; w=2013; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2014)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2014)<=fy_enddt) then do; w=2014; output D&fac.; end;
		if (fy_bgndt<=mdy(01,01,2015)<=fy_enddt) or (fy_bgndt<=mdy(12,31,2015)<=fy_enddt) then do; w=2015; output D&fac.; end;
	run;

	data D&fac.;
		set D&fac.;

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
		jan2011=mdy(01,01,2011);
		jan2012=mdy(01,01,2012);
		jan2013=mdy(01,01,2013);
		jan2014=mdy(01,01,2014);
		jan2015=mdy(01,01,2015);

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
		dec2011=mdy(12,31,2011);
		dec2012=mdy(12,31,2012);
		dec2013=mdy(12,31,2013);
		dec2014=mdy(12,31,2014);
		dec2015=mdy(12,31,2015);

		j=w-1995;
		prov_id_w=prov_id || w;
	run;

	proc sort data=D&fac.; by prov_id_w; run;

	data D&fac.;
		set D&fac.;
		by prov_id_w;
		retain totcaldays;

		array ajan{20}
		      jan1996 - jan2015;

		array adec{20}
		      dec1996 - dec2015;

		jan=ajan{j};
		dec=adec{j};

		wbegin=max(of fy_bgndt jan);
		wend=min(of fy_enddt dec);

		wreportdays=(wend - wbegin) + 1;

		if first.prov_id_w then do;
		   totcaldays=0;
		end;
		totcaldays=totcaldays + wreportdays;
	run;

	/*Add up total calendar year reporting days between the overlapping fiscal years reports*/
		data D&fac.;
			set D&fac. (drop=totcaldays);
			retain totcaldays;
			by prov_id w;
			if first.w then totcaldays=wreportdays;
			if ~first.w then totcaldays=totcaldays+wreportdays;
		run;

		proc sort data=D&fac.; by prov_id w descending totcaldays; run;

		data D&fac. (drop=totcaldays rename=(totcaldays2=totcaldays));
			set D&fac.;
			retain totcaldays2;
			by prov_id w;
			if first.w then totcaldays2=totcaldays;
		run;

		/*Weight the FY CCRs by the days in the calendar year covered by the FY report, then combine the weighted CCRs*/
		proc sort data=D&fac.; by prov_id w cost_yr; run;

		data D&fac._test in.&fac._ccr_all;
			set D&fac.;

			/*totccr and totccrc are the calendar year days weighted CCR for when a provider reports in FY*/
			propw=wreportdays/totcaldays;
			totccr=Total_CCR * propw;
			totccr_c=Total_CCR_c * propw;

			/*Sum up the individual weighted calendar year CCRs to get the final cal_Total_CCRs */
			retain cal_Total_CCR cal_Total_CCR_c;
			by prov_id w;
			if first.w then do;
				cal_Total_CCR=totccr;
				cal_Total_CCR_c=totccr_c;
			end;
			else do;
				cal_Total_CCR=cal_Total_CCR + totccr;
				cal_Total_CCR_c=cal_Total_CCR_c + totccr_c;
			end;
			output D&fac._test;
			if last.w then do;
				cost_yr=w;
				output in.&fac._ccr_all;
			end;
		run;

		/*Take a look to make sure the data collapsed correctly*/
		proc print data=D&fac. (obs=60); 
			var prov_id cost_yr fy_bgndt fy_enddt w Total_CCR Total_CCR_c wreportdays totcaldays;
		run;
		proc print data=D&fac._test (obs=60); 
			var prov_id cost_yr fy_bgndt fy_enddt w Total_CCR cal_Total_CCR cal_Total_CCR_c Total_CCR_c totccr propw totcaldays wreportdays;
		run; 
		proc print data=in.&fac._ccr_all (obs=30); 
			var prov_id cost_yr fy_bgndt fy_enddt Total_CCR Total_CCR_c cal_Total_CCR cal_Total_CCR_c;
		run;


	***trim outlying CCR values;
		***first restrict values to < 10 and > 0.1;
		***then restrict to within 4 std devs of mean value of CCR for given year;
		data &fac._ccr_all_trim;
			set in.&fac._ccr_all;
			if not(0.1<cal_Total_CCR<=10) then cal_Total_CCR =.;
			if not(0.1<cal_Total_CCR_c<=10) then cal_Total_CCR_c =.;
			run;

	%macro trim(var);
		proc means data=&fac._ccr_all_trim noprint;
			 var cal_&var.;
			 output out=omeans1 stddev=stddev1 mean=mean1;
			 class cost_yr;
		run;

		proc sort data=&fac._ccr_all_trim;
			 by cost_yr;
		run;

		data in.&fac._ccr_all_trim (drop=
			     pos4sd_1 
			     neg4sd_1
			     _TYPE_
			     _FREQ_
			     mean1
			     stddev1);

			merge &fac._ccr_all_trim 
			      omeans1;
			 by cost_yr;

			pos4sd_1		=mean1 +		(4 * stddev1);
			neg4sd_1		=mean1 -		(4 * stddev1);

			if not(neg4sd_1 <= cal_&var. <= pos4sd_1) then cal_&var. = .;
			else if cal_&var. < 0 then cal_&var. =.;
		run;

		proc freq data=in.&fac._ccr_all_trim;
			tables cost_yr;
		run;

		proc univariate data=in.&fac._ccr_all;
			var cal_&var. &var.;
		run;
		proc univariate data=in.&fac._ccr_all_trim;
			var cal_&var. &var.;
		run;
	%mend;
	*%trim(var=Total_CCR);
	*%trim(var=Total_CCR_c);
%mend;
%calconvert(fac=ach);
%calconvert(fac=irf);
%calconvert(fac=ltch);
%calconvert(fac=hospsnf);


