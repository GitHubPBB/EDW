USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ProductAnalysis]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





 
CREATE VIEW [dbo].[PBB_ProductAnalysis] 
AS

	SELECT *
	  FROM dbo.PBB_ProductAnalysisDetails
	;

GO
