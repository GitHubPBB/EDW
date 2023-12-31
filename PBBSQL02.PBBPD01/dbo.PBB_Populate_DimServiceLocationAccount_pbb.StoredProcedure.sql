USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimServiceLocationAccount_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_Populate_DimServiceLocationAccount_pbb]
AS
    begin

	   set nocount on

	   truncate table [DimServiceLocationAccount_pbb];

	   WITH LocationAccount
		   AS (SELECT [pbb_DimAccountId]
				   ,[pbb_DimServiceLocationId]
				   ,[pbb_LocationAccountStatus]
				   ,MAX([pbb_LocationAccountOpenOrder]) AS [pbb_LocationAccountOpenOrder] --If at least 1 item on the account location is associated with an open order then 'Yes' else 'No'
				   ,[pbb_LocationOpenLeadType]
				   ,[pbb_LocationOpenOpportunity]
			  FROM DimServiceLocationItem_pbb
			  GROUP BY [pbb_DimServiceLocationId]
					,[pbb_DimAccountId]
					,[pbb_LocationAccountStatus]
					,[pbb_LocationOpenLeadType]
					,[pbb_LocationOpenOpportunity])

	   --select *from DimServiceLocationItem_pbb where pbb_DimAccountId = '0AC72D44-A0E3-4192-BA30-A877C953D7A4'
	   --select * from dimaccount where accountcode in (200361909,200358841)    
	   ,
		   LocationAccountWithStatuses
		   AS (select LocationAccount.*
				   ,LocationAccountItemStatuses = STUFF(
				    (
					   SELECT DISTINCT 
							'; ' + DimServiceLocationItem_pbb.pbb_LocationItemStatus
					   FROM DimServiceLocationItem_pbb
					   WHERE DimServiceLocationItem_pbb.[pbb_DimAccountId] = LocationAccount.[pbb_DimAccountId]
						    AND DimServiceLocationItem_pbb.[pbb_DimServiceLocationId] = LocationAccount.[pbb_DimServiceLocationId] FOR XML PATH('')
				    ),1,2,'')
			  from LocationAccount),
		   LocationAccountBundle
		   AS (SELECT [pbb_DimAccountId]
				   ,[pbb_DimServiceLocationId]
				   ,MAX([pbb_IsPhone]) AS IsPhone
				   ,MAX([pbb_IsData]) AS IsData
				   ,MAX([pbb_IsCable]) AS IsCable
			  FROM DimServiceLocationItem_pbb
			  WHERE pbb_LocationItemStatus <> 'I'
			  GROUP BY [pbb_DimServiceLocationId]
					,[pbb_DimAccountId]),
		   LocationStatusRank
		   as (SELECT pbb_DimServiceLocationAccountId = 0
				   ,[LocationAccountWithStatuses].pbb_DimServiceLocationId
				   ,SourceId = CONCAT([LocationAccountWithStatuses].[pbb_DimServiceLocationId],' | ',[LocationAccountWithStatuses].[pbb_DimAccountId])
				   ,pbb_ServiceLocationAccountStatus = CASE
												   WHEN LocationAccountItemStatuses like '%A%'
												   THEN 'Active'
												   WHEN LocationAccountItemStatuses like '%N%'
												   THEN 'Nonpay'
												   WHEN pbb_LocationAccountOpenOrder = 'Yes'
												   THEN 'Pending Order'
												   WHEN pbb_LocationOpenOpportunity = 'Yes'
												   THEN 'Opportunity'
												   WHEN pbb_LocationOpenLeadType NOT LIKE ''
												   THEN CONCAT('Lead-',pbb_LocationOpenLeadType)
												   WHEN pbb_LocationAccountStatus = 'P'
												   THEN 'Prospect'
												   WHEN LocationAccountItemStatuses IS NULL
													   AND pbb_LocationAccountStatus = 'I'
												   THEN 'Inactive' --LocationAccountStatus (locationaccountitemstatus) no items active/pbb_locationaccountstatus acct inactive
												   WHEN LocationAccountItemStatuses like '%I%'
												   THEN 'Inactive' ELSE NULL
											    END
				   ,pbb_ServiceLocationAccountStatusRank = CASE
													  WHEN LocationAccountItemStatuses like '%A%'
													  THEN 1
													  WHEN LocationAccountItemStatuses like '%N%'
													  THEN 1
													  WHEN pbb_LocationAccountOpenOrder = 'Yes'
													  THEN 2
													  WHEN pbb_LocationOpenOpportunity = 'Yes'
													  THEN 3
													  WHEN pbb_LocationOpenLeadType NOT LIKE ''
													  THEN 4
													  WHEN pbb_LocationAccountStatus = 'P'
													  THEN 4
													  WHEN LocationAccountItemStatuses IS NULL
														  AND pbb_LocationAccountStatus = 'I'
													  THEN 5 --LocationAccountStatus (locationaccountitemstatus) no items active/pbb_locationaccountstatus acct inactive
													  WHEN LocationAccountItemStatuses like '%I%'
													  THEN 5 ELSE 6
												   END
				   ,pbb_LocationAccountBundleType = CASE
												WHEN IsCable = 0
													AND IsData = 0
													AND IsPhone = 1
												THEN 'Phone Only'
												WHEN IsCable = 0
													AND IsData = 1
													AND IsPhone = 0
												THEN 'Internet Only'
												WHEN IsCable = 1
													AND IsData = 0
													AND IsPhone = 0
												THEN 'Cable Only'
												WHEN IsCable = 1
													AND IsData = 0
													AND IsPhone = 1
												THEN 'Double Play-Phone/Cable'
												WHEN IsCable = 0
													AND IsData = 1
													AND IsPhone = 1
												THEN 'Double Play-Internet/Phone'
												WHEN IsCable = 1
													AND IsData = 1
													AND IsPhone = 0
												THEN 'Double Play-Internet/Cable'
												WHEN IsCable = 1
													AND IsData = 1
													AND IsPhone = 1
												THEN 'Triple Play-Internet/Phone/Cable'
												WHEN IsCable = 0
													AND IsData = 0
													AND IsPhone = 0
												THEN 'Other' ELSE 'None'
											 END
			  FROM LocationAccountWithStatuses
				  LEFT JOIN LocationAccountBundle ON LocationAccountWithStatuses.pbb_DimAccountId = LocationAccountBundle.pbb_DimAccountId
											  AND LocationAccountWithStatuses.pbb_DimServiceLocationId = LocationAccountBundle.pbb_DimServiceLocationId)
		   insert into [dbo].[DimServiceLocationAccount_pbb]
												  (pbb_ServiceLocationAccountId
												  ,pbb_ServiceLocationAccountStatus
												  ,pbb_ServiceLocationAccountStatusRank
												  ,pbb_LocationAccountBundleType
												  )
				select dt.SourceId
					 ,dt.pbb_ServiceLocationAccountStatus
					 ,dt.pbb_ServiceLocationAccountStatusRank
					 ,dt.pbb_LocationAccountBundleType
				from
					(
					    select pbb_DimServiceLocationId
							,min(pbb_ServiceLocationAccountStatusRank) pbb_servicelocationaccountstatusrank
					    from LocationStatusRank 
					    --where pbb_DimServiceLocationId = 200183
					    group by pbb_DimServiceLocationId
					) r
					join LocationStatusRank dt on r.pbb_DimServiceLocationId = dt.pbb_DimServiceLocationId
											and r.pbb_ServiceLocationAccountStatusRank = dt.pbb_ServiceLocationAccountStatusRank
    end
GO
