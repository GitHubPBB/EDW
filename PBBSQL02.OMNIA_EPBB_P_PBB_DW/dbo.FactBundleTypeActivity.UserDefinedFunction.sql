USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[FactBundleTypeActivity]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[FactBundleTypeActivity](
			@StartDate DATE
		    ,@EndDate   DATE)
RETURNS @Results TABLE(
				   BeginDate            Date
				  ,EndDate              Date
				  ,DimServiceLocationId INT
				  ,DimAccountId         INT
				  ,AccountLocation      NVARCHAR(100)
				   --	DimAccountCategoryId INT,
				  ,PBB_BundleTypeStart  NVARCHAR(100)
				  ,Begin_Other          NVARCHAR(100)
				  ,PBB_BundleTypeEnd    NVARCHAR(100)
				  ,End_Other            NVARCHAR(100)
				  ,BeginCount           INT
				  ,EndCount             INT
				  ,Install              INT
				  ,Disconnect           INT
				  ,Upgrade              INT
				  ,Downgrade            INT
				  ,Sidegrade            INT
				  )
AS
	BEGIN
	    ;
	    WITH BeginSnapshot
		    AS (SELECT FactLocationAccount.*
			   FROM [dbo].[PBB_Snapshot_LocationAccountBundleType] FactLocationAccount
			   where Snapshotdate = @StartDate),
		    EndSnapshot
		    AS (SELECT FactLocationAccount.*
			   FROM dbo.[PBB_Snapshot_LocationAccountBundleType] FactLocationAccount
			   where snapshotdate = @EndDate)

		    INSERT INTO @Results
				 SELECT @StartDate BeginDate
					  ,@EndDate EndDate
					  ,ISNULL(BeginSnapshot.DimServiceLocationId,EndSnapshot.DimServiceLocationId) AS DimServiceLocationId
					  ,ISNULL(BeginSnapshot.DimAccountId,EndSnapshot.DimAccountId) AS DimAccountId
					  ,CAST(ISNULL(BeginSnapshot.DimAccountId,EndSnapshot.DimAccountId) as NVARCHAR(100)) + '|' + CAST(ISNULL(BeginSnapshot.DimServiceLocationId,EndSnapshot.DimServiceLocationId) as NVARCHAR(100)) AS AccountLocation
					   --	ISNULL(BeginSnapshot.DimAccountCategoryId, EndSnapshot.DimAccountCategoryId) AS DimAccountCategoryId,
					  ,BeginSnapshot.PBB_BundleType AS BeginBundleType
					  ,BeginSnapshot.DoesCustomerHaveOtherServices
					  ,EndSnapshot.PBB_BundleType AS EndBundleType
					  ,EndSnapshot.DoesCustomerHaveOtherServices
					  ,BeginCount = CASE
									WHEN BeginSnapshot.PBB_BundleType IS NULL
									THEN 0 ELSE 1
								 END
					  ,EndCount = CASE
								   WHEN EndSnapshot.PBB_BundleType IS NULL
								   THEN 0 ELSE 1
							    END
					  ,Install = CASE
								  WHEN (BeginSnapshot.PBB_BundleType IS NULL
									  AND EndSnapshot.PBB_BundleType IS NOT NULL) or PBB_BundleTransition.TransitionType = 'New'
								  THEN 1 ELSE 0
							   END
					  ,Disconnect = CASE
									WHEN (BeginSnapshot.PBB_BundleType IS NOT NULL
										AND EndSnapshot.PBB_BundleType IS NULL) or PBB_BundleTransition.TransitionType = 'Lost'
									THEN 1 ELSE 0
								 END
					  ,Upgrade = CASE
								  WHEN PBB_BundleTransition.TransitionType = 'Upgrade'
								  THEN 1 ELSE 0
							   END
					  ,Downgrade = CASE
								    WHEN PBB_BundleTransition.TransitionType = 'Downgrade'
								    THEN 1 ELSE 0
								END
					  ,Sidegrade = CASE
								    WHEN PBB_BundleTransition.TransitionType = 'Sidegrade'
								    THEN 1 ELSE 0
								END
				 FROM BeginSnapshot 
					 FULL OUTER JOIN EndSnapshot ON BeginSnapshot.DimAccountId = EndSnapshot.DimAccountId
											  AND BeginSnapshot.DimServiceLocationId = EndSnapshot.DimServiceLocationId
					 LEFT JOIN PBB_BundleTransition ON BeginSnapshot.PBB_BundleType = PBB_BundleTransition.BundleType
												AND EndSnapshot.PBB_BundleType = PBB_BundleTransition.ToBundleType			
	    RETURN
	END
GO
