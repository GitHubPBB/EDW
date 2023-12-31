USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetLocationAccountBundleType_NrcCourtesyExclude]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   FUNCTION [dbo].[PBB_GetLocationAccountBundleType_NrcCourtesyExclude](
			@PointInTime DATE)
RETURNS TABLE
AS
	RETURN
		  (

		  with Accounts as
		  (select distinct DimAccount.DimAccountId
				    ,DimAccount.AccountCode
				    ,DimAccount.AccountName
					,DimAccountCategory.AccountGroup
					,DimAccountCategory.AccountType
		  from [dbo].[PBB_FactCustomerAccount_Fixed] FactCustomerAccount
			join DimAccount on FactCustomerAccount.DimAccountId = DimAccount.DimAccountID
			join DimAccountCategory on FactCustomerAccount.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
		 WHERE /*DimAccount.AccountId  NOT IN (  SELECT AccountId AS DimAccountId  FROM DimAccount_pbb
												WHERE DimAccount_pbb.pbb_AccountDiscountNames LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
												OR  DimAccount_pbb.pbb_AccountDiscountNames LIKE '%Courtesy%' ) -- exclude test and Courtesy a/c
				  AND*/  FactCustomerAccount.EffectiveStartDate <= @PointInTime
				  AND FactCustomerAccount.EffectiveEndDate > @PointInTime
				  AND DimAccount.DimAccountId <> 0)
			 SELECT FactCustomerItem.DimServiceLocationId
				  ,ServiceLocationFullAddress
				  ,Accounts.DimAccountId
				  ,Accounts.AccountCode
				  ,Accounts.AccountName
				  ,Accounts.AccountType
				  ,Accounts.AccountGroup
				  ,CASE
					  WHEN SUM( ISNULL(PrdComponentMap.IsCableSvc , 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0
						  AND (SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) >= 1
							  or SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) >= 1)
					  THEN 'Phone Only'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0
					  THEN 'Internet Only'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0
					  THEN 'Cable Only'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0
						  AND (SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) >= 1
							  or SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) >= 1)
					  THEN 'Double Play-Phone/Cable'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) >= 1
						  AND (SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) >= 1
							  or SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) >= 1)
					  THEN 'Double Play-Internet/Phone'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0
					  THEN 'Double Play-Internet/Cable'
				  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) >= 1
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) >= 1
						  AND (SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) >= 1
							  or SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) >= 1)
					  THEN 'Triple Play-Internet/Phone/Cable'
					  WHEN SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
						  AND SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0
					  THEN 'None' ELSE 'Other'
				   END AS PBB_BundleType
				  ,case
					  when((SUM( ISNULL( PrdComponentMap.isdata, 0 ) ) > 0
						   and SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0)
						  or (SUM( ISNULL( PrdComponentMap.isphone, 0 ) ) > 0
							 and SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
							 and SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0)
						  or (SUM( ISNULL( PrdComponentMap.iscable, 0 ) ) > 0
							 and SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) = 0))
						 or (SUM( ISNULL( PrdComponentMap.isdata, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsDataSvc, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsPhone, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsLocalPhn, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsComplexPhn, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsCable, 0 ) ) = 0
							and SUM( ISNULL( PrdComponentMap.IsCableSvc, 0 ) ) = 0)
					  then 'Y' else 'N'
				   end as DoesCustomerHaveOtherServices
			 FROM FactCustomerItem
				 JOIN Accounts on FactCustomerItem.DimAccountId = Accounts.DimAccountId
				 JOIN DimServiceLocation on FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
				 JOIN DimCatalogItem ON FactCustomerItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
				 JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
			 WHERE  FactCustomerItem.SourceId NOT like '%.N' -- added to exclude NRC
				  AND FactCustomerItem.EffectiveStartDate <= @PointInTime
				  AND FactCustomerItem.EffectiveEndDate > @PointInTime
				  AND FactCustomerItem.Deactivation_DimDateId > @PointInTime
			 GROUP BY FactCustomerItem.DimServiceLocationId
				  ,ServiceLocationFullAddress
				  ,Accounts.DimAccountId
				  ,Accounts.AccountCode
				  ,Accounts.AccountName
				  ,Accounts.AccountType
				  ,Accounts.AccountGroup
		  )
GO
