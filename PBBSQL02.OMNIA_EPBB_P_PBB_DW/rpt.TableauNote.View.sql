USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[TableauNote]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE           VIEW [rpt].[TableauNote]
AS
--IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME  = 'TableauNote' AND TABLE_SCHEMA = 'rpt'  )
--DROP VIEW rpt.TableauNote; 

WITH CTE
AS (
	SELECT 0 AS NOTE_LINE_NO
		,'' AS NOTE_CATEGORY
		,'' AS NOTE -- add more NOTE_CATEGORY and note for dsplay in footer
	
	UNION ALL
	
	SELECT 1 AS NOTE_LINE_NO
		,'All' AS NOTE_CATEGORY
		,'© 2022 Point Broadband. All Rights Reserved.' AS NOTE 
	)
SELECT DISTINCT NOTE_CATEGORY
	,STRING_AGG(CONVERT(NVARCHAR(max), NOTE), CHAR(10)) WITHIN
GROUP (
		ORDER BY NOTE_LINE_NO
		) NOTE
FROM CTE
GROUP BY NOTE_CATEGORY
GO
