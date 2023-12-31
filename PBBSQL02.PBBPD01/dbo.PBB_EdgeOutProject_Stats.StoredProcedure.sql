USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_EdgeOutProject_Stats]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[PBB_EdgeOutProject_Stats]

/*(
	@ProjectEnteredDateStart as date = '10/01/2018',
	@ProjectName as varchar(50) = 'PROJECT'
)*/

AS
    BEGIN
        SELECT --[Location Zone], 
               [Project Name], 
               MarketType, 
               Serviceability, 
               COUNT(DISTINCT LocCnt) TotalLocations, 
               SUM([Active]) Active, 
               SUM([Nonpay]) NonPay, 
               SUM([Pending Order]) PendingOrder, 
               SUM([Prospect]) ProspectAccount, 
               SUM([Inactive]) InactiveAccount, 
               SUM([None]) 'None',
			   SUM(BaseMRC) BaseMRC
        FROM
        (
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
                             CreatedOn, 
                             ServiceLocationCreatedBy, 
                             case when LocationIsServicable = '' then 'No' else LocationIsServicable end as Serviceability, 
                             [Serviceable Date], 
                             ISNULL([Account-Location Status], 'None') AccountLocationStatus, 
                             MIN([Account-Service Activation Date]) [Account-Service Activation Date], 
                             [Account-Service Deactivation Date], 
                             AccountCode, 
                             AccountName, 
                             AccountEMailAddress, 
                             AccountPhoneNumber, 
                             BillingAddressPhone, 
                             SUM(pbb_LocationAccountAmount) BaseMRC
            FROM DimAddressDetails
			where [Project Name] <> ''
            GROUP BY --[Location Zone], 
                     FundType, 
                     FundTypeID, 
                     [Wirecenter Region], 
                     [Project Name], 
                     [Omnia SrvItemLocationID], 
                     [Full Address], 
                     CreatedOn, 
                     ServiceLocationCreatedBy, 
                     LocationIsServicable, 
                     [Serviceable Date], 
                     [Account-Location Status], 
                     [Account-Service Deactivation Date], 
                     AccountCode, 
                     AccountName, 
                     AccountEMailAddress, 
                     AccountPhoneNumber, 
                     BillingAddressPhone
        ) pvt_table PIVOT(COUNT([LocationID]) FOR AccountLocationStatus IN([Active], 
                                                                           [Nonpay], 
                                                                           [Pending Order], 
                                                                           [Prospect], 
                                                                           [Inactive], 
                                                                           [None])) AS rowvalue --add all account statuses
        GROUP BY --[Location Zone], 
                 [Project Name], 
                 MarketType, 
                 Serviceability;
    END;
GO
