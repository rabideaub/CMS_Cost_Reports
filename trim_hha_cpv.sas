libname in "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
options compress=yes nofmterr;


proc contents data=in.hha_cpv_calyear; run;

***trim outlying CCR values;
	***restrict to within 4 std devs of mean value of CPV for given year;
	data hha_cpv_calyear_trim;
		set in.hha_cpv_calyear;
	run;

	proc means data=hha_cpv_calyear_trim noprint;
		 var calyear_total_cpv;
		 output out=omeans1 stddev=stddev1 mean=mean1;
		 class calyear;
	run;

	proc sort data=hha_cpv_calyear_trim;
		 by calyear;
	run;

	data in.hha_cpv_calyear_trim (drop=
		     pos4sd_1 - pos4sd_2
		     neg4sd_1 - neg4sd_2
		     _TYPE_
		     _FREQ_
		     mean1 - mean2
		     stddev1 - stddev2);

		merge hha_cpv_calyear_trim 
		      omeans1;
		 by calyear;

		pos4sd_1		=mean1 +		(4 * stddev1);
		neg4sd_1		=mean1 -		(4 * stddev1);

		if not(neg4sd_1 <= calyear_total_cpv <= pos4sd_1) then calyear_total_cpv = .;
		else if calyear_total_cpv < 0 then calyear_total_cpv =.;
	run;

	proc univariate data=in.hha_cpv_calyear_trim;
		var calyear_total_cpv;
	run;
	proc univariate data=in.hha_cpv_calyear_trim;
		var calyear_total_cpv;
	run;
