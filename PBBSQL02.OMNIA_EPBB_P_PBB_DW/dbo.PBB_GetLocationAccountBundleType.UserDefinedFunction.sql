USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetLocationAccountBundleType]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_GetLocationAccountBundleType](
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
			where FactCustomerAccount.EffectiveStartDate <= @PointInTime
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
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Phone Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Internet Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Cable Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Double Play-Phone/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Double Play-Internet/Phone'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Double Play-Internet/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Triple Play-Internet/Phone/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'None' ELSE 'Other'
				   END AS PBB_BundleType
				  ,case
					  when((SUM(PrdComponentMap.isdata) > 0
						   and SUM(PrdComponentMap.IsDataSvc) = 0)
						  or (SUM(PrdComponentMap.isphone) > 0
							 and SUM(PrdComponentMap.IsLocalPhn) = 0
							 and SUM(PrdComponentMap.IsComplexPhn) = 0)
						  or (SUM(PrdComponentMap.iscable) > 0
							 and SUM(PrdComponentMap.IsCableSvc) = 0))
						 or (SUM(PrdComponentMap.isdata) = 0
							and SUM(PrdComponentMap.IsDataSvc) = 0
							and SUM(PrdComponentMap.IsPhone) = 0
							and SUM(PrdComponentMap.IsLocalPhn) = 0
							and SUM(PrdComponentMap.IsComplexPhn) = 0
							and SUM(PrdComponentMap.IsCable) = 0
							and SUM(PrdComponentMap.IsCableSvc) = 0)
					  then 'Y' else 'N'
				   end as DoesCustomerHaveOtherServices
			 FROM FactCustomerItem
				 JOIN Accounts on FactCustomerItem.DimAccountId = Accounts.DimAccountId
				 JOIN DimServiceLocation on FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
				 JOIN DimCatalogItem ON FactCustomerItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
				 JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
			 WHERE FactCustomerItem.EffectiveStartDate <= @PointInTime
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
