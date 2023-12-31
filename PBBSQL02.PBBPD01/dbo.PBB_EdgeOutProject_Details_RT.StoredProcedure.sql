USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_EdgeOutProject_Details_RT]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE [OMNIA_EPBB_P_PBB_DW]
--GO

--/****** Object:  StoredProcedure [dbo].[PBB_EdgeOutProject_Details]    Script Date: 5/27/2021 10:57:30 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


Create PROCEDURE [dbo].[PBB_EdgeOutProject_Details_RT]
--@BillingYYYY int = '2021',
--@BillingMM int = '05'
AS
    BEGIN

        --Details
               SELECT --[Location Zone], 
                             [Project Name], 
                             [Wirecenter Region],
                             CASE
                                 WHEN [Wirecenter Region] LIKE '%Competitive%'
                                 THEN 'Competitive'
                                 ELSE 'Non-Competitive'
                             END AS MarketType, 
                             FundType, 
                             FundTypeID, 
                             [Omnia SrvItemLocationID] LocationID, 
                             [Omnia SrvItemLocationID] LocCnt, 
                             [Full Address], 
							 AddressNoPostal,
                             CreatedOn, 
                             ServiceLocationCreatedBy, 
                             case when LocationIsServicable = '' then 'No' else LocationIsServicable end as Serviceability, 
                             [Serviceable Date], 
                             ISNULL([Account-Location Status], 'None') AccountLocationStatus, 
                             MIN([Account-Service Activation Date]) [Account-Service Activation Date], 
                             [Account-Service Deactivation Date], 
                             ad.AccountCode, 
                             ad.AccountName, 
                             SUM(pbb_LocationAccountAmount) BaseMRC,
							 ((apbb.pbb_AccountDiscountPercentage * -1) / 100) discountpercentage, 
							ROUND(ad.pbb_LocationAccountAmount * ((apbb.pbb_AccountDiscountPercentage * -1) / 100), 2) discountrate, 
							pbb_LocationAccountAmount - ROUND(ad.pbb_LocationAccountAmount * ((apbb.pbb_AccountDiscountPercentage * -1) / 100), 2) net
			FROM DimAddressDetails ad
			 LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON ad.AccountCode = a.AccountCode
			 LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
			where [Project Name] <> ''
            GROUP BY --[Location Zone], 
                     FundType, 
                     FundTypeID, 
                     [Wirecenter Region], 
                     [Project Name], 
                     [Omnia SrvItemLocationID], 
                     [Full Address], 
					 AddressNoPostal,
                     CreatedOn, 
                     ServiceLocationCreatedBy, 
                     LocationIsServicable, 
                     [Serviceable Date], 
                     [Account-Location Status], 
                     [Account-Service Deactivation Date], 
                     ad.AccountCode, 
                     ad.AccountName,apbb.pbb_AccountDiscountPercentage,pbb_LocationAccountAmount
    END;
--GO


GO
