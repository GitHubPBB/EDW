USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SMART_HOME_TOTAL_DETAILED]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE FUNCTION [dbo].[PBB_DB_SMART_HOME_TOTAL_DETAILED](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
(Select 
      FactCustomerItem.DimCustomerItemId,
	  FactCustomerItem.ItemID,
	  FactCustomerItem.ItemQuantity,
	  FactCustomerItem.ItemPrice,
	  DimAccount.AccountCode,
	  DimAccount.AccountName,
	  DimAccount.AccountStatus,
	  DimAccount.AccountPhoneNumber,
	  DimAccount.AccountEMailAddress,
	  DimAccount.BillingAddressStreetLine1,
	  replace(DimAccount.BillingAddressCity,' ','') BillingAddressCity,
	  DimAccount.BillingAddressState,
	  DimAccount.BillingAddressStateAbbreviation,
	  DimAccount.BillingAddressCountry,
	  DimAccount.BillingAddressPostalCode,
	  DimAccount.BillingAddressPhone,
	  DimAccountCategory.AccountClass,
	  DimAccountCategory.AccountGroup,
	  DimAccountCategory.AccountType,
	  DimAccountCategory.CycleNumber,
	  DimAccountCategory.AccountSegment,
	  DimCatalogItem.ComponentName,
	  DimCatalogItem.ComponentCode,
	  DimCatalogItem.ComponentClass,
      SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket, 
      DimAccountCategory_pbb.pbb_MarketSummary As 'VATN'
From FactCustomerItem
Join DimAccountCategory ON FactCustomerItem.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId    
Join DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId  
Join DimCatalogItem ON FactCustomerItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
--Join DimCatalogItem_pbb ON FactCustomerItem.DimCatalogItemId = DimCatalogItem_pbb.DimCatalogItemId And DimCatalogItem_pbb.CatalogItemIsSmartHome = 'Yes'
join PrdComponentMap cm on DimCatalogItem.ComponentCode = cm.ComponentCode and IsSmartHome = 1
Join DimAccount ON FactCustomerItem.DimAccountId = DimAccount.DimAccountId
JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
Where  DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
			And FactCustomerItem.EffectiveStartDate <= case
												  when datepart(weekday,@ReportDate) = 2
												  then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											   end
			And FactCustomerItem.EffectiveEndDate > case
											    when datepart(weekday,@ReportDate) = 2
											    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											end
			And FactCustomerItem.Deactivation_DimDateId > case
													when datepart(weekday,@ReportDate) = 2
													then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
												 end
	  --AND (SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) IN (@AccountGroup)) 
	  --AND (DimAccountCategory.AccountType IN (@AccountType))
)
GO
