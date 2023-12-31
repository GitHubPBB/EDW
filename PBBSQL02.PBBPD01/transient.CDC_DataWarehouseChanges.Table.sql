USE [PBBPDW01]
GO
/****** Object:  Table [transient].[CDC_DataWarehouseChanges]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[CDC_DataWarehouseChanges](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CaptureDate] [smalldatetime] NOT NULL,
	[ProcessedDate] [smalldatetime] NULL,
	[ChangeOperation] [nvarchar](50) NOT NULL,
	[EntityTableName] [nvarchar](128) NOT NULL,
	[AliasedPrimaryTableName] [nvarchar](128) NOT NULL,
	[EntityTableBusinessKeyValue] [nvarchar](4000) NOT NULL,
	[PrimaryTableKeyValue] [nvarchar](4000) NOT NULL
) ON [PRIMARY]
GO
