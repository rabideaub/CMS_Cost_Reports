**########################################################################################################################**
#	Project Name:	RAND MEDICARE COST REPORTS
#
#	Author:		D.J. Caudry, Harvard Medical School
#
#	Program Name:	snf.s2s3wkshts.sas
#
#	Date Written:	May 12, 2011		
#
#	Must follow:	inputsnf.sas
#	Must precede:	snfccr.sas
#
#	Purpose:	Creates SAS data sets from SNF S2 and S3 worksheets
#
#
#	Reads:		snfyearalpha.sas7bdat	(year=1995-2009)
#			snfyearnmrc.sas7bdat	(year=1995-2009)
#			snfyearrollup.sas7bdat	(year=1995-2009)
#
#	Writes:		snf_s2s3_2010_2013.sas7bdat
#
**########################################################################################################################**;

libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname snfsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";
libname snfout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports";



options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=========================================================================================================================================;
proc print data=SNFSRC.SNF2011ALPHA (obs=50);
	where awksht="S200001";
run;

%MACRO MGETS2(yyear,selectwksht);

****S2 ALPHA****;
data 
	o1	(keep=rec_num prov_id fy_bgndt fy_enddt snf_street)
	o2	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00100_0200)
	o3	(keep=rec_num prov_id fy_bgndt fy_enddt snf_po_box)
	o4	(keep=rec_num prov_id fy_bgndt fy_enddt snf_city)
	o5	(keep=rec_num prov_id fy_bgndt fy_enddt snf_state)
	o6	(keep=rec_num prov_id fy_bgndt fy_enddt snf_zipcode)
	o7	(keep=rec_num prov_id fy_bgndt fy_enddt snf_county)
	o8	(keep=rec_num prov_id fy_bgndt fy_enddt snf_msa_code)
	o9	(keep=rec_num prov_id fy_bgndt fy_enddt snf_urban_rural)
	o10	(keep=rec_num prov_id fy_bgndt fy_enddt snf_name)
	o11	(keep=rec_num prov_id fy_bgndt fy_enddt snf_prov_id)
	o12	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00400_0300)
	o13	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00400_0400)
	o14	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00400_0500)
	o15	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00400_0600)
	o16	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00600_0200)
	o17	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00600_0300)
	o18	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00600_0400)
	o19	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00600_0600)
	o20	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00610_0200)
	o21	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00610_0300)
	o22	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00610_0600)
	o23	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00800_0200)
	o24	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00800_0300)
	o25	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00800_0500)
	o26	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00800_0600)
	o27	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00801_0200)
	o28	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00801_0300)
	o29	(keep=rec_num prov_id fy_bgndt fy_enddt S2_00801_0500)
	o30	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01000_0200)
	o31	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01000_0300)
	o32	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01000_0400)
	o33	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01000_0500)
	o34	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01000_0600)
	o35	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01003_0600)
	o36	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01004_0500)
	o37	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01012_0500)
	o38	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01020_0200)
	o39	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01020_0300)
	o40	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01020_0500)
	o41	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01020_0600)
	o42	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01042_0600)
	o43	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01100_0200)
	o44	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01100_0300)
	o45	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01100_0500)
	o46	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01100_0600)
	o47	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01101_0200)
	o48	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01101_0300)
	o49	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01101_0500)
	o50	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01101_0600)
	o51	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01104_0200)
	o52	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01104_0300)
	o53	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01104_0500)
	o54	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01200_0200)
	o55	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01200_0300)
	o56	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01500_0100)
	o57	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01600_0100)
	o58	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01700_0100)
	o59	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01800_0100)
	o60	(keep=rec_num prov_id fy_bgndt fy_enddt S2_01900_0100)
	o61	(keep=rec_num prov_id fy_bgndt fy_enddt S2_02100_0100)
	o62	(keep=rec_num prov_id fy_bgndt fy_enddt S2_02200_0100)
	o63	(keep=rec_num prov_id fy_bgndt fy_enddt S2_02800_0100)
	o64	(keep=rec_num prov_id fy_bgndt fy_enddt S2_02900_0100)
	o65	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03000_0100)
	o66	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03100_0100)
	o67	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03200_0100)
	o68	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03300_0100)
	o69	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03300_0200)
	o70	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03500_0300)
	o71	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03510_0300)
	o72	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03600_0100)
	o73	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03600_0200)
	o74	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03700_0100)
	o75	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03700_0200)
	o76	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03900_0200)
	o77	(keep=rec_num prov_id fy_bgndt fy_enddt S2_03901_0200)
	o78	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04000_0200)
	o79	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04001_0200)
	o80	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04004_0200)
	o81	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04100_0100)
	o82	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04200_0100)
	o83	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04300_0100)
	o84	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04600_0100)
	o85	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04700_0100)
	o86	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04700_0200)
	o87	(keep=rec_num prov_id fy_bgndt fy_enddt S2_04900_0100)
	o88	(keep=rec_num prov_id fy_bgndt fy_enddt S2_05000_0100)
	o89	(keep=rec_num prov_id fy_bgndt fy_enddt S2_05100_0100)
	o90	(keep=rec_num prov_id fy_bgndt fy_enddt S2_05200_0100)
	;
set snfsrc.snf&yyear.alpha (where=(awksht=&selectwksht.));

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

%if &yyear.<2011 %then %do;  /*In v10, which is 2011+, col is 5 characters, whereas before it is 4*/
	length awlc $16.;
%end;
%else %if &yyear>=2011 %then %do;
	length awlc $17.;
%end;
awlc=awksht || aline || acol;

length 
	snf_street		$40.
	S2_00100_0200		$1.
	snf_po_box		$28.
	snf_city		$40.
	snf_state		$2.
	snf_zipcode		$10.
	snf_county		$40.
	snf_msa_code		$4.
	snf_urban_rural		$1.
	snf_name		$40.
	snf_prov_id		$6.
	S2_00400_0300		$10.
	S2_00400_0400		$1.
	S2_00400_0500		$1.
	S2_00400_0600		$1.
	S2_00600_0200		$6.
	S2_00600_0300		$10.
	S2_00600_0400		$1.
	S2_00600_0600		$1.
	S2_00610_0200		$6.
	S2_00610_0300		$10.
	S2_00610_0600		$1.
	S2_00800_0200		$6.
	S2_00800_0300		$10.
	S2_00800_0500		$1.
	S2_00800_0600		$1.
	S2_00801_0200		$6.
	S2_00801_0300		$10.
	S2_00801_0500		$1.
	S2_01000_0200		$6.
	S2_01000_0300		$10.
	S2_01000_0400		$1.
	S2_01000_0500		$1.
	S2_01000_0600		$1.
	S2_01003_0600		$1.
	S2_01004_0500		$1.
	S2_01012_0500		$1.
	S2_01020_0200		$6.
	S2_01020_0300		$10.
	S2_01020_0500		$1.
	S2_01020_0600		$1.
	S2_01042_0600		$1.
	S2_01100_0200		$6.
	S2_01100_0300		$10.
	S2_01100_0500		$1.
	S2_01100_0600		$1.
	S2_01101_0200		$6.
	S2_01101_0300		$10.
	S2_01101_0500		$1.
	S2_01101_0600		$1.
	S2_01104_0200		$6.
	S2_01104_0300		$10.
	S2_01104_0500		$1.
	S2_01200_0200		$6.
	S2_01200_0300		$10.
	S2_01500_0100		$1.
	S2_01600_0100		$1.
	S2_01700_0100		$1.
	S2_01800_0100		$1.
	S2_01900_0100		$40.
	S2_02100_0100		$1.
	S2_02200_0100		$1.
	S2_02800_0100		$1.
	S2_02900_0100		$1.
	S2_03000_0100		$1.
	S2_03100_0100		$1.
	S2_03200_0100		$1.
	S2_03300_0100		$1.
	S2_03300_0200		$1.
	S2_03500_0300		$1.
	S2_03510_0300		$1.
	S2_03600_0100		$1.
	S2_03600_0200		$1.
	S2_03700_0100		$1.
	S2_03700_0200		$1.
	S2_03900_0200		$1.
	S2_03901_0200		$1.
	S2_04000_0200		$1.
	S2_04001_0200		$1.
	S2_04004_0200		$1.
	S2_04100_0100		$1.
	S2_04200_0100		$1.
	S2_04300_0100		$1.
	S2_04600_0100		$1.
	S2_04700_0100		$1.
	S2_04700_0200		$1.
	S2_04900_0100		$1.
	S2_05000_0100		$1.
	S2_05100_0100		$1.
	S2_05200_0100		$1.
	;

	%if &yyear.<2011 %then %do;
		if awlc			="S200000001000100"		then do;	snf_street	=aitem;	output o1; end;
		else if awlc		="S200000001000200"		then do;	S2_00100_0200	=aitem;	output o2; end;
		else if awlc		="S200000001000300"		then do;	snf_po_box	=aitem;	output o3; end;
		else if awlc		="S200000002000100"		then do;	snf_city	=aitem;	output o4; end;
		else if awlc		="S200000002000200"		then do;	snf_state	=aitem;	output o5; end;
		else if awlc		="S200000002000300"		then do;	snf_zipcode	=aitem;	output o6; end;
		else if awlc		="S200000003000100"		then do;	snf_county	=aitem;	output o7; end;
		else if awlc		="S200000003000200"		then do;	snf_msa_code	=aitem;	output o8; end;
		else if awlc		="S200000003000300"		then do;	snf_urban_rural	=aitem;	output o9; end;
		else if awlc		="S200000004000100"		then do;	snf_name	=aitem;	output o10; end;
		else if awlc		="S200000004000200"		then do;	snf_prov_id	=aitem;	output o11; end;
		else if awlc		="S200000004000300"		then do;	S2_00400_0300	=aitem;	output o12; end;
		else if awlc		="S200000004000400"		then do;	S2_00400_0400	=aitem;	output o13; end;
		else if awlc		="S200000004000500"		then do;	S2_00400_0500	=aitem;	output o14; end;
		else if awlc		="S200000004000600"		then do;	S2_00400_0600	=aitem;	output o15; end;
		else if awlc		="S200000006000200"		then do;	S2_00600_0200	=aitem;	output o16; end;
		else if awlc		="S200000006000300"		then do;	S2_00600_0300	=aitem;	output o17; end;
		else if awlc		="S200000006000400"		then do;	S2_00600_0400	=aitem;	output o18; end;
		else if awlc		="S200000006000600"		then do;	S2_00600_0600	=aitem;	output o19; end;
		else if awlc		="S200000006100200"		then do;	S2_00610_0200	=aitem;	output o20; end;
		else if awlc		="S200000006100300"		then do;	S2_00610_0300	=aitem;	output o21; end;
		else if awlc		="S200000006100600"		then do;	S2_00610_0600	=aitem;	output o22; end;
		else if awlc		="S200000008000200"		then do;	S2_00800_0200	=aitem;	output o23; end;
		else if awlc		="S200000008000300"		then do;	S2_00800_0300	=aitem;	output o24; end;
		else if awlc		="S200000008000500"		then do;	S2_00800_0500	=aitem;	output o25; end;
		else if awlc		="S200000008000600"		then do;	S2_00800_0600	=aitem;	output o26; end;
		else if awlc		="S200000008010200"		then do;	S2_00801_0200	=aitem;	output o27; end;
		else if awlc		="S200000008010300"		then do;	S2_00801_0300	=aitem;	output o28; end;
		else if awlc		="S200000008010500"		then do;	S2_00801_0500	=aitem;	output o29; end;
		else if awlc		="S200000010000200"		then do;	S2_01000_0200	=aitem;	output o30; end;
		else if awlc		="S200000010000300"		then do;	S2_01000_0300	=aitem;	output o31; end;
		else if awlc		="S200000010000400"		then do;	S2_01000_0400	=aitem;	output o32; end;
		else if awlc		="S200000010000500"		then do;	S2_01000_0500	=aitem;	output o33; end;
		else if awlc		="S200000010000600"		then do;	S2_01000_0600	=aitem;	output o34; end;
		else if awlc		="S200000010030600"		then do;	S2_01003_0600	=aitem;	output o35; end;
		else if awlc		="S200000010040500"		then do;	S2_01004_0500	=aitem;	output o36; end;
		else if awlc		="S200000010120500"		then do;	S2_01012_0500	=aitem;	output o37; end;
		else if awlc		="S200000010200200"		then do;	S2_01020_0200	=aitem;	output o38; end;
		else if awlc		="S200000010200300"		then do;	S2_01020_0300	=aitem;	output o39; end;
		else if awlc		="S200000010200500"		then do;	S2_01020_0500	=aitem;	output o40; end;
		else if awlc		="S200000010200600"		then do;	S2_01020_0600	=aitem;	output o41; end;
		else if awlc		="S200000010420600"		then do;	S2_01042_0600	=aitem;	output o42; end;
		else if awlc		="S200000011000200"		then do;	S2_01100_0200	=aitem;	output o43; end;
		else if awlc		="S200000011000300"		then do;	S2_01100_0300	=aitem;	output o44; end;
		else if awlc		="S200000011000500"		then do;	S2_01100_0500	=aitem;	output o45; end;
		else if awlc		="S200000011000600"		then do;	S2_01100_0600	=aitem;	output o46; end;
		else if awlc		="S200000011010200"		then do;	S2_01101_0200	=aitem;	output o47; end;
		else if awlc		="S200000011010300"		then do;	S2_01101_0300	=aitem;	output o48; end;
		else if awlc		="S200000011010500"		then do;	S2_01101_0500	=aitem;	output o49; end;
		else if awlc		="S200000011010600"		then do;	S2_01101_0600	=aitem;	output o50; end;
		else if awlc		="S200000011040200"		then do;	S2_01104_0200	=aitem;	output o51; end;
		else if awlc		="S200000011040300"		then do;	S2_01104_0300	=aitem;	output o52; end;
		else if awlc		="S200000011040500"		then do;	S2_01104_0500	=aitem;	output o53; end;
		else if awlc		="S200000012000200"		then do;	S2_01200_0200	=aitem;	output o54; end;
		else if awlc		="S200000012000300"		then do;	S2_01200_0300	=aitem;	output o55; end;
		else if awlc		="S200000015000100"		then do;	S2_01500_0100	=aitem;	output o56; end;
		else if awlc		="S200000016000100"		then do;	S2_01600_0100	=aitem;	output o57; end;
		else if awlc		="S200000017000100"		then do;	S2_01700_0100	=aitem;	output o58; end;
		else if awlc		="S200000018000100"		then do;	S2_01800_0100	=aitem;	output o59; end;
		else if awlc		="S200000019000100"		then do;	S2_01900_0100	=aitem;	output o60; end;
		else if awlc		="S200000021000100"		then do;	S2_02100_0100	=aitem;	output o61; end;
		else if awlc		="S200000022000100"		then do;	S2_02200_0100	=aitem;	output o62; end;
		else if awlc		="S200000028000100"		then do;	S2_02800_0100	=aitem;	output o63; end;
		else if awlc		="S200000029000100"		then do;	S2_02900_0100	=aitem;	output o64; end;
		else if awlc		="S200000030000100"		then do;	S2_03000_0100	=aitem;	output o65; end;
		else if awlc		="S200000031000100"		then do;	S2_03100_0100	=aitem;	output o66; end;
		else if awlc		="S200000032000100"		then do;	S2_03200_0100	=aitem;	output o67; end;
		else if awlc		="S200000033000100"		then do;	S2_03300_0100	=aitem;	output o68; end;
		else if awlc		="S200000033000200"		then do;	S2_03300_0200	=aitem;	output o69; end;
		else if awlc		="S200000035000300"		then do;	S2_03500_0300	=aitem;	output o70; end;
		else if awlc		="S200000035100300"		then do;	S2_03510_0300	=aitem;	output o71; end;
		else if awlc		="S200000036000100"		then do;	S2_03600_0100	=aitem;	output o72; end;
		else if awlc		="S200000036000200"		then do;	S2_03600_0200	=aitem;	output o73; end;
		else if awlc		="S200000037000100"		then do;	S2_03700_0100	=aitem;	output o74; end;
		else if awlc		="S200000037000200"		then do;	S2_03700_0200	=aitem;	output o75; end;
		else if awlc		="S200000039000200"		then do;	S2_03900_0200	=aitem;	output o76; end;
		else if awlc		="S200000039010200"		then do;	S2_03901_0200	=aitem;	output o77; end;
		else if awlc		="S200000040000200"		then do;	S2_04000_0200	=aitem;	output o78; end;
		else if awlc		="S200000040010200"		then do;	S2_04001_0200	=aitem;	output o79; end;
		else if awlc		="S200000040040200"		then do;	S2_04004_0200	=aitem;	output o80; end;
		else if awlc		="S200000041000100"		then do;	S2_04100_0100	=aitem;	output o81; end;
		else if awlc		="S200000042000100"		then do;	S2_04200_0100	=aitem;	output o82; end;
		else if awlc		="S200000043000100"		then do;	S2_04300_0100	=aitem;	output o83; end;
		else if awlc		="S200000046000100"		then do;	S2_04600_0100	=aitem;	output o84; end;
		else if awlc		="S200000047000100"		then do;	S2_04700_0100	=aitem;	output o85; end;
		else if awlc		="S200000047000200"		then do;	S2_04700_0200	=aitem;	output o86; end;
		else if awlc		="S200000049000100"		then do;	S2_04900_0100	=aitem;	output o87; end;
		else if awlc		="S200000050000100"		then do;	S2_05000_0100	=aitem;	output o88; end;
		else if awlc		="S200000051000100"		then do;	S2_05100_0100	=aitem;	output o89; end;
		else if awlc		="S200000052000100"		then do;	S2_05200_0100	=aitem;	output o90; end;
	%end;

	%else %if &yyear.>=2011 %then %do;
			if awlc			  ="S2000010010000100"		then do;	snf_street	=aitem;	output o1; end;
		else if awlc		="S2000010010000200"		then do;	S2_00100_0200	=aitem;	output o2; end;
		else if awlc		="S2000010010000300"		then do;	snf_po_box	=aitem;	output o3; end;
		else if awlc		="S2000010020000100"		then do;	snf_city	=aitem;	output o4; end;
		else if awlc		="S2000010020000200"		then do;	snf_state	=aitem;	output o5; end;
		else if awlc		="S2000010020000300"		then do;	snf_zipcode	=aitem;	output o6; end;
		else if awlc		="S2000010030000100"		then do;	snf_county	=aitem;	output o7; end;
		else if awlc		="S2000010030000200"		then do;	snf_msa_code	=aitem;	output o8; end;
		else if awlc		="S2000010030000300"		then do;	snf_urban_rural	=aitem;	output o9; end;
		else if awlc		="S2000010040000100"		then do;	snf_name	=aitem;	output o10; end;
		else if awlc		="S2000010040000200"		then do;	snf_prov_id	=aitem;	output o11; end;
		else if awlc		="S2000010040000300"		then do;	S2_00400_0300	=aitem;	output o12; end;
		else if awlc		="S2000010040000400"		then do;	S2_00400_0400	=aitem;	output o13; end;
		else if awlc		="S2000010040000500"		then do;	S2_00400_0500	=aitem;	output o14; end;
		else if awlc		="S2000010040000600"		then do;	S2_00400_0600	=aitem;	output o15; end;
		else if awlc		="S2000010060000200"		then do;	S2_00600_0200	=aitem;	output o16; end;
		else if awlc		="S2000010060000300"		then do;	S2_00600_0300	=aitem;	output o17; end;
		else if awlc		="S2000010060000400"		then do;	S2_00600_0400	=aitem;	output o18; end;
		else if awlc		="S2000010060000600"		then do;	S2_00600_0600	=aitem;	output o19; end;
		else if awlc		="S2000010061000200"		then do;	S2_00610_0200	=aitem;	output o20; end;
		else if awlc		="S2000010061000300"		then do;	S2_00610_0300	=aitem;	output o21; end;
		else if awlc		="S2000010061000600"		then do;	S2_00610_0600	=aitem;	output o22; end;
		else if awlc		="S2000010080000200"		then do;	S2_00800_0200	=aitem;	output o23; end;
		else if awlc		="S2000010080000300"		then do;	S2_00800_0300	=aitem;	output o24; end;
		else if awlc		="S2000010080000500"		then do;	S2_00800_0500	=aitem;	output o25; end;
		else if awlc		="S2000010080000600"		then do;	S2_00800_0600	=aitem;	output o26; end;
		else if awlc		="S2000010080100200"		then do;	S2_00801_0200	=aitem;	output o27; end;
		else if awlc		="S2000010080100300"		then do;	S2_00801_0300	=aitem;	output o28; end;
		else if awlc		="S2000010080100500"		then do;	S2_00801_0500	=aitem;	output o29; end;
		else if awlc		="S2000010100000200"		then do;	S2_01000_0200	=aitem;	output o30; end;
		else if awlc		="S2000010100000300"		then do;	S2_01000_0300	=aitem;	output o31; end;
		else if awlc		="S2000010100000400"		then do;	S2_01000_0400	=aitem;	output o32; end;
		else if awlc		="S2000010100000500"		then do;	S2_01000_0500	=aitem;	output o33; end;
		else if awlc		="S2000010100000600"		then do;	S2_01000_0600	=aitem;	output o34; end;
		else if awlc		="S2000010100300600"		then do;	S2_01003_0600	=aitem;	output o35; end;
		else if awlc		="S2000010100400500"		then do;	S2_01004_0500	=aitem;	output o36; end;
		else if awlc		="S2000010101200500"		then do;	S2_01012_0500	=aitem;	output o37; end;
		else if awlc		="S2000010102000200"		then do;	S2_01020_0200	=aitem;	output o38; end;
		else if awlc		="S2000010102000300"		then do;	S2_01020_0300	=aitem;	output o39; end;
		else if awlc		="S2000010102000500"		then do;	S2_01020_0500	=aitem;	output o40; end;
		else if awlc		="S2000010102000600"		then do;	S2_01020_0600	=aitem;	output o41; end;
		else if awlc		="S2000010104200600"		then do;	S2_01042_0600	=aitem;	output o42; end;
		else if awlc		="S2000010110000200"		then do;	S2_01100_0200	=aitem;	output o43; end;
		else if awlc		="S2000010110000300"		then do;	S2_01100_0300	=aitem;	output o44; end;
		else if awlc		="S2000010110000500"		then do;	S2_01100_0500	=aitem;	output o45; end;
		else if awlc		="S2000010110000600"		then do;	S2_01100_0600	=aitem;	output o46; end;
		else if awlc		="S2000010110100200"		then do;	S2_01101_0200	=aitem;	output o47; end;
		else if awlc		="S2000010110100300"		then do;	S2_01101_0300	=aitem;	output o48; end;
		else if awlc		="S2000010110100500"		then do;	S2_01101_0500	=aitem;	output o49; end;
		else if awlc		="S2000010110100600"		then do;	S2_01101_0600	=aitem;	output o50; end;
		else if awlc		="S2000010110400200"		then do;	S2_01104_0200	=aitem;	output o51; end;
		else if awlc		="S2000010110400300"		then do;	S2_01104_0300	=aitem;	output o52; end;
		else if awlc		="S2000010110400500"		then do;	S2_01104_0500	=aitem;	output o53; end;
		else if awlc		="S2000010120000200"		then do;	S2_01200_0200	=aitem;	output o54; end;
		else if awlc		="S2000010120000300"		then do;	S2_01200_0300	=aitem;	output o55; end;
		else if awlc		="S2000010150000100"		then do;	S2_01500_0100	=aitem;	output o56; end;
		else if awlc		="S2000010160000100"		then do;	S2_01600_0100	=aitem;	output o57; end;
		else if awlc		="S2000010170000100"		then do;	S2_01700_0100	=aitem;	output o58; end;
		else if awlc		="S2000010180000100"		then do;	S2_01800_0100	=aitem;	output o59; end;
		else if awlc		="S2000010190000100"		then do;	S2_01900_0100	=aitem;	output o60; end;
		else if awlc		="S2000010210000100"		then do;	S2_02100_0100	=aitem;	output o61; end;
		else if awlc		="S2000010220000100"		then do;	S2_02200_0100	=aitem;	output o62; end;
		else if awlc		="S2000010280000100"		then do;	S2_02800_0100	=aitem;	output o63; end;
		else if awlc		="S2000010290000100"		then do;	S2_02900_0100	=aitem;	output o64; end;
		else if awlc		="S2000010300000100"		then do;	S2_03000_0100	=aitem;	output o65; end;
		else if awlc		="S2000010310000100"		then do;	S2_03100_0100	=aitem;	output o66; end;
		else if awlc		="S2000010320000100"		then do;	S2_03200_0100	=aitem;	output o67; end;
		else if awlc		="S2000010330000100"		then do;	S2_03300_0100	=aitem;	output o68; end;
		else if awlc		="S2000010330000200"		then do;	S2_03300_0200	=aitem;	output o69; end;
		else if awlc		="S2000010350000300"		then do;	S2_03500_0300	=aitem;	output o70; end;
		else if awlc		="S2000010351000300"		then do;	S2_03510_0300	=aitem;	output o71; end;
		else if awlc		="S2000010360000100"		then do;	S2_03600_0100	=aitem;	output o72; end;
		else if awlc		="S2000010360000200"		then do;	S2_03600_0200	=aitem;	output o73; end;
		else if awlc		="S2000010370000100"		then do;	S2_03700_0100	=aitem;	output o74; end;
		else if awlc		="S2000010370000200"		then do;	S2_03700_0200	=aitem;	output o75; end;
		else if awlc		="S2000010390000200"		then do;	S2_03900_0200	=aitem;	output o76; end;
		else if awlc		="S2000010390100200"		then do;	S2_03901_0200	=aitem;	output o77; end;
		else if awlc		="S2000010400000200"		then do;	S2_04000_0200	=aitem;	output o78; end;
		else if awlc		="S2000010400100200"		then do;	S2_04001_0200	=aitem;	output o79; end;
		else if awlc		="S2000010400400200"		then do;	S2_04004_0200	=aitem;	output o80; end;
		else if awlc		="S2000010410000100"		then do;	S2_04100_0100	=aitem;	output o81; end;
		else if awlc		="S2000010420000100"		then do;	S2_04200_0100	=aitem;	output o82; end;
		else if awlc		="S2000010430000100"		then do;	S2_04300_0100	=aitem;	output o83; end;
		else if awlc		="S2000010460000100"		then do;	S2_04600_0100	=aitem;	output o84; end;
		else if awlc		="S2000010470000100"		then do;	S2_04700_0100	=aitem;	output o85; end;
		else if awlc		="S2000010470000200"		then do;	S2_04700_0200	=aitem;	output o86; end;
		else if awlc		="S2000010490000100"		then do;	S2_04900_0100	=aitem;	output o87; end;
		else if awlc		="S2000010500000100"		then do;	S2_05000_0100	=aitem;	output o88; end;
		else if awlc		="S2000010510000100"		then do;	S2_05100_0100	=aitem;	output o89; end;
		else if awlc		="S2000010520000100"		then do;	S2_05200_0100	=aitem;	output o90; end;
	%end;

label	snf_street		="snf_street"
	S2_00100_0200		="s2ln1col2"
	snf_po_box		="snf_po_box"
	snf_city		="city"
	snf_state		="state"
	snf_zipcode		="zip_code"
	snf_county		="county"
	snf_msa_code		="msa_code"
	snf_urban_rural		="urban_rural"
	snf_name		="snf_name"

	S2_00400_0300		="snf_date_cert"
	S2_00400_0400		="snf_pay_system_5"
	S2_00400_0500		="snf_pay_system_18"
	S2_00400_0600		="snf_pay_system_19"
	S2_00600_0200		="nf_provid"
	S2_00600_0300		="nf_date_cert"
	S2_00600_0400		="nf_pay_system_5"
	S2_00600_0600		="nf_pay_system_19"
	S2_00610_0200		="icf_mr_provid"
	S2_00610_0300		="icf_mr_date_cert"
	S2_00610_0600		="icf_mr_pay_system_19"
	S2_00800_0200		="snf_hha_provid"
	S2_00800_0300		="snf_hha_date_cert"
	S2_00800_0500		="snf_hha_pay_system_18"
	S2_00800_0600		="snf_hha_pay_system_19"
	S2_00801_0200		="snf_hha01_provid"
	S2_00801_0300		="snf_hha01_date_cert"
	S2_00801_0500		="snf_hha01_pay_system_18"
	S2_01000_0200		="snf_corf_provid"
	S2_01000_0300		="snf_corf_date_cert"
	S2_01000_0400		="snf_corf_pay_system_5"
	S2_01000_0500		="snf_corf_pay_system_18"
	S2_01000_0600		="snf_corf_pay_system_19"
	S2_01003_0600		="snf_corf03_pay_system_19"
	S2_01004_0500		="snf_corf04_pay_system_18"
	S2_01012_0500		="snf_cmhc02_pay_system_18"
	S2_01020_0200		="snf_opt_provid"
	S2_01020_0300		="snf_opt_date_cert"
	S2_01020_0500		="snf_opt_pay_system_18"
	S2_01020_0600		="snf_opt_pay_system_19"
	S2_01042_0600		="snf_osp02_pay_system_19"
	S2_01100_0200		="snf_rhc_provid"
	S2_01100_0300		="snf_rhc_date_cert"
	S2_01100_0500		="snf_rhc_pay_system_18"
	S2_01100_0600		="snf_rhc_pay_system_19"
	S2_01101_0200		="snf_rhc01_provid"
	S2_01101_0300		="snf_rhc01_date_cert"
	S2_01101_0500		="snf_rhc01_pay_system_18"
	S2_01101_0600		="snf_rhc01_pay_system_19"
	S2_01104_0200		="snf_rhc04_provid"
	S2_01104_0300		="snf_rhc04_date_cert"
	S2_01104_0500		="snf_rhc04_pay_system_18"
	S2_01200_0200		="snf_hospice_provid"
	S2_01200_0300		="snf_hospice_date_cert"
	S2_01500_0100		="snf_entirely_participating"
	S2_01600_0100		="snf_partly_participating"
	S2_01700_0100		="snf_unit_of_domiciliatory"
	S2_01800_0100		="snf_unit_of_rehab"
	S2_01900_0100		="snf_unit_of_other_specify"
	S2_02100_0100		="prov_all_inclusive"
	S2_02200_0100		="diff_payment_cost_bal_sht"
	S2_02800_0100		="disposal_capital_assets"
	S2_02900_0100		="accel_deprec_claimed"
	S2_03000_0100		="accel_dep_post_08011970"
	S2_03100_0100		="cease_particpt_medicare"
	S2_03200_0100		="decrse_insurnc_allow_cost"
	S2_03300_0100		="snf_qlfy_exemptn_pta"
	S2_03300_0200		="snf_qlfy_exemptn_ptb"
	S2_03500_0300		="nf_qlfy_exemptn_other"
	S2_03510_0300		="icf_mr_qlfy_exemptn_other"
	S2_03600_0100		="snf_oltc_qlfy_exemptn_pta"
	S2_03600_0200		="snf_oltc_qlfy_exemptn_ptb"
	S2_03700_0100		="snf_hha_qlfy_exemptn_pta"
	S2_03700_0200		="snf_hha_qlfy_exemptn_ptb"
	S2_03900_0200		="snf_corf_qlfy_exemptn_ptb"
	S2_03901_0200		="snf_corf01_qlfy_exempt_ptb"
	S2_04000_0200		="snf_rhc_qlfy_exemptn_ptb"
	S2_04001_0200		="snf_rhc01_qlfy_exemptn_ptb"
	S2_04004_0200		="snf_rhc04_qlfy_exemptn_ptb"
	S2_04100_0100		="snf_exempt_cost_limits"
	S2_04200_0100		="nf_exempt_cost_limits"
	S2_04300_0100		="snf_certfd_rgrdls_care_5_19"
	S2_04600_0100		="malprct_costs_rpt_elsewhr"
	S2_04700_0100		="claiming_ambulance_costs"
	S2_04700_0200		="first_yr_ambulance_svcs"
	S2_04900_0100		="icf_mr_operated_under_19"
	S2_05000_0100		="lt_1500_mcare_days_prev_yr"
	S2_05100_0100		="simplfd_mthd_rpt_prev_yr"
	S2_05200_0100		="simplfd_mthd_rpt_cur_yr"
	;

*=========================================================================================================================================;
****S2 NMRC****;

data s2nmrc;
set snfsrc.snf&yyear.nmrc;
if nwksht=&selectwksht;

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

length nln_col $10.;
nln_col=nline || ncol;

data
     dfydt(keep=rec_num prov_id fy_bgndt fy_enddt) 
     ditem(keep=rec_num nln_col nitem);
set s2nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

proc transpose data=ditem out=titem;
 by rec_num;
 id nln_col;
run;

data s2nmrc;
merge dfydt titem;
 by rec_num;


rename
	_0031000100		=S2_00310_0100
	_0031000200		=S2_00310_0200
	_0032000100		=S2_00320_0100
	_0032000200		=S2_00320_0200
	_0140000100		=S2_01400_0100
	_0150100100		=S2_01501_0100
	_0150200100		=S2_01502_0100
	_0150300100		=S2_01503_0100
	_0150400100		=S2_01504_0100
	_0150500100		=S2_01505_0100
	_0150600100		=S2_01506_0100
	_0150700100		=S2_01507_0100
	_0150800100		=S2_01508_0100
	_0150900100		=S2_01509_0100
	_0151000100		=S2_01510_0100
	_0151100100		=S2_01511_0100
	_0151200100		=S2_01512_0100
	_0151300100		=S2_01513_0100
	_0230000100		=S2_02300_0100
	_0230000200		=S2_02300_0200
	_0240000200		=S2_02400_0200
	_0250000200		=S2_02500_0200
	_0260000100		=S2_02600_0100
	_0260000200		=S2_02600_0200
	_0270000100		=S2_02700_0100
	_0270000200		=S2_02700_0200
	_0440000100		=S2_04400_0100
	_0450000100		=S2_04500_0100
	_0450000200		=S2_04500_0200
	_0450000300		=S2_04500_0300
	_0480000100		=S2_04800_0100
	_0480000200		=S2_04800_0200
	_0480100100		=S2_04801_0100
	_0480100200		=S2_04801_0200
	_0480200100		=S2_04802_0100
	_0480300100		=S2_04803_0100;

drop _NAME_;

data s2nmrc;
set s2nmrc;

label
	S2_00310_0100		="facility_specific_rate"
	S2_00310_0200		="transition_period"
	S2_00320_0100		="wage_idx_adj_factor_pre_oct1"
	S2_00320_0200		="wage_idx_adj_factor_post_930"
	S2_01400_0100		="type_owner_control"
	S2_01501_0100		="staffing_exp_to_rev"
	S2_01502_0100		="recruitment_exp_to_rev"
	S2_01503_0100		="emp_retentn_exp_to_rev"
	S2_01504_0100		="training_exp_to_rev"
	S2_01505_0100		="other_exp_to_rev_05"
	S2_01506_0100		="other_exp_to_rev_06"
	S2_01507_0100		="other_exp_to_rev_07"
	S2_01508_0100		="other_exp_to_rev_08"
	S2_01509_0100		="other_exp_to_rev_09"
	S2_01510_0100		="other_exp_to_rev_10"
	S2_01511_0100		="other_exp_to_rev_11"
	S2_01512_0100		="other_exp_to_rev_12"
	S2_01513_0100		="other_exp_to_rev_13"
	S2_02300_0100		="straight_line_deprec_c1"
	S2_02300_0200		="straight_line_deprec_c2"
	S2_02400_0200		="declining_bal_deprec"
	S2_02500_0200		="sum_of_years_digits_deprec"
	S2_02600_0100		="sum_lines_23_25_deprec_c1"
	S2_02600_0200		="sum_lines_23_25_deprec_c2"
	S2_02700_0100		="bal_of_funded_deprec_1"
	S2_02700_0200		="bal_of_funded_deprec_2"
	S2_04400_0100		="participate_in_nhcmq"
	S2_04500_0100		="malprct_premiums"
	S2_04500_0200		="malprct_paid_losses"
	S2_04500_0300		="malprct_self_insurnc"
	S2_04800_0100		="payment_limit"
	S2_04800_0200		="fee_amt_from_psr"
	S2_04801_0100		="payment_limit_01"
	S2_04801_0200		="fee_amt_from_psr_01"
	S2_04802_0100		="payment_limit_02"
	S2_04803_0100		="fee_amt_from_psr_02"
	;

**merge S2 alpha and nmrc data sets together;
data s2alphanmrc;
merge
      o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 
      o11 o12 o13 o14 o15 o16 o17 o18 o19 
      o20 o21 o22 o23 o24 o25 o26 o27 o28 o29 
      o30 o31 o32 o33 o34 o35 o36 o37 o38 o39 
      o40 o41 o42 o43 o44 o45 o46 o47 o48 o49 
      o50 o51 o52 o53 o54 o55 o56 o57 o58 o59 
      o60 o61 o62 o63 o64 o65 o66 o67 o68 o69 
      o70 o71 o72 o73 o74 o75 o76 o77 o78 o79 
      o80 o81 o82 o83 o84 o85 o86 o87 o88 o89 o90
      s2nmrc;
 by rec_num;

**only want SNFs;
if snf_prov_id=prov_id;

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

**convert date fields to numeric, SAS mdy format;
data snf&yyear._S2;
set s2alphanmrc;
rename
	S2_00400_0300		=c_S2_00400_0300
	S2_00600_0300		=c_S2_00600_0300
	S2_00610_0300		=c_S2_00610_0300
	S2_00800_0300		=c_S2_00800_0300
	S2_00801_0300		=c_S2_00801_0300
	S2_01000_0300		=c_S2_01000_0300
	S2_01020_0300		=c_S2_01020_0300
	S2_01100_0300		=c_S2_01100_0300
	S2_01101_0300		=c_S2_01101_0300
	S2_01104_0300		=c_S2_01104_0300
	S2_01200_0300		=c_S2_01200_0300;

data snf&yyear._S2;
set snf&yyear._S2;

	S2_00400_0300		=input(c_S2_00400_0300,mmddyy10.);
	S2_00600_0300		=input(c_S2_00600_0300,mmddyy10.);
	S2_00610_0300		=input(c_S2_00610_0300,mmddyy10.);
	S2_00800_0300		=input(c_S2_00800_0300,mmddyy10.);
	S2_00801_0300		=input(c_S2_00801_0300,mmddyy10.);
	S2_01000_0300		=input(c_S2_01000_0300,mmddyy10.);
	S2_01020_0300		=input(c_S2_01020_0300,mmddyy10.);
	S2_01100_0300		=input(c_S2_01100_0300,mmddyy10.);
	S2_01101_0300		=input(c_S2_01101_0300,mmddyy10.);
	S2_01104_0300		=input(c_S2_01104_0300,mmddyy10.);
	S2_01200_0300		=input(c_S2_01200_0300,mmddyy10.);

format
	S2_00400_0300		
	S2_00600_0300		
	S2_00610_0300		
	S2_00800_0300		
	S2_00801_0300		
	S2_01000_0300		
	S2_01020_0300		
	S2_01100_0300		
	S2_01101_0300		
	S2_01104_0300		
	S2_01200_0300		date8.
	/*S2_01400_0100		ncontrol_.*/;

label
	S2_00400_0300		="snf_date_cert"
	S2_00600_0300		="nf_date_cert"
	S2_00610_0300		="icf_mr_date_cert"
	S2_00800_0300		="snf_hha_date_cert"
	S2_00801_0300		="snf_hha01_date_cert"
	S2_01000_0300		="snf_corf_date_cert"
	S2_01020_0300		="snf_opt_date_cert"
	S2_01100_0300		="snf_rhc_date_cert"
	S2_01101_0300		="snf_rhc01_date_cert"
	S2_01104_0300		="snf_rhc04_date_cert"
	S2_01200_0300		="snf_hospice_date_cert"
	;

drop
	c_S2_00400_0300
	c_S2_00600_0300
	c_S2_00610_0300
	c_S2_00800_0300
	c_S2_00801_0300
	c_S2_01000_0300
	c_S2_01020_0300
	c_S2_01100_0300
	c_S2_01101_0300
	c_S2_01104_0300
	c_S2_01200_0300
	S2_00100_0200;

if S2_04700_0100="Y" then do;
   if S2_04700_0200=" " then S2_04700_0200="N";
end;
if S2_05000_0100=" " then S2_05000_0100="N";
else if S2_05000_0100="Y" then do;
   if S2_05100_0100=" " then S2_05100_0100="N";
end;
if S2_05200_0100=" " then S2_05200_0100="N";
if S2_00310_0200=4 then S2_00310_0200=100;

array anmrc
	S2_02300_0100
	S2_02300_0200
	S2_02400_0200
	S2_02500_0200
	S2_02600_0100
	S2_02600_0200
	S2_02700_0100
	S2_02700_0200
	S2_04500_0100
	S2_04500_0200
	S2_04500_0300;

do over anmrc;
   if anmrc=. then anmrc=0;
end;

*=========================================================================================================================================;
***zip_code edit***;

length snf_zipcode5 $5. snf_zipcode9 $10.;

snf_zipcode5=substr(snf_zipcode,1,5);
if substr(snf_zipcode,6,5)="-     " then snf_zipcode=substr(snf_zipcode,1,5);
else if "-0001"<=substr(snf_zipcode,6,5)<="-9999" then snf_zipcode9=snf_zipcode;

drop snf_zipcode;
label	snf_zipcode5	="SNF Zip Code-5 (snf_zipcode)"
	snf_zipcode9	="SNF Zip Code-9 (snf_zipcode)"
	;

*=========================================================================================================================================;
***name, street, po box edit***;

snf_name=strip(snf_name);
snf_name=upcase(snf_name);
snf_name=compress(snf_name, '(),');
snf_name=compbl(snf_name);
snf_name=tranwrd(snf_name, ' INC.',		', INC');
snf_name=tranwrd(snf_name, ',, INC.',		', INC');
snf_name=tranwrd(snf_name, ' AND ',		' & ');
snf_name=tranwrd(snf_name, ' - ',			'-');
snf_name=tranwrd(snf_name, ' L L C ',		' LLC ');
snf_name=tranwrd(snf_name, ' L.L.C. ',		' LLC ');
snf_name=tranwrd(snf_name, ',,',	  		',');

snf_name=tranwrd(snf_name, ' CONV. ',		' CONVALESCENT ');
snf_name=tranwrd(snf_name, ' CONV ',		' CONVALESCENT ');
snf_name=tranwrd(snf_name, ' CTR ',		' CENTER ');
snf_name=tranwrd(snf_name, ' CTR. ',		' CENTER ');
snf_name=tranwrd(snf_name, ' CTRE ',		' CENTER ');
snf_name=tranwrd(snf_name, ' CTRE. ',		' CENTER ');
snf_name=tranwrd(snf_name, ' CNTR ',		' CENTER ');
snf_name=tranwrd(snf_name, ' CNTR. ',		' CENTER ');
snf_name=tranwrd(snf_name, ' SAINT ',		' ST ');
snf_name=tranwrd(snf_name, ' ST. ',		' ST ');
snf_name=tranwrd(snf_name, ' HOSP ',		' HOSPITAL ');
snf_name=tranwrd(snf_name, ' HOSP. ',		' HOSPITAL ');
snf_name=tranwrd(snf_name, 'REHABILITATION',	'REHAB');
snf_name=tranwrd(snf_name, ' NURS ',		' NURSING ');
snf_name=tranwrd(snf_name, ' D/P ',		' DP ');
snf_name=tranwrd(snf_name, ' D P ',		' DP ');
snf_name=tranwrd(snf_name, ' ST. ',		' ST ');

snf_name=tranwrd(snf_name, 'REHABILITATION',	'REHAB');
snf_name=tranwrd(snf_name, 'REHABILITATIO ',	'REHAB ');
snf_name=tranwrd(snf_name, 'REHABILITATI ',	'REHAB ');
snf_name=tranwrd(snf_name, 'REHABILITAT ',	'REHAB ');
snf_name=tranwrd(snf_name, 'REHABILITA ',		'REHAB ');
snf_name=tranwrd(snf_name, 'REHABILIT ',		'REHAB ');
snf_name=tranwrd(snf_name, 'REHABILI ',		'REHAB ');
snf_name=tranwrd(snf_name, 'REHABIL ',		'REHAB ');
snf_name=tranwrd(snf_name, 'REHABI ',		'REHAB ');
snf_name=tranwrd(snf_name, 'CORPORATION',		'CORP');
snf_name=tranwrd(snf_name, 'CORPORATIO',		'CORP');
snf_name=tranwrd(snf_name, 'CORPORATI',		'CORP');
snf_name=tranwrd(snf_name, 'CORPORAT',		'CORP');
snf_name=tranwrd(snf_name, 'CORPORA',		'CORP');
snf_name=tranwrd(snf_name, 'CORPOR',		'CORP');
snf_name=tranwrd(snf_name, 'CORPO',		'CORP');

snf_name=tranwrd(snf_name, ' NRSG ',		' NURSING ');
snf_name=tranwrd(snf_name, ' NRSG. ',		' NURSING ');
snf_name=tranwrd(snf_name, ' NSG ',		' NURSING ');
snf_name=tranwrd(snf_name, ' NSG. ',		' NURSING ');
snf_name=tranwrd(snf_name, 'NURS ',		'NURSING ');
snf_name=tranwrd(snf_name, 'FACIL ',		'FACILITY ');
snf_name=tranwrd(snf_name, 'FACI ',		'FACILITY ');
snf_name=tranwrd(snf_name, 'FAC ',		'FACILITY ');
snf_name=tranwrd(snf_name, 'NURSING FACILITY',	'NF');
snf_name=tranwrd(snf_name, 'SKIL ',		'SKILLED ');
snf_name=tranwrd(snf_name, 'SKILLED NURSING',	'SNF');
snf_name=tranwrd(snf_name, 'SNFF',		'SNF');
snf_name=tranwrd(snf_name, 'SKILLED NF',		'SNF');
snf_name=tranwrd(snf_name, 'NURSING HOME',	'NH');
snf_name=tranwrd(snf_name, ' HC ' , 		' HEALTHCARE ');
snf_name=tranwrd(snf_name, ',THE' , 		' ');

*=========================================================================================================================================;
Snf_Street=strip(Snf_Street);
Snf_Street=upcase(Snf_Street);
Snf_Street=compress(Snf_Street, ".-(),");
Snf_Street=compbl(Snf_Street);
Snf_Street=tranwrd(Snf_Street, 'STREET',			'ST');
Snf_Street=tranwrd(Snf_Street, 'AVENUE',			'AVE');
Snf_Street=tranwrd(Snf_Street, 'HIGHWAY',			'HWY');
Snf_Street=tranwrd(Snf_Street, ' DRIVE ',			' DR ');
Snf_Street=tranwrd(Snf_Street, ' CTR ',			' CENTER ');
Snf_Street=tranwrd(Snf_Street, ' ROAD ',			' RD ');
Snf_Street=tranwrd(Snf_Street, ' LN ',			' LANE ');
Snf_Street=tranwrd(Snf_Street, 'BOULEVARD',		'BLVD');
Snf_Street=tranwrd(Snf_Street, 'PARKWAY',			'PKWY');
Snf_Street=tranwrd(Snf_Street, ' CIR ',			' CIRCLE ');
Snf_Street=tranwrd(Snf_Street, ' CTR ',			' CENTER ');

if substr(Snf_Street,1,3)='RR ' then Snf_Street=tranwrd(Snf_Street, 'RR ',		'RURAL ROUTE ');
Snf_Street=tranwrd(Snf_Street, ' RR ',		        ' RURAL ROUTE ');
Snf_Street=tranwrd(Snf_Street, ' RT ',			' ROUTE ');
Snf_Street=tranwrd(Snf_Street, ' RTE ',			' ROUTE ');

if substr(Snf_Street,1,4)='BOX ' then Snf_Street=tranwrd(Snf_Street, 'BOX ',		'PO BOX ');

Snf_Street=tranwrd(Snf_Street, ',P O ',			', P O ');
Snf_Street=tranwrd(Snf_Street, ', P O ',			' PO BOX ');
Snf_Street=tranwrd(Snf_Street, 'P O ',			'PO BOX ');
Snf_Street=tranwrd(Snf_Street, ' BOX ',		    	' PO BOX ');
Snf_Street=tranwrd(Snf_Street, 'PO ',		     	'PO BOX ');
Snf_Street=tranwrd(Snf_Street, ' BOX BOX ',		' BOX ');
Snf_Street=tranwrd(Snf_Street, ' PO PO ',			' PO ');
Snf_Street=tranwrd(Snf_Street, 'PO BOX PO BOX',		'PO BOX');
Snf_Street=tranwrd(Snf_Street, 'PO BOX DRAWER',		'PO BOX'); 
Snf_Street=tranwrd(Snf_Street, ' BOX BOX ',		' BOX ');

Snf_Street=tranwrd(Snf_Street, ' FIRST ',			' 1ST ');
Snf_Street=tranwrd(Snf_Street, ' SECOND ',		' 2ND ');
Snf_Street=tranwrd(Snf_Street, ' THIRD ',			' 3RD ');
Snf_Street=tranwrd(Snf_Street, ' FOURTH ',		' 4TH ');
Snf_Street=tranwrd(Snf_Street, ' FIFTH ',			' 5TH '); 
Snf_Street=tranwrd(Snf_Street, ' SIXTH ',			' 6TH ');
Snf_Street=tranwrd(Snf_Street, ' SEVENTH ',		' 7TH ');
Snf_Street=tranwrd(Snf_Street, ' EIGHTH ',		' 8TH ');
Snf_Street=tranwrd(Snf_Street, ' NINTH ',			' 9TH ');
Snf_Street=tranwrd(Snf_Street, ' TENTH ',			' 10TH ');
Snf_Street=tranwrd(Snf_Street, ' ELEVENTH ',		' 11TH ');
Snf_Street=tranwrd(Snf_Street, ' TWELFTH ',		' 12TH ');
Snf_Street=tranwrd(Snf_Street, ' THIRTEENTH ',		' 13TH ');
Snf_Street=tranwrd(Snf_Street, ' FOURTEENTH ',		' 14TH ');
Snf_Street=tranwrd(Snf_Street, ' FIFTEENTH ',		' 15TH ');
Snf_Street=tranwrd(Snf_Street, ' SIXTEENTH ',		' 16TH ');
Snf_Street=tranwrd(Snf_Street, ' SEVENTEENTH ',		' 17TH ');
Snf_Street=tranwrd(Snf_Street, ' EIGHTEENTH ',		' 18TH ');
Snf_Street=tranwrd(Snf_Street, ' NINETEENTH ',		' 19TH ');

Snf_Street=tranwrd(Snf_Street, ' AND ',			' & ');
Snf_Street=tranwrd(Snf_Street, ' NORTH ',			' N ');
Snf_Street=tranwrd(Snf_Street, ' NO ',			' N ');
Snf_Street=tranwrd(Snf_Street, ' SOUTH ',			' S ');
Snf_Street=tranwrd(Snf_Street, ' SO ',			' S ');

Snf_Street=tranwrd(Snf_Street, ' EAST ',			' E ');
Snf_Street=tranwrd(Snf_Street, ' WEST ',			' W ');
Snf_Street=tranwrd(Snf_Street, ' NORTHWEST ',		' NW ');
Snf_Street=tranwrd(Snf_Street, ' SOUTHWEST ',		' SW ');
Snf_Street=tranwrd(Snf_Street, ' NORTHEAST ',		' NE ');
Snf_Street=tranwrd(Snf_Street, ' SOUTHEAST ',		' SE ');

Snf_Street=tranwrd(Snf_Street, ' PLZ ',			' PLAZA ');
Snf_Street=tranwrd(Snf_Street, ' MOUNT ',			' MT ');

*=========================================================================================================================================;
if substr(Snf_Po_Box,1,3)='RR ' then Snf_Po_Box=tranwrd(Snf_Po_Box, 'RR ',		'RURAL ROUTE ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' RR ',		        ' RURAL ROUTE ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' RT ',			' ROUTE ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' RTE ',			' ROUTE ');

if substr(Snf_Po_Box,1,4)='BOX ' then Snf_Po_Box=tranwrd(Snf_Po_Box, 'BOX ',		'PO BOX ');

Snf_Po_Box=tranwrd(Snf_Po_Box, ',P O ',			', P O ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ', P O ',			' PO BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P O ',			'PO BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' BOX ',		    	' PO BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'PO ',		     	'PO BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' BOX BOX ',		' BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, ' PO PO ',			' PO ');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'PO BOX PO BOX',		'PO BOX');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'PO BOX DRAWER',		'PO BOX'); 
Snf_Po_Box=tranwrd(Snf_Po_Box, ' BOX BOX ',		' BOX ');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P.O. PO BOX',		'PO BOX');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P. O. PO BOX',		'PO BOX');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P.O.DRAWER',		'PO Drawer');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P.O. DRAWER',		'PO Drawer');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'P.O.BOX',			'PO Box');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'N/A',			'  ');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'PO BOX BX',		'PO BOX');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'POBOX',			'PO BOX');
Snf_Po_Box=tranwrd(Snf_Po_Box, 'POST PO BOX',		'PO BOX');

*=========================================================================================================================================;
%MEND MGETS2;

*=========================================================================================================================================;
***		S3 Worksheet		***;
*=========================================================================================================================================;
%MACRO MGETS3(yyear,selectwksht);

data s3nmrc;
set snfsrc.snf&yyear.nmrc;
if nwksht=&selectwksht;

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

length nln_col $10.;
nln_col=nline || ncol;

data
     dfydt(keep=rec_num prov_id fy_bgndt fy_enddt) 
     ditem(keep=rec_num nln_col nitem);
set s3nmrc;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;
run;

title "Print S3";
proc print data=ditem (obs=10); run;
proc print data=dfydt (obs=10); run;
title;

proc transpose data=ditem out=titem;
 by rec_num;
 id nln_col;
run;

proc print data=titem (obs=10);
	var _0010000100

data s3nmrc;
merge dfydt titem;
 by rec_num;
drop _NAME_;

rename
	_0010000100		=S3_00100_0100
	_0010000200		=S3_00100_0200
	_0010000300		=S3_00100_0300
	_0010000400		=S3_00100_0400
	_0010000500		=S3_00100_0500
	_0010000600		=S3_00100_0600
	_0010000700		=S3_00100_0700
	_0010000800		=S3_00100_0800
	_0010000900		=S3_00100_0900
	_0010001000		=S3_00100_1000
	_0010001100		=S3_00100_1100
	_0010001200		=S3_00100_1200
	_0010001300		=S3_00100_1300
	_0010001400		=S3_00100_1400
	_0010001500		=S3_00100_1500
	_0010001600		=S3_00100_1600
	_0010001700		=S3_00100_1700
	_0010001800		=S3_00100_1800
	_0010001900		=S3_00100_1900
	_0010002000		=S3_00100_2000
	_0010002100		=S3_00100_2100
	_0010002200		=S3_00100_2200
	_0010002300		=S3_00100_2300
	_0030000100		=S3_00300_0100
	_0030000200		=S3_00300_0200
	_0030000300		=S3_00300_0300
	_0030000500		=S3_00300_0500
	_0030000600		=S3_00300_0600
	_0030000700		=S3_00300_0700
	_0030000800		=S3_00300_0800
	_0030001000		=S3_00300_1000
	_0030001100		=S3_00300_1100
	_0030001200		=S3_00300_1200
	_0030001300		=S3_00300_1300
	_0030001500		=S3_00300_1500
	_0030001600		=S3_00300_1600
	_0030001700		=S3_00300_1700
	_0030001900		=S3_00300_1900
	_0030002000		=S3_00300_2000
	_0030002100		=S3_00300_2100
	_0030002200		=S3_00300_2200
	_0030002300		=S3_00300_2300
	_0030100100		=S3_00301_0100
	_0030100200		=S3_00301_0200
	_0030100500		=S3_00301_0500
	_0030100600		=S3_00301_0600
	_0030100700		=S3_00301_0700
	_0030101000		=S3_00301_1000
	_0030101100		=S3_00301_1100
	_0030101200		=S3_00301_1200
	_0030101500		=S3_00301_1500
	_0030101600		=S3_00301_1600
	_0030101900		=S3_00301_1900
	_0030102000		=S3_00301_2000
	_0030102100		=S3_00301_2100
	_0030102200		=S3_00301_2200
	_0030102300		=S3_00301_2300
	_0031000100		=S3_00310_0100
	_0031000200		=S3_00310_0200
	_0031000500		=S3_00310_0500
	_0031000600		=S3_00310_0600
	_0031000700		=S3_00310_0700
	_0031001000		=S3_00310_1000
	_0031001100		=S3_00310_1100
	_0031001200		=S3_00310_1200
	_0031001500		=S3_00310_1500
	_0031001600		=S3_00310_1600
	_0031001900		=S3_00310_1900
	_0031002000		=S3_00310_2000
	_0031002100		=S3_00310_2100
	_0031002200		=S3_00310_2200
	_0040000100		=S3_00400_0100
	_0040000200		=S3_00400_0200
	_0040000600		=S3_00400_0600
	_0040000700		=S3_00400_0700
	_0040001100		=S3_00400_1100
	_0040001200		=S3_00400_1200
	_0040001600		=S3_00400_1600
	_0040002000		=S3_00400_2000
	_0040002100		=S3_00400_2100
	_0040002200		=S3_00400_2200
	_0040002300		=S3_00400_2300
	_0050002200		=S3_00500_2200
	_0050002300		=S3_00500_2300
	_0050102200		=S3_00501_2200
	_0050202200		=S3_00502_2200
	_0070002200		=S3_00700_2200
	_0070002300		=S3_00700_2300
	_0070102200		=S3_00701_2200
	_0071002200		=S3_00710_2200
	_0072002200		=S3_00720_2200
	_0072202200		=S3_00722_2200
	_0073002200		=S3_00730_2200
	_0080000100		=S3_00800_0100
	_0080000200		=S3_00800_0200
	_0080000400		=S3_00800_0400
	_0080000500		=S3_00800_0500
	_0080000600		=S3_00800_0600
	_0080000700		=S3_00800_0700
	_0080000900		=S3_00800_0900
	_0080001000		=S3_00800_1000
	_0080001100		=S3_00800_1100
	_0080001200		=S3_00800_1200
	_0080001400		=S3_00800_1400
	_0080001500		=S3_00800_1500
	_0080100600		=S3_00801_0600
	_0080100700		=S3_00801_0700
	_0080001600		=S3_00800_1600
	_0080001800		=S3_00800_1800
	_0080001900		=S3_00800_1900
	_0080002000		=S3_00800_2000
	_0080002100		=S3_00800_2100
	_0080002200		=S3_00800_2200
	_0080002300		=S3_00800_2300
	_0090000100		=S3_00900_0100
	_0090000200		=S3_00900_0200
	_0090000300		=S3_00900_0300
	_0090000400		=S3_00900_0400
	_0090000500		=S3_00900_0500
	_0090000600		=S3_00900_0600
	_0090000700		=S3_00900_0700
	_0090000800		=S3_00900_0800
	_0090000900		=S3_00900_0900
	_0090001000		=S3_00900_1000
	_0090001100		=S3_00900_1100
	_0090001200		=S3_00900_1200
	_0090001300		=S3_00900_1300
	_0090001400		=S3_00900_1400
	_0090001500		=S3_00900_1500
	_0090001600		=S3_00900_1600
	_0090001700		=S3_00900_1700
	_0090001800		=S3_00900_1800
	_0090001900		=S3_00900_1900
	_0090002000		=S3_00900_2000
	_0090002100		=S3_00900_2100
	_0090002200		=S3_00900_2200
	_0090002300		=S3_00900_2300
	_0100000400		=S3_01000_0400
	_0100100400		=S3_01001_0400;

data s3nmrc;
set s3nmrc;

label
	S3_00100_0100		="snf_num_beds"
	S3_00100_0200		="snf_bed_days_avail"
	S3_00100_0300		="snf_inpt_days_5"
	S3_00100_0400		="snf_inpt_days_18"
	S3_00100_0500		="snf_inpt_days_19"
	S3_00100_0600		="snf_inpt_days_other"
	S3_00100_0700		="snf_inpt_days_tot"
	S3_00100_0800		="snf_discharges_5"
	S3_00100_0900		="snf_discharges_18"
	S3_00100_1000		="snf_discharges_19"
	S3_00100_1100		="snf_discharges_other"
	S3_00100_1200		="snf_discharges_tot"
	S3_00100_1300		="snf_avg_los_5"
	S3_00100_1400		="snf_avg_los_18"
	S3_00100_1500		="snf_avg_los_19"
	S3_00100_1600		="snf_avg_los_tot"
	S3_00100_1700		="snf_admissions_tot5"
	S3_00100_1800		="snf_admissions_tot18"
	S3_00100_1900		="snf_admissions_tot19"
	S3_00100_2000		="snf_admissions_other"
	S3_00100_2100		="snf_admissions_tot"
	S3_00100_2200		="snf_fte_employees"
	S3_00100_2300		="snf_fte_nonpaid_workers"
	S3_00300_0100		="nf_num_beds"
	S3_00300_0200		="nf_bed_days_avail"
	S3_00300_0300		="nf_inpt_days_5"
	S3_00300_0500		="nf_inpt_days_19"
	S3_00300_0600		="nf_inpt_days_other"
	S3_00300_0700		="nf_inpt_days_tot"
	S3_00300_0800		="nf_discharges_5"
	S3_00300_1000		="nf_discharges_19"
	S3_00300_1100		="nf_discharges_other"
	S3_00300_1200		="nf_discharges_tot"
	S3_00300_1300		="nf_avg_los_5"
	S3_00300_1500		="nf_avg_los_19"
	S3_00300_1600		="nf_avg_los_tot"
	S3_00300_1700		="nf_admissions_tot5"
	S3_00300_1900		="nf_admissions_tot19"
	S3_00300_2000		="nf_admissions_other"
	S3_00300_2100		="nf_admissions_tot"
	S3_00300_2200		="nf_fte_employees"
	S3_00300_2300		="nf_fte_nonpaid_workers"
	S3_00301_0100		="nf_num_beds_01"
	S3_00301_0200		="nf_bed_days_avail_01"
	S3_00301_0500		="nf_inpt_days_19_01"
	S3_00301_0600		="nf_inpt_days_other_01"
	S3_00301_0700		="nf_inpt_days_tot_01"
	S3_00301_1000		="nf_discharges_19_01"
	S3_00301_1100		="nf_discharges_other_01"
	S3_00301_1200		="nf_discharges_tot_01"
	S3_00301_1500		="nf_avg_los_19_01"
	S3_00301_1600		="nf_avg_los_tot_01"
	S3_00301_1900		="nf_admissions_tot19_01"
	S3_00301_2000		="nf_admissions_other_01"
	S3_00301_2100		="nf_admissions_tot_01"
	S3_00301_2200		="nf_fte_employees_01"
	S3_00301_2300		="nf_fte_nonpaid_workers_01"
	S3_00310_0100		="icf_mr_num_beds"
	S3_00310_0200		="icf_mr_bed_days_avail"
	S3_00310_0500		="icf_mr_inpt_days_19"
	S3_00310_0600		="icf_mr_inpt_days_other"
	S3_00310_0700		="icf_mr_inpt_days_tot"
	S3_00310_1000		="icf_mr_discharges_19"
	S3_00310_1100		="icf_mr_discharges_other"
	S3_00310_1200		="icf_mr_discharges_tot"
	S3_00310_1500		="icf_mr_avg_los_19"
	S3_00310_1600		="icf_mr_avg_los_tot"
	S3_00310_1900		="icf_mr_admissions_tot19"
	S3_00310_2000		="icf_mr_admissions_other"
	S3_00310_2100		="icf_mr_admissions_tot"
	S3_00310_2200		="icf_mr_fte_employees"
	S3_00400_0100		="oth_ltc_num_beds"
	S3_00400_0200		="oth_ltc_bed_days_avail"
	S3_00400_0600		="oth_ltc_inpt_days_other"
	S3_00400_0700		="oth_ltc_inpt_days_tot"
	S3_00400_1100		="oth_ltc_discharges_other"
	S3_00400_1200		="oth_ltc_discharges_tot"
	S3_00400_1600		="oth_ltc_avg_los_tot"
	S3_00400_2000		="oth_ltc_admissions_other"
	S3_00400_2100		="oth_ltc_admissions_tot"
	S3_00400_2200		="oth_ltc_fte_employees"
	S3_00400_2300		="oth_ltc_fte_nonpaid_workers"
	S3_00500_2200		="hha_fte_employees"
	S3_00500_2300		="hha_fte_nonpaid_workers"
	S3_00501_2200		="hha_01_fte_employees"
	S3_00502_2200		="hha_02_fte_employees"
	S3_00700_2200		="corf_fte_employees"
	S3_00700_2300		="corf_fte_nonpaid_workers"
	S3_00701_2200		="corf_01_fte_employees"
	S3_00710_2200		="corf_10_fte_employees"
	S3_00720_2200		="corf_20_fte_employees"
	S3_00722_2200		="corf_22_fte_employees"
	S3_00730_2200		="corf_30_fte_employees"
	S3_00800_0100		="hospice_num_beds"
	S3_00800_0200		="hospice_bed_days_avail"
	S3_00800_0400		="hospice_inpt_days_18"
	S3_00800_0500		="hospice_inpt_days_19"
	S3_00800_0600		="hospice_inpt_days_other"
	S3_00800_0700		="hospice_inpt_days_tot"
	S3_00800_0900		="hospice_discharges_18"
	S3_00800_1000		="hospice_discharges_19"
	S3_00800_1100		="hospice_discharges_other"
	S3_00800_1200		="hospice_discharges_tot"
	S3_00800_1400		="hospice_avg_los_18"
	S3_00800_1500		="hospice_avg_los_19"
	S3_00801_0600		="hospice_01_inpt_days_other"
	S3_00801_0700		="hospice_01_inpt_days_tot"
	S3_00800_1600		="hospice_avg_los_tot"
	S3_00800_1800		="hospice_admissions_tot18"
	S3_00800_1900		="hospice_admissions_tot19"
	S3_00800_2000		="hospice_admissions_other"
	S3_00800_2100		="hospice_admissions_tot"
	S3_00800_2200		="hospice_fte_employees"
	S3_00800_2300		="hospice_fte_nonpaid_workers"
	S3_00900_0100		="tot_num_beds"
	S3_00900_0200		="tot_bed_days_avail"
	S3_00900_0300		="tot_inpt_days_5"
	S3_00900_0400		="tot_inpt_days_18"
	S3_00900_0500		="tot_inpt_days_19"
	S3_00900_0600		="tot_inpt_days_other"
	S3_00900_0700		="tot_inpt_days_tot"
	S3_00900_0800		="tot_discharges_5"
	S3_00900_0900		="tot_discharges_18"
	S3_00900_1000		="tot_discharges_19"
	S3_00900_1100		="tot_discharges_other"
	S3_00900_1200		="tot_discharges_tot"
	S3_00900_1300		="tot_avg_los_5"
	S3_00900_1400		="tot_avg_los_18"
	S3_00900_1500		="tot_avg_los_19"
	S3_00900_1600		="tot_avg_los_tot"
	S3_00900_1700		="tot_admissions_tot5"
	S3_00900_1800		="tot_admissions_tot18"
	S3_00900_1900		="tot_admissions_tot19"
	S3_00900_2000		="tot_admissions_other"
	S3_00900_2100		="tot_admissions_tot"
	S3_00900_2200		="tot_fte_employees"
	S3_00900_2300		="tot_fte_nonpaid_workers"
	S3_01000_0400		="ambulance_trips_18"
	S3_01001_0400		="ambulance_trips_18_02"
	;

*=========================================================================================================================================;
/*data s3rollup;
set snfsrc.snf&yyear.rollup;
if substr(rolabel,1,4)="S3_1";

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

data 
     dfydt(keep=rec_num prov_id fy_bgndt fy_enddt)
     ditem(keep=rec_num rolabel roitem);
set s3rollup;
 by rec_num;

if first.rec_num then do;
   output dfydt;
   output ditem;
end;
else output ditem;

proc transpose data=ditem out=titem;
 by rec_num;
 id rolabel;
run;

data s3rollup;
merge dfydt titem;
 by rec_num;
drop _NAME_;

***note: worksheet S3 has rollup values, S2 does not;
*/
data snf&yyear._S3;
*merge s3nmrc s3rollup;
set s3nmrc;
 by rec_num;

if fy_bgndt<mdy(12,31,2014) and fy_enddt>mdy(01,01,2010);

label
	S3_1_C1_3		="ro_nf_num_beds"
	S3_1_C1_8		="ro_hospice_num_beds"
	S3_1_C2_3		="ro_nf_bed_days_avail"
	S3_1_C2_8		="ro_hospice_bed_days_avail"
	S3_1_C3_3		="ro_nf_inpt_days_5"
	S3_1_C3_3		="ro_nf_inpt_days_5"
	S3_1_C4_10		="ro_ambulance_trips_18"
	S3_1_C4_8		="ro_hospice_inpt_days_18"
	S3_1_C5_3		="ro_nf_inpt_days_19"
	S3_1_C5_8		="ro_hospice_inpt_days_19"
	S3_1_C6_3		="ro_nf_inpt_days_other"
	S3_1_C6_8		="ro_hospice_inpt_days_other"
	S3_1_C7_3		="ro_nf_inpt_days_tot"
	S3_1_C7_8		="ro_hospice_inpt_days_tot"
	S3_1_C8_3		="ro_nf_discharges_5"
	S3_1_C9_8		="ro_hospice_discharges_18"
	S3_1_C10_3		="ro_nf_discharges_19"
	S3_1_C10_8		="ro_hospice_discharges_19"
	S3_1_C11_3		="ro_nf_discharges_other"
	S3_1_C11_8		="ro_hospice_discharges_other"
	S3_1_C12_3		="ro_nf_discharges_tot"
	S3_1_C12_8		="ro_hospice_discharges_tot"
	S3_1_C13_3		="ro_nf_avg_los_5"
	S3_1_C14_8		="ro_hospice_avg_los_18"
	S3_1_C15_8		="ro_hospice_avg_los_19"
	S3_1_C16_3		="ro_nf_avg_los_tot"
	S3_1_C16_8		="ro_hospice_avg_los_tot"
	S3_1_C17_3		="ro_nf_admissions_tot5"
	S3_1_C18_8		="ro_hospice_admissions_tot18"
	S3_1_C19_3		="ro_nf_admissions_tot19"
	S3_1_C19_8		="ro_hospice_admissions_tot19"
	S3_1_C20_3		="ro_nf_admissions_other"
	S3_1_C20_8		="ro_hospice_admissions_other"
	S3_1_C21_3		="ro_nf_admissions_tot"
	S3_1_C21_8		="ro_hospice_admissions_tot"
	S3_1_C22_3		="ro_nf_fte_employees"
	S3_1_C22_5		="ro_hha_fte_employees"
	S3_1_C22_7		="ro_corf_fte_employees"
	S3_1_C22_8		="ro_hospice_fte_employees"
	S3_1_C23_3		="ro_nf_fte_nonpaid_workers"
	S3_1_C23_5		="ro_hha_fte_nonpaid_workers"
	S3_1_C23_7		="ro_corf_fte_nonpaid_workers"
	S3_1_C23_8		="ro_hospice_fte_nonpaid_workers"
	;

*proc print;
* title "s3 year=&yyear";
* var rec_num prov_id fy_bgndt fy_enddt snf_num_beds;
*run;

%MEND MGETS3;
*=========================================================================================================================================;
*=========================================================================================================================================;
%MACRO MMERGEALLS2;
data snf_S2;

merge 
	  /*snf2010_S2*/
      snf2011_S2
      snf2012_S2
      snf2013_S2
	  snf2014_S2;
 by rec_num;

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

proc print;
 title 'alls2';
 var rec_num prov_id snf_prov_id fy_bgndt fy_enddt bgn_yr end_yr snf_name;
run;

%MEND MMERGEALLS2;
*=========================================================================================================================================;
%MACRO MMERGEALLS3;
data snf_S3;

merge 
	  /*snf2010_S3*/
      snf2011_S3
      snf2012_S3
      snf2013_S3
	  snf2014_S3;
 by rec_num;

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

%MEND MMERGEALLS3;
*=========================================================================================================================================;
%MACRO MMERGES2ANDS3;

data snf_s2s3_2010_2014;
merge snf_s2(in=ins2)
      snf_s3;
 by rec_num;
 if ins2;

length urban_rural 3.;
if snf_urban_rural="U" then urban_rural=1;
else if snf_urban_rural="R" then urban_rural=0;
drop snf_urban_rural;

label urban_rural	="Urban/Rural (snf_urban_rural)"
      bgn_yr		="Begin Yr"
      end_yr		="End Yr"
      rec_num		="Record Num"
      prov_id		="Provider ID"
      fy_bgndt		="FY Begin Dt"
      fy_enddt		="FY End Dt"
      snf_prov_id	="SNF Provider ID"
      ;

     if snf_msa_code="33"  then snf_msa_code="0033";
else if snf_msa_code="033" then snf_msa_code="0033";
else if snf_msa_code="016" then snf_msa_code="0160";
else if snf_msa_code="16"  then snf_msa_code="0160";

     if 1<=S2_01400_0100<=2  then owner=1;	*nonprofit;
else if 3<=S2_01400_0100<=6  then owner=2;	*forprofit;
else if 7<=S2_01400_0100<=13 then owner=3;	*govt;
label owner = "Type of Owner";

format owner ctrlcat_.
       urban_rural urbanrural_.
       fy_bgndt
       fy_enddt					date8.;

proc sort data=snf_s2s3_2010_2014 out=snfout.snf_s2s3_2010_2014;
 by rec_num;
run;

proc contents data=snfout.snf_s2s3_2010_2014 varnum;
run;

proc print data=snfout.snf_s2s3_2010_2014 (obs=50); run;

%MEND MMERGES2ANDS3;

*=================================================================================================================================;
%MACRO MSTATAFL;
%MEND MSTATAFL;
*=================================================================================================================================;

/*%mgets2(yyear=2010,selectwksht="S200000");
%mgets3(yyear=2010,selectwksht="S300001");*/

%mgets2(yyear=2011,selectwksht="S200001"); /*This becomes S200001 for v10 which starts in 2011 for SNFs*/
%mgets3(yyear=2011,selectwksht="S300001");

%mgets2(yyear=2012,selectwksht="S200001");
%mgets3(yyear=2012,selectwksht="S300001");

%mgets2(yyear=2013,selectwksht="S200001");
%mgets3(yyear=2013,selectwksht="S300001");

%mgets2(yyear=2014,selectwksht="S200001");
%mgets3(yyear=2014,selectwksht="S300001");

%mmergealls2;
%mmergealls3;
%mmerges2ands3;
%mstatafl;

