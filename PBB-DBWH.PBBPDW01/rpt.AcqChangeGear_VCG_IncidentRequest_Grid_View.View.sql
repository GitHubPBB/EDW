USE [PBBPDW01]
GO
/****** Object:  View [rpt].[AcqChangeGear_VCG_IncidentRequest_Grid_View]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [rpt].[AcqChangeGear_VCG_IncidentRequest_Grid_View]
AS 
SELECT * FROM  [PBBPACQ01].AcqChangeGear.VCG_IncidentRequest_Grid_View
WHERE MetaCurrentRecordIndicator = 1
GO
