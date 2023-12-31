USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FactCustomerAccount_FixedV2]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[PBB_FactCustomerAccount_FixedV2]
AS
	select [FactCustomerAccountId]
		 ,[SourceId]
		 ,[AccountID]
		 ,[DimAccountId]
		 ,[DimAccountCategoryId]
		 ,[DimAgentId]
		 ,[Activation_DimDateId]
		 ,[Deactivation_DimDateId]
		 ,[EffectiveStartDate]
		 ,[EffectiveEndDate]
	from
		(
		    select [FactCustomerAccountId]
				,[SourceId]
				,[AccountID]
				,[DimAccountId]
				,[DimAccountCategoryId]
				,[DimAgentId]
				,[Activation_DimDateId]
				,[Deactivation_DimDateId]
				,[EffectiveStartDate]
				,[EffectiveEndDate]
				,ROW_NUMBER() over(partition by AccountID
										 ,EffectiveStartDate
										 ,EffectiveEndDate
				 order by SourceID desc) as rownumber
		    FROM FactCustomerAccount
		) f
	where rownumber = 1
		 and DimAccountId <> 0

		 --	WITH Max_Rows
		 --		AS (SELECT MAX(SourceId) AS MAX_SourceId
		 --				,AccountID
		 --				,EffectiveStartDate
		 --				,EffectiveEndDate
		 --		    FROM FactCustomerAccount
		 --		    GROUP BY AccountID
		 --				  ,EffectiveStartDate
		 --				  ,EffectiveEndDate)
		 --		SELECT FactCustomerAccount.*
		 --		FROM FactCustomerAccount
		 --			JOIN Max_Rows ON FactCustomerAccount.SourceId = Max_Rows.MAX_SourceId
		 --GO
GO
