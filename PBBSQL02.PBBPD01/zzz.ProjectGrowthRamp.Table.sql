USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[ProjectGrowthRamp]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[ProjectGrowthRamp](
	[ProjectAddressType] [varchar](20) NOT NULL,
	[ProjectAgeMonths] [smallint] NOT NULL,
	[GreenGoalPct] [decimal](6, 3) NOT NULL,
	[YellowGoalPct] [decimal](6, 3) NOT NULL,
	[RedGoalPct] [decimal](6, 3) NOT NULL
) ON [PRIMARY]
GO
