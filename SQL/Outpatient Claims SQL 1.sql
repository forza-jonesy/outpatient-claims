--==============================================================================================================================================
-- OUTPATIENT CLAIMS
-- GITHUB: CMS
-- Database: 
-- Schema: 
-- Table: Outpatient_Claim_Sample
-- Contact Simon Jones
-- DATE: 20231009
--==============================================================================================================================================

--1 General investigating tables
--2 Writing table to get oc joint to bc
--	adding combined field
--  adding comnined flag and count
--3 Create Reporting table to get countdmembers and claims
--4 Final column to get avg cost per disease combination for a provider
--5 Unpivoting benefit table to get one disease 


--==============================================================================================================================================
-- 1 General investigating tables
--==============================================================================================================================================


SELECT DESYNPUF_ID, CLM_ID, SEGMENT
, CLM_FROM_DT, CAST( CAST( CLM_FROM_DT AS char(8)) AS date ) as CLM_FROM_DT_1
, CLM_THRU_DT, CAST( CAST( CLM_THRU_DT AS char(8)) AS date ) as CLM_THRU_DT_1
, PRVDR_NUM, CLM_PMT_AMT, NCH_PRMRY_PYR_CLM_PD_AMT, AT_PHYSN_NPI
, OP_PHYSN_NPI, OT_PHYSN_NPI, NCH_BENE_BLOOD_DDCTBL_LBLTY_AM, NCH_BENE_PTB_DDCTBL_AMT, NCH_BENE_PTB_COINSRNC_AMT, 
ICD9_DGNS_CD_1, ICD9_DGNS_CD_2, ICD9_DGNS_CD_3, ICD9_DGNS_CD_4, ICD9_DGNS_CD_5, ICD9_DGNS_CD_6, ICD9_DGNS_CD_7, ICD9_DGNS_CD_8, ICD9_DGNS_CD_9, ICD9_DGNS_CD_10, ICD9_PRCDR_CD_1, 
ICD9_PRCDR_CD_2, ICD9_PRCDR_CD_3, ICD9_PRCDR_CD_4, ICD9_PRCDR_CD_5, ICD9_PRCDR_CD_6, ADMTNG_ICD9_DGNS_CD, HCPCS_CD_1, HCPCS_CD_2, HCPCS_CD_3, HCPCS_CD_4, HCPCS_CD_5, HCPCS_CD_6,
HCPCS_CD_7, HCPCS_CD_8, HCPCS_CD_9, HCPCS_CD_10, HCPCS_CD_11, HCPCS_CD_12, HCPCS_CD_13, HCPCS_CD_14, HCPCS_CD_15, HCPCS_CD_16, HCPCS_CD_17, HCPCS_CD_18, HCPCS_CD_19, HCPCS_CD_20, 
HCPCS_CD_21, HCPCS_CD_22, HCPCS_CD_23, HCPCS_CD_24, HCPCS_CD_25, HCPCS_CD_26, HCPCS_CD_27, HCPCS_CD_28, HCPCS_CD_29, HCPCS_CD_30, HCPCS_CD_31, HCPCS_CD_32, HCPCS_CD_33, HCPCS_CD_34,
HCPCS_CD_35, HCPCS_CD_36, HCPCS_CD_37, HCPCS_CD_38, HCPCS_CD_39, HCPCS_CD_40, HCPCS_CD_41, HCPCS_CD_42, HCPCS_CD_43, HCPCS_CD_44
FROM FWAE_aPP.dbo.Outpatient_Claim_Sample;


SELECT DESYNPUF_ID, CLM_ID, SEGMENT
, CLM_FROM_DT, CAST( CAST( CLM_FROM_DT AS char(8)) AS date ) as CLM_FROM_DT_1
, CLM_THRU_DT, CAST( CAST( CLM_THRU_DT AS char(8)) AS date ) as CLM_THRU_DT_1
, PRVDR_NUM, CLM_PMT_AMT, NCH_PRMRY_PYR_CLM_PD_AMT, AT_PHYSN_NPI
FROM FWAE_aPP.dbo.Outpatient_Claim_Sample where AT_PHYSN_NPI =''

--==============================================================================================================================================

select count(*) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1; -- 790,044

select count(distinct CLM_ID ) FROM FWAE_aPP.dbo.Outpatient_Claim_Sampl_1e; -- 779256
select count(distinct DESYNPUF_ID ) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1; -- 85k
select count(distinct PRVDR_NUM ) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1; -- 6370
select sum(CLM_PMT_AMT) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample; -- 223.265M
select count(*) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample where ICD9_DGNS_CD_1 =''; --5514
select * FROM FWAE_aPP.dbo.Outpatient_Claim_Sample where AT_PHYSN_NPI = '5578748707';
select count(*) FROM FWAE_aPP.dbo.Beneficiary_Summary; --114,461
select * FROM FWAE_aPP.dbo.Beneficiary_Summary where DESYNPUF_ID = '2C8BD3BDE0E89AC3';
select count(distinct DESYNPUF_ID ) FROM FWAE_aPP.dbo.Beneficiary_Summary; -- 114639, no dupes

select DESYNPUF_ID, SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA
, BENE_BIRTH_Yr, BENE_SEX_IDENT_CD, BENE_RACE_CD, SP_STATE_CODE 
FROM FWAE_aPP.dbo.Beneficiary_Summary;

select  DESYNPUF_ID, concat(SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA) AS Combine
	FROM FWAE_aPP.dbo.Beneficiary_Summary;

select sum(CLM_PMT_AMT) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1; --223265720
select count(*), sum(CLM_PMT_AMT) FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1 oc 
	inner join FWAE_aPP.dbo.Beneficiary_Summary bs on oc.DESYNPUF_ID = bs.DESYNPUF_ID ; --787509, $222433590 Vs 790044, $223265720, 

	
--==============================================================================================================================================
-- 2 writing table to get oc joint to bc with combined diseases and where NPI is not blank as its needed for analysis
--==============================================================================================================================================	
	--select count(*) from (
	SELECT 
		oc.DESYNPUF_ID, CLM_ID, Claim_Count, AT_PHYSN_NPI
		, concat(SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA) AS Combine
		, cast(SP_ALZHDMTA as int) + cast(SP_CHF as int) 		+ cast(SP_CHRNKIDN as int) + cast(SP_CNCR as int)	 + cast(SP_COPD as int)		+ cast(SP_DEPRESSN as int)
		+ cast(SP_DIABETES as int) + cast(SP_ISCHMCHT as int) 	+ cast(SP_OSTEOPRS as int) + cast(SP_RA_OA as int) 	 + cast(SP_STRKETIA as int)  as Multiple_Count
		, case when 
			( cast(SP_ALZHDMTA as int) + cast(SP_CHF as int) 		+ cast(SP_CHRNKIDN as int) + cast(SP_CNCR as int)	 + cast(SP_COPD as int)		+ cast(SP_DEPRESSN as int)
			+ cast(SP_DIABETES as int) + cast(SP_ISCHMCHT as int) 	+ cast(SP_OSTEOPRS as int) + cast(SP_RA_OA as int) 	 + cast(SP_STRKETIA as int) ) >= 3 then 'Multiple' else 'Not Mult' end as Multiple_Flag
		, CLM_PMT_AMT
		, CAST( CAST( CLM_THRU_DT AS char(8)) AS date ) as CLM_THRU_DT_1
		, BENE_BIRTH_Yr, BENE_SEX_IDENT_CD, BENE_RACE_CD, SP_STATE_CODE
		INTO FWAE_aPP.dbo.Outpatient_C_BS_Join
	FROM FWAE_aPP.dbo.Outpatient_Claim_Sample_1 oc 
		inner join FWAE_aPP.dbo.Beneficiary_Summary bs on oc.DESYNPUF_ID = bs.DESYNPUF_ID where AT_PHYSN_NPI <>'' --)	counta --770282 where npi <> ''
		order by AT_PHYSN_NPI, concat(SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA)
		--787,509 rows 

		--select * from FWAE_aPP.dbo.Outpatient_C_BS_Join where Combine = '00000001000';

--==============================================================================================================================================	
-- 3 Create Reporting table to get countdmembers and claims
-- getting cost per member per disease combination for each NPI
--==============================================================================================================================================	

	with cte_1 as (
		SELECT 
			DESYNPUF_ID, CLM_ID, AT_PHYSN_NPI, Combine as Combin
			, Claim_Count
			, CLM_PMT_AMT
			, Sum(CLM_PMT_AMT) over (partition by AT_PHYSN_NPI, Combine) as NPI_Disease_Amt
			, Sum(CLM_PMT_AMT) over (partition by AT_PHYSN_NPI) as NPI_Total_Amt
			, Sum(CLM_PMT_AMT) over (partition by Combine) as Combin_Total_Amt
		FROM FWAE_aPP.dbo.Outpatient_C_BS_Join 
		--where AT_PHYSN_NPI in  ('5578748707', '2602616992','7684092608','1308731628')
		--order by AT_PHYSN_NPI, Combine 
		)
	
	--	select count(distinct DESYNPUF_ID), Combin FROM cte_1 group by Combin
		
		, cte_2 as (
		select DESYNPUF_ID, AT_PHYSN_NPI, Combin
			, sum(Claim_Count) as Claim_Count
			, count(*) over (partition by AT_PHYSN_NPI, Combin) as CountDMembers_NPI_Disease
			, count(*) over (partition by Combin) as CountDMembers_Combin
			, 1 as NPI_Disease_Count
			, avg(NPI_Disease_Amt) as NPI_Disease_Amt
			, avg(NPI_Total_Amt) as NPI_Total_Amt 
			, avg(Combin_Total_Amt) as Combin_Total_Amt
		FROM cte_1 group by DESYNPUF_ID, AT_PHYSN_NPI, Combin
		--group by AT_PHYSN_NPI, Combine
			)
	, cte_3 as (
		select 
		AT_PHYSN_NPI
		, Combin
		, avg(NPI_Disease_Count) as NPI_Disease_Count
		, sum(Claim_Count) as Claim_Count
		, avg(CountDMembers_NPI_Disease) as CountDMembers_NPI_Disease
		, avg(CountDMembers_Combin) as CountDMembers_Combin
		, avg(Combin_Total_Amt) as Combin_Total_Amt
		, avg(NPI_Total_Amt) as NPI_Total_Amt 
		, avg(NPI_Disease_Amt) as NPI_Comb_Amt
		, round(avg(Combin_Total_Amt) /  avg(CountDMembers_Combin),0) as Cost_PM_Comb					-- Amt divided by member count-- Amt for a disease all of one NPI combination. also sum this in Tableau to get total Amt
		, round(avg(NPI_Disease_Amt) /  avg(CountDMembers_NPI_Disease),0) as Cost_PM_NPI_Comb			-- Amt divided by member count

	   FROM cte_2 group by AT_PHYSN_NPI, Combin
		)
	   select *
	   , round(avg(Cost_PM_NPI_Comb) over (partition by AT_PHYSN_NPI),0) as Avg_Cost_Per_NPI
	  from cte_3
	   where AT_PHYSN_NPI in  ('5578748707', '2602616992','7684092608','2371805120')
	   order by AT_PHYSN_NPI desc, Combin asc
	   
	   INTO FWAE_aPP.dbo.Outpatient_BS_Reporting
	    -- 544647 rows of unique npi, disease combo
		
	  -- 2371805120 expensive
	  -- 0513903103 cheap
	  -- 7625887006 zero
	   
		-- select * from FWAE_aPP.dbo.Outpatient_BS_Reporting where AT_PHYSN_NPI in ('2150853459','2861567951', '5578748707', '1308731628')
		-- select sum(npi_disease_Amt) from FWAE_aPP.dbo.Outpatient_BS_Reporting; --$206332790 - same as tableau total 

--==============================================================================================================================================
-- 4 Final column to get avg cost for a provider to treat a disease per member used for question 8
--==============================================================================================================================================

		select  *
		, round(avg(Cost_PM_NPI_Disease_Combin) over (partition by AT_PHYSN_NPI),0) as Avg_NPI_Disease_Cost_PM 
		-- this is the avg cost for a provider to treat a disease per member used for question 8. an avg of an avg.
		from FWAE_aPP.dbo.Outpatient_BS_Reporting 
		where AT_PHYSN_NPI in ('5578748707', '2602616992','7684092608','1308731628')
		
--==============================================================================================================================================
-- 5 Unpivoting benefit table to get one disease at once and showing members multiple times for multiple diseases
-- put diseases in columns and members for a complete list of all the diseases and members

--Need to pivot NPI and disease joined by member. Joined claim table on left with member table. Pivoted in tableau as another data source. This gives a filter for providers that treat a given disease with member count and paid amt
SELECT DESYNPUF_ID, SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA
, BENE_BIRTH_DT, BENE_BIRTH_Yr, BENE_DEATH_DT, BENE_SEX_IDENT_CD, BENE_RACE_CD, BENE_ESRD_IND, SP_STATE_CODE, BENE_COUNTY_CD, BENE_HI_CVRAGE_TOT_MONS, BENE_SMI_CVRAGE_TOT_MONS, BENE_HMO_CVRAGE_TOT_MONS, PLAN_CVRG_MOS_NUM
, MEDREIMB_IP, BENRES_IP, PPPYMT_IP, MEDREIMB_OP, BENRES_OP, PPPYMT_OP, MEDREIMB_CAR, BENRES_CAR, PPPYMT_CAR
FROM FWAE_aPP.dbo.Beneficiary_Summary;

--==============================================================================================================================================

	select DESYNPUF_ID, Disease_Flag, Disease
	into FWAE_aPP.dbo.Beneficiary_Summary_Unpivot
		from (
		select DESYNPUF_ID,SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA 
	FROM FWAE_aPP.dbo.Beneficiary_Summary) pvt
		unpivot(Disease_Flag FOR Disease IN (SP_ALZHDMTA, SP_CHF, SP_CHRNKIDN, SP_CNCR, SP_COPD, SP_DEPRESSN, SP_DIABETES, SP_ISCHMCHT, SP_OSTEOPRS, SP_RA_OA, SP_STRKETIA)) as unpvt
		where disease_flag = '1'
		--where DESYNPUF_ID = '0000F1EB530967F3'
--==============================================================================================================================================
--==============================================================================================================================================


--==============================================================================================================================================
-- Table checking
		
	select * from FWAE_aPP.dbo.Outpatient_BS_Reporting
	where AT_PHYSN_NPI in ('5578748707', '2602616992','7684092608','1308731628')



	
	
	