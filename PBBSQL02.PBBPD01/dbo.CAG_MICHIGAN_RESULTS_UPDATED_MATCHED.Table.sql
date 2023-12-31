USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[CAG_MICHIGAN_RESULTS_UPDATED_MATCHED]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAG_MICHIGAN_RESULTS_UPDATED_MATCHED](
	[Cycle] [nvarchar](255) NULL,
	[Fund] [nvarchar](255) NULL,
	[SAC] [float] NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[Address] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Speed Tier] [float] NULL,
	[# of Units] [float] NULL,
	[Carrier Location ID] [float] NULL,
	[HUBB Location ID] [float] NULL,
	[Subscriber ID(s)] [nvarchar](255) NULL,
	[AccountCode] [char](13) NOT NULL,
	[UseLocationID] [int] NOT NULL
) ON [PRIMARY]
GO
