USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DW_migration_inventory_pf]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DW_migration_inventory_pf](
	[routine_catalog] [nvarchar](128) NULL,
	[routine_Schema] [nvarchar](128) NULL,
	[routine_name] [sysname] NOT NULL,
	[routine_type] [nvarchar](20) NULL,
	[type] [char](2) NULL,
	[row_num] [bigint] NULL,
	[ObjectId] [varchar](26) NOT NULL
) ON [PRIMARY]
GO
