USE [PBBPDW01]
GO
/****** Object:  Table [transient].[FactServiceLocation]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[FactServiceLocation](
	[FactServiceLocationId] [int] NULL,
	[LocationID] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NULL,
	[DimMsagId] [int] NULL,
	[EffectiveStartDate] [smalldatetime] NULL,
	[EffectiveEndDate] [int] NULL
) ON [PRIMARY]
GO
