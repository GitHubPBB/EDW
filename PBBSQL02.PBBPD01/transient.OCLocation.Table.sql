USE [PBBPDW01]
GO
/****** Object:  Table [transient].[OCLocation]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[OCLocation](
	[ID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[OCOrderCaptureID] [int] NULL,
	[LocationName] [varchar](max) NULL,
	[SalesRegionID] [int] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
