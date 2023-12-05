USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DW_migration_inventory_tv_Process]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DW_migration_inventory_tv_Process](
	[tv_ObjectId] [varchar](20) NULL,
	[pf_ObjectId] [varchar](20) NULL,
	[TableOrViewName] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[OjectName] [varchar](100) NULL,
	[ObjectSchema] [varchar](100) NULL,
	[ObjectDatabaseName] [varchar](100) NULL,
	[ObjectType] [varchar](100) NULL
) ON [PRIMARY]
GO
