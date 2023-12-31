USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[ProjectGrowthRamp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectGrowthRamp](
	[ProjectAddressType] [varchar](20) NOT NULL,
	[ProjectAgeMonths] [smallint] NOT NULL,
	[GreenGoalPct] [decimal](6, 3) NOT NULL,
	[YellowGoalPct] [decimal](6, 3) NOT NULL,
	[RedGoalPct] [decimal](6, 3) NOT NULL
) ON [PRIMARY]
GO
