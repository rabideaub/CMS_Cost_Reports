libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname hospout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname out "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

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

%macro cost_charge(fac);
	%do i=2010 %to 2014;

		data s2s3&fac.&i.(keep=rec_num prov_id cost_yr fy_bgndt fy_enddt sub prov_type prev_pct_medicaredays prev_pct_medicaiddays);
			set s2s3&fac.;
			if cost_yr=&i.;
		run;

			**A indicates Hospital and 18 indicates Medicare;
			**1B indicates first subprovider and 2B indicates second subprovider;
			data all_nmrc;
				set hospsrc.hosp&i.nmrc;
				if substr(nwksht,3,2)="0A" then sub=0;
				if substr(nwksht,3,2)="0B" then sub=1;
				if substr(nwksht,3,2)="0C" then sub=2;
				wksht2=substr(nwksht,1,2);
			run;

			proc sort data=all_nmrc; by rec_num nwksht nline ncol; run;

			proc print data=all_nmrc (obs=200); run;

			proc freq data=all_nmrc;
				tables nwksht wksht2 sub / missing;
			run;

			data ddc;
				set all_nmrc;
				if (substr(nwksht,5,2)="18" & /*Medicare*/
					wksht2 in("D1","D3"))   | nwksht="C000001"; /*Worksheets of interest. D1=Routine Services, D3=Ancilliary Services, C0=Routine Services Source 2*/
				wksht4=trim(left(substr(nwksht,1,4)));
				var=trim(left(wksht4)) || "_" || trim(left(nline)) || "_" || trim(left(ncol));
			run;

			proc print data=ddc (obs=200); run;

			proc print data=ddc (obs=10); 
				where wksht2="C0";
			run;

			proc transpose data=ddc out=ddc_wide;
				by rec_num;
				id var;
				var nitem;
			run;

			/*proc print data=ddc_wide (obs=10); run;*/

			data ddc_wide;
				set ddc_wide;
				rename D10A_02100_00100=D1_HOSP_ROUTINE_COST
					   D10C_02100_00100=D1_IRF_ROUTINE_COST
					   D10B_02100_00100=D1_IPF_ROUTINE_COST
					   D10E_02100_00100=D1_SUB3_ROUTINE_COST


					   D10A_02700_00100=D1_HOSP_INPTN_COST
					   D10C_02700_00100=D1_IRF_INPTN_COST
					   D10B_02700_00100=D1_IPF_INPTN_COST
					   D10E_02700_00100=D1_SUB3_INPTN_COST
					   D10A_02800_00100=D1_HOSP_INPTN_CHARGE
					   D10C_02800_00100=D1_IRF_INPTN_CHARGE
					   D10B_02800_00100=D1_IPF_INPTN_CHARGE
					   D10E_02800_00100=D1_SUB3_INPTN_CHARGE


					   D30A_20000_00200=D3_HOSP_ANCIL_CHARGE
					   D30A_20000_00300=D3_HOSP_ANCIL_COST
					   D30C_20000_00200=D3_IRF_ANCIL_CHARGE
					   D30C_20000_00300=D3_IRF_ANCIL_COST
					   D30B_20000_00200=D3_IPF_ANCIL_CHARGE
					   D30B_20000_00300=D3_IPF_ANCIL_COST
					   D30E_20000_00200=D3_SUB3_ANCIL_CHARGE
					   D30E_20000_00300=D3_SUB3_ANCIL_COST
					   D30F_20000_00200=D3_SUB4_ANCIL_CHARGE
					   D30F_20000_00300=D3_SUB4_ANCIL_COST

					   /*For some reason, even though worksheet D3 has separate sheet numbers for IRF and IPF, it also has separate lines for IRF and IPF Charge. Investigate these*/
					   D30A_04000_00200=D3_HOSP_ANCIL_CHARGE_IRF
					   D30A_04100_00200=D3_HOSP_ANCIL_CHARGE_IPF
					   D30C_04000_00200=D3_IRF_ANCIL_CHARGE_IRF
					   D30C_04100_00200=D3_IRF_ANCIL_CHARGE_IPF
					   D30B_04000_00200=D3_IPF_ANCIL_CHARGE_IRF
					   D30B_04100_00200=D3_IPF_ANCIL_CHARGE_IPF


					   C000_03000_00500=C1_HOSP_INPTN_COST
					   C000_03000_00600=C1_HOSP_INPTN_CHARGE
					   C000_04000_00500=C1_IPF_INPTN_COST
					   C000_04000_00600=C1_IPF_INPTN_CHARGE
					   C000_04100_00500=C1_IRF_INPTN_COST
					   C000_04100_00600=C1_IRF_INPTN_CHARGE;
				
			run;

			proc sort data=ddc_wide; by rec_num; run;
			proc sort data=s2s3&fac.&i.; by rec_num; run;

			data ddc_&fac._&i.;
				merge ddc_wide (in=a)
					  s2s3&fac.&i.  (in=b);
				by rec_num;
				if b;

				if sub=0 | sub=. then do;
					if D1_HOSP_INPTN_COST~=. & D3_HOSP_ANCIL_COST~=. & D1_HOSP_INPTN_CHARGE~=. & D3_HOSP_ANCIL_CHARGE~=. then
						total_CCR=((D1_HOSP_INPTN_COST+D3_HOSP_ANCIL_COST)/(D1_HOSP_INPTN_CHARGE+D3_HOSP_ANCIL_CHARGE));
					if C1_HOSP_INPTN_COST~=. & D3_HOSP_ANCIL_COST~=. & C1_HOSP_INPTN_CHARGE~=. & D3_HOSP_ANCIL_CHARGE~=. then
						total_CCR_c=((C1_HOSP_INPTN_COST+D3_HOSP_ANCIL_COST)/(C1_HOSP_INPTN_CHARGE+D3_HOSP_ANCIL_CHARGE));
				end;

				if sub=1 then do;
					if D1_IPF_INPTN_COST~=. & D3_IPF_ANCIL_COST~=. & D1_IPF_INPTN_CHARGE~=. & D3_IPF_ANCIL_CHARGE~=. then
						total_CCR=((D1_IPF_INPTN_COST+D3_IPF_ANCIL_COST)/(D1_IPF_INPTN_CHARGE+D3_IPF_ANCIL_CHARGE));
					if C1_IPF_INPTN_COST~=. & D3_IPF_ANCIL_COST~=. & C1_IPF_INPTN_CHARGE~=. & D3_IPF_ANCIL_CHARGE~=. then
						total_CCR_c=((C1_IPF_INPTN_COST+D3_IPF_ANCIL_COST)/(C1_IPF_INPTN_CHARGE+D3_IPF_ANCIL_CHARGE));
				end;

				if sub=2 then do;
					if D1_IRF_INPTN_COST~=. & D3_IRF_ANCIL_COST~=. & D1_IRF_INPTN_CHARGE~=. & D3_IRF_ANCIL_CHARGE~=. then
						total_CCR=((D1_IRF_INPTN_COST+D3_IRF_ANCIL_COST)/(D1_IRF_INPTN_CHARGE+D3_IRF_ANCIL_CHARGE));
					if C1_IRF_INPTN_COST~=. & D3_IRF_ANCIL_COST~=. & C1_IRF_INPTN_CHARGE~=. & D3_IRF_ANCIL_CHARGE~=. then
						total_CCR_c=((C1_IRF_INPTN_COST+D3_IRF_ANCIL_COST)/(C1_IRF_INPTN_CHARGE+D3_IRF_ANCIL_CHARGE));
				end;

				year=&i.;
			run;

			proc means data=ddc_&fac._&i.;
				class sub;
				var total_CCR total_CCR_c;
			run;

			proc freq data=ddc_&fac._&i.;
				tables sub / missing;
			run;

			title "Compare D1 and C1 for Subproviders for &fac. for &i.";
			proc print data=ddc_&fac._&i. (obs=100);
				var rec_num prov_id sub total_CCR total_CCR_c D1_HOSP_INPTN_COST C1_HOSP_INPTN_COST D1_HOSP_INPTN_CHARGE C1_HOSP_INPTN_CHARGE D1_IPF_INPTN_COST C1_IPF_INPTN_COST 
					D1_IPF_INPTN_CHARGE C1_IPF_INPTN_CHARGE	D1_IRF_INPTN_COST C1_IRF_INPTN_COST D1_IRF_INPTN_CHARGE C1_IRF_INPTN_CHARGE D3_HOSP_ANCIL_CHARGE D3_IPF_ANCIL_CHARGE 
				   D3_IRF_ANCIL_CHARGE D3_HOSP_ANCIL_COST D3_IPF_ANCIL_COST D3_IRF_ANCIL_COST total_CCR total_CCR_c sub;
			run;
			title;

			title "CCR Correlations for &fac. for &i.";
			proc corr data=ddc_&fac._&i.;
				var total_CCR total_CCR_c;
				where (sub=0 | sub=.) & 0<total_CCR<10 & 0<total_CCR_c<10;
			run;

			proc corr data=ddc_&fac._&i.;
				var total_CCR total_CCR_c;
				where sub=1 & 0<total_CCR<10 & 0<total_CCR_c<10;
			run;

			proc corr data=ddc_&fac._&i.;
				var total_CCR total_CCR_c;
				where sub=2 & 0<total_CCR<10 & 0<total_CCR_c<10;
			run;
			title;

			title "Cost Correlations for &fac. for &i. ";
			proc corr data=ddc_&fac._&i.;
				var C1_HOSP_INPTN_COST D1_HOSP_INPTN_COST;
				where sub=0 | sub=.;
			run;

			proc corr data=ddc_&fac._&i.;
				var C1_HOSP_INPTN_CHARGE D1_HOSP_INPTN_CHARGE;
			run;

			proc corr data=ddc_&fac._&i.;
				var C1_IRF_INPTN_COST D1_IRF_INPTN_COST;
			run;

			proc corr data=ddc_&fac._&i.;
				var C1_IRF_INPTN_CHARGE D1_IRF_INPTN_CHARGE;
			run;
			title;
	%end;
%mend;
%cost_charge(fac=irf);
%cost_charge(fac=ltch);
%cost_charge(fac=ach);

data irf;
	set ddc_irf_:;
run;

data hospout.irf_ccr_2010_2014;
	set irf;
run;

data ach;
	set ddc_ach_:;
run;

data hospout.ach_ccr_2010_2014;
	set ach;
run;

data ltch;
	set ddc_ltch_:;
run;

data hospout.ltch_ccr_2010_2014;
	set ltch;
run;
