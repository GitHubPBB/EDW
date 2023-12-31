USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_PBB_ServiceLocationItem]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PBB_Populate_PBB_ServiceLocationItem]
AS
    begin

	   set nocount on

	   truncate table [PBB_ServiceLocationItem]

	   insert into [PBB_ServiceLocationItem]
			SELECT distinct 
				  LocationID = SL.[LocationID]
				 ,[CRMAccountId] = [AccountBase].[AccountId]
				 ,[AccountStatus] = [CusAccount].[AccountStatusCode]
				 ,[SrvItem].ItemID
				 ,[SrvItem].[ItemStatus]
				 ,ItemAmount = [SrvItemPrice].[Amount]
				 ,[ItemActivationDate] = [SrvItem].[ActivationDate]
				 ,[ItemDeactivationDate] = CASE
										 WHEN [SrvItem].[DeactivationDate] > '12-31-2050'
										 THEN '12-31-2050' ELSE [SrvItem].[DeactivationDate]
									  END
				 ,[PriceId] = [SrvItemPrice].[PriceID]
				 ,CM.*
			FROM pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvLocation] SL
				LEFT JOIN pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvItem] AS [SrvItem] ON SL.[LocationID] = [SrvItem].[LocationID]
				LEFT JOIN PrdComponentMap CM on SrvItem.ComponentID = CM.ComponentID
				LEFT JOIN pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvItem] AS [SrvItemParent] ON [SrvItem].[ParentItemID] = [SrvItemParent].[ItemID]
				LEFT JOIN pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvService] AS [SrvService] ON [SrvItem].[ServiceID] = [SrvService].[ServiceID]
				LEFT JOIN pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvItemPrice] AS [SrvItemPrice] ON [SrvItem].[ItemID] = [SrvItemPrice].[ItemID]
																				   AND [SrvItemPrice].[BeginDate] <= GETDATE()
																				   AND ISNULL([SrvitemPrice].[EndDate],GETDATE() + 1) > GETDATE()
				LEFT JOIN pbbsql01.[OMNIA_EPBB_P_PBB_CM].[dbo].[CusAccount] AS [CusAccount] ON [SrvService].[AccountID] = [CusAccount].[AccountID]
				LEFT JOIN pbbsql01.[PBB_P_MSCRM].[dbo].[AccountBase] AS [AccountBase] ON [CusAccount].[AccountID] = [AccountBase].[chr_AccountId]
    end
GO
