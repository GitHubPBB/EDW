USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FactCustomerAccount_Fixed]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_FactCustomerAccount_Fixed]
AS
	WITH Max_Rows
		AS (SELECT MAX(SourceId) AS MAX_SourceId
				,AccountID
				,EffectiveStartDate
				,EffectiveEndDate
		    FROM FactCustomerAccount
		    GROUP BY AccountID
				  ,EffectiveStartDate
				  ,EffectiveEndDate)
		SELECT FactCustomerAccount.*
		FROM FactCustomerAccount
			JOIN Max_Rows ON FactCustomerAccount.SourceId = Max_Rows.MAX_SourceId
GO
