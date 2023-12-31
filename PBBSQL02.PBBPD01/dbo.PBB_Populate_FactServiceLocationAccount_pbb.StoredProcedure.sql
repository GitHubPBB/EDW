USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactServiceLocationAccount_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PBB_Populate_FactServiceLocationAccount_pbb]
as
    begin

	   set nocount on

	   truncate table [dbo].[FactServiceLocationAccount_pbb];
	   WITH LocationsWithoutAccount
		   AS (SELECT SourceId
				   ,DimServiceLocationId
			  FROM [dbo].[FactServiceLocationItem_pbb]
			  WHERE DimAccountId = 0),
		   LocationsWithAccount
		   AS (SELECT DISTINCT 
				    DimServiceLocationId
			  FROM [dbo].[FactServiceLocationItem_pbb]
			  WHERE DimAccountId != 0),
		   LocationsToRemove
		   AS (SELECT LocationsWithoutAccount.SourceId
			  FROM LocationsWithoutAccount
				  JOIN LocationsWithAccount ON LocationsWithoutAccount.DimServiceLocationId = LocationsWithAccount.DimServiceLocationId)
		   insert INTO [dbo].[FactServiceLocationAccount_pbb]
				SELECT SourceId = CONCAT([DimAccountId],' | ',[DimServiceLocationId])
					 ,[DimServiceLocationId]
					 ,[DimFMAddressId]
					 ,[DimAccountId]
					 ,[DimAccountCategoryId]
					 ,[Account_DimAgentId]
					 ,[DimMembershipId]
					 ,[pbb_DimServiceLocationAccountId]
					 ,MIN([pbb_LocationItemActivation_DimDateId]) AS pbb_LocationAccountActivation_DimDateId
					 ,MAX(ISNULL([pbb_LocationItemDeactivation_DimDateId],'2050-12-31')) AS pbb_LocationAccountDeactivation_DimDateId
					 ,SUM([pbb_LocationItemAmount]) AS pbb_LocationAccountAmount
				FROM [dbo].[FactServiceLocationItem_pbb]
					LEFT JOIN LocationsToRemove ON FactServiceLocationItem_pbb.SourceId = LocationsToRemove.SourceId
				WHERE LocationsToRemove.SourceId IS NULL
				GROUP BY [DimServiceLocationId]
					   ,[DimFMAddressId]
					   ,[DimAccountId]
					   ,[DimAccountCategoryId]
					   ,[Account_DimAgentId]
					   ,[DimMembershipId]
					   ,[pbb_DimServiceLocationAccountId]
		   --,[pbb_LocationItemActivation_DimDateId]
		   --,[pbb_LocationItemDeactivation_DimDateId]
    end
GO
