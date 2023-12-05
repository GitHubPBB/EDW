USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[stage_ProjectServiceabilityDateDiff]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[stage_ProjectServiceabilityDateDiff](
	[DimProjectId] [smallint] NULL,
	[Projectname] [varchar](100) NULL,
	[TrendServiceabilityDate] [varchar](10) NULL,
	[ProjectServiceableDate] [date] NULL
) ON [PRIMARY]
GO
