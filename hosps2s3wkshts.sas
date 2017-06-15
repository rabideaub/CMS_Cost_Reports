libname costlib "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Programs/Costs";
libname hospsrc "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";
libname hospout "/schaeffer-b/sch-protected/from-projects/VERTICAL-INTEGRATION/rabideau/Data/Cost_Reports/v10";

options pagesize= 1500 linesize=220 replace mprint symbolgen spool sasautos=macro mautosource nocenter noovp fmtsearch=(costlib work library); 

*=========================================================================================================================================;
%MACRO MGETS2(yyear);
*=========================================================================================================================================;
***		S2 Worksheet		***;
*=========================================================================================================================================;
**first get items from S2 Alpha file;
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

data
	o1	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_street)
	o2	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_po_box)
	o3	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_city)
	o4	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_state)
	o5	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_zipcode)
	o6	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_county)
	o7	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_name)
	o8	(keep=rec_num prov_id fy_bgndt fy_enddt   prov_id)
	o9	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_0300)
	o10	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_0400)
	o11	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_0500)
	o12	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00200_0600)
	o13	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_sub1_prov_id)
	o14	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00300_0300)
	o15	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00300_0400)
	o16	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00300_0500)
	o17	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00300_0600)
	o18	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_sub2_prov_id)
	o19	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00301_0300)
	o20	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00301_0400)
	o21	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00301_0500)
	o22	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00301_0600)
	o23	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_sub3_prov_id)
	o24	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00302_0300)
	o25	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00302_0500)
	o26	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00302_0600)
	o27	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_sub4_prov_id)
	o28	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00303_0300)
	o29	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00303_0500)
	o30	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00303_0600)
	o31	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_sub5_prov_id)
	o32	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00304_0300)
	o33	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00304_0500)
	o34	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00304_0600)
	o35	(keep=rec_num prov_id fy_bgndt fy_enddt   swingbeds_snf_prov_id)
	o36	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_0300)
	o37	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_0400)
	o38	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_0500)
	o39	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00400_0600)
	o40	(keep=rec_num prov_id fy_bgndt fy_enddt   swingbeds_nf_prov_id)

	o41	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_0300)
	o42	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_0400)
	o43	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00500_0600)
	o44	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_snf_prov_id)

	o45	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_0300)
	o46	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_0400)
	o47	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_0500)
	o48	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00600_0600)
	o49	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_nf0_prov_id)

	o50	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_0300)
	o51	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_0400)
	o52	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00700_0600)
	o53	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_nf1_prov_id)

	o54	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_0300)
	o55	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_0400)
	o56	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00701_0600)
	o57	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha0_prov_id)
	o58	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00900_0300)
	o59	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00900_0400)
	o60	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00900_0500)
	o61	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00900_0600)
	o62	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha1_prov_id)

	o63	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00901_0300)
	o64	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00901_0400)
	o65	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00901_0500)
	o66	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00901_0600)
	o67	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha2_prov_id)

	o68	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00902_0300)
	o69	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00902_0500)
	o70	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00902_0600)
	o71	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha3_prov_id)

	o72	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00903_0300)
	o73	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00903_0500)
	o74	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00903_0600)
	o75	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha4_prov_id)

	o76	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00904_0300)
	o77	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00904_0500)
	o78	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00904_0600)
	o79	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha5_prov_id)
	o80	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00905_0300)
	o81	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00905_0500)
	o82	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00905_0600)
	o83	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hha6_prov_id)

	o84	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00906_0300)
	o85	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00906_0500)
	o86	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_00906_0600)

	o87	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_asc_prov_id)
	o88	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01100_0300)
	o89	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01100_0500)
	o90	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01100_0600)
	o91	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hospice0_prov_id)

	o92	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01200_0300)
	o93	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01200_0500)
	o94	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01200_0600)
	o95	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_hospice1_prov_id)

	o96	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01201_0300)
	o97	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic0_prov_id)
	o98	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01400_0300)
	o99	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01400_0400)
	o100	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01400_0500)
	o101	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01400_0600)
	o102	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic1_prov_id)

	o103	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01401_0300)
	o104	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01401_0400)
	o105	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01401_0500)
	o106	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01401_0600)
	o107	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic2_prov_id)

	o108	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01402_0300)
	o109	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01402_0400)
	o110	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01402_0500)
	o111	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01402_0600)
	o112	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic3_prov_id)

	o113	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01403_0300)
	o114	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01403_0400)
	o115	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01403_0500)
	o116	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01403_0600)
	o117	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic4_prov_id)

	o118	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01404_0300)
	o119	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01404_0400)
	o120	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01404_0500)
	o121	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01404_0600)
	o122	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic5_prov_id)

	o123	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01405_0300)
	o124	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01405_0400)
	o125	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01405_0500)
	o126	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01405_0600)
	o127	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic6_prov_id)

	o128	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01406_0300)
	o129	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01406_0400)
	o130	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01406_0500)
	o131	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01406_0600)
	o132	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic7_prov_id)

	o133	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01407_0300)
	o134	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01407_0400)
	o135	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01407_0500)
	o136	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01407_0600)
	o137	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic8_prov_id)

	o138	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01408_0300)
	o139	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01408_0500)
	o140	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01408_0600)
	o141	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic9_prov_id)

	o142	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01409_0300)
	o143	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01409_0500)
	o144	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01409_0600)
	o145	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic10_prov_id)

	o146	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01410_0300)
	o147	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01410_0500)
	o148	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01410_0600)
	o149	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic11_prov_id)

	o150	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01411_0300)
	o151	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01411_0500)
	o152	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01411_0600)
	o153	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic12_prov_id)

	o154	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01412_0300)
	o155	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01412_0500)
	o156	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01412_0600)
	o157	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic13_prov_id)

	o158	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01413_0300)
	o159	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01413_0500)
	o160	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01413_0600)
	o161	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic14_prov_id)

	o162	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01414_0300)
	o163	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01414_0500)
	o164	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01414_0600)
	o165	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic15_prov_id)

	o166	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01415_0300)
	o167	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01415_0500)
	o168	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01415_0600)

	o169	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic16_prov_id)
	o170	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01416_0300)
	o171	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01416_0500)
	o172	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01416_0600)

	o173	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic17_prov_id)
	o174	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01417_0300)
	o175	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01417_0500)
	o176	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01417_0600)

	o177	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic18_prov_id)
	o178	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01418_0300)
	o179	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01418_0500)
	o180	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01418_0600)

	o181	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic19_prov_id)
	o182	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01419_0300)
	o183	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01419_0500)
	o184	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01419_0600)

	o185	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic35_prov_id)
	o186	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01435_0300)
	o187	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01435_0500)
	o188	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01435_0600)

	o189	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic36_prov_id)
	o190	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01436_0300)
	o191	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01436_0500)
	o192	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01436_0600)

	o193	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic37_prov_id)
	o194	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01437_0300)
	o195	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01437_0500)
	o196	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01437_0600)

	o197	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic38_prov_id)
	o198	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01438_0300)
	o199	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01438_0500)
	o200	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01438_0600)

	o201	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic39_prov_id)
	o202	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01439_0300)
	o203	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01439_0500)
	o204	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01439_0600)

	o205	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_health_clinic40_prov_id)
	o206	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01440_0300)
	o207	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01440_0500)
	o208	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01440_0600)

	o209	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_outpt_rehab0_prov_id)
	o210	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01500_0300)
	o211	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01500_0500)
	o212	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01500_0600)

	o213	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_outpt_rehab1_prov_id)
	o214	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01501_0300)
	o215	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01501_0500)
	o216	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01501_0600)

	o217	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_outpt_rehab10_prov_id)
	o218	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01510_0300)
	o219	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01510_0500)
	o220	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01510_0600)

	o221	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_outpt_rehab20_prov_id)
	o222	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01520_0300)
	o223	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01520_0500)
	o224	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01520_0600)

	o225	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_outpt_rehab21_prov_id)
	o226	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01521_0300)
	o227	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01521_0500)

	o228	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis0_prov_id)
	o229	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01600_0300)

	o230	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis1_prov_id)
	o231	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01601_0300)

	o232	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis2_prov_id)
	o233	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01602_0300)

	o234	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis3_prov_id)
	o235	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01603_0300)

	o236	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis4_prov_id)
	o237	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01604_0300)

	o238	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis5_prov_id)
	o239	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01605_0300)

	o240	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis6_prov_id)
	o241	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01606_0300)

	o242	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis7_prov_id)
	o243	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01607_0300)

	o244	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis8_prov_id)
	o245	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01608_0300)

	o246	(keep=rec_num prov_id fy_bgndt fy_enddt   ho_dialysis9_prov_id)
	o247	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_01609_0300)

	o248	(keep=rec_num prov_id fy_bgndt fy_enddt	prov_urban_rural)

	o249	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02100_0200)
	o250	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02101_0100)

	o251	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02101_0200)
	o252	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02102_0100)

	o253	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02102_0200)

	o254	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02103_0200)

	o255	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02103_0300)
	o256	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02103_0400)
	o257	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02103_0500)
	o258	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02106_0100)
	o259	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02107_0100)

	o260	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02108_0200)
	o261	(keep=rec_num prov_id fy_bgndt fy_enddt	S2_02200_0100)
	;

set hospsrc.hosp&yyear.alpha;
if awksht="S200001";

length awlc $17.;
awlc=awksht || aline || acol;

**make all date fields length $10, later transform into numeric and format;
length
	S2_00200_0300
	S2_00300_0300
	S2_00301_0300
	S2_00302_0300
	S2_00303_0300
	S2_00304_0300
	S2_00400_0300
	S2_00500_0300
	S2_00600_0300
	S2_00700_0300
	S2_00701_0300
	S2_00900_0300
	S2_00901_0300
	S2_00902_0300
	S2_00903_0300
	S2_00904_0300
	S2_00905_0300
	S2_00906_0300
	S2_01100_0300
	S2_01200_0300
	S2_01201_0300
	S2_01400_0300
	S2_01401_0300
	S2_01402_0300
	S2_01403_0300
	S2_01404_0300
	S2_01405_0300
	S2_01406_0300
	S2_01407_0300
	S2_01408_0300
	S2_01409_0300
	S2_01410_0300
	S2_01411_0300
	S2_01412_0300
	S2_01413_0300
	S2_01414_0300
	S2_01415_0300
	S2_01416_0300
	S2_01417_0300
	S2_01418_0300
	S2_01419_0300
	S2_01435_0300
	S2_01436_0300
	S2_01437_0300
	S2_01438_0300
	S2_01439_0300
	S2_01440_0300
	S2_01500_0300
	S2_01501_0300
	S2_01510_0300
	S2_01520_0300
	S2_01521_0300
	S2_01600_0300
	S2_01601_0300
	S2_01602_0300
	S2_01603_0300
	S2_01604_0300
	S2_01605_0300
	S2_01606_0300
	S2_01607_0300
	S2_01608_0300
	S2_01609_0300
	S2_02102_0200
	S2_02103_0300		$10.
	;

length
	prov_state		$2.
	prov_zipcode		$10.

	S2_00200_0400
	S2_00200_0500
	S2_00200_0600
	S2_00300_0400
	S2_00300_0500
	S2_00300_0600
	S2_00301_0400
	S2_00301_0500
	S2_00301_0600
	S2_00302_0500
	S2_00302_0600
	S2_00303_0500
	S2_00303_0600
	S2_00304_0500
	S2_00304_0600
	S2_00400_0400
	S2_00400_0500
	S2_00400_0600
	S2_00500_0400
	S2_00500_0600
	S2_00600_0400
	S2_00600_0500
	S2_00600_0600
	S2_00700_0400
	S2_00700_0600
	S2_00701_0400
	S2_00701_0600
	S2_00900_0400
	S2_00900_0500
	S2_00900_0600
	S2_00901_0400
	S2_00901_0500
	S2_00901_0600
	S2_00902_0500
	S2_00902_0600
	S2_00903_0500
	S2_00903_0600
	S2_00904_0500
	S2_00904_0600
	S2_00905_0500
	S2_00905_0600
	S2_00906_0500
	S2_00906_0600
	S2_01100_0500
	S2_01100_0600
	S2_01200_0500
	S2_01200_0600
	S2_01400_0400
	S2_01400_0500
	S2_01400_0600
	S2_01401_0400
	S2_01401_0500
	S2_01401_0600
	S2_01402_0400
	S2_01402_0500
	S2_01402_0600
	S2_01403_0400
	S2_01403_0500
	S2_01403_0600
	S2_01404_0400
	S2_01404_0500
	S2_01404_0600
	S2_01405_0400
	S2_01405_0500
	S2_01405_0600
	S2_01406_0400
	S2_01406_0500
	S2_01406_0600
	S2_01407_0400
	S2_01407_0500
	S2_01407_0600
	S2_01408_0500
	S2_01408_0600
	S2_01409_0500
	S2_01409_0600
	S2_01410_0500
	S2_01410_0600
	S2_01411_0500
	S2_01411_0600
	S2_01412_0500
	S2_01412_0600
	S2_01413_0500
	S2_01413_0600
	S2_01414_0500
	S2_01414_0600
	S2_01415_0500
	S2_01415_0600
	S2_01416_0500
	S2_01416_0600
	S2_01417_0500
	S2_01417_0600
	S2_01418_0500
	S2_01418_0600
	S2_01419_0500
	S2_01419_0600
	S2_01435_0500
	S2_01435_0600
	S2_01436_0500
	S2_01436_0600
	S2_01437_0500
	S2_01437_0600
	S2_01438_0500
	S2_01438_0600
	S2_01439_0500
	S2_01439_0600
	S2_01440_0500
	S2_01440_0600
	S2_01500_0500
	S2_01500_0600
	S2_01501_0500
	S2_01501_0600
	S2_01510_0500
	S2_01510_0600
	S2_01520_0500
	S2_01520_0600
	S2_01521_0500

	prov_urban_rural
	S2_02100_0200
	S2_02101_0100
	S2_02101_0200
	S2_02102_0100
	S2_02103_0200
	S2_02103_0400
	S2_02103_0500
	S2_02106_0100
	S2_02107_0100
	S2_02108_0200
	S2_02200_0100		$1.;

length
	prov_id
	ho_sub1_prov_id
	ho_sub2_prov_id
	ho_sub3_prov_id
	ho_sub4_prov_id
	ho_sub5_prov_id

	swingbeds_snf_prov_id
	swingbeds_nf_prov_id

	ho_snf_prov_id
	ho_nf0_prov_id
	ho_nf1_prov_id

	ho_hha0_prov_id
	ho_hha1_prov_id
	ho_hha2_prov_id
	ho_hha3_prov_id
	ho_hha4_prov_id
	ho_hha5_prov_id
	ho_hha6_prov_id
	ho_asc_prov_id
	ho_hospice0_prov_id
	ho_hospice1_prov_id
	ho_health_clinic0_prov_id
	ho_health_clinic1_prov_id
	ho_health_clinic2_prov_id
	ho_health_clinic3_prov_id
	ho_health_clinic4_prov_id
	ho_health_clinic5_prov_id
	ho_health_clinic6_prov_id
	ho_health_clinic7_prov_id
	ho_health_clinic8_prov_id
	ho_health_clinic9_prov_id
	ho_health_clinic10_prov_id
	ho_health_clinic11_prov_id
	ho_health_clinic12_prov_id
	ho_health_clinic13_prov_id
	ho_health_clinic14_prov_id
	ho_health_clinic15_prov_id
	ho_health_clinic16_prov_id
	ho_health_clinic17_prov_id
	ho_health_clinic18_prov_id
	ho_health_clinic19_prov_id
	ho_health_clinic35_prov_id
	ho_health_clinic36_prov_id
	ho_health_clinic37_prov_id
	ho_health_clinic38_prov_id
	ho_health_clinic39_prov_id
	ho_health_clinic40_prov_id

	ho_outpt_rehab0_prov_id
	ho_outpt_rehab1_prov_id
	ho_outpt_rehab10_prov_id
	ho_outpt_rehab20_prov_id
	ho_outpt_rehab21_prov_id

	ho_dialysis0_prov_id		
	ho_dialysis1_prov_id		
	ho_dialysis2_prov_id		
	ho_dialysis3_prov_id		
	ho_dialysis4_prov_id		
	ho_dialysis5_prov_id		
	ho_dialysis6_prov_id		
	ho_dialysis7_prov_id		
	ho_dialysis8_prov_id		
	ho_dialysis9_prov_id		$6.;

	     if awlc	="S2000010010000100" then do;	prov_street			=aitem; output o1; end;
	else if awlc	="S2000010010000200" then do;	prov_po_box			=aitem; output o2; end;
	else if awlc	="S2000010010100100" then do;	prov_city			=aitem; output o3; end;
	else if awlc	="S2000010010100200" then do;	prov_state			=aitem; output o4; end;
	else if awlc	="S2000010010100300" then do;	prov_zipcode			=aitem; output o5; end;
	else if awlc	="S2000010010100400" then do;	prov_county			=aitem; output o6; end;
	else if awlc	="S2000010020000100" then do;	prov_name			=aitem; output o7; end;
	else if awlc	="S2000010020000200" then do;	prov_id				=aitem; output o8; end;
	else if awlc	="S2000010020000300" then do;	S2_00200_0300			=aitem; output o9; end;
	else if awlc	="S2000010020000400" then do;	S2_00200_0400			=aitem; output o10; end;
	else if awlc	="S2000010020000500" then do;	S2_00200_0500			=aitem; output o11; end;
	else if awlc	="S2000010020000600" then do;	S2_00200_0600			=aitem; output o12; end;
	else if awlc	="S2000010030000200" then do;	ho_sub1_prov_id			=aitem; output o13; end;
	else if awlc	="S2000010030000300" then do;	S2_00300_0300			=aitem; output o14; end;
	else if awlc	="S2000010030000400" then do;	S2_00300_0400			=aitem; output o15; end;
	else if awlc	="S2000010030000500" then do;	S2_00300_0500			=aitem; output o16; end;
	else if awlc	="S2000010030000600" then do;	S2_00300_0600			=aitem; output o17; end;
	else if awlc	="S2000010030100200" then do;	ho_sub2_prov_id			=aitem; output o18; end;
	else if awlc	="S2000010030100300" then do;	S2_00301_0300			=aitem; output o19; end;
	else if awlc	="S2000010030100400" then do;	S2_00301_0400			=aitem; output o20; end;
	else if awlc	="S2000010030100500" then do;	S2_00301_0500			=aitem; output o21; end;
	else if awlc	="S2000010030100600" then do;	S2_00301_0600			=aitem; output o22; end;
	else if awlc	="S2000010030200200" then do;	ho_sub3_prov_id			=aitem; output o23; end;
	else if awlc	="S2000010030200300" then do;	S2_00302_0300			=aitem; output o24; end;
	else if awlc	="S2000010030200500" then do;	S2_00302_0500			=aitem; output o25; end;
	else if awlc	="S2000010030200600" then do;	S2_00302_0600			=aitem; output o26; end;
	else if awlc	="S2000010030300200" then do;	ho_sub4_prov_id			=aitem; output o27; end;
	else if awlc	="S2000010030300300" then do;	S2_00303_0300			=aitem; output o28; end;
	else if awlc	="S2000010030300500" then do;	S2_00303_0500			=aitem; output o29; end;
	else if awlc	="S2000010030300600" then do;	S2_00303_0600			=aitem; output o30; end;
	else if awlc	="S2000010030400200" then do;	ho_sub5_prov_id			=aitem; output o31; end;
	else if awlc	="S2000010030400300" then do;	S2_00304_0300			=aitem; output o32; end;
	else if awlc	="S2000010030400500" then do;	S2_00304_0500			=aitem; output o33; end;
	else if awlc	="S2000010030400600" then do;	S2_00304_0600			=aitem; output o34; end;
	else if awlc	="S2000010040000200" then do;	swingbeds_snf_prov_id		=aitem; output o35; end;
	else if awlc	="S2000010040000300" then do;	S2_00400_0300			=aitem; output o36; end;
	else if awlc	="S2000010040000400" then do;	S2_00400_0400			=aitem; output o37; end;
	else if awlc	="S2000010040000500" then do;	S2_00400_0500			=aitem; output o38; end;
	else if awlc	="S2000010040000600" then do;	S2_00400_0600			=aitem; output o39; end;
	else if awlc	="S2000010050000200" then do;	swingbeds_nf_prov_id		=aitem; output o40; end;
	else if awlc	="S2000010050000300" then do;	S2_00500_0300			=aitem; output o41; end;
	else if awlc	="S2000010050000400" then do;	S2_00500_0400			=aitem; output o42; end;
	else if awlc	="S2000010050000600" then do;	S2_00500_0600			=aitem; output o43; end;
	else if awlc	="S2000010060000200" then do;	ho_snf_prov_id			=aitem; output o44; end;
	else if awlc	="S2000010060000300" then do;	S2_00600_0300			=aitem; output o45; end;
	else if awlc	="S2000010060000400" then do;	S2_00600_0400			=aitem; output o46; end;
	else if awlc	="S2000010060000500" then do;	S2_00600_0500			=aitem; output o47; end;
	else if awlc	="S2000010060000600" then do;	S2_00600_0600			=aitem; output o48; end;
	else if awlc	="S2000010070000200" then do;	ho_nf0_prov_id			=aitem; output o49; end;
	else if awlc	="S2000010070000300" then do;	S2_00700_0300			=aitem; output o50; end;
	else if awlc	="S2000010070000400" then do;	S2_00700_0400			=aitem; output o51; end;
	else if awlc	="S2000010070000600" then do;	S2_00700_0600			=aitem; output o52; end;
	else if awlc	="S2000010070100200" then do;	ho_nf1_prov_id			=aitem; output o53; end;
	else if awlc	="S2000010070100300" then do;	S2_00701_0300			=aitem; output o54; end;
	else if awlc	="S2000010070100400" then do;	S2_00701_0400			=aitem; output o55; end;
	else if awlc	="S2000010070100600" then do;	S2_00701_0600			=aitem; output o56; end;
	else if awlc	="S2000010090000200" then do;	ho_hha0_prov_id			=aitem; output o57; end;
	else if awlc	="S2000010090000300" then do;	S2_00900_0300			=aitem; output o58; end;
	else if awlc	="S2000010090000400" then do;	S2_00900_0400			=aitem; output o59; end;
	else if awlc	="S2000010090000500" then do;	S2_00900_0500			=aitem; output o60; end;
	else if awlc	="S2000010090000600" then do;	S2_00900_0600			=aitem; output o61; end;
	else if awlc	="S2000010090100200" then do;	ho_hha1_prov_id			=aitem; output o62; end;
	else if awlc	="S2000010090100300" then do;	S2_00901_0300			=aitem; output o63; end;
	else if awlc	="S2000010090100400" then do;	S2_00901_0400			=aitem; output o64; end;
	else if awlc	="S2000010090100500" then do;	S2_00901_0500			=aitem; output o65; end;
	else if awlc	="S2000010090100600" then do;	S2_00901_0600			=aitem; output o66; end;
	else if awlc	="S2000010090200200" then do;	ho_hha2_prov_id			=aitem; output o67; end;
	else if awlc	="S2000010090200300" then do;	S2_00902_0300			=aitem; output o68; end;
	else if awlc	="S2000010090200500" then do;	S2_00902_0500			=aitem; output o69; end;
	else if awlc	="S2000010090200600" then do;	S2_00902_0600			=aitem; output o70; end;
	else if awlc	="S2000010090300200" then do;	ho_hha3_prov_id			=aitem; output o71; end;
	else if awlc	="S2000010090300300" then do;	S2_00903_0300			=aitem; output o72; end;
	else if awlc	="S2000010090300500" then do;	S2_00903_0500			=aitem; output o73; end;
	else if awlc	="S2000010090300600" then do;	S2_00903_0600			=aitem; output o74; end;
	else if awlc	="S2000010090400200" then do;	ho_hha4_prov_id			=aitem; output o75; end;
	else if awlc	="S2000010090400300" then do;	S2_00904_0300			=aitem; output o76; end;
	else if awlc	="S2000010090400500" then do;	S2_00904_0500			=aitem; output o77; end;
	else if awlc	="S2000010090400600" then do;	S2_00904_0600			=aitem; output o78; end;
	else if awlc	="S2000010090500200" then do;	ho_hha5_prov_id			=aitem; output o79; end;
	else if awlc	="S2000010090500300" then do;	S2_00905_0300			=aitem; output o80; end;
	else if awlc	="S2000010090500500" then do;	S2_00905_0500			=aitem; output o81; end;
	else if awlc	="S2000010090500600" then do;	S2_00905_0600			=aitem; output o82; end;
	else if awlc	="S2000010090600200" then do;	ho_hha6_prov_id			=aitem; output o83; end;
	else if awlc	="S2000010090600300" then do;	S2_00906_0300			=aitem; output o84; end;
	else if awlc	="S2000010090600500" then do;	S2_00906_0500			=aitem; output o85; end;
	else if awlc	="S2000010090600600" then do;	S2_00906_0600			=aitem; output o86; end;
	else if awlc	="S2000010110000200" then do;	ho_asc_prov_id			=aitem; output o87; end;
	else if awlc	="S2000010110000300" then do;	S2_01100_0300			=aitem; output o88; end;
	else if awlc	="S2000010110000500" then do;	S2_01100_0500			=aitem; output o89; end;
	else if awlc	="S2000010110000600" then do;	S2_01100_0600			=aitem; output o90; end;
	else if awlc	="S2000010120000200" then do;	ho_hospice0_prov_id		=aitem; output o91; end;
	else if awlc	="S2000010120000300" then do;	S2_01200_0300			=aitem; output o92; end;
	else if awlc	="S2000010120000500" then do;	S2_01200_0500			=aitem; output o93; end;
	else if awlc	="S2000010120000600" then do;	S2_01200_0600			=aitem; output o94; end;
	else if awlc	="S2000010120100200" then do;	ho_hospice1_prov_id		=aitem; output o95; end;
	else if awlc	="S2000010120100300" then do;	S2_01201_0300			=aitem; output o96; end;
	else if awlc	="S2000010140000200" then do;	ho_health_clinic0_prov_id      	=aitem; output o97; end;
	else if awlc	="S2000010140000300" then do;	S2_01400_0300			=aitem; output o98; end;
	else if awlc	="S2000010140000400" then do;	S2_01400_0400			=aitem; output o99; end;
	else if awlc	="S2000010140000500" then do;	S2_01400_0500			=aitem; output o100; end;
	else if awlc	="S2000010140000600" then do;	S2_01400_0600			=aitem; output o101; end;
	else if awlc	="S2000010140100200" then do;	ho_health_clinic1_prov_id	=aitem; output o102; end;
	else if awlc	="S2000010140100300" then do;	S2_01401_0300			=aitem; output o103; end;
	else if awlc	="S2000010140100400" then do;	S2_01401_0400			=aitem; output o104; end;
	else if awlc	="S2000010140100500" then do;	S2_01401_0500			=aitem; output o105; end;
	else if awlc	="S2000010140100600" then do;	S2_01401_0600			=aitem; output o106; end;
	else if awlc	="S2000010140200200" then do;	ho_health_clinic2_prov_id	=aitem; output o107; end;
	else if awlc	="S2000010140200300" then do;	S2_01402_0300			=aitem; output o108; end;
	else if awlc	="S2000010140200400" then do;	S2_01402_0400			=aitem; output o109; end;
	else if awlc	="S2000010140200500" then do;	S2_01402_0500			=aitem; output o110; end;
	else if awlc	="S2000010140200600" then do;	S2_01402_0600			=aitem; output o111; end;
	else if awlc	="S2000010140300200" then do;	ho_health_clinic3_prov_id	=aitem; output o112; end;
	else if awlc	="S2000010140300300" then do;	S2_01403_0300			=aitem; output o113; end;
	else if awlc	="S2000010140300400" then do;	S2_01403_0400			=aitem; output o114; end;
	else if awlc	="S2000010140300500" then do;	S2_01403_0500			=aitem; output o115; end;
	else if awlc	="S2000010140300600" then do;	S2_01403_0600			=aitem; output o116; end;
	else if awlc	="S2000010140400200" then do;	ho_health_clinic4_prov_id      	=aitem; output o117; end;
	else if awlc	="S2000010140400300" then do;	S2_01404_0300			=aitem; output o118; end;
	else if awlc	="S2000010140400400" then do;	S2_01404_0400			=aitem; output o119; end;
	else if awlc	="S2000010140400500" then do;	S2_01404_0500			=aitem; output o120; end;
	else if awlc	="S2000010140400600" then do;	S2_01404_0600			=aitem; output o121; end;
	else if awlc	="S2000010140500200" then do;	ho_health_clinic5_prov_id	=aitem; output o122; end;
	else if awlc	="S2000010140500300" then do;	S2_01405_0300			=aitem; output o123; end;
	else if awlc	="S2000010140500400" then do;	S2_01405_0400			=aitem; output o124; end;
	else if awlc	="S2000010140500500" then do;	S2_01405_0500			=aitem; output o125; end;
	else if awlc	="S2000010140500600" then do;	S2_01405_0600			=aitem; output o126; end;
	else if awlc	="S2000010140600200" then do;	ho_health_clinic6_prov_id	=aitem; output o127; end;
	else if awlc	="S2000010140600300" then do;	S2_01406_0300			=aitem; output o128; end;
	else if awlc	="S2000010140600400" then do;	S2_01406_0400			=aitem; output o129; end;
	else if awlc	="S2000010140600500" then do;	S2_01406_0500			=aitem; output o130; end;
	else if awlc	="S2000010140600600" then do;	S2_01406_0600			=aitem; output o131; end;
	else if awlc	="S2000010140700200" then do;	ho_health_clinic7_prov_id	=aitem; output o132; end;
	else if awlc	="S2000010140700300" then do;	S2_01407_0300			=aitem; output o133; end;
	else if awlc	="S2000010140700400" then do;	S2_01407_0400			=aitem; output o134; end;
	else if awlc	="S2000010140700500" then do;	S2_01407_0500			=aitem; output o135; end;
	else if awlc	="S2000010140700600" then do;	S2_01407_0600			=aitem; output o136; end;
	else if awlc	="S2000010140800200" then do;	ho_health_clinic8_prov_id	=aitem; output o137; end;
	else if awlc	="S2000010140800300" then do;	S2_01408_0300			=aitem; output o138; end;
	else if awlc	="S2000010140800500" then do;	S2_01408_0500			=aitem; output o139; end;
	else if awlc	="S2000010140800600" then do;	S2_01408_0600			=aitem; output o140; end;
	else if awlc	="S2000010140900200" then do;	ho_health_clinic9_prov_id	=aitem; output o141; end;
	else if awlc	="S2000010140900300" then do;	S2_01409_0300			=aitem; output o142; end;
	else if awlc	="S2000010140900500" then do;	S2_01409_0500			=aitem; output o143; end;
	else if awlc	="S2000010140900600" then do;	S2_01409_0600			=aitem; output o144; end;
	else if awlc	="S2000010141000200" then do;	ho_health_clinic10_prov_id	=aitem; output o145; end;
	else if awlc	="S2000010141000300" then do;	S2_01410_0300			=aitem; output o146; end;
	else if awlc	="S2000010141000500" then do;	S2_01410_0500			=aitem; output o147; end;
	else if awlc	="S2000010141000600" then do;	S2_01410_0600			=aitem; output o148; end;
	else if awlc	="S2000010141100200" then do;	ho_health_clinic11_prov_id	=aitem; output o149; end;
	else if awlc	="S2000010141100300" then do;	S2_01411_0300			=aitem; output o150; end;
	else if awlc	="S2000010141100500" then do;	S2_01411_0500			=aitem; output o151; end;
	else if awlc	="S2000010141100600" then do;	S2_01411_0600			=aitem; output o152; end;
	else if awlc	="S2000010141200200" then do;	ho_health_clinic12_prov_id     	=aitem; output o153; end;
	else if awlc	="S2000010141200300" then do;	S2_01412_0300			=aitem; output o154; end;
	else if awlc	="S2000010141200500" then do;	S2_01412_0500			=aitem; output o155; end;
	else if awlc	="S2000010141200600" then do;	S2_01412_0600			=aitem; output o156; end;
	else if awlc	="S2000010141300200" then do;	ho_health_clinic13_prov_id	=aitem; output o157; end;
	else if awlc	="S2000010141300300" then do;	S2_01413_0300			=aitem; output o158; end;
	else if awlc	="S2000010141300500" then do;	S2_01413_0500			=aitem; output o159; end;
	else if awlc	="S2000010141300600" then do;	S2_01413_0600			=aitem; output o160; end;
	else if awlc	="S2000010141400200" then do;	ho_health_clinic14_prov_id     	=aitem; output o161; end;
	else if awlc	="S2000010141400300" then do;	S2_01414_0300			=aitem; output o162; end;
	else if awlc	="S2000010141400500" then do;	S2_01414_0500			=aitem; output o163; end;
	else if awlc	="S2000010141400600" then do;	S2_01414_0600			=aitem; output o164; end;
	else if awlc	="S2000010141500200" then do;	ho_health_clinic15_prov_id	=aitem; output o165; end;
	else if awlc	="S2000010141500300" then do;	S2_01415_0300			=aitem; output o166; end;
	else if awlc	="S2000010141500500" then do;	S2_01415_0500			=aitem; output o167; end;
	else if awlc	="S2000010141500600" then do;	S2_01415_0600			=aitem; output o168; end;
	else if awlc	="S2000010141600200" then do;	ho_health_clinic16_prov_id	=aitem; output o169; end;
	else if awlc	="S2000010141600300" then do;	S2_01416_0300			=aitem; output o170; end;
	else if awlc	="S2000010141600500" then do;	S2_01416_0500			=aitem; output o171; end;
	else if awlc	="S2000010141600600" then do;	S2_01416_0600			=aitem; output o172; end;
	else if awlc	="S2000010141700200" then do;	ho_health_clinic17_prov_id	=aitem; output o173; end;
	else if awlc	="S2000010141700300" then do;	S2_01417_0300			=aitem; output o174; end;
	else if awlc	="S2000010141700500" then do;	S2_01417_0500			=aitem; output o175; end;
	else if awlc	="S2000010141700600" then do;	S2_01417_0600			=aitem; output o176; end;
	else if awlc	="S2000010141800200" then do;	ho_health_clinic18_prov_id	=aitem; output o177; end;
	else if awlc	="S2000010141800300" then do;	S2_01418_0300			=aitem; output o178; end;
	else if awlc	="S2000010141800500" then do;	S2_01418_0500			=aitem; output o179; end;
	else if awlc	="S2000010141800600" then do;	S2_01418_0600			=aitem; output o180; end;
	else if awlc	="S2000010141900200" then do;	ho_health_clinic19_prov_id     	=aitem; output o181; end;
	else if awlc	="S2000010141900300" then do;	S2_01419_0300			=aitem; output o182; end;
	else if awlc	="S2000010141900500" then do;	S2_01419_0500			=aitem; output o183; end;
	else if awlc	="S2000010141900600" then do;	S2_01419_0600			=aitem; output o184; end;
	else if awlc	="S2000010143500200" then do;	ho_health_clinic35_prov_id	=aitem; output o185; end;
	else if awlc	="S2000010143500300" then do;	S2_01435_0300			=aitem; output o186; end;
	else if awlc	="S2000010143500500" then do;	S2_01435_0500			=aitem; output o187; end;
	else if awlc	="S2000010143500600" then do;	S2_01435_0600			=aitem; output o188; end;
	else if awlc	="S2000010143600200" then do;	ho_health_clinic36_prov_id     	=aitem; output o189; end;
	else if awlc	="S2000010143600300" then do;	S2_01436_0300			=aitem; output o190; end;
	else if awlc	="S2000010143600500" then do;	S2_01436_0500			=aitem; output o191; end;
	else if awlc	="S2000010143600600" then do;	S2_01436_0600			=aitem; output o192; end;
	else if awlc	="S2000010143700200" then do;	ho_health_clinic37_prov_id	=aitem; output o193; end;
	else if awlc	="S2000010143700300" then do;	S2_01437_0300			=aitem; output o194; end;
	else if awlc	="S2000010143700500" then do;	S2_01437_0500			=aitem; output o195; end;
	else if awlc	="S2000010143700600" then do;	S2_01437_0600			=aitem; output o196; end;
	else if awlc	="S2000010143800200" then do;	ho_health_clinic38_prov_id	=aitem; output o197; end;
	else if awlc	="S2000010143800300" then do;	S2_01438_0300			=aitem; output o198; end;
	else if awlc	="S2000010143800500" then do;	S2_01438_0500			=aitem; output o199; end;
	else if awlc	="S2000010143800600" then do;	S2_01438_0600			=aitem; output o200; end;
	else if awlc	="S2000010143900200" then do;	ho_health_clinic39_prov_id	=aitem; output o201; end;
	else if awlc	="S2000010143900300" then do;	S2_01439_0300			=aitem; output o202; end;
	else if awlc	="S2000010143900500" then do;	S2_01439_0500			=aitem; output o203; end;
	else if awlc	="S2000010143900600" then do;	S2_01439_0600			=aitem; output o204; end;
	else if awlc	="S2000010144000200" then do;	ho_health_clinic40_prov_id	=aitem; output o205; end;
	else if awlc	="S2000010144000300" then do;	S2_01440_0300			=aitem; output o206; end;
	else if awlc	="S2000010144000500" then do;	S2_01440_0500			=aitem; output o207; end;
	else if awlc	="S2000010144000600" then do;	S2_01440_0600			=aitem; output o208; end;
	else if awlc	="S2000010150000200" then do;	ho_outpt_rehab0_prov_id		=aitem; output o209; end;
	else if awlc	="S2000010150000300" then do;	S2_01500_0300			=aitem; output o210; end;
	else if awlc	="S2000010150000500" then do;	S2_01500_0500			=aitem; output o211; end;
	else if awlc	="S2000010150000600" then do;	S2_01500_0600			=aitem; output o212; end;
	else if awlc	="S2000010150100200" then do;	ho_outpt_rehab1_prov_id		=aitem; output o213; end;
	else if awlc	="S2000010150100300" then do;	S2_01501_0300			=aitem; output o214; end;
	else if awlc	="S2000010150100500" then do;	S2_01501_0500			=aitem; output o215; end;
	else if awlc	="S2000010150100600" then do;	S2_01501_0600			=aitem; output o216; end;
	else if awlc	="S2000010151000200" then do;	ho_outpt_rehab10_prov_id	=aitem; output o217; end;
	else if awlc	="S2000010151000300" then do;	S2_01510_0300			=aitem; output o218; end;
	else if awlc	="S2000010151000500" then do;	S2_01510_0500			=aitem; output o219; end;
	else if awlc	="S2000010151000600" then do;	S2_01510_0600			=aitem; output o220; end;
	else if awlc	="S2000010152000200" then do;	ho_outpt_rehab20_prov_id	=aitem; output o221; end;
	else if awlc	="S2000010152000300" then do;	S2_01520_0300			=aitem; output o222; end;
	else if awlc	="S2000010152000500" then do;	S2_01520_0500			=aitem; output o223; end;
	else if awlc	="S2000010152000600" then do;	S2_01520_0600			=aitem; output o224; end;
	else if awlc	="S2000010152100200" then do;	ho_outpt_rehab21_prov_id	=aitem; output o225; end;
	else if awlc	="S2000010152100300" then do;	S2_01521_0300			=aitem; output o226; end;
	else if awlc	="S2000010152100500" then do;	S2_01521_0500			=aitem; output o227; end;
	else if awlc	="S2000010160000200" then do;	ho_dialysis0_prov_id		=aitem; output o228; end;
	else if awlc	="S2000010160000300" then do;	S2_01600_0300			=aitem; output o229; end;
	else if awlc	="S2000010160100200" then do;	ho_dialysis1_prov_id		=aitem; output o230; end;
	else if awlc	="S2000010160100300" then do;	S2_01601_0300			=aitem; output o231; end;
	else if awlc	="S2000010160200200" then do;	ho_dialysis2_prov_id		=aitem; output o232; end;
	else if awlc	="S2000010160200300" then do;	S2_01602_0300			=aitem; output o233; end;
	else if awlc	="S2000010160300200" then do;	ho_dialysis3_prov_id		=aitem; output o234; end;
	else if awlc	="S2000010160300300" then do;	S2_01603_0300			=aitem; output o235; end;
	else if awlc	="S2000010160400200" then do;	ho_dialysis4_prov_id		=aitem; output o236; end;
	else if awlc	="S2000010160400300" then do;	S2_01604_0300			=aitem; output o237; end;
	else if awlc	="S2000010160500200" then do;	ho_dialysis5_prov_id		=aitem; output o238; end;
	else if awlc	="S2000010160500300" then do;	S2_01605_0300			=aitem; output o239; end;
	else if awlc	="S2000010160600200" then do;	ho_dialysis6_prov_id		=aitem; output o240; end;
	else if awlc	="S2000010160600300" then do;	S2_01606_0300			=aitem; output o241; end;
	else if awlc	="S2000010160700200" then do;	ho_dialysis7_prov_id		=aitem; output o242; end;
	else if awlc	="S2000010160700300" then do;	S2_01607_0300			=aitem; output o243; end;
	else if awlc	="S2000010160800200" then do;	ho_dialysis8_prov_id		=aitem; output o244; end;
	else if awlc	="S2000010160800300" then do;	S2_01608_0300			=aitem; output o245; end;
	else if awlc	="S2000010160900200" then do;	ho_dialysis9_prov_id		=aitem; output o246; end;
	else if awlc	="S2000010160900300" then do;	S2_01609_0300			=aitem; output o247; end;
	else if awlc	="S2000010210000100" then do;	prov_urban_rural		=aitem; output o248; end;
	else if awlc	="S2000010210000200" then do;	S2_02100_0200			=aitem; output o249; end;
	else if awlc	="S2000010210100100" then do;	S2_02101_0100			=aitem; output o250; end;
	else if awlc	="S2000010210100200" then do;	S2_02101_0200			=aitem; output o251; end;
	else if awlc	="S2000010210200100" then do;	S2_02102_0100			=aitem; output o252; end;
	else if awlc	="S2000010210200200" then do;	S2_02102_0200			=aitem; output o253; end;
	else if awlc	="S2000010210300200" then do;	S2_02103_0200			=aitem; output o254; end;
	else if awlc	="S2000010210300300" then do;	S2_02103_0300			=aitem; output o255; end;
	else if awlc	="S2000010210300400" then do;	S2_02103_0400			=aitem; output o256; end;
	else if awlc	="S2000010210300500" then do;	S2_02103_0500			=aitem; output o257; end;
	else if awlc	="S2000010210600100" then do;	S2_02106_0100			=aitem; output o258; end;
	else if awlc	="S2000010210700100" then do;	S2_02107_0100			=aitem; output o259; end;
	else if awlc	="S2000010210800200" then do;	S2_02108_0200			=aitem; output o260; end;
	else if awlc	="S2000010220000100" then do;	S2_02200_0100			=aitem; output o261; end;

data s2alpha;
merge
      o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 
      o11 o12 o13 o14 o15 o16 o17 o18 o19 
      o20 o21 o22 o23 o24 o25 o26 o27 o28 o29 
      o30 o31 o32 o33 o34 o35 o36 o37 o38 o39 
      o40 o41 o42 o43 o44 o45 o46 o47 o48 o49 
      o50 o51 o52 o53 o54 o55 o56 o57 o58 o59 
      o60 o61 o62 o63 o64 o65 o66 o67 o68 o69 
      o70 o71 o72 o73 o74 o75 o76 o77 o78 o79 
      o80 o81 o82 o83 o84 o85 o86 o87 o88 o89
      o90 o91 o92 o93 o94 o95 o96 o97 o98 o99
      o100 o101 o102 o103 o104 o105 o106 o107 o108 o109
      o110 o111 o112 o113 o114 o115 o116 o117 o118 o119
      o120 o121 o122 o123 o124 o125 o126 o127 o128 o129
      o130 o131 o132 o133 o134 o135 o136 o137 o138 o139
      o140 o141 o142 o143 o144 o145 o146 o147 o148 o149
      o150 o151 o152 o153 o154 o155 o156 o157 o158 o159
      o160 o161 o162 o163 o164 o165 o166 o167 o168 o169
      o170 o171 o172 o173 o174 o175 o176 o177 o178 o179
      o180 o181 o182 o183 o184 o185 o186 o187 o188 o189
      o190 o191 o192 o193 o194 o195 o196 o197 o198 o199
      o200 o201 o202 o203 o204 o205 o206 o207 o208 o209
      o210 o211 o212 o213 o214 o215 o216 o217 o218 o219
      o220 o221 o222 o223 o224 o225 o226 o227 o228 o229
      o230 o231 o232 o233 o234 o235 o236 o237 o238 o239
      o240 o241 o242 o243 o244 o245 o246 o247 o248 o249
      o250 o251 o252 o253 o254 o255 o256 o257 o258 o259
      o260 o261;
 by rec_num;
run;

*data hosp&yyear._S2alpha;
*merge s2alpha hospsrc.hosp&yyear.rpt(keep=rec_num prov_ctrl rpt_stus);
* by rec_num;
*run;

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
run;




	/*Formats change between v96 and v10 and subprovider is broken down from 1 line to 3 lines. See how these lines look in v10*/
	title "CHECK PROVIDER SUBTYPE";
	proc freq data=s2nmrc;
		tables nitem;
		where nlinecol="00400_00400";
	run;

	proc freq data=s2nmrc;
		tables nitem;
		where nlinecol="00500_00400";
	run;

	proc freq data=s2nmrc;
		tables nitem;
		where nlinecol="00600_00400";
	run;
	title;
	/*Continue with regular code*/





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

/*Check Provider Types*/
data test_prov_type;
	merge dfydt titem(rename=(
	/*S2_01900_0100=prov_type
	S2_02000_0100=ho_sub1_prov_type
	S2_02001_0100=ho_sub2_prov_type*/
	S2_00300_00400=prov_type
	S2_00400_00400=ho_sub1_prov_type
	S2_00500_00400=ho_sub2_prov_type)); /**/
 by rec_num;
run;

title "Test Provider Type";
proc freq data=test_prov_type;
	tables prov_type ho_sub1_prov_type ho_sub2_prov_type;
run;
title;

data s2nmrc(keep=rec_num prov_id sub fy_bgndt fy_enddt 
	S2_01800_0100
	prov_type
	ho_sub1_prov_type
	ho_sub2_prov_type
	S2_02002_0100
	S2_02003_0100
	S2_02004_0100
	S2_02103_0100
	S2_02104_0100
	S2_02105_0100
	S2_02600_0100
	S2_02603_0100
	S2_02801_0100
	S2_02801_0200
	S2_02801_0300
	S2_02802_0100
	S2_02803_0100
	S2_02804_0100
	S2_02805_0100
	S2_02806_0100
	S2_02807_0100
	S2_02808_0100
	S2_02809_0100
	S2_02810_0100
	S2_02811_0100
	S2_02812_0100
	S2_02813_0100
	S2_02814_0100
	S2_02815_0100
	S2_02816_0100
	S2_02817_0100
	S2_02818_0100
	S2_02819_0100
	S2_02820_0100
	S2_04600_0100
	S2_05300_0100
	S2_05400_0100
	S2_05400_0200
	S2_05400_0300
	S2_05600_0200
	S2_05600_0400
	S2_05601_0200
	S2_05601_0400
	S2_05602_0200
	S2_05602_0400
	S2_05603_0200
	S2_05603_0400
	S2_05801_0300
	S2_06001_0300
	S2_06200_0500
	S2_06201_0500
	S2_06202_0500
	S2_06203_0500
	S2_06204_0500
	S2_06205_0500
	S2_06206_0500
	S2_06207_0500
	S2_06208_0500
	S2_06209_0500)
	;

merge dfydt titem(rename=(
	/*S2_01900_0100=prov_type
	S2_02000_0100=ho_sub1_prov_type
	S2_02001_0100=ho_sub2_prov_type*/
	S2_00300_00400=prov_type
	S2_00400_00400=ho_sub1_prov_type
	S2_00500_00400=ho_sub2_prov_type)); /**/
 by rec_num;

length sub 3.;
**only keep if Main provider, 1st subprovider or 2nd subprovider is an irf, ltch or ach;
if prov_type in(1 2 5) then do;
   sub=0;
   output s2nmrc;
end;
else if ho_sub1_prov_type in(1 2 5) then do;
   sub=1;
   output s2nmrc;
end;
else if ho_sub2_prov_type in(1 2 5) then do;
   sub=2;
   output s2nmrc;
end;

**merge S2 alpha and nmrc data sets together;
*only keep if there is a nmrc record, because the nmrc file has been restricted to irfs, ltchs and achs;

data s2data;
merge s2alpha(in=ina) s2nmrc(in=ingood);
 by rec_num;
 if ingood and ina;

***convert dates from character to numeric and format;
rename
	S2_00200_0300		=c_S2_00200_0300
	S2_00300_0300		=c_S2_00300_0300
	S2_00301_0300		=c_S2_00301_0300
	S2_00302_0300		=c_S2_00302_0300
	S2_00303_0300		=c_S2_00303_0300
	S2_00304_0300		=c_S2_00304_0300
	S2_00400_0300		=c_S2_00400_0300
	S2_00500_0300		=c_S2_00500_0300
	S2_00600_0300		=c_S2_00600_0300
	S2_00700_0300		=c_S2_00700_0300
	S2_00701_0300		=c_S2_00701_0300
	S2_00900_0300		=c_S2_00900_0300
	S2_00901_0300		=c_S2_00901_0300
	S2_00902_0300		=c_S2_00902_0300
	S2_00903_0300		=c_S2_00903_0300
	S2_00904_0300		=c_S2_00904_0300

	S2_00905_0300		=c_S2_00905_0300
	S2_00906_0300		=c_S2_00906_0300

	S2_01100_0300		=c_S2_01100_0300
	S2_01200_0300		=c_S2_01200_0300
	S2_01201_0300		=c_S2_01201_0300
	S2_01400_0300		=c_S2_01400_0300
	S2_01401_0300		=c_S2_01401_0300
	S2_01402_0300		=c_S2_01402_0300
	S2_01403_0300		=c_S2_01403_0300
	S2_01404_0300		=c_S2_01404_0300
	S2_01405_0300		=c_S2_01405_0300
	S2_01406_0300		=c_S2_01406_0300
	S2_01407_0300		=c_S2_01407_0300
	S2_01408_0300		=c_S2_01408_0300
	S2_01409_0300		=c_S2_01409_0300
	S2_01410_0300		=c_S2_01410_0300
	S2_01411_0300		=c_S2_01411_0300
	S2_01412_0300		=c_S2_01412_0300
	S2_01413_0300		=c_S2_01413_0300
	S2_01414_0300		=c_S2_01414_0300
	S2_01415_0300		=c_S2_01415_0300
	S2_01416_0300		=c_S2_01416_0300
	S2_01417_0300		=c_S2_01417_0300
	S2_01418_0300		=c_S2_01418_0300
	S2_01419_0300		=c_S2_01419_0300
	S2_01435_0300		=c_S2_01435_0300

	S2_01436_0300		=c_S2_01436_0300
	S2_01437_0300		=c_S2_01437_0300
	S2_01438_0300		=c_S2_01438_0300
	S2_01439_0300		=c_S2_01439_0300
	S2_01440_0300		=c_S2_01440_0300

	S2_01500_0300		=c_S2_01500_0300
	S2_01501_0300		=c_S2_01501_0300
	S2_01510_0300		=c_S2_01510_0300
	S2_01520_0300		=c_S2_01520_0300
	S2_01521_0300		=c_S2_01521_0300

	S2_01600_0300		=c_S2_01600_0300
	S2_01601_0300		=c_S2_01601_0300
	S2_01602_0300		=c_S2_01602_0300
	S2_01603_0300		=c_S2_01603_0300
	S2_01604_0300		=c_S2_01604_0300
	S2_01605_0300		=c_S2_01605_0300
	S2_01606_0300		=c_S2_01606_0300
	S2_01607_0300		=c_S2_01607_0300
	S2_01608_0300		=c_S2_01608_0300
	S2_01609_0300		=c_S2_01609_0300

	S2_02102_0200		=c_S2_02102_0200
	S2_02103_0300		=c_S2_02103_0300
	;

data s2data;
set s2data;

	S2_00200_0300	=input(c_S2_00200_0300	,mmddyy10.);
	S2_00300_0300	=input(c_S2_00300_0300	,mmddyy10.);
	S2_00301_0300	=input(c_S2_00301_0300	,mmddyy10.);
	S2_00302_0300	=input(c_S2_00302_0300	,mmddyy10.);
	S2_00303_0300	=input(c_S2_00303_0300	,mmddyy10.);
	S2_00304_0300	=input(c_S2_00304_0300	,mmddyy10.);
	S2_00400_0300	=input(c_S2_00400_0300	,mmddyy10.);
	S2_00500_0300	=input(c_S2_00500_0300	,mmddyy10.);
	S2_00600_0300	=input(c_S2_00600_0300	,mmddyy10.);
	S2_00700_0300	=input(c_S2_00700_0300	,mmddyy10.);
	S2_00701_0300	=input(c_S2_00701_0300	,mmddyy10.);
	S2_00900_0300	=input(c_S2_00900_0300	,mmddyy10.);
	S2_00901_0300	=input(c_S2_00901_0300	,mmddyy10.);
	S2_00902_0300	=input(c_S2_00902_0300	,mmddyy10.);
	S2_00903_0300	=input(c_S2_00903_0300	,mmddyy10.);
	S2_00904_0300	=input(c_S2_00904_0300	,mmddyy10.);
	S2_01100_0300	=input(c_S2_01100_0300	,mmddyy10.);
	S2_01200_0300	=input(c_S2_01200_0300	,mmddyy10.);
	S2_01201_0300	=input(c_S2_01201_0300	,mmddyy10.);
	S2_01400_0300	=input(c_S2_01400_0300	,mmddyy10.);
	S2_01401_0300	=input(c_S2_01401_0300	,mmddyy10.);
	S2_01402_0300	=input(c_S2_01402_0300	,mmddyy10.);
	S2_01403_0300	=input(c_S2_01403_0300	,mmddyy10.);
	S2_01404_0300	=input(c_S2_01404_0300	,mmddyy10.);
	S2_01405_0300	=input(c_S2_01405_0300	,mmddyy10.);
	S2_01406_0300	=input(c_S2_01406_0300	,mmddyy10.);
	S2_01407_0300	=input(c_S2_01407_0300	,mmddyy10.);
	S2_01408_0300	=input(c_S2_01408_0300	,mmddyy10.);
	S2_01409_0300	=input(c_S2_01409_0300	,mmddyy10.);
	S2_01410_0300	=input(c_S2_01410_0300	,mmddyy10.);
	S2_01411_0300	=input(c_S2_01411_0300	,mmddyy10.);
	S2_01412_0300	=input(c_S2_01412_0300	,mmddyy10.);
	S2_01413_0300	=input(c_S2_01413_0300	,mmddyy10.);
	S2_01414_0300	=input(c_S2_01414_0300	,mmddyy10.);
	S2_01415_0300	=input(c_S2_01415_0300	,mmddyy10.);
	S2_01416_0300	=input(c_S2_01416_0300	,mmddyy10.);
	S2_01417_0300	=input(c_S2_01417_0300	,mmddyy10.);
	S2_01418_0300	=input(c_S2_01418_0300	,mmddyy10.);
	S2_01419_0300	=input(c_S2_01419_0300	,mmddyy10.);
	S2_01435_0300	=input(c_S2_01435_0300	,mmddyy10.);
	S2_01500_0300	=input(c_S2_01500_0300	,mmddyy10.);
	S2_01501_0300	=input(c_S2_01501_0300	,mmddyy10.);
	S2_01510_0300	=input(c_S2_01510_0300	,mmddyy10.);
	S2_01520_0300	=input(c_S2_01520_0300	,mmddyy10.);
	S2_01600_0300	=input(c_S2_01600_0300	,mmddyy10.);
	S2_01601_0300	=input(c_S2_01601_0300	,mmddyy10.);
	S2_01602_0300	=input(c_S2_01602_0300	,mmddyy10.);
	S2_01603_0300	=input(c_S2_01603_0300	,mmddyy10.);
	S2_01604_0300	=input(c_S2_01604_0300	,mmddyy10.);
	S2_01605_0300	=input(c_S2_01605_0300	,mmddyy10.);
	S2_02102_0200	=input(c_S2_02102_0200	,mmddyy10.);
	S2_02103_0300	=input(c_S2_02103_0300	,mmddyy10.);

format
	fy_bgndt
	fy_enddt
	S2_00200_0300
	S2_00300_0300
	S2_00301_0300
	S2_00302_0300
	S2_00303_0300
	S2_00304_0300
	S2_00400_0300
	S2_00500_0300
	S2_00600_0300
	S2_00700_0300
	S2_00701_0300
	S2_00900_0300
	S2_00901_0300
	S2_00902_0300
	S2_00903_0300
	S2_00904_0300
	S2_00905_0300
	S2_00906_0300
	S2_01100_0300
	S2_01200_0300
	S2_01201_0300
	S2_01400_0300
	S2_01401_0300
	S2_01402_0300
	S2_01403_0300
	S2_01404_0300
	S2_01405_0300
	S2_01406_0300
	S2_01407_0300
	S2_01408_0300
	S2_01409_0300
	S2_01410_0300
	S2_01411_0300
	S2_01412_0300
	S2_01413_0300
	S2_01414_0300
	S2_01415_0300
	S2_01416_0300
	S2_01417_0300
	S2_01418_0300
	S2_01419_0300
	S2_01435_0300
	S2_01436_0300
	S2_01437_0300
	S2_01438_0300
	S2_01439_0300
	S2_01440_0300
	S2_01500_0300
	S2_01501_0300
	S2_01510_0300
	S2_01520_0300
	S2_01521_0300
	S2_01600_0300
	S2_01601_0300
	S2_01602_0300
	S2_01603_0300
	S2_01604_0300
	S2_01605_0300
	S2_01606_0300
	S2_01607_0300
	S2_01608_0300
	S2_01609_0300
	S2_02102_0200
	S2_02103_0300		date8.
	;

drop
	c_S2_00200_0300
	c_S2_00300_0300
	c_S2_00301_0300
	c_S2_00302_0300
	c_S2_00303_0300
	c_S2_00304_0300
	c_S2_00400_0300
	c_S2_00500_0300
	c_S2_00600_0300
	c_S2_00700_0300
	c_S2_00701_0300
	c_S2_00900_0300
	c_S2_00901_0300
	c_S2_00902_0300
	c_S2_00903_0300
	c_S2_00904_0300
	c_S2_00905_0300
	c_S2_00906_0300
	c_S2_01100_0300
	c_S2_01200_0300
	c_S2_01201_0300
	c_S2_01400_0300
	c_S2_01401_0300
	c_S2_01402_0300
	c_S2_01403_0300
	c_S2_01404_0300
	c_S2_01405_0300
	c_S2_01406_0300
	c_S2_01407_0300
	c_S2_01408_0300
	c_S2_01409_0300
	c_S2_01410_0300
	c_S2_01411_0300
	c_S2_01412_0300
	c_S2_01413_0300
	c_S2_01414_0300
	c_S2_01415_0300
	c_S2_01416_0300
	c_S2_01417_0300
	c_S2_01418_0300
	c_S2_01419_0300
	c_S2_01435_0300
	c_S2_01436_0300
	c_S2_01437_0300
	c_S2_01438_0300
	c_S2_01439_0300
	c_S2_01440_0300
	c_S2_01500_0300
	c_S2_01501_0300
	c_S2_01510_0300
	c_S2_01520_0300
	c_S2_01521_0300
	c_S2_01600_0300
	c_S2_01601_0300
	c_S2_01602_0300
	c_S2_01603_0300
	c_S2_01604_0300
	c_S2_01605_0300
	c_S2_01606_0300
	c_S2_01607_0300
	c_S2_01608_0300
	c_S2_01609_0300
	c_S2_02102_0200
	c_S2_02103_0300
	;

**create categorical owner variable;
     if 1<=S2_01800_0100<=2  then owner=1;	*nonprofit;
else if 3<=S2_01800_0100<=6  then owner=2;	*forprofit;
else if 7<=S2_01800_0100<=13 then owner=3;	*govt;

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

**restrict S3 to providers in S2, which only has records for irfs, ltchs, achs;
data s3nmrc;
merge s3nmrc(in=ins3) s2data(in=ingood keep=rec_num);
 by rec_num;
 if ingood and ins3;

data
     dfydt(keep=rec_num prov_id fy_bgndt ) 
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
data s3nmrc(keep=rec_num prov_id fy_bgndt 
	S3_00100_0100
	S3_00100_0200
	S3_00100_0300
	S3_00100_0400
	S3_00100_0500
	S3_00100_0600
	S3_00100_1200
	S3_00100_1300
	S3_00100_1400
	S3_00100_1500

	S3_00200_0400
	S3_00200_0500

	S3_00300_0300
	S3_00300_0400
	S3_00300_0500
	S3_00300_0600

	S3_00400_0300
	S3_00400_0500
	S3_00400_0600

	S3_00500_0100
	S3_00500_0200
	S3_00500_0300
	S3_00500_0400
	S3_00500_0500
	S3_00500_0600

	S3_00600_0300

	S3_00700_0300

	S3_00800_0300

	S3_00900_0300

	S3_01000_0300

	S3_01100_0300
	S3_01100_0500
	S3_01100_0600

	S3_01200_0100
	S3_01200_0200
	S3_01200_0300
	S3_01200_0400
	S3_01200_0500
	S3_01200_0600
	S3_01200_0700
	S3_01200_0800
	S3_01200_0900
	S3_01200_1000
	S3_01200_1100
	S3_01200_1200
	S3_01200_1300
	S3_01200_1400
	S3_01200_1500

	S3_01300_0300
	S3_01300_0400
	S3_01300_0500
	S3_01300_0600

	S3_01400_0100
	S3_01400_0200
	S3_01400_0300
	S3_01400_0400
	S3_01400_0500
	S3_01400_0600
	S3_01400_0700
	S3_01400_0800
	S3_01400_0900
	S3_01400_1000
	S3_01400_1100
	S3_01400_1200
	S3_01400_1300
	S3_01400_1400
	S3_01400_1500

	S3_01401_0100
	S3_01401_0200
	S3_01401_0300
	S3_01401_0400
	S3_01401_0500
	S3_01401_0600
	S3_01401_0700
	S3_01401_0800
	S3_01401_0900
	S3_01401_1000
	S3_01401_1100
	S3_01401_1200
	S3_01401_1300
	S3_01401_1400
	S3_01401_1500

	S3_01500_0100
	S3_01500_0200
	S3_01500_0300
	S3_01500_0400
	S3_01500_0500
	S3_01500_0600
	S3_01500_0700
	S3_01500_0800
	S3_01500_0900
	S3_01500_1000
	S3_01500_1100

	S3_01600_0100
	S3_01600_0200
	S3_01600_0300
	S3_01600_0500
	S3_01600_0600
	S3_01600_0700
	S3_01600_0800
	S3_01600_0900
	S3_01600_1000
	S3_01600_1100
	S3_01601_0100
	S3_01601_0200
	S3_01601_0300
	S3_01601_0500
	S3_01601_0600
	S3_01601_0700
	S3_01601_0800
	S3_01601_0900
	S3_01601_1000
	S3_01601_1100

	S3_01700_0100
	S3_01700_0200
	S3_01700_0600
	S3_01700_0700
	S3_01700_0800
	S3_01700_0900
	S3_01700_1000
	S3_01700_1100
	S3_01700_1500

	S3_01800_0300
	S3_01800_0700
	S3_01800_0800
	S3_01800_0900
	S3_01800_1000
	S3_01800_1100

	S3_02000_0700
	S3_02000_0800
	S3_02000_0900
	S3_02000_1000
	S3_02000_1100

	S3_02100_0700
	S3_02100_0800
	S3_02100_0900
	S3_02100_1000
	S3_02100_1100

	S3_02300_0300
	S3_02300_0700
	S3_02300_0800
	S3_02300_0900
	S3_02300_1000
	S3_02300_1100

	S3_02400_0300
	S3_02400_0700
	S3_02400_0800
	S3_02400_0900
	S3_02400_1000
	S3_02400_1100

	S3_02500_0100
	S3_02500_0700
	S3_02500_0800
	S3_02500_0900
	S3_02500_1000
	S3_02500_1100

	S3_02600_0500
	S3_02600_0501
	S3_02600_0502
	S3_02600_0600
	S3_02600_0601
	S3_02600_0602

	S3_02700_0400

	S3_02800_0600);

merge dfydt titem;
 by rec_num;
run;

/*data s3rollup;
set hospsrc.hosp&yyear.rollup;
if substr(rolabel,1,2)="S3";

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

proc transpose data=ditem
     out=titem(drop=_NAME_);
 by rec_num;
 id rolabel;
run;

data s3rollup;
merge dfydt titem;
 by rec_num;

rename 
        S3_1_C1_6	=S3_00600_0100
	S3_1_C1_7	=S3_00700_0100
	S3_1_C1_8	=S3_00800_0100
	S3_1_C1_9	=S3_00900_0100
	S3_1_C1_10	=S3_01000_0100
	S3_1_C1_21	=S3_02100_0100

	S3_1_C2_6	=S3_00600_0200
	S3_1_C2_7	=S3_00700_0200
	S3_1_C2_8	=S3_00800_0200
	S3_1_C2_9	=S3_00900_0200
	S3_1_C2_10	=S3_01000_0200
	S3_1_C2_21	=S3_02100_0200

	S3_1_C4_6 	=S3_00600_0400
	S3_1_C4_7 	=S3_00700_0400
	S3_1_C4_8 	=S3_00800_0400
	S3_1_C4_9 	=S3_00900_0400
	S3_1_C4_10	=S3_01000_0400
	S3_1_C4_18	=S3_01800_0400
	S3_1_C4_21	=S3_02100_0400
	S3_1_C4_23	=S3_02300_0400
	S3_1_C4_24	=S3_02400_0400

	S3_1_C5_6	=S3_00600_0500
	S3_1_C5_7	=S3_00700_0500
	S3_1_C5_8	=S3_00800_0500
	S3_1_C5_9	=S3_00900_0500
	S3_1_C5_10	=S3_01000_0500
	S3_1_C5_18	=S3_01800_0500
	S3_1_C5_21	=S3_02100_0500
	S3_1_C5_23	=S3_02300_0500
	S3_1_C5_24	=S3_02400_0500

	S3_1_C6_6	=S3_00600_0600
	S3_1_C6_7	=S3_00700_0600
	S3_1_C6_8	=S3_00800_0600
	S3_1_C6_9	=S3_00900_0600
	S3_1_C6_10	=S3_01000_0600
	S3_1_C6_18	=S3_01800_0600
	S3_1_C6_21	=S3_02100_0600
	S3_1_C6_23	=S3_02300_0600
	S3_1_C6_24	=S3_02400_0600
	;       
*/


data hosp&yyear._s2s3;
merge s2data(in=ingood) s3nmrc /*s3rollup*/;
 by rec_num;
 if ingood;

%MEND MGETS3;
*=======================================================================================================================================================================;

%MACRO MMERGEALLS2S3;

data hosp_s2s3_2010_2014;
merge 
      /*hosp1996_S2S3(in=in1996)
      hosp1997_S2S3(in=in1997)
      hosp1998_S2S3(in=in1998)
      hosp1999_S2S3(in=in1999)
      hosp2000_S2S3(in=in2000)
      hosp2001_S2S3(in=in2001)
      hosp2002_S2S3(in=in2002)
      hosp2003_S2S3(in=in2003)
      hosp2004_S2S3(in=in2004)
      hosp2005_S2S3(in=in2005)
      hosp2006_S2S3(in=in2006)
      hosp2007_S2S3(in=in2007)
      hosp2008_S2S3(in=in2008)
      hosp2009_S2S3(in=in2009)*/
      hosp2010_S2S3(in=in2010)
      hosp2011_S2S3(in=in2011)
      hosp2012_S2S3(in=in2012)
      hosp2013_S2S3(in=in2013)
	  hosp2014_S2S3(in=in2014);
 by rec_num;

length bgn_yr end_yr cost_yr 3.;

if in1996 then cost_yr=1996;
else if in1997 then cost_yr=1997;
else if in1998 then cost_yr=1998;
else if in1999 then cost_yr=1999;
else if in2000 then cost_yr=2000;
else if in2001 then cost_yr=2001;
else if in2002 then cost_yr=2002;
else if in2003 then cost_yr=2003;
else if in2004 then cost_yr=2004;
else if in2005 then cost_yr=2005;
else if in2006 then cost_yr=2006;
else if in2007 then cost_yr=2007;
else if in2008 then cost_yr=2008;
else if in2009 then cost_yr=2009;
else if in2010 then cost_yr=2010;
else if in2011 then cost_yr=2011;
else if in2012 then cost_yr=2012;
else if in2013 then cost_yr=2013;
else if in2014 then cost_yr=2014;

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
else if mdy(01,01,2010)<=fy_bgndt<mdy(01,01,2011) then bgn_yr=2010;
else if mdy(01,01,2011)<=fy_bgndt<mdy(01,01,2012) then bgn_yr=2011;
else if mdy(01,01,2012)<=fy_bgndt<mdy(01,01,2013) then bgn_yr=2012;
else if mdy(01,01,2013)<=fy_bgndt<mdy(01,01,2014) then bgn_yr=2013;
else if mdy(01,01,2014)<=fy_bgndt<mdy(01,01,2015) then bgn_yr=2014;

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
else if mdy(01,01,2010)<=fy_enddt<mdy(01,01,2011) then end_yr=2010;
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

    S2_00200_0400              ="Hospital: Payment System V"
    S2_00200_0500              ="Hospital: Payment System XVIII"
    S2_00200_0600              ="Hospital: Payment System XIX"
    swingbeds_snf_prov_id      ="Swing Beds-SNF-1 Provider ID"
    S2_00400_0400              ="Swing Beds-SNF-1 Pay System V"
    S2_00400_0500              ="Swing Beds-SNF-1 Pay System XVIII"
    S2_00400_0600              ="Swing Beds-SNF-1 Pay System XIX"
    swingbeds_nf_prov_id       ="Swing Beds-SNF-2 Provider ID"
    S2_00500_0400              ="Swing Beds-SNF-2 Pay System V"
    S2_00500_0600              ="Swing Beds-SNF-2 Pay System XIX"
    snf_prov_id		       ="SNF Provider ID"
    S2_00600_0400              ="SNF Pay System V"
    S2_00600_0500              ="SNF Pay System XVIII"
    S2_00600_0600              ="SNF Pay System XIX"
    nf1_prov_id                ="NF-1 Provider ID"
    S2_00700_0400              ="NF-1 Pay V"
    S2_00700_0600              ="NF-1 Pay XIX"
    nf2_prov_id                ="NF-2 Provider ID"
    S2_00701_0400              ="NF-2 Pay V"
    S2_00701_0600              ="NF-2 Pay XIX"
    prov_urban_rural           ="Main Provider Urban/Rural"
    S2_02100_0200              ="Main Provider, Rural and <= 100 beds"
    S2_02800_0100              ="SNF: all pts in managed care, no Medicare util"
    S2_02802_0200              ="SNF: Rural/Urban"
    S2_02802_0300              ="SNF: MSA or State Code"
    S2_02802_0400              ="SNF: CBSA or State Code"
    S2_02803_0200              ="SNF Staffing: Pay increase to Direct Pt Care"
    S2_02804_0200              ="SNF Recruitment: Pay increase to Direct Pt Care"
    S2_02805_0200              ="SNF Retention: Pay increase to Direct Pt Care"
    S2_02806_0200              ="SNF Training: Pay increase to Direct Pt Care"
    S2_02807_0200              ="SNF Other: Pay increase to Direct Pt Care"
    S2_02900_0100              ="Rural SNF < 50 beds"
    S2_03803_0100              ="Title 19 NF pts in Title 18 beds"
    S2_04900_0100              ="SNF A: Exemption"
    S2_04900_0200              ="SNF B: Exemption"
    S2_01800_0100              ="Main Provider: Type of Control"
    prov_type                  ="Main Provider: Type of Provider"
    S2_02600_0100              ="SCH status number of periods"
    S2_02603_0100              ="S2 Line 2603 Col 1"
    S2_02801_0100              ="SNF: Transition Period"
    S2_02801_0200              ="SNF: Wage-Index Adj Factor Pre-Oct 1"
    S2_02801_0300              ="SNF: Wage-Index Adj Factor Post-Oct 1"
    S2_02802_0100              ="SNF: Facility-specific rate"
    S2_02803_0100	       ="SNF: Staffing % Expenses to SNF Revenue"
    S2_02804_0100	       ="SNF: Recruitment % Expenses to SNF Revenue"
    S2_02805_0100	       ="SNF: Retention % Expenses to SNF Revenue"
    S2_02806_0100	       ="SNF: Training % Expenses to SNF Revenue"
    S2_02807_0100	       ="SNF: Other % Expenses to SNF Revenue"
    S2_04600_0100              ="SNF: NHCMQ Phase"
    S2_02103_0100              ="Main Provider: Geo Location U/R"
    S2_02104_0100              ="Main Provider: Geo Location U/R start"
    S2_02105_0100              ="Main Provider: Geo Location U/R end"

    S2_00200_0300              ="Main Provider: Date Certified"
    S2_00400_0300              ="Swing Beds-SNF: Date Certified"
    S2_00500_0300              ="Swing Beds-NF: Date Certified"
    S2_00600_0300              ="Hosp-Based SNF: Date Certified"
    S2_00700_0300              ="Hosp-Based NF-1: Date Certified"
    S2_00701_0300              ="Hosp-Based NF-2: Date Certified"
    prov_zipcode5              ="Main Provider Zip Code-5"    
    prov_zipcode9              ="Main Provider Zip Code-9"    

    S3_00100_0100		="Hospital Num Beds"
    S3_00100_0200		="Hospital Bed Days Available"
    S3_00100_0201		="Hospital Agg Hours (CAH)"

    S3_00100_0300		="Hospital Title 5 Days"
    S3_00100_0400		="Hospital Title 18 Days"
    S3_00100_0401		="Hospital Non-coverd Days (LTCH)"

    S3_00100_0500		="Hospital Title 19 Days"
    S3_00100_0600		="Hospital Total Days"
    S3_00100_1200		="Hospital Title 5 Discharges"
    S3_00100_1300		="Hospital Title 18 Discharges"
    S3_00100_1400		="Hospital Title 19 Discharges"
    S3_00100_1500		="Hospital Total Discharges"

    S3_01500_0100		="SNF Num Beds"
    S3_01500_0200		="SNF Bed Days Available"
    S3_01500_0300		="SNF Title 5 Days"
    S3_01500_0400		="SNF Title 18 Days"
    S3_01500_0500		="SNF Title 19 Days"
    S3_01500_0600		="SNF Total Days"
    S3_01500_0700		="SNF Total Interns/Res/FTE"
    S3_01500_0900		="SNF Net Interns/Res/FTE"
    S3_01500_1000		="SNF FTE on Payroll"
    S3_01500_1100		="SNF Nonpaid Workers"

    S3_01600_0100		="NF Num Beds"
    S3_01600_0200		="NF Bed Days Available"
    S3_01600_0300		="NF Title 5 Days"
    S3_01600_0500		="NF Title 19 Days"
    S3_01600_0600		="NF Total Days"
    S3_01600_0700		="NF Total Interns/Res/FTE"
    S3_01600_0900		="NF Net Interns/Res/FTE"
    S3_01600_1000		="NF FTE on Payroll"
    S3_01600_1100		="NF Nonpaid Workers"

    S3_01601_0100		="NF-2 Num Beds"
    S3_01601_0200		="NF-2 Bed Days Available"
    S3_01601_0500		="NF-2 Title 19 Days"
    S3_01601_0600		="NF-2 Total Days"
    S3_01601_1000		="NF-2 FTE on Payroll"
    S3_01601_1100		="NF-2 Nonpaid Workers"
    ;

format
       owner ctrlcat_.
       prov_urban_rural $urban_.
       ;

***get lagged year percent Medicare and percent Medicaid;

proc sort data=hosp_s2s3_2010_2014;
 by prov_id cost_yr;
run;

data hosp_s2s3_2010_2014;
set hosp_s2s3_2010_2014;
 by prov_id;

if sub=0 then do;
   medicaredays=S3_00100_0400;
   medicaiddays=S3_00100_0500;
   totaldays=S3_00100_0600;
   prev_medicaredays=lag(S3_00100_0400);
   prev_medicaiddays=lag(S3_00100_0500);
   prev_totaldays=lag(S3_00100_0600);
end;
else if sub=1 then do;
   medicaredays=S3_01400_0400;
   medicaiddays=S3_01400_0500;
   totaldays=S3_01400_0600;
   prev_medicaredays=lag(S3_01400_0400);
   prev_medicaiddays=lag(S3_01400_0500);
   prev_totaldays=lag(S3_01400_0600);
end;
else if sub=2 then do;
   medicaredays=S3_01401_0400;
   medicaiddays=S3_01401_0500;
   totaldays=S3_01401_0600;
   prev_medicaredays=lag(S3_01401_0400);
   prev_medicaiddays=lag(S3_01401_0500);
   prev_totaldays=lag(S3_01401_0600);
end;

if medicaredays=. then medicaredays=0;
if medicaiddays=. then medicaiddays=0;
if totaldays=. then totaldays=0;

if prev_medicaredays=. then prev_medicaredays=0;
if prev_medicaiddays=. then prev_medicaiddays=0;
if prev_totaldays=. then prev_totaldays=0;

if first.prov_id then do;
   prev_medicaredays=.;
   prev_medicaiddays=.;
   prev_totaldays=.;
end;

if totaldays > 0 then do;
   pct_medicaredays = medicaredays / totaldays;
   pct_medicaiddays = medicaiddays / totaldays;
end;

if prev_totaldays > 0 then do;
   prev_pct_medicaredays = prev_medicaredays / prev_totaldays;
   prev_pct_medicaiddays = prev_medicaiddays / prev_totaldays;
end;

if S2_01800_0100 in(1 2) then control_catg=1;				*non-profit;
else if S2_01800_0100 in(3 4 5 6) then control_catg=2;			*for-profit;
else if S2_01800_0100 in(7 8 9 10 11 12 13) then control_catg=3;	*govt;
format control_catg catcntl_.
	prov_type  
	ho_sub1_prov_type
	ho_sub2_prov_type		htype_.;

label control_catg = "Main Provider Type of Control";

proc sort data=hosp_s2s3_2010_2014 out=hospout.hosp_s2s3_2010_2014;
 by rec_num;
run;

proc contents data=hospout.hosp_s2s3_2010_2014 varnum;
run;

%MEND MMERGEALLS2S3;

*=================================================================================================================================;

/*%mgets2(yyear=1996);
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
%mgets3(yyear=2009);*/

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

