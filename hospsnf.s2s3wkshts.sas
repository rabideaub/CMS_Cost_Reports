**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	hospsnf.s2s3wkshts.sas
#
#	Date Written:	June 20, 2011		
#
#	Purpose:	Gets data from S2 and S3 Hospital complex worksheets for Hospitals that have SNF subproviders
#
#	Reads:		hosp(year)alpha.sas7bdat   		(year=1996-2009)
#			hosp(year)nmrc.sas7bdat	   		(year=1996-2009)
#
#	Writes:		hospsnf_s2s3_1996_2009.sas7bdat
#			hospsnf_s2s3_1996_2009.dta
#
**########################################################################################################################**;


libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname snfout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";


options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=========================================================================================================================================;
%MACRO MGETS2(yyear);
*=========================================================================================================================================;
***		S2 Worksheet		***;
*=========================================================================================================================================;
**column 2: provider id:
2 	 Hospital
3 	 Subprovider
4 	 Swing Beds-SNF
5 	 Swing Beds-NF
6 	 Hospital-Based SNF
7 	 Hospital-Based NF
8 	 Hospital-Based OLTC
9 	 Hospital-Based HHA
11 	 Separately Certified ASC
12 	 Hospital-Based Hospice
14 	 Hospital-Based Health Clinic (specify)
15 	 Outpatient Rehab. Clinic (specify)
16 	 Renal Dialysis
;

proc print data=hospsrc.hosp&yyear.alpha (obs=10);
	where awksht="S200001";
run;

data
	o1	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_street)
	o2	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_po_box)
	o3	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_city)
	o4	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_state)
	o5	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_zipcode)
	o6	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_county)
	o7	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_name)
	o8	(keep=rec_num prov_id fy_bgndt fy_enddt   prov_id)
	o9	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_00300)
	o10	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_00400)
	o11	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_00500)
	o12	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_00600)

	o13	(keep=rec_num prov_id fy_bgndt fy_enddt   swingbeds_snf_prov_id)
	o14	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_00300)
	o15	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_00400)
	o16	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_00500)
	o17	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_00600)

	o18	(keep=rec_num prov_id fy_bgndt fy_enddt   swingbeds_nf_prov_id)
	o19	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_00300)
	o20	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_00400)
	o21	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_00600)

	o22	(keep=rec_num prov_id fy_bgndt fy_enddt   snf_prov_id)
	o23	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_00300)
	o24	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_00400)
	o25	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_00500)
	o26	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_00600)

	o27	(keep=rec_num prov_id fy_bgndt fy_enddt   nf1_prov_id)
	o28	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_00300)
	o29	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_00400)
	o30	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_00600)

	o31	(keep=rec_num prov_id fy_bgndt fy_enddt   nf2_prov_id)
	o32	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_00300)
	o33	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_00400)
	o34	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_00600)

	o35	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_urban_rural)
	o36	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02100_00200)

	o37	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02800_00100)

	o38	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02802_00200)
	o39	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02802_00300)
	o40	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02802_00400)

	o41	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02803_00200)
	o42	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02804_00200)
	o43	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02805_00200)
	o44	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02806_00200)
	o45	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02807_00200)

	o46	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02900_00100)

	o47	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_03803_00100)
	o48	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_04900_00100)
	o49	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_04900_00200)
	;

set hospsrc.hosp&yyear.alpha;
if awksht="S200001";

length awlc $17.;
awlc=awksht || aline || acol;

**make all date fields length $10, later transform into numeric and format;
length
	S2_00200_00300
	S2_00400_00300
	S2_00500_00300
	S2_00600_00300
	S2_00700_00300
	S2_00701_00300		$10.
	;

length
	prov_id
	swingbeds_snf_prov_id
	swingbeds_nf_prov_id
	snf_prov_id
	nf1_prov_id
	nf2_prov_id		$6.
	prov_state		$2.
	prov_zipcode		$10.
	S2_00200_00400
	S2_00200_00500
	S2_00200_00600
	S2_00400_00400
	S2_00400_00500
	S2_00400_00600
	S2_00500_00400
	S2_00500_00600
	S2_00600_00400
	S2_00600_00500
	S2_00600_00600
	S2_00700_00400
	S2_00700_00600
	S2_00701_00400
	S2_00701_00600
	prov_urban_rural
	S2_02100_00200
	S2_02800_00100
	S2_02802_00200
	S2_02803_00200
	S2_02804_00200
	S2_02805_00200
	S2_02806_00200
	S2_02807_00200
	S2_02900_00100
	S2_03803_00100
	S2_04900_00100
	S2_04900_00200		$1.

	S2_02802_00300
	S2_02802_00400		$6.
	;

	     if awlc	="S2000010010000100" then do;	prov_street			=aitem; output o1; end;
	else if awlc	="S2000010010000200" then do;	prov_po_box			=aitem; output o2; end;
	else if awlc	="S2000010020000100" then do;	prov_city			=aitem; output o3; end;
	else if awlc	="S2000010020000200" then do;	prov_state			=aitem; output o4; end;
	else if awlc	="S2000010020000300" then do;	prov_zipcode			=aitem; output o5; end;
	else if awlc	="S2000010030000100" then do;	prov_county			=aitem; output o6; end;
	else if awlc	="S2000010040000100" then do;	prov_name			=aitem; output o7; end;
	else if awlc	="S2000010040000200" then do;	prov_id				=aitem; output o8; end;
	else if awlc	="S2000010030000500" then do;	S2_00200_00300			=aitem; output o9; end;
	else if awlc	="S2000010030000600" then do;	S2_00200_00400			=aitem; output o10; end;
	else if awlc	="S2000010030000700" then do;	S2_00200_00500			=aitem; output o11; end;
	else if awlc	="S2000010030000800" then do;	S2_00200_00600			=aitem; output o12; end;

	else if awlc	="S2000010070000200" then do;	swingbeds_snf_prov_id		=aitem; output o13; end;
	else if awlc	="S2000010070000500" then do;	S2_00400_00300			=aitem; output o14; end;
	else if awlc	="S2000010070000600" then do;	S2_00400_00400			=aitem; output o15; end;
	else if awlc	="S2000010070000700" then do;	S2_00400_00500			=aitem; output o16; end;
	else if awlc	="S2000010070000800" then do;	S2_00400_00600			=aitem; output o17; end;

	else if awlc	="S2000010050000200" then do;	swingbeds_nf_prov_id		=aitem; output o18; end;
	else if awlc	="S2000010050000300" then do;	S2_00500_00300			=aitem; output o19; end;
	else if awlc	="S2000010050000400" then do;	S2_00500_00400			=aitem; output o20; end;
	else if awlc	="S2000010050000600" then do;	S2_00500_00600			=aitem; output o21; end;

	else if awlc	="S2000010090000200" then do;	snf_prov_id			=aitem; output o22; end;
	else if awlc	="S2000010060000300" then do;	S2_00600_00300			=aitem; output o23; end;
	else if awlc	="S2000010060000400" then do;	S2_00600_00400			=aitem; output o24; end;
	else if awlc	="S2000010060000500" then do;	S2_00600_00500			=aitem; output o25; end;
	else if awlc	="S2000010060000600" then do;	S2_00600_00600			=aitem; output o26; end;

	else if awlc	="S2000010070000200" then do;	nf1_prov_id			=aitem; output o27; end;
	else if awlc	="S2000010070000300" then do;	S2_00700_00300			=aitem; output o28; end;
	else if awlc	="S2000010070000400" then do;	S2_00700_00400			=aitem; output o29; end;
	else if awlc	="S2000010070000600" then do;	S2_00700_00600			=aitem; output o30; end;

	else if awlc	="S2000010070100200" then do;	nf2_prov_id			=aitem; output o31; end;
	else if awlc	="S2000010070100300" then do;	S2_00701_00300			=aitem; output o32; end;
	else if awlc	="S2000010070100400" then do;	S2_00701_00400			=aitem; output o33; end;
	else if awlc	="S2000010070100600" then do;	S2_00701_00600			=aitem; output o34; end;

	else if awlc	="S2000010210000100" then do;	prov_urban_rural		=aitem; output o35; end;
	else if awlc	="S2000010210000200" then do;	S2_02100_00200			=aitem; output o36; end;

	else if awlc	="S2000010280000100" then do;	S2_02800_00100			=aitem; output o37; end;

	else if awlc	="S2000010280200200" then do;	S2_02802_00200			=aitem; output o38; end;
	else if awlc	="S2000010280200300" then do;	S2_02802_00300			=aitem; output o39; end;
	else if awlc	="S2000010280200400" then do;	S2_02802_00400			=aitem; output o40; end;

	else if awlc	="S2000010280300200" then do;	S2_02803_00200			=aitem; output o41; end;
	else if awlc	="S2000010280400200" then do;	S2_02804_00200			=aitem; output o42; end;
	else if awlc	="S2000010280500200" then do;	S2_02805_00200			=aitem; output o43; end;
	else if awlc	="S2000010280600200" then do;	S2_02806_00200			=aitem; output o44; end;
	else if awlc	="S2000010280700200" then do;	S2_02807_00200			=aitem; output o45; end;

	else if awlc	="S2000010290000100" then do;	S2_02900_00100			=aitem; output o46; end;

	else if awlc	="S2000010380300100" then do;	S2_03803_00100			=aitem; output o47; end;

	else if awlc	="S2000010490000100" then do;	S2_04900_00100			=aitem; output o48; end;
	else if awlc	="S2000010490000200" then do;	S2_04900_00200			=aitem; output o49; end;

data s2alpha;
merge
      o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 
      o11 o12 o13 o14 o15 o16 o17 o18 o19 
      o20 o21 o22(in=insnf) o23 o24 o25 o26 o27 o28 o29 
      o30 o31 o32 o33 o34 o35 o36 o37 o38 o39 
      o40 o41 o42 o43 o44 o45 o46 o47 o48 o49;
 by rec_num;

**only get s2 worksheets for Hospital-based SNFs (o22 has snf_prov_id);
if insnf;

*=========================================================================================================================================;
**Now get S2 numeric (also output S3 nmrc file at this time);

****S2 and S3 NMRC****;

data s2nmrc s3nmrc;
set hospsrc.hosp&yyear.nmrc;
if nwksht="S200001" then do;
   length nlinecol $11.;
   nlinecol=nline || "_" || ncol;
   output s2nmrc;
end;
else if nwksht="S300001" then do;
   length nlinecol $11.;
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

proc transpose data=ditem 
     prefix=s2_
     out=titem(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

data s2nmrc(keep=rec_num prov_id fy_bgndt fy_enddt 
		S2_02100_00100
		S2_00300_00400
		S2_02600_00100
		S2_02700_00100
		S2_03500_00100
		S2_02603_00100);

merge dfydt titem;
 by rec_num;

**merge S2 alpha and nmrc data sets together;
*only keep if there is an alpha record, because the alpha file has been restricted to hospital-based snfs;

data s2data;
merge s2alpha(in=inalpha) s2nmrc(in=innmrc);
 by rec_num;
 if inalpha and innmrc;

**convert dates from character to SAS numeric and format;
rename
	S2_00200_00300		=c_S2_00200_0300
	S2_00400_00300		=c_S2_00400_0300
	S2_00500_00300		=c_S2_00500_0300
	S2_00600_00300		=c_S2_00600_0300
	S2_00700_00300		=c_S2_00700_0300
	S2_00701_00300		=c_S2_00701_0300
	;

data s2data;
set s2data;

	S2_00200_00300	=input(c_S2_00200_0300	,mmddyy10.);
	S2_00400_00300	=input(c_S2_00400_0300	,mmddyy10.);
	S2_00500_00300	=input(c_S2_00500_0300	,mmddyy10.);
	S2_00600_00300	=input(c_S2_00600_0300	,mmddyy10.);
	S2_00700_00300	=input(c_S2_00700_0300	,mmddyy10.);
	S2_00701_00300	=input(c_S2_00701_0300	,mmddyy10.);

drop
	c_S2_00200_0300
	c_S2_00400_0300
	c_S2_00500_0300
	c_S2_00600_0300
	c_S2_00700_0300
	c_S2_00701_0300
	;

     if 1<=S2_02100_00100<=2  then owner=1;	*nonprofit;
else if 3<=S2_02100_00100<=6  then owner=2;	*forprofit;
else if 7<=S2_02100_00100<=13 then owner=3;	*govt;

*=========================================================================================================================================;
****Edit provider name, street, PO box and zip code;
***zip_code edit***;

length prov_zipcode5 $5. prov_zipcode9 $10.;

prov_zipcode5=substr(prov_zipcode,1,5);
if substr(prov_zipcode,6,5)="-     " then prov_zipcode=substr(prov_zipcode,1,5);
else if "-0001"<=substr(prov_zipcode,6,5)<="-9999" then prov_zipcode9=prov_zipcode;

drop prov_zipcode;

*=========================================================================================================================================;
***name, street, po box edit***;

prov_name=strip(prov_name);
prov_name=upcase(prov_name);
prov_name=compress(prov_name, '(),');
prov_name=compbl(prov_name);
prov_name=tranwrd(prov_name, ' INC.',		', INC');
prov_name=tranwrd(prov_name, ',, INC.',		', INC');
prov_name=tranwrd(prov_name, ' AND ',		' & ');
prov_name=tranwrd(prov_name, ' - ',			'-');
prov_name=tranwrd(prov_name, ' L L C ',		' LLC ');
prov_name=tranwrd(prov_name, ' L.L.C. ',		' LLC ');
prov_name=tranwrd(prov_name, ',,',	  		',');

prov_name=tranwrd(prov_name, ' CONV. ',		' CONVALESCENT ');
prov_name=tranwrd(prov_name, ' CONV ',		' CONVALESCENT ');
prov_name=tranwrd(prov_name, ' CTR ',		' CENTER ');
prov_name=tranwrd(prov_name, ' CTR. ',		' CENTER ');
prov_name=tranwrd(prov_name, ' CTRE ',		' CENTER ');
prov_name=tranwrd(prov_name, ' CTRE. ',		' CENTER ');
prov_name=tranwrd(prov_name, ' CNTR ',		' CENTER ');
prov_name=tranwrd(prov_name, ' CNTR. ',		' CENTER ');
prov_name=tranwrd(prov_name, ' SAINT ',		' ST ');
prov_name=tranwrd(prov_name, ' ST. ',		' ST ');
prov_name=tranwrd(prov_name, ' HOSP ',		' HOSPITAL ');
prov_name=tranwrd(prov_name, ' HOSP. ',		' HOSPITAL ');
prov_name=tranwrd(prov_name, 'REHABILITATION',	'REHAB');
prov_name=tranwrd(prov_name, ' NURS ',		' NURSING ');
prov_name=tranwrd(prov_name, ' D/P ',		' DP ');
prov_name=tranwrd(prov_name, ' D P ',		' DP ');
prov_name=tranwrd(prov_name, ' ST. ',		' ST ');

prov_name=tranwrd(prov_name, 'REHABILITATION',	'REHAB');
prov_name=tranwrd(prov_name, 'REHABILITATIO ',	'REHAB ');
prov_name=tranwrd(prov_name, 'REHABILITATI ',	'REHAB ');
prov_name=tranwrd(prov_name, 'REHABILITAT ',	'REHAB ');
prov_name=tranwrd(prov_name, 'REHABILITA ',		'REHAB ');
prov_name=tranwrd(prov_name, 'REHABILIT ',		'REHAB ');
prov_name=tranwrd(prov_name, 'REHABILI ',		'REHAB ');
prov_name=tranwrd(prov_name, 'REHABIL ',		'REHAB ');
prov_name=tranwrd(prov_name, 'REHABI ',		'REHAB ');
prov_name=tranwrd(prov_name, 'CORPORATION',		'CORP');
prov_name=tranwrd(prov_name, 'CORPORATIO',		'CORP');
prov_name=tranwrd(prov_name, 'CORPORATI',		'CORP');
prov_name=tranwrd(prov_name, 'CORPORAT',		'CORP');
prov_name=tranwrd(prov_name, 'CORPORA',		'CORP');
prov_name=tranwrd(prov_name, 'CORPOR',		'CORP');
prov_name=tranwrd(prov_name, 'CORPO',		'CORP');

prov_name=tranwrd(prov_name, ' NRSG ',		' NURSING ');
prov_name=tranwrd(prov_name, ' NRSG. ',		' NURSING ');
prov_name=tranwrd(prov_name, ' NSG ',		' NURSING ');
prov_name=tranwrd(prov_name, ' NSG. ',		' NURSING ');
prov_name=tranwrd(prov_name, 'NURS ',		'NURSING ');
prov_name=tranwrd(prov_name, 'FACIL ',		'FACILITY ');
prov_name=tranwrd(prov_name, 'FACI ',		'FACILITY ');
prov_name=tranwrd(prov_name, 'FAC ',		'FACILITY ');
prov_name=tranwrd(prov_name, 'NURSING FACILITY',	'NF');
prov_name=tranwrd(prov_name, 'SKIL ',		'SKILLED ');
prov_name=tranwrd(prov_name, 'SKILLED NURSING',	'SNF');
prov_name=tranwrd(prov_name, 'SNFF',		'SNF');
prov_name=tranwrd(prov_name, 'SKILLED NF',		'SNF');
prov_name=tranwrd(prov_name, 'NURSING HOME',	'NH');
prov_name=tranwrd(prov_name, ' HC ' , 		' HEALTHCARE ');
prov_name=tranwrd(prov_name, ',THE' , 		' ');

*=========================================================================================================================================;
Prov_Street=strip(Prov_Street);
Prov_Street=upcase(Prov_Street);
Prov_Street=compress(Prov_Street, ".-(),");
Prov_Street=compbl(Prov_Street);
Prov_Street=tranwrd(Prov_Street, 'STREET',			'ST');
Prov_Street=tranwrd(Prov_Street, 'AVENUE',			'AVE');
Prov_Street=tranwrd(Prov_Street, 'HIGHWAY',			'HWY');
Prov_Street=tranwrd(Prov_Street, ' DRIVE ',			' DR ');
Prov_Street=tranwrd(Prov_Street, ' CTR ',			' CENTER ');
Prov_Street=tranwrd(Prov_Street, ' ROAD ',			' RD ');
Prov_Street=tranwrd(Prov_Street, ' LN ',			' LANE ');
Prov_Street=tranwrd(Prov_Street, 'BOULEVARD',		'BLVD');
Prov_Street=tranwrd(Prov_Street, 'PARKWAY',			'PKWY');
Prov_Street=tranwrd(Prov_Street, ' CIR ',			' CIRCLE ');
Prov_Street=tranwrd(Prov_Street, ' CTR ',			' CENTER ');

if substr(Prov_Street,1,3)='RR ' then Prov_Street=tranwrd(Prov_Street, 'RR ',		'RURAL ROUTE ');
Prov_Street=tranwrd(Prov_Street, ' RR ',		        ' RURAL ROUTE ');
Prov_Street=tranwrd(Prov_Street, ' RT ',			' ROUTE ');
Prov_Street=tranwrd(Prov_Street, ' RTE ',			' ROUTE ');

if substr(Prov_Street,1,4)='BOX ' then Prov_Street=tranwrd(Prov_Street, 'BOX ',		'PO BOX ');

Prov_Street=tranwrd(Prov_Street, ',P O ',			', P O ');
Prov_Street=tranwrd(Prov_Street, ', P O ',			' PO BOX ');
Prov_Street=tranwrd(Prov_Street, 'P O ',			'PO BOX ');
Prov_Street=tranwrd(Prov_Street, ' BOX ',		    	' PO BOX ');
Prov_Street=tranwrd(Prov_Street, 'PO ',		     	'PO BOX ');
Prov_Street=tranwrd(Prov_Street, ' BOX BOX ',		' BOX ');
Prov_Street=tranwrd(Prov_Street, ' PO PO ',			' PO ');
Prov_Street=tranwrd(Prov_Street, 'PO BOX PO BOX',		'PO BOX');
Prov_Street=tranwrd(Prov_Street, 'PO BOX DRAWER',		'PO BOX'); 
Prov_Street=tranwrd(Prov_Street, ' BOX BOX ',		' BOX ');

Prov_Street=tranwrd(Prov_Street, ' FIRST ',			' 1ST ');
Prov_Street=tranwrd(Prov_Street, ' SECOND ',		' 2ND ');
Prov_Street=tranwrd(Prov_Street, ' THIRD ',			' 3RD ');
Prov_Street=tranwrd(Prov_Street, ' FOURTH ',		' 4TH ');
Prov_Street=tranwrd(Prov_Street, ' FIFTH ',			' 5TH '); 
Prov_Street=tranwrd(Prov_Street, ' SIXTH ',			' 6TH ');
Prov_Street=tranwrd(Prov_Street, ' SEVENTH ',		' 7TH ');
Prov_Street=tranwrd(Prov_Street, ' EIGHTH ',		' 8TH ');
Prov_Street=tranwrd(Prov_Street, ' NINTH ',			' 9TH ');
Prov_Street=tranwrd(Prov_Street, ' TENTH ',			' 10TH ');
Prov_Street=tranwrd(Prov_Street, ' ELEVENTH ',		' 11TH ');
Prov_Street=tranwrd(Prov_Street, ' TWELFTH ',		' 12TH ');
Prov_Street=tranwrd(Prov_Street, ' THIRTEENTH ',		' 13TH ');
Prov_Street=tranwrd(Prov_Street, ' FOURTEENTH ',		' 14TH ');
Prov_Street=tranwrd(Prov_Street, ' FIFTEENTH ',		' 15TH ');
Prov_Street=tranwrd(Prov_Street, ' SIXTEENTH ',		' 16TH ');
Prov_Street=tranwrd(Prov_Street, ' SEVENTEENTH ',		' 17TH ');
Prov_Street=tranwrd(Prov_Street, ' EIGHTEENTH ',		' 18TH ');
Prov_Street=tranwrd(Prov_Street, ' NINETEENTH ',		' 19TH ');

Prov_Street=tranwrd(Prov_Street, ' AND ',			' & ');
Prov_Street=tranwrd(Prov_Street, ' NORTH ',			' N ');
Prov_Street=tranwrd(Prov_Street, ' NO ',			' N ');
Prov_Street=tranwrd(Prov_Street, ' SOUTH ',			' S ');
Prov_Street=tranwrd(Prov_Street, ' SO ',			' S ');

Prov_Street=tranwrd(Prov_Street, ' EAST ',			' E ');
Prov_Street=tranwrd(Prov_Street, ' WEST ',			' W ');
Prov_Street=tranwrd(Prov_Street, ' NORTHWEST ',		' NW ');
Prov_Street=tranwrd(Prov_Street, ' SOUTHWEST ',		' SW ');
Prov_Street=tranwrd(Prov_Street, ' NORTHEAST ',		' NE ');
Prov_Street=tranwrd(Prov_Street, ' SOUTHEAST ',		' SE ');

Prov_Street=tranwrd(Prov_Street, ' PLZ ',			' PLAZA ');
Prov_Street=tranwrd(Prov_Street, ' MOUNT ',			' MT ');

*=========================================================================================================================================;
if substr(Prov_Po_Box,1,3)='RR ' then Prov_Po_Box=tranwrd(Prov_Po_Box, 'RR ',		'RURAL ROUTE ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' RR ',		        ' RURAL ROUTE ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' RT ',			' ROUTE ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' RTE ',			' ROUTE ');

if substr(Prov_Po_Box,1,4)='BOX ' then Prov_Po_Box=tranwrd(Prov_Po_Box, 'BOX ',		'PO BOX ');

Prov_Po_Box=tranwrd(Prov_Po_Box, ',P O ',			', P O ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ', P O ',			' PO BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P O ',			'PO BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' BOX ',		    	' PO BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'PO ',		     	'PO BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' BOX BOX ',		' BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, ' PO PO ',			' PO ');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'PO BOX PO BOX',		'PO BOX');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'PO BOX DRAWER',		'PO BOX'); 
Prov_Po_Box=tranwrd(Prov_Po_Box, ' BOX BOX ',		' BOX ');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P.O. PO BOX',		'PO BOX');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P. O. PO BOX',		'PO BOX');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P.O.DRAWER',		'PO Drawer');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P.O. DRAWER',		'PO Drawer');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'P.O.BOX',			'PO Box');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'N/A',			'  ');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'PO BOX BX',		'PO BOX');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'POBOX',			'PO BOX');
Prov_Po_Box=tranwrd(Prov_Po_Box, 'POST PO BOX',		'PO BOX');

%MEND MGETS2;

*=========================================================================================================================================;
%MACRO MGETS3(yyear);
*=========================================================================================================================================;
***		S3 Worksheet		***;
*=========================================================================================================================================;

**restrict S3 to providers in S2, which only has records for providers with Hopspital-based SNFs;
data s3nmrc;
merge s3nmrc s2data(in=ingood keep=rec_num);
 by rec_num;
 if ingood;

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

proc transpose data=ditem
          prefix=s3_
     	  out=titem(drop=_NAME_);
 by rec_num;
 id nlinecol;
run;

data s3nmrc(keep=rec_num prov_id fy_bgndt fy_enddt
	S3_00100_00100
	S3_00100_00200
	S3_00100_00201
	S3_00100_00300
	S3_00100_00400
	S3_00100_00401
	S3_00100_00500
	S3_00100_00600
	S3_00100_01200
	S3_00100_01300
	S3_00100_01400
	S3_00100_01500

	S3_01900_00100
	S3_01900_00200
	S3_01900_00300
	S3_01900_00400
	S3_01900_00500
	S3_01900_00600
	S3_01900_00700
	S3_01900_00900
	S3_01900_01000
	S3_01900_01100

	S3_01600_00100
	S3_01600_00200
	S3_01600_00300
	S3_01600_00500
	S3_01600_00600
	S3_01600_00700
	S3_01600_00900
	S3_01600_01000
	S3_01600_01100
	S3_01601_00100
	S3_01601_00200
	S3_01601_00500
	S3_01601_00600
	S3_01601_01000);

merge dfydt titem;
 by rec_num;

data snf&yyear._s2s3;
merge s2data(in=ingood) s3nmrc;
 by rec_num;
 if ingood;

proc contents varnum;
run;

%MEND MGETS3;
*=======================================================================================================================================================================;

%MACRO MMERGEALLS2S3;

data hospsnf_s2s3_2010_2014;
merge snf2010_S2S3(in=in2010)
      snf2011_S2S3(in=in2011)
      snf2012_S2S3(in=in2012)
      snf2013_S2S3(in=in2013)
	  snf2014_S2S3(in=in2014);
 by rec_num;

length bgn_yr end_yr cost_yr 3.;

if in2010 then cost_yr=2010;
else if in2011 then cost_yr=2011;
else if in2012 then cost_yr=2012;
else if in2013 then cost_yr=2013;
else if in2014 then cost_yr=2014;

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

label	
    rec_num                     ="Rec Num"
    prov_id                     ="Provider ID"
    snf_prov_id			="SNF Provider ID"
    owner			="Type of Owner"
    prov_name                   ="Main Provider Name"
    prov_street                 ="Main Provider Street"
    prov_po_box                 ="Main Provider PO Box"
    prov_city                   ="Main Provider City"
    prov_state                  ="Main Provider State"
    prov_county                 ="Main Provider County"
    prov_zipcode5	        ="Main Provider Zip Code-5"
    prov_zipcode9	        ="Main Provider Zip Code-9"
    fy_bgndt                    ="FY Begin Dt"
    fy_enddt                    ="FY End Dt"
    bgn_yr			="Period Begin Year"
    end_yr			="Period End Year"
    cost_yr			="Cost Year"

    S2_00200_00400              ="Hospital: Payment System V"
    S2_00200_00500              ="Hospital: Payment System XVIII"
    S2_00200_00600              ="Hospital: Payment System XIX"
    swingbeds_snf_prov_id      ="Swing Beds-SNF-1 Provider ID"
    S2_00400_00400              ="Swing Beds-SNF-1 Pay System V"
    S2_00400_00500              ="Swing Beds-SNF-1 Pay System XVIII"
    S2_00400_00600              ="Swing Beds-SNF-1 Pay System XIX"
    swingbeds_nf_prov_id       ="Swing Beds-SNF-2 Provider ID"
    S2_00500_00400              ="Swing Beds-SNF-2 Pay System V"
    S2_00500_00600              ="Swing Beds-SNF-2 Pay System XIX"
    snf_prov_id		       ="SNF Provider ID"
    S2_00600_00400              ="SNF Pay System V"
    S2_00600_00500              ="SNF Pay System XVIII"
    S2_00600_00600              ="SNF Pay System XIX"
    nf1_prov_id                ="NF-1 Provider ID"
    S2_00700_00400              ="NF-1 Pay V"
    S2_00700_00600              ="NF-1 Pay XIX"
    nf2_prov_id                ="NF-2 Provider ID"
    S2_00701_00400              ="NF-2 Pay V"
    S2_00701_00600              ="NF-2 Pay XIX"
    prov_urban_rural           ="Main Provider Urban/Rural"
    S2_02100_00200              ="Main Provider, Rural and <= 100 beds"
    S2_02800_00100              ="SNF: all pts in managed care, no Medicare util"
    S2_02802_00200              ="SNF: Rural/Urban"
    S2_02802_00300              ="SNF: MSA or State Code"
    S2_02802_00400              ="SNF: CBSA or State Code"
    S2_02803_00200              ="SNF Staffing: Pay increase to Direct Pt Care"
    S2_02804_00200              ="SNF Recruitment: Pay increase to Direct Pt Care"
    S2_02805_00200              ="SNF Retention: Pay increase to Direct Pt Care"
    S2_02806_00200              ="SNF Training: Pay increase to Direct Pt Care"
    S2_02807_00200              ="SNF Other: Pay increase to Direct Pt Care"
    S2_02900_00100              ="Rural SNF < 50 beds"
    S2_03803_00100              ="Title 19 NF pts in Title 18 beds"
    S2_04900_00100              ="SNF A: Exemption"
    S2_04900_00200              ="SNF B: Exemption"
    S2_02100_00100              ="Main Provider: Type of Control"
    S2_01900_00100              ="Main Provider: Type of Provider"
    S2_02600_00100              ="SCH status number of periods"
    S2_02603_00100              ="S2 Line 2603 Col 1"
    S2_02801_00100              ="SNF: Transition Period"
    S2_02801_00200              ="SNF: Wage-Index Adj Factor Pre-Oct 1"
    S2_02801_00300              ="SNF: Wage-Index Adj Factor Post-Oct 1"
    S2_02802_00100              ="SNF: Facility-specific rate"
    S2_02803_00100	       ="SNF: Staffing % Expenses to SNF Revenue"
    S2_02804_00100	       ="SNF: Recruitment % Expenses to SNF Revenue"
    S2_02805_00100	       ="SNF: Retention % Expenses to SNF Revenue"
    S2_02806_00100	       ="SNF: Training % Expenses to SNF Revenue"
    S2_02807_00100	       ="SNF: Other % Expenses to SNF Revenue"
    S2_04600_00100              ="SNF: NHCMQ Phase"
    S2_02103_00100              ="Main Provider: Geo Location U/R"
    S2_02104_00100              ="Main Provider: Geo Location U/R start"
    S2_02105_00100              ="Main Provider: Geo Location U/R end"

    S2_00200_00300              ="Main Provider: Date Certified"
    S2_00400_00300              ="Swing Beds-SNF: Date Certified"
    S2_00500_00300              ="Swing Beds-NF: Date Certified"
    S2_00600_00300              ="Hosp-Based SNF: Date Certified"
    S2_00700_00300              ="Hosp-Based NF-1: Date Certified"
    S2_00701_00300              ="Hosp-Based NF-2: Date Certified"
    prov_zipcode5              ="Main Provider Zip Code-5"    
    prov_zipcode9              ="Main Provider Zip Code-9"    

    S3_00100_00100		="Hospital Num Beds"
    S3_00100_00200		="Hospital Bed Days Available"
    S3_00100_00201		="Hospital Agg Hours (CAH)"

    S3_00100_00300		="Hospital Title 5 Days"
    S3_00100_00400		="Hospital Title 18 Days"
    S3_00100_00401		="Hospital Non-coverd Days (LTCH)"

    S3_00100_00500		="Hospital Title 19 Days"
    S3_00100_00600		="Hospital Total Days"
    S3_00100_01200		="Hospital Title 5 Discharges"
    S3_00100_01300		="Hospital Title 18 Discharges"
    S3_00100_01400		="Hospital Title 19 Discharges"
    S3_00100_01500		="Hospital Total Discharges"

    S3_01900_00200		="SNF Num Beds"
    S3_01900_00300		="SNF Bed Days Available"
    S3_01900_00500		="SNF Title 5 Days"
    S3_01900_00600		="SNF Title 18 Days"
    S3_01900_00700		="SNF Title 19 Days"
    S3_01900_00800		="SNF Total Days"
    S3_01900_00900		="SNF Total Interns/Res/FTE"
    S3_01900_01000		="SNF FTE on Payroll"
    S3_01900_01100		="SNF Nonpaid Workers"

    S3_02000_00200		="NF Num Beds"
    S3_02000_00300		="NF Bed Days Available"
    S3_02000_00500		="NF Title 5 Days"
    S3_02000_00700		="NF Title 19 Days"
    S3_02000_00800		="NF Total Days"
    S3_02000_00900		="NF Total Interns/Res/FTE"
    S3_02000_01000		="NF FTE on Payroll"
    S3_02000_01100		="NF Nonpaid Workers"

    S3_01601_00100		="NF-2 Num Beds"
    S3_01601_00200		="NF-2 Bed Days Available"
    S3_01601_00500		="NF-2 Title 19 Days"
    S3_01601_00600		="NF-2 Total Days"
    S3_01601_01000		="NF-2 FTE on Payroll"
    S3_01601_01100		="NF-2 Nonpaid Workers"
    ;

format
       owner ctrlcat_.
       prov_urban_rural $urban_.
       ;

proc sort data=hospsnf_s2s3_2010_2014 out=snfout.hospsnf_s2s3_2010_2014;
 by rec_num;
run;

proc contents data=snfout.hospsnf_s2s3_2010_2014 varnum;
run;

%MEND MMERGEALLS2S3;

*=================================================================================================================================;
%MACRO MSTATAFL;
***CREATE STATA FILE***;
         proc export data=snfout.hospsnf_s2s3_2010_2014
            outfile='/data/postacute/RAND/SNF/outdata/hospsnf_s2s3_2010_2014'
            dbms=dta
	    replace;
         run;

%MEND MSTATAFL;
*=================================================================================================================================;

%mgets2(yyear=2010);
%mgets3(yyear=2010);

%mgets2(yyear=2011);
%mgets3(yyear=2011);

%mgets2(yyear=2012);
%mgets3(yyear=2012);

%mgets2(yyear=2013);
%mgets3(yyear=2013);

%mgets2(yyear=2014);
%mgets3(yyear=2014);

%mmergealls2s3;

