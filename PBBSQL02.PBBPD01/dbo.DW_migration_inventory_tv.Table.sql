USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DW_migration_inventory_tv]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DW_migration_inventory_tv](
	[TABLE_CATALOG] [nvarchar](128) NULL,
	[TABLE_SCHEMA] [sysname] NULL,
	[TABLE_NAME] [sysname] NOT NULL,
	[TABLE_TYPE] [varchar](10) NULL,
	[row_num] [bigint] NULL,
	[ObjectId] [varchar](25) NOT NULL
) ON [PRIMARY]
GO
